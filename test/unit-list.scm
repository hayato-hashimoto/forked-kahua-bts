;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: unit-list.scm,v 1.10 2006/04/08 11:43:48 shibata Exp $

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
                (a (@ (href "/kahua.cgi/kagoiri-musume/")) "�ȥå�")))
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
                 (thead (tr (th "��˥å�̾")
                            (th "����")
                            (th (@ (nowrap "nowrap")) "�ե���")
                            (th "����")
                            (th)))
                 (tbody))
          ?*)
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) *))
        test-sxml-match?)

 (call-worker-test* "��˥å��ɲåڡ����ذ�ư"

                    :node '(*TOP*
                            (!contain
                             (a (@ (href ?&))
                                "�ץ��������ɲ�")))

                    :sxpath (//navigation-action '(// a))
                    :body '(("name" "cut-sea") ("pass" "cutsea")))

 (test* "����˥åȺ����ե�����"
        '(*TOP*
          (form (@ (onsubmit "return submitCreateUnit(this)")
                   (method "POST")
                   (action ?_))
                ?*
                (input (@ (value "����˥åȷ���") (type "submit")))))
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) form))
        test-sxml-match?)

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
                     (td (input
                          (@ (value "")
                             (type "text")
                             (size "80")
                             (name "name")))))
                 (tr (td "����")
                     (td (@ (colspan "2"))
                         (textarea
                          (@ (type "text")
                             (rows "10")
                             (name "desc")
                             (cols "80")))))
                 (tr (@ (align "left"))
                     (td "�ե���" (span (@ (class "warning")) "(��)"))
                     (td (table (tr (@ (id "user-tr"))
                                    (td (@ (id "memberlistblock"))
                                     (ul (@ (ondblclick ?_)
                                            (id "memberlist")
                                            (class "userlist"))))
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
                                         (li (@ (value "   ")))
                                         (li (@ (value "cut-sea")) "cut-sea")
                                         (li (@ (value "guest")) "guest")
                                         (li (@ (value "kago")) "kago")))
                                 (td (@ (id "select-td")))
                                 (script
                                   (@ (type "text/javascript"))
                                   ?*)))))
                 (tr (td "���Υ��ɥ쥹")
                     (td (textarea
                          (@ (type "text")
                             (rows "2")
                             (name "notify-addresses")
                             (cols "20")))))
                 (tr (td "����")
                  (td (input (@ (type "checkbox")
                                (name "public")
                                (id "public")))
                      (label (@ (for "public")) "����"))))
          )
        (call-worker/gsid->sxml w
                                '()
                                '(("name" "cut-sea") ("pass" "cutsea"))
                                '(// (div (@ (equal? (id "body")))) form (table 2)))
        test-sxml-match?)
 )

(test-end)