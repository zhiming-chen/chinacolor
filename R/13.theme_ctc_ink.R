#' CTC Ink Theme for ggplot2
#'
#' A theme inspired by traditional Chinese ink wash painting aesthetic, featuring the "five shades of ink" technique,
#' implemented using colors selected from the 384-color palette.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family (default: "SimHei" for Chinese compatibility).
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#'
#' @return A ggplot2 theme object.
#'
#' @details
#' This theme emulates the subtle tonal variations of traditional Chinese ink wash painting,
#' where five gradations of ink (from pale to dense) create depth and texture. Key design elements:
#'
#' - **Background layers**:
#'   - Plot background uses "Qianshan Cui" (#86908A) — a muted teal-green mimicking aged paper;
#'   - Panel background uses "Jie Lü" (#6B7D73) — a soft jade-green hue evoking ink-washed silk.
#'
#' - **Ink gradations**: Colors are selected to reflect the "five shades" concept:
#'   - Dense ink: "Qing Li" (#422517) — deep brownish-black for primary text;
#'   - Medium ink: "Laoseng Yi" (#A46244) — warm sepia for accents and axis lines;
#'   - Light ink: "Li Ke" (#775039) — chestnut brown for axis text;
#'   - Very light ink: "Shuang Di" (#C7C6B6) — pale grayish-beige for borders and captions;
#'   - Wash layers: "Lv Yun" (#45493D) and "Ou Si Qiu Ban" (#D3CBC5) — muted greens/browns for grid lines,
#'     simulating diluted ink washes.
#'
#' @examples
#' \dontrun{
#' # Example 1: Color scatter plot
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_manual(
#'     values = c(
#'       "#C12C1F",  # Shanhu He (coral red)
#'       "#779649",  # Bi Shan (jade green)
#'       "#88ABDA"   # Qie Lan (pale blue)
#'     )
#'   ) +
#'   theme_ctc_ink() +
#'   labs(
#'     title = "Iris sepal size distribution",
#'     x = "Sepal length (cm)",
#'     y = "Sepal width (cm)",
#'     color = "Species"
#'   )
#'
#' # Example 2: Heatmap (using sequential palette)
#' library(reshape2)
#' corr_data <- cor(mtcars)
#' corr_melted <- melt(corr_data)
#' ggplot(corr_melted, aes(x = Var1, y = Var2, fill = value)) +
#'   geom_tile(linewidth = 0.3, color = "#6B798E") +  # Song Lan (indigo)
#'   scale_fill_gradientn(
#'     colors = c(
#'       "#13393E",  # Luo Zi Dai (deep indigo)
#'       "#354E6B",  # Qing Que Tou Dai (cobalt)
#'       "#88ABDA",  # Qie Lan (pale blue)
#'       "#D5EBE1"   # Tian Piao (pale aqua)
#'     ),
#'     name = "Correlation coefficient"
#'   ) +
#'   theme_ctc_ink(grid_major = FALSE) +
#'   labs(
#'     title = "Correlation analysis of car performance parameters",
#'     x = NULL,
#'     y = NULL
#'   ) +
#'   theme(axis.text.x = element_text(angle = 45, hjust = 1))
#' }
#'
#' @export
theme_ctc_ink <- function(
        base_size = 12,
        base_family = "SimHei",
        grid_major = TRUE,
        grid_minor = FALSE
) {
    theme_bw(base_size = base_size, base_family = base_family) %+replace%

        theme(
            # Background colors
            plot.background = element_rect(fill ="#86908A",  color = NA),  # 千山翠
            panel.background = element_rect(fill = "#6B7D73", color = "#C7C6B6", linewidth = 0.3),  # 结绿，霜地

            # Text elements
            plot.title = element_text(color = "#422517", size = base_size * 1.3, face = "bold", hjust = 0.5, margin = margin(b = 10)),  # 青骊
            plot.subtitle = element_text(color = "#A46244", size = base_size * 0.95, hjust = 0.5, margin = margin(b = 15)),  # 老僧衣
            plot.caption = element_text(color = "#C7C6B6", size = base_size * 0.75, hjust = 1, margin = margin(t = 10)),  # 霜地
            axis.title = element_text(color = "#422517", size = base_size * 0.95, face = "bold"),  # 青骊
            axis.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # Grid lines
            panel.grid.major = element_line(color = "#45493D", linetype = "dashed", linewidth = 0.3),  # 绿云
            panel.grid.minor = element_line(color = "#D3CBC5", linetype = "dotted", linewidth = 0.2),  # 藕丝秋半

            # Legend
            legend.background = element_rect(fill = "#6B7D73", color = "#C7C6B6", linewidth = 0.2),  # 千山翠，霜地
            legend.title = element_text(color = "#422517", size = base_size * 0.9, face = "bold"),  # 青骊
            legend.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # Other elements
            axis.line = element_line(color = "#A46244", linewidth = 0.4),  # 老僧衣
            strip.background = element_rect(fill = "#D3CBC5", color = "#C7C6B6", linewidth = 0.3),  # 藕丝秋半，霜地
            strip.text = element_text(color = "#422517", size = base_size * 0.9, face = "bold")  # 青骊
        )
}
