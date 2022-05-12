#!/usr/bin/env bats

@test "subsequent run" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/subsequent-run/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/subsequent-run/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}
