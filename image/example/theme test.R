
color_pick <- create_color_pick(color_id = c(20,68,120,172,276,312))
color_pick_2 <- create_color_pick(color_id = c(17,65,117,169,273,309))
pal <- ctc_palette(type = "custom",color_pick = color_pick,show_colors = T)
pal_2 <- ctc_palette(type = "custom",color_pick = color_pick_2,show_colors = T)

plotdata <- data.frame(sex = factor(rep(c("F", "M"), each=200)),
                       weight = c(rnorm(200, 55), rnorm(200, 58)))

P <- ggdensity(plotdata,
          x = "weight",
          add = "mean",
          rug = TRUE,    # x轴显示分布密度
          color = "sex",
          fill = "sex",
          palette = pal[2:3])

P_2 <- ggdensity(plotdata,
               x = "weight",
               add = "mean",
               rug = TRUE,    # x轴显示分布密度
               color = "sex",
               fill = "sex",
               palette = c("#A2D2E2", "#D3CBC5")
               )

P_2+
# scale_color_ctc_d(palette_name = 82,direction = -1)+
#     scale_fill_ctc_d(palette_name = 82,direction = -1)+
    theme_ctc_ink()


P + theme_ctc_ink()
P + theme_ctc_paper()
P + theme_ctc_bronze()
P + theme_ctc_dunhuang()
P + theme_ctc_mineral()

p2 <- gghistogram(plotdata,
            x = "weight",
            bins = 30,
            add = "mean",
            rug = TRUE,
            color = "sex",
            fill = "sex",
            palette = pal[2:3])

p2 + theme_ctc_paper()

df <- ToothGrowth
my_comparisons <- list( c("0.5", "1"), c("1", "2"), c("0.5", "2") )

p3 <- ggviolin(df,
               x = "dose",
               y = "len",
               fill = "dose",
               palette = pal,
               add = "boxplot",
               add.params = list(fill = "white"))+
    stat_compare_means(comparisons = my_comparisons, label = "p.signif")+ # Add significance levels
    stat_compare_means(label.y = 50)

p3 + theme_ctc_dunhuang



# 示例1：彩色散点图（使用您提供的颜色）
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 3) +
  scale_color_manual(
    values = pal_3[4:6]
  ) +
  theme_ctc_ink() +
  labs(
    title = "鸢尾花萼片尺寸分布",
    x = "萼片长度 (cm)",
    y = "萼片宽度 (cm)",
    color = "品种"
  )
