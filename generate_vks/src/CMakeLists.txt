add_executable(
    test_main
    main.cpp
)

target_link_libraries(
    test_main
    PRIVATE
    barretenberg
    env
)