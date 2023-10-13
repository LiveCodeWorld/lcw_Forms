script "behavior_ViewColourRecord"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewColourRecord
type: behavior
version: 0.1

/*
This view is designed to display a colour swatch from the kuler web site.
*/


--> Working on
-
getprop colorMind_InputData [changeItems]
   /*
   put "{'input':[[44,43,44],[90,83,82],'N','N','N'],'model':'default'}" into iJSON
   replace "'" with quote in iJSON
   put json_ToArray (iJSON) into iArray
   */
   put the palette_Array of me into paletteArray
   repeat for each item changeItem in changeItems
      put colorMind_NameToItemNum (changeItem) into itemNum
      put "N" into paletteArray [itemNum]
   end repeat
   --
   put paletteArray into inputData ["input"]
   put "default" into inputData ["model"]
   --
   return inputData
end colorMind_InputData

getprop mind_Colour [mindName]
   put colorMind_NameToItemNum (mindName) into itemNum
   put "Colour" && itemNum into btnName
   put the long id of btn btnName of the colour_Group of me into buttonObject
   put the backgroundcolor of buttonObject into someColour
   return someColour
end mind_Colour

setprop mind_Colour [mindName] someColour
   put colorMind_NameToItemNum (mindName) into itemNum
   put "Colour" && itemNum into btnName
   put the long id of btn btnName of the colour_Group of me into buttonObject
   set the backgroundcolor of buttonObject to someColour
   return buttonObject
end mind_Colour

function colorMind_NameToItemNum mindName
   if mindName is a number then return mindName
   --
   switch mindName
      case "Light shades"
         return 1
      case "Light accent"
         return 2
      case "Main brand color"
         return 3
      case "Dark accent"
         return 4
      default -- "Dark shades"
         return 5
   end switch
end colorMind_NameToItemNum

getprop colour_PaletteData
   put the title_Text of me into colourPaletteData ["title"]
   put the tag_Items of me into colourPaletteData ["tags"]
   put the info_Text of me into colourPaletteData ["info"]
   put the palette_Array of me into colourPaletteData ["palette"]
   return colourPaletteData
end colour_PaletteData

setprop colour_PaletteData colourPaletteData
   lock screen
   set the title_Text of me to colourPaletteData ["title"]
   set the tag_Items of me to colourPaletteData ["tags"]
   set the info_Text of me to colourPaletteData ["info"]
   set the palette_Array of me to colourPaletteData ["palette"]
   LayoutControl
   unlock screen
end colour_PaletteData


--> Record | Data
-
on FillInData pDataArray
   set the title_Text of me to pDataArray ["themeItem"]["themeTitle"]   
   put pDataArray ["themeItem"]["themeTags"] into themeTags
   set the tag_Lines of me to themeTags
   
   put "author:" && pDataArray ["themeItem"]["themeAuthor"]["authorLabel"] & CR after infoText
   put "rating:" && pDataArray ["themeItem"]["themeRating"] & CR after infoText
   put "downloads:" && pDataArray ["themeItem"]["themeDownloadCount"] & CR after infoText
   delete char -1 of infoText
   set the info_Text of me to infoText
   
   repeat with swatchNum = 1 to 5
      put "swatch[" & swatchNum & "]" into someSwatch
      put round(pDataArray ["themeItem"]["themeSwatches"][someSwatch]["swatchChannel1"] * 256) into item 1 of someColour
      put round(pDataArray ["themeItem"]["themeSwatches"][someSwatch]["swatchChannel2"] * 256) into item 2 of someColour
      put round(pDataArray ["themeItem"]["themeSwatches"][someSwatch]["swatchChannel3"] * 256) into item 3 of someColour
      
      put someColour into colourPaletteArray [swatchNum]
   end repeat
   set the colour_Palette of me to colourPaletteArray
end FillInData

getprop colour_Palette
   local swatchArray
   repeat with btnNum = 1 to 5
      put "Colour" && btnNum into btnName
      put the backgroundcolor of btn btnName of the colour_Group of me into colourPaletteArray [btnNum] 
   end repeat
   return colourPaletteArray
