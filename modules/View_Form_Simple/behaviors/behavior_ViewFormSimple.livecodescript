script "behavior_ViewFormSimple"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewFormSimple
type: behavior
version: 0.1

/*
A basic form element.
*/

getprop form_View
   put the long id of me into layoutView
   if not(the long id of target contains layoutView) then exit to top
   
   return layoutView
end form_View

getprop form_Model
   return the long id of me
end form_Model

getprop view_Object
   return the long id of me
end view_Object


--> Menu | Props
-
/*
This can be overidden with a menu_Target handler on the  menu_GetTopController() script (ie the card).
Check the "menu_TargetFromGlobal" handler of stack libOPN_Menus
*/

getprop menu_Target
   put menu_GetTargetObject() into mTarget
   return mTarget
end menu_Target


--> Events
-
-- on dragdrop
   /*
   Would need a background graphic.
   */
   put the dragdata ["private"] into viewName
   put the dragDestination into targetObject
   beep
end dragdrop


--> Record | Defaults
-
setprop form_InsertView [isHidden] viewNames
   lock screen
   put the form_View of the target into formView
   put the rect of formView into oRect
   put empty into copiedObjects
   replace CR with comma in viewNames
   repeat for each item viewName in viewNames
      form_AddView viewName
      put the result into copiedObject
      if copiedObject is empty then next repeat
      --
      if isHidden is true then set the visible of copiedObject to false
      put copiedObject & CR after copiedObjects
   end repeat
   delete last char of copiedObjects
   -- set the view_Rect of formView to oRect
   LayoutControl
   unlock screen
   return copiedObjects
end form_InsertView

command form_AddView vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then return empty
   --
   if libraryGroup is empty or libraryGroup is the long id of me then return empty
   copy templateObject to me
   put it into copiedObject
   --
   return copiedObject
end form_AddView


--> Record | Defaults
-
getprop record_Type
   set the itemdelimiter to "|"
   put the view_Name of the target into recordType
   delete item 1 of recordType
   return recordType
end record_Type

getprop record_Name
   return the short name of the target
end record_Name


--> Form | Data | Array
-
getprop form_Array
   repeat for each line recordView in the form_Records of me
      put the record_Label of recordView into someLabel
      put the record_Value of recordView into someValue
      put the record_Type of recordView into recordType
      
      put someValue into formArray [someLabel]
      if recordType is not empty then put recordType into formArray [someLabel]["@attributes"]["recordType"]
   end repeat
   return formArray
end form_Array

setprop form_Array formArray
   form_SetRecordObjects empty
   
   repeat for each key someKey in formArray
      put formArray [someKey] into recordValue
      switch
         case someValue is an array
            break
         case someValue is a number
            break
         case someValue is a date
            break
         case the number of lines of someValue = 1
            put "Record|CharField|Basic" into vName
            break
         case the number of words of someValue = 1
            put "Record|TextField" into vName
            break
      end switch
      form_AddView vName
      put the result into createdRecord
      
      set the record_Label of createdRecord to someKey
      set the record_Value of createdRecord to recordValue
      
   end repeat
end form_Array


--> Form | Data
-
getprop form_PostData
   local postData
   
   repeat with groupNum = 1 to the number of groups of me
      put the long id of group groupNum of me into someGroup
      
      put the record_Label of someGroup into recordName
      put the record_Value of someGroup into recordValue
      if recordValue is not empty then 
         form_AddToPostData recordName, recordValue, postData
      end if
   end repeat
   return postData
end form_PostData

getprop form_Table
   set the itemdelimiter to tab
   repeat for each line recordView in the form_Records of me
      put the record_Label of recordView into someLabel
      put the record_Value of recordView into someValue
      put the record_Type of recordView into recordType
      
      put someLabel into item 1 of someRecord
      put someValue into item 2 of someRecord
      put recordType into item 3 of someRecord
      put someRecord & CR after formTable
   end repeat
   delete char -1 of formTable
   return formTable
end form_Table

