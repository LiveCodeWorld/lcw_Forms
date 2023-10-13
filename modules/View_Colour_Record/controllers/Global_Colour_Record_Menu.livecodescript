script "Global | Colour | Record | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Colour | Record | Menu
type: controller
version: 0.1

/*
Light shades
Use this color as the background for your dark-on-light designs, or the text color of an inverted design.

Light accent
Accent colors can be used to bring attention to design elements by contrasting with the rest of the palette.

Main brand color
This color should be eye-catching but not harsh. It can be liberally applied to your layout as its main identity.

Dark accent
Another accent color to consider. Not all colors have to be used - sometimes a simple color scheme works best.

Dark shades
Use as the text color for dark-on-light designs, or as the background for inverted designs.
*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop changeColour_Params
   return "Light shades,Light accent,Main brand color,Dark accent,Dark shades"
end changeColour_Params

getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop colourPalette_Param [colourRecord]
   return the title_Text of colourRecord
end colourPalette_Param

getprop colourPalette_Params
   return colour_ListPaletteNames()
end colourPalette_Params


--> Global | Colour | Record | Menu
-
on menu_RandomColorMind colourRecord
   put the title_Text of colourRecord into cTitle
   put lcw_Ask ("What name would you like to give this colour palette?", cTitle) into cTitle
   --
   put colorMind_FetchPaletteArray() into cPaletteArray
   put colour_ConstructPaletteData (cTitle, cPaletteArray) into colourPaletteData
   --
   set the colour_PaletteData of colourRecord to colourPaletteData
end menu_RandomColorMind

on menu_ChangeColour colourRecord, mindName
   put the colorMind_InputData [mindName] of colourRecord into inputData
   put colorMind_FetchPaletteArray (inputData) into paletteArray
   
   if paletteArray is an array then
      set the palette_Array of colourRecord to paletteArray
      
      -- display_Data inputData, "colorMind_InputData"
      -- display_Data paletteArray, "colorMind_FetchPaletteArray"
      put the mind_Colour [mindName] of colourRecord
   else
      breakpoint
   end if
end menu_ChangeColour

on menu_DisplayPaletteArray colourRecord
   put the palette_Array of colourRecord into paletteArray
   display_Data paletteArray, "palette_Array"
end menu_DisplayPaletteArray

private command _
end _

on menu_ColourPalette colourRecord, paletteTitle
   put colour_GetPalette (paletteTitle) into colourPaletteData
   set the colour_PaletteData of colourRecord to colourPaletteData
end menu_ColourPalette

on menu_SaveColourPalette colourRecord
   put the colour_PaletteData of colourRecord into colourPaletteData
   --
   colour_SavePalette colourPaletteData
end menu_SaveColourPalette

private command __
end __

on menu_ImportKulerXml colourRecord
   /*
   <palette>
   <color name='UI/UX-1' rgb='0D734D' r='13' g='115' b='77' />
   <color name='UI/UX-2' rgb='078C4E' r='7' g='140' b='78' />
   <color name='UI/UX-3' rgb='D9D9D9' r='217' g='217' b='217' />
   <color name='UI/UX-4' rgb='404040' r='64' g='64' b='64' />
   <color name='UI/UX-5' rgb='0D0D0D' r='13' g='13' b='13' />
   </palette>
   */
   -- put debug_GetCommentAbove() into someXML
   local someXML
   put lcw_Ask ("Paste Adobe Kuler XML...", someXML) into kulerXML
   --
   put "Author: https://color.adobe.com" into infoText
   put CR & "Tags:" after infoText
   put CR & "Created:" && the short date after infoText
   --
   put kuler_XmlToPalleteData (kulerXML, infoText) into colourPaletteData
   --
   --  display_Data paletteArray, "kuler Palette Array"
   set the colour_PaletteData of colourRecord to colourPaletteData
end menu_ImportKulerXml

on menu_LaunchKuler
   launch url "https://color.adobe.com/explore"
end menu_LaunchKuler
