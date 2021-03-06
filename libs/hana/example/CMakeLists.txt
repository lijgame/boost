# Copyright Louis Dionne 2013-2017
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.md or copy at http://boost.org/LICENSE_1_0.txt)

add_custom_target(examples COMMENT "Build all the examples.")
add_dependencies(check examples)


##############################################################################
# Caveats: Take note of examples that are not supported.
##############################################################################
if (NOT Boost_FOUND)
    list(APPEND EXCLUDED_EXAMPLES
        "ext/boost/*.cpp"
        "tutorial/appendix_mpl.cpp"
        "tutorial/ext/fusion_to_hana.cpp"
        "tutorial/ext/mpl_vector.cpp"
        "tutorial/integral.cpp"
        "tutorial/introduction.cpp"
        "tutorial/mpl_cheatsheet.cpp"
        "tutorial/quadrants.cpp"
        "tutorial/quickstart.switchAny.cpp"
        "tutorial/rationale.container.cpp"
        "tutorial/type.cpp"
        "type/basic_type.cpp"
    )
endif()


##############################################################################
# Add all the examples
##############################################################################
file(GLOB_RECURSE EXAMPLES "*.cpp")
file(GLOB_RECURSE EXCLUDED_EXAMPLES ${EXCLUDED_EXAMPLES})
list(REMOVE_ITEM EXAMPLES "" ${EXCLUDED_EXAMPLES})

# Several examples have unused parameters because the name of the parameters
# are useful for illustration, even if the implementation is not actually
# presented. We don't want to generate warnings for that or need to comment
# out all unused parameter names.
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag(-Wno-unused-parameter BOOST_HANA_HAS_WNO_UNUSED_PARAMETER)

foreach(_file IN LISTS EXAMPLES)
    boost_hana_target_name_for(_target "${_file}")
    add_executable(${_target} EXCLUDE_FROM_ALL "${_file}")
    add_test(${_target} ${CMAKE_CURRENT_BINARY_DIR}/${_target})
    boost_hana_set_test_properties(${_target})
    if (BOOST_HANA_HAS_WNO_UNUSED_PARAMETER)
        target_compile_options(${_target} PRIVATE -Wno-unused-parameter)
    endif()
    add_dependencies(examples ${_target})
endforeach()
