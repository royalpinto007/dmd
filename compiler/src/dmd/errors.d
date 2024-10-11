/**
 * Functions for raising errors.
 *
 * Copyright:   Copyright (C) 1999-2024 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/errors.d, _errors.d)
 * Documentation:  https://dlang.org/phobos/dmd_errors.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/errors.d
 */

module dmd.errors;

public import core.stdc.stdarg;
import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import dmd.errorsink;
import dmd.globals;
import dmd.location;
import dmd.common.outbuffer;
import dmd.root.rmem;
import dmd.root.string;
import dmd.console;

nothrow:

/// Constants used to discriminate kinds of error messages.
enum ErrorKind
{
    warning,
    deprecation,
    error,
    tip,
    message,
}

// Struct for SARIF Tool Information
struct ToolInformation {
    string name;
    string toolVersion;

    string toJson() nothrow {
        return `{"name": "` ~ name ~ `", "version": "` ~ toolVersion ~ `"}`;
    }
}

// Struct for SARIF Result
struct Result {
    string ruleId;  // Rule identifier
    string message;  // Error message
    PhysicalLocation location;  // Location where the error occurred

    string toJson() nothrow {
        return `{"ruleId": "` ~ ruleId ~ `", "message": "` ~ message ~ `", "location": ` ~ location.toJson() ~ `}`;
    }
}

// Struct for Physical Location of the Error
struct PhysicalLocation {
    string uri;  // File path (URI)
    int startLine;  // Line number where the error occurs
    int startColumn;  // Column number where the error occurs

    string toJson() nothrow {
        return `{"artifactLocation": {"uri": "` ~ uri ~ `"}, "region": {"startLine": ` ~ intToString(startLine) ~ `, "startColumn": ` ~ intToString(startColumn) ~ `}}`;
    }
}

// SARIF Report Struct
struct SarifReport {
    ToolInformation tool;  // Information about the tool
    Invocation invocation;  // Information about the execution
    Result[] results;  // List of results (errors, warnings, etc.)

    string toJson() nothrow {
        string resultsJson = "[" ~ results[0].toJson();
        foreach (result; results[1 .. $]) {
            resultsJson ~= ", " ~ result.toJson();
        }
        resultsJson ~= "]";

        return `{"tool": ` ~ tool.toJson() ~ `, "invocation": ` ~ invocation.toJson() ~ `, "results": ` ~ resultsJson ~ `}`;
    }
}

// Struct for Invocation Information
struct Invocation {
    bool executionSuccessful;

    string toJson() nothrow {
        return `{"executionSuccessful": ` ~ (executionSuccessful ? "true" : "false") ~ `}`;
    }
}

// Function to replace writeln with fprintf for printing to stdout
void printToStdout(string message) nothrow {
    fprintf(stdout, "%.*s\n", cast(int)message.length, message.ptr);  // Cast to int
}

void generateSarifReport(const ref Loc loc, const(char)* format, va_list ap, ErrorKind kind) nothrow
{
    string toolVersion = global.versionString();  // Retrieve dynamic version
    ToolInformation tool = ToolInformation("DMD", toolVersion);
    
    // Format the error message
    string formattedMessage = formatErrorMessage(format, ap);

    // Directly print the SARIF JSON structure to stdout
    fprintf(stdout, "{\n");

    // Write the invocation status
    fprintf(stdout, "  \"invocation\": {\n");
    fprintf(stdout, "    \"executionSuccessful\": false\n");
    fprintf(stdout, "  },\n");

    // Start the results array
    fprintf(stdout, "  \"results\": [\n    {\n");

    // Write location in SARIF format (artifactLocation + region)
    fprintf(stdout, "      \"location\": {\n");
    fprintf(stdout, "        \"artifactLocation\": {\n");
    fprintf(stdout, "          \"uri\": \"%s\"\n", loc.filename.toDString().ptr);
    fprintf(stdout, "        },\n");
    fprintf(stdout, "        \"region\": {\n");
    fprintf(stdout, "          \"startLine\": %d,\n", loc.linnum);
    fprintf(stdout, "          \"startColumn\": %d\n", loc.charnum);
    fprintf(stdout, "        }\n");
    fprintf(stdout, "      },\n");

    // Write message and ruleId
    fprintf(stdout, "      \"message\": \"%s\",\n", formattedMessage.ptr);
    fprintf(stdout, "      \"ruleId\": \"DMD\"\n");

    // Close results and array
    fprintf(stdout, "    }\n  ],\n");

    // Write tool information with the dynamic version
    fprintf(stdout, "  \"tool\": {\n");
    fprintf(stdout, "    \"name\": \"DMD\",\n");
    fprintf(stdout, "    \"version\": \"%s\"\n", toolVersion.ptr);
    fprintf(stdout, "  }\n");

    // Close JSON structure
    fprintf(stdout, "}\n");
}

