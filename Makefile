.DEFAULT_GOAL := help
.PHONY: push-all	## カレントディレクトリ以下の全変更を反映
push-all:
	git add .
	git commit -m "commit all changes"
	git push origin HEAD

.PHONY: help
help:	## show commands
	@grep -E '^[[:alnum:]_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'