setprop form_Table displayTable
   put the long id of me into someLayout
   set the itemdelimiter to tab
   put the number of lines of displayTable into numberOfRows
   
   -- delete if too many
   put the number of groups of someLayout into numberNow
   put numberOfRows + 1 into numberAfterLast
   --
   if numberAfterLast < 1 then put 1 into numberAfterLast
   --
   if numberNow > numberAfterLast then
      repeat with groupNum = numberNow down to numberAfterlast
         if exists(group groupNum of someLayout) then
            put the long id of group groupNum of someLayout into someView
            delete someView
         end if
      end repeat
   end if
   
   -- now add if needed
   put the number of groups of someLayout into numberNow
   put the long id of group 1 of someLayout into someView
   put numberOfRows - numberNow into numberToAdd
   repeat numberToAdd
      clone someView
      put the result into createdObject
   end repeat
   
   repeat for each line lineNum in displayTable
      put line lineNum of displayTable into someRecord
      put the long id of group lineNum of me into recordView
      
      put item 1 of someRecord into someLabel
      put item 2 of someRecord into someValue
      set the record_Label of recordView to someLabel
      set the record_Value of recordView to someValue
   end repeat
end form_Table


--> Form
-
getprop form_Label
   put the label of me into formLabel
   if formLabel is empty then return the short name of me
   return formLabel
end form_Label

setprop form_Label formLabel
   lock screen
   set the label of me to formLabel
   -- set the form_ShowName of me to true
   unlock screen
end form_Label

getprop form_IsOpaque someBoolean
   return the opaque of me
end form_IsOpaque

setprop form_IsOpaque someBoolean
   set the opaque of me to someBoolean
end form_IsOpaque

setprop form_IsRed someBoolean
   if someBoolean is true then
      lock screen
      set the form_IsOpaque of me to true
      set the form_BackgroundColour of me to "red"
      unlock screen
   else
      set the form_BackgroundColour of me to ""
   end if
end form_IsRed

getprop form_IsRed someBoolean
   return the form_BackgroundColour of me = "red"
end form_IsRed

getprop form_ShowName someBoolean
   put the long id of me into formView
   if word 1 of formView = "card" then return empty
   return the showname of formView
end form_ShowName

setprop form_ShowName someBoolean
   put the long id of me into formView
   if word 1 of formView = "card" then return empty
   set the showname of me to someBoolean
   set the form_IsSquare of me to false
end form_ShowName

setprop form_IsSquare someBoolean
   lock screen
   -- set the visible of the form_Background of me to someBoolean
   if someBoolean is true then
      set the threed of me to false
      -- set the showborder of me to false
      set the borderwidth of me to 1
   else
      -- needs to be opaque (one of these will do)
      -- set the backgroundcolor of me to empty
      set the opaque of me to false
      
      set the threed of me to true
      set the showborder of me to true
      set the borderwidth of me to 2
   end if
   unlock screen
end form_IsSquare

getprop form_IsSquare
   return the threed of me is false
end form_IsSquare

getprop record_FieldColour
   if the long id of me is not the long id of the target then pass record_FieldColour
   put the form_Records of me into formRecords
   put line 1 of formRecords into firstFormRecord
   put the record_FieldColour of firstFormRecord into someColour
   return someColour
end record_FieldColour

setprop record_FieldColour someColour
   if the long id of me is not the long id of the target then pass record_FieldColour
   lock screen
   put the form_Records of me into formRecords
   repeat for each line formRecord in formRecords
      set the record_FieldColour of formRecord to someColour
   end repeat
   unlock screen
end record_FieldColour

getprop form_BackgroundColour
   return the backgroundcolor of me
end form_BackgroundColour

setprop form_BackgroundColour someColour
   if the form_ShowName of me is true then pass form_BackgroundColour
   set the backgroundcolor of me to someColour
end form_BackgroundColour


--> Geometry
-
on resizeStack
   LayoutControl
end resizeStack

on resizeControl
   -- if the long id of me is not the long id of the target then pass resizeControl
   LayoutControl
end resizeControl

setprop view_Rect someRect
   if the long id of me is not the long id of the target then pass view_Rect
   LayoutControl someRect
