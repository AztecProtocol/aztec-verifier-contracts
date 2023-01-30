add_executable(
    generate_keys_and_proofs
    main.cpp
)

target_link_libraries(
    generate_keys_and_proofs
    PRIVATE
    barretenberg
    env
)