script "Global | Code | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Code | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- put display_MenuTarget (tObject) into dView
   put the display_View of tObject into dView
   return dView
end menu_Target

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget

getprop checked_DontWrap [dView]
   put the dont_Wrap of dView is true into sBoolean
   return sBoolean
end checked_DontWrap


--> Global | Code | Line | Menu
-
on menu_Do dView
   dispatch "do_Script" to dView
end menu_Do

on menu_CodeLine dView
   put the script_Text of dView
end menu_CodeLine

private on _
end _

on menu_DontWrap dView
   put the dont_Wrap of dView is true into sBoolean
   set the dont_Wrap of dView to (sBoolean is false)
end menu_DontWrap

on menu_LayoutControl dView
   dispatch "LayoutControl" to dView
end menu_LayoutControl

on menu_Behavior dView
   put the behavior of dView into bObject
   edit the script of bObject
end menu_Behavior

on menu_ModuleTools dView
   put the view_Name of dView into viewName
   display_ModuleTools viewName
end menu_ModuleTools

private on __
end __

on submenu_Dev
   return menu_DevTitle ("Global | Code | Line | Menu")
end submenu_Dev
