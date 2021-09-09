---
layout: default
title: DINish -- OpenType features
permalink: /features
---

# Language sensitive

The acute accent (as in the french word "café") is styled differently in Polish. By setting the language to Polish, DINish will render the acute accent as a kreska.

* libreOffice: Set the document language to Polish (Tools->Options->Language settings), or change the language for a portion of your text (Tools->Language).
* HTML: Set the page language in the html tag for the page `<html lang="pl">` or just for a span `<span lang="pl">`:

```
<span lang="pl">Pójdźże, kiń tę chmurność w głąb flaszy!</span>
```
<div lang="pl" class="sample">Pójdźże, kiń tę chmurność w głąb flaszy!</div>

# Number styles

There are four styles of numerals to pick from. The default is lining, proportional numerals:
```
font-feature-settings: "lnum", "pnum";  /* Or leave out; it's the default */
```
<div class="sample" id="numeral_lnum_pnum">Columbus left Castile in August 1492 with 3 ships</div>

For artistic value, or to make the numbers go with the flow of mostly lowercase text, you can select old style numerals:
```
font-feature-settings: "onum", "pnum";  /* Or just "onum" */
```
<div class="sample" id="numeral_onum_pnum">Columbus left Castile in August 1492 with 3 ships</div>

For tabular data, you have the option of lining tabular numbers:
```
font-feature-settings: "lnum", "tnum";  /* Or just "tnum" */
```
<div class="sample" id="numeral_lnum_tnum">
<table>
<tr><td>Borrowed in 1492</td><td align="right">1,000,000</td></tr>
<tr><td>Interest</td><td align="right">114,000</td></tr>
<tr><td>To repay in 1493</td><td align="right">1,114,000</td></tr>
</table>
</div>

You can also use old style tabular numbers:
```
font-feature-settings: "onum", "tnum";
```
<div class="sample" id="numeral_onum_tnum">
<table>
<tr><th>Vessel</th><th align="right">Rental rate/mo</th></tr>
<tr><td>Santa Maria</td><td align="right">172,800</td></tr>
<tr><td>Pinta</td><td align="right">115,200</td></tr>
<tr><td>Nina</td><td align="right">57,600</td></tr>
</table>
</div>
