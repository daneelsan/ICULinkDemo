# Demo for the ICULink paclet

This demo corresponds to a [WTC23](https://wtc.wolfram.com/series/wtc-home/) talk which discussed ways in which to call external libraries using 2 approaches: the Foreign Function Interface and the Wolfram Compiler.

## FFI

To use the FFI section of this demo, simply do:

Load the paclet directory:
```Mathematica
PacletDirectoryLoad["~/path/to/ICULink"];
```

Do a `Needs` of the paclet:
```Mathematica
Needs["ICULink`"]
```

Call a function defined in ``ICULink`FFI``:
```Mathematica
In[]:= ICULink`FFI`UnicodeVersion[]
Out[]= {11, 0, 0, 0}
```

## Compiled Component

### Build the ICULink compiled component

Run the script:
```Mathematica
./scripts/build.wls
```

The generated library should be stored in (depending on your OS):
```shell
$ ls ICULink/LibraryResources/MacOSX-ARM64/
ICULink.dylib*
```

### Load the ICULink compiled component

Load the paclet directory:
```Mathematica
PacletDirectoryLoad["~/path/to/ICULink"];
```

Do a `Needs` of the paclet:
```Mathematica
Needs["ICULink`"]
```

Call any of the functions defined in ``ICULink`CC`` and the compiled component should be autoloaded:
```Mathematica
In[]:= ICULink`CC`UnicodeVersion[]
Out[]= {11, 0, 0, 0}
```
