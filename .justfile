# The template testing is broken, so it's not tested. However, there is a
# duplicate "template" test that is "persistent" instead of just
# "compile-only". The only source code difference is the relative paths for
# dependent files/imports.
# https://github.com/typst-community/tytanic/issues/184

export TYPST_FONT_PATHS := "fonts"


PREVIEW_DIR := env(
  'TYPST_PACKAGE_CACHE_PATH',
  env(
    'XDG_CACHE_HOME',
    env('HOME') / if os() == 'macos' { 'Library/Application Support' } else { '.cache' }
  ) / 'typst' / 'packages',
) / 'preview'

PACKAGE_NAME := shell(
  'grep "$1" typst.toml | sed -E "$2"',
  '^name',
  's/[^"]+"([^"]+)".*/\1/',
)

PACKAGE_VERSION := shell(
  'grep "$1" typst.toml | grep -o "$2"',
  '^version',
  '[0-9]\+\.[0-9]\+\.[0-9]\+',
)

PRE_COMMIT_SCRIPT := "\
#!/bin/sh
set -eu
# Run tests.
just test
# Format files.
if ! just format --check; then
  just format
  echo 'Include new formatting changes.'
  exit 1
fi
"

alias t := test
alias st := search-test
alias ut := update-test
alias f := format
alias i := install
alias un := uninstall
alias init := pre-commit

# Automatically use local binary over global one, if present. For more
# information (including used version), see Testing section in ./README.md.
tt := shell("if [ -f tt ]; then echo ./tt; else echo tt; fi")

# Run tests.
test *args: pre-commit
  {{tt}} run {{args}}

# Run tests that match given regex.
search-test *args:
  just test --expression 'regex:{{args}}'

# Update tests.
update-test *args: pre-commit
  {{tt}} update {{args}}

format action="--inplace":
  typstyle '{{action}}' ./template/paper.typ ./tests/*/test.typ
  typstyle '{{action}}' --wrap-text *.typ ./tests/*.typ

# Install the package by linking it to this repository.
install:
  mkdir -p '{{PREVIEW_DIR / PACKAGE_NAME}}'
  rm -rf '{{PREVIEW_DIR / PACKAGE_NAME / PACKAGE_VERSION}}'
  ln -s "$PWD" '{{PREVIEW_DIR / PACKAGE_NAME / PACKAGE_VERSION}}'
  @ echo
  @ echo 'Installed. To uninstall run:'
  @ echo 'just uninstall'

# Uninstall the package allowing the upstream version to be used.
uninstall:
  rm -rf '{{PREVIEW_DIR / PACKAGE_NAME / PACKAGE_VERSION}}'
  @ echo
  @ echo 'Uninstalled.'

# Initialize the pre-commit Git hook, overriding (potentially) existing one.
pre-commit:
  echo '{{PRE_COMMIT_SCRIPT}}' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
