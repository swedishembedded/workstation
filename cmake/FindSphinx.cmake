# FindSphinx.cmake

find_program(SPHINX_EXECUTABLE
    NAMES sphinx-build
    HINTS $ENV{SPHINX_DIR}
    PATH_SUFFIXES bin
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sphinx
    FOUND_VAR Sphinx_FOUND
    REQUIRED_VARS SPHINX_EXECUTABLE
)

