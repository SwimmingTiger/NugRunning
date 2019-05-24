-----------------------------------------------------------------------------------
-- It's a better idea to edit userconfig.lua in NugRunningUserConfig addon folder
-- CONFIG GUIDE: https://github.com/rgd87/NugRunning/wiki/NugRunningUserConfig
-----------------------------------------------------------------------------------
local _, helpers = ...
local Spell = helpers.Spell
local ModSpell = helpers.ModSpell
local Cooldown = helpers.Cooldown
local Activation = helpers.Activation
local EventTimer = helpers.EventTimer
local Cast = helpers.Cast
local Item = helpers.Item
local Anchor = helpers.Anchor
local Talent = helpers.Talent
local Glyph = helpers.Glyph
local GetCP = helpers.GetCP
local SPECS = helpers.SPECS
local GotSpell = helpers.Talent
local IsPlayerSpell = IsPlayerSpell
local IsUsableSpell = IsUsableSpell
local _,class = UnitClass("player")

-- NugRunningConfig.overrideTexture = true
-- NugRunningConfig.texture = "Interface\\AddOns\\NugRunning\\statusbar"
-- NugRunningConfig.overrideFonts = true
-- NugRunningConfig.nameFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 10, alpha = 0.5 }
-- NugRunningConfig.timeFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 8, alpha = 1 }
-- NugRunningConfig.stackFont = { font = "Interface\\AddOns\\NugRunning\\Calibri.ttf", size = 12 }

NugRunningConfig.nameplates.parented = true

NugRunningConfig.colors = {}
local colors = NugRunningConfig.colors
colors["RED"] = { 0.8, 0, 0}
colors["RED2"] = { 1, 0, 0}
-- colors["RED3"] = { 183/255, 58/255, 93/255}
colors["LRED"] = { 1,0.4,0.4}
colors["DRED"] = { 0.55,0,0}
colors["CURSE"] = { 0.6, 0, 1 }
colors["PINK"] = { 1, 0.3, 0.6 }
colors["PINK2"] = { 1, 0, 0.5 }
colors["PINK3"] = { 226/255, 35/255, 103/255 }
colors["PINKIERED"] = { 206/255, 4/256, 56/256 }
colors["TEAL"] = { 0.32, 0.52, 0.82 }
colors["TEAL2"] = {38/255, 221/255, 163/255}
colors["TEAL3"] = {52/255, 172/255, 114/255}
colors["DTEAL"] = {15/255, 78/255, 60/255}
colors["ORANGE"] = { 1, 124/255, 33/255 }
colors["ORANGE2"] = { 1, 66/255, 0 }
colors["FIRE"] = {1,80/255,0}
colors["LBLUE"] = {149/255, 121/255, 214/255}
colors["DBLUE"] = { 50/255, 34/255, 151/255 }
colors["GOLD"] = {1,0.7,0.5}
colors["LGREEN"] = { 0.63, 0.8, 0.35 }
colors["GREEN"] = {0.3, 0.9, 0.3}
colors["DGREEN"] = { 0, 0.35, 0 }
colors["PURPLE"] = { 187/255, 75/255, 128/255 }
colors["PURPLE2"] = { 188/255, 37/255, 186/255 }
colors["BURGUNDY"] = { 102/255, 22/255, 49/255 }
colors["REJUV"] = { 1, 0.2, 1}
colors["PURPLE3"] = { 64/255, 48/255, 109/255 }
colors["PURPLE4"] = { 121/255, 29/255, 57/255 }
colors["PURPLE5"] = { 0.49, 0.16, 0.60 }
colors["DPURPLE"] = {74/255, 14/255, 85/255}
colors["DPURPLE2"] = {0.42, 0, 0.7}
colors["CHIM"] = {199/255, 130/255, 255/255}
colors["FROZEN"] = { 65/255, 110/255, 1 }
colors["CHILL"] = { 0.6, 0.6, 1}
colors["BLACK"] = {0.35,0.35,0.35}
colors["SAND"] = { 168/255, 75/255, 11/255 }
colors["WOO"] = {151/255, 86/255, 168/255}
colors["WOO2"] = {80/255, 83/255, 150/255}
colors["WOO2DARK"] = {30/255, 30/255, 65/255}
colors["BROWN"] = { 192/255, 77/255, 48/255}
colors["DBROWN"] = { 118/255, 69/255, 50/255}
colors["MISSED"] = { .15, .15, .15}
colors["DEFAULT_DEBUFF"] = { 0.8, 0.1, 0.7}
colors["DEFAULT_BUFF"] = { 1, 0.4, 0.2}

local effects = {}
-- I stopped at M
effects["UNHOLY"] = {
    path = "spells/enchantments/skullballs.m2",
    scale = 4,
    x = 0, y = -2,
}
effects["PURPLESWIPE"] = {
    path = "spells/enchantments/shaman_purple.m2",
    scale = 4,
    x = -10, y = -3,
}
effects["JUDGEMENT"] = {
    path = "spells/fireshot_missile.m2",
    scale = 4,
    x = -3, y = -4,
}
effects["AEGWYNN"] = {
    path = "spells/Gouge_precast_state_hand.m2",
    scale = 4,
    x = -1, y = -1,
}
effects["HOLY"] = {
    path = "spells/layonhands_low_chest.m2",
    scale = 2.6,
    x = -10, y = -1,
}
effects["NIGHTBORNE"] = {
    path = "spells/magic_cast_hand.m2",
    scale = 3,
    x = -12, y = -1,
}
effects["LIGHTNING"] = {
    path = "spells/lightning_precast_low_hand.m2",
    scale = 5,
    x = -1, y = 0,
}
effects["BACKSTAB"] = {
    path = "spells/backstab_impact_chest.m2",
    scale = 3,
    x = -5, y = -2,
}
NugRunningConfig.effects = effects

