/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
        return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
        filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
        return filename;
    }

    int stringIndex = 0;
    int IdIndex = 0;
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
        /* nothing special to do in the initial state */
        break;
     case YYCOMMENT:
          System.err.println("EOF in comment");
          break;
     case YYSTRING:
          System.err.println("EOF in string constant");
          break;
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup
%state YYCOMMENT,YYSTRING,YYSTRING_NEWLINE_ERR,YYSTRING_NULL_ERR

DIGIT        = [0-9]
WHITESPACE   = [ \t\v\r\f]
NEWLINE      = \n
LINECOMMENT  = --[^\n]*
COMMENTBEGIN = \(\*
COMMENTEND   = \*\)
STRINGBEGIN  = \"
STRINGCHARS  = [^\"\0\n\t\b\f\\]+
STRINGEND    = \"
TYPEID       = [A-Z][A-z0-9_]*
OBJECTID     = [a-z][A-z0-9_]*
CLASS        = [Cc][Ll][Aa][Ss][Ss]
ELSE         = [Ee][Ll][Ss][Ee]
IF           = [Ii][Ff]
FI           = [Ff][Ii]
IN           = [Ii][Nn]
INHERITS     = [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]
ISVOID       = [Ii][Ss][Vv][Oo][Ii][Dd]
LET          = [Ll][Ee][Tt]
LOOP         = [Ll][Oo][Oo][Pp]
POOL         = [Pp][Oo][Oo][Ll]
THEN         = [Tt][Hh][Ee][Nn]
WHILE        = [Ww][Hh][Ii][Ll][Ee]
CASE         = [Cc][Aa][Ss][Ee]
ESAC         = [Ee][Ss][Aa][Cc]
NEW          = [Nn][Ee][Ww]
OF           = [Oo][Ff]
NOT          = [Nn][Oo][Tt]
TRUE         = t[Rr][Uu][Ee]
FALSE        = f[Aa][Ll][Ss][Ee]
AT           = @
ANYCHAR      = .
ESCAPED      =(\\\\n)|\[tfb]

%%

<YYINITIAL>{COMMENTBEGIN}                  { yybegin(YYCOMMENT); }
<YYCOMMENT>{COMMENTEND}                    { yybegin(YYINITIAL); }
<YYINITIAL>{COMMENTEND}                    { System.err.println("Unmatched *)"); }
<YYCOMMENT>{ANYCHAR}                       { ; }
<YYINITIAL>{WHITESPACE}                    { ; }
<YYINITIAL>{LINECOMMENT}                   { ; }
<YYINITIAL>{ELSE}                          { return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>{IF}                            { return new Symbol(TokenConstants.IF); }
<YYINITIAL>{FI}                            { return new Symbol(TokenConstants.FI); }
<YYINITIAL>{IN}                            { return new Symbol(TokenConstants.IN); }
<YYINITIAL>{INHERITS}                      { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>{ISVOID}                        { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>{LET}                           { return new Symbol(TokenConstants.LET); }
<YYINITIAL>{LOOP}                          { return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>{POOL}                          { return new Symbol(TokenConstants.POOL); }
<YYINITIAL>{THEN}                          { return new Symbol(TokenConstants.THEN); }
<YYINITIAL>{WHILE}                         { return new Symbol(TokenConstants.WHILE); }
<YYINITIAL>{CASE}                          { return new Symbol(TokenConstants.CASE); }
<YYINITIAL>{ESAC}                          { return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>{NEW}                           { return new Symbol(TokenConstants.NEW); }
<YYINITIAL>{OF}                            { return new Symbol(TokenConstants.OF); }
<YYINITIAL>{NOT}                           { return new Symbol(TokenConstants.NOT); }
<YYINITIAL>{CLASS}                         { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>{TRUE}                          { return new Symbol(TokenConstants.BOOL_CONST, "true"); }
<YYINITIAL>{FALSE}                         { return new Symbol(TokenConstants.BOOL_CONST, "false"); }

<YYINITIAL>\*                              { return new Symbol(TokenConstants.MULT); }
<YYINITIAL>\.                              { return new Symbol(TokenConstants.DOT); }
<YYINITIAL>;                               { return new Symbol(TokenConstants.SEMI); }
<YYINITIAL>\/                              { return new Symbol(TokenConstants.DIV); }
<YYINITIAL>\+                              { return new Symbol(TokenConstants.PLUS); }

<YYINITIAL>-                               { return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>~                               { return new Symbol(TokenConstants.NEG); }
<YYINITIAL>\(                              { return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>\)                              { return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>\<                              { return new Symbol(TokenConstants.LT); }
<YYINITIAL><=                              { return new Symbol(TokenConstants.LE); }
<YYINITIAL>,                               { return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>=                               { return new Symbol(TokenConstants.EQ); }
<YYINITIAL><-                              { return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL>\:                              { return new Symbol(TokenConstants.COLON); }
<YYINITIAL>\{                              { return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL>\}                              { return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>@                               { return new Symbol(TokenConstants.AT); }

<YYINITIAL>{TYPEID}                        { return new Symbol(TokenConstants.TYPEID,
                                                 new IdSymbol(yytext(), yytext().length(), IdIndex++)); }
<YYINITIAL>{OBJECTID}                      { return new Symbol(TokenConstants.OBJECTID,
                                                 new IdSymbol(yytext(), yytext().length(), IdIndex++)); }

<YYINITIAL>{STRINGBEGIN}                  { string_buf.setLength(0); yybegin(YYSTRING); }
<YYSTRING>\n                              { System.err.println("Unterminated string constant");
                                               yybegin(YYSTRING_NEWLINE_ERR); }
<YYSTRING>\0                                      { System.err.println("String contains null character");
                                              yybegin(YYSTRING_NULL_ERR); }
<YYSTRING>{STRINGCHARS}                           { string_buf.append(yytext()); }
<YYSTRING>\\t                                     { string_buf.append('\t'); }
<YYSTRING>\\n                                     { string_buf.append('\n'); }
<YYSTRING>\\\"                                    { string_buf.append('\"'); }
<YYSTRING>\\                                      { string_buf.append('\\'); }
<YYSTRING>{STRINGEND}                             { yybegin(YYINITIAL);
                                                       return new Symbol(TokenConstants.STR_CONST,
                                                           new StringSymbol(string_buf.toString(), string_buf.length(), stringIndex++)); }
<YYSTRING_NULL_ERR>\"                     { yybegin(YYINITIAL); }
<YYSTRING_NEWLINE_ERR>\n                  { yybegin(YYINITIAL); curr_lineno++;}
\n                                        { curr_lineno++; }

<YYINITIAL>{DIGIT}+                       { return new Symbol(TokenConstants.INT_CONST,
                                               new IntSymbol(yytext(), yytext().length(), Integer.parseInt(yytext()))); }
<YYINITIAL>"=>"                           { return new Symbol(TokenConstants.DARROW); }


<YYINITIAL>error                          { return new Symbol(TokenConstants.error); }

.                                         { return new Symbol(TokenConstants.ERROR, yytext()); }
