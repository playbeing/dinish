#!/bin/sh

# Rebuild all fonts and run fontbakery.

(cd .. && make clean && make && make fontbakery)
