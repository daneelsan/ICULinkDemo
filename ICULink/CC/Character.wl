BeginPackage["ICULink`CC`Character`"];


Begin["`Private`"];


Needs["ICULink`Libraries`"];


With[{
	$UMAXVERSIONLENGTH = 4,
	$UZEROERROR = Typed[0, "UErrorCode"]
},

$declarations = {
	TypeDeclaration["Macro", "UChar", "UnsignedInteger16"]
	,
	TypeDeclaration["Macro", "UChar32", "Integer32"]
	,

	(* ENUM *)
	TypeDeclaration["Macro", "UCharNameChoice", "CInt"],

	(* ENUM *)
	TypeDeclaration["Macro", "UErrorCode", "CInt"],

	(* ENUM *)
	TypeDeclaration["Macro", "UProperty", "CInt"],
	TypeDeclaration["Macro", "UPropertyNameChoice", "CInt"],

	LibraryFunctionDeclaration[
		"u_charName_62",
		$ICULibraryPaths,
		{
			"UChar32", (* code *)
			"UCharNameChoice", (* nameChoice *)
			"CString", (* buffer *)
			"Integer32", (* bufferLength *)
			"RawPointer"::["UErrorCode"] (* pErrorCode *)
		} -> "Integer32"
		,
		"CBoxing" -> False
	],

	LibraryFunctionDeclaration[
		"u_charAge_62",
		$ICULibraryPaths,
		{
			"UChar32", (* code *)
			"UVersionInfo" (* versionArray *)
		} -> "Void"
		,
		"CBoxing" -> False
	],

	LibraryFunctionDeclaration[
		"u_getIntPropertyValue_62",
		$ICULibraryPaths,
		{
			"UChar32", (* code *)
			"UProperty" (* property *)
		} -> "Integer32"
		,
		"CBoxing" -> False
	],

	LibraryFunctionDeclaration[
		"u_getPropertyValueName_62",
		$ICULibraryPaths,
		{
			"UProperty", (* property *)
			"Integer32", (* value *)
			"UPropertyNameChoice" (* nameChoice *)
		} -> "CString"
		,
		"CBoxing" -> False
	],

	(***************************************************************************
	ICUCharacterName, ICUCharacterNameAlias
	***************************************************************************)
	FunctionDeclaration[
		ICULink`CC`CharacterName,
		Typed[
			{"UChar32"} -> "String"
		] @
		Function[{code},
			iICUCharacterName[code, Typed[0, "UCharNameChoice"]]
		],
		"Inline" -> "Hint"
	],
	FunctionDeclaration[
		ICULink`CC`CharacterNameAlias,
		Typed[
			{"UChar32"} -> "String"
		] @
		Function[{code},
			iICUCharacterName[code, Typed[3, "UCharNameChoice"]]
		],
		"Inline" -> "Hint"
	],
	FunctionDeclaration[
		iICUCharacterName,
		Typed[
			{"UChar32", "UCharNameChoice"} -> "String"
		] @
		Function[{code, nameChoice},
			Module[{bufferLength, buffer, pErrorCode, nameLength, name},
				bufferLength = Typed[128, "Integer32"];
				(* TODO: Create the buffer on the stack to avoid unnecessary runtime allocations *)
				buffer = CreateTypeInstance["CString", bufferLength];
				pErrorCode = ToRawPointer[$UZEROERROR];
				nameLength = LibraryFunction["u_charName_62"][code, nameChoice, buffer, bufferLength, pErrorCode];
				(* TODO: Make this a Failure predicate *)
				If[FromRawPointer[pErrorCode] > $UZEROERROR,
					(* TODO: Add all LibraryLink errors to WolframExceptionCode *)
					Native`ThrowWolframExceptionCode["Unknown"]
				];
				(* TODO: Is there a way to get rid of the Cast? *)
				name = CreateTypeInstance["String", buffer, Cast[nameLength, "MachineInteger"]];
				DeleteObject[buffer];
				name
			]
		]
	],

	(***************************************************************************
	ICUCharacterAge
	***************************************************************************)
	FunctionDeclaration[
		ICULink`CC`CharacterAge,
		Typed[
			{"UChar32"} -> "PackedArray"::["MachineInteger", 1]
		] @
		Function[{code},
			Module[{array, data, versionArray},
				(* TODO: Create versionArray on the stack instead *)
				array = Array`NewNumericArray[TypeSpecifier["UnsignedInteger8"], $UMAXVERSIONLENGTH];
				data = Array`GetData[array];
				versionArray = Native`BitCast[data, "UVersionInfo"];
				LibraryFunction["u_charAge_62"][code, versionArray];
				Array`ConvertArray[array, Compile`$ReturnType]
			]
		]
	],

	(***************************************************************************
	ICUCharacterPropertyValueName
	***************************************************************************)
	FunctionDeclaration[
		ICULink`CC`CharacterPropertyValueName,
		Typed[
			{"UChar32", "UProperty", "UPropertyNameChoice"} -> "String"
		] @
		Function[{code, prop, nameChoice},
			Module[{val, valName},
				val = LibraryFunction["u_getIntPropertyValue_62"][code, prop];
				valName = LibraryFunction["u_getPropertyValueName_62"][prop, val, nameChoice];
				If[Native`NullQ[valName],
					(* TODO: Add all LibraryLink errors to WolframExceptionCode *)
					Native`ThrowWolframExceptionCode["Unknown"]
				];
				CreateTypeInstance["String", valName]
			]
		]
	]
}
];


$installedFuns = {
	ICULink`CC`CharacterName,
	ICULink`CC`CharacterNameAlias,
	ICULink`CC`CharacterAge,
	ICULink`CC`CharacterPropertyValueName
};


DeclareCompiledComponent["ICULink", "Declarations" -> $declarations];

DeclareCompiledComponent["ICULink", "InstalledFunctions" -> $installedFuns];


End[];


EndPackage[];
