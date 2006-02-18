;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: change-password.scm,v 1.1 2006/02/18 14:51:44 shibata Exp $

(use gauche.test)
(use gauche.collection)
(use file.util)
(use text.tree)
(use sxml.ssax)
(use sxml.sxpath)
(use kahua)
(use kahua.test.xml)
(use kahua.test.worker)

(load "common.scm")

(test-start "kagoiri-musume change password check")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (test-section "kagoiri-musume click change password")

 (test* "���������"
        '(*TOP*
          (form (@ (method "POST")
                   (action ?&))
                ?*))
        (call-worker/gsid->sxml w '() '() '(// (div (@ (equal? (id "body")))) form))
        (make-match&pick w))

 (test* "�ѥ�����ѹ����"
        '(*TOP*
          ?*
          (a (@ (href ?&) ?*) "�ѥ�����ѹ�")
          ?*)
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "header")))) a))
        (make-match&pick w))
 
 (test* "�ѥ�����ѹ��ڡ���"
        '(*TOP*
          (h3 "cut-sea ����Υѥ�����ѹ�")
          (form (@ (method "POST")
                   (action ?&change-pw))
                 (table (tr (th "��ѥ����")
                            (td (input (@ (value "")
                                          (type "password")
                                          (name "old-pw")
                                          (id "focus")))))
                        (tr (th "���ѥ����")
                            (td (input (@ (value "")
                                          (type "password")
                                          (name "new-pw")))))
                        (tr (th "���ѥ����(��ǧ)")
                            (td (input (@ (value "")
                                          (type "password")
                                          (name "new-again-pw"))))))
                 (input (@ (value "�ѹ�") (type "submit") (name "submit")))
                 (p (@ (class "warning"))))
          )
        (call-worker/gsid->sxml w '() '()
                                '(// (div (@ (equal? (id "body")))) *))
        (make-match&pick w))

 (set-gsid w 'change-pw)

 (test* "���ѥ����(��ǧ)��ְ㤨��"
        '(*TOP*
          "���ѥ���ɤ������Ǥ�")
        (call-worker/gsid->sxml w
                                '()
                                '(("old-pw" "cutsea") ("new-pw" "badsea") ("new-again-pw" "newsea"))
                                '(// (p (@ (equal? (class "warning")))) *text*))
        (make-match&pick w))

 (set-gsid w 'change-pw)

 (test* "��ѥ���ɤ�ְ㤨��"
        '(*TOP*
          "��ѥ���ɤ������Ǥ�")
        (call-worker/gsid->sxml w
                                '()
                                '(("old-pw" "badsea") ("new-pw" "newsea") ("new-again-pw" "newsea"))
                                '(// (p (@ (equal? (class "warning")))) *text*))
        test-sxml-match?)

 (set-gsid w 'change-pw)

 (test* "�ѥ���ɤ��ѹ�"
        '(*TOP*
          "cut-sea ����Υѥ���ɤ��ѹ����ޤ���")
        (call-worker/gsid->sxml w
                                '()
                                '(("old-pw" "cutsea") ("new-pw" "goodsea") ("new-again-pw" "goodsea"))
                                '(// (div (@ (equal? (class "msgbox")))) h3 *text*))
        test-sxml-match?)

 (set-gsid w 'change-pw)

 (test* "�ѹ������ѥ���ɤǥѥ���ɤ��ѹ�"
        '(*TOP*
          "cut-sea ����Υѥ���ɤ��ѹ����ޤ���")
        (call-worker/gsid->sxml w
                                '()
                                '(("old-pw" "goodsea") ("new-pw" "cutsea") ("new-again-pw" "cutsea"))
                                '(// (div (@ (equal? (class "msgbox")))) h3 *text*))
        test-sxml-match?)
 )

(test-end)