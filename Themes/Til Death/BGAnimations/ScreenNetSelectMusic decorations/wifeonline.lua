local profile = PROFILEMAN:GetProfile(PLAYER_1)
local frameX = 10
local frameY = 250+capWideScale(get43size(120),90)
local frameWidth = capWideScale(get43size(455),455)
local scoreType = themeConfig:get_data().global.DefaultScoreType
local score
local song
local steps
local alreadybroadcasted
local alreadybroadcasted

local update = false
local t = Def.ActorFrame{
	BeginCommand=function(self)
		steps = nil
		song = nil
		score = nil
		self:finishtweening()
		if getTabIndex() == 0 then
			self:queuecommand("On")
			update = true
		else 
			self:queuecommand("Off")
			update = false
		end
	end,
	OffCommand=cmd(bouncebegin,0.2;xy,-500,0;diffusealpha,0),
	OnCommand=cmd(bouncebegin,0.2;xy,0,0;diffusealpha,1),
	SetCommand=function(self)
		self:finishtweening()
		if getTabIndex() == 0 then
			self:queuecommand("On")
			update = true
		else 
			self:queuecommand("Off")
			update = false
		end
	end,
	TabChangedMessageCommand=cmd(queuecommand,"Set"),
}


-- Temporary update control tower; it would be nice if the basic song/step change commands were thorough and explicit and non-redundant
t[#t+1] = Def.Actor{
	SetCommand=function(self)
		if song and not alreadybroadcasted then 		-- if this is true it means we've just exited a pack's songlist into the packlist
			song = GAMESTATE:GetCurrentSong()			-- also apprently true if we're tabbing around within a songlist and then stop...
			MESSAGEMAN:Broadcast("UpdateChart")			-- ms.ok(whee:GetSelectedSection( )) -- use this later to detect pack changes
			MESSAGEMAN:Broadcast("RefreshChartInfo")
		else
			alreadybroadcasted = false
		end
	end,
	CurrentStepsP1ChangedMessageCommand=function(self)	
		song = GAMESTATE:GetCurrentSong()			
		MESSAGEMAN:Broadcast("UpdateChart")
		alreadybroadcasted = true
	end,
	CurrentSongChangedMessageCommand=function(self)
		if playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).OneShotMirror then	-- This will disable mirror when switching songs if OneShotMirror is enabled
			local modslevel = topscreen  == "ScreenEditOptions" and "ModsLevel_Stage" or "ModsLevel_Preferred"
			local playeroptions = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions(modslevel)
			playeroptions:Mirror( false )
		end
		self:queuecommand("Set")
	end,
}

local function GetBestScoreByFilter(perc,CurRate)
	local rtTable = getRateTable(PROFILEMAN:GetProfile(PLAYER_1):GetHighScoresByKey(getCurKey()))
	local rates = tableKeys(rtTable)
	local scores, score
	
	if CurRate then
		local tmp = getCurRateString()
		if tmp == "1x" then tmp = "1.0x" end
		rates = {tmp}
		if not rtTable[rates[1]] then return nil end
	end
	
	table.sort(rates)
	for i=#rates,1,-1 do
		scores = rtTable[rates[i]]
		local bestscore = 0
		local index
		
		for ii=1,#scores do
			score = scores[ii]
			if score:ConvertDpToWife() > bestscore and getClearTypeFromScore(PLAYER_1,score,0) ~= "Invalid" then
				index = ii
				bestscore = score:ConvertDpToWife()
			end
		end
		
		if index and scores[index]:GetWifeScore() == 0 and GetPercentDP(scores[index]) > perc * 100 then
			return scores[index]
		end
		
		if bestscore > perc then
			return scores[index]
		end
	end		
end

local function GetDisplayScore()
	local score
	score = GetBestScoreByFilter(0, true)
	
	if not score then score = GetBestScoreByFilter(0.9, false) end
	if not score then score = GetBestScoreByFilter(0.5, false) end
	if not score then score = GetBestScoreByFilter(0, false) end
	return score
end

t[#t+1] = Def.Actor{
	SetCommand=function(self)		
		if song then 
			steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
			score = GetDisplayScore()
			MESSAGEMAN:Broadcast("RefreshChartInfo")
		end
	end,
	UpdateChartMessageCommand=cmd(queuecommand,"Set"),
	CurrentRateChangedMessageCommand=function()
		score = GetDisplayScore()
	end,
}

