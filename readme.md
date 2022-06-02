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
 '- plugins
    '- dreck
    '- *
       |'- bundled
       |   '- **
       |'- generated
       |   '- **
       |'- rules.makefile
       |'- src
       |   '- **
       '- variables.makefile
```

### `./persistent`

This directory contains information which is used internally by Dreck.  It should be committed whenever it changes.

### `./plugins/dreck`

A Git submodule of this repository.

### `./plugins/*`

Each other subdirectory represents a plugin which should be discovered by Dreck.  Most of these should be Git submodules.

### `./plugins/*/bundled/**`

Everything in these directories and their subdirectories will be copied to the root of the project the first time a build is performed with this plugin installed (e.g. `./plugins/example-plugin/bundled/a/b.c` would be copied to `./a/b.c`).  Note that if the file is then deleted or modified, it will _not_ be replaced on the next build.  This is intended to be used for configuration files, IDE helper files, CI scripts, etc.

### `./plugins/*/rules.makefile`

Use these makefiles to add rules.

The following variables are defined (most plugins will introduce their own as well):

#### `DRECK_GENERATED_PATHS`

An read-only space-separated list of all of the files which are to be generated during the build, relative to the root of the project, space separated (e.g. `./plugins/example-plugin/generated/a/b.c`).

#### Example

Given appropriate variable manipulation (see `./plugins/*/variables.makefile`), this would make a copy of each text file in the source files as an generated file, transformed into lower case:

```makefile
./plugins/example-plugin/generated/%-in-lower-case.txt: ./%.txt
	mkdir -p $(dir $@)
	cat $< | tr A-Z a-z > $@
```

### `./plugins/*/src/**`

Everything in these directories is considered to be a source file.  Each file will be listed in `DRECK_SRC_PATHS`, relative to the root of the project, space separated (e.g. `./plugins/example-plugin/src/a/b.c` would be included in `DRECK_SRC_PATHS` as `./a/b.c`).

### `./plugins/*/variables.makefile`

Use these makefiles to add/amend variables.

The following variables are defined:

#### `DRECK_SRC_PATHS`

A read-only space-separated list of all of the source files found, relative to the root of the project, space separated (e.g. `./plugins/example-plugin/src/a/b.c`).

#### `DRECK_GENERATED_PATHS`

An append-only space-separated list of all of the files which will be generated during the build, relative to the root of the project, space separated (e.g. `./plugins/example-plugin/generated/a/b.c`).

#### Example

This defines the variables which would make a copy of each text file in the source files as a generated file, transformed into lower case:

```makefile
DRECK_GENERATED_PATHS += $(patsubst ./plugins/example-plugin/generated/%.txt, ./%-in-lower-case.txt, $(filter ./%.txt, $(DRECK_SRC_PATHS)))
```

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