// Helper function to format error messages
string formatErrorMessage(const(char)* format, va_list ap) nothrow
{
    char[2048] buffer;  // Increased buffer size to handle longer messages
    import core.stdc.stdio : vsnprintf;
    vsnprintf(buffer.ptr, buffer.length, format, ap);
    return buffer[0 .. buffer.length].dup;
}

// Function to convert int to string
string intToString(int value) nothrow {
    char[32] buffer;
    import core.stdc.stdio : sprintf;
    sprintf(buffer.ptr, "%d", value);
    return buffer[0 .. buffer.length].dup;
}

/***************************
 * Error message sink for D compiler.
 */
class ErrorSinkCompiler : ErrorSink
{
  nothrow:
  extern (C++):
  override:

    void error(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }

    void errorSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }

    void warning(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }

    void warningSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }

    void deprecation(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }

    void deprecationSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }

    void message(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.message);
        va_end(ap);
    }
}


/**
 * Color highlighting to classify messages
 */
enum Classification : Color
{
    error = Color.brightRed,          /// for errors
    gagged = Color.brightBlue,        /// for gagged errors
    warning = Color.brightYellow,     /// for warnings
    deprecation = Color.brightCyan,   /// for deprecations
    tip = Color.brightGreen,          /// for tip messages
}


static if (__VERSION__ < 2092)
    private extern (C++) void noop(const ref Loc loc, const(char)* format, ...) {}
else
    pragma(printf) private extern (C++) void noop(const ref Loc loc, const(char)* format, ...) {}


package auto previewErrorFunc(bool isDeprecated, FeatureState featureState) @safe @nogc pure nothrow
{
    with (FeatureState) final switch (featureState)
    {
        case enabled:
            return &error;

        case disabled:
            return &noop;

        case default_:
            return isDeprecated ? &noop : &deprecation;
    }
}

package auto previewSupplementalFunc(bool isDeprecated, FeatureState featureState) @safe @nogc pure nothrow
{
    with (FeatureState) final switch (featureState)
    {
        case enabled:
            return &errorSupplemental;

        case disabled:
            return &noop;

        case default_:
            return isDeprecated ? &noop : &deprecationSupplemental;
    }
}