--All these 4:3 ratio and 16:9 widescreen ratio stuff goes here. -Misterkister
----------------------------------------------------------------------------------------
local wifeY = frameY-170
local wifeX = frameX+25
local wifescoretypeX = frameX+150
local wifescoretypeY = frameY+40
local secondarytypeX = frameX+130
local secondarytypeY = frameY+63
local secondaryscoretypeX = frameX+173
local secondaryscoretypeY = frameY+63
local rateX = frameX+55
local rateY = frameY+58
local datescoreX = frameX+185
local datescoreY = frameY+59
local maxcomboX = frameX+185
local maxcomboY = frameY+49
local difficultyX = frameX+58
local difficultyY = frameY
local negativebpmX = frameX+10
local negativebpmY = frameY-120
local infoboxx = 310
local infoboxy = 200
local infoboxbar = 3
local infoboxwidth = 65
local infoboxheight = 200
local lengthx = capWideScale(get43size(374),420)+60
local lengthy = capWideScale(get43size(360),275)
local cdtitlemaxwidth = 75
local cdtitlemaxheight = 30
local curateX = 18
local curateY = SCREEN_BOTTOM-225
--local radarX = frameX+13

--16:9 ratio.
if IsUsingWideScreen() == true then

	wifeY = frameY-290
	wifeX = frameX+25
	wifescoretypeX = frameX+95
	wifescoretypeY = frameY-290
	secondarytypeX = frameX+180
	secondarytypeY = frameY-290
	secondaryscoretypeX = frameX+245
	secondaryscoretypeY = frameY-290
	rateX = frameX+125
	rateY = frameY-295
	datescoreX = frameX+170
	datescoreY = frameY-150
	maxcomboY = frameY-150
	maxcomboX = frameX+300
	difficultyY = frameY-115
	difficultyX = frameX+440
	negativebpmY = frameY-150
	--radarX = frameX+400

	infoboxx = capWideScale(get43size(374),405)
	infoboxy = capWideScale(get43size(360),215)
	infoboxbar = 8
	infoboxwidth = 95
	infoboxheight = 195
	lengthx = capWideScale(get43size(374),375)
	lengthy = capWideScale(get43size(360),170)
	cdtitlemaxwidth = 75
	cdtitlemaxheight = 30
	curateX = 425
	curateY = SCREEN_CENTER_Y-35
end

--4:3 ratio.
if not IsUsingWideScreen() == true then

	wifeY = frameY-170
	wifeX = frameX+25
	wifescoretypeX = frameX+95
	wifescoretypeY = frameY-170
	secondarytypeX = frameX+25
	secondarytypeY = frameY-150
	secondaryscoretypeX = frameX+95
	secondaryscoretypeY = frameY-150
	rateX = frameX+145
	rateY = frameY-175
	datescoreX = frameX+130
	datescoreY = frameY-150
	maxcomboY = frameY-175
	maxcomboX = frameX+210
	difficultyY = frameY-95
	difficultyX = frameX+330
	negativebpmY = frameY-290
	--radarX = frameX+400

	infoboxx = 310
	infoboxy = 220
	infoboxbar = 3
	infoboxwidth = 65
	infoboxheight = 175
	lengthx = 290
	lengthy = 142
	cdtitlemaxwidth = 50
	cdtitlemaxheight = 60
	curateX = SCREEN_CENTER_X-20
	curateY = SCREEN_CENTER_Y-72
end

t[#t+1] = Def.Quad{
	InitCommand=cmd(xy,infoboxx,infoboxy;zoomto,infoboxwidth,infoboxheight;halign,0;valign,0;diffuse,color("#333333CC");diffusealpha,0.66)
}
t[#t+1] = Def.Quad{
	InitCommand=cmd(xy,infoboxx,infoboxy;zoomto,infoboxbar,infoboxheight;halign,0;valign,0;diffuse,getMainColor('highlight');diffusealpha,0.5)
}	
-- -- Music Rate Display
-- t[#t+1] = LoadFont("Common Large") .. {
	-- InitCommand=cmd(xy,curateX,curateY;visible,true;halign,0;zoom,0.3;maxwidth,capWideScale(get43size(360),360)/capWideScale(get43size(0.45),0.45)),
	-- BeginCommand=function(self)
		-- self:settext(getCurRateDisplayString())
	-- end,
	-- CodeMessageCommand=function(self,params)
		-- local rate = getCurRateValue()
		-- ChangeMusicRate(rate,params)
		-- self:settext(getCurRateDisplayString())
	-- end,
-- }

