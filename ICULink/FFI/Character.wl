(*
	See:
		- https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/uchar_8h.html
*)

BeginPackage["ICULink`FFI`Character`"];


Begin["`Private`"];


Needs["ICULink`FFI`Utilities`"];
Needs["ICULink`FFI`ICULibraryFunction`"];
Needs["ICULink`Debug`"];


ICUEnum["UCharNameChoice", All] := <|
	"U_UNICODE_CHAR_NAME" -> 0,
	"U_EXTENDED_CHAR_NAME" -> 1,
	"U_CHAR_NAME_ALIAS" -> 2
|>;


(*******************************************************************************
	CharacterName
*******************************************************************************)

(*
	U_CAPI int32_t	u_charName (UChar32 code, UCharNameChoice nameChoice, char *buffer, int32_t bufferLength, UErrorCode *pErrorCode)
 		Retrieve the name of a Unicode character.
*)
ICULibraryFunctionLoad[
	"libicuuc",
	"u_charName_62",
	{
		(* code         *) "UChar32",
		(* nameChoice   *) ICUEnum["UCharNameChoice"],
		(* buffer       *) "RawPointer"::["CUnsignedChar"],
		(* bufferLength *) "Integer32",
		(* pErrorCode   *) "RawPointer"::[ICUEnum["UErrorCode"]]
	},
	(* nameLength *)       "Integer32"
];

$charNameBufferLength = 128;

$charNameBuffer = RawMemoryAllocate["CUnsignedChar", $charNameBufferLength];

$pErrorCode = RawMemoryAllocate[ICUType[ICUEnum["UErrorCode"]]];

ICULink`FFI`CharacterName[code_Integer] :=
	Module[{nameLength, errorCode},

		RawMemoryWrite[$pErrorCode, ICUEnum["UErrorCode", "U_ZERO_ERROR"]];

		nameLength = ICULibraryFunction["u_charName_62"][code, 0, $charNameBuffer, $charNameBufferLength, $pErrorCode];

		errorCode = RawMemoryRead[$pErrorCode];
		If[ICUFailureQ[errorCode],
			DebugPrint["CharacterName: ICULibraryFunction[\"u_charName_62\"] failed with the error code ", errorCode, "."];
			Return[$Failed]
		];

		If[nameLength === 0,
			""
			,
			RawMemoryImport[$charNameBuffer, {"String", nameLength}]
		]
	];


(*******************************************************************************
	ICUCharacterAge
*******************************************************************************)

(*
	U_CAPI void u_charAge (UChar32 c, UVersionInfo versionArray)
		Get the "age" of the code point.
*)
ICULibraryFunctionLoad[
	"libicuuc",
	"u_charAge_62",
	{
		(* code         *) "UChar32",
		(* versionArray *) "UVersionInfo"
	},
	"Void"
];

ICULink`FFI`CharacterAge[code_Integer] :=
	With[{versionArray = RawMemoryAllocate["UnsignedInteger8", ICUConstant["U_MAX_VERSION_LENGTH"]]},
		ICULibraryFunction["u_charAge_62"][code, versionArray];
		RawMemoryImport[versionArray, {"List", ICUConstant["U_MAX_VERSION_LENGTH"]}]
	];


End[];


EndPackage[];
