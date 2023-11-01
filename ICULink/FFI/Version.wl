(*
	See:
		- https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/uversion_8h.html
*)

BeginPackage["ICULink`FFI`Version`"];


Begin["`Private`"];


Needs["ICULink`FFI`Utilities`"];
Needs["ICULink`FFI`ICULibraryFunction`"];
Needs["ICULink`Debug`"];


(*
	#define U_MAX_VERSION_LENGTH   4
*)
ICUConstant["U_MAX_VERSION_LENGTH"] =
	4;


(*
	typedef uint8_t UVersionInfo[U_MAX_VERSION_LENGTH]
*)
ICUType["UVersionInfo"] =
	"RawPointer"::["UnsignedInteger8"];


(*******************************************************************************
	UnicodeVersion
*******************************************************************************)

(*
	U_CAPI void u_getUnicodeVersion(UVersionInfo versionArray)
		Gets the Unicode version information.
*)
ICULibraryFunctionLoad[
	"libicuuc",
	"u_getUnicodeVersion_62",
	{
		(* versionArray *) "UVersionInfo"
	},
	"Void"
];

ICULink`FFI`UnicodeVersion[] :=
	With[{versionArray = RawMemoryAllocate["UnsignedInteger8", ICUConstant["U_MAX_VERSION_LENGTH"]]},
		ICULibraryFunction["u_getUnicodeVersion_62"][versionArray];
		RawMemoryImport[versionArray, {"List", ICUConstant["U_MAX_VERSION_LENGTH"]}]
	];


(*
	typedef uint8_t UVersionInfo[U_MAX_VERSION_LENGTH]
*)
ICUType["UVersionInfo"] =
	"RawPointer"::["UnsignedInteger8"];


(*******************************************************************************
	ICUVersion
*******************************************************************************)

(*
	U_CAPI void u_getVersion(UVersionInfo versionArray)
		Gets the ICU release version.
*)
ICULibraryFunctionLoad[
	"libicuuc",
	"u_getVersion_62",
	{
		(* versionArray *) "UVersionInfo"
	},
	"Void"
];

ICULink`FFI`ICUVersion[] :=
	With[{versionArray = RawMemoryAllocate["UnsignedInteger8", ICUConstant["U_MAX_VERSION_LENGTH"]]},
		ICULibraryFunction["u_getVersion_62"][versionArray];
		RawMemoryImport[versionArray, {"List", ICUConstant["U_MAX_VERSION_LENGTH"]}]
	];


End[];


EndPackage[];
