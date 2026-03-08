# kvetka-terraform-ls — automated setup

Follow these steps exactly to install the Terraform LSP plugin for Claude Code.

## Step 1: Install terraform-ls binary

Detect the operating system and install terraform-ls:

- **macOS**: Run `brew install hashicorp/tap/terraform-ls`
- **Linux (Debian/Ubuntu)**: Download the latest release from `https://api.releases.hashicorp.com/v1/releases/terraform-ls/latest`, extract the zip, and move the binary to `~/.local/bin/terraform-ls` with `chmod +x`
- **Linux (other)**: Same as above
- **Windows**: Run `choco install terraform-ls`

After installation, verify by running `terraform-ls version`. If the command fails, stop and report the error.

## Step 2: Add the plugin marketplace

Run this command:

```bash
claude plugin marketplace add illiakrauchanka/kvetka-terraform-ls
```

If it fails because the marketplace already exists, that's fine — continue to the next step.

## Step 3: Install the plugin

Run this command:

```bash
claude plugin install kvetka-terraform-ls
```

If it says the plugin is already installed, that's fine.

## Step 4: Verify

Run `claude plugin list` and confirm `kvetka-terraform-ls` appears with status `enabled`.

Run `terraform-ls version` and confirm it outputs a version number.

## Step 5: Report results

Tell the user:

1. Which version of terraform-ls was installed
2. Whether the plugin was registered successfully
3. That they need to **restart Claude Code** for the LSP to activate
4. After restart, Claude Code will have go-to-definition, find-references, hover docs, and diagnostics for `.tf` and `.tfvars` files
