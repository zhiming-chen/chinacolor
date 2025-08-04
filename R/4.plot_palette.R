#' @title Visualize Color Palettes
#'
#' @description This function visualizes built-in or custom color palettes as horizontal bar charts.
#'
#' @param x
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "紫韵花影",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#' You can get the palette_name values and a quick preview the palettes by run `list_palettes()` function.
#' for custom palette: a color vector or the name of a color vector.
#' @param type Palette type, either "built_in" (pre-defined palettes) or "custom" (user-defined color vectors).
#' @param name Display name for the palette. Defaults to NULL (uses original name for built-in palettes, vector name or "unnamed palette" for custom palettes).

#' @param show_text A logical value ,default is `FALSE`.if `TRUE`,hex values and names of the color in the palette displayed.
#' For custom palette,if there are no color name defined, then only show the hex color value.
#' @param ... Additional parameters passed to other functions (currently unused).
#'
#' @return Invisibly returns the color vector.
#'
#' @details
#' For built-in palette, colors are extracted from the `palette_list` data.
#' For custom palette, colors are first validated using `validate_colors()` and then visualized.
#'
#' The palette is displayed as a horizontal bar chart with each color block representing a color,
#' and the palette name shown at the center:
#' for built_in palette:
#'  1. if param `name` is null,show the index,name of palette, the palette_name value and the palette_name_e value.
#'  2. if param `name` is not null,show the `name` value.
#'
#' @examples
#' \dontrun{
#' # for built_in palette
#'
#' plot_palette(x = 33, type = "built_in") # show_text is `FALSE`;
#' plot_palette(x = 33, type = "built_in",show_text = TRUE) # show_text is `TRUE`;
#'
#' # Name defined,and then the default name rules do not worked; the index and the name of the palette invisible.
#' plot_palette(x = 33, type = "built_in",show_text = TRUE,name = "for XX Customer ONLY")
#'
#' # for custom palette
#'
#' # Plot a custom palette (via color vector)
#' my_colors <- c("#FF0000", "#00FF00", "#0000FF")
#' No name defined, colors object name my_colors as the name.
#' plot_palette(x = my_colors, type = "custom" )
#'
#' plot_palette(x = my_colors, type = "custom",name = "base colors",show_text = TRUE)
#'
#' Directly pass a color vector (without pre-defining a variable)
#' plot_palette(x = c("red", "green", "blue"), type = "custom",show_text = TRUE)
#'}
#' @seealso
#' \code{\link{validate_colors}}: Helper function to validate color values.
#' \code{\link{list_palettes}}:Display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @importFrom graphics image rect text
#' @importFrom rlist list.filter
#' @export
plot_palette <- function(x,
                         type = c("built_in", "custom"),
                         name = NULL,
                         show_text =FALSE, ...) {
    type <- match.arg(type)

    # --------------------------
    # 1. Built-in palette handling
    # --------------------------
    if (type == "built_in") {
        # Load built-in palette list
        # if (!exists("palette_list")) {
        #     stop("Built-in palette data not loaded. Please run `data(palette_list)` first.")
        # }


        palette <- find_palette(palette = x)
        elementname <- names(rlist::list.filter(palette_list,
                                                identical(.,
                                                          palette)))

        element_name <- if(grepl(pattern = "[0-9]",
                                 as.character(x))) {names(palette_list[x])}else{elementname}

        index_value <- (1:length(palette_list))[which(names(palette_list) == element_name)]

        colors <- palette$hex
        color_names <- palette$name
        target_title <- paste0(palette$palette_name," ",palette$palette_name_e)
        palette_title <- if (!is.null(name)) name else target_title

    }

    # --------------------------
    # 2. Custom palette handling
    # --------------------------
    if (type == "custom") {
        # Get color vector
        x_expr <- substitute(x)
        is_vector_name <- is.symbol(x_expr)

        if (is_vector_name) {
            vec_name <- deparse(x_expr)
            if (!exists(vec_name, envir = parent.frame())) {
                stop("Vector name '$vec_name' does not exist. Check input.")
            }
            colors_raw <- get(vec_name, envir = parent.frame())
        } else {
            colors_raw <- x
        }

        # Validate colors
        if (!is.vector(colors_raw) || length(colors_raw) == 0) {
            stop("Input must be a non-empty vector.")
        }

        color_check <- validate_colors(colors_raw)
        colors <- color_check$valid
        color_names <- if (all(colors %in% chinacolor$hex)) {
            chinacolor$name[match(colors, chinacolor$hex)]  # 完整返回所有匹配的name
        } else {
            NULL  # 不满足条件时返回NULL
        }

        # Warn about invalid values
        if (nrow(color_check$invalid) > 0) {
            warning("The following invalid color values were ignored:\n",
                    paste0("Position ", color_check$invalid$position, ": '",
                           color_check$invalid$value, "'", collapse = "\n"))
        }

        if (length(colors) == 0) {
            stop("No valid color values to display.")
        }

        # Determine name
        if (!is.null(name)) {
            palette_title <- name
        } else if (is_vector_name) {
            palette_title <- vec_name
        } else {
            palette_title <- "unnamed palette"
        }
    }

    # --------------------------
    # 3. Plot the palette
    # --------------------------
    text_colors <- generate_contrast_color(hex = colors,
                                           type = "analog",
                                           threshold = 0.5,delta = 0.5)
    n <- length(colors)
    x_coords <- 1:n  # x coordinates: 1 to n
    y_coords <- 1    # y coordinates: fixed at 1

    old_par <- par(mar = c(0.5, 0.5, 0.5, 0.5))
    on.exit(par(old_par))

    image(
        x = x_coords,
        y = y_coords,
        as.matrix(1:n),
        col = colors,
        xaxt = "n", yaxt = "n", bty = "n",
        xlab = "", ylab = ""
    )

    # Add title
    rect(xleft = 0, ybottom = 0.9, xright = n + 1, ytop = 1.1,
         col = rgb(1, 1, 1, 0.8), border = NA)
    text(x = (n + 1) / 2, y = 1, labels = palette_title, cex = 2.5, family = "simkai")
    if (type == "built_in"&& is.null(name)){
    text(x = (n + 1.4) / 2, y = 0.93, labels = element_name, cex = 1, family = "simkai")
    text(x = (n + 0.6) / 2, y = 0.93, labels = index_value, cex = 1, family = "simkai")
    }
    if(show_text){
        text(x = 1:n,
             y = 0.62,
             labels = colors,
             cex = 1,
             family = "simkai",
             col = text_colors)
        # if (type == "built_in"){ text(x = 1:n,
        #                               y = 0.64,
        #                               labels = color_names,
        #                               cex = 1,
        #                               font = 2,
        #                               family = "KaiTi",
        #                               col = text_colors)
            if (!is.null(color_names)){ text(x = 1:n,
                                          y = 0.64,
                                          labels = color_names,
                                          cex = 1,
                                          font = 2,
                                          family = "simkai",
                                          col = text_colors)
        }
    }

    invisible(colors)
}