end colour_Palette

setprop colour_Palette colourPaletteArray
   repeat with btnNum = 1 to 5
      put "Colour" && btnNum into btnName
      put colourPaletteArray [btnNum] into someColour
      set the backgroundcolor of btn btnName of the colour_Group of me to someColour
   end repeat
end colour_Palette

getprop palette_Array
   repeat with btnNum = 1 to 5
      put "Colour" && btnNum into btnName
      put the backgroundcolor of btn btnName of the colour_Group of me into someColour
      split someColour using comma
      put someColour into paletteArray [btnNum] 
   end repeat
   return paletteArray
end palette_Array

setprop palette_Array paletteArray
   repeat with btnNum = 1 to 5
      put "Colour" && btnNum into btnName
      put paletteArray [btnNum] into someColour
      combine someColour using comma
      set the backgroundcolor of btn btnName of the colour_Group of me to someColour
   end repeat
end palette_Array


--> Events | Geometry
-
on resizeControl
   LayoutControl the rect of me
end resizeControl

on LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   
   lock screen
   put the inner_Rect [pRect] of me into innerRect
   put 6 into someMargin
   
   put the basic_Palette of me into basicPalette
   put the width of basicPalette into basicWidth
   put the height of basicPalette into basicHeight
   
   put the tag_Field of me into tagField
   put the info_Field of me into infoField
   
   set the topleft of basicPalette to item 1 to 2 of innerRect
   
   put innerRect into infoRect
   put item 1 of innerRect + basicWidth + someMargin into infoLeft
   put infoLeft into item 1 of infoRect
   put item 2 of innerRect + basicHeight into infoBottom
   put infoBottom into item 4 of infoRect
   set the rect of infoField to infoRect
   
   if the text of tagField is empty then
      hide tagField
   else
      show tagField
      put innerRect into tagRect
      put the formattedheight of tagField - 4 into tagFieldHeight
      put infoBottom + someMargin into tagTop
      put tagTop into item 2 of tagRect
      put tagTop + tagFieldHeight into item 4 of tagRect
      set the rect of tagField to tagRect
   end if
   unlock screen
end LayoutControl


--> Events
-
on mouseUp
   set the backgroundcolor of the title_Field of me to ""
   pass mouseUp
end mouseUp

-- on mouseRelease
-- interestingly during a dragdrop this message is sent when the mouse leaves the dragsource
set the backgroundcolor of the title_Field of me to ""
pass mouseRelease
end mouseRelease

on mouseDoubleUp
   put the short name of the target into tName
   switch word 1 of tName
      case "Tags"
         put the clickText into searchTerm
         if searchTerm is empty then
            set the lockText of the target to not the lockText of the target
         else
            -- lcw_Notify the long name of me, true
            select the clickchunk
            send "kuler_SearchForKeyWord searchTerm" to me in 2 ticks
         end if
         break
      case "Colour"
         if the shiftKey is "Down" then
            put word -1 of tName into itemNum
            
            # Relies on internet and ColorMind API
            put the colorMind_InputData [itemNum] of me into inputData
            put colorMind_FetchPaletteArray (inputData) into paletteArray
            if paletteArray is an array then
               set the palette_Array of me to paletteArray
            end if
         else
            answer color
            put it into someColour
            set the backgroundcolor of the target to someColour
         end if
         break
      default
         pass mouseDoubleUp
   end switch
end mouseDoubleUp

on mouseDown pButton
   put the long id of the target into targetObject
   switch word 1 of the short name of targetObject
      case "Title"
         put the dgControl of me into dgView
         if exists(dgView) then set the dgHilitedLine of dgView to the dgLine of me
         if pButton = 3 then
            menu_PullDown "Global | Kuler | Title | Menu"
         else
            drag_SetGlobalStatus true
            -- RevBug!!! (not able to set dragData to an array)
            -- put the colour_Palette of targetObject into colourPaletteArray
            set the dragdata ["private"] to "colour_Palette"
         end if
         break
      case "Colour"
         drag_SetGlobalStatus true
         put the backgroundcolor of targetObject into someColour
         set the dragdata ["private"] to someColour
         break
      default
         pass mouseDown
   end switch
