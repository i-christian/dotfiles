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

CACHE_FILE="/tmp/cargo_dir_cache"

# Function to find the directory containing Cargo.toml
find_cargo_dir() {
    local dir="$1"
    
    while IFS= read -r -d '' subdir; do
        if [[ -f "$subdir/Cargo.toml" ]]; then
            echo "$subdir"  # Return the directory containing Cargo.toml
            return
        fi
    done < <(find "$dir" -type d -print0)

    echo ""  # Return empty string if not found
}

# Try to use cached cargo_dir
if [[ -f "$CACHE_FILE" ]]; then
    cargo_dir=$(cat "$CACHE_FILE")
else
    # Find the directory containing Cargo.toml starting from the current directory
    cargo_dir=$(find_cargo_dir "$(pwd)")
    # Cache the found directory for next time
    if [[ -n "$cargo_dir" ]]; then
        echo "$cargo_dir" > "$CACHE_FILE"
    fi
fi

if [[ -z "$cargo_dir" ]]; then
    echo "No Cargo.toml found. Commit rejected."
    exit 1  # Reject the commit
fi

# Change to the directory containing Cargo.toml
cd "$cargo_dir" || { echo "Failed to change directory to $cargo_dir. Commit rejected."; exit 1; }

# Run clippy and capture the output
output=$(cargo clippy -- -D warnings 2>&1)

# Check if Clippy has produced any warnings
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
This hook uses a caching mechanism to speed up the directory search for Cargo.toml, improving performance on subsequent commits.

- You may need to run cargo clippy manually to fix any warnings before you can successfully commit changes.

- If you want to bypass this hook for a specific commit, you can use the --no-verify flag:
  ```
    git commit -m "your message" --no-verify
  ```
