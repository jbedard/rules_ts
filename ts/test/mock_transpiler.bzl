"Fixture to demonstrate a custom transpiler for ts_project"

load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@aspect_rules_js//js:defs.bzl", "js_library")

_DUMMY_SOURCEMAP = """{"version":3,"sources":["%s"],"mappings":"AAAO,KAAK,CAAC","file":"in.js","sourcesContent":["fake"]}"""

def mock(name, srcs, **kwargs):
    """Mock transpiler macro.

    In real usage you would wrap a rule like
    https://github.com/aspect-build/rules_swc/blob/main/docs/swc.md

    Args:
        name: name
        srcs: all source files/targets
        **kwargs: other generic args
    """

    outs = []

    for s in srcs:
        if s.endswith(".ts") and not s.endswith(".d.ts"):
            js_out = s.replace(".ts", ".js")
            map_out = s.replace(".ts", ".js.map")

            copy_file(
                name = "_{}_{}_js".format(name, s),
                src = s,
                out = js_out,
                **kwargs
            )

            write_file(
                name = "_{}_{}_map".format(name, s),
                out = map_out,
                content = [_DUMMY_SOURCEMAP % s],
                **kwargs
            )

            outs.append(js_out)
            outs.append(map_out)

    js_library(
        name = name,
        srcs = outs,
    )
