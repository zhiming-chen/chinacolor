#' List 384 Traditional Chinese Colors with HEX Values
#'
#' Displays 384 traditional Chinese colors in an interactive 16-column table (4 subgroups × 4 columns each),
#' where each subgroup includes color ID, visual preview, HEX code, and traditional name. Supports pagination
#' for easy browsing in RStudio Viewer.
#'
#' @return An invisible data frame containing structured color information. In interactive environments,
#'   an interactive DT table is displayed with pagination controls.
#'
#' @details
#' The function organizes 384 traditional Chinese colors into groups of 4, with each group presented in a row.
#' Each of the 4 subgroups in a row contains four elements:
#' - color_id: Unique identifier for the color
#' - color preview: Visual block showing the actual color
#' - HEX code: Hexadecimal color code (e.g., #FFFFFF) for direct use in plotting
#' - name: Traditional Chinese name of the color
#'
#' Requires the `DT` package and a pre-defined `chinacolor` data frame with columns:
#' `group_id`, `color_id`, `hex`, and `name`.
#'
#' @examples
#' \dontrun{
#' # Display the interactive color table
#' color_data <- list_colors()
#'
#' # View structure of the returned data frame
#' str(color_data)
#' }
#'
#' @importFrom DT datatable formatStyle
#'
#' @seealso
#' \code{\link{plot_color_grid}}: Visualize 384 Chinese Traditional Colors in a Grid
#' @export
list_colors <- function() {
    # Load color data (assumes chinacolor is pre-defined)
    color_df <- chinacolor

    # Validate required columns and data size
    stopifnot(
        "Data frame 'chinacolor' must contain columns: 'group_id', 'color_id', 'hex', 'name'" =
            all(c("group_id", "color_id", "hex", "name") %in% names(color_df)),
        "Data frame 'chinacolor' must contain exactly 384 colors" =
            nrow(color_df) == 384
    )

    # Create display data frame with HEX values added in each subgroup
    create_display_df <- function(df) {
        # Split data into subgroups of 4 consecutive colors
        groups <- split(df, (seq_len(nrow(df)) - 1) %/% 4)
        # Combine subgroups into a structured data frame with HEX columns
        result <- do.call(rbind, lapply(groups, function(g) {
            data.frame(
                group_id = g$group_id[1],
                # Subgroup 1 with HEX
                color_id_1 = g$color_id[1],
                color_1 = sprintf('<div style="height:24px;background:%s"></div>', g$hex[1]),
                hex_1 = g$hex[1],
                name_1 = g$name[1],
                # Subgroup 2 with HEX
                color_id_2 = g$color_id[2],
                color_2 = sprintf('<div style="height:24px;background:%s"></div>', g$hex[2]),
                hex_2 = g$hex[2],
                name_2 = g$name[2],
                # Subgroup 3 with HEX
                color_id_3 = g$color_id[3],
                color_3 = sprintf('<div style="height:24px;background:%s"></div>', g$hex[3]),
                hex_3 = g$hex[3],
                name_3 = g$name[3],
                # Subgroup 4 with HEX
                color_id_4 = g$color_id[4],
                color_4 = sprintf('<div style="height:24px;background:%s"></div>', g$hex[4]),
                hex_4 = g$hex[4],
                name_4 = g$name[4],
                stringsAsFactors = FALSE
            )
        }))
        result
    }

    # Generate formatted display data with HEX columns
    display_df <- create_display_df(color_df)

    # Display interactive table in RStudio Viewer if interactive
    if (interactive() && requireNamespace("DT", quietly = TRUE)) {
        # Custom header with HEX column added in each subgroup
        header_html <- "
    <table class='display'>
      <thead>
        <tr>
          <th rowspan='2'>group_id</th>
          <th colspan='4'>subgroup_1</th>
          <th colspan='4'>subgroup_2</th>
          <th colspan='4'>subgroup_3</th>
          <th colspan='4'>subgroup_4</th>
        </tr>
        <tr>
          <th>color_id</th><th>color</th><th>HEX</th><th>name</th>
          <th>color_id</th><th>color</th><th>HEX</th><th>name</th>
          <th>color_id</th><th>color</th><th>HEX</th><th>name</th>
          <th>color_id</th><th>color</th><th>HEX</th><th>name</th>
        </tr>
      </thead>
    </table>"

        # Create interactive DT table with pagination
        dt <- DT::datatable(
            display_df,
            rownames = FALSE,
            escape = FALSE,  # Enable HTML rendering for color blocks
            container = header_html,
            options = list(
                pageLength = 16,  # Adjusted for more compact display with extra columns
                dom = 'lpt',      # Show length selector, table, and pagination
                scrollX = TRUE,   # Enable horizontal scrolling for wide table
                columnDefs = list(
                    list(targets = 0, width = "50px"),          # group_id column
                    list(targets = c(1,5,9,13), width = "60px"), # color_id columns
                    list(targets = c(2,6,10,14), width = "60px"),# color preview columns
                    list(targets = c(3,7,11,15), width = "70px"),# HEX code columns
                    list(targets = c(4,8,12,16), width = "90px"),# name columns
                    list(targets = "_all", className = "dt-center")  # Center-align all columns
                ),
                initComplete = DT::JS(
                    "function(settings, json) {",
                    "  $('th').css({'padding': '2px', 'font-size': '12px'});",  # Style headers
                    "}"
                ),
                pagingType = "simple_numbers",  # Pagination style
                language = list(
                    paginate = list(
                        previous = "上一页",
                        `next` = "下一页"  # Escape reserved keyword 'next'
                    ),
                    lengthMenu = "每页显示 _MENU_ 行"
                )
            )
        ) |>
            # Highlight group IDs with background color
            DT::formatStyle(
                columns = "group_id",
                backgroundColor = "#f5f5f5",
                fontWeight = "bold"
            ) |>
            # Adjust padding for color preview blocks
            DT::formatStyle(
                columns = c(2,6,10,14),
                padding = "1px"
            ) |>
            # Style HEX columns for better readability
            DT::formatStyle(
                columns = c(3,7,11,15),
                fontFamily = "monospace",
                fontSize = "8px"
            )

        print(dt)  # Display the table
    }

    invisible(display_df)  # Return the display data frame invisibly
}
