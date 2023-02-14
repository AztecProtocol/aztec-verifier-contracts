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