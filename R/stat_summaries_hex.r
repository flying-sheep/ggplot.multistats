#' Multi-Stat Binning Layer
#'
#' Very similar to \code{\link[ggplot2]{stat_summary_hex}}, but allows
#' for multiple stats to be captured using the \code{funs} parameter.
#'
#' @inheritParams ggplot2::stat_summary_2d
#' @param funs       A list or vector of functions and function names.
#'                   See \code{\link{normalize_function_list}} for details.
#' @param key_glyph  A legend key drawing function or a string providing
#'                   the function name minus the \code{draw_key_} prefix.
#'                   The default is \code{\link{draw_key_hexagon}}.
#'
#' @seealso
#' \code{\link{normalize_function_list}} for the \code{funs} parameter
#' and \code{\link{draw_key_hexagon}} for the legend entry.
#'
#' @examples
#' library(ggplot2)
#' # Define the variable used for the stats using z
#' ggplot_base <- ggplot(iris, aes(Sepal.Width, Sepal.Length, z = Petal.Width))
#' # The default is creating `after_stat(value)` containing the mean
#' ggplot_base + stat_summaries_hex(aes(fill = after_stat(value)), bins = 5)
#' # but you can specify your own stats
#' ggplot_base + stat_summaries_hex(
#'   aes(fill = after_stat(median), alpha = after_stat(n)),
#'   funs = c('median', n = 'length'),
#'   bins = 5)
#'
#' @importFrom methods formalArgs
#' @importFrom rlang %||% exec
#' @importFrom ggplot2 layer
#' @export
stat_summaries_hex <- function(
	mapping = NULL, data = NULL, geom = 'hex', position = 'identity',
	...,
	bins = 30, binwidth = NULL, drop = TRUE,
	funs = c(value = 'mean'), na.rm = FALSE,
	show.legend = NA, inherit.aes = TRUE,
	key_glyph = NULL
) {
	modern_args <- list()
	if ('key_glyph' %in% formalArgs(layer))
		modern_args$key_glyph <- key_glyph %||% draw_key_hexagon

	exec(
		layer,
		data = data, mapping = mapping,
		stat = StatSummariesHex, geom = geom, position = position,
		show.legend = show.legend, inherit.aes = inherit.aes,
		!!!modern_args,
		params = list(
			bins = bins, binwidth = binwidth, drop = drop,
			funs = funs, na.rm = na.rm,
			...
		)
	)
}

#' @importFrom ggplot2 ggproto Stat
#' @name stat_summaries_hex
#' @docType NULL
#' @export
StatSummariesHex <- ggproto(
	'StatSummariesHex',
	Stat,
	#default_aes = aes(fill = after_stat(value)),
	required_aes = c('x', 'y', 'z'),
	dropped_aes = c('z'),
	compute_group = function(
		data, scales,
		binwidth = NULL, bins = 30,
		drop = TRUE,
		funs = c(value = 'mean')
	) {
		if (is.null(binwidth)) binwidth <- ggplot2:::hex_binwidth(bins, scales)
		if (length(funs) < 1L) stop('You need to provide at least one function')

		funs <- as.list(normalize_function_list(funs))  # if it was no list before, adding a function makes it one
		funs$`_dummy` <- function(x) 1  # hexBinSummarise ruins our day if we have less than two items in the list
		idx_dummy <- names(funs) %in% '_dummy'
		if (sum(idx_dummy) > 1L) stop('You cannot name a function `_dummy`, sorry.')

		fun <- function(x) sapply(funs, exec, x, simplify = FALSE)

		v <- ggplot2:::hexBinSummarise(data$x, data$y, data$z, binwidth, fun = fun, drop = drop)
		v_new <-  do.call(rbind, lapply(v$value, function(line) as.data.frame(line[!idx_dummy])))
		v$value <- NULL
		cbind(v, v_new)
	}
)
