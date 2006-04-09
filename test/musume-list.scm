;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: musume-list.scm,v 1.6 2006/04/09 10:34:21 shibata Exp $

(load "common.scm")

(test-start "kagoiri-musume musume list check")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (login w :top '?&)

 (make-unit w :view '?&musume-list)

 (set-gsid w 'musume-list)

 (test* "�ʥӥ��������"
        '(*TOP*
          (div ?@
               (a ?@ "�ȥå�")
               " > "
               (span (@ (class "current"))
                     (a ?@
                        "����̼��Test Proj."))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//navigation))
        test-sxml-match?)

 (test* "��˥塼"
        '(*TOP*
          (!contain
           (a ?@
              "�Ʒ��ɲ�")
           (a ?@
              "����")
           (a ?@
              "����")))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//navigation-action '(// a)))
        test-sxml-match?)

 (test* "��˥å��⸡��"
        '(*TOP*
          (div ?@
               (form (@ (method "POST")
                        (action ?_))
                 (input (@ (value ?_)
                           (type "hidden")
                           (name "unit-id")))
                 "��˥å��⸡��:"
                 (input (@ (type "text")
                           (size "10")
                           (onKeyUp "delay_search(this.value)")
                           (onKeyDown "search_onKeyDown(event)")
                           (name "word")
                           (id "focus")))
                 (input (@ (value "����") (type "submit"))))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (div (@ (equal? (id "search-box"))))))
        test-sxml-match?)

 (test* "�ڡ��������ȥ�"
        '(*TOP*
          (h2 "����̼��Test Proj. - ̼������"))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//page-title))
        test-sxml-match?)


 (test-section "�Ʒ�����ơ��֥�")

 (test* "�ե�����"
        '(*TOP*
          (form (@ (method "POST")
                   (id "filtering_form")
                   (action ?_))
                (table ?*)
                ))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "filtering_form"))))))
        test-sxml-match?)

 (test* "�ե��륿���ơ��֥�"
        '(*TOP*
          (table (@ (class "table-filter"))
                   (tr (@ (onclick "toggle_select_mode(event)"))
                       (th (span (@ (class "clickable")) "ͥ����"))
                       (th (span (@ (class "clickable")) "���ơ�����"))
                       (th (span (@ (class "clickable")) "������"))
                       (th (span (@ (class "clickable")) "���ƥ���"))
                       (th (span (@ (class "clickable")) "��������"))
                       (th "ɽ�����"))
                   (tr (@ (valign "top"))
                       (td (select
                             (@ (onchange
                                  "filter_table(this, 'musume_list', '����')")
                                (name "priority"))
                             (option (@ (value "*all*")) "����")
                             (option (@ (value "normal")) "����")
                             (option (@ (value "low")) "��")
                             (option (@ (value "high")) "��")))
                       (td (select
                             (@ (onchange
                                  "filter_table(this, 'musume_list', '����')")
                                (name "status"))
                             (option (@ (value "*all*")) "����")
                             (option (@ (value "open")) "OPEN")
                             (option (@ (value "completed")) "COMPLETED")))
                       (td (select
                             (@ (onchange
                                  "filter_table(this, 'musume_list', '����')")
                                (name "type"))
                             (option (@ (value "*all*")) "����")
                             (option (@ (value "bug")) "�Х�")
                             (option (@ (value "task")) "������")
                             (option (@ (value "request")) "�ѹ���˾")))
                       (td (select
                             (@ (onchange
                                  "filter_table(this, 'musume_list', '����')")
                                (name "category"))
                             (option (@ (value "*all*")) "����")
                             (option (@ (value "global")) "����")
                             (option (@ (value "section")) "���������")))
                       (td (select
                             (@ (onchange
                                  "filter_table(this, 'musume_list', '����')")
                                (name "assign"))
                             (option (@ (value "*all*")) "����")
                             (option (@ (value "   ")))
                             (option (@ (value "cut-sea")) "cut-sea")))
                       (td (select
                             (@ (name "limit"))
                             (option (@ (value "")))
                             (option (@ (value "20")) "20")
                             (option (@ (value "50")) "50")
                             (option
                               (@ (value "200") (selected "true"))
                               "200")
                             (option (@ (value "500")) "500")
                             (option (@ (value "1000")) "1000")))
                       (td (noscript
                             (input (@ (value "�ʤ����")
                                       (type "submit")
                                       (name "submit"))))))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (table (@ (equal? (class "table-filter"))))))
        test-sxml-match?)


 (test* "�ե��륿���ơ��֥�"
        '(*TOP*
          (table (@ (id "musume_list") (class "listing"))
                   (thead (span (@ (id "musume_count")))
                          "˨������̼�������ޤ���(T^T)"
                          (div (@ (id "status-num"))
                               (span (a (@ (onclick
                                             "return update_status(this)")
                                           (href ?_))
                                        "OPEN")
                                     "(0) ")
                               (span (a (@ (onclick
                                             "return update_status(this)")
                                           (href ?_))
                                        "COMPLETED")
                                     "(0) "))
                          (tr (@ (onclick "sort_table(event);return false"))
                              (th)
                              (th (@ (value "no")) "No.")
                              (th (@ (value "title")) "�����ȥ�")
                              (th (@ (value "priority")) "ͥ����")
                              (th (@ (value "status")) "���ơ�����")
                              (th (@ (value "type")) "������")
                              (th (@ (value "category")) "���ƥ���")
                              (th (@ (value "assign")) "��������")
                              (th (@ (value "ltime")) "����")
                              (th (@ (value "ctime")) "��Ͽ��")
                              (th (@ (value "mtime")) "������")))
                   (tbody)))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (table (@ (equal? (id "musume_list"))))))
        test-sxml-match?)
 )

(test-end)