local DotSpell = function(id, opts)
    if type(opts.duration) == "number" then
        local m = opts.duration*0.3 - 0.2
        -- opts.recast_mark = m
        opts.overlay = {0, m, 0.25}
    end
    return Spell(id,opts)
end
helpers.DotSpell = DotSpell


local Interrupt = function(id, name, duration)
    EventTimer(id, { event = "SPELL_INTERRUPT", short = "Interrupted", name = name, target = "pvp", duration = duration,  scale = 0.75, shine = true, color = colors.LBLUE })
end
helpers.Interrupt = Interrupt

if select(4,GetBuildInfo()) > 19999 then return end

-- RACIALS
Spell( 23234 ,{ name = "Blood Fury", global = true, duration = 15, scale = 0.75, group = "buffs" })
Spell( 20594 ,{ name = "Stoneform", global = true, duration = 8, shine = true, group = "buffs" })
Spell( 20549 ,{ name = "War Stomp", global = true, duration = 2, maxtimers = 1, color = colors.DRED })
Spell( 7744 ,{ name = "Will of the Forsaken", global = true, duration = 5, group = "buffs", color = colors.PURPLE5 })

-- Cast({ 746, 1159, 3267, 3268, 7926, 7927, 10838, 10839, 18608, 18610, 23567, 23568, 23569, 23696, 24412, 24413, 24414 },
    -- { name = "First Aid", global = true, tick = 1, tickshine = true, overlay = {"tick", "tickend", 0.4 }, color = colors.LGREEN })



if class == "WARLOCK" then
-- Interrupt(119910, "Spell Lock", 6) -- Felhunter spell from action bar
Interrupt(19244, "Spell Lock", 6) -- Rank 1
Interrupt(19647, "Spell Lock", 8) -- Rank 2
Spell( 24259 ,{ name = "Silence", duration = 3, color = colors.PINK }) -- Spell Lock Silence

local normalize_dots_to = nil--26

Spell({ 1714, 11719 }, { name = "Curse of Tongues", duration = 30, color = colors.CURSE })
Spell({ 702, 1108, 6205, 7646, 11707, 11708 },{  name = "Curse of Weakness", duration = 120, color = colors.CUR })
Spell({ 17862, 17937 }, { name = "Curse of Shadows", duration = 300, glowtime = 15, color = colors.CURSE })
Spell({ 1490, 11721, 11722 }, { name = "Curse of Elements", duration = 300, glowtime = 15, color = colors.CURSE })
Spell({ 704, 7658, 7659, 11717 }, { name = "Curse of Recklessness", duration = 120, shine = true, color = colors.CURSE })
Spell( 603 ,{ name = "Curse of Doom", duration = 60, ghost = true, color = colors.CURSE, nameplates = true, })
Spell( 18223 ,{ name = "Curse of Exhaustion", duration = 12, ghost = true, color = colors.CURSE })

Spell( 17941 ,{ name = "Shadow Trance", duration = 10, shine = true, priority = 15, glowtime = 10, scale = 0.7, shinerefresh = true, color = colors.DPURPLE })


Spell( 6358, { name = "Seduction", duration = 20, color = colors.PURPLE4 }) -- varies, Improved Succubus
Spell({ 5484, 17928 }, { name = "Howl of Terror", duration = 15, shine = true, maxtimers = 1,
    duration = function(timer)
        return timer.spellID == 5484 and 10 or 15
    end
})
Spell({ 5782, 6213, 6215 }, { name = "Fear",
    duration = function(timer)
        if timer.spellID == 5782 then return 10
        elseif timer.spellID == 6213 then return 15
        else return 20 end
    end
})
Spell({ 710, 18647 }, { name = "Banish", nameplates = true, color = colors.TEAL3,
    duration = function(timer)
        return timer.spellID == 710 and 20 or 30
    end
})
Spell({ 6789, 17925, 17926 }, { name = "Death Coil", duration = 3, color = colors.DTEAL })


Spell({ 18265, 18879, 18880, 18881}, { name = "Siphon Life", duration = 30, priority = 5, fixedlen = normalize_dots_to, nameplates = true, ghost = true, color = colors.DTEAL })
Spell({ 980, 6217, 11711, 11712, 11713 }, { name = "Curse of Agony", duration = 24, fixedlen = normalize_dots_to, nameplates = true, ghost = true, priority = 6, color = colors.CURSE })
Spell({ 172, 6222, 6223, 7648, 11671, 11672, 25311 }, { name = "Corruption", preghost = true, tick = 3, overlay = {"tick", "end", 0.35}, priority = 9, fixedlen = normalize_dots_to, nameplates = true, ghost = true, color = colors.PINK3,
    duration = function(timer, opts)
        if timer.spellID == 172 then
            return 12
        elseif timer.spellID == 6222 then
            return 15
        else
            return 18
        end
    end })
Spell({ 348, 707, 1094, 2941, 11665, 11667, 11668, 25309 },{ name = "Immolate", preghost = true, recast_mark = 1.5, overlay = {0, 1.5, 0.3}, duration = 15, nameplates = true, priority = 10, ghost = true, color = colors.RED })

