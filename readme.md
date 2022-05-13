# Dreck [![Continuous Integration](https://github.com/sunruse/dreck/workflows/Continuous%20Integration/badge.svg)](https://github.com/sunruse/dreck/actions) [![License](https://img.shields.io/github/license/sunruse/dreck.svg)](https://github.com/sunruse/dreck/blob/master/license) [![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

> _noun_ **`INFORMAL`** rubbish; trash

A really pretty awful plugin-based build framework.

## Dependencies

- Bash.
- GNU `make`.
- Unix-like `find`.
- Unix-like `mkdir` supporting `-p`.
- Unix-like `cp`.
- Unix-like `rm` supporting `-rf`.

Realistically, any common Linux distribution should include these, or have them in their standard repositories.  On Windows, the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) can be used.

## Installation in a new project

After creating a new Git repository for your project, install Dreck as a submodule by running the following in a Bash shell at the root:

```bash
git submodule add https://github.com/sunruse/dreck submodules/dreck
```

## Running a build

It is recommended to install a plugin to run the build.

If none of these apply to your use case, run the following in a Bash shell from the root of your project:

```bash
make --file ./submodules/dreck/makefile
```

The first build will generate some ["bundled" files](./bundled) such as Git configuration which almost all projects should include.  Subsequent builds will not modify these.

## Project structure

```
|'- persistent
 '- submodules
    |'- dreck
     '- plugins
        '- *
           |'- makefile
            '- bundled
               '- **
```

### `./persistent`

This directory contains information which is used internally by Dreck.  It should be committed whenever it changes.

### `./submodules/dreck`

A Git submodule of this repository.

### `./submodules/plugins/*`

Each subdirectory should be a submodule representing a plugin which should be discovered by dreck.

### `./submodules/plugins/*/bundled/**`

Everything in this directory and its subdirectories will be copied to the root directory the first time a build is performed with this plugin is installed (e.g. `./submodules/plugins/example-plugin/bundled/a/b.c` would be copied to `./a/b.c`).  Note that if the file is then deleted, it will _not_ be recreated on the next build.  This is intended to be used for example files, IDE helper files, etc.

## Test suite

Run the following in a Bash shell at the root of this repository to run the automated test suite:

```bash
./submodules/bats-core/bin/bats ./tests/run.bash
```

This is configured to run in continuous integration as a GitHub Action.

It has additionally been configured as the default build task for Visual Studio Code, so it can be ran at any time via:

- `Terminal` > `Run Build Task...`.
- Ctrl + Shift + B (Windows/Linux).
- Cmd + Shift + B (macOS).
