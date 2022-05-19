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
- Unix-like `cut`.
- Unix-like `echo`.

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
|'- ephemeral
|   '- intermediate
|      '- **
|   '- src
|      '- **
|'- persistent
|'- src
|   '- **
 '- submodules
    |'- dreck
     '- plugins
        '- *
           |'- bundled
           |   '- **
           |'- rules.makefile
           |'- src
           |   '- **
            '- variables.makefile
```

### `./ephemeral/intermediate/**`

This directory is for files which were generated from source files (minified, compiled, etc.) but should not appear in the final product of the build.  Makefiles of plugins which create files in this directory must append their names to `DRECK_INTERMEDIATE_PATHS` relative to `./ephemeral/intermediate`, space-separated (e.g. `./ephemeral/intermediate/a/b.c` would be included in `DRECK_INTERMEDIATE_PATHS` as `./ephemeral/intermediate/a/b.c`).

### `./ephemeral/src/**`

This directory contains the result of merging `./src/**` and `./submodules/plugins/*/src/**` (e.g. either `./src/a/b.c` or `./submodules/plugins/example-plugin/src/a/b.c` would both be copied to `./ephemeral/src/a/b.c`).  All files within are listed in `DRECK_SRC_PATHS` relative to `./ephemeral/src`, space-separated (e.g. either `./src/a/b.c` or `./submodules/plugins/example-plugin/src/a/b.c` would be included in `DRECK_SRC_PATHS` as `./ephemeral/src/a/b.c`).

### `./persistent`

This directory contains information which is used internally by Dreck.  It should be committed whenever it changes.

### `./src/**`

Everything in this directory is considered to be a source file of your project.  Each file will be copied to `./ephemeral/src` (e.g. `./src/a/b.c` will be copied to `./ephemeral/src/a/b.c`) and will be listed in `DRECK_SRC_PATHS` relative to `./src`, space separated (e.g. `./src/a/b.c` would be included in `DRECK_SRC_PATHS` as `./a/b.c`).

### `./submodules/dreck`

A Git submodule of this repository.

### `./submodules/plugins/*`

Each subdirectory should be a submodule representing a plugin which should be discovered by dreck.

### `./submodules/plugins/*/bundled/**`

Everything in this directory and its subdirectories will be copied to the root directory the first time a build is performed with this plugin is installed (e.g. `./submodules/plugins/example-plugin/bundled/a/b.c` would be copied to `./a/b.c`).  Note that if the file is then deleted, it will _not_ be recreated on the next build.  This is intended to be used for example files, IDE helper files, etc.

### `./submodules/plugins/*/rules.makefile`

Use this makefile to add rules.

The following variables are defined:

#### `DRECK_SRC_PATHS`

A read-only space-separated list of all of the source files found, relative to `./ephemeral/src` (e.g. `./ephemeral/src/a/b.c` will appear as `./a/b.c`).

#### `DRECK_INTERMEDIATE_PATHS`

A read-only  space-separated list of all of the intermediate files which will exist by the end of the build, relative to `./ephemeral/intermediate` (e.g. `./ephemeral/intermediate/a/b.c` will appear as `./a/b.c`).

#### Example

Given appropriate variable manipulation (see `./submodules/plugins/*/variables.makefile`), this would make a copy of each text file in the source files as an intermediate file, transformed into lower case:

```makefile
./ephemeral/intermediate/%-in-lower-case.txt: ./ephemeral/src/%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
```

### `./submodules/plugins/*/src/**`

Everything in this directory is considered to be a source file contributed by a plugin.  Each file will be copied to `./ephemeral/src` (e.g. `./submodules/plugins/example-plugin/src/a/b.c` will be copied to `./ephemeral/src/a/b.c`) and will be listed in `DRECK_SRC_PATHS` relative to `./submodules/plugins/*/src`, space separated (e.g. `./submodules/plugins/example-plugin/src/a/b.c` would be included in `DRECK_SRC_PATHS` as `./a/b.c`).

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

### `./submodules/plugins/*/variables.makefile`

Use this makefile to add/amend variables.

The following variables are defined:

#### `DRECK_SRC_PATHS`

A read-only space-separated list of all of the source files found, relative to `./ephemeral/src` (e.g. `./ephemeral/src/a/b.c` will appear as `./a/b.c`).

#### `DRECK_INTERMEDIATE_PATHS`

A readable and appendable space-separated list of all of the intermediate files which will exist by the end of the build, relative to `./ephemeral/intermediate` (e.g. `./ephemeral/intermediate/a/b.c` will appear as `./a/b.c`).

#### Example

This defines the variables which would make a copy of each text file in the source files as an intermediate file, transformed into lower case:

```makefile
DRECK_INTERMEDIATE_PATHS += $(patsubst ./%.txt, ./%-in-lower-case.txt, $(filter ./%.txt, $(DRECK_SRC_PATHS)))
```
