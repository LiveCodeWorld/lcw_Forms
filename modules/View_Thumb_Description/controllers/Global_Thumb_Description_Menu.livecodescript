script "Global | Thumb | Description | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: View|Thumb|Description
type: controller
version: 0.1


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_IsSimple
   return true
end menu_IsSimple


--> Global | Thumb | Description | Menu
-
on menu_Behavior displayView
   put the behavior of displayView into bObject
   edit the script of bObject
end menu_Behavior

private on _
end _

on menu_MenuEdit displayView
   menu_Edit "Global | Thumb | Description | Menu"
end menu_MenuEdit

on submenu_Dev
   return menu_DevTitle ("Global | Thumb | Description | Menu")
end submenu_Dev
