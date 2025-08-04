#' Create a color_pick List for ctc_palette Function
#'
#' This function helps users easily create a properly formatted `color_pick` list
#' required by the `ctc_palette()` function, specifically for selecting colors from the `chinacolor` dataset.
#'
#' @param color_id A vector of specific color IDs to include (directly selected from `chinacolor`).
#' @param groups A vector of group numbers to filter colors from (based on `chinacolor$group_id`).
#' @param subgroups A list where each element corresponds to subgroups (1-4 or -1) for the respective group in `groups`.
#'   Use `-1` to reverse the order of subgroups (equivalent to `4:1`). If `NULL`, defaults to all subgroups (1:4) for each group.
#' @param order_rule Sorting rule for the selected colors:
#'   `1` (preserve input order), `0` (sort by color ID ascending), or `-1` (sort by color ID descending). Defaults to `1`.
#'
#' @return A properly structured `color_pick` list compatible with `ctc_palette(type = "custom")`.
#'
#' @details
#' All color selections are derived from the `chinacolor` dataset, which contains colors categorized by `group`, `subgroup`, and `color_id`.
#' - If `groups` are specified, colors are first filtered by group and subgroup.
#' - `color_id` allows direct inclusion of specific colors, which are appended to the group/subgroup selections.
#' - Duplicate colors (from overlapping group/subgroup and `color_id` selections) are automatically removed while preserving order.
#' @examples
#' \dontrun{
#' # Example 1: Select colors by specific IDs
#' color_pick <- create_color_pick(color_id = c(4, 8, 12))
#'
#' # Example 2: Select colors by groups and subgroups
#' color_pick <- create_color_pick(
#'   groups = c(35, 27),
#'   subgroups = list(c(2, 4), c(1, 3))  # Subgroups for group 35 and 27 respectively
#' )
#'
#' # Example 3: Combine group selection with specific IDs and sort by ID
#' color_pick <- create_color_pick(
#'   color_id = c(4, 8, 12),
#'   groups = c(35, 27),
#'   subgroups = list(-1, c(1, 3)),  # -1 = reverse subgroup order (4:1)
#'   order_rule = 0  # Sort by color ID ascending
#' )
#' }
#' @seealso
#' \code{\link{ctc_palette}}: Function that uses the `color_pick` list for custom palette generation.
#' \code{chinacolor}: The underlying data containing color metadata (groups, subgroups, and IDs).
#'
#' @export
create_color_pick <- function(color_id = NULL,
                              groups = NULL,
                              subgroups = NULL,
                              order_rule = 1) {
    # Initialize the result list
    color_pick <- list()

    # Process color_id
    if (!is.null(color_id)) {
        color_pick$color_id <- color_id
    }

    # Process groups and subgroups
    if (!is.null(groups)) {
        # Validate groups is a vector (not a list)
        if (!is.vector(groups) || is.list(groups)) {
            stop("'groups' must be a vector (not a list)")
        }

        # Handle subgroups
        if (!is.null(subgroups)) {
            # Ensure subgroups is a list
            if (!is.list(subgroups)) {
                subgroups <- list(subgroups)
            }

            # Validate subgroups length matches groups or is 1 (recycled)
            if (length(subgroups) != length(groups) && length(subgroups) != 1) {
                stop("'subgroups' must have the same length as 'groups' or be a single element")
            }

            # Recycle subgroups if length 1
            if (length(subgroups) == 1 && length(groups) > 1) {
                subgroups <- rep(subgroups, length(groups))
            }

            # Validate subgroup values (1-4 or -1)
            for (i in seq_along(subgroups)) {
                s <- subgroups[[i]]
                if (!all(s %in% c(1:4, -1))) {
                    stop(paste("Subgroups for group", groups[i], "must only contain 1-4 or -1"))
                }
            }
        } else {
            # Default to all subgroups (1:4) if not specified
            subgroups <- rep(list(1:4), length(groups))
        }

        # Add group information to color_pick
        color_pick$group_info <- list(
            group = groups,
            subgroup = subgroups
        )
    }

    # Validate and set order rule
    if (!order_rule %in% c(1, 0, -1)) {
        stop("'order_rule' must be 1 (input order), 0 (ID ascending), or -1 (ID descending)")
    }
    color_pick$order <- order_rule

    return(color_pick)
}
