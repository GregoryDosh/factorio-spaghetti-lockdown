VERSION = `jq -r .version info.json`
NAME = `jq -r .name info.json`
RELEASE_NAME = $(NAME)_$(VERSION)

# target: all - Default target. Does nothing.
all:
	echo "Try 'make help'"

# target: help - Display callable targets.
help:
	egrep "^# target:" [Mm]akefile

# target: tag - Tag a release.
tag:
	git tag -f $(VERSION)

# target: push_tag - Push tag to GitHub.
push_tag:
	git push origin $(VERSION)

# target: link - Link the existing folder to the Factorio location for macOS
link:
	rm -f $(HOME)/Library/Application\ Support/factorio/mods/$(NAME)*
	ln -s "`pwd`/" "$(HOME)/Library/Application Support/factorio/mods/$(RELEASE_NAME)"

# target: dist - Make a release.
dist:
	rm -f *.zip
	git archive --prefix "$(RELEASE_NAME)/" -o "$(RELEASE_NAME).zip" HEAD
