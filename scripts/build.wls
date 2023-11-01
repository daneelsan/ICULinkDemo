#! /usr/bin/env wolframscript

Print["Mathematica build : ", {$Version, Internal`$LayoutCreationID}];

$BASEDIR = ParentDirectory[DirectoryName[$InputFileName], 1];
Print["Base directory:", $BASEDIR];

$PACLETDIR = FileNameJoin[{$BASEDIR, "ICULink"}];
Print["ICULink paclet directory: ", $PACLETDIR];

PacletDirectoryLoad[$PACLETDIR];

Needs["ICULink`"]

result = BuildCompiledComponent[
	"ICULink",
	PacletObject["ICULink"],
	CompilerOptions -> {
		"CreateLibraryOptions" -> {
			"ShellCommandFunction" -> Print,
			"ShellOutputFunction" -> Print
		}
	}
];

If[FailureQ[result],
	Print["Failed to build the compiled component: ", result];
	Exit[1]
];

Print["Succesfully build the compiled component: ", result];
Exit[0]
