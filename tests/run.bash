#!/usr/bin/env bats

@test "project setup" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/project-setup/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/project-setup/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

@test "first run" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/first-run/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/first-run/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

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
  sleep 2
  find $actual/src -type f -name "changed-*.txt" -exec touch {} +
  find $actual/submodules/plugins/*/src -type f -name "changed-*.txt" -exec touch {} +
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

@test "only changes" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/only-changes/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/only-changes/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  sleep 2
  find $actual/src -type f -name "changed-*.txt" -exec touch {} +
  find $actual/submodules/plugins/*/src -type f -name "changed-*.txt" -exec touch {} +
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

@test "only deletions" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/only-deletions/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/only-deletions/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

@test "no changes" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/no-changes/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/no-changes/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}

@test "only additions" {
  repository=$(pwd)
  temporaryDirectory=$(mktemp -d)
  expected=$temporaryDirectory/expected
  cp -r ./tests/only-additions/expected/. $expected
  mkdir -p $expected/submodules/dreck
  cp -r . $expected/submodules/dreck
  actual=$temporaryDirectory/actual
  cp -r ./tests/only-additions/input/. $actual
  mkdir -p $actual/submodules/dreck
  cp -r . $actual/submodules/dreck
  cd $actual

  make --file ./submodules/dreck/makefile

  cd $repository
  diff --brief --recursive $actual $expected
  rm -rf $temporaryDirectory
}