-- Spell( 26385, { name = "Shadowburn", duration = 5, scale = 0.5, color = colors.DPURPLE }) -- Soul Shard debuff

Cooldown( 17962, { name = "Conflagrate", ghost = true, priority = 5, color = colors.PINK })


Spell({ 6229, 11739, 11740, 28610 } ,{ name = "Shadow Ward", duration = 30, group = "buffs", scale = 0.7, color=colors.DPURPLE})
Spell({ 7812, 19438, 19440, 19441, 19442, 19443 }, { name = "Sacrifice", duration = 30, group = "buffs", shine = true, color=colors.GOLD })

end



if class == "SHAMAN" then
Interrupt({ 8042, 8044, 8045, 8046, 10412, 10413, 10414 }, "Earth Shock", 2)

-- Spell( 3600 ,{ name = "Earthbind", maxtimers = 1, duration = 5, timeless = true, color = colors.BROWN, scale = 0.7 })
Spell({ 16257, 16277, 16278, 16279, 16280 }, { name = "Flurry", duration = 15, scale = 0.5, shine = true, color = colors.DPURPLE })
Spell({ 8056, 8058, 10472, 10473 }, { name = "Frost Shock", duration = 8, color = colors.LBLUE })
Spell({ 8050, 8052, 8053, 10447, 10448, 29228 }, { name = "Flame Shock", duration = 12, color = colors.RED, ghost = true })
Cooldown( 8042 ,{ name = "Shock", color = colors.DTEAL, ghost = 1, priority = 1, scale = 0.8 })
Cooldown( 17364 ,{ name = "Stormstrike", color = colors.CURSE, priority = 10, scale_until = 5, ghost = true  })
Spell( 29063 ,{ name = "Focused Casting", shine = true, duration = 6, color = colors.PURPLE4, group = "buffs" })
Spell( 16246 ,{ name = "Clearcasting", shine = true, duration = 15, color = colors.CHIM, group = "buffs" })
Spell( 16166 ,{ name = "Elemental Mastery", shine = true, duration = 15, priority = 12, timeless = true, scale = 0.7, color = colors.DPURPLE })
Spell( 16188 ,{ name = "Nature's Swiftness", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })
Spell( 29203 ,{ name = "Healing Way", maxtimers = 2, duration = 15, scale = 0.7, color = colors.LGREEN })

end

if class == "PALADIN" then

Spell( 20066 ,{ name = "Repentance", duration = 6 })
Spell({ 2878, 5627, 5627 }, { name = "Turn Undead",
    duration = function(timer)
        if timer.spellID == 2878 then return 10
        elseif timer.spellID == 5627 then return 15
        else return 20 end
    end
})
Cooldown( 879 ,{ name = "Exorcism", color = colors.ORANGE, ghost = true, priority = 8, })
Cooldown( 24275 ,{ name = "Hammer of Wrath", color = colors.TEAL2, ghost = true, priority = 11 })

Spell( 1044 ,{ name = "Blessing of Freedom", duration = 10, group = "buffs" })
Spell({ 6940, 20729 }, { name = "Blessing of Sacrifice", duration = 10, group = "buffs", color = colors.LRED })
Spell({ 1022, 5599, 10278 }, { name = "Blessing of Protection", group = "buffs", color = colors.WOO2,
    duration = function(timer)
        if timer.spellID == 1022 then return 6
        elseif timer.spellID == 5599 then return 8
        else return 10 end
    end
})
-- DS includes Divine Protection
Spell({ 498, 5573, 642, 1020 }, { name = "Divine Shield", duration = 12, group = "buffs", color = colors.BLACK }) --varies BUFF

Spell({ 20375, 20915, 20918, 20919, 20920 }, { name = "Seal of Command", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.RED })
Spell({ 21084, 20287, 20288, 20289, 20290, 20291, 20292, 20293 }, { name = "Seal of Righteousness", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.DTEAL })
Spell({ 20162, 20305, 20306, 20307, 20308, 21082 }, { name = "Seal of the Crusader", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.GOLD })
Spell({ 20165, 20347, 20348, 20349 }, { name = "Seal of Light", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.LGREEN })
Spell({ 20166, 20356, 20357 }, { name = "Seal of Wisdom", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.LBLUE })
Spell( 20164 , { name = "Seal of Justice", scale_until = 8, priority = 6, duration = 30, ghost = 1, color = colors.BLACK })

Spell({ 21183, 20188, 20300, 20301, 20302, 20303 }, { name = "Judgement of the Crusader", short = "Crusader", duration = 10, color = colors.GOLD })
Spell({ 20185, 20344, 20345, 20346 }, { name = "Judgement of Light", short = "Light", duration = 10, color = colors.LGREEN })
Spell({ 20186, 20354, 20355 }, { name = "Judgement of Wisdom", short = "Wisdom", duration = 10, color = colors.LBLUE })
Spell( 20184 , { name = "Judgement of Justice", short = "Justice", duration = 10, color = colors.BLACK })

Spell({ 853, 5588, 5589, 10308 }, { name = "Hammer of Justice", short = "Hammer", color = colors.FROZEN,
    duration = function(timer)
        if timer.spellID == 853 then return 3
        elseif timer.spellID == 5588 then return 4
        elseif timer.spellID == 5589 then return 5
        else return 6 end
    end
}) -- varies

