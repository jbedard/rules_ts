"ts_typecheck_aspect"

_aspect_arr_attrs = ["deps", "data"]

# An aspect for collecting the ts_project "typecheck" output group across all
# transitive dependencies and adding it as a validation action.

def _ts_typecheck_aspect_impl(target, ctx):
    typechecks = []

    if OutputGroupInfo in target and "typecheck" in target[OutputGroupInfo]:
        typechecks.append(target[OutputGroupInfo]["typecheck"])

    for attr in _aspect_arr_attrs:
        if hasattr(ctx.rule.attr, attr):
            for dep in getattr(ctx.rule.attr, attr):
                if OutputGroupInfo in dep:
                    if "_transitive_typecheck_aspect" in dep[OutputGroupInfo]:
                        typechecks.append(dep[OutputGroupInfo]["_transitive_typecheck_aspect"])

    return [
        OutputGroupInfo(
            # TODO: does this overwrite existing validation actions? It APPEARS not.
            _validation = depset(transitive = typechecks),

            # TODO: why is this required in order to have the validation action run?
            # ... because of https://github.com/bazelbuild/bazel/issues/19636?
            _transitive_typecheck_aspect = depset(transitive = typechecks),
        ),
    ]

ts_typecheck_aspect = aspect(
    implementation = _ts_typecheck_aspect_impl,
    attr_aspects = _aspect_arr_attrs,
)
