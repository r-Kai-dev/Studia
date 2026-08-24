# Rust Notes

## Resources
- [ ] [Docs - Official Rust Book](https://doc.rust-lang.org/book/)
- [ ] [Comprehensive Rust](https://google.github.io/comprehensive-rust/)
- [ ] [Book - Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [ ] [Programming Rust](https://www.oreilly.com/library/view/programming-rust-3rd/9781098176228/)
- [ ] [Docs - Polar DataFrame](https://docs.pola.rs/)

- - -

# Installation & Version Management
- Rust versions and the compiler versions (`rustc`) are the same thing. Examples are `stable`, `beta`, `nightly`, or `1.95.0`.
- Editions of Rust refer to sets of syntax rules. For example, in edition 2018, the async became a special keyword, while in previous editions, the word can be used as the name of any variable.
- As long as the compiler version is newer than the edition, it can compile different crates (libraries in Rust terminology) with different editions used in the same project. It simply uses a different set of syntax rules to compile each crate independently.

## `rustup`: Installer & Version Manager
- `rustup` is the tool to install rust, managing versions and associated tools.
- Install `rustup`: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Different versions of rust are called `toolchain`s.
    - Install: `rustup toolchain install <version>`
    - List: `rustup toolchain list`
    - Default globally: `rustup default <version>`
    - Set locally: navigate to dir and `rustup override set <version>`
    - Unset locally: navigate to dir and `rustup override unset`
- A `rust-toolchain.toml` should be used to specify the compiler version for readability and reproducibility.
- `cargo` and `rustc` can also specify the compiler version when compiles, but they are only effective for the current command, not for the project.

## `rustc`: Compiler
- `rustc <file-name>.rs` compiles a Rust source file into an executable binary (typically `<file-name>` on Unix, `<file-name>.exe` on Windows)

## `Cargo`: Package Manager & Build System
- `cargo new <new-dir>` creates a new directory with cargo structures.
- `cargo init` creates the same structures within an existing directory.
- `cargo check` checks if the code can be successfully compiled without actual compilation.
- `cargo build` 
    - By default compiles the code in debug mode into a binary within `/target/debug`.
    - `cargo build --release` compiles the code in release mode into a binary within `/target/release`.
    - Release builds take longer than debug builds, but the output binaries are more optimized (with full compiler optimizations and LTO).
- `cargo run` compiles then run the binary in one command, also with `debug` and `release` modes.

- - -

# Variables & Mutability
- Variables are immutable by default: `let x = 5`.
- Compile-time error if the code tried to update the value: `let x = 5; x = 6`.
- Make variable mutable: `let mut x = 5`, even then the data types cannot be mutated. Only values of the same type can be assigned.
- Shadowing is reusing the same variable name for a different variable: `let x = 5; let x = x + 1`.
- Shadowing variable is different from mutable variable.
    - Shadowing allows change of data types: `let x = 5; let x = "yes"`.
    - After shadowing, the new variable can still be immutable.
- Variables have their own scopes within `{}`. Example: `let x = 5; {let x = "y";}` — the two `x`s are unrelated and the second `x` does not shadow the first one.
- Constants can be bound to a value as: `const UPPER_CASE_LETTERS : u32 = 60 * 60 * 3`.
    - "Inlining": the usage of constants are replaced at compile time. Example: `MY_CONSTANT + 1` becomes the machine language equivalent of `500 + 1` if in the code the constant was bound to value `500`. Formally, the constant is "inlined" at compile time.
    - Constants can only be the result of limited set of operations, not a general function (with exception of `const fn`). The rule of thumb is that it should only use what's available in the source code, without a running OS or heap memory. Examples are literals, arithmetics, data structures like arrays with constants as components, etc.
    - At run-time, constants are already inlined (replaced with their literal values), so they do not occupy dedicated memory locations like variables.

- - -

# Data Types

## Type Annotations
- Rust is a statically typed language, meaning it must know the types of all variables at compile time.
- In many cases, Rust can infer what the type should be without the type annotations.
- In cases different types are possible, explicit type annotations must be added.

## Scalar Types

### Integers
- There are signed (`i`) and unsigned (`u`) integer types for each length: 8, 16, 32, 64, 128, and architecture-dependent.
- Signed variants for bit-width `n` can store values from `-2^(n-1)` to `2^(n-1)-1` inclusively.
- Unsigned variants for bit-width `n` can store values from `0` to `2^n-1` inclusively.
- Adding underscore `_` to the integer literals does not change the value so it can be used as a visual separator.
- Integer literals can be represented in different ways: Decimals, Hex (`0x`), Octal (`0o`), Binary (`0b`), Byte (`u8` only: b'A').
- Signed integers are stored using two's complement representation.
    - Explanation of [Two's Complement](https://youtu.be/4qH4unVtJkE).
    - In short, it represents an n-bit integer by assigning weight `-2^(n-1)` to the most significant bit and `2^(n-2), 2^(n-3), ..., 2^0` to the remaining bits.
- Integer Overflow
    - Default behaviors depend on build configuration (not just compile mode): 1. wrapping in release builds (optimized); 2. panic in debug builds.
    - Overflow behaviors can be controlled by methods:
        - `wrapping_*` wraps the value on overflow, cycling back to the minimum value.
        - `checked_*` returns `None` when overflow;
        - `overflowing_*` returns the value and a boolean overflow indicator;
        - `saturating_*` clamps the value to the minimum or maximum boundary.

### Floating Points
- Two types of floating-point numbers: `f32` and `f64` (default).
- All floating-point types are signed.
- [How Floating-Point Numbers are Represented](https://youtu.be/bbkcEiUjehk)
    - They follow the IEEE 754 standard: sign bit, exponent, and mantissa (significand). Notable behavior includes `NaN`, `Infinity`, and `±0`.

### Numerical Operations
- Numerical operations cannot be applied between different numeric types without explicit casting.
- `-5/3` result is `-1`
- `+`, `-`, `*`, `/` all result in the same data type as the operands.
- `%` (modulo) works on both integers and floating-point types (`f32`/`f64`), returning the remainder of division.

### Boolean Type
- Boolean types occupy one byte in memory with possible values of `true` and `false`

### Character Type
- `char` type literals are specified by the single quotations, while the string literals use double quotations.
- A `char` is 4 bytes in size and represents a Unicode scalar value (one of the ~1.1 million code points in the Unicode standard).

## Compound Types
- A compound type can group multiple values into one type.
- Two compound types: tuples and arrays.

### Tuple Type
- Tuple is a way to group values of multiple types.
- Fixed length when declared.
- Example: `let tup: (i32, f64, u8) = (500, 6.4, 1)`
- Deconstruct a tuple `let (x, y, z) = tup;`
- Access values at certain index using period: `let one = tup.1;`
- An empty tuple without any value is called a *unit* `()`.
- Expressions return unit value `()` when they don't return any other value.

### Array Type
- Array: collection of the same type values `[1, 2, 3, 4]`.
- Arrays are allocated on the stack, not heap.
- Arrays have fixed lengths when declared: `let x: [i32; 5] = [1, 2, 3, 4, 5];` (Note: the syntax uses a semicolon `;` between the type and length, not a comma).
- Set repeated values: `let x = [3; 5];` is equivalent to `let x = [3, 3, 3, 3, 3]`.
- Element access via index: `let first = a[0];`
- Rust checks at runtime whether the index is within bounds. This check is necessary because index values can be dynamic (determined at runtime). Rust panics on out-of-bounds access rather than allowing invalid memory access — a key part of Rust's "memory-safe" design.

- - -

# Functions

## Define a function
- Minimal syntax of a function: `fn <func-name> {<statements-and/or-expressions>}`
- For functions calling other functions, the order of the function defintions in the program does not matter.

## Arguments (Parameters)
- Arguments: `fn <func-name> (<arg1>: <data-type>, <arg2>: <data-type>) {}`
- Data types of arguments must be declared.

## Statement v.s. Expression v.s. Items
- Rust blocks are consist of 3 types of code: expressions, statements, and items.
- Statements are instructions that performance some action and do not return a value. Examples:
    - Creating a variable using `let`
    - Defining a function
- Expression evaluate to a resultant value. Examples:
    - Call a function or macro
    - A new scope created by curly brackets `{}`
- Items are declarations like `fn`, `struct`, `impl`. They are not values, nor part of execution order, just definitions teh compiler resolves.
- Adding a trailing `;` to an expression turns it into a statement.

## Return value
- Implicitily, the return value of a function is the value of the final expression of the function body, when no `return` is used.
- Functions can return early by using `return` keyword explicity, for example `return x;`.
- Return value type: `fn <func-name> -> <return-data-type> {}`
- Be careful not to end the returned expression with a semicolon `;`. It converts the expression into a statement, so the function no longer returns the desired result.

- - -

# Control Flow

## if expression
- Syntax: `if <condition> {arm} else if <condition> {arm} else {arm}`
- A condition must be `bool`.
- Use `match` if there are too many branches.
- The whole `if` block is an expression with no `;` at the end.
- `if` expression can be used as the right side of `let` statement: `let x = if y > 0 { 1 } else { -1 };`.
- If at least one branch of `if` evalutes to a value (is an expression), all other branches must evaluates to that same type.

## Loops
- 3 looping keywords: `loop` (a generic and customizable loop), `while` and `for`.
- `loop` syntax: `loop {}`
- `while` syntax: `while <condition> {}`
- `for` syntax: `for number in array/(i..j) {}`
- Loops are expressions.
- Only `loop` can evaluate to a meaningful value, while `for` and `while` loops evaluate to unit type `()`.
- `break` can be used to break out (stop) the innermost loop.
- `break <value>;` can be used in `loop` (not `for` or `while`) to break the loop and evaluate to that value.
- `continue;` can be used to rest of the code inside the innermost loop.
- `return` inside a loop not only break the loop, but also the function.

- - -

# Ownership

## Stack v.s. Heap
- The stack is the part of memory that stores values in "Last-In, First-Out" (LIFO) order, pushing (creating) and dropping values (data) as needed.
- The heap is the part of memory where each value is allocated into an empty location, with a pointer returned as the address.
- The stack is faster, given it's LIFO nature and because CPUs often keep stack data in cache.
- Heap memory pointers are stored on the stack.
- Data types with fixed lengths are stored on the stack, like numerics, characters, bools, tuples, and arrays.
- Data types with dynamic lengths (can change at run time) are stored on the heap, like vectors and strings.

## Ownership Rules
- Fundamental rules:
    - Each value has an owner (variable).
    - There can only be one owner at a time.
    - When the owner (variable) goes out of scope, the value will be dropped.
- `drop`: when a variable owning a value goes out of scope, the `drop` function is called to remove the value from memory.
- The `drop` function is itself an empty function that take the value's ownership via it's argument. As a result, once `drop` is called, the value goes out of scope and is dropped from memory.

## Copy v.s. Move
- Copy: when assigned to a new variable (e.g. `=` or passed as a function argument), values of types with the `Copy` trait are copied and then assigned to the new variable.
- Move: when assigned to a new variable (e.g. `=` or passed as a function argument), values of types without the `Copy` trait is `moved` to the new variable, and the value is `dropped` when that new variable goes out of scope.
- `clone` method: deep-copies a heap value on demand. Example: String type as a `clone` method. Deep cloning means not only copying the pointers in stack, but also actually make a copy of the data in heap.
- Traits and memory allocation: values on the heap cannot have the `Copy` trait, and a type can never implement both `Copy` and `Drop` at once.

## Ownership & Functions
- Passing a variable to a function's argument will move or copy the value, similar to assigning values to a new variable.
- For a variable bound to a value without the `Copy` trait (can be on stack or heap), calling a function with that variable passed as an argument makes the function take ownership of the value, with the argument variable as the value's new owner. Once the function call finishes, the value is dropped from memory since the scope of the argument variable ends.
- For a variable bound to a value with the `Copy` train (must be on stack), calling a function with that variable passed as an argument does not move the ownership of the value. Instead, a copy is made on the stack and assigned to the function's argument variable.
- Returned values from functions act exactly the same as other values: when assigned to a variable, they either move ownership to the variable or are copied and assigned to it.
