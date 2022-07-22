---
layout: default
title: DINish -- OpenType features
permalink: /dinish/features
---

# Language sensitive

The acute accent (as in the french word "café") is styled differently in Polish. By setting the language to Polish, DINish will render the acute accent as a kreska.

* libreOffice: Set the document language to Polish (Tools->Options->Language settings), or change the language for a portion of your text (Tools->Language).
* HTML: Set the page language in the html tag for the page `<html lang="pl">` or just for a span `<span lang="pl">`:

```
<span lang="pl">Pójdźże, kiń tę chmurność w głąb flaszy!</span>
```
<div lang="pl" class="sample">Pójdźże, kiń tę chmurność w głąb flaszy!</div>

The Romanian language has comma accents. Historically, these were implemented as cedillas in the first version of Unicode. This was fixed later on, but that means that there is now an inconsistency for documents using the historic Unicode characters. With the language set correctly, DINish will render as expected even with legacy Unicode characters:
```
<span lang="en">Muzicologă în bej vând whisky şi tequila, preţ fix.</span> (Don't do this!)
<span lang="ro">Muzicologă în bej vând whisky şi tequila, preţ fix.</span>
```
<div lang="en" class="sample">Muzicologă în bej vând whisky şi tequila, preţ fix. (Don't do this!)</div>
<div lang="ro" class="sample">Muzicologă în bej vând whisky şi tequila, preţ fix.</div>

If your language happens to not have such exceptions, DINish will behave gently even if the wrong language is specified, such as this pangram in Turkish, set in the English language:
```
<span lang="en">Pijamalı hasta yağız şoföre çabucak güvendi.</span> (The language is set to English instead)
```
<div lang="en" class="sample">Pijamalı hasta yağız şoföre çabucak güvendi.</div>

The Dutch language has an ij digraph. If you prefer, you can enable the
ss01 stylistic alternate to automatically substitute ij with ĳ.

```
<span lang="nl">Pa's wijze lynx bezag vroom het fikse aquaduct te IJburg</span>
<span lang="nl" style="font-feature-settings: 'ss01';">Pa's wijze lynx bezag vroom het fikse aquaduct te IJburg</span>
```
<div lang="nl" class="sample">Pa's wijze lynx bezag vroom het fikse aquaduct te IJburg</div>
<div lang="nl" style="font-feature-settings: 'ss01';" class="sample">Pa's wijze lynx bezag vroom het fikse aquaduct te IJburg</div>



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

### Acknowledgements

Columbus' balance sheet was found in The Journal of Applied Business Research, Fourth Quarter 2007 Volume 23, Number 4.
The pangrams were lifted from [Richard Rutter's Clagnut blog](http://clagnut.com/blog/2380/).
