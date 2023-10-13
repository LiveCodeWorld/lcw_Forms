script "Global | DataView | Template | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | DataView | Template | Dev | Menu
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

getprop disabled_ShowRowStack [dView]
   put the stack_Name of dView into stackName
   if exists (stack stackName) then
      return false
   else
      return true
   end if
end disabled_ShowRowStack

getprop setLinkedRowStack_Param [dView]
   put the stack_Name of dView into stackName
   return stackName
end setLinkedRowStack_Param

getprop setLinkedRowStack_Params [dView]
   put the stack_Name of dView into stackNames
   if stackNames is empty then return "Open stack..."
   
   put CR & "-,Open stack..." after stackNames
   return stackNames
end setLinkedRowStack_Params


--> Global | DataView | Template | Dev | Menu
-
on menu_DisplayRowStyleArray dView
   display_DvRowStyleArray dView
end menu_DisplayRowStyleArray

on menu_AddRowTemplateStackfiles dView
   put the dv_RowStyleArray of dView into styleArray
   repeat for each key styleName in styleArray
      set the cursor to busy
      put styleArray [styleName] into rowView
      if exists (rowView) is false then
         put rowView into badStyleArray [styleName]
         next repeat
      end if
      --
      put the stack_Name of rowView into stackName
      set the stackFile_Link of dView to stackName
   end repeat
   --
   if badStyleArray is an array then
      display_Data badStyleArray, "Can'f Find", "Bad Style Data"
   else
      lcw_AnswerWarning "Added all rows to stackfiles!"
   end if
end menu_AddRowTemplateStackfiles

on menu_ExportMenusAndStackFiles dView
   put the module_Folder of dView into moduleFolder
   --
   project_ExportMenusAndStackFiles moduleFolder
   put the result into projectArray
   --
   put the view_Name of dView into moduleName
   display_Data projectArray, moduleName, "Module Array"  
end menu_ExportMenusAndStackFiles

private command _
end _

on menu_ShowLinkedRowStack dView
   breakpoint
   put the dv_LinkedRowStack of dView into stackName
   if exists (stack stackName) is false then
      put stackName
      lcw_Answer "Cannot locate stack '[[stackName]]'!", dView, stackName
   else
      go to stack stackName
   end if
end menu_ShowLinkedRowStack

on menu_SetLinkedRowStack dView, stackName
   breakpoint
   if stackName = "Open stack..." then
      answer file "Choose a stack..." with type "LiveCode Stacks|rev|RSTK"
      put it into stackPath
      if stackPath is empty then exit to top
      --
      set the dv_LinkedRowStack of dView to stackPath
   else
      set the dv_LinkedRowStack of dView to stackName
      set the stackFile_Link of dView to stackName
   end if
end menu_SetLinkedRowStack

private command _
end _

-- on menu_AddRowToStyleArray dView, stackName
   put the dvRowControl of control 1 of stack stackName into rowViewToImport
   --
   put the dv_RowStyleArray of dView into styleArray
   union styleArray with importStyleArray
   set the dv_RowStyleArray of dView to styleArray
   --
   display_Data styleArray, the short name of dView, "Row Style Array"
end menu_AddRowToStyleArray
