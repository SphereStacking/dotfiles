# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based dotfiles repository for macOS (Apple Silicon) using nix-darwin and home-manager for declarative system configuration.

## Common Commands

```bash
# Apply configuration changes
sudo darwin-rebuild switch --flake ./nix#spherenoMacBook-Pro

# Validate flake without building
nix flake check ./nix --no-build

# Initial setup (new machine)
./bootstrap.sh
```

## Architecture

The configuration is split between system-level (nix-darwin) and user-level (home-manager) settings:

- **`nix/flake.nix`**: Entry point defining inputs (nixpkgs, nix-darwin, home-manager) and the darwin configuration
- **`nix/darwin.nix`**: System-wide settings, imports homebrew.nix and system.nix modules, defines system packages
- **`nix/home.nix`**: User configuration, imports zsh.nix, git.nix, starship.nix modules, manages symlinks for VSCode and Claude Code settings

### Module Organization

- `modules/homebrew.nix`: GUI applications via Homebrew casks (cleanup="zap" removes unlisted apps)
- `modules/system.nix`: macOS defaults (Dock, Finder, keyboard settings)
- `modules/zsh.nix`: Shell configuration with Sheldon plugin manager, custom `cc` function for Claude Code CLI
- `modules/git.nix`, `modules/starship.nix`: Git and prompt configuration

### Symlink Strategy

Home-manager uses `mkOutOfStoreSymlink` for VSCode and Claude Code configs, allowing direct editing of files in the dotfiles repo without rebuilding.

## Important Notes

- Target hostname is `spherenoMacBook-Pro` (used in darwin-rebuild command)
- Username is `sphere`
- Homebrew's `cleanup = "zap"` means apps not in `casks` list will be removed on rebuild
