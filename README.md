# turbo-paste
Turbo paste a.k.a [tpaste](https://tpaste.us)

Alpine Linux command line pastebin inspired by http://sprunge.us

Differences compared to sprunge:

* Based on Lua (Turbo lua framework)
* Backend using redis
* Syntax highlighting by highlight.js cdnjs

Requirements:

* [Turbo lua](https://github.com/kernelsauce/turbo)
* [Redis](https://redis.io/)
* [lua-redis](https://github.com/nrk/redis-lua)
* [Hashids lua](https://github.com/leihog/hashids.lua)
