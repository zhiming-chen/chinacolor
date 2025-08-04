#' Discrete Color Scale for ggplot2 Using Built-in CTC Palettes (Outline Colors)
#'
#' Creates a discrete outline color scale for ggplot2 by retrieving colors from built-in CTC palettes
#' (seq01-seq20, div01-div20, qual01-qual20) via `ctc_palette()`.  Designed for mapping discrete/categorical data.
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "紫韵花影",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#' You can get the palette_name values and a quick preview the palettes by run `list_palettes()` function.
#' @param n Number of colors to extract from the palette. If NULL (default), uses the number of unique data categories.
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 discrete outline color scale object.
#'
#' @details
#' - Requires `palette_list` loaded via `data(palette_list)` first.
#' - Valid palette names: sequential (seq001-seq036), diverging (div001-div029), qualitative (qual001-qual033).
#' - Warns if using non-qualitative palettes (designed for continuous data) with discrete data.
#' - Colors are fetched via `ctc_palette(type = "built_in")`.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#' iris$sepal_group <- cut(
#'     iris$Sepal.Length,
#'    breaks = 4,
#'    labels = paste0("组", 1:4)
#')
#'
#' ggplot(iris, aes(x = Sepal.Width,
#'                       y = Petal.Width,
#'                       color = sepal_group)) +
#'    geom_point(size = 2.5) +  # 散点图
#'    geom_smooth(method = "lm", se = FALSE) +  # 回归线
#'    scale_color_ctc_d(palette_name = 60)+  # can select palette by using index, name in list,palette_name and palette_name_e values.
#'    theme_ctc_dunhuang() # use the customed theme in this package.
#' }
#'
#' @seealso
#' `ctc_palette()` for palette generation;
#' `scale_fill_ctc_d()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
scale_colour_ctc_d <- function(palette_name, n = NULL, direction = 1, ...) {
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

    # Type compatibility check: Discrete functions work best with qualitative palettes
    if (!palette_type %in% "qualitative") {
        warning(
            "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
        )
    }

    discrete_scale(
        aesthetics = "colour",
        scale_name = "ctc_d",
        palette = function(n_colors) {
            ctc_palette(
                type = "built_in",
                palette_name = palette_name,
                n = n %||% n_colors,
                direction = direction
            )
        },
        ...
    )
}

# Discrete Fill Scale
#' Discrete Color Scale for ggplot2 Using Built-in CTC Palettes (Fill Colors)
#'
#' Creates a discrete fill color scale for ggplot2 by wrapping `scale_colour_ctc_d()` with aesthetics set to "fill".
#' Uses built-in palettes (seq001-seq036, div001-div029, qual001-qual033) via `ctc_palette()`.
#'
#' @param palette_name Valid name (seq001-seq036, div001-div029, qual001-qual033) or numeric index (1-98) of a palette in `palette_list`.
#' @param n Number of colors to extract from the palette. If NULL (default), uses the number of unique data categories.
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 discrete fill color scale object.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#' ggplot(mpg, aes(x = class, fill = class)) +
#'    geom_bar() +
#'    scale_fill_ctc_d(palette_name = 41)+
#'    theme_ctc_mineral()
#'}
#'
#'
#' @seealso
#' `scale_colour_ctc_d()` for outline scales;
#' `ctc_palette()` for palette generation;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
 scale_fill_ctc_d <- function(palette_name, n = NULL, direction = 1, ...) {
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
    #
    #
    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Type compatibility check: Discrete functions work best with qualitative palettes
    if (!palette_type %in% "qualitative") {
        warning(
            "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
        )
    }

    discrete_scale(
        aesthetics = "fill",
        scale_name = "ctc_d",
        palette = function(n_colors) {
            ctc_palette(
                type = "built_in",
                palette_name = palette_name,
                n = n %||% n_colors,
                direction = direction
            )
        },
        ...
    )
}







# Alias for scale_colour_ctc_d (American English Spelling)
#' @rdname scale_colour_ctc_d
#' @export
scale_color_ctc_d <- scale_colour_ctc_d




# Helper function: Handle NULL values
#' Null Coalescing Operator
#'
#' Returns the first argument if it is not NULL, otherwise returns the second argument.
#'
#' @param a First argument.
#' @param b Second argument (default value if `a` is NULL).
#'
#' @return The value of `a` if it is not NULL, otherwise the value of `b`.
#'
#' @keywords internal
`%||%` <- function(a, b) {
    if (is.null(a)) b else a
}

