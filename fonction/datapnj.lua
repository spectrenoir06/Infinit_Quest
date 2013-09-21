data.pnj = {}

data.pnj[1] = {
    name = "Eskimos",
    skin = "skin1.png",
    talk = function()
        --android.ttsSpeak("ma bite")
    end,
}

data.pnj[2] = {
    name = "Pirate",
    skin = "skin2.png",
    talk = function()
        info=true
    end,
}
    
data.pnj[3] = {
    name = "Marchande",
    skin = "skin3.png",
    talk = function()
        info=false
        print("Fuck le debug mode")
    end,
}
data.pnj[4] = {
    name = "Pere",
    skin ="skin4.png",
    talk = function()
        print("coffres gratos !!!")
        --steve:additem(57,1)
    end,
}
data.pnj[5] = {
    name = "pnj 1",
    skin ="skin5.png",
    talk = function()
        print("Zboob")
    end,
}
data.pnj[6] = {
    name = "pnj 2",
    skin ="skin6.png",
    talk = function()
        print("Zboob")
    end,
}
data.pnj[7] = {
    name = "pnj 3",
    skin ="skin7.png",
    talk = function()
        print("zboob")
    end,
}
data.pnj[8] = {
    name = "pnj 3",
    skin ="skin7.png",
    talk = function()
        mobile=true
        print("mobil on")
    end,
}
data.pnj[9] = {
    name = "pnj 3",
    skin ="skin7.png",
    talk = function()
        mobile=false
        print("mobil off")
    end,
}