end view_Rect

getprop vertical_Spacings
   local actualVerticalSpacing, horizontalShifts
   getActualSpacing actualVerticalSpacing, horizontalShifts
   return actualVerticalSpacing
end vertical_Spacings

getprop horizontal_Shifts
   local actualVerticalSpacing, horizontalShifts
   getActualSpacing actualVerticalSpacing, horizontalShifts
   return horizontalShifts
end horizontal_Shifts

private command getActualSpacing @actualVerticalSpacing, @horizontalShifts
   put the inner_Rect of me into innerRect
   put item 1 of innerRect into defaultLeft
   put the form_Records of me into formRecords
   put the number of lines of formRecords into numberOfRecords
   repeat with recordNum = 1 to (numberOfRecords  - 1)
      put line recordNum of formRecords into recordView
      put line (recordNum + 1) of formRecords into nextRecordView
      
      put the bottom of recordView into recordBottom
      put the top of nextRecordView into nextRecordTop
      put nextRecordTop - recordBottom into verticalSpacing
      put verticalSpacing into item recordNum of actualVerticalSpacing
      
      put the left of recordView into recordLeft
      put recordLeft - defaultLeft into shiftRight
      put shiftRight into item recordNum of horizontalShifts
   end repeat
   
   put the left of nextRecordView into recordLeft
   put recordLeft - defaultLeft into shiftRight
   put shiftRight into item (recordNum + 1) of horizontalShifts
end getActualSpacing

getprop inner_Rect [pRect]
   if the long id of the target is not the long id of me then pass inner_Rect
   if pRect is empty then put the rect of me into pRect
   if the view_ResizeToContents of me is true then put the view_FormattedRect [pRect] of me into pRect
   
   put the form_Margins of me into someMargin -- rather than margins
   put the box_Rect [pRect] of me into boxRect
   put rect_SubtractMargin (someMargin, boxRect) into innerRect
   -- set the rect_Mask [innerRect] of me to "yellow"
   return innerRect
end inner_Rect

on LayoutControl pRect
   -- warning:  only works if the lockloc of the group is true!
   
   put the long id of me into formView
   -- if formView is not the long id of the target then return false -- pass LayoutControl
   if pRect is empty then put the rect of me into pRect
   
   lock screen
   
   put the form_VerticalSpacing of me into formVerticalSpacing
   put the record_DefaultHeight of me into recordDefaultHeight
   
   put the form_Margins of me into someMargin
   if the view_ResizeToContents of me is true then put the view_FormattedRect [pRect] of me into pRect
   put the box_Rect [pRect] of me into boxRect
   put rect_SubtractMargin (someMargin, boxRect) into innerRect
   
   if word 1 of formView is not "card" then
      if the vscrollbar of me is true then
         put the scrollbarwidth of me into scrollBarMargin
      end if
      if the auto_Scroll of me is true then
         put the formatted_Height of me into fHeight
         put item 4 of pRect - item 2 of pRect into actualHeight
         if fHeight > actualHeight then
            set the vScrollbar of me to true
         else
            set the vScrollbar of me to false
         end if
      end if
   end if
   
   -- set the rect_Mask [pRect] of me to "yellow"
   -- set the rect_Mask [innerRect] of me to "red"
   
   put item 2 of innerRect into viewTop
   put the form_Records of me into formRecords
   put item 1 of formVerticalSpacing into lastVerticalSpacing
   repeat with recordNum = 1 to the number of lines of formRecords
      put line recordNum of formRecords into recordView
      put item recordNum of formVerticalSpacing into verticalSpacing
      if verticalSpacing is empty then put lastVerticalSpacing into verticalSpacing
      put verticalSpacing into lastVerticalSpacing
      
      if the visible of recordView is false then next repeat
      put innerRect into viewRect
      put viewTop into item 2 of viewRect
      
      put the record_Height of recordView into recordHeight
      if recordHeight is empty then put height of recordView into recordHeight
      put viewTop + recordHeight into item 4 of viewRect
      
      -- set the rect_Mask [viewRect] of recordView to "yellow"
      -- dispatch "LayoutControl" to recordView with viewRect -- need to do this twice to precalculate record_Height!
      set the rect of recordView to viewRect
      
      get the record_Height of recordView
      if it is empty then get the height of recordView
      if it is not recordHeight then
         put it into recordHeight
         -- if recordHeight is empty then put recordDefaultHeight into recordHeight
         add recordHeight + verticalSpacing to fHeight
         
         put viewTop + recordHeight into viewBottom
         put viewBottom into item 4 of viewRect
         
         -- set the view_Rect of recordView to viewRect
         -- set the rect of recordView to viewRect - will not work for controls
         -- dispatch "LayoutControl" to recordView with viewRect
         set the rect of recordView to viewRect
         -- set the rect_Mask of recordView to red
      end if
      
      -- as the record_Height may have been changed - let's recalculate.
      put viewTop + the height of recordView+ verticalSpacing into viewTop
      -- put viewBottom + verticalSpacing into viewTop
   end repeat
   
   if word 1 of formView is not "card" then
      if the showName of me is true then
         -- needed if title is showing as title moves things around
         -- but seems to muck up normal geometry?
         set the rect of me to pRect
      end if
   end if
   unlock screen
   
   -- set the uOPN ["inner_Rect"] of me to innerRect
   
   -- set the rect_Mask [pRect] of me to "blue"
