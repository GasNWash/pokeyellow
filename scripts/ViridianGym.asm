ViridianGym_Script:
	ld hl, .CityName
	ld de, .LeaderName
	call LoadGymLeaderAndCityName
	call EnableAutoTextBoxDrawing
	ld hl, ViridianGymTrainerHeaders
	ld de, ViridianGym_ScriptPointers
	ld a, [wViridianGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianGymCurScript], a
	ret

.CityName:
	db "VIRIDIAN CITY@"

.LeaderName:
	db "GIOVANNI@"

ViridianGymResetScripts:
	CheckAndResetEvent EVENT_052
	call nz, ViridianGymScript_HideJessieJames
	xor a
	ld [wJoyIgnore], a
ViridianGymSetScript:
	ld [wViridianGymCurScript], a
	ld [wCurMapScript], a
	ret

ViridianGymScript_HideJessieJames:
	ld a, HS_VIRIDIAN_GYM_JAMES 
	call ViridianScript_HideObject
	ld a, HS_VIRIDIAN_GYM_JESSIE
	call ViridianGymScript_HideObject
	ret

ViridianGym_ScriptPointers:
	def_script_pointers
	dw_const ViridianGymDefaultScript,              SCRIPT_VIRIDIANGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VIRIDIANGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VIRIDIANGYM_END_BATTLE
	dw_const ViridianGymGiovanniPostBattle,         SCRIPT_VIRIDIANGYM_GIOVANNI_POST_BATTLE
	dw_const ViridianGymScript5,               SCRIPT_VIRIDIANGYM_SCRIPT5
	dw_const ViridianGymScript6,               SCRIPT_VIRIDIANGYM_SCRIPT6
	dw_const ViridianGymScript7,               SCRIPT_VIRIDIANGYM_SCRIPT7
	dw_const ViridianGymScript8,               SCRIPT_VIRIDIANGYM_SCRIPT8
	dw_const ViridianGymScript9,               SCRIPT_VIRIDIANGYM_SCRIPT9
	dw_const ViridianGymScript10,               SCRIPT_VIRIDIANGYM_SCRIPT10
	dw_const ViridianGymScript11,              SCRIPT_VIRIDIANGYM_SCRIPT11
	dw_const ViridianGymScript12,              SCRIPT_VIRIDIANGYM_SCRIPT12
	dw_const ViridianGymScript13,              SCRIPT_VIRIDIANGYM_SCRIPT13
	dw_const ViridianGymScript14,              SCRIPT_VIRIDIANGYM_SCRIPT14
	dw_const ViridianGymPlayerSpinningScript,       SCRIPT_VIRIDIANGYM_PLAYER_SPINNING

ViridianGymDefaultScript:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, ViridianGymArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES
	call z, ViridianGymScript_455a5
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7
	jp z, CheckFightingMapTrainers
	call StartSimulatingJoypadStates
	ld hl, wd736
	set 7, [hl]
	ld a, SFX_ARROW_TILES
	call PlaySound
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANGYM_PLAYER_SPINNING
	ld [wCurMapScript], a
	ret

ViridianGymArrowTilePlayerMovement:
	map_coord_movement 19, 11, ViridianGymArrowMovement1
	map_coord_movement 19,  1, ViridianGymArrowMovement2
	map_coord_movement 18,  2, ViridianGymArrowMovement3
	map_coord_movement 11,  2, ViridianGymArrowMovement4
	map_coord_movement 16, 10, ViridianGymArrowMovement5
	map_coord_movement  4,  6, ViridianGymArrowMovement6
	map_coord_movement  5, 13, ViridianGymArrowMovement7
	map_coord_movement  4, 14, ViridianGymArrowMovement8
	map_coord_movement  0, 15, ViridianGymArrowMovement9
	map_coord_movement  1, 15, ViridianGymArrowMovement10
	map_coord_movement 13, 16, ViridianGymArrowMovement11
	map_coord_movement 13, 17, ViridianGymArrowMovement12
	db -1 ; end

