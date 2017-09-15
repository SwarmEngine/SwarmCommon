cmake_minimum_required(VERSION 3.3)

project(SwarmEngineBase)

set(SWARM_BASE_HEADERS
        src/engine/EngineTypes.h
)

foreach(Header ${SWARM_BASE_HEADERS})
    install(FILES ${Header} DESTINATION include)
endforeach()

install(FILES src/cmake/SwarmEngineBase.cmake DESTINATION cmake)