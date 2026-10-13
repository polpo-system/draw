# Draw of ETH Oberon, for polpo

Draw is the line drawing editor of the Oberon system (N. Wirth, 1988; ported to System 3 at
ETH in 1994). A drawing is made of horizontal and vertical lines, captions in
any font, and macros: small drawings kept in libraries, such as the TTL circuits of
`TTL0.Lib`. Further modules add rectangles, oblique lines, circles, ellipses and spline curves.
It needs only the classic desktop (viewers and text frames), not Gadgets.

This is the Draw of Native Oberon 2.3.7, with its tool text, its guide, the TTL macro
libraries, the electrical symbols font and the example drawings. polpo compiles it on all its
architectures (x86, ARM, ARMv7, RISC-V, MIPS).

## What is here

    Draw.Tool             the tool text: the commands to click
    DrawGuide.Text        the guide by N. Wirth: mouse, commands, macros
    src/Graphics.Mod      drawings, lines, captions, macros and libraries; reading and writing
    src/GraphicFrames.Mod the frames that show a drawing and take the mouse and the keys
    src/Draw.Mod          the commands: Open, Store, SetWidth, ChangeFont, Macro, ...
    src/Rectangles.Mod    rectangles (Rectangles.Make, SetShade)
    src/Curves.Mod        oblique lines, circles, ellipses (Curves.MakeLine, MakeCircle, MakeEllipse)
    src/Splines.Mod       open and closed spline curves (Splines.MakeOpen, MakeClosed)
    share/TTL0.Lib        macro libraries: TTL circuits
    share/TTL1.Lib
    share/TTL0.Graph      drawings that show every macro of the libraries
    share/TTL1.Graph
    share/Elektra.Graph   the symbols of the Elektra font
    fonts/Elektra.Scn.Fnt a font of electrical symbols
    test/DrawTest.Mod     the test: a drawing loads, is written again and reads back the same
    test/sample.Graph     a drawing with each kind of element

## Installing

With portia, the package manager of polpo: `portia.Install draw`. The tool text and the guide
go to `tools/`, the libraries and drawings to `share/` and the font to `fonts/`, where polpo
finds them by name from any directory; the sources are in `src/pkg/draw/`.

## Using it

In the desktop (`loksh System.Init`), open the tool text with `System.Open Draw.Tool` and
the guide with `Script.Open DrawGuide.Text`. Then:

    Draw.Open TTL0.Graph      opens a drawing (a new one if the file does not exist)
    Draw.Store                writes the drawing of the viewer (menu), or Draw.Store name

The mouse, in a drawing:

    left                      draw a line (horizontal or vertical)
    left, no motion           set the caret; then type a caption
    left + right              set a secondary caret (for rectangles, circles, splines)
    middle                    move the selection
    middle + left             copy the selection
    middle + right            shift the drawing in the viewer
    right                     select the elements in a rectangle
    right, no motion          select one element (a macro by its lower left corner)
    right + left              select without deselecting the rest

A circle: set the caret at the centre, a secondary caret at the radius, then click
`Curves.MakeCircle`. A macro: set the caret, then `Draw.Macro TTL0 N00`. The guide explains
the rest, including how to make macros and libraries of your own.

## Changes for polpo

  * The sources are plain text instead of Oberon texts, indented with spaces.
  * Graphics: a drawing that uses a macro of a missing library (or a macro the library does
    not have) opens without that macro and says so in the log; before, it trapped.

`Draw.Print` needs a printer driver (`LPRPrinter`, `PSPrinter` of Native Oberon), which polpo
does not have yet: it does nothing.

## Testing

`DrawTest.Run file` opens the drawing, counts its elements, writes it to a new file, reads that
back and compares the counts. It needs the desktop modules (DISPLAY set; an Xvnc will do).

    DrawTest.Run sample.Graph
    DrawTest: sample.Graph lines 2 captions 29 macros 1 curves 3 rectangles 1 splines 1 ok

The license is GPL-3 (`LICENSE`); the code comes from ETH Oberon, whose license (`LICENSE.ETH`)
asks to keep its copyright notice and conditions, which `LICENSE.ETH` does.
