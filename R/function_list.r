map_lgl <- function(.x, .f, ...) vapply(.x, .f, logical(1L), ...)

#' Normalize a List of Functions
#'
#' Takes a list of functions and function names
#' (or a vector of function names) and names it.
#' Requires all entries with functions to be named and
#' adds names to functions that were specified as names.
#'
#' @param funs  Valid list or vector of function names and/or functions.
#' @return Named list or character vector of functions.
#'
#' @examples
#' normalize_function_list(c(value = 'mean'))
#' normalize_function_list(c('median', n = 'length'))
#' normalize_function_list(list('median', n = length))
#' normalize_function_list(list(Sum = sum, Custom = function(x) sum(nchar(as.character(x)))))
#'
#' @export
normalize_function_list <- function(funs) {
	fun_or_chr <- function(x) is.function(x) || is.character(x)

	if (is.function(funs))
		return(function(x) list(value = funs(x)))

	if (!is.character(funs) && !is.list(funs) || !all(map_lgl(funs, fun_or_chr)))
		stop('You need to provide either a function, a list of functions, or a character vector of function names, not a ', class(funs))

	if (is.null(names(funs)))
		names(funs) <- rep_len('', length(funs))
	if (any(map_lgl(funs[names(funs) == ''], is.function)))
		stop('If providing a list of functions, you need to name functions you pass, e.g. list(myfun = function(x) ..., "mean")')

	names(funs)[names(funs) == ''] <- funs[names(funs) == '']
	funs
}
