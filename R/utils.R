#' Find Palette (Internal Function)
#'
#' Retrieves palette data by index/name/Chinese or English name.
#'
#' @param palette Palette identifier, supports:
#'   - Numeric index (1-20)
#'   - Element name (e.g. "seq01")
#'   - Chinese name (e.g. "樱霞晕彩")
#'   - English name (e.g. "cherry_blush")
#' @return List containing palette data with structure:
#' \describe{
#'   \item{hex}{Vector of HEX color codes}
#'   \item{name}{Vector of color names}
#'   \item{palette_name}{Chinese palette name}
#'   \item{palette_name_e}{English palette name}
#'   \item{type}{Type (sequential/diverging/qualitative)}
#'   \item{color_count}{Number of colors}
#' }
#' @keywords internal
#' @noRd

find_palette <- function(palette) {
    if (missing(palette)) {
        stop("Palette identifier required. See available options with list_palettes()",
             call. = FALSE)
    }

    # Numeric index
    if (is.numeric(palette)) {
        if (!palette %in% seq_along(palette_list)) {
            stop(sprintf(
                "Invalid index %s (valid: 1-%s). Run list_palettes() to see options",
                palette,
                length(palette_list)
            ), call. = FALSE)
        }
        return(palette_list[[palette]])
    }

    # Character input
    if (is.character(palette)) {
        # Exact name match
        idx <- match(tolower(palette), tolower(names(palette_list)))
        if (!is.na(idx)) return(palette_list[[idx]])

        # Fuzzy name match
        matches <- vapply(palette_list, function(x) {
            tolower(palette) %in% tolower(c(x$palette_name, x$palette_name_e))
        }, logical(1))

        if (any(matches)) return(palette_list[[which(matches)[1]]])
    }

    # No matches found
    stop(sprintf(
        "Palette '%s' not found. Valid identifiers:\n- Index (1-%s)\n- Element name (e.g. 'seq01')\n- Chinese/English names\nRun list_palettes() for complete reference",
        palette,
        length(palette_list)
    ), call. = FALSE)
}


#' Validate Color Values and Convert to Uniform Hexadecimal Format (Internal)
#'
#' @description Internal helper function to validate color specifications and convert them
#' to standardized uppercase hexadecimal format. Not intended for direct user interaction.
#'
#' Supports:
#' 1. Standard hex colors ("#FF0000", "#F00")
#' 2. R built-in named colors ("red")
#' 3. rgb()/hsv()/hcl() function calls ("rgb(255,0,0)")
#'
#' @param colors Character vector of color values to validate.
#'
#' @return List with two components:
#' \itemize{
#'   \item \code{valid}: Character vector of valid colors in uppercase hex format
#'   \item \code{invalid}: Data frame containing:
#'         \itemize{
#'           \item \code{position}: Input vector index
#'           \item \code{value}: Original invalid value
#'         }
#' }
#'
#' @details
#' This internal function performs strict validation:
#' 1. Hex values must match regex \code{^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$}
#' 2. Named colors must be in \code{grDevices::colors()}
#' 3. Function calls are evaluated in restricted environment (only basic math operators allowed)
#'
#' Transparency (alpha) channels are not supported. All outputs are 6-character uppercase hex.
#'
#' @noRd
#' @keywords internal
validate_colors <- function(colors) {
    valid_hex <- character(length(colors))
    invalid_pos <- integer(0)
    invalid_val <- character(0)
    valid_count <- 0

    # Create secure evaluation environment
    safe_env <- new.env(parent = emptyenv())
    safe_env$c <- base::c
    safe_env$rgb <- grDevices::rgb
    safe_env$hsv <- grDevices::hsv
    safe_env$hcl <- grDevices::hcl
    safe_env$pi <- pi
    safe_env$`(` <- base::`(`

    # Add basic math operators
    math_ops <- c("+", "-", "*", "/", "%%", "%/%", "^", "(", "{", "=")
    for (op in math_ops) safe_env[[op]] <- get(op, envir = baseenv())

    for (i in seq_along(colors)) {
        color <- trimws(colors[i])

        # Case 1: Validate hex format
        if (grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", color)) {
            hex <- ifelse(nchar(color) == 4,
                          paste0("#", substr(color,2,2), substr(color,2,2),
                                 substr(color,3,3), substr(color,3,3),
                                 substr(color,4,4), substr(color,4,4)),
                          color)
            valid_count <- valid_count + 1
            valid_hex[valid_count] <- toupper(hex)
            next
        }

        # Case 2: Validate named colors
        if (color %in% grDevices::colors()) {
            rgb_vals <- grDevices::col2rgb(color)
            valid_count <- valid_count + 1
            valid_hex[valid_count] <- toupper(grDevices::rgb(
                rgb_vals[1], rgb_vals[2], rgb_vals[3],
                maxColorValue = 255
            ))
            next
        }

        # Case 3: Validate color function calls
        if (grepl("^(rgb|hsv|hcl)\\s*\\(", color, ignore.case = TRUE)) {
            tryCatch({
                parsed <- eval(parse(text = color, n = 1), envir = safe_env)

                if (is.character(parsed) &&
                    length(parsed) == 1 &&
                    grepl("^#[A-Fa-f0-9]{6}$", parsed)) {
                    valid_count <- valid_count + 1
                    valid_hex[valid_count] <- toupper(parsed)
                    next
                }
            }, error = function(e) NULL)
        }

        # Record invalid if all checks fail
        invalid_pos <- c(invalid_pos, i)
        invalid_val <- c(invalid_val, color)
    }

    # Return optimized structure
    list(valid = valid_hex[seq_len(valid_count)],
         invalid = if (length(invalid_pos) ){
             data.frame(position = invalid_pos, value = invalid_val, stringsAsFactors = FALSE)
         } else {
             data.frame(position = integer(0), value = character(0))
         }
    )

}

