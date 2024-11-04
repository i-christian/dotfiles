# Rust Project Pre-Commit Hook for Clippy Checks

This repository includes a pre-commit hook that runs Clippy checks on your Rust project before allowing commits. This ensures that your code adheres to best practices and does not have any warnings, which can help maintain code quality.

## Purpose

The purpose of this pre-commit hook is to automatically check your Rust code for Clippy warnings whenever you attempt to make a commit. If any warnings are found, the commit will be rejected, allowing you to address the issues before proceeding.

## Installation

To set up this pre-commit hook in your Rust project, follow these steps:

1. **Navigate to Your Git Repository**: Open a terminal and navigate to the root directory of your Rust project (where your `.git` folder is located).

   ```bash
   cd /path/to/your/rust/project
   ```
2. **Create the Pre-Commit Hook**: Inside the .git/hooks directory, create a file named pre-commit. You can do this with a text editor or by using the following command:
  ```
    touch .git/hooks/pre-commit
  ```

3. **Add the Script**: Open the newly created pre-commit file in your favorite text editor and paste the following script into it:

```
  #!/usr/bin/env bash

# Function to find the directory containing Cargo.toml
find_cargo_dir() {
    local dir="$1"

    # Traverse upwards in the directory structure
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/Cargo.toml" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done

    # If not found, traverse downwards from the current directory
    while IFS= read -r -d '' subdir; do
        if [[ -f "$subdir/Cargo.toml" ]]; then
            echo "$subdir"
            return
        fi
    done < <(find "$1" -type d -print0)

    echo ""
}

# Find the directory containing Cargo.toml starting from the current directory
cargo_dir=$(find_cargo_dir "$(pwd)")

if [[ -z "$cargo_dir" ]]; then
    echo "No Cargo.toml found. Commit rejected."
    exit 1
fi

cd "$cargo_dir" || { echo "Failed to change directory to $cargo_dir. Commit rejected."; exit 1; }

output=$(cargo clippy -- -D warnings 2>&1)

if [ $? -ne 0 ]; then
    echo "Clippy warnings found. Commit rejected."
    echo "$output"
    exit 1 
else
    echo "No Clippy warnings. Proceeding with commit."
fi

exit 0

```

4. **Make the Script Executable**: After saving the file, make sure to grant execute permissions to the pre-commit hook with the following command:
  ```
    chmod +x .git/hooks/pre-commit
  ```

### Usage
Once the pre-commit hook is set up, it will automatically run every time you attempt to make a commit.

- If Clippy finds any warnings in your code, the commit will be rejected, and you will see the output of the warnings in your terminal.
- If there are no warnings, the commit will proceed as usual. 

### Notes
- You may need to run `cargo clippy --fix` manually to fix any warnings before you can successfully commit changes.

- If you want to bypass this hook for a specific commit, you can use the --no-verify flag:
  ```
    git commit -m "your message" --no-verify
  ```
