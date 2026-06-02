.PHONY: install lint mock mock-gate mock-core mock-all test-mock test-local test-html test-ci clean

install:
	npm install

lint:
	npm run lint:contracts

mock: mock-gate

mock-gate:
	npm run mock:gate

mock-core:
	npm run mock:core

mock-all:
	npm run mock:all

test-mock:
	npm run test:mock

test-local:
	npm run test:local

test-html:
	npm run test:html

test-ci:
	npm run test:ci

clean:
	rm -f reports/*.xml reports/*.html reports/*.json prism*.log
