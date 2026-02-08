import maya.api.OpenMaya as om
import maya.cmds as cmds

SOCKET_NAME = "vscode_to_maya"
if not cmds.commandPort(SOCKET_NAME, query=True):
    cmds.commandPort(name=SOCKET_NAME, sourceType="python")
