(define *head*
  `(head
    (title ?_) (meta ?@) (link ?@) (script ?@)))

(define *header*
  '(div ?@
        (h1 ?@ ?_)
        (a ?@ "�ȥå�")
        (a ?@ "�����ƥ����")
        (a ?@ "��˥åȰ���")
        (a ?@ "Login")))

(define *footer*
  '(div (@ (id "bottom-pane"))
        (p ?_)))

(define (*header-logedin* user)
  `(div ?@
        (h1 ?@ ?_)
        (a ?@ "�ȥå�")
        (a ?@ "�����ƥ����")
        (a ?@ "��˥åȰ���")
        (a ?@ "�ѥ�����ѹ�")
        (span " Now login:" (a ?@ ,user))
        (a (@ (href ?&)) "Logout")
        (form ?@ "����:" (input ?@))))

(define-syntax *make-body*
  (syntax-rules ()
    ((*mke-body* b1 ...)
     `(div (@ (id "body"))
           b1 ...))))

