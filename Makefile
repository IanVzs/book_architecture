config:
	cp config.toml.template config.toml

run: config
	hugo server --bind 0.0.0.0 --minify

build: config
	hugo -D --minify
