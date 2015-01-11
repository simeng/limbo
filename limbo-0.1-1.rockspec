package = "Limbo"
version = "0.1-1"
source = {
    url = "git://github.com/simeng/limbo",
    tag = "v0.1"
}
description = {
    summary = "A client for the Imbo image server.",
    detailed = [[
        A client for the Imbo image server
        https://github.com/imbo/imbo
    ]],
    homepage = "https://github.com/simeng/limbo",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1",
    "sha2 >= 0.2",
    "cjson >= 2.0"
}
build = {
    type = "builtin",
    modules = {

    },
    copy_directories = { "tests" }
}

