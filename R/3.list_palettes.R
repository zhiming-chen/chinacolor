#' List Available Color Palettes
#'
#' Display a searchable table of all available color palettes with their identifiers,
#' including index numbers, element names, and Chinese/English names.
#'
#' @return An interactive DT table (in Shiny) or printed list (in console)
#' @export
#' @examples
#' \dontrun{
#' list_palettes()  # Console output
#' }
list_palettes <- function() {
    # base data
    palette_df <- data.frame(
        Index = seq_along(palette_list),
        ElementName = names(palette_list),
        ChineseName = sapply(palette_list, function(x) x$palette_name %||% NA_character_),
        EnglishName = sapply(palette_list, function(x) x$palette_name_e %||% NA_character_),
        Type = sapply(palette_list, function(x) x$type %||% NA_character_),
        Colors = sapply(palette_list, function(x) x$color_count %||% NA_integer_),
        stringsAsFactors = FALSE
    )

    #  ）the dataframe for return result without colors_preview info
    return_df <- palette_df

    # 交互式环境处理
    if (interactive() && requireNamespace("DT", quietly = TRUE)) {
        # 安全创建颜色预览
        color_preview <- vapply(palette_list, function(x) {
            tryCatch({
                colors <- x$hex
                if (is.null(colors)) return("")
                if (length(colors) == 0) return("")

                # 验证颜色格式
                colors <- sapply(colors, function(c) {
                    if (grepl("^#?[0-9A-Fa-f]{6}$", c) ||
                        grepl("^#?[0-9A-Fa-f]{8}$", c)) {
                        if (!startsWith(c, "#")) return(paste0("#", c))
                        return(c)
                    }
                    return(NA_character_)
                })

                valid_colors <- colors[!is.na(colors)]
                if (length(valid_colors) == 0) return("")

                # 创建颜色条
                paste0(
                    '<div style="display:flex; height:24px; border:1px solid #eee; border-radius:3px;">',
                    paste0(
                        '<div style="flex:1; background:', valid_colors,
                        '; position:relative;" title="', valid_colors, '"></div>',
                        collapse = ""
                    ),
                    '</div>'
                )
            }, error = function(e) {
                warning("Error creating preview for palette: ", conditionMessage(e))
                return("")
            })
        }, character(1))

        # 在显示用的DF中添加颜色预览列（放在第二列）
        display_df <- cbind(
            palette_df[, 1, drop = FALSE],  # Index列
            ColorPreview = color_preview,    # 颜色预览列
            palette_df[, -1]                 # 其他所有列
        )

        # 创建数据表
        dt <- DT::datatable(
            display_df,
            rownames = FALSE,
            filter = "top",
            options = list(
                pageLength = 20,
                dom = 'tip',
                scrollX = TRUE,
                columnDefs = list(
                    list(
                        targets = 1,  # 颜色预览列现在是第2列
                        width = "200px",
                        render = DT::JS(
                            "function(data, type, row) {",
                            "  return type === 'display' ? data : '';",
                            "}")
                    )
                )
            ),
            escape = FALSE
        )

        print(dt)
    }

    # 返回干净的dataframe（不含颜色预览列）
    invisible(return_df)
}

# NULL安全的操作符
`%||%` <- function(x, y) if (is.null(x)) y else x