Spell( 20216 ,{ name = "Divine Favor", shine = true, duration = 15, priority = 12, timeless = true, scale = 0.7, color = colors.DPURPLE })
Cooldown( 26573 ,{ name = "Consecration", color = colors.PINKIERED, priority = 9, scale = 0.85, ghost = true })
Cooldown( 20473 ,{ name = "Holy Shock", ghost = 1, priority = 5, scale_until = 5, color = colors.WOO })

Spell({ 20925, 20927, 20928 }, { name = "Holy Shield", duration = 10, priority = 7, scale = 1, ghost = true, arrow = colors.PINK2, color = colors.PINK3 })

end

if class == "HUNTER" then

Spell( 19263 ,{ name = "Deterrence", duration = 10, color = colors.LBLUE, shine = true, group = "buffs" })
Spell( 3045 ,{ name = "Rapid Fire", duration = 15, color = colors.PINK2, group = "buffs" })
Spell( 19574 ,{ name = "Bestial Wrath", duration = 18, target = "pet", group = "buffs", shine = true, color = colors.LRED })

Spell({ 1513, 14326, 14327 }, { name = "Scare Beast",
    duration = function(timer)
        if timer.spellID == 1513 then return 10
        elseif timer.spellID == 14326 then return 15
        else return 20 end
    end
})

Spell({ 1978, 13549, 13550, 13551, 13552, 13553, 13554, 13555, 25295 }, { name = "Serpent Sting", duration = 15, color = colors.PURPLE, ghost = true, preghost = true, })
Spell({ 3043, 14275, 14276, 14277 }, { name = "Scorpid Sting", duration = 20, color = colors.TEAL })
Spell({ 3034, 14279, 14280 }, { name = "Viper Sting", duration = 8, color = colors.DBLUE })
Spell({ 19386, 24132, 24133 }, { name = "Wyvern Sting", duration = 12, color = colors.GREEN })


Spell(19229, { name = "Wing Clip", shine = true, duration = 5, scale = 0.6, color = colors.DBROWN })
Spell({ 19306, 20909, 20910 }, { name = "Counterattack", shine = true, duration = 5, scale = 0.6, color = colors.DBROWN })

Cooldown( 19306 ,{ name = "Counterattack", ghost = 1, priority = 5, color = colors.PURPLE4 })
Activation( 19306, { for_cd = true, effect = "JUDGEMENT", ghost = 5 })
helpers.OnUsableTrigger(19306)

Spell({ 13812, 14314, 14315 }, { name = "Explosive Trap", duration = 20, maxtimers = 1, color = colors.RED, ghost = 1 })
Spell({ 13797, 14298, 14299, 14300, 14301 }, { name = "Immolation Trap", duration = 20, color = colors.RED, ghost = 1 })
Spell({ 3355, 14308, 14309 }, { name = "Freezing Trap", color = colors.FROZEN,
    duration = function(timer)
        local mul = 1 + 0.15*GotSpell(19239) + 0.15*GotSpell(19245)
        if timer.spellID == 3355 then return 10*mul
        elseif timer.spellID == 14308 then return 15*mul
        else return 20*mul end
    end
})

Spell( 19503 , { name = "Scatter Shot", duration = 4, color = colors.PINK3, shine = true })

Cooldown( 1495 ,{ name = "Mongoose Bite", ghost = true, priority = 4, color = colors.WOO })
Cooldown( 2973 ,{ name = "Raptor Strike", ghost = 1, priority = 3, color = colors.LBLUE })

Cooldown( 19434 ,{ name = "Aimed Shot", ghost = true, priority = 10, color = colors.TEAL3 })
Cooldown( 2643 ,{ name = "Multi-Shot", ghost = true, priority = 5, color = colors.PINK3 })
Cooldown( 3044 ,{ name = "Arcane Shot", ghost = true, priority = 7, color = colors.PINK })
Spell({ 2974, 14267, 14268 }, { name = "Wing Clip", duration = 10, color = colors.BROWN })
Spell( 5116 ,{ name = "Concussive Shot", duration = 4, color = colors.BROWN })
Spell( 19410 ,{ name = "Conc Stun", duration = 3, shine = true, color = colors.RED })
Spell( 24394 ,{ name = "Intimidation", duration = 3, shine = true, color = colors.RED })

end

if class == "DRUID" then
Interrupt(16979, "Feral Charge", 4)

Spell( 22812 ,{ name = "Barkskin", duration = 15, color = colors.WOO2, group = "buffs" })
Spell({ 339, 1062, 5195, 5196, 9852, 9853 }, { name = "Entangling Roots", color = colors.DBROWN,
    duration = function(timer)
        if timer.spellID == 339 then return 12
        elseif timer.spellID == 1062 then return 15
        elseif timer.spellID == 5195 then return 18
        elseif timer.spellID == 5196 then return 21
        elseif timer.spellID == 9852 then return 24
        else return 27 end
    end
}) -- varies
Spell({ 2908, 8955, 9901 }, { name = "Soothe Animal", duration = 15, color = colors.PURPLE5 })
-- includes Faerie Fire (Feral) ranks
Spell({ 770, 778, 9749, 9907, 17390, 17391, 17392 }, { name = "Faerie Fire", duration = 40, color = colors.PURPLE5 })
Spell({ 2637, 18657, 18658 }, { name = "Hibernate", color = colors.PURPLE4, nameplates = true,
    duration = function(timer)
        if timer.spellID == 2637 then return 20
        elseif timer.spellID == 18657 then return 30
        else return 40 end
    end
}) -- varies
Spell({ 99, 1735, 9490, 9747, 9898 }, { name = "Demoralizing Roar", duration = 30, color = colors.DTEAL, shinerefresh = true })
Spell({ 5211, 6798, 8983 }, { name = "Bash", color = colors.RED,
    duration = function(timer)
        if timer.spellID == 5211 then return 2
        elseif timer.spellID == 6798 then return 3
        else return 4 end
    end
}) -- varies

