#!/bin/bash

# =============================================================================
# Downloads configuration files from:
# https://github.com/estanislaocrivos/configuration-files
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/estanislaocrivos/configuration-files/main/c-projects/setup.sh | bash
#
# Or download and run:
#   curl -O https://raw.githubusercontent.com/estanislaocrivos/configuration-files/main/c-projects/setup.sh
#   chmod +x setup.sh
#   ./setup.sh
# =============================================================================

set -e

BASE_URL="https://raw.githubusercontent.com/estanislaocrivos/configuration-files/main/c-projects"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

download_file() {
    local file=$1
    local dest=$2

    if [ -f "$dest" ]; then
        print_warning "File exists, backing up: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    if curl -fsSL "$BASE_URL/$file" -o "$dest" 2>/dev/null; then
        print_success "Downloaded: $dest"
    else
        print_error "Failed to download: $file"
        return 1
    fi
}

echo ""
echo "Cloning Embedded C Project Configuration Setup..."
echo ""

# Root configuration files
print_status "Downloading root configuration files..."
download_file ".clang-format" ".clang-format"
download_file ".clang-tidy" ".clang-tidy"
download_file ".clangd" ".clangd"
download_file ".editorconfig" ".editorconfig"
download_file ".gitignore" ".gitignore"
download_file ".gitattributes" ".gitattributes"
download_file ".gdbinit" ".gdbinit"
download_file ".pre-commit-config.yaml" ".pre-commit-config.yaml"
download_file "openocd.cfg" "openocd.cfg"
download_file "Doxyfile" "Doxyfile"
download_file "project.yml" "project.yml"

# VSCode configuration
print_status "Downloading VSCode configuration..."
mkdir -p .vscode
download_file ".vscode/c_cpp_properties.json" ".vscode/c_cpp_properties.json"
download_file ".vscode/settings.json" ".vscode/settings.json"
download_file ".vscode/launch.json" ".vscode/launch.json"
download_file ".vscode/tasks.json" ".vscode/tasks.json"
download_file ".vscode/extensions.json" ".vscode/extensions.json"

echo ""
print_success "Configuration files downloaded successfully!"
echo ""
echo "Next steps:"
echo "  1. Review and customize the configuration files"
echo "  2. Update openocd.cfg for your target MCU"
echo "  3. Update .vscode/launch.json for your debugger"
echo "  4. Run 'pre-commit install' to enable git hooks"
echo ""