/**
 * Print an error message, increasing the global error count.
 * Params:
 *      loc    = location of error
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void error(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void error(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }

/**
 * Same as above, but takes a filename and line information arguments as separate parameters.
 * Params:
 *      filename = source file of error
 *      linnum   = line in the source file
 *      charnum  = column number on the line
 *      format   = printf-style format specification
 *      ...      = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void error(const(char)* filename, uint linnum, uint charnum, const(char)* format, ...)
    {
        const loc = SourceLoc(filename.toDString, linnum, charnum);
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void error(const(char)* filename, uint linnum, uint charnum, const(char)* format, ...)
    {
        const loc = SourceLoc(filename.toDString, linnum, charnum);
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }

/// Callback for when the backend wants to report an error
extern(C++) void errorBackend(const(char)* filename, uint linnum, uint charnum, const(char)* format, ...)
{
    const loc = SourceLoc(filename.toDString, linnum, charnum);
    va_list ap;
    va_start(ap, format);
    verrorReport(loc, format, ap, ErrorKind.error);
    va_end(ap);
}

/**
 * Print additional details about an error message.
 * Doesn't increase the error count or print an additional error prefix.
 * Params:
 *      loc    = location of error
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void errorSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void errorSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.error);
        va_end(ap);
    }

/**
 * Print a warning message, increasing the global warning count.
 * Params:
 *      loc    = location of warning
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void warning(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void warning(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }

/**
 * Print additional details about a warning message.
 * Doesn't increase the warning count or print an additional warning prefix.
 * Params:
 *      loc    = location of warning
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void warningSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void warningSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.warning);
        va_end(ap);
    }

/**
 * Print a deprecation message, may increase the global warning or error count
 * depending on whether deprecations are ignored.
 * Params:
 *      loc    = location of deprecation
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void deprecation(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void deprecation(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }

/**
 * Print additional details about a deprecation message.
 * Doesn't increase the error count, or print an additional deprecation prefix.
 * Params:
 *      loc    = location of deprecation
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void deprecationSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void deprecationSupplemental(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReportSupplemental(loc, format, ap, ErrorKind.deprecation);
        va_end(ap);
    }

/**
 * Print a verbose message.
 * Doesn't prefix or highlight messages.
 * Params:
 *      loc    = location of message
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void message(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.message);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void message(const ref Loc loc, const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(loc, format, ap, ErrorKind.message);
        va_end(ap);
    }

/**
 * Same as above, but doesn't take a location argument.
 * Params:
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void message(const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(Loc.initial, format, ap, ErrorKind.message);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void message(const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(Loc.initial, format, ap, ErrorKind.message);
        va_end(ap);
    }

/**
 * The type of the diagnostic handler
 * see verrorReport for arguments
 * Returns: true if error handling is done, false to continue printing to stderr
 */
alias DiagnosticHandler = bool delegate(const ref Loc location, Color headerColor, const(char)* header, const(char)* messageFormat, va_list args, const(char)* prefix1, const(char)* prefix2);

/**
 * The diagnostic handler.
 * If non-null it will be called for every diagnostic message issued by the compiler.
 * If it returns false, the message will be printed to stderr as usual.
 */
__gshared DiagnosticHandler diagnosticHandler;

/**
 * Print a tip message with the prefix and highlighting.
 * Params:
 *      format = printf-style format specification
 *      ...    = printf-style variadic arguments
 */
static if (__VERSION__ < 2092)
    extern (C++) void tip(const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(Loc.initial, format, ap, ErrorKind.tip);
        va_end(ap);
    }
else
    pragma(printf) extern (C++) void tip(const(char)* format, ...)
    {
        va_list ap;
        va_start(ap, format);
        verrorReport(Loc.initial, format, ap, ErrorKind.tip);
        va_end(ap);
    }


// Encapsulates an error as described by its location, format message, and kind.
private struct ErrorInfo
{
    this(const ref SourceLoc loc, const ErrorKind kind, const(char)* p1 = null, const(char)* p2 = null) @safe @nogc pure nothrow
    {
        this.loc = loc;
        this.p1 = p1;
        this.p2 = p2;
        this.kind = kind;
    }

    const SourceLoc loc;              // location of error
    Classification headerColor; // color to set `header` output to
    const(char)* p1;            // additional message prefix
    const(char)* p2;            // additional message prefix
    const ErrorKind kind;       // kind of error being printed
    bool supplemental;          // true if supplemental error
}

/**
 * Implements $(D error), $(D warning), $(D deprecation), $(D message), and
 * $(D tip). Report a diagnostic error, taking a va_list parameter, and
 * optionally additional message prefixes. Whether the message gets printed
 * depends on runtime values of DiagnosticReporting and global gagging.
 * Params:
 *      loc         = location of error
 *      format      = printf-style format specification
 *      ap          = printf-style variadic arguments
 *      kind        = kind of error being printed
 *      p1          = additional message prefix
 *      p2          = additional message prefix
 */
