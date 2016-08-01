/*
'EndIf' Lexer rule ���� �������� EOF�� ������ �� �տ� Whitespace? �߰���. ���� �������� ������� ���� case.
������ lexer rule ���� �����ϰ� �߰���.

#endif ���� lexer rule ���� ���� ���ο� �ּ�ó���� �������� �� ���� ó��.
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


ZeroIfDef : '#' Whitespace? 'if' Whitespace [0] Emptyspace? Newline+ 
| '#' Whitespace? 'if' Whitespace [0] Emptyspace? EOF
;

ElifDef : '#' Whitespace? 'elif' Emptyspace? Newline
| '#' Whitespace? 'elif' Whitespace? EOF
;

ElseDef : '#' (Whitespace|BlockComment)* 'else' Emptyspace? Newline 
| '#' (Whitespace|BlockComment)* 'else' Whitespace? EOF
;
EndIf : '#' (Whitespace|BlockComment)* 'endif' Emptyspace? Newline 
| '#' (Whitespace|BlockComment)* 'endif' Emptyspace? EOF
;
SimpleIfDef : '#' Whitespace? 'if' Whitespace
| '#' Whitespace? 'if' Whitespace? Newline+
| '#' Whitespace? 'if' EOF
| '#' Whitespace? 'ifdef' Whitespace 
| '#' Whitespace? 'ifdef' Whitespace? Newline+
| '#' Whitespace? 'ifndef' Whitespace 
| '#' Whitespace? 'ifndef' Whitespace? Newline+
;
Emptyspace : (Whitespace|BlockComment|LineComment)+ -> skip;

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
