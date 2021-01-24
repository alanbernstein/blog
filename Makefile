.PHONY: init-theme
init-theme:
	git submodule update --init --recursive


.PHONY: serve
serve:
	hugo serve