extern (C++) void verrorReport(const Loc loc, const(char)* format, va_list ap, ErrorKind kind, const(char)* p1 = null, const(char)* p2 = null)
{
    return verrorReport(loc.SourceLoc, format, ap, kind, p1, p2);
}

/// ditto
extern (C++) void verrorReport(const SourceLoc loc, const(char)* format, va_list ap, ErrorKind kind, const(char)* p1 = null, const(char)* p2 = null)
{
    auto info = ErrorInfo(loc, kind, p1, p2);
    final switch (info.kind)
    {
    case ErrorKind.error:
        global.errors++;
        if (!global.gag)
        {
            info.headerColor = Classification.error;
            verrorPrint(format, ap, info);

            // Hook: Generate SARIF report only if the --sarif flag is set
            if (global.params.sarif)
            {
                generateSarifReport(info.loc, format, ap, info.kind);
            }
            if (global.params.v.errorLimit && global.errors >= global.params.v.errorLimit)
            {
                fprintf(stderr, "error limit (%d) reached, use `-verrors=0` to show all\n", global.params.v.errorLimit);
                fatal(); // moderate blizzard of cascading messages
            }
        }
        else
        {
            if (global.params.v.showGaggedErrors)
            {
                info.headerColor = Classification.gagged;
                verrorPrint(format, ap, info);
            }
            global.gaggedErrors++;
        }
        break;

    case ErrorKind.deprecation:
        if (global.params.useDeprecated == DiagnosticReporting.error)
            goto case ErrorKind.error;
        else if (global.params.useDeprecated == DiagnosticReporting.inform)
        {
            if (!global.gag)
            {
                global.deprecations++;
                if (global.params.v.errorLimit == 0 || global.deprecations <= global.params.v.errorLimit)
                {
                    info.headerColor = Classification.deprecation;
                    verrorPrint(format, ap, info);

                    // Hook: Generate SARIF report only if the --sarif flag is set
                    if (global.params.sarif)
                    {
                        generateSarifReport(info.loc, format, ap, info.kind);
                    }
                }
            }
            else
            {
                global.gaggedWarnings++;
            }
        }
        break;

    case ErrorKind.warning:
        if (global.params.warnings != DiagnosticReporting.off)
        {
            if (!global.gag)
            {
                info.headerColor = Classification.warning;
                verrorPrint(format, ap, info);

                // Hook: Generate SARIF report only if the --sarif flag is set
                if (global.params.sarif)
                {
                    generateSarifReport(info.loc, format, ap, info.kind);
                }

                if (global.params.warnings == DiagnosticReporting.error)
                    global.warnings++;
            }
            else
            {
                global.gaggedWarnings++;
            }
        }
        break;

    case ErrorKind.tip:
        if (!global.gag)
        {
            info.headerColor = Classification.tip;
            verrorPrint(format, ap, info);

            // Hook: Generate SARIF report only if the --sarif flag is set
            if (global.params.sarif)
            {
                generateSarifReport(info.loc, format, ap, info.kind);
            }
        }
        break;

    case ErrorKind.message:
        OutBuffer tmp;
        writeSourceLoc(tmp, info.loc, Loc.showColumns, Loc.messageStyle);
        if (tmp.length)
            fprintf(stdout, "%s: ", tmp.extractChars());

        tmp.reset();
        tmp.vprintf(format, ap);
        fputs(tmp.peekChars(), stdout);
        fputc('\n', stdout);
        fflush(stdout);     // ensure it gets written out in case of compiler aborts

        // Hook: Generate SARIF report only if the --sarif flag is set
        if (global.params.sarif)
        {
            generateSarifReport(info.loc, format, ap, info.kind);
        }
        break;
    }
}

