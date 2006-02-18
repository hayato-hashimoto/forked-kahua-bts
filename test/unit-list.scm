;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: unit-list.scm,v 1.2 2006/02/18 14:14:32 shibata Exp $

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

(test-start "kagoiri-musume unit-list enter check")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (test-section "kagoiri-musume unit-list link click without login")

 (test* "���������"
        '(*TOP*
          (h1 "����̼���ؤ褦������")
          (h3 "��˥åȰ����ϰ��̥桼����������Ȥ�ɬ�פǤ�")
          (form (@ (method "POST")
                   (action ?&unit-list))
                ?*))
        (call-worker/gsid->sxml w '() '() '(// (div (@ (equal? (id "body")))) *))
        (make-match&pick w))

 (set-gsid w 'unit-list)

 (test-section "kagoiri-musume unit-list link click with login")

 (test* "�ʥӥ��������"
        '(*TOP*
          (span (@ (class "current"))
                (a (@ (href "kahua.cgi/kagoiri-musume/")) "�ȥå�")))
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "navigation")))) *))
        test-sxml-match?)

 (test* "��˥åȰ���"
        '(*TOP*
          ?*
          (h2 "��˥åȰ���")
          (table (@ (class "listing"))
                 (thead (tr (th)
                            (th "��˥å�̾")
                            (th "����")
                            (th "�ե���")
                            (th "����")))
                 (tbody))
          ?*)
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) *))
        test-sxml-match?)

 (test* "����˥åȺ����ե�����"
        '(*TOP*
          (form (@ (onsubmit "return submitForm(this)")
                   (method "POST")
                   (action ?&unit-list))
                ?*
                (input (@ (value "����˥åȷ���") (type "submit")))))
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) form))
        (make-match&pick w))

 (test* "�ե����������"
        '(*TOP*
          (table (tr (@ (onclick "toggle_fulllist(event)"))
                     (th (@ (colspan "2"))
                         (span (@ (class "clickable")) "ͥ����"))
                     (th (@ (colspan "2"))
                         (span (@ (class "clickable")) "���ơ�����"))
                     (th (@ (colspan "2"))
                         (span (@ (class "clickable")) "������"))
                     (th (@ (colspan "2"))
                         (span (@ (class "clickable")) "���ƥ���")))
                 (tr (td (select
                          (@ (size "5")
                             (name "priority")
                             (multiple "true")
                             (id "priority"))
                          (option (@ (value "high")) "��")
                          (option (@ (value "low")) "��")
                          (option (@ (value "normal")) "����")
                          (option (@ (value "super")) "Ķ��")))
                     (td (div (@ (onclick "up_select(this, 'priority')")
                                 (class "clickable"))
                              "��")
                         (div (@ (onclick "down_select(this, 'priority')")
                                 (class "clickable"))
                              "��"))
                     (td (select
                          (@ (size "5")
                             (name "status")
                             (multiple "true")
                             (id "status"))
                          (option (@ (value "completed")) "COMPLETED")
                          (option (@ (value "on-hold")) "ON HOLD")
                          (option (@ (value "open")) "OPEN")
                          (option (@ (value "rejected")) "REJECTED")
                          (option (@ (value "taken")) "TAKEN")))
                     (td (div (@ (onclick "up_select(this, 'status')")
                                 (class "clickable"))
                              "��")
                         (div (@ (onclick "down_select(this, 'status')")
                                 (class "clickable"))
                              "��"))
                     (td (select
                          (@ (size "5")
                             (name "type")
                             (multiple "true")
                             (id "type"))
                          (option (@ (value "bug")) "�Х�")
                          (option (@ (value "discuss")) "����")
                          (option (@ (value "etc")) "����¾")
                          (option (@ (value "report")) "���")
                          (option (@ (value "request")) "�ѹ���˾")
                          (option (@ (value "task")) "������")
                          (option (@ (value "term")) "�Ѹ�")))
                     (td (div (@ (onclick "up_select(this, 'type')")
                                 (class "clickable"))
                              "��")
                         (div (@ (onclick "down_select(this, 'type')")
                                 (class "clickable"))
                              "��"))
                     (td (select
                          (@ (size "5")
                             (name "category")
                             (multiple "true")
                             (id "category"))
                          (option (@ (value "global")) "����")
                          (option (@ (value "infra")) "����ե�")
                          (option (@ (value "master")) "�ޥ���")
                          (option (@ (value "section")) "���������")))
                     (td (div (@ (onclick "up_select(this, 'category')")
                                 (class "clickable"))
                              "��")
                         (div (@ (onclick "down_select(this, 'category')")
                                 (class "clickable"))
                              "��"))))
          )
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) form (table 1)))
        test-sxml-match?)


 (test* "��˥å�̾�����ס��ե�������"
        '(*TOP*
          (table (tr (td "��˥å�̾" (span (@ (class "warning")) "(��)"))
                     (td (textarea
                          (@ (type "text")
                             (rows "1")
                             (name "name")
                             (cols "32")))))
                 (tr (td "����")
                     (td (@ (colspan "2"))
                         (textarea
                          (@ (type "text")
                             (rows "10")
                             (name "desc")
                             (cols "80")))))
                 (tr (@ (align "left"))
                     (td "�ե���" (span (@ (class "warning")) "(��)"))
                     (td (table (tr (td (select
                                         (@ (size "5")
                                            (name "fans")
                                            (multiple "true")
                                            (id "fans"))
                                         (option (@ (value "   ")))
                                         (option (@ (value "cut-sea")) "cut-sea")
                                         (option (@ (value "guest")) "guest")
                                         (option (@ (value "kago")) "kago")))
                                    (td (div (@ (onclick
                                                 "up_select(this, 'fans')")
                                                (class "clickable"))
                                             "��")
                                        (div (@ (onclick
                                                 "down_select(this, 'fans')")
                                                (class "clickable"))
                                             "��"))))))
                 (tr (td "���Υ��ɥ쥹")
                     (td (textarea
                          (@ (type "text")
                             (rows "2")
                             (name "notify-addresses")
                             (cols "20"))))))
          )
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) form (table 2)))
        test-sxml-match?)
 )

(test-end)