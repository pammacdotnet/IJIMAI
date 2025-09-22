#import "../minimal-template.typ": config, ijimai
#let config = toml(bytes(config))
#(config.at("authors").first().name = "Johannes Diderik van der Waals")
#(_ = config.paper.remove("short-author-list"))
#assert.eq(
  catch(() => ijimai(conf: config)[]),
  "assertion failed: Failed to generate short author list.\n"
    + "Please provide a custom value in the TOML file:\n"
    + "[paper]\nshort-author-list = \"<Your short list of authors>\"",
)
