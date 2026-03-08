#!/usr/bin/env bash
# Check and auto-install terraform-ls and terragrunt-ls.
# This hook runs at Claude Code session start.

set -euo pipefail

RELEASES_URL="https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download"
INSTALL_DIR="${HOME}/.local/bin"

# --- terraform-ls (.tf, .tfvars) ---
if command -v terraform-ls &>/dev/null; then
    version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    echo "terraform-ls v${version} found"
else
    if [[ "$(uname -s)" == "Darwin" ]] && command -v brew &>/dev/null; then
        brew install hashicorp/tap/terraform-ls &>/dev/null
        if command -v terraform-ls &>/dev/null; then
            version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
            echo "terraform-ls v${version} installed"
        else
            echo "terraform-ls NOT found — brew install hashicorp/tap/terraform-ls"
        fi
    else
        echo "terraform-ls NOT found — see https://github.com/hashicorp/terraform-ls/releases"
    fi
fi

# --- terragrunt-ls (.hcl) ---
if command -v terragrunt-ls &>/dev/null; then
    echo "terragrunt-ls found"
elif [[ -x "${INSTALL_DIR}/terragrunt-ls" ]]; then
    echo "terragrunt-ls found at ${INSTALL_DIR}"
else
    # Auto-download from our releases
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    arch="$(uname -m)"
    case "$arch" in
        x86_64)       arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) arch="" ;;
    esac

    if [[ -n "$arch" ]] && command -v curl &>/dev/null; then
        artifact="terragrunt-ls_${os}_${arch}.tar.gz"
        url="${RELEASES_URL}/${artifact}"
        echo "Downloading terragrunt-ls (${os}/${arch})..."
        mkdir -p "$INSTALL_DIR"
        tmp_dir=$(mktemp -d)
        if curl -fsSL "$url" -o "${tmp_dir}/${artifact}" 2>/dev/null; then
            tar xzf "${tmp_dir}/${artifact}" -C "${tmp_dir}"
            mv "${tmp_dir}/terragrunt-ls" "${INSTALL_DIR}/terragrunt-ls"
            chmod +x "${INSTALL_DIR}/terragrunt-ls"
            rm -rf "$tmp_dir"
            echo "terragrunt-ls installed to ${INSTALL_DIR}"

            # Ensure ~/.local/bin is in PATH hint
            if ! echo "$PATH" | tr ':' '\n' | grep -q "${INSTALL_DIR}"; then
                echo "Add to PATH: export PATH=\"${INSTALL_DIR}:\$PATH\""
            fi
        else
            rm -rf "$tmp_dir"
            echo "terragrunt-ls NOT found — no pre-built binary available yet"
            echo "Build from source: git clone https://github.com/gruntwork-io/terragrunt-ls && cd terragrunt-ls && go build -o terragrunt-ls ."
        fi
    else
        echo "terragrunt-ls NOT found — see https://github.com/gruntwork-io/terragrunt-ls"
    fi
fi

exit 0
