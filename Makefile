main:
	gitbook serve

pdf:
	mkdir -p dist
	gitbook pdf . dist/desosa2017.pdf
