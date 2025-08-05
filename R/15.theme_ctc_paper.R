#'CTC Paper Theme for ggplot2

#' A theme inspired by traditional Chinese rice paper, with improved color harmony.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#'
#' @return A ggplot2 theme object that can be added to ggplot objects.
#'
#' @details
#' Recommended color combinations (carefully selected from 384 colors):
#' - **Discrete categories**: Qing Li (#422517), Shan Hu He (#C12C1F), Bi Shan (#779649), Qie Lan (#88ABDA)
#' - **Continuous gradients**:
#'   - Warm-toned gradient: Huang Bai You (#FFF799) → Xiang Ye (#ECD452) → Cang Huang (#B6A014) → Li Ke (#775039)
#'   - Cool-toned gradient: Tian Piao (#D5EBE1) → Cang Lang (#B1D5C8) → Piao Bi (#80A492) → Qing Li (#422517)
#'
#' The color names in comments (e.g., 凝脂, 玉色) are traditional Chinese color terms, preserving cultural connotations.
#'
#' @seealso
#' \code{\link{scale_color_ctc_d}},\code{\link{scale_fill_ctc_d}}
#' \code{\link{scale_color_ctc_c}}, \code{\link{scale_fill_ctc_c}}
#' \code{\link{scale_clor_ctc_m}}, \code{\link{scale_fill_ctc_m}}
#' for color or fill scales that pair well with this theme.
#'
#' @importFrom ggplot2 theme_bw element_rect element_text element_line margin
#' @import ggplot2
#'
#' @examples
#' \dontrun{
# Example 1: Scatter plot with discrete colors
#' showtext::showtext_auto()
#' font_add("zkt","C:\\Users\\czm\\AppData\\Local\\Microsoft\\Windows\\Fonts\\字酷堂清楷体.ttf")
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'     geom_point(size = 3) +
#'     scale_color_ctc_d(palette_name = 52,name = "品种图例")+
#'     theme_ctc_paper(base_family = "zkt") +
#'     labs(
#'         title = "鸢尾花数据可视化",
#'         subtitle = "基于萼片尺寸的分类",
#'         x = "萼片长度 (cm)",
#'         y = "萼片宽度 (cm)",
#'         caption = "数据来源: Fisher (1936)",
#'         color = "品种"
#'     )
#' # Example 2: Continuous color example
#' ggplot(mtcars, aes(x = reorder(rownames(mtcars), mpg), y = mpg, fill = hp)) +
#' geom_bar(stat = "identity") +
#'     scale_fill_ctc_c(palette_name = 10,name = "马力",direction = -1)+
#' theme_ctc_paper(grid_major = FALSE) +
#'     labs(
#'         title = "汽车性能对比",
#'         subtitle = "马力与燃油效率的关系",
#'         x = "车型",
#'         y = "每加仑英里数 (MPG)",
#'         caption = "数据来源：mtcars数据集"
#'     ) +
#'     coord_flip()
#' }
#'
#' @note For optimal Chinese display, it is recommended to use the \code{showtext} package to manage fonts, as demonstrated in the examples.
#' @export
theme_ctc_paper <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE
) {
    if (is.null(base_family)) {
        base_family <- setup_chinese_font()
    }
    theme_bw(base_size = base_size, base_family = base_family) %+replace%

        theme(
            # 背景色
            plot.background = element_rect(fill = "#F5F2E9", color = NA),  # 凝脂
            panel.background = element_rect(fill = "#EAE4D1", color = "#C7C6B6", linewidth = 0.3),  # 玉色，霜地

            # 文本元素
            plot.title = element_text(color = "#422517", size = base_size * 1.3, face = "bold", hjust = 0.5, margin = margin(b = 10)),  # 青骊
            plot.subtitle = element_text(color = "#A46244", size = base_size * 0.95, hjust = 0.5, margin = margin(b = 15)),  # 老僧衣
            plot.caption = element_text(color = "#C7C6B6", size = base_size * 0.75, hjust = 1, margin = margin(t = 10)),  # 霜地
            axis.title = element_text(color = "#422517", size = base_size * 0.95, face = "bold"),  # 青骊
            axis.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # 网格线
            panel.grid.major = element_line(color = "#E0E0D0", linetype = "dashed", linewidth = 0.3),  # 韶粉
            panel.grid.minor = element_line(color = "#EBEDDF", linetype = "dotted", linewidth = 0.2),  # 吉量

            # 图例
            legend.background = element_rect(fill = "#F5F2E9", color = "#C7C6B6", linewidth = 0.2),  # 凝脂，霜地
            legend.title = element_text(color = "#422517", size = base_size * 0.9, face = "bold"),  # 青骊
            legend.text = element_text(color = "#775039", size = base_size * 0.85),  # 栗壳

            # 其他元素
            axis.line = element_line(color = "#A46244", linewidth = 0.4),  # 老僧衣
            strip.background = element_rect(fill = "#E0E0D0", color = "#C7C6B6", linewidth = 0.3),  # 韶粉，霜地
            strip.text = element_text(color = "#422517", size = base_size * 0.9, face = "bold")  # 青骊
        )
}
