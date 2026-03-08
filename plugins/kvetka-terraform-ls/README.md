# kvetka-terraform-ls

Claude Code plugin that integrates [HashiCorp terraform-ls](https://github.com/hashicorp/terraform-ls) language server for Terraform infrastructure-as-code projects.

## What it does

When editing `.tf` and `.tfvars` files, Claude Code gains:

- **Go to definition** — jump to resource/module/variable definitions instantly
- **Find references** — find all usages of a resource, variable, or module
- **Hover documentation** — get type info and docs for any symbol
- **Diagnostics** — catch errors immediately after editing, not 10 prompts later

Without LSP, Claude searches code using text grep — slow, imprecise, and burns tokens on wrong files. With LSP, it resolves symbols in milliseconds.

## Quick setup

Copy-paste this into Claude Code and it will do everything for you:

```
Follow the setup instructions from https://raw.githubusercontent.com/illiakrauchanka/kvetka-terraform-ls/main/SETUP.md
```

Or install manually — see below.

## Supported file types

| Extension | Language ID |
|-----------|-------------|
| `.tf` | `terraform` |
| `.tfvars` | `terraform-vars` |

> `.hcl` files (Terragrunt, Packer) are not covered by terraform-ls — only Terraform-native files are supported.

## Manual installation

### 1. Install terraform-ls

**macOS:**
```bash
brew install hashicorp/tap/terraform-ls
```

**Linux:**
```bash
# Download from https://github.com/hashicorp/terraform-ls/releases
```

**Windows:**
```bash
choco install terraform-ls
```

Verify: `terraform-ls version`

### 2. Install the plugin

In Claude Code:
```
/plugin marketplace add illiakrauchanka/kvetka-terraform-ls
/plugin install kvetka-terraform-ls
```

### 3. Restart Claude Code

The LSP activates on next session start:
```
terraform-ls v0.38.5 found
```

## How it works

```
Claude Code <-> LSP Client <-> terraform-ls (stdio) <-> Your .tf files
                                      |
                              Terraform providers
                              Module registry
                              State files
```

## Requirements

- Claude Code v2.1.0+
- terraform-ls v0.34.0+
- Terraform v1.0+ (for provider schema resolution)

## Limitations

- **No `.hcl` support** — terraform-ls handles `.tf` and `.tfvars` only ([#15785](https://github.com/anthropics/claude-code/issues/15785))
- **Provider schemas** — `terraform init` must be run in your project for full diagnostics

## Troubleshooting

**LSP not activating:**
```bash
which terraform-ls
terraform-ls serve   # should hang waiting for stdio — Ctrl+C to exit
```

**No diagnostics:**
```bash
cd your-terraform-project && terraform init
```

## License

MIT