ViridianGymArrowMovement1:
	db D_UP, 9
	db -1 ; end

ViridianGymArrowMovement2:
	db D_LEFT, 8
	db -1 ; end

ViridianGymArrowMovement3:
	db D_DOWN, 9
	db -1 ; end

ViridianGymArrowMovement4:
	db D_RIGHT, 6
	db -1 ; end

ViridianGymArrowMovement5:
	db D_DOWN, 2
	db -1 ; end

ViridianGymArrowMovement6:
	db D_DOWN, 7
	db -1 ; end

ViridianGymArrowMovement7:
	db D_RIGHT, 8
	db -1 ; end

ViridianGymArrowMovement8:
	db D_RIGHT, 9
	db -1 ; end

ViridianGymArrowMovement9:
	db D_UP, 8
	db -1 ; end

ViridianGymArrowMovement10:
	db D_UP, 6
	db -1 ; end

ViridianGymArrowMovement11:
	db D_LEFT, 6
	db -1 ; end

ViridianGymArrowMovement12:
	db D_LEFT, 12
	db -1 ; end

ViridianGymPlayerSpinningScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, .ViridianGymLoadSpinnerArrow
	xor a
	ld [wJoyIgnore], a
	ld hl, wd736
	res 7, [hl]
	ld a, SCRIPT_VIRIDIANGYM_DEFAULT
	ld [wCurMapScript], a
	ret
.ViridianGymLoadSpinnerArrow
	farjp LoadSpinnerArrowTiles

ViridianGymGiovanniPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ViridianGymResetScripts
	ld a, D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
; fallthrough
ViridianGymReceiveTM27:
	ld a, TEXT_VIRIDIANGYM_GIOVANNI_EARTH_BADGE_INFO
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	lb bc, TM_FISSURE, 1
	call GiveItem
	jr nc, .bag_full
	ld a, TEXT_VIRIDIANGYM_GIOVANNI_RECEIVED_TM27
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM27
	jr .gym_victory
.bag_full
	ld a, TEXT_VIRIDIANGYM_GIOVANNI_TM27_NO_ROOM
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gym_victory
	ld hl, wObtainedBadges
	set BIT_EARTHBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_EARTHBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7

	ld a, HS_ROUTE_22_RIVAL_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	SetEvents EVENT_2ND_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	jp ViridianGymResetScripts

ViridianGymScript_455a5:
	ld a, [wYCoord]
	cp $e
	ret nz
	ResetEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp $18
	jr z, .asm_455c2
	ld a, [wXCoord]
	cp $19
	ret nz
	SetEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
.asm_455c2
	xor a
	ldh [hJoyHeld], a
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	call UpdateSprites
	call Delay3
	call UpdateSprites
	call Delay3
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_VIRIDIANGYM_TEXT17  ;;;;;;;;;;;
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, HS_VIRIDIAN_GYM_JAMES 
	call ViridianGymScript_ShowObject
	ld a, HS_VIRIDIAN_GYM_JESSIE
	call ViridianGymScript_ShowObject
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT5
	call ViridianGymSetScript
	ret

ViridianGymJessieJamesMovementData_45605:
	db $4
ViridianGymJessieJamesMovementData_45606:
	db $4
	db $4
	db $4
	db $ff

ViridianGymScript5:
	ld de, ViridianGymJessieJamesMovementData_45605
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
	jr z, .asm_45617
	ld de, ViridianGymJessieJamesMovementData_45606
