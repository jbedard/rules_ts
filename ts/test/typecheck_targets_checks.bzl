"""Loading-phase assertions for optional typecheck/transitive_typecheck target generation.

Any failure here surfaces when this package is loaded, so no test needs to run.
"""

load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//ts:defs.bzl", "ts_project")

def _assert_exists(name, expected):
    if bool(native.existing_rule(name)) != expected:
        fail("expected target '%s' %s exist" % (name, "to" if expected else "to NOT"))

def typecheck_targets_checks(name):
    """Instantiates ts_project variants and asserts which typecheck helper targets are generated.

    Args:
        name: name of a filegroup created so the macro follows naming conventions
    """
    write_file(
        name = "typecheck_gen_src",
        out = "typecheck_gen.ts",
        content = ["export const a: number = 1"],
    )

    # A no_emit ts_project generates all typecheck helper targets by default
    ts_project(
        name = "typecheck_targets_default",
        srcs = ["typecheck_gen.ts"],
        tsconfig = {},
        no_emit = True,
    )
    _assert_exists("typecheck_targets_default_typecheck", True)
    _assert_exists("typecheck_targets_default_typecheck_test", True)
    _assert_exists("typecheck_targets_default_transitive_typecheck", True)
    _assert_exists("typecheck_targets_default_transitive_typecheck_test", True)

    ts_project(
        name = "typecheck_targets_no_tests",
        srcs = ["typecheck_gen.ts"],
        tsconfig = {},
        no_emit = True,
        typecheck_test_targets = False,
    )
    _assert_exists("typecheck_targets_no_tests_typecheck", True)
    _assert_exists("typecheck_targets_no_tests_typecheck_test", False)
    _assert_exists("typecheck_targets_no_tests_transitive_typecheck", True)
    _assert_exists("typecheck_targets_no_tests_transitive_typecheck_test", False)

    ts_project(
        name = "typecheck_targets_minimal",
        srcs = ["typecheck_gen.ts"],
        tsconfig = {},
        no_emit = True,
        transitive_typecheck_targets = False,
        typecheck_test_targets = False,
    )
    _assert_exists("typecheck_targets_minimal_typecheck", True)
    _assert_exists("typecheck_targets_minimal_typecheck_test", False)
    _assert_exists("typecheck_targets_minimal_transitive_typecheck", False)
    _assert_exists("typecheck_targets_minimal_transitive_typecheck_test", False)

    native.filegroup(
        name = name,
        srcs = [
            "typecheck_targets_default_typecheck",
            "typecheck_targets_no_tests_typecheck",
            "typecheck_targets_minimal_typecheck",
        ],
    )
