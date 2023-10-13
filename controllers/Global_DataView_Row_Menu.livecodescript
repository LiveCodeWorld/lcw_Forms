script "Global | DataView | Row | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | DataView | Row | Menu
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
   put the dvRowControl of tObject into rowView
   return rowView
end menu_Target

getprop checked_ShowIcon [rowView]
   put the icon_isVisible of rowView into isShowing
   return isShowing
end checked_ShowIcon


--> Global | DataView | Row | Menu
-
on menu_ShowIcon rowView
   put the icon_isVisible of rowView into isShowing
   set the icon_isVisible of rowView to (isShowing is false)
end menu_ShowIcon

private on _
end _

on submenu_Dev
   return menu_DevTitle("Global | DataView | Row | Menu")
end submenu_Dev