end LayoutControl

getprop record_DefaultHeight
   return 24
end record_DefaultHeight

getprop formatted_Height
   if the long id of the target is not the long id of me then pass formatted_Height
   
   put the margins of me into someMargin
   margin_Normalize someMargin, lMargin, tMargin, rMargin, bMargin   
   put tMargin + bMargin into fHeight
   
   put the form_VerticalSpacing of me into verticalSpacing
   put the record_DefaultHeight of me into recordDefaultHeight
   
   put the form_Records of me into formRecords
   repeat for each line recordView in formRecords
      -- should this be "view_Height" or "formatted_Height"
      -- put the record_Height of recordView into recordHeight
      put the height of recordView into recordHeight
      if recordHeight is empty then
         put recordDefaultHeight into recordHeight
      else
         -- subtract 2 from recordHeight -- hack for border ???
      end if
      
      add recordHeight to fHeight
      add verticalSpacing to fHeight
   end repeat
   subtract verticalSpacing from fHeight
   
   if the showname of me is true then
      put the effective textsize of me into tHeight
      add round (tHeight/1) + 6 to fHeight
   end if
   return fHeight
end formatted_Height

getprop view_FormattedRect [pRect]
   if pRect is empty then put the rect of me into pRect
   
   put the formatted_Height of me into fHeight
   put item 2 of pRect + fHeight into item 4 of pRect
   return pRect
end view_FormattedRect

getprop auto_Scroll
   return the uOPN ["auto_Scroll"] of me
end auto_Scroll

setprop auto_Scroll [pRect] someBoolean
   if pRect is empty then put the rect of me into pRect
   
   lock screen
   set the uOPN ["auto_Scroll"] of me to someBoolean
   switch someBoolean
      case true
         put the formatted_Height of me into fHeight
         put item 4 of pRect - item 2 of pRect into actualHeight
         if fHeight > actualHeight then
            set the vScrollbar of me to true
         else
            set the vScrollbar of me to false
         end if
         break
      case false
         set the vScrollbar of me to false
         break         
   end switch
   dispatch "LayoutControl" to me
   unlock screen
end auto_Scroll

getprop form_Margins
   put the uOPN ["form_Margins"] of me into formMargins
   if formMargins is empty then return 16
   return formMargins
end form_Margins

setprop form_Margins formMargins
   set the uOPN ["form_Margins"] of me to formMargins
   LayoutControl
end form_Margins

getprop record_Height
   put the customproperties of me into propArray
   put propArray ["record_Height"] into recordHeight
   
   if recordHeight is empty then put the record_Height of the owner of me into recordHeight
   -- if recordHeight is empty then put the record_DefaultHeight of me into recordHeight
   return recordHeight