#' Generate Contrast Colors
#'
#' Automatically generate black/white or analogous contrast colors based on input colors
#'
#' @param hex HEX value(s) of the original color(s)
#' @param type Type of contrast color: "mono" (black/white) or "analog" (analogous)
#' @param threshold Lightness threshold (0-1), default 0.6
#' @param delta Brightness offset value for analogous colors (0-1), default 0.4
#' @param output_format Output format: "hex" (default) or "hsl"
#'
#' @return HEX values or HSL matrix of contrast colors
#' @examples
#' # Generate black and white contrast color
#' generate_contrast_color("#3498db")
#'
#' # Generate analogous contrast color (smaller offset)
#' generate_contrast_color("#3498db", "analog", delta = 0.3)
#' @noRd
#' @keywords internal

generate_contrast_color <- function(hex, type = "mono", threshold = 0.6,
                                    delta = 0.4, output_format = "hex") {
    # Validate input
    if (!type %in% c("mono", "analog")) {
        stop("type parameter must be 'mono' or 'analog'", call. = FALSE)
    }

    if (threshold < 0 || threshold > 1) {
        stop("threshold parameter must be between 0 and 1", call. = FALSE)
    }

    if (delta < 0 || delta > 1) {
        stop("delta parameter must be between 0 and 1", call. = FALSE)
    }

    # Convert HEX to HSL
    hsl <- hex_to_hsl(hex)

    # Apply contrast color logic
    result <- t(apply(hsl, 1, function(row) {
        h <- row[1]
        s <- row[2]
        l <- row[3]

        if (type == "mono") {
            # Black and white mode
            if (l > threshold) return(c(h, s, 0))   # Use black for dark backgrounds
            else return(c(h, s, 1))                 # Use white for light backgrounds
        } else {
            # Analogous color mode
            if (l > threshold) {
                new_l <- max(l - delta, 0)  # Cannot be lower than 0
            } else {
                new_l <- min(l + delta, 1)  # Cannot be higher than 1
            }
            return(c(h, s, new_l))
        }
    }))

    # Set column names
    colnames(result) <- c("h", "s", "l")

    # Format output
    if (output_format == "hex") {
        return(apply(result, 1, hsl_to_hex))
    } else {
        return(result)
    }
}

# Helper function: HEX to HSL (corrected version)
hex_to_hsl <- function(hex) {
    # Convert HEX to RGB
    rgb_mat <- col2rgb(hex)

    # Calculate HSL
    hsl <- apply(rgb_mat, 2, function(rgb_val) {
        r <- rgb_val[1]/255
        g <- rgb_val[2]/255
        b <- rgb_val[3]/255

        max_val <- max(r, g, b)
        min_val <- min(r, g, b)
        delta <- max_val - min_val

        # Calculate lightness
        l <- (max_val + min_val)/2

        # Calculate saturation
        s <- if (delta == 0) 0 else delta/(1 - abs(2*l - 1))

        # Calculate hue
        h <- 0
        if (delta != 0) {
            if (max_val == r) h <- ((g - b)/delta) %% 6
            else if (max_val == g) h <- (b - r)/delta + 2
            else h <- (r - g)/delta + 4
            h <- h * 60
        }

        # Normalize hue
        h <- h %% 360
        if (is.nan(h)) h <- 0

        c(h, s, l)
    })

    t(hsl)  # Transpose to have one color per row
}

# Helper function: HSL to HEX
hsl_to_hex <- function(hsl) {
    h <- hsl[1]
    s <- hsl[2]
    l <- hsl[3]

    # Conversion formula
    c <- (1 - abs(2*l - 1)) * s
    x <- c * (1 - abs((h/60) %% 2 - 1))
    m <- l - c/2

    # Calculate RGB based on hue range
    if (h < 60) {
        rgb_val <- c(c, x, 0)
    } else if (h < 120) {
        rgb_val <- c(x, c, 0)
    } else if (h < 180) {
        rgb_val <- c(0, c, x)
    } else if (h < 240) {
        rgb_val <- c(0, x, c)
    } else if (h < 300) {
        rgb_val <- c(x, 0, c)
    } else {
        rgb_val <- c(c, 0, x)
    }

    # Apply lightness correction and convert to HEX
    rgb_final <- rgb_val + m
    rgb_final <- pmax(pmin(rgb_final, 1), 0)
    rgb(rgb_final[1], rgb_final[2], rgb_final[3])
}

