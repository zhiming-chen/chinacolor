#' Plot Built-in Palettes
#'
#' 60 palettes created from 384 colors can be visualized using this function. It allows plotting one or multiple built-in palettes in a single figure.
#'
#' @param palette_names The name(s) of the color palette(s) (as character strings) or their position(s) in the palette list (as numeric values).
#'
#' Palette categories and available ranges:
#' \itemize{
#'   \item Sequential Palettes: 1-20, named \code{seq01} to \code{seq20}
#'   \item Diverging Palettes: 21-40, named \code{div01} to \code{div20}
#'   \item Qualitative Palettes: 41-60, named \code{qual01} to \code{qual20}
#' }
#'
#' Accepts either a single name/position or a vector of names/positions. For example, "seq01" or 1 refers to the first palette.
#'
#' @return A ggplot plot object
#'
#' @details This function visualizes multiple built-in palettes in one figure, helping users overview and select appropriate palettes. For better display effects, it is strongly recommended to plot no more than 30 palettes at once.
#'
#' @importFrom ggplot2 ggplot geom_tile scale_fill_identity facet_grid theme_void theme element_rect element_text unit
#'
#' @seealso
#' `plot_palette()` to visualize a single palette;
#' `list_palettes()` Display a searchable table of all available color palettes with their identifiers with color preview.
#'
#'
#'
#' @examples
#' \dontrun{
#' # Plot a single palette
#' plot_palettes("qual15")  # Using list name in palette list
#' plot_palettes(16)         # Using palette position in palette list
#'
#' # Plot multiple specified palettes
#' # Using a name vector
#' palette_names <- c("seq01", "seq02", "seq03", "seq04", "seq05", "seq06")
#' plot_palettes(palette_names)
#'
#' # Using a position vector
#' plot_palettes(37:60)
#'}
#' @export
plot_palettes <- function(palette_names) {
# Input validation

if (missing(palette_names) || length(palette_names) == 0) {
    stop("Please provide valid palette names or indices. Use ?plot_palettes for help.")
}

# Get valid ranges and names
valid_indices <- seq_along(palette_list)
valid_names <- names(palette_list)

# Check numeric input
if (is.numeric(palette_names)) {
    # Check for non-integer values
    if (!all(palette_names == as.integer(palette_names))) {
        stop("Numeric inputs must be integers. Use ?plot_palettes for help.")
    }

    # Check if within valid range
    invalid <- !palette_names %in% valid_indices
    if (any(invalid)) {
        stop(paste("Numeric inputs are out of valid range. The valid range is 1 to", length(palette_list),
                   ". Invalid values: ", paste(palette_names[invalid], collapse = ", "),
                   ". Use ?plot_palettes for help."))
    }
}
# Check string input
else if (is.character(palette_names)) {
    invalid <- !palette_names %in% valid_names
    if (any(invalid)) {
        stop(paste("String inputs do not exist in the palette list. Invalid values: ",
                   paste(palette_names[invalid], collapse = ", "),
                   ". Use ?plot_palettes for help."))
    }
}
# Handle other input types
else {
    stop("Invalid input type. Please use numeric values or strings. Use ?plot_palettes for help.")
}
    all_data <- list()
    for (palette_name in palette_names) {
        palette_info <- palette_list[[palette_name]]
        name_text <- ifelse(is.numeric(palette_name),
                            names(palette_list[palette_name]),
                            palette_name)
        if (!is.null(palette_info)) {
            n_colors <- palette_info$color_count
            data <- data.frame(
                palette = rep(name_text, n_colors),
                x = 1:n_colors,
                y = 1,
                color = palette_info$hex
            )
            all_data <- rbind(all_data, data)
        } else {
            warning(paste("Palette", palette_name, "not found in palette_list."))
        }
    }

    if (nrow(all_data) > 0) {

        p <- ggplot(all_data, aes(x = x, y = y, fill = color)) +
            geom_tile() +
            scale_fill_identity() +
            facet_grid(palette ~ ., switch = "y") +
            theme_void() +
            theme(
                plot.background = element_rect(fill = "black", color = NA),
                panel.background = element_rect(fill = "black", color = NA),
                strip.text = element_text(color = "white", size = 20),
                strip.background = element_rect(fill = "black", color = NA),
                strip.text.y.left = element_text(
                    color = "white",
                    angle = 0,
                    hjust = 0.5,
                ),
                panel.spacing.y = unit(0, "lines")
            )

        print(p)
    }
}

