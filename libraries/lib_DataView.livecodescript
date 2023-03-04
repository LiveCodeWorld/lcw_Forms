script "lib_DataView"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_DataView
type: library
version: 0.1

/*Some help*/


--> Working on
-
function dv_ListRowViewTemplates pStackNames
   if pStackNames is empty then put the openStacks into pStackNames
   repeat for each line stackName in pStackNames
      if exists (control 1 of stack stackName) then
         put the dvRowControl of control 1 of stack stackName into rowView
         if exists (rowView) then
            put stackName & CR after rowViewStackNames
         end if
      end if
   end repeat
   delete char -1 of rowViewStackNames
   return rowViewStackNames
end dv_ListRowViewTemplates
   
function dv_ListStackNames pStackNames
   if pStackNames is empty then put the openStacks into pStackNames
   repeat for each line stackName in pStackNames
      if exists (control 1 of stack stackName) then
         put the dvControl of control 1 of stack stackName into dView
         if exists (dView) then
            put stackName & CR after dvStackNames
         end if
      end if
   end repeat
   return dvStackNames
end dv_ListStackNames

function dv_FilterByStyle dData, rowStyle
   local fData
   dv_AddFiltered fData, rowStyle, dData
   return fData
end dv_FilterByStyle

command dv_AddFiltered @fData, rowStyle, dData, pNewItemNum
   if pNewItemNum is not a number then put 1 into pNewItemNum
   repeat with itemNum = 1 to item 2 of the extents of dData
      put dData [itemNum] into rowData
      if rowData ["@style"] is rowStyle then
         put rowData into fData [pNewItemNum]
         add 1 to pNewItemNum
      end if
   end repeat
end dv_AddFiltered

command dv_InsertNewRows @dData, newIData
   -- at top only for now.
   put newIData into nData [1]
   --
   put item 2 of the extents of nData + 1 into newRowNum
   repeat with itemNum = 1 to item 2 of the extents of dData
      put dData [itemNum] into rowData
      put rowData into nData [newRowNum]
      add 1 to newRowNum
   end repeat
   put nData into dData
end dv_InsertNewRows

command display_DvRowStyleArray dView
   put the dv_RowStyleArray of dView into styleArray
   --
   display_Data styleArray, the short name of dView, "Row Style Array"
   put the result into displayView
   return displayView
end display_DvRowStyleArray


--> Props
-
getprop dv_WikiSlug
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the dv_Metadata ["pSlug"] of dView into pSlug
   return pSlug
end dv_WikiSlug

getprop dv_Wikidomain
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the dv_Metadata ["wikiDomain"] of dView into wikiDomain
   return wikiDomain
end dv_Wikidomain

setprop dv_Wikidomain [pSlug] wikiDomain
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   
   put the dv_RowStyleNames of dView into styleNames
   put dv_FetchWikiStoryData (wikiDomain, pSlug, styleNames) into storyData
   --
   set the dvData of dView to storyData
   --
   set the dv_Metadata ["wikiDomain"] of dView to wikiDomain
   set the dv_Metadata ["pSlug"] of dView to pSlug
   --
   return storyData
end dv_Wikidomain


--> DataView | Row
-
getprop dv_RowNum
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   --
   put the dvRow of rowView into rowNum
   return rowNum
end dv_RowNum

getprop dv_RowData
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   put the dvRow of rowView into rowNum
   --
   -- put the dvData of rowView into dData
   -- put dData [rowNum] into rowData
   put the dvRowData [rowNum] of rowView into rowData
   return rowData
end dv_RowData

setprop dv_RowData [rowType] rowData
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   put the dvRow of rowView into rowNum
   --
   if rowType is not empty then put rowType into rowData ["@style"]
   --
   put the dvData of me into dData
   put rowData into dData [rowNum]
   set the dvData of me to dData
   --
   return dData
end dv_RowData

getprop dv_RowValue [someKey]
   put the dv_RowData of the target into rowData
   return rowData [someKey]
end dv_RowValue

setprop dv_RowValue [someKey] someValue
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   --
   put the dvData of rowView into dData
   put the dvRow of rowView into rowNum
   --
   put someValue into dData [rowNum][someKey]
   set the dvData of rowView to dData
   --
   return dData
