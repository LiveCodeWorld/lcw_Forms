script "Global | Form | Simple | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Form | Simple | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop checked_FormIsRed [viewObject]
   put the form_IsRed of viewObject into isRed
   return isRed
end checked_FormIsRed


--> Global | Form | Simple | Dev | Menu
-
on menu_TestPlaceholders formView
   repeat 5
      put "Layout|Placeholder" & CR after vNames
   end repeat
   delete char -1 of vNames
   --
   set the form_InsertView of formView to vNames
end menu_TestPlaceholders

on menu_TestForm formView
   put "Layout|Placeholder" & CR after vNames
   put "View|Record|File" & CR after vNames
   put "View|Record|CharField|Basic" & CR after vNames
   put "Layout|Placeholder" & CR after vNames
   put "Layout|Placeholder" & CR after vNames
   delete char -1 of vNames
   --
   set the form_InsertView of formView to vNames
end menu_TestForm

private on _
end _

on menu_FormIsRed viewObject
   -- put menu_GetChecked (the params)
   put the form_IsRed of viewObject is false into notRed
   --
   set the form_IsRed of viewObject to notRed
end menu_FormIsRed

on menu_Behavior displayView
   put the behavior of displayView into bObject
   edit the script of bObject
end menu_Behavior

private on _
end _

on menu_MenuEdit displayView
   menu_Edit "Global | Form | Simple | Dev | Menu"
end menu_MenuEdit
