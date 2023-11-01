BeginPackage["ICULink`Debug`"];

$DebugMode;

DebugPrint;

Begin["`Private`"];

If[!BooleanQ[$DebugMode],
	$DebugMode = False;
];

SetAttributes[DebugPrint, HoldAll];

DebugPrint[args___] /; TrueQ[$DebugMode] :=
	Print[args];

End[];

EndPackage[];
