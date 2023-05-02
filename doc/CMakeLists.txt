cmake_minimum_required(VERSION 3.12)

project(MyProjectDocs LANGUAGES NONE)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

# Find Sphinx and make sure it is installed
find_package(Sphinx REQUIRED)

# Set the source and build directories for the documentation
set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR})
set(SPHINX_BUILD ${CMAKE_CURRENT_BINARY_DIR}/_build)

# Configure Sphinx options
set(SPHINX_CONF_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(SPHINX_CACHE_DIR ${CMAKE_CURRENT_BINARY_DIR}/_doctrees)

# Create a custom target to build the documentation using Sphinx
add_custom_target(Sphinx ALL
    COMMAND ${SPHINX_EXECUTABLE} -b html
            -c ${SPHINX_CONF_DIR}
            -d ${SPHINX_CACHE_DIR}
            ${SPHINX_SOURCE} ${SPHINX_BUILD}
    COMMENT "Building HTML documentation with Sphinx"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

