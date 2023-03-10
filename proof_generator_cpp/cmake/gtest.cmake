if(TESTING)
    include(GoogleTest)
    include(FetchContent)

    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        # Version 1.12.1 is not compatible with WASI-SDK 12
        GIT_TAG release-1.10.0 
    )

    FetchContent_GetProperties(googletest)
    if(NOT googletest_POPULATED)
        FetchContent_Populate(googletest)
        add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR} EXCLUDE_FROM_ALL)
    endif()

    # Disable all warning when compiling gtest
    target_compile_options(
        gtest
        PRIVATE
        -w
    )

    if(WASM)
        target_compile_definitions(
            gtest
            PRIVATE
            -DGTEST_HAS_EXCEPTIONS=0
            -DGTEST_HAS_STREAM_REDIRECTION=0)
    endif()

    mark_as_advanced(
        BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
        gmock_build_tests gtest_build_samples gtest_build_tests
        gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
    )

    enable_testing()
endif()
