(*
	See:
		- https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/utypes_8h.html
		- https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/umachine_8h.html
*)

BeginPackage["ICULink`FFI`Utilities`"];


ICUConstant;

ICUType;

ICUEnum;

ICUSuccessQ;

ICUFailureQ;


Begin["`Private`"];


ICUConstant["FALSE"] =
	0;

ICUConstant["TRUE"] =
	1;


ICUType["UBool"] =
	"Integer8";

ICUType["UChar32"] =
	"Integer32";

ICUType[ICUEnum[_]] :=
	"CInt";

ICUType[ty_] :=
	ty;


ICUEnum["UErrorCode", All] = <|
	"U_ZERO_ERROR" -> 0,
	"U_ILLEGAL_ARGUMENT_ERROR" -> 1,
	"U_MISSING_RESOURCE_ERROR" -> 2,
	"U_INVALID_FORMAT_ERROR" -> 3,
	"U_FILE_ACCESS_ERROR" -> 4,
	"U_INTERNAL_PROGRAM_ERROR" -> 5,
	"U_MESSAGE_PARSE_ERROR" -> 6,
	"U_MEMORY_ALLOCATION_ERROR" -> 7,
	"U_INDEX_OUTOFBOUNDS_ERROR" -> 8,
	"U_PARSE_ERROR" -> 9,
	"U_INVALID_CHAR_FOUND" -> 10,
	"U_TRUNCATED_CHAR_FOUND" -> 11,
	"U_ILLEGAL_CHAR_FOUND" -> 12,
	"U_INVALID_TABLE_FORMAT" -> 13,
	"U_INVALID_TABLE_FILE" -> 14,
	"U_BUFFER_OVERFLOW_ERROR" -> 15,
	"U_UNSUPPORTED_ERROR" -> 16,
	"U_RESOURCE_TYPE_MISMATCH" -> 17,
	"U_ILLEGAL_ESCAPE_SEQUENCE" -> 18,
	"U_UNSUPPORTED_ESCAPE_SEQUENCE" -> 19,
	"U_NO_SPACE_AVAILABLE" -> 20,
	"U_CE_NOT_FOUND_ERROR" -> 21,
	"U_PRIMARY_TOO_LONG_ERROR" -> 22,
	"U_STATE_TOO_OLD_ERROR" -> 23,
	"U_TOO_MANY_ALIASES_ERROR" -> 24,
	"U_ENUM_OUT_OF_SYNC_ERROR" -> 25,
	"U_INVARIANT_CONVERSION_ERROR" -> 26,
	"U_INVALID_STATE_ERROR" -> 27,
	"U_COLLATOR_VERSION_MISMATCH" -> 28,
	"U_USELESS_COLLATOR_ERROR" -> 29,
	"U_NO_WRITE_PERMISSION" -> 30,
	"U_INPUT_TOO_LONG_ERROR" -> 31
|>;

ICUEnum[enum_, field_] :=
	Lookup[ICUEnum[enum, All], field];


ICUSuccessQ[x_] :=
	x <= ICUEnum["UErrorCode", "U_ZERO_ERROR"];


ICUFailureQ[x_] :=
	x > ICUEnum["UErrorCode", "U_ZERO_ERROR"];


End[];


EndPackage[];