.asm_45617
	ld a, VIRIDIANGYM_JAMES
	ldh [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT5
	call ViridianGymSetScript
	ret

ViridianGymScript6:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
ViridianGymScript7:
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_LEFT
	ld [wSprite02StateData1FacingDirection], a
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
	jr z, .asm_4564a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
.asm_4564a
	call Delay3
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
ViridianGymScript8:
	ld de, ViridianGymJessieJamesMovementData_45606
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
	jr z, .asm_4565f
	ld de, ViridianGymJessieJamesMovementData_45605
.asm_4565f
	ld a, VIRIDIANGYM_JESSIE
	ldh [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT9
	call ViridianGymSetScript
	ret

ViridianGymScript9:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
ViridianGymScript10:
	ld a, $2
	ld [wSprite03StateData1MovementStatus], a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite03StateData1FacingDirection], a
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES_ON_LEFT
	jr z, .asm_45697
	ld a, SPRITE_FACING_RIGHT
	ld [wSprite03StateData1FacingDirection], a
.asm_45697
	call Delay3
	ld a, TEXT_VIRIDIANGYM_TEXT18
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
ViridianGymScript11:
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ViridianGymJessieJamesEndBattleText
	ld de, ViridianGymJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2e
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_052
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT12
	call ViridianGymSetScript
	ret

ViridianGymScript12:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, ViridianGymResetScripts
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld [wSprite03StateData1MovementStatus], a
	xor a
	ld [wSprite02StateData1FacingDirection], a
	ld [wSprite03StateData1FacingDirection], a
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_VIRIDIANGYM_TEXT19
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT13
	call ViridianGymSetScript
	ret

ViridianGymScript13:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_VIRIDIAN_GYM_JAMES  
	call ViridianGymScript_HideObject
	ld a, HS_VIRIDIAN_GYM_JESSIE
	call ViridianGymScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_VIRIDIANGYM_SCRIPT14
	call ViridianGymSetScript
	ret

ViridianGymScript14:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_VIRIDIAN_GYM_JESSIE_JAMES
	ld a, SCRIPT_VIRIDIANGYM_DEFAULT
	call ViridianGymSetScript
	ret

ViridianGymScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

ViridianGymScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

ViridianGym_TextPointers:
	def_text_pointers
	dw_const ViridianGymGiovanniText,               TEXT_VIRIDIANGYM_GIOVANNI
	dw_const ViridianGymJessieJamesText,            TEXT_VIRIDIANGYM_JAMES
	dw_const ViridianGymJessieJamesText,            TEXT_VIRIDIANGYM_JESSIE
	dw_const ViridianGymCooltrainerM1Text,          TEXT_VIRIDIANGYM_COOLTRAINER_M1
	dw_const ViridianGymHiker1Text,                 TEXT_VIRIDIANGYM_HIKER1
	dw_const ViridianGymRocker1Text,                TEXT_VIRIDIANGYM_ROCKER1
	dw_const ViridianGymHiker2Text,                 TEXT_VIRIDIANGYM_HIKER2
	dw_const ViridianGymCooltrainerM2Text,          TEXT_VIRIDIANGYM_COOLTRAINER_M2
	dw_const ViridianGymHiker3Text,                 TEXT_VIRIDIANGYM_HIKER3
	dw_const ViridianGymRocker2Text,                TEXT_VIRIDIANGYM_ROCKER2
	dw_const ViridianGymCooltrainerM3Text,          TEXT_VIRIDIANGYM_COOLTRAINER_M3
	dw_const ViridianGymGymGuideText,               TEXT_VIRIDIANGYM_GYM_GUIDE
	dw_const PickUpItemText,                        TEXT_VIRIDIANGYM_REVIVE
	dw_const ViridianGymGiovanniEarthBadgeInfoText, TEXT_VIRIDIANGYM_GIOVANNI_EARTH_BADGE_INFO
	dw_const ViridianGymGiovanniReceivedTM27Text,   TEXT_VIRIDIANGYM_GIOVANNI_RECEIVED_TM27
	dw_const ViridianGymGiovanniTM27NoRoomText,     TEXT_VIRIDIANGYM_GIOVANNI_TM27_NO_ROOM
	dw_const ViridianGymText17,                     TEXT_VIRIDIANGYM_TEXT17
	dw_const ViridianGymText18,                TEXT_VIRIDIANGYM_TEXT18
	dw_const ViridianGymText19,                TEXT_VIRIDIANGYM_TEXT19

ViridianGymTrainerHeaders:
	def_trainers 5
ViridianGymTrainerHeader0:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, 4, ViridianGymCooltrainerM1BattleText, ViridianGymCooltrainerM1EndBattleText, ViridianGymCooltrainerM1AfterBattleText
ViridianGymTrainerHeader1:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1, 4, ViridianGymHiker1BattleText, ViridianGymHiker1EndBattleText, ViridianGymHiker1AfterBattleText
ViridianGymTrainerHeader2:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2, 4, ViridianGymRocker1BattleText, ViridianGymRocker1EndBattleText, ViridianGymRocker1AfterBattleText
ViridianGymTrainerHeader3:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3, 2, ViridianGymHiker2BattleText, ViridianGymHiker2EndBattleText, ViridianGymHiker2AfterBattleText
ViridianGymTrainerHeader4:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4, 3, ViridianGymCooltrainerM2BattleText, ViridianGymCooltrainerM2EndBattleText, ViridianGymCooltrainerM2AfterBattleText
ViridianGymTrainerHeader5:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5, 4, ViridianGymHiker3BattleText, ViridianGymHiker3EndBattleText, ViridianGymHiker3AfterBattleText
ViridianGymTrainerHeader6:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6, 3, ViridianGymRocker2BattleText, ViridianGymRocker2EndBattleText, ViridianGymRocker2AfterBattleText
ViridianGymTrainerHeader7:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7, 4, ViridianGymCooltrainerM3BattleText, ViridianGymCooltrainerM3EndBattleText, ViridianGymCooltrainerM3AfterBattleText
	db -1 ; end
ViridianGymJessieJamesText:
	text_end

ViridianGymText17:
	text_far _ViridianGymJessieJamesText1
	text_asm
	ld c, 10
	call DelayFrames
	ld a, $8
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

ViridianGymText18:
	text_far _ViridianGymJessieJamesText2
	text_end

ViridianGymJessieJamesEndBattleText:
	text_far _ViridianGymJessieJamesText3
	text_end

ViridianGymText19:
	text_far _ViridianGymJessieJamesText4
	text_asm
	ld c, 64
	call DelayFrames
	jp TextScriptEnd

ViridianGymGiovanniText:
	text_asm
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM27
	jr nz, .afterBeat
	call z, ViridianGymReceiveTM27
	call DisableWaitingAfterTextDisplay
	jr .text_script_end
.afterBeat
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .PostBattleAdviceText
	call PrintText
	call GBFadeOutToBlack
	ld a, HS_VIRIDIAN_GYM_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	jr .text_script_end
.beforeBeat
	ld hl, .PreBattleText
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, .ReceivedEarthBadgeText
	ld de, .ReceivedEarthBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $8
	ld [wGymLeaderNo], a
	ld a, SCRIPT_VIRIDIANGYM_GIOVANNI_POST_BATTLE
	ld [wViridianGymCurScript], a
.text_script_end
	jp TextScriptEnd

.PreBattleText:
	text_far _ViridianGymGiovanniPreBattleText
	text_end

.ReceivedEarthBadgeText:
	text_far _ViridianGymGiovanniReceivedEarthBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_end

.PostBattleAdviceText:
	text_far _ViridianGymGiovanniPostBattleAdviceText
	text_waitbutton
	text_end

ViridianGymGiovanniEarthBadgeInfoText:
	text_far _ViridianGymGiovanniEarthBadgeInfoText
	text_end

ViridianGymGiovanniReceivedTM27Text:
	text_far _ViridianGymGiovanniReceivedTM27Text
	sound_get_item_1

ViridianGymGiovanniTM27ExplanationText:
	text_far _ViridianGymGiovanniTM27ExplanationText
	text_end

ViridianGymGiovanniTM27NoRoomText:
	text_far _ViridianGymGiovanniTM27NoRoomText
	text_end

ViridianGymCooltrainerM1Text:
	text_asm
	ld hl, ViridianGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymCooltrainerM1BattleText:
	text_far _ViridianGymCooltrainerM1BattleText
	text_end

ViridianGymCooltrainerM1EndBattleText:
	text_far _ViridianGymCooltrainerM1EndBattleText
	text_end

ViridianGymCooltrainerM1AfterBattleText:
	text_far _ViridianGymCooltrainerM1AfterBattleText
	text_end

ViridianGymHiker1Text:
	text_asm
	ld hl, ViridianGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymHiker1BattleText:
	text_far _ViridianGymHiker1BattleText
	text_end

ViridianGymHiker1EndBattleText:
	text_far _ViridianGymHiker1EndBattleText
	text_end

ViridianGymHiker1AfterBattleText:
	text_far _ViridianGymHiker1AfterBattleText
	text_end

ViridianGymRocker1Text:
	text_asm
	ld hl, ViridianGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymRocker1BattleText:
	text_far _ViridianGymRocker1BattleText
	text_end

ViridianGymRocker1EndBattleText:
	text_far _ViridianGymRocker1EndBattleText
	text_end

ViridianGymRocker1AfterBattleText:
	text_far _ViridianGymRocker1AfterBattleText
	text_end

ViridianGymHiker2Text:
	text_asm
	ld hl, ViridianGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymHiker2BattleText:
	text_far _ViridianGymHiker2BattleText
	text_end

ViridianGymHiker2EndBattleText:
	text_far _ViridianGymHiker2EndBattleText
	text_end

ViridianGymHiker2AfterBattleText:
	text_far _ViridianGymHiker2AfterBattleText
	text_end

ViridianGymCooltrainerM2Text:
	text_asm
	ld hl, ViridianGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymCooltrainerM2BattleText:
	text_far _ViridianGymCooltrainerM2BattleText
	text_end

ViridianGymCooltrainerM2EndBattleText:
	text_far _ViridianGymCooltrainerM2EndBattleText
	text_end

ViridianGymCooltrainerM2AfterBattleText:
	text_far _ViridianGymCooltrainerM2AfterBattleText
	text_end

ViridianGymHiker3Text:
	text_asm
	ld hl, ViridianGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymHiker3BattleText:
	text_far _ViridianGymHiker3BattleText
	text_end

ViridianGymHiker3EndBattleText:
	text_far _ViridianGymHiker3EndBattleText
	text_end

ViridianGymHiker3AfterBattleText:
	text_far _ViridianGymHiker3AfterBattleText
	text_end

ViridianGymRocker2Text:
	text_asm
	ld hl, ViridianGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymRocker2BattleText:
	text_far _ViridianGymRocker2BattleText
	text_end

ViridianGymRocker2EndBattleText:
	text_far _ViridianGymRocker2EndBattleText
	text_end

ViridianGymRocker2AfterBattleText:
	text_far _ViridianGymRocker2AfterBattleText
	text_end

ViridianGymCooltrainerM3Text:
	text_asm
	ld hl, ViridianGymTrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

ViridianGymCooltrainerM3BattleText:
	text_far _ViridianGymCooltrainerM3BattleText
	text_end

ViridianGymCooltrainerM3EndBattleText:
	text_far _ViridianGymCooltrainerM3EndBattleText
	text_end

ViridianGymCooltrainerM3AfterBattleText:
	text_far _ViridianGymCooltrainerM3AfterBattleText
	text_end

ViridianGymGymGuideText:
	text_asm
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .afterBeat
	ld hl, ViridianGymGuidePreBattleText
	call PrintText
	jr .done
.afterBeat
	ld hl, ViridianGymGuidePostBattleText
	call PrintText
.done
	jp TextScriptEnd

ViridianGymGuidePreBattleText:
	text_far _ViridianGymGuidePreBattleText
	text_end

ViridianGymGuidePostBattleText:
	text_far _ViridianGymGuidePostBattleText
	text_end
