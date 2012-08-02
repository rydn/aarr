BOOTSTRAP = ./out/assets/css/bootstrap.css
BOOTSTRAP_LESS = ./public/less/bootstrap.less
BOOTSTRAP_RESPONSIVE = ./out/assets/css/bootstrap-responsive.css
BOOTSTRAP_RESPONSIVE_LESS = ./public/less/responsive.less
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


#
# BUILD public/docs
#

build:
	@echo "\n${HR}"
	@echo "Building AaRr..."
	@echo "${HR}\n"
	@echo "Running JSHint...			    ${CHECK} Done"
	@recess --compile ${BOOTSTRAP_LESS} > ${BOOTSTRAP}
	@recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > ${BOOTSTRAP_RESPONSIVE}
	@echo "Compiling LESS...			    ${CHECK} Done"
	@node public/docs/build
	@cp public/img/* out/assets/img/
	@cp public/js/*.js out/assets/js/
	@cp public/ico/* out/assets/ico/
	@cp public/html/* out/
	@rm out/assets/js/bootstrap-*
	@echo "Compiling documentation...                  ${CHECK} Done"
	@cat public/js/bootstrap-transition.js public/js/bootstrap-alert.js public/js/bootstrap-button.js public/js/bootstrap-carousel.js public/js/bootstrap-collapse.js public/js/bootstrap-dropdown.js public/js/bootstrap-modal.js public/js/bootstrap-tooltip.js public/js/bootstrap-popover.js public/js/bootstrap-scrollspy.js public/js/bootstrap-tab.js public/js/bootstrap-typeahead.js > out/assets/js/bootstrap.js
	@uglifyjs -nc out/assets/js/bootstrap.js > out/assets/js/bootstrap.min.js
	@cat public/js/vendor/jquery.hashlisten/jquery.hashlisten.js > out/assets/js/vendor.js
	@cat public/js/lib/*.js > out/assets/js/cs.js
	@uglifyjs -nc out/assets/js/vendor.js > out/assets/js/vendor.min.js
	@uglifyjs -nc out/assets/js/cs.js > out/assets/js/cs.min.js
	@uglifyjs -nc public/js/vendor/jquery/dist/jquery.js > out/assets/js/jquery.min.js
	@echo "Compiling and minifying javascript...       ${CHECK} Done"
	@mkdir .tmp
	@mkdir .tmp/jsmin
	@mv out/assets/js/*.min.js .tmp/jsmin/
	@rm -fr out/assets/js/*.js
	@mv .tmp/jsmin/*.min.js out/assets/js/
	@rm -fr .tmp/
	@echo "Removing unminified javascript...	    ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Successfully built at ${DATE}."
	@echo "${HR}\n"

#
# RUN JSHINT & QUNIT TESTS IN PHANTOMJS
#

test:
	jshint public/js/*.js --config js/.jshintrc
	jshint public/js/tests/unit/*.js --config js/.jshintrc
	node public/js/tests/server.js &
	phantomjs public/js/tests/phantom.js "http://localhost:3000/js/tests"
	kill -9 `cat public/js/tests/pid.txt`
	rm public/js/tests/pid.txt

#
# BUILD SIMPLE BOOTSTRAP DIRECTORY
# recess & uglifyjs are required
#

bootstrap:
	mkdir -p out/assets/img
	mkdir -p out/assets/css
	mkdir -p out/assets/js
	mkdir -p out/assets/ico
	cp public/img/* out/assets/img/
	recess --compile ${BOOTSTRAP_LESS} > out/assets/css/bootstrap.css
	recess --compress ${BOOTSTRAP_LESS} > out/assets/css/bootstrap.min.css
	recess --compile ${BOOTSTRAP_RESPONSIVE_LESS} > out/assets/css/bootstrap-responsive.css
	recess --compress ${BOOTSTRAP_RESPONSIVE_LESS} > out/assets/css/bootstrap-responsive.min.css
	cat public/js/bootstrap-transition.js public/js/bootstrap-alert.js public/js/bootstrap-button.js public/js/bootstrap-carousel.js public/js/bootstrap-collapse.js public/js/bootstrap-dropdown.js public/js/bootstrap-modal.js public/js/bootstrap-tooltip.js public/js/bootstrap-popover.js public/js/bootstrap-scrollspy.js public/js/bootstrap-tab.js public/js/bootstrap-typeahead.js > out/assets/js/bootstrap.js
	uglifyjs -nc out/assets/js/bootstrap.js > out/assets/js/bootstrap.min.tmp.js
	echo "/*!\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > out/assets/js/copyright.js
	cat out/assets/js/copyright.js out/assets/js/bootstrap.min.tmp.js > out/assets/js/bootstrap.min.js
	rm out/assets/js/copyright.js out/assets/js/bootstrap.min.tmp.js

#
# MAKE FOR GH-PAGES 4 FAT & MDO ONLY (O_O  )
#

gh-pages: bootstrap public/docs
	rm -f out/assets/bootstrap.zip
	zip -r out/assets/bootstrap.zip bootstrap
	rm -r bootstrap
	rm -f ../bootstrap-gh-pages/assets/bootstrap.zip
	node public/docs/build production
	cp -r public/docs/* ../bootstrap-gh-pages

#
# WATCH LESS FILES
#

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"


.PHONY: public/docs watch gh-pages
