# Common Configuration Files 📝

A collection of configuration files for various tools and applications, designed to be easily shared and reused across different projects and environments.

## Repository Structure

c-projects/
├── .clang-format
├── .pre-commit-config.yaml
├── proyect.yml
└── Doxyfile
README.md
LICENSE

## Included Configuration Files

- `.clang-format`: Configuration for Clang-Format, a tool for formatting C/C++ code. This file follows a specific style guide defined by me and can be used to maintain consistent code formatting across projects.
- `.pre-commit-config.yaml`: Configuration for pre-commit, a framework for managing and maintaining multi-language pre-commit hooks. This file defines the hooks that will be run before committing code to ensure code quality and consistency. Some hooks requiere installation of additional tools (such as cppcheck, clang-format, etc.).
- `Doxyfile`: Configuration for Doxygen, a documentation generator for C++, C, and other programming languages. This file contains settings for generating documentation from source code comments, in this case specifically for C and C++ projects.
- `project.yml`: A configuration file for Unity (Ceedling) unit testing tool for C projects. This file includes settings for test frameworks, file paths, and other options to facilitate unit testing in C projects.