Spell( 5209 , { name = "Challenging Roar", duration = 6, maxtimers = 1 })
Spell( 6795 ,{ name = "Taunt", duration = 3 })

Spell({ 1850, 9821 }, { name = "Dash", duration = 15 })
Spell( 5229, { name = "Enrage", color = colors.PURPLE4, shine = true, scale = 0.6, group = "buffs", duration = 10 })
Spell({ 22842, 22895, 22896 }, { name = "Frenzied Regeneration", duration = 10, color = colors.LGREEN })

Spell( 16922, { name = "Starfire Stun", duration = 3, shine = true, color = colors.RED })
Spell({ 9005, 9823, 9827 }, { name = "Pounce", duration = 2, priority = -20, color = colors.RED })
Spell({ 9007, 9824, 9826 }, { name = "Pounce Bleed", duration = 18, priority = 4, color = colors.PINK3 })
Spell({ 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835 }, { name = "Moonfire", duration = 12, priority = 5, ghost = true, color = colors.PURPLE, nameplates = true,
duration = function(timer)
    if timer.spellID == 8921 then return 9
    else return 12 end
end
})
Spell({ 1822, 1823, 1824, 9904 }, { name = "Rake", tick = 3, overlay = {"tick", "end"}, duration = 9, priority = 6, nameplates = true, ghost = true, color = colors.PINKIERED })
Spell({ 1079, 9492, 9493, 9752, 9894, 9896 }, { name = "Rip", tick = 2, overlay = {"tick", "end"}, duration = 12, priority = 5, ghost = true, nameplates = true, color = colors.RED })
Spell({ 5217, 6793, 9845, 9846 }, { name = "Tiger's Fury", duration = 6, color = colors.GOLD, scale = 0.7, group = "buffs", shine = true })

Spell( 2893 ,{ name = "Abolish Poison", tick = 2, tickshine = true, overlay = {"tick", "end"}, group = "buffs", duration = 8, color = colors.TEAL2 })
Spell( 29166 , { name = "Innervate", duration = 20, shine = true, color = colors.DBLUE })

Spell({ 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858 }, { name = "Regrowth", duration = 21, scale = 0.7, color = colors.LGREEN })
Spell({ 774, 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299 }, { name = "Rejuvenation", scale = 1, duration = 12, color = colors.REJUV })
Spell( 16870 ,{ name = "Clearcasting", shine = true, group = "buffs", duration = 15, color = colors.CHIM })

Spell({ 5570, 24974, 24975, 24976, 24977 }, { name = "Insect Swarm", duration = 12, priority = 6, color = colors.TEAL3, ghost = true, nameplates = true, })
Spell( 17116 ,{ name = "Nature's Swiftness", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })


end

if class == "MAGE" then
Interrupt(2139, "Counterspell", 10)

Spell( 18469 ,{ name = "Silence", duration = 4, color = colors.CHIM }) -- Improved Counterspell
Spell({ 118, 12824, 12825, 12826, 28270, 28271, 28272 },{ name = "Polymorph", glowtime = 5, ghost = 1, ghosteffect = "NIGHTBORNE", color = colors.LGREEN,
    duration = function(timer)
        if timer.spellID == 118 then return 20
        elseif timer.spellID == 12824 then return 30
        elseif timer.spellID == 12825 then return 40
        else return 50 end
    end
}) -- varies


Spell( 11958 ,{ name = "Ice Block", duration = 10, color = colors.CHIM, group = "buffs", shine = true })
Spell({ 1463, 8494, 8495, 10191, 10192, 10193 }, { name = "Mana Shield", duration = 60, ghost = true, group = "buffs", color = colors.TEAL })
Spell({ 11426, 13031, 13032, 13033 }, { name = "Ice Barrier", duration = 60, ghost = true, group = "buffs", color = colors.TEAL3 })
Spell({ 543, 8457, 8458, 10223, 10225 }, { name = "Fire Ward", duration = 30, group = "buffs", scale = 0.7, color = colors.ORANGE })
Spell({ 6143, 8461, 8462, 10177, 28609 }, { name = "Frost Ward", duration = 30, group = "buffs", scale = 0.7, color = colors.LBLUE })
Spell( 28682 ,{ name = "Combustion", color = colors.PINK2, timeless = true, group = "buffs", priority = -20, duration = 10 })

Cooldown( 2136, { name = "Fire Blast", color = colors.LRED, ghost = true })

Spell( 12355 ,{ name = "Impact", duration = 2, shine = true, color = colors.PURPLE3 }) -- fire talent stun proc
Spell( 12654 ,{ name = "Ignite", duration = 4, affiliation = "raid", shine = true, shinerefresh = true, ghost = true, ghosteffect = "JUDGEMENT", color = colors.PINK3 })
EventTimer({ spellID = 12654, event = "SPELL_PERIODIC_DAMAGE",
    action = function(active, srcGUID, dstGUID, spellID, damage )
        local ignite_timer = NugRunning.gettimer(active, spellID, dstGUID, "DEBUFF")
        if ignite_timer then
            ignite_timer:SetName(damage)
        end
    end})
