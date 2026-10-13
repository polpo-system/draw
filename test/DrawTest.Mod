MODULE DrawTest;  (** DrawTest.Run file: the drawing loads, is written again and reads back the same *)
IMPORT Texts, Oberon, Files, Graphics, Curves, Rectangles, Splines, out;  (* out: the standard output, for the tests of portia *)

CONST Kinds = 7;  (* lines, captions, macros, curves, rectangles, splines, others *)

TYPE Counts = ARRAY Kinds OF INTEGER;

VAR count: Counts;

PROCEDURE Count(obj: Graphics.Object; VAR done: BOOLEAN);
BEGIN
  IF obj IS Graphics.Line THEN INC(count[0])
  ELSIF obj IS Graphics.Caption THEN INC(count[1])
  ELSIF obj IS Graphics.Macro THEN INC(count[2])
  ELSIF obj IS Curves.Curve THEN INC(count[3])
  ELSIF obj IS Rectangles.Rectangle THEN INC(count[4])
  ELSIF obj IS Splines.Spline THEN INC(count[5])
  ELSE INC(count[6])
  END
END Count;

PROCEDURE Load(name: ARRAY OF CHAR; VAR c: Counts): BOOLEAN;
VAR G: Graphics.Graph; i: INTEGER;
BEGIN
  i := 0; WHILE i < Kinds DO count[i] := 0; INC(i) END;
  NEW(G); Graphics.Open(G, name);
  IF Graphics.res # 0 THEN RETURN FALSE END;
  Graphics.Enumerate(G, Count); c := count;
  RETURN TRUE
END Load;

PROCEDURE Show(VAR c: Counts);
BEGIN
  out.String(" lines "); out.Int(c[0], 0); out.String(" captions "); out.Int(c[1], 0);
  out.String(" macros "); out.Int(c[2], 0); out.String(" curves "); out.Int(c[3], 0);
  out.String(" rectangles "); out.Int(c[4], 0); out.String(" splines "); out.Int(c[5], 0);
  IF c[6] # 0 THEN out.String(" others "); out.Int(c[6], 0) END
END Show;

PROCEDURE Run*;
VAR S: Texts.Scanner; name: ARRAY 64 OF CHAR; a, b: Counts; G: Graphics.Graph; i, res: INTEGER; same: BOOLEAN;
BEGIN
  Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
  IF (S.class # Texts.Name) & (S.class # Texts.String) THEN out.String("usage: DrawTest.Run file"); out.Ln; RETURN END;
  COPY(S.s, name);
  out.String("DrawTest: "); out.String(name);
  IF ~Load(name, a) THEN out.String(" does not load"); out.Ln; RETURN END;
  Show(a);
  NEW(G); Graphics.Open(G, name); Graphics.WriteFile(G, "zq_draw.Graph");
  same := Load("zq_draw.Graph", b);
  i := 0; WHILE same & (i < Kinds) DO same := a[i] = b[i]; INC(i) END;
  Files.Delete("zq_draw.Graph", res);
  IF same & (a[6] = 0) THEN out.String(" ok") ELSE out.String(" wrong") END;
  out.Ln
END Run;

END DrawTest.