end record_Height

setprop record_Height recordHeight 
   set the view_DisplayProperty ["record_Height"] of me to recordHeight
   dispatch "LayoutControl" to me -- changes the target
   return the result
end record_Height

getprop record_DefaultHeight
   return 24
end record_DefaultHeight

private command _SetRecordTextHeight recordHeight, labelView, valueView
   -- lets auto set the text height
   put round((recordHeight - 18)/2) + 13 into guessTextHeight
   set the label_TextHeight of labelView to guessTextHeight
   if word 1 of valueView = "field" then
      set the textheight of valueView to guessTextHeight
   else
   end if
end _SetRecordTextHeight

on ResizeLabel recordLabelWidth
   -- upward (top down) chaining
   dispatch "ResizeLabel" to of the owner of me with recordLabelWidth
   if it is not "handled" then set the record_LabelWidth of me to recordLabelWidth
end ResizeLabel

getprop record_DefaultLabelWidth
   return 160
end record_DefaultLabelWidth

getprop record_LabelWidth
   -- if the long id of the target is not the long id of me then pass record_LabelWidth
   -- put the view_DisplayProperty ["record_LabelWidth"] of me into recordLabelWidth
   put the customproperties of me into propArray
   put propArray ["record_LabelWidth"] into recordLabelWidth
   
   if recordLabelWidth is empty then put the record_LabelWidth of the owner of me into recordLabelWidth
   if recordLabelWidth is empty then put the record_DefaultLabelWidth of me into recordLabelWidth
   return recordLabelWidth
end record_LabelWidth

setprop record_LabelWidth recordLabelWidth
   set the view_DisplayProperty ["record_LabelWidth"] of me to recordLabelWidth
   dispatch "LayoutControl" to me -- changes the target
end record_LabelWidth

getprop form_VerticalSpacing
   -- could duse view_Spacing?
   put the uOPN ["form_VerticalSpacing"] of me into formVerticalSpacing
   return formVerticalSpacing
end form_VerticalSpacing

setprop form_VerticalSpacing someSpacing
   set the uOPN ["form_VerticalSpacing"] of me to someSpacing
   set the view_Rect of me to the rect of me
end form_VerticalSpacing

getprop form_MaximumLabelWidth
   put the long id of me into formView
   
   put the form_Records of formView into formRecords
   repeat for each line recordView in formRecords
      put the record_LabelWidth of recordView & comma after recordLabelWidths
   end repeat
   return max(recordLabelWidths)
end form_MaximumLabelWidth

getprop view_Height
   -- a default that works for this layout (me)
   -- and any record groups that do not trap the view_Height property
   if the long id of the target = the long id of me then
      -- someone is asking for my height?
      return the formattedheight of me
   else
      -- return 100
      put the height of the target into recordHeight
      return recordHeight
   end if
end view_Height

getprop view_ResizeToContents
   return the uOPN ["view_ResizeToContents"] of me
   -- return the locklocation of me is false
end view_ResizeToContents

setprop view_ResizeToContents someBoolean
   set the uOPN ["view_ResizeToContents"] of me to someBoolean
   -- set the locklocation of me to (not someBoolean)
   resizeControl
end view_ResizeToContents


--> Deps
-
on form_AddToPostData recordName, recordValue, @postData
   get recordName & "=" & urlencode(recordValue)
   if postData is empty then
      put it into postData
   else
      put "&" & it after postData
   end if
end form_AddToPostData

command line_Delete someLines, @fromContainer, partLine, skipLines
   set the wholematches to (partLine is empty)
   repeat with ii = 1 to the number of lines of someLines
      put line ii of someLines into someLine
      get lineoffset(someLine, fromContainer, skipLines)
      if it is not 0 then
         put it + skipLines into lineNum
         delete line lineNum of fromContainer
      end if 
   end repeat
   return the number of lines of someIndex
end line_Delete

