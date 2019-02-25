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

# target: clean - Clean the links and zip files from the dev/dist process
clean:
	rm -f ./*.zip
	rm -f $(HOME)/Library/Application\ Support/factorio/mods/$(NAME)*

# target: link - Link the existing folder to the Factorio location for macOS
link:
	make clean
	ln -s "`pwd`/" "$(HOME)/Library/Application Support/factorio/mods/$(RELEASE_NAME)"

# target: dist - Make a release.
dist:
	make clean
	git archive --prefix "$(RELEASE_NAME)/" -o "$(RELEASE_NAME).zip" HEAD