/**
 * Implements $(D errorSupplemental), $(D warningSupplemental), and
 * $(D deprecationSupplemental). Report an addition diagnostic error, taking a
 * va_list parameter. Whether the message gets printed depends on runtime
 * values of DiagnosticReporting and global gagging.
 * Params:
 *      loc         = location of error
 *      format      = printf-style format specification
 *      ap          = printf-style variadic arguments
 *      kind        = kind of error being printed
 */
extern (C++) void verrorReportSupplemental(const ref Loc loc, const(char)* format, va_list ap, ErrorKind kind)
{
    return verrorReportSupplemental(loc.SourceLoc, format, ap, kind);
}

/// ditto
extern (C++) void verrorReportSupplemental(const SourceLoc loc, const(char)* format, va_list ap, ErrorKind kind)
{
    auto info = ErrorInfo(loc, kind);
    info.supplemental = true;
    switch (info.kind)
    {
    case ErrorKind.error:
        if (global.gag)
        {
            if (!global.params.v.showGaggedErrors)
                return;
            info.headerColor = Classification.gagged;
        }
        else
            info.headerColor = Classification.error;
        verrorPrint(format, ap, info);
        break;

    case ErrorKind.deprecation:
        if (global.params.useDeprecated == DiagnosticReporting.error)
            goto case ErrorKind.error;
        else if (global.params.useDeprecated == DiagnosticReporting.inform && !global.gag)
        {
            if (global.params.v.errorLimit == 0 || global.deprecations <= global.params.v.errorLimit)
            {
                info.headerColor = Classification.deprecation;
                verrorPrint(format, ap, info);
            }
        }
        break;

    case ErrorKind.warning:
        if (global.params.warnings != DiagnosticReporting.off && !global.gag)
        {
            info.headerColor = Classification.warning;
            verrorPrint(format, ap, info);
        }
        break;

    default:
        assert(false, "internal error: unhandled kind in error report");
    }
}

/**
 * Just print to stderr, doesn't care about gagging.
 * (format,ap) text within backticks gets syntax highlighted.
 * Params:
 *      format  = printf-style format specification
 *      ap      = printf-style variadic arguments
 *      info    = context of error
 */
