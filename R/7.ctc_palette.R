#' Generate Built-in or Custom Color Palettes
#'
#' This function generates two types of color palettes: built-in palettes and custom palettes.
#' Built-in palettes include sequential (seq01-seq20), diverging (div01-div20), and qualitative (qual01-qual20) types,
#' supporting dynamic color count and direction adjustments. Custom palettes allow color selection via groups, subgroups,
#' or direct color IDs, with configurable sorting rules.
#'
#' @param type Palette type, default value is `built_in`.either "built_in" (pre-defined palettes) or "custom" (user-defined selection).
#' @param palette_name  ONLY valid when type = "built_in".
#' the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "紫韵花影",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#' You can get the palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#' @param n Number of colors required (ONLY valid when type = "built_in").
#'   If exceeding the base color count of the palette, sequential and diverging palettes will interpolate,
#'   while qualitative palettes will cycle through existing colors.
#' @param direction Color order direction (only valid when type = "built_in"), 1 for normal order, -1 for reversed. Defaults to 1.
#' @param color_pick List of parameters for custom palette selection (ONLY valid when type = "custom"). Should contain:
#'   \itemize{
#'     \item group_info: A list with 'group' (vector of groups) and 'subgroup' (list of subgroups).
#'     \item color_id: Vector of specific color IDs to include (optional).
#'     \item order: Sorting rule, 1 for input order, 0 for ascending ID, -1 for descending ID (defaults to 1).
#'   }
#'   Use `create_color_pick()` to generate this list.
#' @param show_colors Logical (TRUE/FALSE) indicating whether to display a preview of the palette. Defaults to FALSE.
#' @param palette_title Title for the palette preview (only used when show_colors = TRUE). Defaults to NULL.
#'
#' @return A character vector of hexadecimal color codes.
#'
#' @details
#' Built-in palettes (type = "built_in") rely on the `palette_list` data, which CAN be loaded via `data(palette_list)` before use.
#' This data is a list where each element contains:
#'   - hex: Vector of hexadecimal color codes.
#'   - name:Vector of the color names,Chinese version.
#'   - color_count: Number of base colors in the palette.
#'   - type: Palette category ("sequential", "diverging", or "qualitative").
#'   - palette_name: Chinese name for the palette.
#'   - palette_name_e: English name for the palette.
#'   - ......
#'   you can run `list_palettes`function for a quick view of all of the built_in palettes.
#'
#' Valid built-in palette names/indexes:
#'   - Sequential: "seq01" to "seq20" (indexes 1-20).
#'   - Diverging: "div01" to "div20" (indexes 21-40).
#'   - qualitative: "qual01" to "qual20" (indexes 41-60).
#'
#' Custom palettes (type = "custom") rely on the `chinacolor` data, which includes color group, subgroup, and unique color_id.
#' The selection logic is: first extract colors by group and subgroup, then append explicitly specified color_ids,
#' and finally deduplicate and sort according to the specified rule.
#' @examples
#' \dontrun{
#' # for built_in palette
#' # 1 Using a built-in sequential palette (seq05)
#' pal_builtin <- ctc_palette(
#'   type = "built_in",
#'   palette_name = "seq05",  # Valid sequential palette name
#'   n = 5,                      # Number of colors to extract
#'   direction = 1,              # Normal order
#'   show_colors = TRUE          # Display color preview
#' )
#'
#'  # 2 Using a built-in diverging palette with defined plot title
#'  pal_div <- ctc_palette(
#'   type = "built_in",
#'   palette_name = 38,
#'   n = 7,
#'   direction = -1,              # Reversed order
#'   palette_title = "Just for Test",show_colors = T
#' )
#'  # 3 Using a built-in palette BY palette_name value
#'  pal_div <- ctc_palette(
#'   type = "built_in",
#'   palette_name = "古陶温光",
#'   n = 5,
#'   direction = 1,
#'   show_colors = T
#' )

