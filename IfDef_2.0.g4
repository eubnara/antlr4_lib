grammar IfDef;


//parser rule

blockList
: block*
;
//endif, else, elif �� �׻� if ifdef ��� ¦�� �¾ƾ� �Ѵ�.
//�������� �� �Ǵ� �����̶�� �����Ͽ� �ؽ�Ʈ �м�(���� �м�)�� �Ѵ�.
// ����, ���� 'block' rule ������ endif, else, elif �� simpleIfSet �̳� zeroIfSet // �� ���Եǰ�
// simpleIfSet�� zeroIfSet�� ������ setList�� ���ԵǹǷ� �����Ͽ���.
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

//elif�� ���� �� ���� �� ������, else�� �� if set�� ���� �� ���� �� ����.
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


//cf. #if �� ���ٿ� ���ְ� newline ���� ó���ȴٸ�, #if 0 �� ���� ȿ���̴�.
//#if
//#if 0
//����, [0] �� �ƴ϶�, [0]? ���� ǥ���Ͽ���.
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