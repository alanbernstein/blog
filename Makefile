.PHONY: init-theme
init-theme:
	git submodule update --init --recursive


.PHONY: serve
serve:
	hugo serve

.PHONY: newpost
newpost:
	echo $(ARGS)
	hugo new posts/$1.md
	$(EDITOR) content/posts/$1.md


.PHONY: list-drafts
list-drafts:
	cd content/posts && egrep -nir "draft.*true" | cut -d: -f1 | sort
