#!/usr/bin/env bash
# Check if terraform-ls is installed and provide installation guidance if not.
# This hook runs at Claude Code session start.

set -euo pipefail

MINIMUM_VERSION="0.34.0"
INSTALL_URL="https://github.com/hashicorp/terraform-ls/releases"

# Check if terraform-ls is in PATH
if command -v terraform-ls &>/dev/null; then
    version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    echo "terraform-ls v${version} found"
    exit 0
fi

# Not found — attempt auto-install based on platform
os="$(uname -s)"
arch="$(uname -m)"

case "$os" in
    Darwin)
        if command -v brew &>/dev/null; then
            echo "terraform-ls not found. Installing via Homebrew..."
            brew install hashicorp/tap/terraform-ls 2>&1
            if command -v terraform-ls &>/dev/null; then
                version=$(terraform-ls version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
                echo "terraform-ls v${version} installed successfully"
                exit 0
            fi
        fi
        ;;
    Linux)
        # Try downloading binary directly
        if command -v curl &>/dev/null; then
            case "$arch" in
                x86_64) tf_arch="amd64" ;;
                aarch64|arm64) tf_arch="arm64" ;;
                *) tf_arch="" ;;
            esac

            if [ -n "$tf_arch" ]; then
                echo "terraform-ls not found. Downloading latest release..."
                latest=$(curl -s "https://api.releases.hashicorp.com/v1/releases/terraform-ls/latest" | grep -oE '"version":"[^"]+"' | head -1 | cut -d'"' -f4)
                if [ -n "$latest" ]; then
                    tmp_dir=$(mktemp -d)
                    zip_url="https://releases.hashicorp.com/terraform-ls/${latest}/terraform-ls_${latest}_linux_${tf_arch}.zip"
                    curl -sL "$zip_url" -o "${tmp_dir}/terraform-ls.zip"
                    unzip -qo "${tmp_dir}/terraform-ls.zip" -d "${tmp_dir}"
                    install_dir="${HOME}/.local/bin"
                    mkdir -p "$install_dir"
                    mv "${tmp_dir}/terraform-ls" "${install_dir}/terraform-ls"
                    chmod +x "${install_dir}/terraform-ls"
                    rm -rf "$tmp_dir"

                    if "${install_dir}/terraform-ls" version &>/dev/null; then
                        echo "terraform-ls v${latest} installed to ${install_dir}"
                        echo "Make sure ${install_dir} is in your PATH"
                        exit 0
                    fi
                fi
            fi
        fi
        ;;
esac

# If we got here, auto-install failed
cat <<EOF
[kvetka-terraform-ls] terraform-ls is not installed.

Install it manually:

  macOS:   brew install hashicorp/tap/terraform-ls
  Linux:   Download from ${INSTALL_URL}
  Windows: choco install terraform-ls

The Terraform LSP features (go-to-definition, diagnostics, hover)
will not be available until terraform-ls is installed.
EOF

exit 0
