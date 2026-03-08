# terraform-lsp

Claude Code plugin that connects [HashiCorp terraform-ls](https://github.com/hashicorp/terraform-ls) language server for Terraform/Terragrunt infrastructure-as-code projects.

## What it does

When editing `.tf` and `.tfvars` files, Claude Code gains:

- **Go to definition** — jump to resource/module/variable definitions instantly
- **Find references** — find all usages of a resource, variable, or module
- **Hover documentation** — get type info and docs for any symbol
- **Diagnostics** — catch errors immediately after editing, not 10 prompts later
- **Autocomplete context** — Claude understands your module structure, not just text patterns

Without LSP, Claude searches for code using text grep — slow, imprecise, and burns tokens on wrong files. With LSP, it resolves symbols in milliseconds.

## Supported file types

| Extension | Language ID |
|-----------|-------------|
| `.tf` | `terraform` |
| `.tfvars` | `terraform-vars` |

> **Note:** `.hcl` files (Terragrunt, Packer) are not covered by terraform-ls. Only Terraform-native files are supported.

## Installation

### 1. Install terraform-ls

The language server binary must be available in your `PATH`.

**macOS (Homebrew):**
```bash
brew install hashicorp/tap/terraform-ls
```

**Linux (binary):**
```bash
# Download latest from https://github.com/hashicorp/terraform-ls/releases
# Or use the plugin's auto-install (attempts download on first session start)
```

**Windows:**
```bash
choco install terraform-ls
```

Verify:
```bash
terraform-ls version
```

### 2. Install the plugin

**Option A — From GitHub marketplace (recommended):**
```
/plugin marketplace add 01tech/claude-code-terraform-lsp
/plugin install terraform-lsp
```

**Option B — Local install for development:**
```bash
claude --plugin-dir /path/to/claude-code-terraform-lsp
```

### 3. Restart Claude Code

The LSP server activates on the next session start. You'll see a confirmation in the session hook output:

```
terraform-ls v0.36.4 found
```

## How it works

```
Claude Code ←→ LSP Client ←→ terraform-ls (stdio) ←→ Your .tf files
                                    ↓
                            Terraform providers
                            Module registry
                            State files
```

1. **Session start**: Hook script checks if `terraform-ls` is installed (auto-installs via Homebrew on macOS if missing)
2. **File open**: When Claude reads/edits a `.tf` or `.tfvars` file, the LSP server activates
3. **Code intelligence**: Claude uses the `LSP` tool for go-to-definition, diagnostics, references, and hover — instead of grep

## Configuration

The plugin uses sensible defaults. terraform-ls initialization options:

```json
{
  "experimentalFeatures": {
    "prefillRequiredFields": true,
    "validateOnSave": true
  }
}
```

To customize, edit `.lsp.json` in the plugin directory.

## Requirements

- Claude Code v2.1.0+
- terraform-ls v0.34.0+ (v0.36+ recommended)
- Terraform v1.0+ (for provider schema resolution)

## Limitations

- **No `.hcl` support**: terraform-ls only handles Terraform files (`.tf`, `.tfvars`). Terragrunt `.hcl` files, Packer `.pkr.hcl`, and Terraform Stacks (`.tfstack.hcl`) are not supported due to Claude Code's extension matching ([#15785](https://github.com/anthropics/claude-code/issues/15785))
- **Provider schemas**: terraform-ls needs `terraform init` to have been run in the project for full provider completion/diagnostics
- **Large monorepos**: First indexing may take a few seconds on repos with many modules

## Troubleshooting

**LSP not activating:**
```bash
# Check if terraform-ls is in PATH
which terraform-ls

# Test it manually
terraform-ls serve
# Should hang waiting for stdio input — Ctrl+C to exit
```

**No diagnostics/completions:**
```bash
# Make sure terraform init has been run in your project
cd your-terraform-project
terraform init
```

**Check Claude Code LSP status:**
In Claude Code, the LSP tool should appear in your available tools. If not, restart the session.

## License

MIT
