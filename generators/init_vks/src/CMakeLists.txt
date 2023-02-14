add_executable(
    init_vks
    main.cpp
)

target_link_libraries(
    init_vks 
    PRIVATE
    barretenberg
    env
)