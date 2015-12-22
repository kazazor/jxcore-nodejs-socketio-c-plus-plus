{
    "targets": [{
        "target_name": "wineAddon",
        "sources": [ "wine.cc" ],
        "conditions": [
            ['OS in "linux android mac ios"', {
                "ldflags": [ "-m elf_i386" ],
                "cflags_cc": [ "-fPIC -m32" ],
                'cflags': ['-std=c++0x', "-m32"],
                'cflags!': [ '-fno-tree-vrp' ],
                "architecture": "i386",
                "xcode_settings": {
                    'OTHER_CPLUSPLUSFLAGS': ['-std=c++11', '-stdlib=libstdc++'],
                    "GCC_ENABLE_CPP_EXCEPTIONS": "YES"
                }
            }]
        ]
    }]
}