end mouseDown


--> Events | Drag
-
getprop drag_Enter
   put the dragDestination into targetObject
   put the dragsource into colourSource
   
   -- can't drop onto itself
   if colourSource = targetObject then return false
   
   -- if it is in the source stack pass to local "dragEnter"
   put the stack_Object of colourSource into sourceStack
   if targetObject contains sourceStack then return false
   
   -- if it is a "rev" stack don't allow dropping
   put the stack_Object of targetObject into targetStack
   put the short name of targetStack into targetStackName
   -- lcw_Notify targetStackName
   if char 1 to 3 of targetStackName = "rev" then
      set the dragAction to "none"
      -- lcw_Notify "Sorry - for now not allowing colouring of rev stacks!"
      return true
   end if
   
   put the dragData["private"] into droppedValue
   if droppedValue = "colour_Palette" then
      set the dragAction to "link"
   else
      set the dragAction to "link"
   end if
end drag_Enter

on dragStart
   switch word 1 of the short name of the target
      case "Title"
         set the backgroundcolor of the title_Field of me to "orange"
         break
   end switch
   pass dragStart
end dragStart

on dragEnd
   put the dragDestination into targetObject
   put the dragsource into colourSource -- RevBug - have to put on its own line!!!
   
   put the dragData["private"] into droppedValue
   if droppedValue = "colour_Palette" then set the backgroundcolor of the title_Field of me to ""
   
   if exists(targetObject) is false then return false -- probably not dropped on an object
   
   if exists(the kuler_View of targetObject) then
      dragDropOnKuler targetObject, colourSource
   else
      if droppedValue = "colour_Palette" then
         put the colour_Palette of colourSource into colourPaletteArray
         set the colour_Palette of targetObject to colourPaletteArray    
      else if droppedValue is a color then
         put the backgroundcolor of colourSource into dropColour
         put the short name of colourSource into colourSourceName
         switch word 2 of colourSourceName
            case "1"
               set the foregroundcolor of targetObject to dropColour
               break
            case "2"
               set the backgroundcolor of targetObject to dropColour
               break
            case "3"
               put the card_Object of targetObject into cardObject
               set the backgroundcolor of cardObject to dropColour
               break
            case "4"
               if word 1 of targetObject = "group" then
                  put targetObject into groupObject
               else
                  delete word 1 to 4 of groupObject
               end if
               if word 1 of groupObject = "group" then
                  set the backgroundcolor of groupObject to dropColour
               else
                  beep
                  lcw_Notify "Cannot find group to colour!"
               end if
               break
            case "5"
               put the stack_Object of targetObject into stackObject
               set the linkcolor of stackObject to dropColour
               break
         end switch
      end if
   end if
end dragEnd

on dragDropOnKuler targetObject, colourSource
   if the dragData["private"] is a color then
      set the borderColor of targetObject to ""
      put the backgroundcolor of colourSource into sourceColour
      
      if the dragAction = "link" then
         -- swapping within a recordView
         put the backgroundcolor of targetObject into dropColour
         set the backgroundcolor of targetObject to sourceColour
         set the backgroundcolor of colourSource to dropColour
         
         put the dgDatacontrol of targetObject into recordView
         _UpdateRecord recordView
      else
         lcw_Notify ("Copying colour to new position" & CR & sourceColour)
         set the backgroundcolor of targetObject to sourceColour
      end if
   end if
end dragDropOnKuler

