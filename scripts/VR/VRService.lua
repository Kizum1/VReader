local VRService = game:GetService("VRService")
local CameraHandler = game.Workspace.CurrentCamera
local HeadScale = 1
CameraHandler.HeadScale = HeadScale
local module = {}

function getHeadCFrame()
	return VRService:GetUserCFrame(Enum.UserCFrame.Head)
end

function getCenterCFrame()
	return getHeadCFrame():ToObjectSpace(CameraHandler:GetRenderCFrame())
end

function getLeftCFrame()
	return getCenterCFrame() * VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
end
function getRightCFrame()
	local cfRH = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
	return ((CameraHandler.CFrame*CFrame.new(cfRH.p * HeadScale)) * CFrame.fromEulerAnglesXYZ(cfRH:ToEulerAnglesXYZ())) * CFrame.Angles(math.rad(30), math.rad(275), math.rad(0)) 
end

module.Rig = {
	CFrames = {
		Head = getHeadCFrame,
		Center = getCenterCFrame,
		Hand = {
			Left = getLeftCFrame,
			Right = getRightCFrame
		}
	}
}

return module
