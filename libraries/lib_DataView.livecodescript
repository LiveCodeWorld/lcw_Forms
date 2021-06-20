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

getprop dv_LinkedRowStack
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   
   put the dv_MetadataObject of dView into metadataObject
   put the uLCW ["dv_LinkedRowStack"] of metadataObject into stackName
   return stackName
end dv_LinkedRowStack

setprop dv_LinkedRowStack stackName
   if exists (stack stackName) is false then return "error, stack does not exists:" && stackName
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   
   put the short name of stack stackName into stackName -- could be a path
   --
   put the dv_MetadataObject of dView into metadataObject
   set the uLCW ["dv_LinkedRowStack"] of metadataObject to stackName
   --
   set the stackFile_Link of dView to stackName
   return metadataObject
end dv_LinkedRowStack
   
getprop dv_LinkedDataView
   put the dv_MetadataObject of the target into metadataObject
   put the uLCW ["dv_LinkedDataView"] of metadataObject into dView
   return dView
end dv_LinkedDataView

setprop dv_LinkedDataView dView
   -- set this for a card, button or dataview to link menus or other tools to a specific instance
   if exists (dView) is false then return "error, dView does not exists:" && dView
   put revRuggedID (dView) into dView
   
   put the dv_MetadataObject of the target into metadataObject
   set the uLCW ["dv_LinkedDataView"] of metadataObject to dView
   return metadataObject
end dv_LinkedDataView

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


--> Levure
-
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


--> DataView
-
command dv_AddMarkdownTitle @dData, someTitle, pLevel
   if someTitle is empty then return 0
   --
   if pLevel is empty then put 1 into pLevel
   put text_RepeatString ("#", pLevel) && someTitle into someMarkdown
   --
   dv_AddMarkdown dData, someMarkdown
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

command dv_CreateModule moduleName, pDisplayView, pProjectName
   -- defaults to creating a modulee in the "lcw_Forms" project
   
   put view_GetTemplateObject (moduleName) into rowTemplate
   if exists (rowTemplate) then
      lcw_AnswerWarning  "A view or module called '[[moduleName]]' already exists!", pDisplayView, moduleName
   end if
   --
   if pProjectName is empty then
      put "lcw_Forms" into pProjectName
      -- put "lcw_Wiki" into pProjectName
   end if
   put module_ConstructFolder (moduleName, pProjectName) into moduleFolder
   if there is a folder moduleFolder is false then
      return "Error, theree is not folder for the module:" && pProjectName
   end if
   --
   module_Create moduleFolder, moduleName
   put the result into resultArray
   --
   go to stack moduleName
   save stack moduleName
   display_ModuleTools moduleName, true
   --
   return resultArray
   --
   put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
   put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
end dv_CreateModule

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


--> Deps
-
command indexedArray_Add @indexedData, itemArray, insertNum
   put item 2 of the extents of indexedData into maxNum
   
   -- move all items (rows) from insertNum onwards one-up
   repeat with itemNum = maxNum down to rowNum
      get indexedData [itemNum] 
      put itemNum + 1 into oneAfter
      put it into indexedData [oneAfter]
   end repeat
   
   -- insert itemArray into row insertNum (overwriting duplicated old row)
   put itemArray into indexedData [insertNum]
end indexedArray_Add

command indexedArray_Delete @indexedData, rowRow
   put item 2 of the extents of indexedData into maxNum
   put indexedData [rowRow] into rowDataToMove
   
   -- first lets delete and re-number
   put rowRow + 1 into startDeleteNum
   repeat with itemNum = startDeleteNum to maxNum
      get indexedData [itemNum]
      put itemNum - 1 into oneBefore
      put it into indexedData [oneBefore]
   end repeat
   delete variable indexedData [maxNum]
   --
   return rowDataToMove
end indexedArray_Delete
