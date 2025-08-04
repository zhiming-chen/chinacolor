#' CTC Mineral Theme for ggplot2
#'
#' A theme implemented using 384 colors, emphasizing the rich saturation and vividness of traditional mineral pigments, which have been used in Chinese art for millennia.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family (default: "KaiTi" — suited for Chinese calligraphic style).
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#'
#' @return A ggplot2 theme object.
#'
#' @details
#' This theme draws inspiration from traditional mineral pigments—naturally occurring inorganic substances prized in historical Chinese art for their intense, lightfast colors. The design balances these vivid pigments with complementary background tones to enhance readability while preserving authenticity.
#'
#' Key design features:
#' - **Background layers**: Subtle, earthy greens ("Jia Tan" #CAD7C5 for plot background and "Bing Tai" #BECAB7 for panel background) create a neutral canvas that makes mineral pigments stand out.
#' - **Recommended color schemes** (all from the 384-color list):
#'   - Discrete data: High-saturation mineral color combinations such as "Qun Qing" (#2E59A7, lapis lazuli blue) + "Shan Hu He" (#C12C1F, cinnabar red) + "Bi Shan" (#779649, malachite green).
#'   - Continuous data: Monochromatic gradients within mineral families, e.g., "Qie Lan" (#88ABDA, pale azurite) → "Qun Qing" (#2E59A7, deep lapis) or "Shui Hong" (#ECB0C1, light carmine) → "Shan Hu He" (#C12C1F, rich cinnabar).
#' - **Text and accents**: Warm browns and sepia tones ("Qing Li" #422517, "Lao Seng Yi" #A46244) provide clear contrast without competing with the vivid mineral pigments.
#'
#' @examples
#' \dontrun{
#' # Example 1: Categorical scatter plot (using high-saturation mineral colors)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_manual(
#'     values = c(
#'       "#2E59A7",  # Qun Qing (lapis lazuli blue)
#'       "#C12C1F",  # Shan Hu He (cinnabar red)
#'       "#779649"   # Bi Shan (malachite green)
#'     )
#'   ) +
#'   theme_ctc_mineral() +
#'   labs(
#'     title = "Iris species comparison",
#'     x = "Sepal length (cm)",
#'     y = "Sepal width (cm)",
#'     color = "Species"
#'   )
#'
#' # Example 2: Stacked bar plot (using mineral color series)
#' library(dplyr)
#' ggplot(mpg %>% count(class, drv), aes(x = class, y = n, fill = drv)) +
#'   geom_col(position = "stack", linewidth = 0.3, color = "#80A492") +  # Piao Bi (border color)
#'   scale_fill_manual(
#'     values = c(
#'       "#A67C52",  # Zhe Shi (ochre)
#'       "#B8860B",  # Hu Po (amber)
#'       "#D2B48C"   # Zong He Se (sienna)
#'     )
#'   ) +
#'   theme_ctc_mineral(grid_major = FALSE) +
#'   labs(
#'     title = "Distribution of car classes by drive type",
#'     x = "Car class",
#'     y = "Count",
#'     fill = "Drive type"
#'   ) +
#'   theme(axis.text.x = element_text(angle = 45, hjust = 1))
#' }
#'
#' @export
theme_ctc_mineral <- function(
        base_size = 12,
        base_family = "KaiTi",
        grid_major = TRUE,
        grid_minor = FALSE
) {
    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(
            # 背景色
            plot.background = element_rect(fill = "#CAD7C5", color = NA),  # 葭菼
            panel.background = element_rect(fill = "#BECAB7", color = "#C7C6B6", linewidth = 0.3),  # 冰台，霜地

            # 文本元素
            plot.title = element_text(color = "#422517", size = base_size * 1.3, face = "bold", hjust = 0.5, margin = margin(b = 10)),  # 青骊
            plot.subtitle = element_text(color = "#A46244", size = base_size * 0.95, hjust = 0.5, margin = margin(b = 15)),  # 老僧衣
            plot.caption = element_text(color = "#C7C6B6", size = base_size * 0.75, hjust = 1, margin = margin(t = 10)),  # 霜地
            axis.title = element_text(color = "#422517", size = base_size * 0.95, face = "bold"),  # 青骊
            axis.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # 网格线
            panel.grid.major = element_line(color = "#B3BDA9", linetype = "dashed", linewidth = 0.3),  # 青古
            panel.grid.minor = element_line(color = "#C0AD5E", linetype = "dotted", linewidth = 0.2),  # 栾华

            # 图例
            legend.background = element_rect(fill = "#CAD7C5", color = "#C7C6B6", linewidth = 0.2),  # 葭菼，霜地
            legend.title = element_text(color = "#422517", size = base_size * 0.9, face = "bold"),  # 青骊
            legend.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # 其他元素
            axis.line = element_line(color = "#A46244", linewidth = 0.4),  # 老僧衣
            strip.background = element_rect(fill = "#B3BDA9", color = "#C7C6B6", linewidth = 0.3),  # 青古，霜地
            strip.text = element_text(color = "#422517", size = base_size * 0.9, face = "bold")  # 青骊
        )
}
