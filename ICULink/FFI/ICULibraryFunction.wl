BeginPackage["ICULink`FFI`ICULibraryFunction`"];


ICULibraryFunction;

ICULibraryFunctionLoad;


Begin["`Private`"];


Needs["ICULink`FFI`Utilities`"];
Needs["ICULink`Debug`"];
Needs["ICULink`Libraries`"];


ICULibraryFunction[funName_String] :=
	(
		DebugPrint["ICULibraryFunction: ", funName, " is not loaded."];
		$Failed
	);


ICULibraryFunctionLoad[lib_, funName_, argTypes_List, resType_] :=
	Module[{libLoaded, fun},
		libLoaded = ICULoadLibraries[];
		If[FailureQ[libLoaded],
			DebugPrint["ICULibraryFunctionLoad: ICULoadLibraries[] failed."];
			Return @ libLoaded;
		];
		fun = ForeignFunctionLoad[lib, funName, MapAll[ICUType, argTypes] -> MapAll[ICUType, resType]];
		If[Head[fun] =!= ForeignFunction,
			DebugPrint["ICULibraryFunctionLoad: Failed to load ", funName, "."];
			Return @ fun;
		];
		DebugPrint["ICULibraryFunctionLoad: Succesfully loaded ", funName, "."];
		ICULibraryFunction[funName] = fun
	];


End[];


EndPackage[];
