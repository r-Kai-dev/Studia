# Podman/Docker Mounts: Bind Mounts, Volumes, and Shadowing

## Core concepts

- A **mount** attaches a filesystem (or subtree) onto an existing path (the *mountpoint*), shadowing whatever was previously visible there. `mount()` does not create paths — the mountpoint directory must already exist before mounting onto it.
- **Bind mount** (`-v host_path:container_path`): makes an *existing* host directory visible at another path. No copying — same underlying data, visible from two paths at once.
- **Anonymous volume** (`-v container_path`, no host source given): asks the engine to create *new, engine-managed storage* and mount it at that container path. This storage lives in the engine's own volume directory (e.g. `~/.local/share/containers/storage/volumes/...`), unrelated to any host project directory.
- **Mount namespaces**: the host and the container each have their own view of what's mounted where. A mount performed inside the container's namespace has zero effect on the host's namespace, and vice versa — even though both may reference overlapping paths.

## Volume "populate from image"

- When an anonymous/named volume is mounted onto a path for the first time, and that path already contains files at the *image layer* being covered, the engine copies those image files into the volume's backing storage once. This is how a `.venv` baked into an image "ends up" in a volume.

## The shadowing chain (why a stray `.venv` shows up on the host)

Given:
```
-v "$PROJ_PATH:/workspace:Z"
-v "/workspace/.venv"
```

1. `/workspace` is bind-mounted to `$PROJ_PATH` — inside the container's mount namespace, `/workspace` now *is* the host directory (the image's original `/workspace` content is shadowed/irrelevant).
2. To mount the anonymous volume at `/workspace/.venv`, the engine must ensure that path exists as a directory first. Since `/workspace` already resolves to the host dir, this `mkdir` happens **directly on the host disk** (`$PROJ_PATH/.venv`) — not in any container-side storage.
3. This creates an empty "stub" directory on the host — a real, persistent artifact, not a container concept leaking out.
4. The anonymous volume (populated from the image's original `.venv`, if any existed at that image layer) is then mounted over `/workspace/.venv`, **inside the container's namespace only**.
5. Result: host sees the empty stub (nothing else was ever mounted there in the host's namespace); container sees the volume's populated content (the stub still physically exists underneath but is shadowed/unreachable by path, like a rug over a hole in the floor).

- No "syncing" ever occurs between the two — they are separate storage locations from the very first moment, not something that starts linked and later diverges.

## Mount ordering doesn't matter

- Engines don't mount `-v` flags in CLI-argument order. They sort by path depth/specificity, always mounting parent paths (e.g. `/workspace`) before nested child paths (e.g. `/workspace/.venv`).
- This is required for correctness: a nested volume mount must be prepared *after* its parent bind mount is finalized, otherwise the parent mount would immediately clobber/discard the child mount nested inside it.
- Practical takeaway: writing `-v` flags in a different order in the command produces identical behavior.

## Practical pattern: keep image-baked venv outside the bind-mounted tree

- Build the venv at a path *not* nested under the bind-mounted project directory (e.g. `/opt/venv`), and point `PATH`/`VIRTUAL_ENV` at it. This avoids the shadowing/stub issue entirely since no mount ever needs to be nested under `/workspace`.
- Watch for: any entrypoint/activation script that assumes a project-relative venv path (e.g. `source .venv/bin/activate`) needs updating to the new location, or it will silently activate against an empty shadowed path.

## Practical pattern: mask a host-side `.venv` from the container

- To prevent a stray host `.venv` (e.g. from local IDE tooling) from being visible inside the container at `/workspace/.venv`, add an anonymous volume mount at that path:
  ```
  -v "$PROJ_PATH:/workspace:Z"
  -v "/workspace/.venv"
  ```
- This is safe and non-destructive: the host's real `.venv` is untouched on disk, just shadowed/hidden from the container's view. The container instead sees an empty directory (assuming the image no longer bakes anything at that path).
- This is a standard idiom for blanking out `node_modules`, `.venv`, `__pycache__`, build artifacts, etc. from leaking through a bind mount.
- Whether the *image* has anything baked in at that path only affects what content the container sees inside the volume — it has no bearing on whether the empty host-side stub gets created. The stub-creation step doesn't inspect image content; it just needs a directory to exist so it can mount onto it.

## `uv sync` permission error on a freshly stub-created `.venv`

- Symptom (with `--userns="keep-id:uid=1000,gid=1000"`): if host `.venv` doesn't exist before container start, `uv sync` fails with `failed to open file .venv/CACHEDIR.TAG: Permission denied`. `CACHEDIR.TAG` itself is just the normal first file `uv` writes when bootstrapping a fresh venv — not the actual issue.
- Root cause: the stub directory is `mkdir`'d by Podman's mount-setup machinery (container root identity) *before* the keep-id-mapped process starts. `keep-id` only remaps ownership of files that already exist — it doesn't chown things created fresh during setup. So the stub ends up owned by a subordinate-mapped root, not uid 1000, and the uid-1000 process can't write into it.
- **Fix: create `.venv` on the host first** (e.g. run `uv venv` locally before starting the container). Then it's owned by your real host uid 1000, no stub-creation occurs, and ownership matches the keep-id-mapped process — no error. This is why a pre-existing host `.venv` works but a freshly-stubbed one doesn't.
- Alternatives: mount with `:U` to force a chown at start; chown in an entrypoint before dropping privileges; or keep the real venv outside `/workspace` (e.g. `/opt/venv`, chowned at build time) to avoid runtime mountpoint creation entirely.
