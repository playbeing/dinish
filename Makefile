SOURCES := $(wildcard sources/*/*.ufo)

OTFNAMES := $(patsubst sources/%.ufo,otf/%.otf,$(SOURCES))
TTFNAMES := $(patsubst sources/%.ufo,ttf/%.ttf,$(SOURCES))
WOFFNAMES := $(patsubst sources/%.ufo,woff/%.woff,$(SOURCES))
WOFF2NAMES := $(patsubst sources/%.ufo,woff2/%.woff2,$(SOURCES))
OTFS := $(patsubst otf/%.otf,fonts/otf/%.otf,$(OTFNAMES))
TTFS := $(patsubst ttf/%.ttf,fonts/ttf/%.ttf,$(TTFNAMES))
WOFFS := $(patsubst woff/%.woff,fonts/woff/%.woff,$(WOFFNAMES))
WOFF2S := $(patsubst woff2/%.woff2,fonts/woff2/%.woff2,$(WOFF2NAMES))

all: update_version $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S) docs zips install_ofl

clean:
	rm -rf fonts zips

psfnormalize:
	(cd sources && sh -c 'for font in */*.ufo; do psfnormalize $$font; done')
	tools/normalize_glif.sh sources/*/*.ufo

fonts/otf/%.otf: sources/%.ufo
	@mkdir -p $(@D)
	tools/process-font.sh $< $@

fonts/ttf/%.ttf: sources/%.ufo
	@mkdir -p $(@D)
	tools/process-font.sh $< $@

fonts/woff/%.woff: sources/%.ufo
	@mkdir -p $(@D)
	tools/process-font.sh $< $@

fonts/woff2/%.woff2: sources/%.ufo
	@mkdir -p $(@D)
	tools/process-font.sh $< $@

fontbakery: all
	-fontbakery check-universal --verbose --full-lists --html fontbakery-dinish-report.html ofl/dinish/*.ttf
	-fontbakery check-universal --verbose --full-lists --html fontbakery-dinishcondensed-report.html ofl/dinishcondensed/*.ttf
	-fontbakery check-universal --verbose --full-lists --html fontbakery-dinishexpanded-report.html ofl/dinishexpanded/*.ttf
	-fontbakery check-universal --verbose --full-lists --html fontbakery-dinishvariable-report.html variable_ttf/*.ttf

metadata_templates: all
	sh -c 'for f in DINish DINishCondensed DINishExpanded; do slug=`echo $$f|tr A-Z a-z`; mkdir -p ofl/$$slug; cp fonts/ttf/$$f/*.ttf ofl/$$slug; gftools add-font ofl/$$slug; done' 2>&1 | grep -v '^no cp file for'

install_ofl:
	sh -c 'for f in DINish DINishCondensed DINishExpanded; do slug=`echo $$f|tr A-Z a-z`; mkdir -p ofl/$$slug; cp fonts/ttf/$$f/*.ttf ofl/$$slug; done'


.PHONY: docs zips update_version
docs:	docs/_sass/DINish-Regular.scss docs/_sass/DINish-Bold.scss
	bash -c 'for f in DINish DINishCondensed DINishExpanded; do slug=`echo $$f|tr A-Z a-z`; mkdir -p ofl/$$slug; cp sources/$$f/{METADATA.pb,DESCRIPTION.en_us.html} ofl/$$slug; done'
	bash -c 'cat docs/index.md.header README.md >docs/index.md'
	bash -c 'cat docs/dinish/index.md.header README.md >docs/dinish/index.md'

docs/_sass/%.scss: fonts/woff2/DINish/%.woff2
	tools/woff2css $< $@

zips:
	@mkdir -p zips
	sh -c 'for t in otf ttf woff woff2; do (cd fonts/$$t && zip ../../zips/dinish-$$t.zip */*.$$t); done'

update_version:
	tools/update-version.sh

# Danger, Will Robinson!
revert_auto_changes:
	git checkout docs/_sass/DINish*.scss fonts/ sources/*.ufo/fontinfo.plist ofl
