/*
#if
#elif
#else
#endif
처리 완료

#ifdef
#ifndef
미처리

ver 3.0
*/


grammar IfDef;


//parser rule

blockList
: block+
;
//endif, elseDef, elifDef 는 항상 if ifdef 등과 짝이 맞아야 한다.
//컴파일이 잘 되는 파일이라는 가정하에 텍스트 분석(정적 분석)을 한다.
// 따라서, 다음 'block' rule 에서는 endif, elseDef, elifDef 는 simpleIfDefSet 이나 zeroIfDefSet // 에 포함되고
// simpleIfDefSet과 zeroIfDefSet은 각각의 setList에 포함되므로 제거하였다.
block
: zeroIfDefSetList
| simpleIfDefSetList
| Whitespace
| unknown
;

zeroIfDefSetList
: zeroIfDefSet
| zeroIfDefSet zeroIfDefSetList
;

//elifDef는 여러 번 나올 수 있지만, elseDef는 한 if set에 여러 번 나올 수 없다.
//(simpleIfDefSetList | zeroIfDefSetList)? --> (simpleIfDefSetList | zeroIfDefSetList)* 
// simpleDefSetList 와 zeroIfDefSetList가 같이 있는 경우 묶어주기 위해서
zeroIfDefSet
:  zeroIfDef elifDef* elseDef? endIf
| zeroIfDef elifDefList? (simpleIfDefSetList | zeroIfDefSetList)* elifDefList? elseDef? (simpleIfDefSetList| zeroIfDefSetList)* endIf
; 

simpleIfDefSetList
: simpleIfDefSet
| simpleIfDefSet simpleIfDefSetList
;

//(simpleIfDefSetList | zeroIfDefSetList)? --> (simpleIfDefSetList | zeroIfDefSetList)*
//설명은 zeorIfDefSet와 동일
simpleIfDefSet
:  simpleIfDef elifDef* elseDef? endIf
| simpleIfDef elifDefList? (simpleIfDefSetList| zeroIfDefSetList)* elifDefList? elseDef? (simpleIfDefSetList| zeroIfDefSetList)? endIf
;

//elifDef simpleIfDefSet* zeroIfDefSet*  --> elifDef (simpleIfDefSet | zeroIfDefSet)*
//전자는 zeroIfDefSet가 먼저 나온 경우를 처리하질 못함
elifDefList
: elifDef
| elifDef (simpleIfDefSet | zeroIfDefSet)*
| elifDef elifDefList
;


zeroIfDef
: ZeroIfDef
;

simpleIfDef
: SimpleIfDef
;

elifDef
: ElifDef
;

elseDef
: ElseDef
;

endIf
: EndIf
;


unknown
: Unknown
;

//lexer rule


ZeroIfDef : '#' Whitespace? 'if' Whitespace [0] Whitespace? Newline+ 
| '#' Whitespace? 'if' Whitespace [0] EOF
;

ElifDef : '#' Whitespace? 'elif' Whitespace? Newline
| '#' Whitespace? 'elif' EOF
;

ElseDef : '#' Whitespace? 'else' Whitespace? Newline 
| '#' Whitespace? 'else' EOF
;
EndIf : '#' Whitespace? 'endif' Whitespace? Newline 
| '#' Whitespace? 'endif' EOF
;
SimpleIfDef : '#' Whitespace? 'if' Whitespace
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
