add_executable(
    proof_generator
    main.cpp
)


target_link_libraries(
    proof_generator
    PRIVATE
    barretenberg
    env
)

add_executable(
    init_vks
    init_vks.cpp
)

target_link_libraries(
    init_vks
    PRIVATE
    barretenberg
    env
)