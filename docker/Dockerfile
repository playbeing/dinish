FROM python:3.10

RUN apt update -qq && apt install --no-install-recommends -y rsync rename g++ make libfreetype-dev zip
RUN mkdir -p /usr/src && cd /usr/src && git clone --recursive https://github.com/google/woff2.git && cd woff2 && make clean all && cp woff2_compress /usr/bin
RUN groupadd -r builder && useradd --no-log-init -r -m --uid 1000 -g builder builder
USER builder
      # FIXME: Get rid of this once we find a clean way to provide a
      # copy of ttfautohint that Google Fonts approves of. Until then,
      # place a copy of ttfautohint 1.8.4 in the "docker" directory when
      # building.
ADD ttfautohint /usr/bin
ADD libttfautohint.so.1.0.3 /usr/lib/x86_64-linux-gnu/libttfautohint.so.1
ENV PATH="/home/builder/.local/bin:/extra-bin:$PATH"
ADD requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
CMD ["bash", "/src/tools/build-ephemeral-ufos.sh"]
