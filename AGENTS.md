# AI Agent Guidelines

## General Principles

### 1. Preserve, Don't Remove
When a statement is technically imprecise or only true under special cases, **add clarification** rather than removing or rewriting the original. The original context and intent should be preserved.

- ❌ "Rotations don't have eigenvalues" (false in 3D)
- ✅ Keep the original + add: "(In 2D this is always true. In 3D, the rotation axis is an eigenvector with eigenvalue 1.)"

- ❌ "Scalar multiplication = scaling by magnitude" (ignores negative scalars)
- ✅ Keep original + add: "If the scalar is negative, the direction is reversed (flipped by 180°)."

### 2. Keep Sentences Concise
Trim unnecessary verbosity in existing sentences, and keep any added clarifications concise too.

- ❌ "A typical full sized BF16 LLM used 16-bits (2 bytes) to store each model weight. So a n-Billion parameter sized LLM takes 2n-Billion bytes in VRAM."
- ✅ "A typical full-precision BF16 LLM uses 16 bits (2 bytes) to store each weight. So an n-billion-parameter LLM takes 2n billion bytes (≈ 2n GB) in VRAM."

- ❌ "When generating the next token, current (last generated) token's Q, K, V and previous tokens' K and V values are needed to compute the attention."
- ✅ "When generating the next token, the current token's Q, and all previous tokens' (including current) K and V values, are needed for attention."

When adding factual clarifications, keep them tight — one short sentence or a parenthetical, never a paragraph.

### 3. Proofread — Don't Rewrite
When proofreading technical notes:

- Fix hard grammar errors (subject-verb agreement, typos like "it accept" → "it accepts", "compiler" → "compile", "it's" vs "its")
- Fix syntax errors (e.g., `[i32, 5]` → `[i32; 5]` in Rust array type syntax)
- Improve wording for conciseness and clarity
- **Do not dramatically rewrite** the text or change the author's voice/style
- Keep the original note-taking style — concise, direct, informal but precise
- Fix spelling: "production" → "products", "compoased" → "composed", "diangonal" → "diagonal", "matrx" → "matrix"
- Fix missing words: "top  tokens" → "top K tokens", "a 8-bit" → "an 8-bit"
- Add periods/punctuation where sentences are incomplete

### 4. Fix Technical Inaccuracies by Adding
When a factual error is found, add the correct information alongside the original rather than replacing it:

- **Two's complement**: Clarify that MSB has weight `-2^(n-1)`, others have positive weights
- **Spectral Theorem proof**: Replace vague sketch with accurate hint (orthogonality of distinct-eigenvalue eigenvectors via subtraction) + caveat about repeated eigenvalues
- **Rank-Nullity**: Fix `dim(rank) + dim(kernel)` (rank is a number, not a space) → "rank + nullity = number of columns"
- **Float modulo**: Add that `%` works on floats too in Rust
- **IEEE 754**: Add note about NaN, Infinity, ±0
- **Overflow**: Clarify "debug builds" / "release builds" (not just "compile mode")

### 5. Mathematical Notation
When converting math notation in markdown:

- Replace backtick-wrapped inline math with `$...$` LaTeX inline math
- Replace unicode math symbols with proper LaTeX:
  - `θ` → `\theta`, `λ` → `\lambda`, `⁻¹` → `^{-1}`, `ᵀ` → `^T`
  - `Σ` → `\Sigma`, `√` → `\sqrt{}`, `π` → `\pi`
  - `min(m,n)` → `\min(m, n)`
- Use `\det()` not `Det()`, `\cos()` not `cos()`

### 6. Language & Terminology
- "a n-" → "an n-", "a 8-bit" → "an 8-bit"
- "2 vectors" → "two vectors" (consistency in informal notes)
- "datasets" → "dataset" (when singular)
- "covariant matrix" → "covariance matrix", "covariants" → "covariances"
- "rust term" → "Rust terminology" (proper capitalization)
- "it's" (possessive) → "its"
- "compile mode" → "build configuration" / "debug builds" / "release builds"

### 7. Code Examples
- Keep original code examples intact
- Only fix syntax errors within code (e.g., `[i32, 5]` → `[i32; 5]`)
- Add brief explanatory notes when the syntax is non-obvious

## File-Specific Notes

### Mathematical Notes (`.md` with math content)
- Prioritize LaTeX math notation accuracy
- Preserve all intuitive explanations and analogies
- Add dimensional/edge-case caveats (e.g., "in 3D only" for cross product)

### Programming Notes (`.md` with code)
- Fix language-specific syntax errors
- Add platform details when relevant (e.g., Windows binary extension `.exe`)
- Clarify terminology (e.g., "build configuration" vs "compile mode")

### AI/ML Notes (`.md` with technical ML content)
- Fix technical descriptions of algorithms (e.g., speculative decoding acceptance criterion)
- Add standard terminology (e.g., "online softmax" for FlashAttention)
- Clarify when statements are domain-specific (2D vs 3D)

## What NOT to Do
- Don't remove original content to "fix" inaccuracies — add clarifications instead
- Don't rewrite in a formal academic tone — preserve the notes style
- Don't change links, resources, or checked/unchecked task items
- Don't alter the document structure (headings, bullet levels, separators)
- Don't add sections or expand topics beyond fixing existing content
