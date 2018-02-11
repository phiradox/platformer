//
//  Levels.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 11/11/16.
//  Copyright © 2016 Ariston Kalpaxis. All rights reserved.
//

import Foundation

struct Levels {
    var data: [(blocks: [String], script: (_ gameScene: GameScene) -> ())] = [
        (blocks: [
            "                                                                        ",
            "                                                                        ",
            " ∞                                    0                                 ",
            "XXX                       ‹‹‹‹‹XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X",
            "                                     LLL       ~        8X    ^        =",
            "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL   LLL       ~      MMMM    ^v       =",
            "L                                L L LLL       ~             ^ v       =",
            "L                               6L   LLL       ~MMMM         ^  v      =",
            "X   XXXX                   XXXXGGG   LLL       ~      MM    ^   v      =",
            "=                                    LLL       ~            ^    v     =",
            "=                                    LLL       ~           ^     v     =",
            "=                                    LLL       ~  M  MM    ^      v    =",
            "= XXX                                LLL       ~  X  X    ^       v  XX=",
            "=                                    LLL   7   ~  X!!X    ^        v  9=",
            "=                                    XXXXXXXXXXXMMMMMMMMMXXXXXXXXXXXXXXX",
            "=   X                                                                   ",
            "=  5X                                                                   ",
            "= GGGGGG                        X<<<<<<<<<<<<<<<<<<<<<<<<<<<            ",
            "=                               !X                  X      G            ",
            "=                                X                  X      G            ",
            "=                                X                  X      G4           ",
            "=                              X X                  XG GGG GXXXX        ",
            "=                                X                  X    G G            ",
            "=                                X           X      X    G G            ",
            "=                                X           X      X    G G            ",
            "=                                X           X      X    G G      XXXX  ",
            "=                                X          2X      X    G G            ",
            "=                                XBBBBBX XXXXXVVVVVVXGG GGFGGGG         ",
            "=                                      X X               G              ",
            "=                                      X X               G              ",
            "=                                      X X               G              ",
            "=            TTTTTTTTT                 X X               G      XXXX    ",
            "=@              XXX       XX      GGGBBX X          3  GGG              ",
            "GGGG   GGGGGGG   X        X1        X    X   GGGGGGGGG   G              ",
            "  X!!!!!X        X        XGGGGGR   XXXXXX      XXX      G              ",
            "  XXXXXXX                  XXXXX       X         X       GXXXX          "
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.1, g: 0.3, b: 0.5, a: 1), topRight: Color(r: 0.2, g: 0.4, b: 0.6, a: 1), bottomLeft: Color(r: 0.3, g: 0.5, b: 0.7, a: 1), bottomRight: Color(r: 0.4, g: 0.6, b: 0.8, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 1, g: 0, b: 0, a: 1))
        }
        ), (blocks: [
                "                         OO                             ",
                "                         OO                             ",
                "          O        O              O          O          ",
                " @                                                     W",
                "XXX      XXX      XXX    XX      XXX        XXX      XXX",
                "         X!!!!!!!!!!!!!!!!!!!!!!!!!X                    ",
                "         XXXXXXXXXXXXXXXXXXXXXXXXXXX                    "
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.4, g: 0.4, b: 0.4, a: 1), topRight: Color(r: 0.4, g: 0.4, b: 0.4, a: 1), bottomLeft: Color(r: 0.4, g: 0.4, b: 0.4, a: 1), bottomRight: Color(r: 0.4, g: 0.4, b: 0.4, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0, g: 1, b: 0, a: 1))
        }), (blocks: [
                "XXXXXXXXXXXXXX",
                "X    O   O  WX",
                "X            X",
                "X            X",
                "X    !   !   X",
                "X    ! O !   X",
                "X    ! O !   X",
                "X    !   !   X",
                "XBBBBXXXXXXXXX",
                "X           !X",
                "X            X",
                "X    OO      X",
                "X    OO      X",
                "X            X",
                "XXXX    XXX  X",
                "X!!!!!!!!!X  X",
                "XXXXXXXXXXXBBX",
                "X         X  X",
                "X         X!OX",
                "X         X  X",
                "XBBBBBXBBOX  X",
                "X     X   X  X",
                "X     XOBBXBBX",
                "X  O  X      X",
                "X     XBBB   X",
                "X     XOOO  !X",
                "XBBBBBXXXXXXXX",
                "X            X",
                "X            X",
                "X            X",
                "X            X",
                "X            X",
                "XBBBBB  BBBBBX",
                "X            X",
                "X  O O  O O  X",
                "X   O    O   X",
                "X@           X",
                "XXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.016, g: 0.012, b: 0.043, a: 1), topRight: Color(r: 0.016, g: 0.031, b: 0.102, a: 1), bottomLeft: Color(r: 0.051, g: 0.165, b: 0.263, a: 1), bottomRight: Color(r: 0.067, g: 0.220, b: 0.255, a: 1))
                
                gameScene.prepareAmbience(colored: Color(r: 1, g: 1, b: 1, a: 1))
        }), (blocks: [
                "XXXXXXXXXXXXXXXX",
                "X@             X",
                "XXXXXXVVVVXXXXXX",
                "X              X",
                "X              X",
                "X OO        OO X",
                "X OO        OO X",
                "X     VVVV     X",
                "X    X!!!!X    X",
                "VVVVVVXXXXVVVVVV",
                "X              X",
                "X   O O O O O  X",
                "X  O O O O O   X",
                "X              X",
                "XXXXXXXXVVXXXXXX",
                "       X       X",
                "       XXXXXX  X",
                "               X",
                "               X",
                "               X",
                "  O    OO    O X",
                "               X",
                "  VV   VV   VVVV",
                "  X!!!!!!!!!!!!X",
                "  XXXXXXXXXXXXXX",
                "   V           V",
                "   V          XO",
                "   V        VVX ",
                "   V          X ",
                "   V VVVV     XO",
                "   V V        X ",
                "   V V        X ",
                "   V V!!!!!!!!XO",
                "XXXXXXXXXXXXXXXV",
                "X!!!!!          ",
                "X!!!!     OO   O",
                "X!!!            ",
                "X!!     VVVVVV  ",
                "X!              ",
                "X     X       XX",
                "X    !X!!!!!!!!X",
                "XW  !!X!!!!!!!!X",
                "XXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.431, g: 0.153, b: 0.071, a: 1), topRight: Color(r: 0.651, g: 0.259, b: 0.129, a: 1), bottomLeft: Color(r: 0.894, g: 0.620, b: 0.243, a: 1), bottomRight: Color(r: 0.996, g: 0.831, b: 0.384, a: 1))
                
                gameScene.prepareAmbience(colored: Color(r: 0, g: 1, b: 1, a: 1))
        }), (blocks: [
                "            X!!!!X                  ",
                "            X    X       XXXXXXXXXXX",
                "!XXXXXXXXXXXX    XXXXXXXXXW        X",
                "    O O     XFX  X       X  O      X",
                "   O O O    X X  X       X         X",
                "    O O     X X  X       XFFFF     X",
                "            X X  X       X         X",
                "O FFFFFFFF  X X  X       X        FX",
                "            X X  X       X         X",
                "OX!!!!!!!!X O X  V     @ X    OO   X",
                " XXXXXXXXXXXXXXRXXX!!!XXXX    OO FFX",
                "O   X  OO  OO  X  O                X",
                "    X XFFFFFFX X  X   O      FFFF  X",
                "    X X!!!!!!X    XRRRX            X",
                "XXFXXBXXXXXXXXXXXXX              OOX",
                "                                 OOX",
                "            O           FFFF OO    X",
                "         O     O             OO  RRX",
                " XXXXXXXRFRFRFRFRXXXXXX            X",
                "        !!!!!!!!!           RRRR   X"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.706, g: 0.341, b: 0.863, a: 1), topRight: Color(r: 0.863, g: 0.322, b: 0.482, a: 1), bottomLeft: Color(r: 0.376, g: 0.682, b: 0.980, a: 1), bottomRight: Color(r: 0.133, g: 0.110, b: 0.694, a: 1))
                
                gameScene.prepareAmbience(colored: Color(r: 0, g: 0, b: 1, a: 1))
        }), (blocks: [
                "           OO        OO    X    ",
                " @                         !    ",
                "XXXX>>>>>>XXXX<<<<<<XXXX>>>>XXX ",
                "X                               ",
                "X                    FFXX<<<<<<X",
                "X OO         FFFF<<<<XXX       X",
                "X OXXRRRR<<<<XXXX      X XXXXX X",
                "X OO XOOOOO            XOOOOOXOX",
                "X    XXXX>>> >         XBBBB XOX",
                "X            X>              XOX",
                "XXXXX>>>>>>>>XX>>>>>>>><><><>X X",
                "X                              X",
                "X                              X",
                "X                              X",
                "X                              X",
                "X       OO        O<<     OO   X",
                "X  O   >><< >OO  >>      >><<XXX",
                "X O<<        <<<      >> V  OOOX",
                "XW X!!!!!!!!!!!!!!!!!!!X V  OOOX",
                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.357, g: 0.086, b: 0.165, a: 1), topRight: Color(r: 0.600, g: 0.016, b: 0.047, a: 1), bottomLeft: Color(r: 0.988, g: 0.337, b: 0.125, a: 1), bottomRight: Color(r: 0.976, g: 0.988, b: 0.859, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 1, g: 0, b: 0, a: 1))
        }), (blocks: [
                "       X!!!!XXXXXXXXX!!XXXXXXXXXTTTTX",
                "       X             !!             X",
                "       X             !!             X",
                "       X    X        !!             X",
                "       X    XXXX     !!     XXXXTT  X",
                "       X    X  X     !!     XTTX    X",
                "XXXXXXXX       X     !!     XOOX    X",
                "X      X       X            XOOX  TTX",
                "X  @   X    X  X            X  X    X",
                "X  XX  X   XX  X            X  X    X",
                "X  XX  X    X  X            X  X    X",
                "X      X    XOOX            XX TTT  X",
                "X      V    XOOX            X  O    X",
                "XXXXXXXXXXXXXXXXTTTTTTTTTTTTX  O    X",
                "            X      !     !OOX  O    X",
                "            XW     !     !OOX  TTTTTX",
                "            XXXX            X       X",
                "               X            X       X",
                "               X            TTTTTT  X",
                "               X                    X",
                "               X      !             X",
                "               X      !             X",
                "               XTTTTTTTTTTTTTTTTTTTTX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.796, g: 0.184, b: 0.192, a: 1), topRight: Color(r: 0.176, g: 0.863, b: 0.447, a: 1), bottomLeft: Color(r: 0.102, g: 0.549, b: 0.525, a: 1), bottomRight: Color(r: 1.000, g: 0.996, b: 0.835, a: 1))
                
                gameScene.prepareAmbience(colored: Color(r: 1.000, g: 0.980, b: 0.443, a: 1))
        }), (blocks: [
                "              IIIIIIIIIIIIIIIIIIIIIII W ",
                "              IO                    I  L",
                "              IIII IIIIIIIIIIIIIIII IL  ",
                "              IO   I          I     I L ",
                "              II IIII IIIIII III IIII  L",
                "              I       I       I     IL  ",
                "              IIIIIIIIII IIIIIIIIII I L ",
                "              IOO         IOO       I  L",
                "              IIII  IIIIIIIIII  IIIIIL  ",
                "@  !   !      X         X           X L ",
                "XXXXXXXXXXXX  X   OO    X  XXXXXXXXXX  L",
                "X    LLLL     X   II    XO X    X       ",
                "X   LLLLLL    X         X  X    X LOLOL ",
                "X  LLL  LLL   X         X OX  TOX O     ",
                "X LLL    LL   X         X  X  X X L !!!!",
                "X LL          X         XO X  X X O     ",
                "X O           X II      X  X  X X LOL   ",
                "X L!!!!!!!!X  X         X OX  X X   O   ",
                "X O XXXXXXXXXXX         X  X  X X   L   ",
                "X!L X                II X  X  X X!  O   ",
                "X O X                   X  X  X XX! L   ",
                "X L!X                   X  X  X XXX! L  ",
                "X                       X  X  X XXXX  L ",
                "X           II          X  X  X TXXX  L ",
                "X     II            OO  X  TT X  TXX  L ",
                "X                   II  X     X   TX!!L ",
                "XXXX                    X     X    TXXL ",
                "   X                    X     X      XL ",
                "   X                    X     X       L ",
                "   X!!!!!!!!!!!!!!!!!!!!XTTTTTXTTTTTXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.953, g: 0.922, b: 0.659, a: 1), topRight: Color(r: 0.976, g: 0.965, b: 0.992, a: 1), bottomLeft: Color(r: 0.063, g: 0.075, b: 0.133, a: 1), bottomRight: Color(r: 0.071, g: 0.094, b: 0.165, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 1.0, g: 1.0, b: 0, a: 1.0))
        }), (blocks: [
                "X                        X",
                "X                        X",
                "X                        X",
                "X                      OOX",
                "X@                     OOX",
                "MMMM  MM  MM  MM  MM  MMMM",
                "    !!  !!    X !!  !!    ",
                "X O           XXXXXXXXXXXX",
                "X             X          X",
                "XXXXVVXXXXXXXXX          X",
                " L X  X            XXXX~~X",
                "LOLX  X            X!X~~~X",
                " L X  X            X!~~~~!",
                "LOLX~~X   MMMMMRRRRX!~~~~!",
                " L X  X   X!!!!!!!!!!~~~!!",
                "          X          ~~!!!",
                "          X          ~~!!!",
                "          X  X~~~~~~~XX  X",
                "          X   RXXXXXX    X",
                "          X   X          X",
                "TTTTTTTTTTX~~!       XX~~X",
                "X       !!!~~!    XXX!!~~!",
                "X       !!~~~!   XOX!!~~~!",
                "X       !~~~~!  XOOX!~~~~!",
                "X       !~~~!! X!OX!~~~~~!",
                "X       !~~~!! X~OX!~~~~!!",
                "X        ~~~!! X OX!~~~! W",
                "X        ~~!!! X X!~~~~! X",
                "X   XXXXXXXXXX X X!~~~!  X",
                "X              X   ~~~   X",
                "XXXXXXXXXXXXXXRXXXXXXMMMMX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.173, g: 0.071, b: 0.169, a: 1), topRight: Color(r: 0.318, g: 0.027, b: 0.200, a: 1), bottomLeft: Color(r: 0.725, g: 0.165, b: 0.247, a: 1), bottomRight: Color(r: 0.992, g: 0.427, b: 0.282, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0, g: 1, b: 0, a: 1.0))
        }), (blocks: [
                "        XXXXXXXXXXXXXXXXXXXXXXXXXX ",
                "        X       ^      X         X ",
                "        X      ^ v     X        OX ",
                "        X     ^   v    X     ><X X ",
                "        X    ^     v   X       !O! ",
                "        X   ^       v  X   <<<<! ! ",
                " @      V  ^ O  O  O v V       !O! ",
                "XXXXXXXXXXXXXXXXXXXXXXXXX>>>>>>X X ",
                "X                 v           v    ",
                "X                 v           v    ",
                "X              LLLvLLL LLLvLLL LLL ",
                "X              LLLvLLL LLLvLLL LLL ",
                "XOO          IILLL LLLvLLL LLL LLL ",
                "XOO                   v            ",
                "XII      II                        ",
                "X          !!!!!!!!!!!!!!!!!!!!!!!!",
                "X    II    !   v          !!     WX",
                "X!!!!      !     v     v  !!     OX",
                "XXX      II!     v v   v  ~~~~   OX",
                "X          !       v v v  OOOO   MX",
                "XOO  II !!!!       v v v    MM    X",
                "XOO                  v v    XX MM X",
                "XII                  v      XX XX X",
                "XXXXXXXXXXXXMMMMMMMMMMMMMMXXXX XX X"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.953, g: 0.741, b: 0.686, a: 1), topRight: Color(r: 0.776, g: 0.514, b: 0.518, a: 1), bottomLeft: Color(r: 0.243, g: 0.416, b: 0.439, a: 1), bottomRight: Color(r: 0.384, g: 0.259, b: 0.388, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0, g: 0, b: 1.0, a: 1.0))
        }), (blocks: [
                "   M  XXXXXXXXXXXXXXXXXXX",
                "   =  X O =   =         X",
                "   =  X O =   =       X X",
                "X  =  X X =   =      XX X",
                "=  X  X = = X =     XXX X",
                "=  X  X = = = =      =X X",
                "=  X! = X = = =      =X X",
                "=  X! = X = = =X     =X X",
                "=  X! = X = = =      =X X",
                "=  X! = X = = =      =X X",
                "=  =  = X = = =      =X X",
                "=  =  = X = = =      =X X",
                "X  =  X X = = =      =X X",
                "   =  X X X = =      =X X",
                "   =  X X   = =     X=X X",
                "   = !X X   = =      =X X",
                "   = XX X   = =      =X X",
                "   =  T X   = =      =X X",
                "   =    X   = =      =X X",
                "   =    X   = =      =X X",
                "   =    X   = =X     =X X",
                "@  =    X   = =      =X X",
                "XXXXTTTTXXX X =      =X X",
                "XTTT    TTX X =      =X X",
                "X         X X =      =X X",
                "X         X X X      =X X",
                "X TTTTTT  XvX V      =X X",
                "X      X  XXXXXXXXXXXXX X",
                "X      X  TTTTTTTTTTTTT X",
                "X      X                X",
                "X     WX                X",
                "XXXXXXXXTTTTTTTTTTTTTTTTX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.035, g: 0.224, b: 0.412, a: 1), topRight: Color(r: 0.373, g: 0.725, b: 0.906, a: 1), bottomLeft: Color(r: 0.090, g: 0.569, b: 0.714, a: 1), bottomRight: Color(r: 0.078, g: 0.106, b: 0.184, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 1.0, g: 0, b: 0, a: 1.0))
        // MARK: Super Level 2
        }), (blocks: [
            "                                   LLLLLLLL  L          X",
            "   XXXXXLLLLLLLLLLLLLLLLLLLLLLLLLX          LLL         X",
            "  X     XLLLLLLLLLLLLLLLLLLLLLLLX            L          X",
            " X       XL0LLLLLLLLLLLLLLLLL9LX            XXXLLLXXX   X",
            "X   LLL   XXXXXXXXXXXXXXXXXXXXX                X8X      X",
            "X  LLLLL   L ‹‹‹             L                  X  L  X X",
            "X  LL6LL   L        ›››      L                    LLL X X",
            "X  LLLLL   L   ›››        ‹‹‹L               M~~X  L  X X",
            "X   LLL   XXXXXXXXXXXXXXXXXXXXX       M~~~M M        X  X",
            " X       X                     X     M     M      XXX   X",
            "  X     X                       X   M   7               X",
            "   XBBBX                         XXXXXXXXXXXXXXXXXXXXXXXX",
            "                                        X  LLLLL        X",
            " 5                                     XXX LLLLL        X",
            "GGG GGG                  ‹‹‹GGG   GGG      LL3LL        X",
            "                             G     4   XXX LLLLL        X",
            "                                  GGG   X  LLLLL        X",
            "                                 XXXXXXXXXXXXXXXXX     XX",
            "                                 X!!!!!!!!!!!!!!X       X",
            "                                 X              X       X",
            "                                 X              X       X",
            "                                 XBBBXBBBBBBBBBXXX      X",
            "                                 XBBBBBBBBBBBBBBB       X",
            "                                 XBBBBBBBBBBBBBXXX      X",
            "                                 BBBBBBBBBBBBBBBX       X",
            "                                 XBBBBBBXBBBBBBBX       X",
            "  @                        1     X      X       X      2X",
            " GGG                      GGG           X             GGX",
            "XXXXX!!!!!!!!XXX!!!!!!!!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.generateBackground(topLeft: Color(r: 0.133, g: 0.412, b: 0.388, a: 1), topRight: Color(r: 0.765, g: 0.133, b: 0.149, a: 1), bottomLeft: Color(r: 0.808, g: 0.216, b: 0.118, a: 1), bottomRight: Color(r: 0.439, g: 0.729, b: 0.161, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0, g: 1, b: 0, a: 1.0))
        }),
        (blocks: [
            "                O          O            ",
            " OOOOOOO  G     G    G     G         G  ",
            "W                                       ",
            "XXXXXXXXX                               ",
            "                                       O",
            "                                       G",
            "                                        ",
            "             O    O    O     O      O   ",
            "             G    G    G     G      G   ",
            "             X                          ",
            "             X                          ",
            "         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "           X                            ",
            "           X                            ",
            "     X        O  O  O  O  O  O  O       ",
            "              X  X  X  X  X  X  X       ",
            "            X!!!!!!!!!!!!!!!!!!!!!X     ",
            "X          XXXXXXXXXXXXXXXXXXXXXXXX     ",
            "X   O O O  X                            ",
            "X   XXXXX  X                         GGG",
            "X!!!!!!!!!!X                            ",
            "XXXXXXXXXXXX                            ",
            "                               XXXXXXXXX",
            "                                        ",
            "                          G             ",
            "                          X    O O O    ",
            "                G         X   O O O O   ",
            "                X    G    X    O O O    ",
            " @    G    G    X    X    X             ",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.geometry.color = Color(r:0.07, g:0.39, b:0.71, a:1.0)
                gameScene.geometry.vertices[0].color = Color(r:0.984, g:0.447, b:0.518, a:1.0) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.988, g: 0.612, b: 0.494, a: 1.0) // bottom right
                gameScene.geometry.vertices[2].color = Color(r: 0.420, g: 0.082, b: 0.467, a: 1.0) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                gameScene.geometry.vertices[5].color = Color(r:0.890, g:0.165, b:0.463, a:1.0) // top right
                
                gameScene.prepareAmbience(colored: Color(r: 1, g: 0, b: 0, a: 1))
        }
        ), (blocks: [
            "          OO                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "       GG                 OO     X           X   O      X OOO       X                                          X",
            "  O O  X                  GG     XOGGGG      X       X  X OOO       X                                          X",
            "   O   X  GG                     XBX    GGGGGXBBBBBBBX  XBBBBBX     X                                          X",
            "  O O  X                       X XOX XXXX   OO       X  XBBBBBX     X                                          X",
            "GGGGGGGX                OO     XOXBX                 X  XBBBBBX     X                              O           X",
            "                        GG     X XOX     GGGGGGGG       XBBBBBX     X                              G           X",
            "        GGGGGG  OO             XOXBX    X!!!!!!!!!!X    XBBBBBX           O        O                           X",
            "                GG             X XOXXXXXXXXXXXXXXXXXXX  XBBBBBX           G        G       O                   X",
            "     GG   OO                   XOXBX                    XBBBBBX   GG                       G               W   X",
            "  @                            X XOX  BBBBBBBBBBBBBBBBBBXBBBBBX OO  OO X                                       X",
            "                     GG        XOXBX    O            O        X   OO   X                                       X",
            " GGG    X!!!!X                 X   X                          X OO  OO X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                //gameScene.geometry.color = Color(r:0.00, g:0.50, b:0.40, a:1.0)
                
                gameScene.geometry.vertices[0].color = Color(r: 0.576, g: 0.157, b: 0.439, a: 1) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.894, g: 0.204, b: 0.235, a: 1) // bottom right
                gameScene.geometry.vertices[2].color = Color(r: 0.451, g: 0.137, b: 0.380, a: 1) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                gameScene.geometry.vertices[5].color = Color(r: 0.861, g: 0.618, b: 0.204, a: 1) // top right
                
                gameScene.prepareAmbience(colored: Color(r: 0.961, g: 0.718, b: 0.204, a: 1))
        }), (blocks: [
            "                   O    ",
            "                        ",
            "                   !    ",
            "                        ",
            "                        ",
            "                        ",
            "                      W ",
            "               G   !    ",
            "    GB                  ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "     G                  ",
            "              G         ",
            "                        ",
            "                        ",
            "                        ",
            "                     G  ",
            "                        ",
            "                        ",
            "BBBBBBBBBBBBBBBBBBBBBBBB",
            "                        ",
            "                    XXX ",
            "                        ",
            "                  O     ",
            "                        ",
            "                 XXX    ",
            "                        ",
            "                        ",
            "       O                ",
            "      XXX               ",
            "                  O     ",
            "                        ",
            "                 XXX    ",
            "                        ",
            "               O        ",
            "                        ",
            "              XXX       ",
            "       O                ",
            "                        ",
            "      XXX               ",
            "            O           ",
            "                        ",
            "           XXX          ",
            "                 O      ",
            "                        ",
            "                XXX     ",
            "                        ",
            "                        ",
            "            O           ",
            "                        ",
            "           XXX          ",
            "                   O    ",
            "                        ",
            "            O     XXX   ",
            "                        ",
            "           XXX          ",
            "                        ",
            "     @                  ",
            "XXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                //gameScene.geometry.color = Color(r:1.00, g:0.48, b:0.00, a:1.0)
                
                gameScene.geometry.vertices[2].color = Color(r: 0.373, g: 0.494, b: 0.855, a: 1) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[5].color = Color(r: 0.471, g: 0.612, b: 0.937, a: 1) // top right
                gameScene.geometry.vertices[0].color = Color(r: 0.733, g: 0.459, b: 0.506, a: 1) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.906, g: 0.596, b: 0.612, a: 1) // bottom right
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                
                gameScene.prepareAmbience(colored: Color(r: 0.8, g: 0.2, b: 0.8, a: 0.8))
        }), (blocks: [
            "                                                             ",
            "     W     V      V      V       V                           ",
            "                                                             ",
            "                                          V                  ",
            "                                             XBBBBBBBBBBBBBBX",
            "                                             XBBBBBBBBBBBBBBX",
            "                                          X  XBBBBBBBBBBBBBBX",
            "                        VVV   V           X  XBBBBBBBBBBBBBBX",
            "                                          X  XBBBBBBBBBBBBBBX",
            "       O      V                           X  XBBBBBBBBBBBBBBX",
            "                                    VVV   X  XBBBBBBBBBBBBBBX",
            "      BBB                                 X                  ",
            "                                          X   O O O O O O O  ",
            "                                          X                  ",
            "                                          XXXXXXXXXXXXXXXXXXX",
            "       V                V                       O     O  O   ",
            "                                VVV              O   O  O O  ",
            "             VV                                   O O  O   O ",
            "X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X O O O !   !  O  O     O",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXBBBBBBBBB",
            "                                                             ",
            "                                                          VVV",
            "                                                             ",
            "                           OOOOOOOOOOOOOOOOOOOO      VVV     ",
            "     @                  VVVVVVVVVVVVVVVVVVVVVVVVVV           ",
            "                                                             ",
            "  GGGGGGG    O O      X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            
            ], script: { (_ gameScene: GameScene) -> () in
                //gameScene.geometry.color = Color(r:0.86, g:0.00, b:0.63, a:1.0)
                
                gameScene.geometry.vertices[2].color = Color(r: 0.067, g: 0.224, b: 0.376, a: 1) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[5].color = Color(r: 0.129, g: 0.475, b: 0.663, a: 1) // top right
                gameScene.geometry.vertices[0].color = Color(r: 0.176, g: 0.482, b: 0.765, a: 1) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.133, g: 0.702, b: 0.518, a: 1) // bottom right
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                
                gameScene.prepareAmbience(colored: Color(r: 0.8, g: 0.2, b: 0.6, a: 0.8))
        }), (blocks: [
            "            O        FFFFF      FFFFF     FFFFF          F         F          W   ",
            "            O                                                                     ",
            "            O       X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "            O       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "          VVVVV                               OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "                 XXXXXXXXXVVVVVVVVVVVVVVVVVVVXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "         X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!XOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "BBBBBBBBBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "X                                                                                X",
            "X                                                                                X",
            "X                                                                                X",
            "XRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR!   !   !         !  OOOOOOOOOO X",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXBBBBBBBBBBBBX",
            "                                                                                  ",
            "                                                                                  ",
            "                                                                                  ",
            "    @              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ",
            "                                                                                  ",
            " GGGGGGGOOOOOOOOOOX!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                //gameScene.geometry.color = Color(r:0.19, g:0.57, b:0.47, a:1.0)
                
                gameScene.geometry.vertices[2].color = Color(r: 0.739, g: 0.247, b: 0.745, a: 1) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[5].color = Color(r: 0.988, g: 0.373, b: 0.125, a: 1) // top right
                gameScene.geometry.vertices[0].color = Color(r: 0.753, g: 0.092, b: 0.102, a: 1) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.984, g: 0.949, b: 0.094, a: 1) // bottom right
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                
                gameScene.prepareAmbience(colored: Color(r: 0.2, g: 0.6, b: 0.5, a: 0.8))
        }), (blocks: [
            "XXXX                                                               ",
            "X  X                                                               ",
            "X  X GGGGGGGGGGGGGG  OOOO    OOOO                                  ",
            "X@ XBX!!!!!!!!!!!!XXXXXXXXXXXXXXXX>>>>>>>>>>>>>>>>>><<<<<<<<<<<<< X",
            "XVVXOX                           X             R                  X",
            "XVVXOX            XFFFFFFFFFFFFFFX O O O       R      R           X",
            "XVVXOX            X              X        R    R      R           X",
            "XOOXOX            X              X        R           R           X",
            "XOOXOX            X              XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFX",
            "XVOXOXRRRRRRRRRRRRXFFFFFFFFFFFFFFX        R           R           X",
            "XOOXRX            X              X  RRR   R !!!!!!!!!!!!!!!!!!!!!!X",
            "XOOXBX            X              X                RRRRRRR      RRRX",
            "XOOX              X              X  O O                        OOOX",
            "XOVXXXXXXXXXXXXXXXXXXXXXXXXXX    XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFX",
            "XOOX    X       X!!!!X      X    X                             OOOX",
            "XOOXBBXVX                   XBBBBX!!!!!!!!!!!!!!!! O O O !!!!!!!!!X",
            "XOOX  X                          X                                X",
            "XOOX  X         RRRRR            X                                X",
            "XVOX  X                          XFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFX",
            "XOOX  X FFFFF           FFFFF    X                                X",
            "XOOX  X                          XW                               X",
            "XVVX  X!!!!!!!!!!!!!!!!!!!!!!!!!!X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "XOOX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "XOOX  X                                                           X",
            "XOOX  X                                                           X",
            "XOVX                                                              X",
            "XOOXRX        !     OOOOO     !      OOOO      !                  X",
            "XOOXXXX<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BBBBBBX",
            "X                       OOOOOOOOOOOOOOOOOOO                       X",
            "X>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>XX",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.geometry.color = Color(r:0.11, g:0.21, b:0.18, a:1.0)
                
                gameScene.geometry.vertices[2].color = Color(r: 0.063, g: 0.106, b: 0.035, a: 1) // top left
                gameScene.geometry.vertices[3].color = gameScene.geometry.vertices[2].color // top left
                gameScene.geometry.vertices[5].color = Color(r: 0.886, g: 0.914, b: 0.239, a: 1) // top right
                gameScene.geometry.vertices[0].color = Color(r: 0.047, g: 0.212, b: 0.373, a: 1) // bottom left
                gameScene.geometry.vertices[1].color = Color(r: 0.247, g: 0.416, b: 0.647, a: 1) // bottom right
                gameScene.geometry.vertices[4].color = gameScene.geometry.vertices[1].color // bottom right
                
                gameScene.prepareAmbience(colored: Color(r: 0.8, g: 0.2, b: 0.8, a: 0.8))
        }), (blocks: [
            "X!!!!!!!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "XXXXXXXXX                    X             X                                                                   X   X      X          X             XXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "X   O      OOO               X    O   O    X OOO                                                               XBX X XXXXOX<       XOX        O    XXBXVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX",
            "X  O O     GGG               X   <<<X<<<   X OOO                    OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO           XBXOXOOOOX X <      X X   GGGXFFF   XXBX!!!!!!!!!!!X X!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X",
            "X O O O X                    X      X      X OOO          >>>FX><><><><><><><><><><><><><><><><><><><><>XVVVVVVXBX X<>>BXOX  <     XOX      X      XXBXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "X  O O  X                OOO X O    X    O XF<<<              X<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<       XBX    >BX X   <    X X      X    O XXBXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "X O O O X                GGG X>>>   X   >>>X                  X       OOOOOOOOOOOOOOOOOOOOOOOOOOO              XBXXX< >BXOX    <   XOXGGG   X   FFFXXBXVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX",
            "X  O O  X      OOO           X      X      X                  X <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<XXXXXXXXOOOX< >BX X     <  X X      X      XXBX!!!!!!!!!!!!!!!!!!!!!!!!!!!X X!!!!!!!!!!!!!!!!!!!X",
            "X   O   X      GGG           X    O X O    X                  X                           !XXXXXXXXXXXXXXXXXXXXXXXBX< >BXOX        XOX      X O    XXBXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXX",
            "X       X                    X   <<<X<<<   X           >>>F   X>>>>>>>>>>>>>>>>>>>>>>>>>VVXX                     XBX< >BX X       >X X   GGGXFFF   XXBXOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "XRRRRRRRX            OOO     X      X      X                  X                            X FFFFFFFFFFFFFFFFFFX XBX< >BXOX      >XXOX      X      XXBXVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV X",
            "XBBBBBBBX            GGG     X O    X    O X                  X                            X                   X XBX< >BX X     >X   X      X    O XXBX!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!X X",
            "X       X   OOO              X>>>   X   >>>X   F<<<           X XFFFFFFFFFFFFFFFFFFFFFFFFFFX                   X XBX< >BXOX    >XX XXXGGG   X   FFFXXBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X",
            "X   @   X   GGG              V      X                         X X!!!!!!!!!!!!!!!!!!!!!!!!!!X                   X XBX<   X X   >XXX          X      XGBX                                                 X",
            "X       X                    V      X                         X XXXXXXXXXXXXXXXXXXXXXXXXXXXOO                  X XBX<   XOX  >XXXX          X         X                                                 X",
            "XGGGGGGGX                    V      XGGGGGGXX!!!!!!!!!!!!!!!!!X                            OORRRRRRRRRRRRRRRRRRX   XX XXX   >XXXXXGGGGGGGGGGXGGGGGGGGRXWOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOX",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX!!!!!!!!!!!!!!!!!!XXXXXX!XXXXXXXXXXXXXXXXXXXXXXX!!!!!!!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.geometry.color = Color(r:0.89, g:0.89, b:0.59, a:1.0)
                gameScene.prepareAmbience(colored: Color(r: 0.8, g: 0.8, b: 0.6, a: 0.8))
        }), (blocks: [
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "                  !     X          O     ",
            "                  !BXGOGX          X     ",
            "            >>>>X X XX XXOOOOOOO!!!X     ",
            "                ! !BX!O!XFFXXXXXXXXXXXXXX",
            "        <<<<<<<<X X XB BX          X   O ",
            "        OOOOOOOO! !BXFOFX          X  O  ",
            "    >>>>>>>>>>>>X   XR RX          X O   ",
            "XXXXXXXXXXXXXXXXXXXXX>O<X          XXXXXX",
            "  O   !   O         X< >X!!!!!!!!OOX   O ",
            "                    XGOGXXXXXXXXXFFX  O  ",
            "  !   O   !         XX XX  OOOOOOOOX O   ",
            "XX!   O   !         X!O!X  OOOOOOOOXXXXXX",
            "OO! O   O !         XB BX  <<<<<<<<X   O ",
            "OO! O ! O !         XFOFXOOOOOOOO  X  O  ",
            "OO!   !   !         XR RXOOOOOOOO WX O   ",
            "XXXXXXXXXXXXXXXXBBBBX>O<XXXXXXXXXXXXBBBBX",
            "X         !     O O X< >X     !         X",
            "X         !      O  X O       !         X",
            "X  @ O    !     O O X         !         X",
            "XGGGGGX       XGGGGGXGGGGGX       XGGGGGX",
            "XXXXXXX   O   XXXXXXXXXXXXX   O   XXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.setColor(Color(r: 0.925, g: 0.784, b: 0.357, a: 1), Color(r: 0.914, g: 0.408, b: 0.282, a: 1), Color(r: 0.749, g: 0.169, b: 0.216, a: 1), Color(r: 0.094, g: 0.616, b: 0.675, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0.2, g: 0.2, b: 0.8, a: 0.8))
        }), (blocks: [
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
            "X                           !      S  X",
            "X       O       O           !     XXX X",
            "X      XGX      X           !     X O X",
            "X   !  XXX      XGGGGGGGX       X XOXXX",
            "X   !           XXXXXXXXX       X!X X!X",
            "XO            O         X   O   X!XOXXX",
            "XXO            O        X       XOX  !X",
            "X  O            O       X!!!!!!!XOXO  X",
            "X   O            O      XXXXXXXXXOX   X",
            "X    O     !!!!   O    VOOO    !XOXO  X",
            "X<<<<<<<<<<<<<<<<<<<<<<<<<<BBBB!XOTTO!X",
            "X        OOVO O O O O O O O    !X  O  X",
            "X OXOXXX XXXB>>>>>>>>>>>>>>>>>>>X  O  X",
            "XO XSXO OX   XOOOOOOOOOOOOOOOOOOX  O  X",
            "X OXXX XXX   XOOOOOOOOOOOOOOXX XX  O !X",
            "XBBXO OX     XXXXXXXXXXXXXXXX! !X TTTTX",
            "XO X XXX   O X         !  !     X  O  X",
            "X OXOX   O X X  O  X   !        X  O  X",
            "XO X XOO X X X  O  X      O     X  O  X",
            "XBBXO OX X X X  W  X      G  O  X  O  X",
            "X  X>>OXOXOXOXGGGGGX      X  G  XTTTT X",
            "X  XXXTXOXOXOXXXXXXX   O  X  X     O  X",
            "X    XXXOXOXOX     X   G     X     S  X",
            "X G    XTXOXOX     X!!!X!!!!!X!XXGGGGGX",
            "XO  G  XXXOXOX OXFFXXXXXXXXXXXXXXXXXXXX",
            "XO X     XTXOXO X  X   XOO            X",
            "XO    G  XXXOX OXFFX X XOO X>>>>>>>>> X",
            "XO   X    OXTXO X  XOXBXXX X          X",
            "XX      XO XXX OXFFX X   X X <<<<<<<<<X",
            "X!!!!!!!X OOOOO X    XRXF  X         @X",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.setColor(Color(r: 0.431, g: 0.765, b: 0.655, a: 1), Color(r: 0.322, g: 0.639, b: 0.549, a: 1), Color(r: 0.839, g: 0.204, b: 0.267, a: 1), Color(r: 0.678, g: 0.231, b: 0.310, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 0.0, g: 0.3, b: 1.0, a: 1.0))
        }), (blocks: [
            "LLLLL                                 LLL   LLL              LLL            ",
            "L   L             LOL             LOL LOL L LOL             LLLLL           ",
            "L W L    LLL    LL   LL         LL    LLL   LLL L LLL   LLL LLOLL  L        ",
            "L   L    LOL LOL       L       L                  LLL L LLL LLLLL LLL LLL   ",
            "LLLLL    LLL            LL   LL                   LLL   LLL  LLL   L  LLL   ",
            "                          LOL                                         LLL   ",
            "                                                                            ",
            "                                                                       L    ",
            "                                                                      LLL   ",
            "                                                                       L    ",
            "                                                                            ",
            "                                                                       L    ",
            "                                                                            ",
            "                                                                       L    ",
            "                                                                      LLL   ",
            "                                                                       L    ",
            "                                                                            ",
            "                                                                      LLL   ",
            "                                                                   L  LLL   ",
            "                                                                  LLL LLL   ",
            "                                                                   L        ",
            "                                LLL        !            LLL   LLL           ",
            "                                LOL        !            LLL  LLLLL          ",
            "          @                     LLL        !            LLL  LLOLL          ",
            "         IIIIIIIIIII                       !                 LLLLL          ",
            "            IIIII                          !                  LLL           ",
            "             III                           !                                ",
            "              I                                                             ",
            "              I            IIIIIIIIIII           IIIIIIIIIII                ",
            "                           XGGGGGGGGGX           XGGGGGGGGGX                ",
            "                            XXXXXXXXX             XXXXXXXXX                 ",
            "                                                                            ",
            "                                                                            "
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.setColor(Color(r: 0.212, g: 0.239, b: 0.447, a: 1), Color(r: 0.400, g: 0.231, b: 0.525, a: 1), Color(r: 0.894, g: 0.310, b: 0.545, a: 1), Color(r: 0.776, g: 0.620, b: 0.839, a: 1))
                gameScene.prepareAmbience(colored: Color(r: 1.0, g: 0, b: 1.0, a: 1.0))
        }), (blocks: [
            "                                                                         =",
            "                                                                         =",
            "                                                    W                    =",
            "                                                    MMMMMMMMMMMMMMMMMMMM =",
            "                                                                       X =",
            "                                                                       X =",
            "                                                                       X =",
            "                                                                       X =",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                       XX =",
            "        ^             X                                             XX^  =",
            "       ^ v            X       ~~~~~~~~~~~~~~~       M             XX     =",
            "      ^   v       X~~~X~X    ~~~~~~~~~~~~~~~~              M M  XX       =",
            "     ^     v     X    X~X   ~~~~~~~~~~~~~~~~~              M M X         =",
            "    ^       v   XXXX~~X~X  ~~~~~~~~~~~~~~~~~~          M   M MX          =",
            " @ ^         v X          ~~~~~~~~~~~~~~~~~~~              M             =",
            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXMMMMMMMMMMMMMMMMXXXXXXXXXXXX"
            ], script: { (_ gameScene: GameScene) -> () in
                gameScene.geometry.color = Color(r:0.39, g:0.81, b:0.53, a:1.0)
                gameScene.prepareAmbience(colored: Color(r: 1.0, g: 0, b: 1.0, a: 1.0))
        })
    ]
}
/*["                                           LLL LLL LLL LLL  L            ",
"                                           LLL LLL LLL LLL  L            ",
 "                                           LLL LLL LLL LLL  L            ",
 "                                                            L            ",
 "                                           L              LLLLL          ",
 "                                                           LLL           ",
 "                                           L                L            ",
 "                                                                         ",
 "                                           L                O            ",
 "                                                                         ",
 "                                           L                O            ",
 "                                          LLL                            ",
 "                                          LLL               L            ",
 "                                          LLL                            ",
 "                                          LLL               O            ",
 "                                          LLL                            ",
 "                                         LLL                O            ",
 "                                         LLL                             ",
 "                                         LLL                L            ",
 "        L  L LLLLL                       LLL                             ",
 "       LLLLLLLLLLLLLLL                  LLL                 O            ",
 "        L  L LLLLLLLLLLLL             LLLLL                              ",
 "        L         LLLLLLLLLLL     LLLLLLLLL                 O            ",
 "       LLL            LLLLLLLLLLLLLLLLLLL                                ",
 "        L L              LLLLLLLLLLLLL                      L            ",
 "         LLL                 LLLLL                                       ",
 "          L L                                              XXX        X X",
 "           LLL                                                        I I",
 "            L L                                                       I I",
 "             LLL                                                      IWI",
 "              L                                                       III",
 "              L                                                          ",
 "             LLL                                                         ",
 "            L L                                                          ",
 "           LLL                                                           ",
 "          L L                                                            ",
 "         LLL                                                             ",
 "        L L                                                              ",
 "       LLL                                                               ",
 "        L                                                                ",
 "                                                                         ",
 " @                                                                       ",
 "XXXXXXXXX                                                                "]*/
