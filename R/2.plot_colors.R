#' Visualize 384 Chinese Traditional Colors in a Grid
#'
#' This function plots all 384 Chinese traditional colors, which are curated from
#' *The Aesthetics of Colors in the Forbidden City*—a collection of hues embodying
#' centuries of Chinese cultural heritage. These colors are deeply rooted in
#' traditional rituals, nature observations, and artistic traditions, with many
#' associated with seasonal changes, festivals, and imperial aesthetics.
#' The colors are arranged in a 24x16 grid where each row corresponds to one of
#' the 24 solar terms, with 16 colors per term. This layout preserves the
#' cultural and seasonal significance of the original color organization.
#'
#' @param show_group Logical. If `TRUE`, adds visual indicators for color groups,
#'   including bounding boxes for each group of four colors, a quadrant circle
#'   with the group number, and a guiding legend. Defaults to `FALSE`.
#'
#' @return A ggplot2 object displaying the color grid with overlaid color IDs.
#'
#' @details
#' The 384 colors are historically linked to China's 24 solar terms (*jieqi*),
#' which mark seasonal transitions in the agricultural calendar. The 24 rows
#' directly correspond to these terms, and the 16 columns per row represent
#' 4 color groups (each with 4 variants) selected to reflect the essence of
#' that term—creating a visual representation of the annual cycle.
#'
#' When `show_group` is `TRUE`, the grid highlights groups of four colors
#' (representing the original `group_id` and `subgroup_id` structure) by drawing
#' bounding boxes around them and adding a numerical label within a quadrant
#' shape in the left of each group's bounding box.
#'
#' @import ggplot2
#' @importFrom dplyr mutate arrange if_else distinct case_when
#' @examples
#' \dontrun{
#' # Plot with cultural/seasonal order (default behavior)
#' plot_color_grid()

#' # Plot with group indicators and legend
#' plot_color_grid(show_group = TRUE)
#' }
#' @seealso
#' \code{\link{list_colors}}: Displays 384 traditional Chinese colors in an interactive 16-column table (4 subgroups × 4 columns each),
#' where each subgroup includes color ID, visual preview, HEX code, and traditional name. Supports pagination
#' for easy browsing in RStudio Viewer.
#' @export
plot_color_grid <- function(show_group = FALSE) {

    # Check if color data exists
    if (!exists("chinacolor")) {
        stop("The 'chinacolor' dataset is missing. Please load it before using this function.")
    }

    # Prepare base data with grid coordinates and text color (for readability)

    plot_title <- "384 Traditional Chinese Colors (without Group ID)"
    plot_title_group <- "384 Chinese Traditional Colors (with Group ID)"
    w_r = 5 # width of the rectangle of the color group
    h_r = 1.4 # heigth of the rectangle of the color group

    w_c = 1 # width of the rectangle of a single color
    h_c = 1 # height of the rectangle of a single color

    # prepare the data for plot
    plot_data <- chinacolor|>
        mutate(rec_x = case_when(group_id%%4 == 1~0.5*w_r, #  x coord of the rectangle of the color group
                                 group_id%%4 == 2~1.5*w_r,
                                 group_id%%4 == 3~2.5*w_r,
                                 .default = 3.5*w_r),
               rec_y = 0.5*h_r + (24-ceiling(group_id/4))*h_r, #  y coord of the rectangle of the color group
               color_x = rec_x + 0.5*w_c*(2*subgroup_id -5),#  x coord of the rectangle of the color with group
               color_y = rec_y,                            # y coord of the rectangle of the color with group
               luminance = (0.299 * RGB_R + 0.587 * RGB_G + 0.114 * RGB_B),
               text_color = if_else(luminance > 0.5, "black", "white"), # text color make sure the number clear to user
               text_x = rec_x -2, # x coord for group id number
               x_coord = rep(1:16, 24), # 16 columns per term, for color without group
               y_coord = rep(24:1, each = 16)) # Rows = 24 terms (top to bottom)) for color without group
    # plot when show_group is TRUE
    if (show_group){

        p_group <- plot_data |>
            ggplot()+

            geom_tile(aes(x = rec_x,
                          y = rec_y,
                          width = 4.8,
                          height = 1.2),
                      fill = "white",color = "grey55",linewidth = 0.6) +
            geom_tile(aes(x = color_x+0.4, y = color_y,   width = 1,
                          height = 1,fill = I(hex)),
                      color = "gray15", linewidth = 0.2, inherit.aes = FALSE)+
            geom_text(aes(x = color_x+0.4, y = color_y,
                          label = color_id, color = I(text_color)), size = 4)+
            geom_point(aes(x = text_x, y = rec_y),colour = "grey75",size = 8,shape = 21,stroke =1 )+
            geom_text(aes(x = text_x, y = rec_y,
                          label = group_id),color = "grey55", size =4) +
            scale_x_continuous(breaks = NULL, expand = c(0, 0)) +
            scale_y_continuous(breaks = NULL, expand = c(0, 0)) +

            theme_minimal() +
            theme(
                panel.grid = element_blank(),
                axis.text = element_blank(),
                axis.title = element_blank(),
                plot.title = element_text(color = "white", face = "bold", hjust = 0.5, margin = margin(b = 10)),
                plot.background = element_rect(fill = "black", color = NA)
            ) +
            ggtitle(plot_title_group)
        return(p_group)
    }
    else{

        # Generate the plot
        p <- ggplot(plot_data, aes(x = x_coord, y = y_coord)) +
            # Color tiles with thin gray borders
            geom_tile(aes(fill = I(hex)), color = "gray15", linewidth =  0.2) +
            # Overlay color IDs with contrast-optimized text
            geom_text(aes(label = color_id, color = I(text_color)), size = 4) +
            # Fix grid dimensions and remove padding
            scale_x_continuous(breaks = NULL, expand = c(0, 0)) +
            scale_y_continuous(breaks = NULL, expand = c(0, 0)) +
            coord_fixed(ylim = c(0.5, 24.5), xlim = c(0.5, 16.5)) +
            # Thematic styling
            theme_minimal() +
            theme(
                panel.grid = element_blank(),
                axis.text = element_blank(),
                axis.title = element_blank(),
                plot.title = element_text(color = "white", face = "bold", hjust = 0.5, margin = margin(b = 10)),
                plot.background = element_rect(fill = "black", color = NA),
                plot.margin = margin(10, 10, 10, 10)
            ) +
            ggtitle(plot_title)
        return(p)
    }
}