Spell( 22959 ,{ name = "Fire Vulnerability", duration = 30, scale = 0.5, priority = -10, glowtime = 4, affiliation = "raid", ghost = true, ghosteffect = "AEGWYNN", color = colors.BROWN })

-- Reserved to Flamestrike
-- EventTimer({ spellID = 153561, event = "SPELL_CAST_SUCCESS", name = "Meteor", duration = 2.9, color = colors.FIRE })

Spell({ 11113, 13018, 13019, 13020, 13021 }, { name = "Blast Wave", duration = 6, scale = 0.6,  color = colors.DBROWN, maxtimers = 1 })
Spell({ 120, 8492, 10159, 10160, 10161 }, { name = "Cone of Cold", scale = 0.6,  color = colors.CHILL, maxtimers = 1,
    duration = function(timer)
        local permafrost = GotSpell(11175) + GotSpell(12569) + GotSpell(12571)
        return 8 + permafrost
    end
})
Spell({ 116, 205, 837, 7322, 8406, 8407, 8408, 10179, 10180, 10181, 25304 }, { name = "Frostbolt", scale = 0.6, color = colors.CHILL,
    duration = function(timer)
        local permafrost = GotSpell(11175) + GotSpell(12569) + GotSpell(12571)
        if timer.spellID == 116 then return 5 + permafrost
        elseif timer.spellID == 205 then return 6 + permafrost
        elseif timer.spellID == 837 then return 6 + permafrost
        elseif timer.spellID == 7322 then return 7 + permafrost
        elseif timer.spellID == 8406 then return 7 + permafrost
        elseif timer.spellID == 8407 then return 8 + permafrost
        elseif timer.spellID == 8408 then return 8 + permafrost
        else return 9 + permafrost end
    end
}) -- varies


Spell( 12494 ,{ name = "Frostbite", duration = 5, color = colors.FROZEN, shine = true })
Spell({ 122, 865, 6131, 10230 } ,{ name = "Frost Nova", duration = 8, color = colors.FROZEN, maxtimers = 1 })

Spell( 12536 ,{ name = "Clearcasting", shine = true, group = "buffs", duration = 15, color = colors.CHIM })
Spell( 12043 ,{ name = "Presence of Mind", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })
Spell( 12042 ,{ name = "Arcane Power", duration = 15, group = "buffs", color = colors.PINK })

end

if class == "PRIEST" then

Spell( 15487 ,{ name = "Silence", duration = 5, color = colors.PINK })

Cast({ 17311, 17312, 17313, 17314, 18807 }, { name = "Mind Flay", short = "", priority = 13, tick = 1, overlay = {"tick", "tickend"}, color = colors.PURPLE2, priority = 11, duration = 3, scale = 0.8 })
Spell({ 10797, 19296, 19299, 19302, 19303, 19304, 19305 }, { name = "Starshards", duration = 6, priority = 9, color = colors.CHIM })
Spell({ 2944, 19276, 19277, 19278, 19279, 19280 }, { name = "Devouring Plague", duration = 24, priority = 9, color = colors.PURPLE4 })

Spell({ 453, 8192, 10953 }, { name = "Mind Soothe", duration = 15, color = colors.PURPLE5 })

Spell({ 9484, 9485, 10955 }, { name = "Shackle Undead", glowtime = 5, nameplates = true, color = colors.PURPLE3, ghost = 1, ghosteffect = "NIGHTBORNE",
    duration = function(timer)
        if timer.spellID == 9484 then return 30
        elseif timer.spellID == 9485 then return 40
        else return 50 end
    end
}) -- varies
Spell( 10060, { name = "Power Infusion", duration = 15, group = "buffs", color = colors.TEAL2 })
-- make charged to 20?
Spell({ 588, 602, 1006, 7128, 10951, 10952 }, { name = "Inner Fire", duration = 600, priority = -100, color = colors.GOLD })
Spell({ 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901 }, { name = "Power Word: Shield", short = "Shield", shinerefresh = true, duration = 30, color = colors.LRED })
Spell( 552 , { name = "Abolish Disease", tick = 5, tickshine = true, overlay = {"tick", "end"}, duration = 20, scale = 0.5, color = colors.BROWN })

Spell({ 14914, 15261, 15262, 15263, 15264, 15265, 15266, 15267 }, { name = "Holy Fire", color = colors.PINK, duration = 10, ghost = true })
Spell({ 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315 }, { name = "Renew", shinerefresh = true, color = colors.LGREEN, duration = 15,  scale = 0.8  })
Spell({ 586, 9578, 9579, 9592, 10941, 10942 }, { name = "Fade", duration = 10, scale = 0.6, shine = true, color = colors.CHILL })
Cooldown( 8092, { name = "Mind Blast", priority = 9, recast_mark = 1.5, color = colors.CURSE, ghosteffect = "NIGHTBORNE", ghost = true })

Spell({ 8122, 8124, 10888, 10890 }, { name = "Psychic Scream", duration = 8, shine = true, maxtimers = 1 })
Spell({ 589, 594, 970, 992, 2767, 10892, 10893, 10894 }, { name = "Shadow Word: Pain", short = "Pain", ghost = true, nameplates = true, priority = 8, color = colors.PURPLE,
    duration = function(timer, opts)
        local duration = 18
        -- Improved SWP, 2 ranks: Increases the duration of your Shadow Word: Pain spell by 3 sec.
        return duration + 3*helpers.Talent(15275) + 3*helpers.Talent(15317)
    end
 }) -- varies by talents

