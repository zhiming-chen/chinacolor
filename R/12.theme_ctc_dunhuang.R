#' CTC Dunhuang Theme for ggplot2
#'
#' A theme strictly inspired by Dunhuang murals (4th-14th century), featuring traditional mineral pigments
#' used in Buddhist art, such as cinnabar red, malachite green, and lapis lazuli blue. All colors are
#' selected from your 384-color list to maintain cultural authenticity.
#'
#' @param base_size Base font size (default: 12pt). Recommended for murals: 14pt for better readability.
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE, mimicking the grid of mural layouts).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param border_style Character: "simple" (thin border) or "ornate" (thick border, imitating mural frames, default: "ornate").
#'
#' @return A ggplot2 theme object with Dunhuang mural aesthetics.
#'
#' @details
#' Classic color schemes of Dunhuang murals (strictly selected from the 384-color list):
#' - **Base background colors**:
#'   - Huangrun (#DFD6B8) — simulates the earth-yellow ground layer of murals;
#'   - Jianxiang (#D5C8A0) — imitates the silk-like beige background
#' - **Major mineral pigments**:
#'   - Cinnabar series: Shanhuhe (#C12C1F) — corresponding to cinnabar red in murals
#'   - Malachite series: Shilu (#206864), Erlu (#5DA39D) — for layered rendering effects
#'   - Azurite series: Qunqing (#2E59A7), Dishiqing (#003460) — imitating lapis lazuli color
#' - **Text color**: Huaqing (#1A2847) — high contrast with earth-yellow background, imitating mural inscriptions
#'
#' @seealso
#' \code{\link{scale_color_ctc_d}},\code{\link{scale_fill_ctc_d}}
#' \code{\link{scale_color_ctc_c}}, \code{\link{scale_fill_ctc_c}}
#' \code{\link{scale_clor_ctc_m}}, \code{\link{scale_fill_ctc_m}}
#' for color or fill scales that pair well with this theme.
#'
#' @importFrom ggplot2 theme_bw element_rect element_text element_line margin
#' @import ggplot2
#' @examples
#' \dontrun{
#' # Example 1: Scatter plot mimicking Dunhuang mural figures
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 4, alpha = 0.9) +  # Translucency simulates mural fading
#'   scale_color_manual(values = c(
#'     "#2E59A7",  # Qunqing (imitating lapis lazuli)
#'     "#C12C1F",  # Shanhuhe (imitating cinnabar)
#'     "#206864"   # Shilu (imitating malachite)
#'   )) +
#'   theme_ctc_dunhuang(border_style = "ornate") +
#'   labs(
#'     title = "Iris data · Dunhuang style",
#'     subtitle = "Color scheme inspired by Mogao Cave 323 murals",
#'     x = "Sepal length (cm)",
#'     y = "Sepal width (cm)",
#'     caption = "Data source: Fisher (1936) | Color reference: Dunhuang Research Academy",
#'     color = "Species"
#'   )
#'
#' # Example 2: Bar plot with mural gradient
#' pal_test <- palette_list$seq010$hex
#' diamonds %>%
#'   filter(cut %in% c("Ideal", "Premium", "Good")) %>%
#'   group_by(cut, color) %>%
#'   summarise(avg_price = mean(price)) %>%
#'   ggplot(aes(x = cut, y = avg_price, fill = color)) +
#'   geom_col(position = "dodge", linewidth = 0.4, color = "#1A2847") +  # Huaqing border imitating mural lines
#'   scale_fill_manual(values = pal_test) +
#'   theme_ctc_dunhuang(grid_major = FALSE) +
#'   labs(
#'     title = "Diamond price comparison · Dunhuang mineral colors",
#'     x = "Cut grade",
#'     y = "Average price (USD)",
#'     fill = "Color grade"
#'   ) +
#'   theme(axis.text.x = element_text(angle = 30, hjust = 1))
#' }
#' @export
theme_ctc_dunhuang <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        border_style = "ornate"
) {

        if (is.null(base_family)) {
            base_family <- setup_chinese_font()
        }

    # Adjust border width by style (imitating mural border thickness)
    border_width <- ifelse(border_style == "ornate", 0.6, 0.3)

    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(
            # Background colors: simulate mural ground layer (earth yellow) and main panel (light brown)
            plot.background = element_rect(
                fill = "#DFD6B8",  # Huangrun — imitates mural base earth yellow
                color = NA
            ),
            panel.background = element_rect(
                fill = "#D5C8A0",  # Jianxiang — imitates silk-like light brown
                color = "#206864",  # Shilu — imitates malachite green mural borders
                linewidth = border_width
            ),

            # Title text: imitates mural inscriptions (cinnabar title, indigo explanations)
            plot.title = element_text(
                color = "#C12C1F",  # Shanhuhe — imitates cinnabar inscriptions
                size = base_size * 1.4,
                face = "bold",
                hjust = 0.5,
                margin = margin(b = 12),
                lineheight = 1.2  # Enhance readability
            ),
            plot.subtitle = element_text(
                color = "#1A2847",  # Huaqing — imitates ink annotations
                size = base_size * 1.05,
                hjust = 0.5,
                margin = margin(b = 15)
            ),
            plot.caption = element_text(
                color = "#775039",  # Lique — imitates small character notes
                size = base_size * 0.8,
                hjust = 1,
                margin = margin(t = 10)
            ),

            # Axis text: high contrast for clarity (indigo/malachite with earth yellow background)
            axis.title = element_text(
                color = "#1A2847",  # Huaqing
                size = base_size * 1.0,
                face = "bold",
                margin = margin(r = 5, t = 5)
            ),
            axis.text = element_text(
                color = "#206864",  # Shilu
                size = base_size * 0.9,
                margin = margin(5, 5, 5, 5)
            ),
            axis.text.x = element_text(angle = 0, hjust = 0.5),  # Avoid rotation to preserve mural feel

            # Grid lines: imitate faint divisions in murals (bronze blue/secondary green, low interference)
            panel.grid.major = if (grid_major) element_line(
                color = "#3D8E86",  # Tongqing — imitates faint green mural divisions
                linetype = "dashed",
                linewidth = 0.25
            ) else element_blank(),
            panel.grid.minor = if (grid_minor) element_line(
                color = "#5DA39D",  # Erlu — lighter auxiliary divisions
                linetype = "dotted",
                linewidth = 0.15
            ) else element_blank(),

            # Legend: imitates donor frames in murals
            legend.background = element_rect(
                fill = "#DFD6B8",  # Huangrun (consistent with plot background)
                color = "#206864",  # Shilu border
                linewidth = 0.3
            ),
            legend.title = element_text(
                color = "#C12C1F",  # Shanhuhe (echoes main title)
                size = base_size * 0.95,
                face = "bold"
            ),
            legend.text = element_text(
                color = "#1A2847",  # Huaqing
                size = base_size * 0.85
            ),
            legend.key = element_rect(fill = "#D5C8A0"),  # Jianxiang (consistent with panel background)

            # Facet elements: imitate segmented borders in murals
            strip.background = element_rect(
                fill = "#C12C1F",  # Shanhuhe (cinnabar-colored divisions)
                color = "#206864",  # Shilu border
                linewidth = border_width
            ),
            strip.text = element_text(
                color = "#DFD6B8",  # Huangrun (contrast with cinnabar background)
                size = base_size * 0.95,
                face = "bold",
                margin = margin(5, 5, 5, 5)
            ),

            # Axis lines: imitate ink outlines in murals
            axis.line = element_line(
                color = "#1A2847",  # Huaqing (imitates ink lines)
                linewidth = 0.35
            ),

            # Overall margins: simulate mounting margins of murals
            plot.margin = margin(15, 15, 10, 15)
        )
}