private void verrorPrint(const(char)* format, va_list ap, ref ErrorInfo info)
{
    const(char)* header;    // title of error message
    if (info.supplemental)
        header = "       ";
    else
    {
        final switch (info.kind)
        {
            case ErrorKind.error:       header = "Error: "; break;
            case ErrorKind.deprecation: header = "Deprecation: "; break;
            case ErrorKind.warning:     header = "Warning: "; break;
            case ErrorKind.tip:         header = "  Tip: "; break;
            case ErrorKind.message:     assert(0);
        }
    }

    if (diagnosticHandler !is null)
    {
        Loc diagLoc;
        diagLoc.linnum = info.loc.line;
        diagLoc.charnum = info.loc.charnum;
        diagLoc.filename = (info.loc.filename ~ '\0').ptr;
        if (diagnosticHandler(diagLoc, info.headerColor, header, format, ap, info.p1, info.p2))
            return;
    }

    if (global.params.v.showGaggedErrors && global.gag)
        fprintf(stderr, "(spec:%d) ", global.gag);
    auto con = cast(Console) global.console;

    OutBuffer tmp;
    writeSourceLoc(tmp, info.loc, Loc.showColumns, Loc.messageStyle);
    const locString = tmp.extractSlice();
    if (con)
        con.setColorBright(true);
    if (locString.length)
    {
        fprintf(stderr, "%.*s: ", cast(int) locString.length, locString.ptr);
    }
    if (con)
        con.setColor(info.headerColor);
    fputs(header, stderr);
    if (con)
        con.resetColor();

    tmp.reset();
    if (info.p1)
    {
        tmp.writestring(info.p1);
        tmp.writestring(" ");
    }
    if (info.p2)
    {
        tmp.writestring(info.p2);
        tmp.writestring(" ");
    }
    tmp.vprintf(format, ap);

    if (con && strchr(tmp.peekChars(), '`'))
    {
        colorSyntaxHighlight(tmp);
        writeHighlights(con, tmp);
    }
    else
        fputs(tmp.peekChars(), stderr);
    fputc('\n', stderr);

    __gshared SourceLoc old_loc;
    auto loc = info.loc;
    if (global.params.v.printErrorContext &&
        // ignore supplemental messages with same loc
        (loc != old_loc || !info.supplemental) &&
        // ignore invalid files
        loc != SourceLoc.init &&
        // ignore mixins for now
        !loc.filename.startsWith(".d-mixin-") &&
        !global.params.mixinOut.doOutput)
    {
        import dmd.root.filename : FileName;
        const fileName = FileName(loc.filename);
        if (auto text = global.fileManager.getFileContents(fileName))
        {
            auto range = dmd.root.string.splitLines(cast(const(char[])) text);
            size_t linnum;
            foreach (line; range)
            {
                ++linnum;
                if (linnum != loc.linnum)
                    continue;
                if (loc.charnum < line.length)
                {
                    fprintf(stderr, "%.*s\n", cast(int)line.length, line.ptr);
                    // The number of column bytes and the number of display columns
                    // occupied by a character are not the same for non-ASCII charaters.
                    // https://issues.dlang.org/show_bug.cgi?id=21849
                    size_t col = 0;
                    while (col < loc.charnum - 1)
                    {
                        import dmd.root.utf : utf_decodeChar;
                        dchar u;
                        const msg = utf_decodeChar(line, col, u);
                        assert(msg is null, msg);
                        fputc(' ', stderr);
                    }
                    fputc('^', stderr);
                    fputc('\n', stderr);
                }
                break;
            }
        }
    }
    old_loc = loc;
    fflush(stderr);     // ensure it gets written out in case of compiler aborts
}

/**
 * The type of the fatal error handler
 * Returns: true if error handling is done, false to do exit(EXIT_FAILURE)
 */
alias FatalErrorHandler = bool delegate();

/**
 * The fatal error handler.
 * If non-null it will be called for every fatal() call issued by the compiler.
 */
__gshared FatalErrorHandler fatalErrorHandler;

/**
 * Call this after printing out fatal error messages to clean up and exit the
 * compiler. You can also set a fatalErrorHandler to override this behaviour.
 */
extern (C++) void fatal()
{
    if (fatalErrorHandler && fatalErrorHandler())
        return;

    exit(EXIT_FAILURE);
}

/**
 * Try to stop forgetting to remove the breakpoints from
 * release builds.
 */
extern (C++) void halt() @safe
{
    assert(0);
}

/**
 * Scan characters in `buf`. Assume text enclosed by `...`
 * is D source code, and color syntax highlight it.
 * Modify contents of `buf` with highlighted result.
 * Many parallels to ddoc.highlightText().
 * Params:
 *      buf = text containing `...` code to highlight
 */
private void colorSyntaxHighlight(ref OutBuffer buf)
{
    //printf("colorSyntaxHighlight('%.*s')\n", cast(int)buf.length, buf[].ptr);
    bool inBacktick = false;
    size_t iCodeStart = 0;
    size_t offset = 0;
    for (size_t i = offset; i < buf.length; ++i)
    {
        char c = buf[i];
        switch (c)
        {
            case '`':
                if (inBacktick)
                {
                    inBacktick = false;
                    OutBuffer codebuf;
                    codebuf.write(buf[iCodeStart .. i]);
                    codebuf.writeByte(0);
                    // escape the contents, but do not perform highlighting except for DDOC_PSYMBOL
                    colorHighlightCode(codebuf);
                    buf.remove(iCodeStart, i - iCodeStart);
                    immutable pre = "";
                    i = buf.insert(iCodeStart, pre);
                    i = buf.insert(i, codebuf[]);
                    break;
                }
                inBacktick = true;
                iCodeStart = i + 1;
                break;

            default:
                break;
        }
    }
}


