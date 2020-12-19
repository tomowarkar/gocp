.PHONY: init, serve, build, gh-deploy
init:
	poetry install

serve:
	poetry run mkdocs serve 

build:
	poetry run mkdocs build

deploy:
	poetry run mkdocs gh-deploy