;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: musume-operate.scm,v 1.6 2006/12/14 07:21:23 cut-sea Exp $

(load "common.scm")

(test-start "kagoiri-musume operate musume")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (login w :top '?&)

 (make-musume w :unit-view '?&musume-list)

 (set-gsid w 'musume-list)

 (call-worker-test* "̼�������"

                    :node '(*TOP*
                            (!contain
                             (a (@ (href ?&musume-new))
                                "̼����")))

                    :sxpath (//navigation-action '(// a)))


 (test-section "̼�����ڡ���")

 (set-gsid w 'musume-new)

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

 (test* "�ڡ��������ȥ�"
        '(*TOP*
          (h2 "����̼��Test Proj. - ������̼��"))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//page-title))
        test-sxml-match?)

 (test* "�ե�����"
        '(*TOP*
          (form (@ (onsubmit "return false;")
                   (method "POST")
                   (id "mainedit")
                   (enctype "multipart/form-data")
                   (action ?&musume-new-submit))
                (table ?*)))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit"))))))
        (make-match&pick w))

 (set-gsid w 'musume-new)

 (test* "�ե���������򥨥ꥢ"
        '(*TOP*
          (table (tr (th "ͥ����")
                     (th "���ơ�����")
                     (th "������")
                     (th "���ƥ���")
                     (th "��������"))
                 (tr (td (select
                          (@ (name "priority"))
                          (option (@ (value "normal")) "����")
                          (option (@ (value "low")) "��")
                          (option (@ (value "high")) "��")))
                     (td (select
                          (@ (name "status"))
                          (option (@ (value "open")) "OPEN")
                          (option
                           (@ (value "completed"))
                           "COMPLETED")))
                     (td (select
                          (@ (name "type"))
                          (option (@ (value "bug")) "�Х�")
                          (option (@ (value "task")) "������")
                          (option
                           (@ (value "request"))
                           "�ѹ���˾")))
                     (td (select
                          (@ (name "category"))
                          (option (@ (value "global")) "����")
                          (option
                           (@ (value "section"))
                           "���������")))
                     (td (select
                          (@ (name "assign"))
                          (option (@ (value "")))
                          (option
                           (@ (value "cut-sea"))
                           "cut-sea")))
                     (td (input (@ (value "������̼������")
                                   (type "button")
                                   (onclick "submit();")))))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit")))) table ((// table) 1)))
        test-sxml-match?)

 (test* "��������"
        '(*TOP*
          (table (@ (class "calendar"))
                 ?*))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (td (@ (equal? (id "limit-calendar")))) table))
        test-sxml-match?)

 (test* "�����ȥ롦�������ϥ��ꥢ"
        '(*TOP*
          (table (tr (td "�����ȥ�"
                         (span (@ (class "warning")) "(��)"))
                     (td (input (@ (type "text")
                                   (size "80")
                                   (name "name")
                                   (id "focus")))))
                 (tr (td)
                     (td (span (@ (onclick ?_))
                               (span (@ (class "clickable"))
                                     "̼�ؤΥ��"))
                         (span (@ (onclick ?_))
                               (span (@ (class "clickable"))
                                     "�᡼�������о�"))))
                 (tr (td "����")
                     (td (textarea
                          (@ (type "text")
                             (rows "20")
                             (name "melody")
                             (id "melody")
                             (cols "80")))))
                 (tr (td "�ե�����")
                     (td (input (@ (type "file")
                                   (name "file")))
                         (input (@ (value "")
                                   (type "hidden")
                                   (name "filename")))))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit")))) table ((// table) 3)))
        test-sxml-match?)

 (test* "���֥ߥåȥܥ���"
        '(*TOP*
          (!repeat
           (input (@ (value "������̼������")
                     (type "button")
                     (onclick "submit();")))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (input (@ (equal? (onclick "submit();"))))))
        test-sxml-match?)

 )

(test-end)