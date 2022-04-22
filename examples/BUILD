load("//ts:defs.bzl", "ts_config")
load("@npm//:node_modules.bzl", "node_modules")

exports_files(["tsconfig-base.json"])

ts_config(
    name = "tsconfig",
    src = "tsconfig-base.json",
    visibility = ["//:__subpackages__"],
)

node_modules()
