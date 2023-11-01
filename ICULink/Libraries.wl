BeginPackage["ICULink`Libraries`"];


$ICULibraryNamesMap;

ICUFindLibraries;

$ICULibraryNames

$ICULibraryPaths;

$ICULibrariesLoadedQ;

ICULoadLibraries;


Begin["`Private`"];


Needs["ICULink`Debug`"];


$ICULibraryNamesMap = <|
	"Linux-x86-64" -> {"libICU.so", "libICU_c.so"},
	"Windows-x86-64" -> {"ICU.dll", "ICU_c.dll"},
	"MacOSX-x86-64" -> {"libicudata", "libicuuc", "libicui18n", "libicuio", "libicutu"},
	"MacOSX-ARM64" -> {"libicudata", "libicuuc", "libicui18n", "libicuio", "libicutu"}
|>;


ICUFindLibraries[] :=
	Module[{libNames, libs},
		libNames = $ICULibraryNamesMap[$SystemID];
		If[MissingQ[libNames],
			Return @ Failure["ICULinkFailure",
				<|
					"MessageTemplate" -> "The computer system `1` is not supported.",
					"MessageParameters" -> {$SystemID},
					"$SystemID" -> $SystemID
				|>
			]
		];

		libs = <||>;
		Do[
			With[{libPath = FindLibrary[libName]},
				If[!FileExistsQ[libPath],
					Return @ Failure["ICULinkFailure",
						<|
							"MessageTemplate" -> "Cannot find the library `1`.",
							"MessageParameters" -> {libName},
							"LibraryName" -> libName
						|>
					]
				];
				libs[libName] = libPath;
			],
			{libName, libNames}
		];

		ICUFindLibraries[] = libs
	];


$ICULibraryNames :=
	ICUFindLibraries[] // If[AssociationQ[#], Keys[#], #] &;


$ICULibraryPaths :=
	ICUFindLibraries[] // If[AssociationQ[#], Values[#], #] &;


If[!BooleanQ[$ICULibrariesLoadedQ],
	$ICULibrariesLoadedQ = False;
];


ICULoadLibraries[] :=
	Module[{libs, initTime, endTime},
		libs = ICUFindLibraries[];
		If[FailureQ[libs],
			Return @ libs
		];

		initTime = AbsoluteTime[];
		If[!TrueQ[$ICULibrariesLoadedQ],
			KeyValueMap[
				Function[{libName, libPath},
					With[{load = LibraryLoad[libPath]},
						If[load === $Failed,
							Return @ Failure["ICULinkFailure",
								<|
									"MessageTemplate" -> "Failed to load the library `1` (`2`).",
									"MessageParameters" -> {libName, libPath},
									"LibraryName" -> libName,
									"LibraryPath" -> libPath
								|>
							]
						];
						DebugPrint["ICULoadLibraries: Successfully loaded ", libPath];
					]
				],
				libs
			];
			$ICULibrariesLoadedQ = True
		];
		endTime = AbsoluteTime[];

		Success["ICULinkSuccess",
			<|
				"MessageTemplate" -> "Successfully loaded ICU libraries.",
				"Timing" -> endTime - initTime,
				"Libraries" -> libs
			|>
		]
	];


End[];


EndPackage[];