end dv_RowValue


--> DataView | RowTemplate
-
getprop dv_RowTemplateName [rowStyleName]
   put the dv_RowTemplate [rowStyleName] of the target into templateObject
   if exists (templateObject) is false then return empty
   
   put the view_Name of templateObject into viewName
   return viewName
end dv_RowTemplateName

setprop dv_RowTemplateName [rowStyleName] viewName
   put view_GetTemplateObject (viewName) into templateObject
   if exists (templateObject) is false then return empty
   
   set the dv_RowTemplate [rowStyleName] of the target to templateObject
   return the result
end dv_RowTemplateName

getprop dv_MulipleHilites
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the viewProp ["multiple lines"] of dView into someBoolean
   return someBoolean
end dv_MulipleHilites

setprop dv_MulipleHilites someBoolean
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   set the viewProp ["multiple lines"] of dView to someBoolean
end dv_MulipleHilites

getprop dv_RowTemplate [rowStyleName]
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   put dvRowStyleArray [rowStyleName] into templateObject
   return templateObject
end dv_RowTemplate

setprop dv_RowTemplate [rowStyleName] templateObject
   put the dvControl of the target into dView
   if exists (dView) is false then return "error, not a DataView"
   --
   if exists (templateObject) is false then
      return "error, rowTemplate does not exist"
   else
      put revRuggedId (templateObject) into templateObject
   end if
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   put templateObject into dvRowStyleArray [rowStyleName]
   set the viewProp ["row style templates"] of dView to dvRowStyleArray
   
   -- make sure it si in the stackfile
   set the stackFile_LinkObject of dView to templateObject
   --
   return dvRowStyleArray
end dv_RowTemplate

getprop dv_RowBehavior [rowNum]
   if rowNum is empty then put the dvClickRow of target into rowNum
   
   put the dvRowData [rowNum] of the target into rowData
   --
   put rowData ["@style"] into rowStyle
   put the dv_RowStyleArray of target into rowStyleArray
   put rowStyleArray [rowStyle] into rowBehavior
   return rowBehavior
end dv_RowBehavior


--> DataView | Row | Style
-
getprop dv_RowStyle
   put the dv_RowValue ["@style"] of the target into rowType
   return rowType
end dv_RowStyle

setprop dv_RowStyle rowType
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   --
   put the dvRow of rowView into rowNum
   
   put the dvData of me into dData
   put rowType into dData [rowNum]["@style"]
   set the dvData of me to dData
   --
   return dData
end dv_RowStyle

getprop dv_RowStyleNames
   put the dv_RowStyleArray of the target into dvRowStyleArray
   put keys (dvRowStyleArray) into styleNames
   return styleNames
end dv_RowStyleNames

getprop dv_RowStyleArray
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   return dvRowStyleArray
end dv_RowStyleArray

setprop dv_RowStyleArray [rowName] someValue
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   switch
      case rowName is empty and someValue is an array
         set the viewProp ["row style templates"] of dView to someValue
         break
      case rowName is not empty and someValue is not an array
         set the dv_RowTemplate [rowName] of dView to someValue
         break
      default
         breakpoint
   end switch
end dv_RowStyleArray

getprop dv_Controls
   put the long id of the target into tObject
   switch word 1 of tObject
      case "stack"
         put the long id of the current card of the defaultstack into cardObject
         return _CardDvControls (cardObject)
      case "card"
         return _CardDvControls (tObject)
      default
         return the dv_ControlsWithin of tObject
   end switch
end dv_Controls

getprop dv_ControlsWithin
   -- is it a dvControl or is there a dvControl one level deep within it?
   -- could recurse
   put the long id of the target into tObject
   --
   put the dvControl of tObject into fObject
   switch
      case fObject = tObject
         return fObject
      case fObject is not empty
         return empty
   end switch
   
   put the childControlIDs of tObject into cIDs
   repeat for each line cID in cIDs
      put the dvControl of control id cID of tObject into fObject
      switch fObject
         case empty
         case tObject
            break
         default
            put fObject & CR after fObjects
      end switch
   end repeat
   delete char -1 of fObjects
   return fObjects
