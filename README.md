
# Tool to generate c++ code for case conversions

This tool uses tables obtained at https://unicode.org/

The conversion procedures are simplified.
Most notable omissions:
- contextual or locale dependent conversions
- case folding

The result of these simplifications is that the generated code is well portable and has no external dependencies.

The generated code works with unicode code points.
Other encodings (eg. utf8) has to be converted to utf32, processed and converted back.

