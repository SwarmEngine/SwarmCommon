cmake_minimum_required(VERSION 3.3)

project(SwarmCommon)

set(SWARM_COMMON_HEADERS
        src/engine/EngineTypes.h
)

foreach(Header ${SWARM_COMMON_HEADERS})
    install(FILES ${Header} DESTINATION include)
endforeach()