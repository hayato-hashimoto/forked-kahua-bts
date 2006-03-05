;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: unit-operate.scm,v 1.4 2006/03/05 06:06:49 shibata Exp $

(use gauche.test)
(use gauche.collection)
(use file.util)
(use text.tree)
(use sxml.ssax)
(use sxml.sxpath)
(use kahua)
(use kahua.test.xml)
(use kahua.test.worker)

(use common-test)

(load "common.scm")

(test-start "kagoiri-musume operate unit")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (login w :top '?&unit-list)

 (set-gsid w 'unit-list)

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
                 (tr (td (select ?@
                          (option (@ (value "normal") (selected "#t")) "����")
                          (option (@ (value "low") (selected "#t")) "��")
                          (option (@ (value "high") (selected "#t")) "��")
                          (option (@ (value "super")) "Ķ��")))
                     (td ?*)
                     (td (select ?@
                          (option (@ (value "open") (selected "#t")) "OPEN")
                          (option (@ (value "completed") (selected "#t")) "COMPLETED")
                          (option (@ (value "on-hold")) "ON HOLD")
                          (option (@ (value "rejected")) "REJECTED")
                          (option (@ (value "taken")) "TAKEN")))
                     (td ?*)
                     (td (select ?@
                          (option (@ (value "bug") (selected "#t")) "�Х�")
                          (option (@ (value "task") (selected "#t")) "������")
                          (option (@ (value "request") (selected "#t")) "�ѹ���˾")
                          (option (@ (value "discuss")) "����")
                          (option (@ (value "etc")) "����¾")
                          (option (@ (value "report")) "���")
                          (option (@ (value "term")) "�Ѹ�")))
                     (td ?*)
                     (td (select ?@
                          (option (@ (value "global") (selected "#t")) "����")
                          (option (@ (value "section") (selected "#t")) "���������")
                          (option (@ (value "infra")) "����ե�")
                          (option (@ (value "master")) "�ޥ���")))
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
                     (td (textarea ?@
                                   "����̼��Test Proj.")))
                 (tr (td "����")
                     (td ?@
                         (textarea ?@
                                   "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")))
                 (tr ?@
                     (td "�ե���" ?*)
                     (td (table (tr (td (@ (id "memberlistblock"))
                                        (ul (@ (id "memberlist")
                                               (class "userlist"))
                                            (li (@ (value "   ")))
                                            (li (@ (value "cut-sea")) "cut-sea")))
                                    (td "<=")
                                    (td (@ (id "allmemberlistblock"))
                                        "����:"
                                        (input (@ (type "text")
                                                  (onkeyup
                                                   "filter_member(this.value)")
                                                  (id "membersearch")))
                                        (ul (@ (id "allmemberlist")
                                               (class "userlist"))
                                            (li (@ (value "guest")) "guest")
                                            (li (@ (value "kago")) "kago")))
                                    (script
                                     (@ (type "text/javascript"))
                                     ?_)))))
                 (tr (td "���Υ��ɥ쥹")
                     (td (textarea ?@))))
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
              (td (a ?@ "����"))
              (td (a (@ (href ?&) ?*) "����̼��Test Project.") " (0)")
              (td "����̼���ΥХ��ȥ�å��󥰤ȥ������ޥ͡������Ȥ�Ԥ���˥å�")
              (td "cut-sea , guest")
              (td (a ?@ "��")))
          )
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
         '(// (div (@ (equal? (id "body")))) table tbody tr))
        (make-match&pick w))
 )

(test-end)