# kvetka-tf-tg-ls

Claude Code plugin that provides LSP code intelligence for Terraform and Terragrunt projects.

Two language servers, one plugin:

| Server | Files | Features |
|--------|-------|----------|
| [terraform-ls](https://github.com/hashicorp/terraform-ls) (HashiCorp) | `.tf`, `.tfvars` | go-to-definition, diagnostics, hover, references |
| [terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls) (Gruntwork) | `.hcl` | diagnostics, hover, go-to-definition, completion, formatting |

## Quick setup

Copy-paste this into Claude Code:

```
Follow the setup instructions from https://raw.githubusercontent.com/illiakrauchanka/kvetka-tf-tg-ls/main/SETUP.md
```

Or install manually — see below.

## What it does

Without LSP, Claude searches code using text grep — slow, imprecise, and burns tokens on wrong files. With LSP, it resolves symbols in milliseconds.

**For `.tf` files** (terraform-ls):
- Go to definition — jump to resource/module/variable definitions
- Find references — find all usages of a resource or variable
- Hover — type info and docs for any symbol
- Diagnostics — catch errors immediately after editing

**For `.hcl` files** (terragrunt-ls):
- Diagnostics — same as `terragrunt validate`, in real time
- Hover — see evaluated values of locals
- Go to definition — jump to included files
- Completion — block and attribute names
- Formatting — format terragrunt.hcl files

## Manual installation

### 1. Install the plugin

In Claude Code:
```
/plugin marketplace add illiakrauchanka/kvetka-tf-tg-ls
/plugin install kvetka-tf-tg-ls
```

### 2. Language servers

Both servers are **auto-installed** on first session start:

- **terraform-ls** — installed via Homebrew on macOS, or downloaded from HashiCorp releases on Linux
- **terragrunt-ls** — downloaded from [our pre-built releases](https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases) (built weekly from Gruntwork's latest code)

To install manually:

```bash
# terraform-ls
brew install hashicorp/tap/terraform-ls

# terragrunt-ls (pre-built binary)
curl -sL https://github.com/illiakrauchanka/kvetka-tf-tg-ls/releases/latest/download/terragrunt-ls_darwin_arm64.tar.gz | tar xz
mv terragrunt-ls ~/.local/bin/

# terragrunt-ls (from source, requires Go)
git clone https://github.com/gruntwork-io/terragrunt-ls.git
cd terragrunt-ls && go build -o ~/.local/bin/terragrunt-ls .
```

### 3. Restart Claude Code

The LSP servers activate on next session start:
```
terraform-ls v0.38.5 found
terragrunt-ls found
```

## How it works

```
                     ┌─ terraform-ls ──> .tf, .tfvars
Claude Code <-> LSP ─┤
                     └─ terragrunt-ls ─> .hcl (terragrunt)
```

## Requirements

- Claude Code v2.1.0+
- terraform-ls v0.34.0+ (auto-installed)
- terragrunt-ls (auto-installed)
- Terraform v1.0+ (for provider schema resolution in .tf files)

## Limitations

- **terragrunt-ls is early-stage** — maintained by Gruntwork, still pre-release. Some features may be incomplete
- **Provider schemas** — `terraform init` must be run for full .tf diagnostics
- **.hcl scope** — terragrunt-ls handles Terragrunt configs only, not Packer/Nomad/Consul HCL

## Troubleshooting

**LSP not activating:**
```bash
which terraform-ls && terraform-ls version
which terragrunt-ls
```

**No diagnostics for .tf:**
```bash
cd your-terraform-project && terraform init
```

**terragrunt-ls not found after install:**
```bash
# Ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"
```

## License

MIT
