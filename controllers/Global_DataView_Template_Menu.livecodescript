script "Global | DataView | Template | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | DataView | Template | Menu
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
   put tObject into LocalArray ["tObject"]
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   --
   if exists (displayView) then
      put the displayed_Object of tObject into dView
      put the dvControl of dView into dView
   else
      put the dvControl of tObject into dView
   end if
   put dView into LocalArray ["dView"]
   --
   _LoadRowStyleNames dView
end menu_Init

getprop menu_Target [tObject]
   return LocalArray ["dView"]
end menu_Target

private command _LoadRowStyleNames dView
   if exists (dView) is true then
      put the dv_RowStyleNames of dView into rowStyleNames
      sort rowStyleNames
   else
      put empty into rowStyleNames
   end if
   put rowStyleNames into LocalArray ["rowStyleNames"]
end _LoadRowStyleNames

getprop disabled_ShowRowStack [dView]
   put the dv_LinkedRowStack of dView into stackName
   if exists (stack stackName) then
      return false
   else
      return true
   end if
end disabled_ShowRowStack

getprop showRowTemplate_Params [dView]
   return LocalArray ["rowStyleNames"]
end showRowTemplate_Params

getprop relinkRowTemplate_Params [dView]
   return LocalArray ["rowStyleNames"]
end relinkRowTemplate_Params

getprop rowTemplateBehavior_Params [dView]
   return LocalArray ["rowStyleNames"]
end rowTemplateBehavior_Params

getprop setRowStack_Param [dView]
   put the dv_LinkedRowStack of dView into stackName
   return stackName
end setRowStack_Param

getprop setRowStack_Params [dView]
   put the dv_LinkedRowStack of dView into stackNames
   if stackNames is empty then return "Open stack..."
   
   put CR & "-,Open stack..." after stackNames
   return stackNames
end setRowStack_Params

getprop createNewTemplate_Params
   return env_ListLocalProjects()
end createNewTemplate_Params

private function project_ConstructViewName projectName, pLastBit
   put "View | "  into guessViewName
   --
   replace "lcw_" with empty in projectName
   put text_InitialCaps (projectName) & " | " after guessViewName
   --
   if pLastBit is not empty then
      put text_InitialCaps (pLastBit) after guessName
   end if
   --
   return guessName
end project_ConstructViewName


--> Global | DataView | Template | Menu
-
on menu_DisplayRowTemplateArray dView
   put the short name of dView into sTitle
   put the dv_RowStyleArray of dView into styleArray
   --
   display_Data styleArray, sTitle, "Row Style Array"
end menu_DisplayRowTemplateArray

on _
end _

on menu_ShowRowTemplate dView, rowStyleName
   put the dv_RowTemplate [rowStyleName] of dView into templateObject
   if exists (templateObject) is false then breakpoint
   
   object_GoTo templateObject, pMakeVisible
end menu_ShowRowTemplate

on menu_RowTemplateBehavior dView, rowStyleName
   put the dv_RowTemplate [rowStyleName] of dView into templateObject
   if exists (templateObject) is false then breakpoint
   
   put the behavior of templateObject into bObject
   if exists (bObject) is false then breakpoint
   
   edit the script of bObject
end menu_RowTemplateBehavior

on menu_RelinkRowTemplate dView, rowStyleName
   put "View|Wiki|"  & text_InitialCaps(rowStyleName) into defaultName -- "View|Wiki|Markdown"
   put lcw_Ask("Link a view or module to replace the row template:", defaultName) into viewName
   -- put module_GetTemplateObject (viewName) into templateObject
   put view_GetTemplateObject (viewName) into templateObject
   --
   set the dv_RowTemplate [rowStyleName] of dView to templateObject
   --
   menu_DisplayRowStyleArray dView
   menu_RefreshDataView dView
end menu_RelinkRowTemplate

on _
end _

getprop createNewStyle_Params
   -- quick hack
   put the openStacks into stackNames
   filter stackNames with "View|*"
   return stackNames
end createNewStyle_Params
   
on menu_CreateNewStyle dView, moduleName
   set the itemdelimiter to "|"
   put item -1 of moduleName into guessNamme
   --
   put lcw_Ask ("What style would you like to associate the template with?", "clause", dView) into styleName
   --
   set the dv_RowTemplateName [styleName] of dView to moduleName
end menu_CreateNewStyle

on menu_CreateNewTemplate dView, projectName
   put lcw_Ask ("What style would you like to associate the template with?", "clause", dView) into styleName
   --
   put project_ConstructViewName (projectName, styleName) into guessName
   --
   put lcw_Ask ("Great - now what name do you want for the new linked module?", guessName, dView) into moduleName
   --
   dv_CreateModule moduleName, dView, projectName
   put the result into resultArray
   -- 
   put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
   put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
   --
   -- set the dv_RowTemplate [styleName] of dView to templateObject -- can;t do that until the module is created
   set the stackFile_Name of dView to moduleName
end menu_CreateNewTemplate

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

on _
end _

on menu_ShowRowStack dView
   put the dv_LinkedRowStack of dView into stackName
   go to stack stackName
end menu_ShowRowStack

on menu_SetRowStack dView, stackName
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
end menu_SetRowStack

on _
end _

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
