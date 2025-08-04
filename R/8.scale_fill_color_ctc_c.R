#' Continuous Color Scale for ggplot2 Using Built-in CTC Palettes (Outline Colors)
#'
#' Creates a continuous outline color scale for ggplot2 by retrieving colors from built-in CTC palettes
#' (seq01-seq20, div01-div20, qual01-qual20) via `ctc_palette()`. Designed for mapping continuous data
#' with smooth gradient interpolation.
#'
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "紫韵花影",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#' You can get the palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::scale_color_gradientn()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 continuous outline color scale object.
#'
#' @details
#' - Requires `palette_list` loaded via `data(palette_list)` first.
#' - Valid palette names: sequential (seq001-seq036), diverging (div001-div029), qualitative (qual001-qual033).
#' - Warns if using qualitative palettes (designed for categorical data) with continuous data.
#' - Colors are fetched via `ctc_palette(type = "built_in")` and interpolated by `scale_color_gradientn()`.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#'
#' # 1 Use sequential palette "seq05" for continuous data
#' ggplot(airquality, aes(x = Day, y = Temp, color = Ozone)) +
#'   geom_point(size = 4) +
#'   scale_colour_ctc_c(palette_name = "seq05", direction = 1)
#'
#' # 2 Use diverging palette via index (38 = div18)
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'   geom_point(size = 4) +
#'   scale_colour_ctc_c(palette_name = 38, direction = -1)

#' # 3 Use palette_name value,a Chinese name for palette
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'     geom_point(size = 4) +
#'     scale_colour_ctc_c(palette_name = "碧霄流澈", direction = 1)

#' # 4 Use palette_name_e value,a English name for palette
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'     geom_point(size = 4) +
#'     scale_colour_ctc_c(palette_name = "violet_bloom", direction = -1)
#' }
#'
#' @seealso
#' `ctc_palette()` for palette generation;
#' `scale_fill_ctc_c()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
scale_colour_ctc_c <- function(palette_name, direction = 1, ...) {

    # # Check built-in palette information (names and indices)
    # built_in_names <- list(names(palette_list), 1:length(palette_list))
    #
    # # Check if built-in palette data is loaded
    # if (!exists("palette_list")) {
    #     stop("Please load the built-in palette data first: data(palette_list)")
    # }
    #
    # # Validate if the palette exists in palette_list
    # if (!palette_name %in% unlist(built_in_names)) {
    #     warning(paste("Palette", palette_name, "not found in palette_list."))
    # }

    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Check palette type compatibility with continuous data
    if (palette_type %in% "qualitative") {
        warning("For continuous data, it is recommended to use 'sequential' or 'diverging' type palettes")
    }

    # Directly use scale_color_gradientn and let ggplot2 handle interpolation
    scale_color_gradientn(
        colors = ctc_palette(
            type = "built_in",
            palette_name = palette_name,
            direction = direction
        ),
        ...
    )
}


#' Continuous Fill Color Scale for ggplot2 Using Built-in CTC Palettes
#'
#' Creates a continuous outline color scale for ggplot2 by retrieving colors from built-in CTC palettes
#' (seq01-seq20, div01-div20, qual01-qual20) via `ctc_palette()`. Designed for mapping continuous data
#' with smooth gradient interpolation.
#'
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "紫韵花影",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#' You can get the palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::scale_fill_gradientn()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 continuous fill color scale object.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#'
#' # 1 Use diverging palette for fill,
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'   geom_raster() +
#'   scale_fill_ctc_c(palette_name = "div12", direction = -1, name = "Density")
#'
#'   # 2 palette by index value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#' geom_raster() +
#'     scale_fill_ctc_c(palette_name = 33, direction = 1, name = "Density")
#'
#'   # 3 palette by Chinese palette_name value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = "海天沙影", direction = 1, name = "Density")
#'
#'   # 4 palette by English palette_name_e value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = "autumn_blue", direction = -1, name = "Density")
#' }
#'
#' @seealso
#' `ctc_palette()` for palette generation;
#' `scale_colour_ctc_c()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
scale_fill_ctc_c <- function(palette_name, direction = 1, ...) {
    # Check built-in palette information (names and indices)
    # built_in_names <- list(names(palette_list), 1:length(palette_list))
    #
    # # Check if built-in palette data is loaded
    # if (!exists("palette_list")) {
    #     stop("Please load the built-in palette data first: data(palette_list)")
    # }
    #
    # # Validate if the palette exists in palette_list
    # if (!palette_name %in% unlist(built_in_names)) {
    #     warning(paste("Palette", palette_name, "not found in palette_list."))
    # }

    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Check palette type compatibility with continuous data
    if (palette_type %in% "qualitative") {
        warning("For continuous data, it is recommended to use 'sequential' or 'diverging' type palettes")
    }

    # Directly use scale_fill_gradientn for fill aesthetics
    scale_fill_gradientn(
        colors = ctc_palette(
            type = "built_in",
            palette_name = palette_name,
            direction = direction
        ),
        ...
    )
}


#' Alias for scale_colour_ctc_c (American English Spelling)
#'
#' Convenience alias for `scale_colour_ctc_c()` to support American English.
#'
#' @inheritParams scale_colour_ctc_c
#' @export
scale_color_ctc_c <- scale_colour_ctc_c
