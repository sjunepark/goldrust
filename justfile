# Tests are run by nextest
# --all-features is not passed since `minify-html` is a optional dependency which takes long to compile,
# and is not going to be included in local development.
# CI will run with the `--all-features` flag.

set dotenv-required := true
set dotenv-filename := ".env.example"

watch_base := "cargo watch -q -c -i 'tests/resources/**/*'"
no_capture := if env_var("TEST_LOG") == "true" { "--no-capture" } else { "" }

run bin="":
    clear
    cargo run --bin {{ bin }} -r

# Watch

watch:
    {{ watch_base }} -x "c --all-targets"

watch-test name="":
    {{ watch_base }} -s "just test {{ name }}"

watch-test-pkg pkg:
    {{ watch_base }} -s "just test-pkg {{ pkg }}"

watch-example package name:
    {{ watch_base }} -s "just example {{ package }} {{ name }}"

watch-test-integration:
    {{ watch_base }} -x "nextest run -E 'kind(test)'"

watch-bench name="":
    {{ watch_base }} -s "just bench {{ name }}"

# Individual commands

test name="":
    clear
    cargo nextest run {{ no_capture }} --all-targets {{ name }}

test-pkg pkg:
    clear
    cargo nextest run --all-targets --package {{ pkg }}

test-doc:
    clear
    cargo test --doc

check-lib-bins:
    clear
    cargo check --lib --bins

example package name:
    clear
    cargo run -p {{ package }} --example {{ name }}

bench package name="":
    clear
    cargo bench --all-features --all-targets -p {{ package }} {{ name }}

cov:
    clear
    rustup run nightly cargo llvm-cov nextest --open --lib --locked

lint:
    clear
    cargo clippy --all-targets --locked

tree crate:
    clear
    cargo tree --all-features --all-targets -i {{ crate }}

tag version:
    git tag -a v{{ version }} -m "Version {{ version }}"
