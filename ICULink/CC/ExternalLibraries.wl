BeginPackage["ICULink`CC`ExternalLibraries`"];


Begin["`Private`"];


Needs["ICULink`Libraries`"] (* for $ICULibraryNames *)


DeclareCompiledComponent["ICULink", "ExternalLibraries" -> $ICULibraryNames];


End[];


EndPackage[];
