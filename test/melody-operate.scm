;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: melody-operate.scm,v 1.5 2006/03/08 12:58:58 cut-sea Exp $

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

(test-start "kagoiri-musume operate melody")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (login w :top '?&)

 (make-musume w :view '?&melody-list)

 (set-gsid w 'melody-list)

 (test-section "new melody")

 (test* "�ե�����"
        '(*TOP*
          (form (@ (!contain (action ?&)))
                ?*))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit"))))))
        (make-match&pick w))

 (test/send&pick "���������"
                 w
                 '(("priority" "super")
		   ("status" "completed")
		   ("type" "discuss")
		   ("category" "section")
		   ("melody" "����������")
		   ("assign" "   ")))

 (test* "�ڡ��������ȥ�ι���������å�"
        '(*TOP*
          (h3 "����̼��Test Proj. - 1���ƥ��Ȥ�̼�� - COMPLETED"))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(,@//body h3))
        test-sxml-match?)

 (test* "�ե���������򥨥ꥢ�ι���������å�"
        '(*TOP*
          (table (tr ?*)
                 (tr (td (select
                          (@ (name "priority"))
                          (option (@ (value "normal")) "����")
                          (option (@ (value "low")) "��")
                          (option (@ (value "high")) "��")))
                     (td (select
                          (@ (name "status"))
                          (option (@ (value "open")) "OPEN")
                          (option
                           (@ (value "completed") (selected "true"))
                           "COMPLETED")))
                     (td (select
                          (@ (name "type"))
                          (option (@ (value "bug")) "�Х�")
                          (option (@ (value "task")) "������")
                          (option (@ (value "request")) "�ѹ���˾")))
                     (td (select
                          (@ (name "category"))
                          (option (@ (value "global")) "����")
                          (option
                           (@ (value "section") (selected "true"))
                           "���������")))
                     (td (select
                          (@ (name "assign"))
                          (option (@ (value "   ") (selected "true")))
                          (option (@ (value "cut-sea")) "cut-sea")))
                     (td ?*))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit")))) table ((// table) 1)))
        test-sxml-match?)

 (test* "������Ƥ�����å�"
        '(*TOP*
          (dl (@ (id ?_))
              (dt (span (@ (class "song-no")) "��2.")
                  (span (@ (class "song-time")) ?_)
                  (span (@ (class "song-fan")) "[cut-sea]")
		  (a (@ (!permute (onclick ?_) (href ?_))) "[�ؾ�]")
                  (a (@ (onClick "return confirm('�����˺�����ޤ�����')?true:false")
                        (href ?_)) "[���]"))
              (dd (p (@ (class "rectangle")) "����������")))
          (dl ?*))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(,@//body dl))
        test-sxml-match?)
 )


(test-end)