/**
 * Embed these highlighting commands in the text stream.
 * HIGHLIGHT.Escape indicates a Color follows.
 */
enum HIGHLIGHT : ubyte
{
    Default    = Color.black,           // back to whatever the console is set at
    Escape     = '\xFF',                // highlight Color follows
    Identifier = Color.white,
    Keyword    = Color.white,
    Literal    = Color.white,
    Comment    = Color.darkGray,
    Other      = Color.cyan,           // other tokens
}

/**
 * Highlight code for CODE section.
 * Rewrite the contents of `buf` with embedded highlights.
 * Analogous to doc.highlightCode2()
 */

private void colorHighlightCode(ref OutBuffer buf)
{
    import dmd.lexer;
    import dmd.tokens;

    __gshared int nested;
    if (nested)
    {
        // Should never happen, but don't infinitely recurse if it does
        --nested;
        return;
    }
    ++nested;

    scope Lexer lex = new Lexer(null, cast(char*)buf[].ptr, 0, buf.length - 1, 0, 1, global.errorSinkNull, &global.compileEnv);
    OutBuffer res;
    const(char)* lastp = cast(char*)buf[].ptr;
    //printf("colorHighlightCode('%.*s')\n", cast(int)(buf.length - 1), buf[].ptr);
    res.reserve(buf.length);
    res.writeByte(HIGHLIGHT.Escape);
    res.writeByte(HIGHLIGHT.Other);
    while (1)
    {
        Token tok;
        lex.scan(&tok);
        res.writestring(lastp[0 .. tok.ptr - lastp]);
        HIGHLIGHT highlight;
        switch (tok.value)
        {
        case TOK.identifier:
            highlight = HIGHLIGHT.Identifier;
            break;
        case TOK.comment:
            highlight = HIGHLIGHT.Comment;
            break;
        case TOK.int32Literal:
            ..
        case TOK.dcharLiteral:
        case TOK.string_:
            highlight = HIGHLIGHT.Literal;
            break;
        default:
            if (tok.isKeyword())
                highlight = HIGHLIGHT.Keyword;
            break;
        }
        if (highlight != HIGHLIGHT.Default)
        {
            res.writeByte(HIGHLIGHT.Escape);
            res.writeByte(highlight);
            res.writestring(tok.ptr[0 .. lex.p - tok.ptr]);
            res.writeByte(HIGHLIGHT.Escape);
            res.writeByte(HIGHLIGHT.Other);
        }
        else
            res.writestring(tok.ptr[0 .. lex.p - tok.ptr]);
        if (tok.value == TOK.endOfFile)
            break;
        lastp = lex.p;
    }
    res.writeByte(HIGHLIGHT.Escape);
    res.writeByte(HIGHLIGHT.Default);
    //printf("res = '%.*s'\n", cast(int)buf.length, buf[].ptr);
    buf.setsize(0);
    buf.write(&res);
    --nested;
}

/**
 * Write the buffer contents with embedded highlights to stderr.
 * Params:
 *      buf = highlighted text
 */
private void writeHighlights(Console con, ref const OutBuffer buf)
{
    bool colors;
    scope (exit)
    {
        /* Do not mess up console if highlighting aborts
         */
        if (colors)
            con.resetColor();
    }

    for (size_t i = 0; i < buf.length; ++i)
    {
        const c = buf[i];
        if (c != HIGHLIGHT.Escape)
        {
            fputc(c, con.fp);
            continue;
        }

        const color = buf[++i];
        if (color == HIGHLIGHT.Default)
        {
            con.resetColor();
            colors = false;
        }
        else
        if (color == Color.white)
        {
            con.resetColor();
            con.setColorBright(true);
            colors = true;
        }
        else
        {
            con.setColor(cast(Color)color);
            colors = true;
        }
    }
}
