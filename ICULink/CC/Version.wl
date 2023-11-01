BeginPackage["ICULink`CC`Version`"];


Begin["`Private`"];


Needs["ICULink`Libraries`"];


With[{
	$UMAXVERSIONLENGTH = 4
},

$declarations = {
	TypeDeclaration[
		"Alias",
		"UVersionInfo", "CArray"::["UnsignedInteger8"]
	]
	,
	(***************************************************************************
		UnicodeVersion
	***************************************************************************)
	LibraryFunctionDeclaration[
		"u_getUnicodeVersion_62",
		$ICULibraryPaths,
		{
			"UVersionInfo" (* versionArray *)
		} -> "Void"
		,
		"CBoxing" -> False
	]
	,
	FunctionDeclaration[
		ICULink`CC`UnicodeVersion,
		Typed[
			{} -> "PackedArray"::["MachineInteger", 1]
		] @
		Function[{},
			Module[{array, data, versionArray},
				(* TODO: Create versionArray on the stack instead *)
				array = Array`NewNumericArray[TypeSpecifier["UnsignedInteger8"], $UMAXVERSIONLENGTH];
				data = Array`GetData[array];
				versionArray = Cast[data, "UVersionInfo", "BitCast"];
				LibraryFunction["u_getUnicodeVersion_62"][versionArray];
				Array`ConvertArray[array, Compile`$ReturnType]
			]
		]
	]
	,
	(***************************************************************************
		ICUVersion
	***************************************************************************)
	LibraryFunctionDeclaration[
		"u_getVersion_62",
		$ICULibraryPaths,
		{
			"UVersionInfo" (* versionArray *)
		} -> "Void"
		,
		"CBoxing" -> False
	]
	,
	FunctionDeclaration[
		ICULink`CC`ICUVersion,
		Typed[
			{} -> "PackedArray"::["MachineInteger", 1]
		] @
		Function[{},
			Module[{array, data, versionArray},
				(* TODO: Create versionArray on the stack instead *)
				array = Array`NewNumericArray[TypeSpecifier["UnsignedInteger8"], $UMAXVERSIONLENGTH];
				data = Array`GetData[array];
				versionArray = Cast[data, "UVersionInfo", "BitCast"];
				LibraryFunction["u_getVersion_62"][versionArray];
				Array`ConvertArray[array, Compile`$ReturnType]
			]
		]
	]
};

];


$installedFuns = {
	ICULink`CC`UnicodeVersion
	,
	ICULink`CC`ICUVersion
};


DeclareCompiledComponent["ICULink", "Declarations" -> $declarations];

DeclareCompiledComponent["ICULink", "InstalledFunctions" -> $installedFuns];


End[];


EndPackage[];
