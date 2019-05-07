#' Draw a Hexagon
#'
#' The default legend key drawing function for \code{\link{stat_summaries_hex}}.
#' This function can be used as \code{key_glyph} parameter by any layer.
#'
#' @inheritParams ggplot2::draw_key_polygon
#' @return A hexagonal \code{\link[grid]{polygonGrob}}.
#'
#' @seealso
#' The legend key drawing functions built into ggplot:
#' \code{\link[ggplot2]{draw_key}}.
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
#'   geom_hex(key_glyph = 'hexagon') +
#'   guides(fill = 'legend')
#'
#' @importFrom hexbin hexcoords
#' @importFrom grid unit polygonGrob gpar
#' @importFrom ggplot2 .pt
#' @importFrom scales alpha
#' @export
draw_key_hexagon <- function(data, params, size) {
	if (is.null(data$size))
		data$size <- .5
	lwd <- min(data$size, min(size)/4)

	dx <- dy <- .5
	hexC <- hexcoords(dx, dy / sqrt(3))

	x <- y <- unit(.5, 'npc')
	size <- unit(1, 'npc') - unit(lwd, 'mm')

	polygonGrob(
		x = hexC$x * size + x,
		y = hexC$y * size + y,
		gp = gpar(
			col = data$colour %||% NA,
			fill = alpha(data$fill %||% 'grey20', data$alpha),
			lty = data$linetype %||% 1,
			lwd = lwd * .pt,
			linejoin = params$linejoin %||% 'mitre',
			lineend = if (identical(params$linejoin, 'round')) 'round' else 'square'
		)
	)
}