function object_GetGroupControls someGroup, nested
   put empty into myControls
   repeat with controlNum = 1 to the number of controls in someGroup
      put the long ID of control controlNum of someGroup into controlObject
      if nested is not true and word 1 of controlObject is "group" then
         add the number of layers in controlObject to controlNum
      end if
      put controlObject & return after myControls
   end repeat
   delete last char of myControls
   return myControls
end object_GetGroupControls

getprop object_TopControls
   put the long ID of the target into targetObject
   return object_GetGroupControls(targetObject, false)
end object_TopControls

function rect_GetInner groupRect, someGroup
   -- was "rect_GetVisibleRect", "rect_GetInnerRect"
   if word 1 of someGroup is not "group" then return groupRect
   put the margins of someGroup into someMargin
   
   put the scrollbarwidth of someGroup into scrollBarMargin
   if the vscrollbar of someGroup is true then subtract scrollBarMargin from item 3 of groupRect
   if the hscrollbar of someGroup is true then subtract scrollBarMargin from item 4 of groupRect
   
   if the showborder of someGroup is true then
      put the borderwidth of someGroup into bWidth
      
      if the showname of someGroup is true then
         put the effective textheight of someGroup - bWidth - 1 into someBit
         add someBit to item 2 of someMargin
      end if
      
      put rect_SubtractMargin(bWidth, groupRect) into groupRect
      -- subtract 2 from item 1 of groupRect	# fiddle
   end if
   
   -- add 2 to someMargin	# fiddle
   put rect_SubtractMargin(someMargin, groupRect) into innerRect
   return innerRect
end rect_GetInner

command margin_Normalize @someMargin, @leftM, @topM, @rightM, @bottomM
   -- fixed bug in setting bottomM when 4th item is empty
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   put leftM,topM,rightM,bottomM into someMargin
end margin_Normalize

getprop box_Rect [groupRect]
   put the long id of the target into someGroup
   if word 1 of someGroup is not "group" then return groupRect
   if groupRect is empty then put the rect of someGroup into groupRect
   
   if the showname of someGroup is true then
      put the effective textsize of someGroup into tHeight
      if the threeD of someGroup is true then
         add tHeight + 4 to someBit
      else
         add round (tHeight/2) + 0 to someBit
      end if
      add someBit to item 2 of groupRect
   end if
   return groupRect
end box_Rect

function rect_SubtractMargin someMargin, someRect
   margin_Normalize someMargin, lMargin, tMargin, rMargin, bMargin   
   add lMargin to item 1 of someRect
   add tMargin to item 2 of someRect
   subtract rMargin from item 3 of someRect
   subtract bMargin from item 4 of someRect
   return someRect
end rect_SubtractMargin

getprop view_Name
   -- a value of the target (property is not inherited by objects below)  
   put the uRIP ["name"] of the target into vName
   if the dgProps ["style"] of the target is among the items of "table,form" then
      -- it is a datagrid
      if vName is empty then
         -- in case it is not named (ie a vanilla Rev control)
         return "View|Rev|Datagrid"
      else
         return vName
      end if
   else if the uRIP ["type"] of the target is not "view" then
      -- it is not only views that have uRip names
      return empty
   else
      return vName
   end if
end view_Name


--> Objects
-
getprop form_Record [recordNum]
   put form_GetRecordObjects() into formRecords
   return line recordNum of formRecords
end form_Record

getprop form_Records
   put form_GetRecordObjects() into formRecords
   return formRecords
end form_Records

setprop form_Records formRecords
   form_SetRecordObjects formRecords
end form_Records

private function form_GetRecordObjects
   put the object_TopControls of me into formRecords
   -- put the form_Background of me into formBackground
   -- line_Delete formBackground, formRecords
   return formRecords
end form_GetRecordObjects

private command form_SetRecordObjects formRecords
   lock screen
   put the rect of me into oRect
   put form_GetRecordObjects() into oldRecords
   repeat for each line oldRecord in oldRecords
      delete oldRecord
   end repeat
   
   repeat for each line formRecord in formRecords
      copy formRecord to me
   end repeat
   
   set the view_Rect of me to oRect
   unlock screen
end form_SetRecordObjects

