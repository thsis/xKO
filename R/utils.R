#' Create a Blog Post
#'
#' Initializes a directory in the \code{posts} directory of the blog.
#' @param title title of blog post
#' @keywords internal
create_post <- function(title, slug = NULL) {
  slug <- if (is.null(slug)) slugify(title) else slug
  qmd <- file.path("blog", "posts", slug, "index.qmd")
  if (!file.exists(qmd)) {
    dir.create(dirname(qmd), recursive = TRUE, showWarnings = FALSE)
    usethis::use_template(
      "post.qmd",
      save_as = qmd,
      data = list(title = title, date = Sys.Date()),
      package = "xKO"
    )
  }
}


slugify <- function(x) {
  x |> stringr::str_to_lower(title) |> stringr::str_replace_all(" ", "-")
}
