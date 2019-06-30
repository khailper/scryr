# scryr 0.3.0.9000
* added `relabel_mtg_color` to turn a Scryfall color code ("G") into a 
human-readable label ("Green").
* added `wubrg_order` to turn output of `relabel_mtg_color` into an ordered 
factor (mainly for use with legends in `ggplot2`).
* added `extract_subtypes` to strip card type from type lines in order to 
just get subtypes
* assirted minor documentation improvements

# scryr 0.2.1.9000
* updated `Suggests` to reflect packages used in vignette

# scyr 0.2.0.9000
* added functions for the Bulk Data API
* added `label_guild` and `label_tri` functions to streamline labelling cards 
based on color
* Added vignette on using `label_guild`
* `pkgdown` support

# scyr 0.1.0.9000

* public release
* added functions to query the Scryfall API: `scry_cards()` (Card Search API),
`scry_catalog` (Catalog API), and `scry_sets` (Set API),