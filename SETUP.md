# kvetka-tf-tg-ls — automated setup

Follow these steps exactly to install the Terraform + Terragrunt LSP plugin for Claude Code.

## Step 1: Install terraform-ls

Detect the operating system and install terraform-ls:

- **macOS**: Run `brew install hashicorp/tap/terraform-ls`
- **Linux**: Download the latest release from `https://api.releases.hashicorp.com/v1/releases/terraform-ls/latest`, extract the zip, and move the binary to `~/.local/bin/terraform-ls` with `chmod +x`
- **Windows**: Run `choco install terraform-ls`

Verify by running `terraform-ls version`.

## Step 2: Install terragrunt-ls

Detect OS and architecture, then download the pre-built binary:

- **macOS Apple Silicon**: `curl -sL https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download/terragrunt-ls_darwin_arm64.tar.gz | tar xz && mv terragrunt-ls ~/.local/bin/`
- **macOS Intel**: `curl -sL https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download/terragrunt-ls_darwin_amd64.tar.gz | tar xz && mv terragrunt-ls ~/.local/bin/`
- **Linux x86_64**: `curl -sL https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download/terragrunt-ls_linux_amd64.tar.gz | tar xz && mv terragrunt-ls ~/.local/bin/`
- **Linux ARM64**: `curl -sL https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download/terragrunt-ls_linux_arm64.tar.gz | tar xz && mv terragrunt-ls ~/.local/bin/`

Make sure `~/.local/bin` is in PATH. If the download fails (no releases yet), skip this step — the plugin hook will attempt auto-download on each session start.

If the download fails and Go is installed, build from source:
```bash
git clone https://github.com/gruntwork-io/terragrunt-ls.git
cd terragrunt-ls && go build -o ~/.local/bin/terragrunt-ls .
```

## Step 3: Add the plugin marketplace

Run this command:

```bash
claude plugin marketplace add illiakrauchanka/kvetka-tf-tg-ls
```

If it fails because the marketplace already exists, that's fine — continue.

## Step 4: Install the plugin

```bash
claude plugin install kvetka-tf-tg-ls
```

If already installed, that's fine.

## Step 5: Verify

Run `claude plugin list` and confirm `kvetka-tf-tg-ls` appears with status `enabled`.

## Step 6: Report results

Tell the user:

1. Which version of terraform-ls was installed
2. Whether terragrunt-ls was installed (and how — binary download or source build)
3. Whether the plugin was registered successfully
4. That they need to **restart Claude Code** for the LSP servers to activate
5. After restart:
   - `.tf` and `.tfvars` files get go-to-definition, diagnostics, hover, references (via terraform-ls)
   - `.hcl` files get diagnostics, hover, go-to-definition, completion, formatting (via terragrunt-ls)
