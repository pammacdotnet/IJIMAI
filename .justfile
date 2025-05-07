alias r := run
run *args:
  tt run --ppi 100 --no-use-system-fonts --font-path fonts --warnings ignore --expression 'not template()' {{args}}
  # tt run --ppi 100 --no-use-system-fonts --font-path fonts --expression 'not template()' {{args}}

alias u := update
update *args:
  tt update --ppi 100 --no-use-system-fonts --font-path fonts --warnings ignore --expression 'not template()' {{args}}
  # tt update --ppi 100 --no-use-system-fonts --font-path fonts --expression 'not template()' {{args}}
