/*
 * Copyright 2017 James De Broeck
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <string>
#include <stdexcept>


// *****************
//  Engine Typedefs
// *****************

namespace swarm {

    typedef     unsigned int    SWMenum;
    typedef     unsigned int    SWMuint;
    typedef     int             SWMint;
    typedef     int             SWMsizei;
    typedef     unsigned char   SWMboolean;
    typedef     float           SWMfloat;
    typedef     double          SWMdouble;

}



// *********************
//  Engine Enumerations
// *********************

namespace swarm {

    enum MemoryPrefix {
        MEM_BYTE = 1,
        MEM_KB = MEM_BYTE*1024,
        MEM_MB = MEM_KB*1024,
        MEM_GB = MEM_MB*1024
    };

    enum BitWidth {
        BIT_8 = 1,
        BIT_16 = 2,
        BIT_32 = 4,
        BIT_64 = 8
    };

}

namespace std {
    inline string to_string(swarm::MemoryPrefix pre) {
        switch(pre) {
            case swarm::MEM_BYTE: return "B";
            case swarm::MEM_KB: return "KB";
            case swarm::MEM_MB: return "MB";
            case swarm::MEM_GB: return "GB";
            default: return "";
        }
    }
    inline string to_string(swarm::BitWidth width) {
        switch(width) {
            case swarm::BIT_8: return "8-Bit";
            case swarm::BIT_16: return "16-Bit";
            case swarm::BIT_32: return "32-Bit";
            case swarm::BIT_64: return "64-Bit";
            default: return "";
        }
    }
}



// *******************
//  Engine Base Types
// *******************

namespace swarm {
    class SwarmException : public std::runtime_error {
    public:
        explicit SwarmException(const std::string& message) : runtime_error(message) {}
    };
}