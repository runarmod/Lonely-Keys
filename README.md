# Platformer

This is a game made with Lua and the framework [LOVE2D](https://love2d.org).
The tiles, players, enemies, items and HUD-elements are from the [Platformer Pack Redux](https://kenney.nl/assets/platformer-pack-redux) made by [Kenney.nl](https://kenney.nl/) with some slight modifications done by me.
The maps are made using [Tiled](https://www.mapeditor.org).

### TODO:
`No particular order`
- [ ] Find a name
- [ ] Fix all known bugs
    - [ ] Unducking cause issues when there is a block above (considering not fixing, not very noticable)
    - [ ] Player suddenly stop when walking on flat surface
    - [x] Coins duplicate when restarting (pressing R)
    - [x] Editing number of keys in Tiled messes up the HUD
    - [x] If user hasn't added a required layer in Tiled, it crashes
    - [ ] Land sound doesn't play when just falling of a ledge
    - [x] Possible to land on cloud startingpoint
- [x] Slow down when crouching
- [x] Add HUD
    - [ ] Level
    - [x] Lives (hearts)
    - [x] Have key or not
    - [x] Time
    - [x] FPS
    - [x] Score
    - [x] Highscore
    - [x] Coins
- [x] Switch to next level
- [ ] All levels complete
    - [x] Add startingscreen / tutoriallevel
        - [x] Change character
        - [x] Collecting coins
        - [x] Wasting time lowers score
        - [x] Keys
        - [x] Press E to go to next level when all available keys are collected
    - [ ] Complete level 1
    - [x] Add level 2
    - [x] Add level 3
    - [ ] Add level 4
- [x] Add key and lock
- [x] Add coins
- [x] Restart when dead
- [x] Spikes
- [x] Add gameoverscreen
- [x] Music
- [x] Soundeffects
    - [x] Coins
    - [x] Land
    - [x] Jump
    - [x] Key
    - [x] Hurt
- [x] Highscoresystem
