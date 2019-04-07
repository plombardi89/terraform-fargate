SHELL := /usr/bin/env bash

.PHONY: fmt test plan plan-destroy output whoami

all: fmt test

fmt:
	@terraform fmt -write=true

test:
	@terraform validate

plan:
	terraform plan -out tfplan

plan-destroy:
	terraform plan -destroy -out tfplan.destroy

output:
	@terraform output -json

whoami:
	@./whoami.sh
