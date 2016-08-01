grammar IfDef;


//parser rule

blockList
: block*
;

block
: zeroIf
| elseIf
| endIf
| simpleIf
| Whitespace
| unknown
;


zeroIf
: ZeroIf
;

simpleIf
: SimpleIf
;

elseIf
: ElseIf
;

endIf
: EndIf
;


unknown
: Unknown
;

//lexer rule

ZeroIf : '#' Whitespace? 'if' Whitespace [0] Whitespace? Newline+ 
| '#' Whitespace? 'if' Whitespace [0] EOF
;
ElseIf : '#' Whitespace? 'else' Whitespace? Newline 
| '#' Whitespace? 'else' EOF
;
EndIf : '#' Whitespace? 'endif' Whitespace? Newline 
| '#' Whitespace? 'endif' EOF
;
SimpleIf : '#' Whitespace? 'if' Whitespace
| '#' Whitespace* 'if' Whitespace? Newline+
| '#' Whitespace* 'if' EOF
| '#' Whitespace* 'ifdef' Whitespace 
| '#' Whitespace* 'ifdef' Whitespace? Newline+
;
Whitespace : [ \t]+ -> skip;
Newline : ( '\r' '\n'? | '\n' ) -> skip;
BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;
LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;
Unknown :  . -> skip ;