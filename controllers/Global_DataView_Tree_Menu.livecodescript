script "Global | DataView | Tree | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | DataView | Tree | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
  pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   return the displayed_Object of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget


--> Global | DataView | Tree | Menu
-
on menu_DisplayContract dView
   set the dv_Wikidomain of dView to "lexon.wiki"
end menu_DisplayContract

on _
end _

on submenu_Behaviors
   return "Global | DataView | Behaviors | Menu"
end submenu_Behaviors

on submenu_Templates
   return "Global | DataView | Template | Menu"
end submenu_Templates

on submenu_Geometry
   return "Global | View | Geometry | Menu"
end submenu_Geometry

on _
end _

on menu_Refresh dView
   display_DataView dView, "click"
end menu_Refresh

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Empty dView
   set the dvData of dView to empty
end menu_Empty

on menu_DisplayDataViewData dView
   put the dvData of dView into tArray
   put "DataView"  && kwote (the short name of dView) into sTitle
   --
   display_Data tArray, "dvData", sTitle
end menu_DisplayDataViewData
