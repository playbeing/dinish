SOURCES := $(wildcard src/*/*.ufo)

OTFNAMES := $(patsubst src/%.ufo,otf/%.otf,$(SOURCES))
TTFNAMES := $(patsubst src/%.ufo,ttf/%.ttf,$(SOURCES))
WOFFNAMES := $(patsubst src/%.ufo,woff/%.woff,$(SOURCES))
WOFF2NAMES := $(patsubst src/%.ufo,woff2/%.woff2,$(SOURCES))
OTFS := $(patsubst otf/%.otf,generated/otf/%.otf,$(OTFNAMES))
TTFS := $(patsubst ttf/%.ttf,generated/ttf/%.ttf,$(TTFNAMES))
WOFFS := $(patsubst woff/%.woff,generated/woff/%.woff,$(WOFFNAMES))
WOFF2S := $(patsubst woff2/%.woff2,generated/woff2/%.woff2,$(WOFF2NAMES))
DOCS := docs/index.md

all: $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S) $(DOCS)

clean:
	rm -rf generated

psfnormalize:
	(cd src && sh -c 'for font in *.ufo; do psfnormalize $$font; done')

generated/otf/%.otf: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

generated/ttf/%.ttf: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

generated/woff/%.woff: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

generated/woff2/%.woff2: src/%.ufo
	@mkdir -p $(@D)
	./process-font.sh $< $@

fontbakery: all
	bash -c 'for f in Dinish DinishCondensed DinishExpanded; do cp src/$$f/{METADATA.pb,DESCRIPTION.en_us.html} generated/otf/$$f; done'
	fontbakery check-googlefonts --html fontbakery-dinish-report.html generated/otf/Dinish/*.otf
	fontbakery check-googlefonts --html fontbakery-dinishcondensed-report.html generated/otf/DinishCondensed/*.otf
	fontbakery check-googlefonts --html fontbakery-dinishexpanded-report.html generated/otf/DinishExpanded/*.otf

metadata_templates: all
	sh -c 'for f in Dinish DinishCondensed DinishExpanded; do slug=`echo $$f|tr A-Z a-z`; mkdir -p ofl/$$slug; cp generated/otf/$$f/*.otf ofl/$$slug; gftools add-font ofl/$$slug; done' 2>&1 | grep -v '^no cp file for'

docs/index.md: README.md
	bash -c 'cat docs/index.md.header README.md >docs/index.md'