end dv_ControlsWithin


--> DataVieew | Metadata
-
getprop dv_Metadata [someKey]
   put the dv_MetadataObject of the target into metadataObject
   --
   put the uLCW ["dv_Metadata"] of metadataObject into dvMetadata
   if someKey is empty then
      return dvMetadata
   else
      return dvMetadata [someKey]
   end if
end dv_Metadata

setprop dv_Metadata [someKey] someValue
   put the dv_MetadataObject of the target into metadataObject
   --
   if someKey is empty then
      set the uLCW ["dv_Metadata"] of metadataObject to someValue
   else
      put the uLCW ["dv_Metadata"] of metadataObject into dvMetadata
      put someValue into dvMetadata [someKey]
      set the uLCW ["dv_Metadata"] of metadataObject to dvMetadata
   end if
end dv_Metadata

getprop dv_MetadataObject
   -- makes it easy to reference a standard local place to store metadata for a dv 
   put the long id of the target into tObject
   
   put the dvControl of tObject into dView
   if exists (dView) then return dView
   
   put the display_View of tObject into displayView
   if exists (displayView) then return displayView
   
   put the card_Object of tObject into cObject
   return cObject
end dv_MetadataObject


--> DataView
-
command dv_AddMarkdownTitle @dData, someTitle, pLevel
   if someTitle is empty then return 0
   --
   if pLevel is empty then put 1 into pLevel
   put text_RepeatString ("#", pLevel) && someTitle into someMarkdown
   --
   -- dv_AddMarkdown dData, someMarkdown
   put dv_ConstructItem (someMarkdown, "markdown") into itemArray
   put pLevel into itemArray ["level"]
   dv_AddItemArray itemArray, dData
   --
   put the result into insertedIndexNum
   return insertedIndexNum
end dv_AddMarkdownTitle

command dv_AddMarkdown @dData, someMarkdown
   if someTitle is empty then return 0
   --
   put dv_ConstructItem (someMarkdown, "markdown") into itemArray
   dv_AddItemArray itemArray, dData
   put the result into insertedIndexNum
   --
   return insertedIndexNum
end dv_AddMarkdown

command dv_AddItemArray itemArray, @dData
   if itemArray is not an array then return 0
   --
   put item 2 of the extents of dData into lastIndexNum
   add 1 to lastIndexNum
   put itemArray into dData [lastIndexNum]
   --
   return lastIndexNum
end dv_AddItemArray

function dv_ConstructItem someText, itemType, pID
   if pID is empty then put uuid () into pID
   --
   put someText into itemArray ["text"]
   put itemType into itemArray ["@style"]
   put pID into itemArray ["id"]
   return itemArray
end dv_ConstructItem

function dv_FetchWikiStoryData wikiDomain, pSlug, pStyleNames
   put pageArray_Fetch (wikiDomain, pSlug) into pageArray
   put pageArray ["story"] into storyArray
   repeat for each key itemNum in storyArray
      put storyArray [itemNum]["type"] into itemType
      --
      switch
         case itemType = "paragraph" -- made a mistake in naming of group
            put "text" into storyArray [itemNum]["@style"]
            break
         case itemType is among the lines of pStyleNames
            put itemType into storyArray [itemNum]["@style"]
            break
         default
            put "default" into storyArray [itemNum]["@style"]
      end switch
      delete variable storyArray [itemNum]["type"]
   end repeat
   return storyArray
end dv_FetchWikiStoryData

command dv_TidyHTML @someHTML
   replace "<h1>" with "<h3>" in someHTML 
   replace "</h1>" with "</h3>" in someHTML 
end dv_TidyHTML


--> Private
-
private function _CardDvControls cardObject
   put the groupIDs of cardObject into gIDs
   repeat for each line gID in gIDs
      put the the dv_ControlsWithin of group id gID of cardObject into groupControls
      if groupControls is not empty then
         put groupControls & CR after dvControls
      end if
   end repeat
   delete char -1 of dvControls
   return dvControls
end _CardDvControls