on dragEnter
   put the long id of the target into targetObject
   put the dragsource into colourSource
   if targetObject = colourSource then pass dragEnter
   
   if targetObject contains the stack_Object of colourSource then
      if the dragData["private"] is not a color then
         set the dragaction to "none"
         return false
      end if
   end if
   
   switch word 1 of the short name of targetObject
      case "Title"
         set the dragAction to "link"
         break
      case "Colour"
         set the borderColor of targetObject to "green"
         put colourSource into colourGroup
         delete word 1 to 4 of colourGroup
         if targetObject contains colourGroup then
            set the dragAction to "link"
         else
            set the dragAction to "copy"
         end if
         break
      default
         pass dragEnter
   end switch
end dragEnter

on dragLeave
   put the long id of the target into targetObject
   switch word 1 of the short name of targetObject
      case "Colour"
         set the borderColor of targetObject to ""
         break
      default
         pass dragLeave
   end switch
end dragLeave

private command _UpdateRecord recordView
   put the title_Text of recordView into swatchName
   put the dgControl of recordView into dgView
   
   put the dgIndex of recordView into indexNum
   put the dgDataOfIndex [indexNum] of dgView into dataArray
   
   repeat with swatchNum = 1 to 5
      put "Colour" && swatchNum into btnName
      put the backgroundcolor of btn btnName of the colour_Group of recordView into someColour
      put _ConstructKulerSwatchArray (someColour) into swatchArray
      
      put "swatch[" & swatchNum & "]" into someSwatch
      put swatchArray into dataArray ["themeItem"]["themeSwatches"][someSwatch]
   end repeat
   
   set the dgDataOfIndex [indexNum] of dgView to dataArray
end _UpdateRecord

private function _ConstructKulerSwatchArray someRGB
   put "0" into swatchArray ["swatchIndex"]
   put (item 1 of someRGB / 256) into swatchArray ["swatchChannel1"]
   put (item 2 of someRGB / 256) into swatchArray ["swatchChannel2"]
   put (item 3 of someRGB / 256) into swatchArray ["swatchChannel3"]
   put "0.0" into swatchArray ["swatchChannel4"]
   put colour_RgbToHex(someRGB) into swatchArray ["swatchHexColor"]
   return swatchArray
end _ConstructKulerSwatchArray


--> Colour | Metadata
-
getprop title_Text
   return the text of the title_Field of me
end title_Text

setprop title_Text someTitle
   set the text of the title_Field of me to someTitle
end title_Text

getprop info_Text
   return the text of the info_Field of me
end info_Text

setprop info_Text infoText
   set the text of the info_Field of me to infoText
end info_Text

getprop tag_Lines
   put the text of the tag_Field of me into tagItems
   repeat for each item tagItem in tagItems
      repeat for each word tagWord in tagLine
         put tagWord & ", " after tagWords
      end repeat
      delete char -2 to -1 of tagWords
      put tagWords & CR after tagLines
   end repeat
   delete char -1 of tagLines
   return tagLines
end tag_Lines

setprop tag_Lines tagLines
   replace comma with space in tagLines
   replace CR with ", " in tagLines
   set the text of the tag_Field of me to tagLines
end tag_Lines

getprop tag_Items
   return the text of the tag_Field of me
end tag_Items

setprop tag_Items tagItems
   set the text of the tag_Field of me to tagItems
end tag_Items


--> Display
-
setprop dgHilite pBoolean
   if pBoolean then
      put the dgProp["hilited text color"] of me into someColour
      set the foregroundcolor of me to ""
      set the backgroundcolor of me to "pink"
   else
      set the foregroundcolor of me to empty
      set the backgroundcolor of me to ""
   end if
end dgHilite


--> Objects
-
getprop basic_Palette
   return the long id of grp "Basic Colour Palette" of me
end basic_Palette

getprop colour_Group
   return the long id of grp "Colours" of me
end colour_Group

getprop title_Field
   return the long id of fld "Title" of me
end title_Field

getprop info_Field
   return the long id of fld "Info" of me
end info_Field

getprop tag_Field
   return the long id of fld "Tags" of me
end tag_Field

getprop view_Object
   return the long id of me
end view_Object

getprop colour_Record
   return the long id of me
end colour_Record

getprop dgDataControl
   return the long id of me
end dgDataControl
