--A MISTWEAVER rotation by Mack

ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit, spell) then
        ProbablyEngine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

ProbablyEngine.rotation.register_custom(270, "Macks Fire 1.0", {

  --buffs/pause
--{ "pause", "player.buff(Divine Hymn)" }, --Pause
--{ "pause", "player.buff(Hymn of Hope)" }, --Pause
{ "115921", "!player.buffs.stats" }, --stats

--SURVIVAL
{ "!115203", { 
    "player.health <= 35" 
  }, "Player" },--fortifying brew
{ "!5512", "player.health <= 50" },  --healthstone

--CDs
{ "!115310", "modifier.lalt" },  --Revival
{"115313", "modifier.rcontrol", "ground" }, --statue
{"spinning crane kick", "modifier.lshift"},  --sck or rjw


--Tier 2 CD's

  { "123986", "modifier.lcontrol", "player" },  --chi burst
  { "124081", "modifier.lcontrol", "lowest" }, --zen shpere
  { "115098", "modifier.lcontrol", "lowest" }, --chi wave

--Expel Harm
  { "Expel Harm", {"lowest.health <= 100","player.chi < 4"}, "lowest" },



--!!!!!!!!!!!!!!!    JADE SERPENT STANCE      !!!!!!!!!!!!!!!!!
{{
 --ReM @3 stacks
 { "!Renewing Mist", { "lowest.buff(119611).duration <= 2", "lowest.spell(Renewing Mist).charges = 3" , "player.chi < 4" } , "lowest" }, 

--Need MORE MANA
{ "!115294", { "player.mana < 8", "player.buff(115867).count >= 2", "!player.moving"}}, -- mana tea

--Tank emergency Healing
{ "!Life Cocoon", "tank.health <= 15", "tank"},
{ "!115175", { "tank.health <= 15",  "!modifier.last" ,"!player.moving" }, "tank" }, -- Soothing Mist
{ "!116680", "tank.health <= 15" , "player" }, -- TFT
{ "124682", { "player.casting(Soothing Mist)", "tank.health <= 18", "player.chi > 2" }, "tank" }, -- EnM
{ "116694", { "player.casting(Soothing Mist)", "tank.health <= 18" }, "tank" }, -- Surging Mist

--Emergency Healing
{ "!115175", { "lowest.health <= 15", "!modifier.last", "!player.moving" }, "lowest" }, -- Soothing Mist
{ "116680", "lowest.health <= 15" , "player" }, -- TFT
{ "124682", { "player.casting(Soothing Mist)", "lowest.health <= 15", "player.chi > 2" }, "lowest" }, -- EnM
{ "116694", { "player.casting(Soothing Mist)", "lowest.health <= 15" }, "lowest" }, -- Surging Mist

--MANA
{ "115294", { "player.mana < 75", "player.buff(115867).count >= 2", "!player.moving", "!@coreHealing.needsHealing(50, 5)"}}, -- mana tea




--!!!!  AoE If multitarget is enabled. ReM/Uplift healing  !!!!
{{
  
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 4", "lowest.spell(Renewing Mist).charges > 1" , "player.chi < 4"}, "lowest" }, --ReM 

{ "!Uplift", { "@coreHealing.needsHealing(90, 5)", "player.chi >= 2", "!player.moving" }, "lowest" }, --Uplift
{ "!Renewing Mist", { "lowest.buff(119611).duration <= 6", "player.chi < 2", "@coreHealing.needsHealing(70, 5)" }, "lowest" }, --ReM Need Chi

}, "modifier.multitarget"},



--Lowest if below 60% (tank included), tank if below 80%, anyone

{ "115175", {"lowest.health <= 60","!player.moving"}, "lowest" }, -- Soothing Mist
{ "124682", { "player.casting(Soothing Mist)", "lowest.health <= 75", "player.chi > 2" }, "lowest" }, -- EnM
{ "116694", { "player.casting(Soothing Mist)", "lowest.health <= 50" }, "lowest" }, -- Surging Mist

{ "115175", {"tank.health <= 80","!player.moving"}, "tank" }, -- Soothing Mist
{ "124682", { "player.casting(Soothing Mist)", "tank.health <= 80", "player.chi > 2" }, "tank" }, -- EnM
{ "116694", { "player.casting(Soothing Mist)", "tank.health <= 60" }, "tank" }, -- Surging Mist

{ "115175", {"lowest.health <= 100","!player.moving"}, "lowest" }, -- Soothing Mist



}, "player.stance = 1" },



--!!!!!!!!!!!!!!!         CRANE STANCE DPS          !!!!!!!!!!!!!!!!!!!!!!



{{
  -- Auto Target
    { "/cleartarget", {
      "toggle.autotarget", 
      (function() return UnitIsFriend("player","target") end)
      }},
    { "/target [target=focustarget, harm, nodead]", {"target.range > 40", "!target.exists","toggle.autotarget"} },
    { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
      { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},


{ "Surging Mist", "player.buff(Vital Mists).count = 5" },
{"Tiger Palm", {"player.buff(Vital Mists.count = 4", "player.chi > 0" }},
{ "Rising Sun Kick", {"target.debuff(130320).duration < 5", "player.chi > 1"} },
{"Blackout Kick", {"player.buff(127722).duration < 5", "player.chi > 1" }},
{"Tiger Palm", {"player.buff(125359).duration < 5", "player.chi > 0" }},
{"Blackout Kick",  "player.chi > 1" },
{"Jab"}, 



}, "player.stance = 2"},


},{
--out of combat
{ "115921", "!player.buffs.stats" }, --stats
{ "115921", "!raid.buffs.stats" }, --stats
{"115313", "modifier.rcontrol", "ground" }, --statue
},function()

end)
