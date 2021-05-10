SOURCES := $(wildcard sources/*/*.ufo)

OTFNAMES := $(patsubst sources/%.ufo,otf/%.otf,$(SOURCES))
TTFNAMES := $(patsubst sources/%.ufo,ttf/%.ttf,$(SOURCES))
WOFFNAMES := $(patsubst sources/%.ufo,woff/%.woff,$(SOURCES))
WOFF2NAMES := $(patsubst sources/%.ufo,woff2/%.woff2,$(SOURCES))
OTFS := $(patsubst otf/%.otf,fonts/otf/%.otf,$(OTFNAMES))
TTFS := $(patsubst ttf/%.ttf,fonts/ttf/%.ttf,$(TTFNAMES))
WOFFS := $(patsubst woff/%.woff,fonts/woff/%.woff,$(WOFFNAMES))
WOFF2S := $(patsubst woff2/%.woff2,fonts/woff2/%.woff2,$(WOFF2NAMES))

all: $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S) docs

clean:
	rm -rf fonts

psfnormalize:
	(cd sources && sh -c 'for font in *.ufo; do psfnormalize $$font; done')

fonts/otf/%.otf: sources/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fonts/ttf/%.ttf: sources/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fonts/woff/%.woff: sources/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fonts/woff2/%.woff2: sources/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fontbakery: all
	-fontbakery check-googlefonts --html fontbakery-dinish-report.html fonts/otf/Dinish/*.otf
	-fontbakery check-googlefonts --html fontbakery-dinishcondensed-report.html fonts/otf/DinishCondensed/*.otf
	-fontbakery check-googlefonts --html fontbakery-dinishexpanded-report.html fonts/otf/DinishExpanded/*.otf

metadata_templates: all
	sh -c 'for f in Dinish DinishCondensed DinishExpanded; do slug=`echo $$f|tr A-Z a-z`; mkdir -p ofl/$$slug; cp fonts/otf/$$f/*.otf ofl/$$slug; gftools add-font ofl/$$slug; done' 2>&1 | grep -v '^no cp file for'

.PHONY: docs
docs:
	bash -c 'for f in Dinish DinishCondensed DinishExpanded; do cp sources/$$f/{METADATA.pb,DESCRIPTION.en_us.html} fonts/otf/$$f; done'
	bash -c 'cat docs/index.md.header README.md >docs/index.md'
