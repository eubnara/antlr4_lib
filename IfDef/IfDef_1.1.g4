grammar IfDef;


//parser rule

blockList
: block*
;
block
: zeroIfSetList
| simpleIfSetList
| zeroIf
| simpleIf
| else
| elif
| endif
| Whitespace
| unknown
;

zeroIfSetList
: zeroIfSet
| zeroIfSet zeroIfSetList
;

zeroIfSet
: zeroIf else? endif
| zeroIf (simpleIfSet|zeroIfSet)+ (endIf|else)
; 

simpleIfSetList
: simpleIfSet
| simpleIfSet simpleIfSetList
;

simpleIfSet
: simpleIf endIf
| simpleIf else endIf
| simpleIf (simpleIfSet|zeroIfSet)+ endIf
;

zeroIf
: ZeroIf
;

simpleIf
: SimpleIf
;

elif
: Elif
;

else
: Else
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

Elif : '#' Whitespace? 'elif' Whitespace? Newline
| '#' Whitespace? 'elif' EOF
;

Else : '#' Whitespace? 'else' Whitespace? Newline 
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