t[#t+1] = Def.ActorFrame{
	-- -- **frames/bars**
	-- Def.Quad{InitCommand=cmd(xy,frameX,frameY-76;zoomto,110,94;halign,0;valign,0;diffuse,color("#333333CC");diffusealpha,0.66)},			--Upper Bar
	-- Def.Quad{InitCommand=cmd(xy,frameX,frameY+18;zoomto,frameWidth+4,50;halign,0;valign,0;diffuse,color("#333333CC");diffusealpha,0.66)},	--Lower Bar
	-- Def.Quad{InitCommand=cmd(xy,frameX,frameY-76;zoomto,8,144;halign,0;valign,0;diffuse,getMainColor('highlight');diffusealpha,0.5)},		--Side Bar (purple streak on the left)
	
	-- **score related stuff** These need to be updated with rate changed commands
	-- Primary percent score
	LoadFont("Common Large")..{
		InitCommand=cmd(xy,wifeX,wifeY;zoom,0.3;halign,0.5;maxwidth,175;valign,1),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
				if score:GetWifeScore() == 0 then 
					self:settextf("%05.2f%%", notShit.floor(GetPercentDP(score)*100)/100)
					self:diffuse(getGradeColor(score:GetGrade()))
				else
					self:settextf("%05.2f%%", notShit.floor(score:GetWifeScore()*10000)/100)
					self:diffuse(getGradeColor(score:GetWifeGrade()))
				end
			else
				self:settext("")
			end
		end,
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Primary ScoreType
	LoadFont("Common Large")..{
		InitCommand=cmd(xy,wifescoretypeX,wifescoretypeY;zoom,0.3;halign,1;valign,1),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
				if score:GetWifeScore() == 0 then 
					self:settext("DP*")
				else
					self:settext(scoringToText(scoreType))
				end
			else
				self:settext("")
			end
		end,
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Secondary percent score
	LoadFont("Common Normal")..{
		InitCommand=cmd(xy,secondarytypeX,secondarytypeY;zoom,0.6;halign,0.5;maxwidth,125;valign,1),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
				if score:GetWifeScore() == 0 then 
					self:settextf("NA")
					self:diffuse(getGradeColor("Grade_Failed"))
				else
					self:settextf("%05.2f%%", GetPercentDP(score))
					self:diffuse(getGradeColor(score:GetGrade()))
				end
			else
				self:settext("")
			end
		end,
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Secondary ScoreType
	LoadFont("Common Normal")..{
		InitCommand=cmd(xy,secondaryscoretypeX,secondaryscoretypeY;zoom,0.4;halign,1;valign,1),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
				if score:GetWifeScore() == 0 then 
					self:settext("Wife")
				else
					self:settext("DP")
				end
			else
				self:settext("")
			end
		end,
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Rate for the displayed score
	LoadFont("Common Normal")..{
		InitCommand=cmd(xy,rateX,rateY;zoom,0.5;halign,0.5),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then 
			local rate = getRate(score)
				if getCurRateString() ~= rate then
					self:settext("("..rate..")")
				else
					self:settext(rate)
				end
			else
				self:settext("")
			end
		end,
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Date score achieved on
	LoadFont("Common Normal")..{
		InitCommand=cmd(xy,datescoreX,datescoreY;zoom,0.4;halign,0),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
					self:settext(score:GetDate())
				else
					self:settext("")
				end
		end,
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	},

	-- MaxCombo
	LoadFont("Common Normal")..{
		InitCommand=cmd(xy,maxcomboX,maxcomboY;zoom,0.4;halign,0),
		BeginCommand=cmd(queuecommand,"Set"),
		SetCommand=function(self)
			if song and score then
				self:settextf("Max Combo: %d", score:GetMaxCombo())
			else
				self:settext("")
			end
		end,
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
		RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	},
	-- **End score related stuff**
}

-- -- "Radar values" aka basic chart information
-- local function radarPairs(i)
	-- local o = Def.ActorFrame{
		-- LoadFont("Common Normal")..{
			-- InitCommand=cmd(xy,radarX,frameY-52+13*i;zoom,0.5;halign,0;maxwidth,120),
			-- SetCommand=function(self)
				-- if song then
					-- self:settext(ms.RelevantRadarsShort[i])
				-- else
					-- self:settext("")
				-- end
			-- end,
			-- RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
		-- },
		-- LoadFont("Common Normal")..{
			-- InitCommand=cmd(xy,radarXX,frameY+-52+13*i;zoom,0.5;halign,1;maxwidth,60),
			-- SetCommand=function(self)
				-- if song then		
					-- self:settext(GAMESTATE:GetCurrentSteps(PLAYER_1):GetRelevantRadars(PLAYER_1)[i])
				-- else
					-- self:settext("")
				-- end
			-- end,
			-- RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
		-- },
	-- }
	-- return o
-- end

-- -- Create the radar values
-- for i=1,5 do
	-- t[#t+1] = radarPairs(i)
-- end

-- Difficulty value ("meter"), need to change this later
t[#t+1] = LoadFont("Common Large") .. {
	InitCommand=cmd(xy,difficultyX,difficultyY;halign,0.5;zoom,0.4;maxwidth,110/0.6),
	BeginCommand=cmd(queuecommand,"Set"),
	SetCommand=function(self)
		if song then
			local meter = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMSD(getCurRateValue(), 1)
			--If meter is showing 0 because it's a solo or a double chart, then don't show the numbers. -Misterkister
			if meter == 0 then
				self:settext("")
			else
				self:settextf("%05.2f",meter)
				self:diffuse(ByMSD(meter))
			end
		else
			self:settext("")
		end
		if song and steps:GetTimingData():HasWarps() then
			self:settext("")
		end
	end,
	RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
	CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
}

t[#t+1] = Def.Sprite {
	InitCommand=cmd(xy,capWideScale(get43size(374),394)+60,capWideScale(get43size(290),270);halign,0.5;valign,1),
	SetCommand=function(self)
		self:finishtweening()
		if GAMESTATE:GetCurrentSong() then
			local song = GAMESTATE:GetCurrentSong()	
			if song then
				if song:HasCDTitle() then
					self:visible(true)
					self:Load(song:GetCDTitlePath())
				else
					self:visible(false)
				end
			else
				self:visible(false)
			end
			local height = self:GetHeight()
			local width = self:GetWidth()
			
			if height >= cdtitlemaxheight and width >= cdtitlemaxwidth then
				if height*(cdtitlemaxwidth/cdtitlemaxheight) >= width then
				self:zoom(cdtitlemaxheight/height)
				else
				self:zoom(cdtitlemaxwidth/width)
				end
			elseif height >= cdtitlemaxheight then
				self:zoom(cdtitlemaxheight/height)
			elseif width >= cdtitlemaxwidth then
				self:zoom(cdtitlemaxwidth/width)
			else
				self:zoom(1)
			end
		else
		self:visible(false)
		end
	end,
	BeginCommand=cmd(queuecommand,"Set"),
	RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
}

t[#t+1] = LoadFont("Common Large") .. {
	InitCommand=cmd(xy,negativebpmX,negativebpmY;halign,0;zoom,0.25);
	BeginCommand=cmd(queuecommand,"Set");
	SetCommand=function(self)
		if song and steps:GetTimingData():HasWarps() then
			self:settext("Negative BPMs Detected")
			self:diffuse(color("#e61e25"))
		else
			self:settext("")
		end
	end,
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set"),
	RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
}

-- t[#t+1] = LoadFont("Common Large") .. {
	-- InitCommand=cmd(xy,(capWideScale(get43size(384),384))+68,SCREEN_BOTTOM-135;halign,1;zoom,0.4,maxwidth,125),
	-- BeginCommand=cmd(queuecommand,"Set"),
	-- SetCommand=function(self)
		-- if song then
			-- self:settext(song:GetOrTryAtLeastToGetSimfileAuthor())
		-- else
			-- self:settext("")
		-- end
	-- end,
	-- CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set"),
	-- RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
-- }

-- active filters display
-- t[#t+1] = Def.Quad{InitCommand=cmd(xy,16,capWideScale(SCREEN_TOP+172,SCREEN_TOP+194);zoomto,SCREEN_WIDTH*1.35*0.4 + 8,24;halign,0;valign,0.5;diffuse,color("#000000");diffusealpha,0),
	-- EndingSearchMessageCommand=function(self)
		-- self:diffusealpha(1)
	-- end
-- }
-- t[#t+1] = LoadFont("Common Large") .. {
	-- InitCommand=cmd(xy,20,capWideScale(SCREEN_TOP+170,SCREEN_TOP+194);halign,0;zoom,0.4;settext,"Active Filters: "..GetPersistentSearch();maxwidth,SCREEN_WIDTH*1.35),
	-- EndingSearchMessageCommand=function(self, msg)
		-- self:settext("Active Filters: "..msg.ActiveFilter)
	-- end
-- }

--test actor
t[#t+1] = LoadFont("Common Large") .. {
	InitCommand=cmd(xy,frameX,frameY-120;halign,0;zoom,0.4,maxwidth,125),
	BeginCommand=cmd(queuecommand,"Set"),
	SetCommand=function(self)
		self:settext("")
	end,
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set"),
	RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
}


-- Song duration
t[#t+1] = LoadFont("Common Large") .. {
	InitCommand=cmd(xy,lengthx,lengthy;visible,true;halign,1;zoom,capWideScale(get43size(0.4),0.4);maxwidth,capWideScale(get43size(360),360)/capWideScale(get43size(0.45),0.45)),
	BeginCommand=cmd(queuecommand,"Set"),
	SetCommand=function(self)
		if song then
			local playabletime = GetPlayableTime()
			self:settext(SecondsToMMSS(playabletime))
			self:diffuse(ByMusicLength(playabletime))
		else
			self:settext("")
		end
	end,
	CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
	RefreshChartInfoMessageCommand=cmd(queuecommand,"Set"),
}
return t
