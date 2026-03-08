#!/usr/bin/env bash
# Check if terraform-ls and terragrunt-ls are installed.
# This hook runs at Claude Code session start.

set -euo pipefail

status=()

# --- terraform-ls (.tf, .tfvars) ---
if command -v terraform-ls &>/dev/null; then
    version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    status+=("terraform-ls v${version} found")
else
    # Attempt auto-install on macOS
    if [[ "$(uname -s)" == "Darwin" ]] && command -v brew &>/dev/null; then
        brew install hashicorp/tap/terraform-ls &>/dev/null
        if command -v terraform-ls &>/dev/null; then
            version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
            status+=("terraform-ls v${version} installed")
        else
            status+=("terraform-ls NOT found — brew install hashicorp/tap/terraform-ls")
        fi
    else
        status+=("terraform-ls NOT found — see https://github.com/hashicorp/terraform-ls/releases")
    fi
fi

# --- terragrunt-ls (.hcl) ---
if command -v terragrunt-ls &>/dev/null; then
    status+=("terragrunt-ls found")
else
    # Check common Go bin locations
    for dir in "$HOME/go/bin" "$HOME/.local/bin" "/usr/local/bin"; do
        if [[ -x "${dir}/terragrunt-ls" ]]; then
            status+=("terragrunt-ls found at ${dir} (add to PATH)")
            break
        fi
    done

    if [[ ${#status[@]} -lt 2 ]]; then
        status+=("terragrunt-ls NOT found — go install github.com/gruntwork-io/terragrunt-ls@latest or build from https://github.com/gruntwork-io/terragrunt-ls")
    fi
fi

# Print results
for s in "${status[@]}"; do
    echo "$s"
done

exit 0
