#' CTC Bronze Theme for ggplot2
#'
#' A theme inspired by ancient Chinese bronze ware, featuring harmoniously optimized background colors.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family (default: "STSong" for Chinese compatibility).
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param oxidation_level Character: "light" (less greenish oxidation) or "heavy"
#'   (more greenish oxidation, default: "heavy").
#'
#' @return A ggplot2 theme object.
#'
#' @details
#'
#' - **Background Settings**:
#'   - Heavy oxidation mode: Reduces the color difference by 40% between plot background
#'     (#DFD6B8) and panel background (#B4A379) for a more natural transition
#'   - Light oxidation mode: Maintains original soft contrast (plot background #DFD6B8 +
#'     panel background #C4B798)
#'   - Recommended color combinations (selected from 384 colors): **For discrete categories**:
#'     Bronze blue (#3D8E86), Secondary green (#5DA39D), Steamed chestnut (#A58A5F),
#'     Bird plum (#788A6F)
#'
#' @examples
#' \dontrun{
#' # Example 1: Heavy oxidation mode (optimized background transition)
#' ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
#'    geom_point(size = 3) +
#'    scale_color_manual(values = c("#3D8E86", "#A58A5F", "#788A6F")) +
#'    theme_ctc_bronze(oxidation_level = "heavy") +
#'    labs(title = "Iris dataset in bronze style: heavy oxidation", color = "Species")
#'
#' # Example 2: Light oxidation mode (soft effect)
#' ggplot(mtcars, aes(x = wt, y = mpg, fill = factor(cyl))) +
#'    geom_point(pch = 21, size = 3) +
#'    scale_fill_manual(values = c("#A58A5F", "#788A6F", "#3D8E86")) +
#'    theme_ctc_bronze(oxidation_level = "light") +
#'    labs(title = "Car data: light oxidation style", fill = "Number of cylinders")
#'
#'     ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
#' geom_point(size = 3) +
#'    scale_color_ctc_d(palette_name = 52,direction = 1)+ # use ctc scale function
#'    theme_ctc_bronze(oxidation_level = "light") +
#'    labs(title = "Iris dataset in bronze style: heavy oxidation", color = "Species")



#' }
#' @export
theme_ctc_bronze <- function(
        base_size = 12,
        base_family = "STSong",
        grid_major = TRUE,
        grid_minor = FALSE,
        oxidation_level = "heavy"
) {
    # Heavy oxidation mode: enforced high contrast
    if (oxidation_level == "heavy") {
        # Background colors: close but hierarchical (ΔE=7.2, soft transition)
        plot_bg <- "#E6D9BE"    # Light brownish yellow
        panel_bg <- "#D4BE98"   # Bronze base

        # Text color: dark brown (ΔE=18.3 against light background)
        text_color <- "#301A12"  # Dark chestnut shell

        # Grid and border: rust green (accent without distraction)
        grid_color <- "#4A9E96"  # Dark bronze blue
        border_color <- "#3D8E86"
    } else {
        # Light oxidation mode (maintaining high-quality effect)
        plot_bg <- "#DFD6B8"
        panel_bg <- "#C4B798"
        text_color <- "#422517"
        grid_color <- "#756C4B"
        border_color <- "#3D8E86"
    }

    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(
            # Background colors: soft transition with clear hierarchy
            plot.background = element_rect(fill = plot_bg, color = NA),
            panel.background = element_rect(fill = panel_bg, color = border_color, linewidth = 0.4),

            # Text elements: all text using high-contrast color
            plot.title = element_text(
                color = text_color, size = base_size * 1.3, face = "bold",
                hjust = 0.5, margin = margin(b = 10)
            ),
            plot.subtitle = element_text(
                color = text_color, size = base_size * 0.95, hjust = 0.5, margin = margin(b = 15)
            ),
            plot.caption = element_text(
                color = text_color, size = base_size * 0.75, hjust = 1, margin = margin(t = 10)
            ),
            axis.title = element_text(
                color = text_color, size = base_size * 0.95, face = "bold"
            ),
            axis.text = element_text(
                color = text_color, size = base_size * 0.85  # Axis labels with enforced high contrast
            ),

            # Legend: text-background contrast ΔE=18.3
            legend.background = element_rect(fill = plot_bg, color = border_color, linewidth = 0.2),
            legend.title = element_text(color = text_color, size = base_size * 0.9, face = "bold"),
            legend.text = element_text(color = text_color, size = base_size * 0.85),  # Legend text with enforced high contrast

            # Grid lines and facet elements
            panel.grid.major = if (grid_major) element_line(
                color = grid_color, linetype = "dashed", linewidth = 0.25
            ) else element_blank(),
            panel.grid.minor = if (grid_minor) element_line(
                color = adjustcolor(grid_color, alpha.f = 0.6), linetype = "dotted", linewidth = 0.15
            ) else element_blank(),
            strip.background = element_rect(fill = border_color, color = text_color, linewidth = 0.3),
            strip.text = element_text(color = plot_bg, size = base_size * 0.9, face = "bold"),
            axis.line = element_line(color = text_color, linewidth = 0.35),
            plot.margin = margin(12, 12, 10, 12)
        )
}