Spell( 15269 ,{ name = "Blackout", duration = 3, shine = true, color = colors.PURPLE3 })
-- Cast( 15407, { name = "Mind Flay", short = "", priority = 12, tick = 1, overlay = {"tick", "tickend"}, color = colors.PURPLE2, priority = 11, duration = 3, scale = 0.8 })
-- Spell( 15258 ,{ name = "Shadow Vulnerability", short = "Vulnerability", duration = 15, scale = 0.5, priority = -10, glowtime = 4, ghost = true, ghosteffect = "AEGWYNN", color = colors.DPURPLE })
Spell( 15286 ,{ name = "Vampiric Embrace", duration = 60, priority = 5, scale_until = 10, shinerefresh = true, ghost = true, ghosteffect = "AEGWYNN", color = colors.PURPLE4 })
Spell( 14751 ,{ name = "Inner Focus", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.WOO2DARK })

end

if class == "ROGUE" then
Interrupt({ 1766, 1767, 1768, 1769 }, "Kick", 5)

Spell( 18425 ,{ name = "Silence", duration = 2, color = colors.PINK }) -- Improved Kick

Spell( 13750 ,{ name = "Adrenaline Rush", group = "buffs", priority = -5, duration = 15, color = colors.LRED })
Spell( 13877 ,{ name = "Blade Flurry", group = "buffs", priority = -4, duration = 15, color = colors.PURPLE5 })

-- TODO: Premeditation timer

Spell( 1833 , { name = "Cheap Shot", duration = 4, color = colors.LRED })
Spell({ 2070, 6770, 11297 }, { name = "Sap", color = colors.LBLUE, glowtime = 5, ghost = 1, ghosteffect = "NIGHTBORNE",
    duration = function(timer)
        if timer.spellID == 6770 then return 25 -- yes, Rank 1 spell id is 6770 actually
        elseif timer.spellID == 2070 then return 35
        else return 45 end
    end
}) -- varies
Spell( 2094 , { name = "Blind", duration = 10, color = colors.WOO })

Spell({ 1856, 1857 }, { name = "Vanish", duration = 10, group = "buffs", scale = 0.5, color = colors.BLACK })

Spell({ 8647, 8649, 8650, 11197, 11198 }, { name = "Expose Armor", duration = 30, color = colors.WOO2 })
Spell({ 703, 8631, 8632, 8633, 11289, 1129 }, { name = "Garrote", color = colors.PINK3, duration = 18 })
Spell({ 408, 8643 }, { name = "Kidney Shot", shine = true, color = colors.LRED,
    duration = function(timer)
        local duration = timer.spellID == 8643 and 1 or 0 -- if Rank 2, add 1s
        return duration + GetCP()
    end,
}) -- varies
Spell({ 1943, 8639, 8640, 11273, 11274, 11275 }, { name = "Rupture", tick = 2, tickshine = true, overlay = {"tick", "end"}, shine = true, color = colors.RED, 
    duration = function() return (6 + GetCP()*2) end,
}) -- varies
Spell({ 5171, 6774 }, { name = "Slice and Dice", shinerefresh = true, color = colors.PURPLE,
    duration = function(timer)
        local mul = 1 + 0.15*helpers.Talent(14165) + 0.15*helpers.Talent(14166) + 0.15*helpers.Talent(14167)
        return (6 + GetCP()*3)*mul
    end
}) -- varies

Spell({ 2983, 8696, 11305 }, { name = "Sprint", group = "buffs", shine = true, duration = 8 })
Spell( 5277 ,{ name = "Evasion", group = "buffs", color = colors.PINK, duration = 15 })
Spell({ 1776, 1777, 8629, 11285, 11286 }, { name = "Gouge", shine = true, color = colors.PINK3,
    duration = function(timer)
        return 4 + 0.5*GotSpell(13741) + 0.5*GotSpell(13793) + 0.5*GotSpell(13792)
    end
})

Spell( 14177 ,{ name = "Cold Blood", shine = true, duration = 15, group = "buffs", priority = -12, timeless = true, scale = 0.7, color = colors.DTEAL })
Spell({ 14143, 14149 }, { name = "Remorseless", group = "buffs", scale = 0.75, duration = 20, color = colors.TEAL3 })
Cooldown( 14251, { name = "Riposte", color = colors.PURPLE2, scale = 0.8 })
Activation( 14251, { for_cd = true, effect = "JUDGEMENT", ghost = 6 })
helpers.OnUsableTrigger(14251)
Cooldown( 14278, { name = "Ghostly Strike", color = colors.WOO, ghost = true, scale_until = 5, })

EventTimer({ event = "SPELL_CAST_SUCCESS", spellID = 1725, name = "Distract", color = colors.WOO2DARK, duration = 10 })

end

if class == "WARRIOR" then
Interrupt({ 6552, 6554 }, "Pummel", 4)
Interrupt({ 72, 1671, 1672 }, "Shield Bash", 6)

Spell( 18498 ,{ name = "Silence", duration = 3, color = colors.PINK }) -- Improved Shield Bash

Spell( 20230 ,{ name = "Retaliation", group = "buffs", shine = true, duration = 15, color = colors.PINK })
Spell( 1719 ,{ name = "Recklessness", group = "buffs", shine = true, duration = 15, color = colors.REJUV })
Spell( 871, { name = "Shield Wall", group = "buffs", shine = true, duration = 10, color = colors.WOO }) -- varies
Spell( 12976, { name = "Last Stand", group = "buffs", color = colors.PURPLE3, duration = 20, priority = -8 })
Spell( 12328, { name = "Death Wish", group = "buffs", shine = true, duration = 30, color = colors.PINKIERED })

