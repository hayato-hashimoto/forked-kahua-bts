;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: unit-operate.scm,v 1.15 2006/12/13 01:21:03 cut-sea Exp $

(load "common.scm")

(test-start "kagoiri-musume operate unit")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (login w)

 (make-unit w :edit '?&unit-edit)

 (test-section "��˥å�����")

 (set-gsid w 'unit-edit)

 (test* "�ڡ��������ȥ�"
	`(*TOP*
          "������̼��Test Proj.�٥�˥å�����")
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) h2 *text*))
        (make-match&pick w))

 (set-gsid w 'unit-edit)

 (test* "�ե�����"
	`(*TOP*
          (form (@ (onsubmit "return submitCreateUnit(this)")
                   (method "POST")
                   (action ?&unit-edit-submit))
                ?*
                (input (@ (value "����") (type "submit")))))
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) form))
        (make-match&pick w))

 (set-gsid w 'unit-edit)

 (test* "�ե����������(���ߤ��ͤ����򤵤�Ƥ��뤫)"
	`(*TOP*
          (table (tr ?*)
                 (tr (td (select
			  ?@
			  (!permute
			   (option (@ (value "normal") (selected "#t")) "����")
			   (option (@ (value "low") (selected "#t")) "��")
			   (option (@ (value "high") (selected "#t")) "��")
			   (option (@ (value "super")) "Ķ��"))))
                     (td ?*)
                     (td (select
			  ?@
			  (!permute
			   (option (@ (value "open") (selected "#t")) "OPEN")
			   (option (@ (value "completed") (selected "#t")) "COMPLETED")
			   (option (@ (value "on-hold")) "ON HOLD")
			   (option (@ (value "taken")) "TAKEN")
			   (option (@ (value "rejected")) "REJECTED"))))
                     (td ?*)
                     (td (select
			  ?@
			  (!permute
			   (option (@ (value "bug") (selected "#t")) "�Х�")
			   (option (@ (value "task") (selected "#t")) "������")
			   (option (@ (value "request") (selected "#t")) "�ѹ���˾")
			   (option (@ (value "discuss")) "����")
			   (option (@ (value "report")) "���")
			   (option (@ (value "term")) "�Ѹ�")
			   (option (@ (value "etc")) "����¾"))))
                     (td ?*)
                     (td (select
			  ?@
			  (!permute
			   (option (@ (value "global") (selected "#t")) "����")
			   (option (@ (value "section") (selected "#t")) "���������")
			   (option (@ (value "infra")) "����ե�")
			   (option (@ (value "master")) "�ޥ���"))))
                     (td ?*))))
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) form (table 1)))
        test-sxml-match?)

 (set-gsid w 'unit-edit)

 (test* "��˥å�̾�����ס��ե�������(���ߤ��ͤ����򤵤�Ƥ��뤫)"
        '(*TOP*
          (table (tr (td "��˥å�̾" ?*)
                     (td (input (@ (value "����̼��Test Proj.") ?*))))
                 (tr (td "����")
                     (td ?@
                         (textarea ?@
                                   "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")))
                 (tr ?@
                     (td "�ե���" ?*)
                     (td (table (tr (@ (id "user-tr"))
                                    (td (@ (id "memberlistblock"))
                                        (ul (@ (ondblclick ?_)
                                               (id "memberlist")
                                               (class "userlist"))
                                            (li (@ (user-name "   ")))
                                            (li (@ (user-name "cut-sea")) "cut-sea")))
                                    (td "<=")
                                    (td (@ (id "allmemberlistblock"))
                                        "����:"
                                        (input (@ (type "text")
                                                  (onkeyup
                                                   "filter_member(this.value)")
                                                  (id "membersearch")))
                                        (ul (@ (ondblclick ?_)
                                               (id "allmemberlist")
                                               (class "userlist"))
					    (!permute
					     (li (@ (user-name "kago")) "kago")
					     (li (@ (user-name "guest")) "guest"))))
                                    (td (@ (id "select-td")))
                                    (script
                                     (@ (type "text/javascript"))
                                     ?_)))))
                 (tr (td "���Υ��ɥ쥹")
                     (td (textarea ?@)))
                 (tr (td "����")
                     (td (input (@ (type "checkbox")
                                   (name "public")
                                   (id "public")))
                         (label (@ (for "public")) "����"))))
          )
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) form (table 2)))
        test-sxml-match?)

 (set-gsid w 'unit-edit-submit)

 (test/send&pick "��˥å������ѹ�"
                 w
                 '(("priority" "normal" "super" "high")
		   ("status" "open" "on-hold" "completed")
		   ("type" "task" "request" "discuss")
		   ("category" "master" "infra" "global" "section")
		   ("name" "����̼��Test Project.")
		   ("desc" "����̼���ΥХ��ȥ�å��󥰤ȥ������ޥ͡������Ȥ�Ԥ���˥å�")
		   ("fans" "   " "cut-sea" "guest")))

 (test* "��˥å������ѹ���ǧ"
	`(*TOP*
          (tr ?@
              (td ?@ (a (@ (href ?&) ?*) "����̼��Test Project.") " (0)")
              (td "����̼���ΥХ��ȥ�å��󥰤ȥ������ޥ͡������Ȥ�Ԥ���˥å�")
              (td (span ?@
                        (span ?@ "2��"))
                  (div ?@ (div "cut-sea") (div "guest")))
              (td (a ?@ "��"))
              (td ?@ (span ?@ (a ?@ "����"))))
          )
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) table tbody tr))
        (make-match&pick w))
 )

(test-end)