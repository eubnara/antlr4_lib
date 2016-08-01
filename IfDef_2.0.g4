grammar IfDef;


//parser rule

blockList
: block*
;
//endif, else, elif 는 항상 if ifdef 등과 짝이 맞아야 한다.
//컴파일이 잘 되는 파일이라는 가정하에 텍스트 분석(정적 분석)을 한다.
// 따라서, 다음 'block' rule 에서는 endif, else, elif 는 simpleIfSet 이나 zeroIfSet // 에 포함되고
// simpleIfSet과 zeroIfSet은 각각의 setList에 포함되므로 제거하였다.
block
: zeroIfSetList
| simpleIfSetList
| Whitespace
| unknown
;

zeroIfSetList
: zeroIfSet
| zeroIfSet zeroIfSetList
;

//elif는 여러 번 나올 수 있지만, else는 한 if set에 여러 번 나올 수 없다.
zeroIfSet
:  zeroIf elif* else? endIf
| zeroIf (simpleIfSetList | zeroIfSetList)? elifList? else? (simpleIfSetList | zeroIfSetList)? endIf
; 

simpleIfSetList
: simpleIfSet
| simpleIfSet simpleIfSetList
;

simpleIfSet
:  simpleIf elif* else? endIf
| simpleIf (simpleIfSetList | zeroIfSetList)? elifList? else? (simpleIfSetList | zeroIfSetList)? endIf
;

elifList
: elif
| elif simpleIfSet* zeroIfSet*
| elif elifList
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


//cf. #if 만 한줄에 써있고 newline 으로 처리된다면, #if 0 와 같은 효과이다.
//#if
//#if 0
//따라서, [0] 이 아니라, [0]? 으로 표현하였다.
ZeroIf : '#' Whitespace? 'if' Whitespace [0]? Whitespace? Newline+ 
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