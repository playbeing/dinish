SOURCES := $(wildcard ./src/*.ufo)

OTFS := $(patsubst ./src/%.ufo,./generated/otf/%.otf,$(SOURCES))
TTFS := $(patsubst ./src/%.ufo,./generated/ttf/%.ttf,$(SOURCES))
WOFFS := $(patsubst ./src/%.ufo,./generated/woff/%.woff,$(SOURCES))
WOFF2S := $(patsubst ./src/%.ufo,./generated/woff2/%.woff2,$(SOURCES))

all: $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S)

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
	fontbakery check-googlefonts --html fontbakery-report.html generated/otf/*.otf
