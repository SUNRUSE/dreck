# dreck

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

## Running a build

It is recommended to install a plugin to run the build.

If none of these apply to your use case, run the following in a Bash shell from the root of your project:

```bash
make --file ./submodules/dreck/makefile
```

## Project structure

```
'- submodules
   |'- dreck
    '- plugins
       '- *
          |'- makefile
           '- bundled
              '- **
```

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
