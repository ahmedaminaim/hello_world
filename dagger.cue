package main

import (
    "strings"
    "dagger.io/dagger"
    "dagger.io/dagger/core"
)

dagger.#Plan & {
    client: commands: {

        complie: {
            name: "./complie.sh"
        }
        sha256Sum: {
            name: "sha256sum"
            // args: ["helloworld/bin/Release/net6.0/MyApp.dll", "helloworld/bin/Release/net6.0/MyApp.deps.json"]
            args: ["helloworld/bin/Release/net6.0/MyApp.dll"]

        }
    }
                    
    actions: {
    
        complie: {
            _complie: core.#Nop & {
                // we access the command's output via the `stdout` field
                input: strings.TrimSpace(client.commands.complie.stdout)
            }
            // action outputs for debugging
            complie: _complie.output

        }

        hash: {

            _calculate_sha256: core.#Nop & {
                // we access the command's output via the `stdout` field
                input: strings.TrimSpace(client.commands.sha256Sum.stdout)
            }
            
            sha256: _calculate_sha256.output
        }
    }
}