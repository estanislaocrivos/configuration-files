# Common Configuration Files 📜

A collection of configuration files for various tools and applications, designed to be easily shared and reused across different projects and environments.

## Repository Structure

```text
c-projects/
├── .clang-format
├── .clang-tidy
├── .clangd
├── .editorconfig
├── .gdbinit
├── .gitattributes
├── .gitignore
├── .pre-commit-config.yaml
├── .vscode/
│   ├── c_cpp_properties.json
│   ├── extensions.json
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── Doxyfile
├── openocd.cfg
└── project.yml
README.md
LICENSE
```

## Included Configuration Files

### Code Formatting

- **`.clang-format`**: Configuration for Clang-Format, a tool for formatting C/C++ code. This file follows a specific style guide and can be used to maintain consistent code formatting across projects. Key settings include Allman brace style, 4-space indentation, and 80-character line limit.

- **`.editorconfig`**: Editor-agnostic configuration that works across multiple editors (VSCode, Vim, CLion, etc.). Defines charset, line endings, indentation, and max line length for different file types. Ensures consistent formatting regardless of the editor used.

### Static Analysis

- **`.clang-tidy`**: Configuration for Clang-Tidy static analyzer. Enables checks from bugprone, cert, clang-analyzer, performance, and portability categories. Includes naming conventions for embedded C projects (snake_case functions, UPPER_CASE macros, `_t` suffix for types).

- **`.clangd`**: Configuration for the Clangd language server. Provides IDE-like features (autocompletion, diagnostics, go-to-definition) in any editor that supports LSP. Includes strict warning flags and integrates with Clang-Tidy for real-time static analysis.

### Pre-commit Hooks

- **`.pre-commit-config.yaml`**: Configuration for pre-commit, a framework for managing and maintaining multi-language pre-commit hooks. This file defines the hooks that will be run before committing code to ensure code quality and consistency. Some hooks require installation of additional tools (such as cppcheck, clang-format, etc.).

### Git Configuration

- **`.gitignore`**: Comprehensive ignore patterns for embedded C projects. Covers build artifacts (`.o`, `.elf`, `.bin`, `.hex`), IDE files (VSCode, CLion, Eclipse, Keil, IAR), analysis tools (coverage, valgrind), and OS-specific files.

- **`.gitattributes`**: Git attributes for consistent file handling. Normalizes line endings to LF, configures binary file detection, sets up diff drivers for C files, and marks vendor directories for GitHub statistics exclusion.

### Debugging

- **`.gdbinit`**: GDB configuration for embedded development. Includes custom commands for common operations:
  - `reset` / `reset_run`: Reset target
  - `flash`: Load firmware
  - `regs` / `sregs`: Show registers
  - `fault`: Analyze Cortex-M fault registers
  - `periph`: Show System Control Block
  - `ocd` / `jlink`: Connect to debug servers

- **`openocd.cfg`**: OpenOCD configuration template for various debug adapters and target MCUs. Includes configurations for ST-Link, J-Link, CMSIS-DAP, and target definitions for STM32, Nordic nRF, NXP, and other common microcontrollers.

### Documentation

- **`Doxyfile`**: Configuration for Doxygen, a documentation generator for C/C++ projects. Contains settings for generating HTML documentation from source code comments, with search functionality and syntax highlighting.

### Testing

- **`project.yml`**: Configuration file for Ceedling (Unity) unit testing framework for C projects. Includes settings for test frameworks, mocking with CMock, code coverage with gcov, and multiple report formats.

### VSCode Configuration

The `.vscode/` directory contains VSCode-specific settings:

- **`c_cpp_properties.json`**: IntelliSense configuration with multiple profiles:
  - ARM GCC (Cortex-M): For cross-compilation
  - Native GCC: For host-based testing
  - Clangd: For use with clangd extension

- **`settings.json`**: Editor settings including formatting on save, rulers, file associations, clangd arguments, and Cortex-Debug configuration.

- **`launch.json`**: Debug configurations for multiple scenarios:
  - OpenOCD (ST-Link, J-Link)
  - J-Link GDB Server
  - PyOCD
  - QEMU (for testing without hardware)
  - Native debugging for unit tests

- **`tasks.json`**: Build and utility tasks:
  - Build (Make/CMake)
  - Flash (OpenOCD/ST-Flash/J-Link)
  - Test (Ceedling)
  - Static analysis (cppcheck, clang-tidy)
  - Documentation generation

- **`extensions.json`**: Recommended extensions for embedded C development.

## Usage

### Generating compile_commands.json

Many tools (clangd, clang-tidy) require a compilation database. Generate it using one of these methods:

**With CMake:**

```bash
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# or add to CMakeLists.txt:
# set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

**With Make (using Bear):**

```bash
# Install bear first: brew install bear (macOS) or apt install bear (Linux)
bear -- make
```

**With Ceedling:**

```bash
ceedling test:all
# compile_commands.json is generated in build/
```

### Using Clang-Tidy

```bash
# Single file
clang-tidy -p build src/main.c

# All source files
clang-tidy -p build src/*.c

# With fixes applied automatically
clang-tidy -p build --fix src/*.c
```

### Using GDB with OpenOCD

```bash
# Terminal 1: Start OpenOCD
openocd -f openocd.cfg

# Terminal 2: Start GDB
arm-none-eabi-gdb -x .gdbinit build/firmware.elf

# Inside GDB, connect and flash:
(gdb) ocd
(gdb) flash
```

### Using Pre-commit

```bash
# Install pre-commit
pip install pre-commit

# Install hooks (run once per repo)
pre-commit install

# Run manually on all files
pre-commit run --all-files
```

### Copying to a New Project

```bash
# Copy all configuration files
cp -r c-projects/.* /path/to/your/project/
cp c-projects/openocd.cfg /path/to/your/project/
cp c-projects/Doxyfile /path/to/your/project/
cp c-projects/project.yml /path/to/your/project/

# Or selectively copy what you need
cp c-projects/.clang-format /path/to/your/project/
cp c-projects/.editorconfig /path/to/your/project/
```

You may also use the setup script to automate this process:

```bash
curl -fsSL https://raw.githubusercontent.com/estanislaocrivos/configuration-files/main/c-projects/setup.sh | bash
```

Or download and run:

```bash
curl -O https://raw.githubusercontent.com/estanislaocrivos/configuration-files/main/c-projects/setup.sh
chmod +x setup.sh
./setup.sh
```

## Requirements

| Tool | Purpose | Installation |
| ------ | --------- | -------------- |
| clang-format | Code formatting | `brew install llvm` |
| clang-tidy | Static analysis | `brew install llvm` |
| clangd | Language server | `brew install llvm` |
| cppcheck | Static analysis | `brew install cppcheck` |
| pre-commit | Git hooks | `pip install pre-commit` |
| doxygen | Documentation | `brew install doxygen` |
| openocd | Debug server | `brew install openocd` |
| arm-none-eabi-gdb | Debugger | `brew install --cask gcc-arm-embedded` |
| bear | Compilation DB | `brew install bear` |
| ceedling | Unit testing | `gem install ceedling` |

## License

See [LICENSE](LICENSE) file.
