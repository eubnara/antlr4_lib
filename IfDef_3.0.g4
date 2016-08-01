/*
#if
#elif
#else
#endif
ó�� �Ϸ�

#ifdef
#ifndef
��ó��

ver 3.0
*/


grammar IfDef;


//parser rule

blockList
: block+
;
//endif, elseDef, elifDef �� �׻� if ifdef ��� ¦�� �¾ƾ� �Ѵ�.
//�������� �� �Ǵ� �����̶�� �����Ͽ� �ؽ�Ʈ �м�(���� �м�)�� �Ѵ�.
// ����, ���� 'block' rule ������ endif, elseDef, elifDef �� simpleIfDefSet �̳� zeroIfDefSet // �� ���Եǰ�
// simpleIfDefSet�� zeroIfDefSet�� ������ setList�� ���ԵǹǷ� �����Ͽ���.
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

//elifDef�� ���� �� ���� �� ������, elseDef�� �� if set�� ���� �� ���� �� ����.
//(simpleIfDefSetList | zeroIfDefSetList)? --> (simpleIfDefSetList | zeroIfDefSetList)* 
// simpleDefSetList �� zeroIfDefSetList�� ���� �ִ� ��� �����ֱ� ���ؼ�
zeroIfDefSet
:  zeroIfDef elifDef* elseDef? endIf
| zeroIfDef elifDefList? (simpleIfDefSetList | zeroIfDefSetList)* elifDefList? elseDef? (simpleIfDefSetList| zeroIfDefSetList)* endIf
; 

simpleIfDefSetList
: simpleIfDefSet
| simpleIfDefSet simpleIfDefSetList
;

//(simpleIfDefSetList | zeroIfDefSetList)? --> (simpleIfDefSetList | zeroIfDefSetList)*
//������ zeorIfDefSet�� ����
simpleIfDefSet
:  simpleIfDef elifDef* elseDef? endIf
| simpleIfDef elifDefList? (simpleIfDefSetList| zeroIfDefSetList)* elifDefList? elseDef? (simpleIfDefSetList| zeroIfDefSetList)? endIf
;

//elifDef simpleIfDefSet* zeroIfDefSet*  --> elifDef (simpleIfDefSet | zeroIfDefSet)*
//���ڴ� zeroIfDefSet�� ���� ���� ��츦 ó������ ����
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