#' for custom palette
#' # 4 Using a custom palette (filtered by group and subgroup),no plot title defined.
#' custom_pick <- create_color_pick(
#'  groups = c(35, 27),
#'  subgroups = list(c(2, 4), c(1, 3)),
#'  order_rule = 1
#' )
#' pal_custom <- ctc_palette(
#'  type = "custom",
#'  color_pick = custom_pick,
#'  show_colors = TRUE
#' )
#'
#' # 5 Custom palette (mixing group selection with direct color_ids)
#' custom_pick2 <- create_color_pick(
#'   groups = 35,
#'   subgroups = list(-1),  # -1 reverses subgroup order (4:3:2:1)
#'   color_id = c(4, 8, 12),
#'   order_rule = 0         # Sort by ascending ID
#' )
#' pal_custom2 <- ctc_palette(type = "custom",
#' color_pick = custom_pick2, show_colors = TRUE,palette_title = "Just for Test")
#' }
#' @seealso
#' Helper function `create_color_pick()` for generating the `color_pick` parameter;
#' `plot_palettes()` to visualize built-in palettes;
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#' Built-in palettes data `palette_list` and raw colors data `chinacolor` storing built-in palettes and custom color information respectively.
#'
#' @importFrom grDevices colorRampPalette
#' @importFrom utils data
#' @export
ctc_palette <- function(type = "built_in",
                        palette_name = NULL,
                        n = NULL,
                        direction = 1,
                        color_pick = list(),
                        show_colors = FALSE,
                        palette_title = NULL
) {

    # 1. Strictly validate 'type' parameter
    valid_types <- c("built_in", "custom")
    # if (!type %in% valid_types) {
    #     stop(paste("Invalid 'type' parameter. Must be one of:", paste(valid_types, collapse = ", ")))
    # }
    type <- match.arg(type, choices = valid_types)

    # Parameter validation: Avoid cross-type parameters
    if (type == "built_in" && !is.null(color_pick) && length(color_pick) > 0) {
        warning("When type='built_in', 'color_pick' parameter is ignored. Use 'palette_name' and 'n' instead.")
    }
    if (type == "custom" && (!is.null(palette_name) || !is.null(n))) {
        warning("When type='custom', 'palette_name' and 'n' parameters are ignored. Use 'color_pick' instead.")
    }

    if (type == "built_in") {
        # Built-in palette branch
        # Check if built-in palette data exists
        if (!exists("palette_list")) {
            stop("Built-in palette data not loaded. Please run `data(palette_list)` first.")
        }

        # Check if palette_name is provided
        if (is.null(palette_name)) {
            stop("When type='built_in', 'palette_name' must be provided. Valid names: seq001-seq036, div001-div029, qual001-qual033; indexes: 1-98.")
        }

        # # Handle numeric index (position in palette_list)
        # if (is.numeric(palette_name)) {
        #     if (palette_name < 1 || palette_name > length(palette_list)) {
        #         stop(paste("Invalid index. Must be between 1 and", length(palette_list), "(see plot_palettes() for valid ranges)."))
        #     }
        #     palette_name <- names(palette_list)[palette_name]
        # }
        #
        # # Check if palette name exists
        # if (!palette_name %in% names(palette_list)) {
        #     stop(paste("Unknown palette name. Valid names: seq001-seq036, div001-div029, qual001-qual033. Load data and check `names(palette_list)` after running `data(palette_list)`."))
        # }

        # Get palette information (use hex field)
        # palette_data <- palette_list[[palette_name]]
        # base_colors <- palette_data$hex  # Use hex field uniformly
        # base_count <- palette_data$color_count
        # palette_type <- palette_data$type

        palette_data <- find_palette(palette = palette_name)
        base_colors <- palette_data$hex  # Use hex field uniformly
        base_count <- palette_data$color_count
        palette_type <- palette_data$type
        # colors <- palette$hex
        # color_names <- palette$name
        target_title <- paste0(palette_data$palette_name," ",palette_data$palette_name_e)
        palette_title <- if (!is.null(palette_title)) palette_title else target_title




        # Process color count 'n'
        if (!is.null(n)) {
            if (n > base_count) {
                # When more colors are needed, handle differently by type
                if (palette_type %in% c("sequential", "diverging")) {
                    # Sequential and diverging: use interpolation
                    # palette_type <- "continuous"
                    palette <- colorRampPalette(base_colors)(n)
                } else {
                    # qualitative: cycle through base colors
                    palette <- rep(base_colors, length.out = n)
                }
            } else {
                if (palette_type %in% c("sequential", "qualitative")) {
                    # Sequential/qualitative: take first n colors in current order
                    palette <- base_colors[1:n]
                } else if (palette_type == "diverging") {
                    # Diverging: take colors from middle outwards
                    mid <- ceiling(base_count / 2)  # Middle position

                    if (n == 1) {
                        # Take middle color
                        palette <- base_colors[mid]
                    } else {
                        # Calculate number of colors needed on each side
                        left_count <- floor((n - 1) / 2)
                        right_count <- ceiling((n - 1) / 2)

                        # Calculate range of colors to take
                        start <- max(1, mid - left_count)
                        end <- min(base_count, mid + right_count)

                        # Ensure correct number of colors
                        if ((end - start + 1) < n) {
                            # If not enough on right side, extend left first
                            start <- max(1, start - (n - (end - start + 1)))
                        }

                        palette <- base_colors[start:end]
                    }
                } else {
                    warning("Unknown palette type. Using default order.")
                    palette <- base_colors[1:n]
                }
            }
        } else {
            # Use original palette if 'n' not specified
            palette <- base_colors
        }

        # Process direction (1 = normal, -1 = reverse)
        if (!direction %in% c(1, -1)) {
            warning("'direction' must be 1 or -1. Defaulting to 1.")
            direction <- 1
        }
        if (direction == -1) {
            palette <- rev(palette)
        }

    } else if (type == "custom") {
        # Custom palette branch (逻辑不变，保持与原有设计一致)
        if (!exists("chinacolor")) {
            stop("Custom color data not loaded. Please run `data(chinacolor)` first.")
        }
        color_data <- chinacolor

        # Parse parameters
        group_info <- color_pick$group_info
        groups <- if (!is.null(group_info$group)) group_info$group else NULL
        subgroups <- if (!is.null(group_info$subgroup)) group_info$subgroup else NULL
        color_id <- if (!is.null(color_pick$color_id)) color_pick$color_id else NULL
        order_rule <- if (!is.null(color_pick$order)) color_pick$order else 1

        # Parameter validation
        if (!order_rule %in% c(1, 0, -1)) {
            stop("'color_pick$order' must be 1 (input order), 0 (ascending ID), or -1 (descending ID)")
        }
        if (!is.null(groups) && length(groups) > 0 && is.null(subgroups)) {
            subgroups <- rep(list(1:4), length(groups))  # Default to all subgroups
        }

        # Process subgroups: convert -1 to 4:1 and ensure valid order
        if (!is.null(groups) && length(groups) > 0) {
            if (!is.list(subgroups)) subgroups <- as.list(subgroups)
            if (length(subgroups) < length(groups)) {
                subgroups <- rep(subgroups, length.out = length(groups))
            }

            for (i in seq_along(subgroups)) {
                s <- subgroups[[i]]
                if (is.numeric(s) && length(s) == 1 && s == -1) {
                    subgroups[[i]] <- 4:1  # Reverse order
                } else if (!all(s %in% 1:4)) {
                    stop(paste("Subgroup for group", groups[i], "must be 1-4 or -1"))
                }
            }
        }

        # Select color IDs (in subgroup order)
        selected_ids <- c()

        if (!is.null(groups) && length(groups) > 0) {
            for (i in seq_along(groups)) {
                g <- groups[i]
                s_order <- subgroups[[i]]
                group_data <- color_data[color_data$group == g, ]

                for (sub in s_order) {
                    sub_ids <- group_data$color_id[group_data$subgroup == sub]
                    selected_ids <- c(selected_ids, sub_ids)
                }
            }
        }

        # Process color_id: append explicitly selected IDs
        if (!is.null(color_id)) {
            valid_ids <- intersect(color_id, color_data$color_id)
            if (length(valid_ids) < length(color_id)) {
                warning("The following IDs do not exist:", paste(setdiff(color_id, valid_ids), collapse = ","))
            }
            selected_ids <- c(selected_ids, valid_ids)
        }

        # Deduplicate and sort
        unique_ids <- unique(selected_ids)
        if (length(unique_ids) == 0) stop("No colors matched the criteria")

        selected_data <- color_data[match(unique_ids, color_data$color_id), ]
        if (order_rule == 0) {
            selected_data <- selected_data[order(selected_data$color_id), ]
        } else if (order_rule == -1) {
            selected_data <- selected_data[order(-selected_data$color_id), ]
        }

        # Output result
        pal <- selected_data$hex
        if (!is.null(n)) pal <- if (n > length(pal)) rep(pal, length.out = n) else pal[1:n]
        palette <- pal
        palette_title <- if (!is.null(palette_title)) palette_title else "unnamed palette"
    }

    # Display color preview
    if (show_colors) {

        color_names <-  if(all(palette %in% chinacolor$hex)){
            chinacolor$name[match(palette, chinacolor$hex)]
        } else{
          NULL
        }


        cat("Colors in the palette:\n")
        print(palette)
        cat("Number of colors:", length(palette), "\n")
        plot_palette(x = palette, type = "custom", name = palette_title,show_text = T)
    }

    return(unname(palette))
}
