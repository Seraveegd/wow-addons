--[[
	frame.lua
		A specialized version of the bagnon frame for guild banks
--]]

local Bagnon = LibStub('AceAddon-3.0'):GetAddon('Bagnon')
local Frame = Bagnon:NewClass('GuildFrame', 'Frame', Bagnon.Frame)


--[[ Events ]]--

function Frame:OnShow()
	PlaySound('GuildVaultOpen')

	self:UpdateEvents()
	self:RegisterMessage('SHOW_LOG_FRAME')
	self:RegisterMessage('SHOW_EDIT_FRAME')
	self:RegisterMessage('SHOW_ITEM_FRAME')
	self:UpdateLook()
end

function Frame:OnHide()
	StaticPopup_Hide('GUILDBANK_WITHDRAW')
	StaticPopup_Hide('GUILDBANK_DEPOSIT')
	StaticPopup_Hide('CONFIRM_BUY_GUILDBANK_TAB')
	CloseGuildBankFrame()
	PlaySound('GuildVaultClose')

	self:UpdateEvents()
	self:SendMessage('GUILD_BANK_CLOSED')

	--fix issue where a frame is hidden, but not via bagnon controlled methods (ie, close on escape)
	if self:IsFrameShown() then
		self:HideFrame()
	end
end


--[[ Messages ]]--

function Frame:SHOW_LOG_FRAME()
	self:FadeFrames()
	self:FadeInFrame(self:GetLogFrame())
end

function Frame:SHOW_EDIT_FRAME()
	self:FadeFrames()
	self:FadeInFrame(self:GetEditFrame())
end

function Frame:SHOW_ITEM_FRAME()
	self:FadeFrames()
	self:FadeInFrame(self:GetItemFrame())
end

function Frame:FadeFrames()
	self:FadeOutFrame(self.itemFrame)
	self:FadeOutFrame(self.editFrame)
	self:FadeOutFrame(self.logFrame)
end


--[[ Create ]]--

function Frame:CreateItemFrame()
	local f = Bagnon.GuildItemFrame:New(self:GetFrameID(), self)
	self.itemFrame = f
	return f
end

function Frame:CreateBagFrame()
	local f = Bagnon.GuildTabFrame:New(self:GetFrameID(), self)
	self.bagFrame = f
	return f
end

function Frame:CreateMoneyFrame()
	local f = Bagnon.GuildMoneyFrame:New(self:GetFrameID(), self)
	self.moneyFrame = f
	return f
end

function Frame:CreateLogToggles ()
	local t = {}
	for i = 1, Bagnon.LogToggle.numTypes do
		t[i] = Bagnon.LogToggle:New(self, i)
	end
	
	self.logToggles = t
	return t
end

function Frame:CreateLogFrame()
	local item = self:GetItemFrame()
	local log = Bagnon.LogFrame:New(self:GetFrameID(), self)
	log:SetPoint('BOTTOMRIGHT', item, -27, 5)
	log:SetPoint('TOPLEFT', item, 5, -5)
	
	self.logFrame = log
	return log
end

function Frame:CreateEditFrame()
	local item = self:GetItemFrame()
	local edit = Bagnon.EditFrame:New(self:GetFrameID(), self)
	edit:SetPoint('BOTTOMRIGHT', item, -27, 5)
	edit:SetPoint('TOPLEFT', item, 5, -5)
	
	self.editFrame = edit
	return edit
end


--[[ Get ]]--

function Frame:GetLogFrame()
	return self.logFrame or self:CreateLogFrame()
end

function Frame:GetEditFrame()
	return self.editFrame or self:CreateEditFrame()
end

function Frame:GetLogToggles()
	return self.logToggles or self:CreateLogToggles()
end


--[[ Proprieties ]]--

function Frame:HasLogs()
	return true
end

function Frame:HasBagFrame()
	return true
end

function Frame:IsBagFrameShown()
	return true
end

function Frame:HasBagToggle()
	return false
end

function Frame:HasPlayerSelector()
	return false
end