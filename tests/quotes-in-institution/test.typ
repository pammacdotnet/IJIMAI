#import "../minimal-template.typ": config, ijimai
#let config = toml(bytes(config))
#let institution-with-quotes = "A nice university \"ABC\", somewhere"
#(config.at("authors").first().institution = institution-with-quotes)
#show: ijimai.with(config: config)