Spell({ 772, 6546, 6547, 6548, 11572, 11573, 11574 }, { name = "Rend", tick = 3, tickshine = true, overlay = {"tick", "end"}, color = colors.RED, ghost = true,
    duration = function(timer)
        if timer.spellID == 772 then return 9
        elseif timer.spellID == 6546 then return 12
        elseif timer.spellID == 6547 then return 15
        elseif timer.spellID == 6548 then return 18
        else return 21 end
    end
}) -- varies
Spell({ 1715, 7372, 7373 }, { name = "Hamstring", ghost = true, color = colors.PURPLE4, duration = 15 })
Spell( 23694 , { name = "Immobilized", shine = true, color = colors.BLACK, duration = 5 }) -- Improved Hamstring

Spell({ 694, 7400, 7402, 20559, 20560 }, { name = "Mocking Blow", color = colors.LRED, duration = 6, shine = true })
Spell( 1161 ,{ name = "Challenging Shout", duration = 6, maxtimers = 1 })
Spell( 355 ,{ name = "Taunt", duration = 3 })

Cooldown( 7384, { name = "Overpower", shine = true, color = colors.LBLUE, scale = 0.75, priority = 7 })
Activation( 7384, { for_cd = true, effect = "NIGHTBORNE", ghost = 6 })
helpers.OnUsableTrigger(7384)

Cooldown( 6343, { name = "Thunder Clap", ghost = 1, scale = 0.8, color = colors.PINKIERED, priority = 9.5 })
Spell({ 5242, 6192, 6673, 11549, 11550, 11551, 25289 }, { name = "Battle Shout", ghost = true, scale_until = 20, priority = -300, glow2time = 10, color = colors.DPURPLE, duration = 120 })
Spell({ 1160, 6190, 11554, 11555, 11556 }, { name = "Demoralizing Shout", duration = 30, color = colors.DTEAL, shinerefresh = true })
Spell( 18499, { name = "Berserker Rage", color = colors.REJUV, shine = true, scale = 0.6, group = "buffs", duration = 10 })
Spell({ 20253, 20614, 20615 }, { name = "Intercept", duration = 3, shine = true, color = colors.DRED })

Spell( 12323, { name = "Piercing Howl", maxtimers = 1, duration = 6, color = colors.DBROWN })
Spell( 5246 ,{ name = "Intimidating Shout", duration = 8, maxtimers = 1 })

Spell( 676 ,{ name = "Disarm", color = colors.PINK3, scale = 0.8, shine = true,
    duration = function(timer)
        return 10 + GotSpell(12313) + GotSpell(12804) + GotSpell(12807)
    end,
}) -- varies
-- Spell( 29131 ,{ name = "Bloodrage", color = colors.WOO, duration = 10, scale = 0.5, shine = true })

Cooldown( 6572 ,{ name = "Revenge", priority = 5, color = colors.PURPLE, resetable = true, fixedlen = 6, ghost = 1 })
Activation( 6572, { for_cd = true, effect = "JUDGEMENT", ghost = 6 })
-- There's no spell activation overlay in classic, so using SPELL_UPDATE_USABLE to emulate it
helpers.OnUsableTrigger(6572)

Spell( 12798 , { name = "Revenge Stun", duration = 3, shine = true, color = colors.DRED })

Spell( 2565 ,{ name = "Shield Block", color = colors.WOO2, shine = true, group = "buffs", shinerefresh = true, priority = - 9, duration = 5, arrow = colors.LGREEN }) -- varies BUFF
Cooldown( 2565 ,{ name = "Shield Block", priority = 9.9, scale = 0.5, ghost = true, color = colors.DPURPLE })

Cooldown( 23922, { name = "Shield Slam", tick = 1.5, tickshine = true, overlay = {"tick", "end"}, short = "", priority = 10, fixedlen = 6, ghost = true, ghosteffect = "NIGHTBORNE", color = colors.CURSE })
Cooldown( 12294, { name = "Mortal Strike", tick = 1.5, tickshine = true, overlay = {"tick", "end"}, priority = 10, short = "", fixedlen = 6, ghost = true, ghosteffect = "NIGHTBORNE",  color = colors.CURSE })
Cooldown( 23881, { name = "Bloodthirst", tick = 1.5, tickshine = true, overlay = {"tick", "end"}, priority = 10, short = "", fixedlen = 6, ghost = true, ghosteffect = "NIGHTBORNE",  color = colors.CURSE })

-- Make Charges?
Spell({ 7386, 7405, 8380, 11596, 11597 }, { name = "Sunder Armor", duration = 30, color = colors.DBROWN })
Spell( 12809 ,{ name = "Concussion Blow", color = colors.TEAL2, shine = true, duration = 5 })
Spell( 12292 ,{ name = "Sweeping Strikes", group = "buffs", shine = true, priority = -100503, color = colors.LRED, duration = 20, scale = 0.8 })
Spell({ 12880, 14201, 14202, 14203, 14204 }, { name = "Enrage", color = colors.PURPLE4, shine = true, shinerefresh = true, scale = 0.75, group = "buffs", priority = -3, duration = 12 })
Spell({ 12966, 12967, 12968, 12969, 12970 }, { name = "Flurry", color = colors.PURPLE5, shinerefresh = true, scale = 0.5, group = "buffs", priority = -1, duration = 15 })

end