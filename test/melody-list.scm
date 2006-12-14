;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: melody-list.scm,v 1.11 2006/12/14 07:21:23 cut-sea Exp $

(load "common.scm")

(test-start "kagoiri-musume melody list check")

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

 (test-section "melody list")

 (test* "�ʥӥ��������"
        '(*TOP*
          (div ?@
               (a (@ (href ?_)) "�ȥå�")
               " > "
               (a (@ (href ?_))
                  "����̼��Test Proj.")
               " > "
               (span (@ (class "current"))
                     (a (@ (href ?_))
                        "�ƥ��Ȥ�̼��"))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//navigation))
        test-sxml-match?)

 (call-worker-test* "��˥塼"

                    :node '(*TOP*
                            (!contain
                             (a ?@ (span (@ (id "bookmark-button")) "�֥å��ޡ����ɲ�"))
                             (a ?@ "����")
                             (a ?@ "����")))

                    :sxpath (//navigation-action '(// a)))

 (test* "�����ư���"
        '(*TOP*
          (!contain
           (div (a (@ (onclick "copy_search(this)")
                     (href ?_)
                     (class "clickable"))
                  "����̼")
               (a (@ (onclick "copy_search(this)")
                     (href ?_)
                     (class "clickable"))
                  "����̼"))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//body '(div)))
        test-sxml-match?)

 (test* "�ڡ��������ȥ�"
        '(*TOP*
          (h2 "����̼��Test Proj. - 1���ƥ��Ȥ�̼�� - OPEN"))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//page-title))
        test-sxml-match?)


 (test* "��ƥե�����"
        '(*TOP*
          (form (@ (method "POST")
                   (id "mainedit")
                   (enctype "multipart/form-data")
                   (action ?_))
                (table ?*)))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(// (form (@ (equal? (id "mainedit"))))))
        test-sxml-match?)


 (test* "�ե���������򥨥ꥢ"
        '(*TOP*
          (table (tr (th "ͥ����")
                     (th "���ơ�����")
                     (th "������")
                     (th "���ƥ���")
                     (th "��������"))
                 (tr (td (select
                          (@ (name "priority"))
                          (option
                           (@ (value "normal"))
                           "����")
                          (option
                           (@ (value "low"))
                           "��")
                          (option
                           (@ (value "high")
                              (selected "true"))
                           "��")))
                     (td (select
                          (@ (name "status"))
                          (option
                           (@ (value "open")
                              (selected "true"))
                           "OPEN")
                          (option
                           (@ (value "completed"))
                           "COMPLETED")))
                     (td (select
                          (@ (name "type"))
                          (option
                           (@ (value "bug"))
                           "�Х�")
                          (option
                           (@ (value "task")
                              (selected "true"))
                           "������")
                          (option
                           (@ (value "request"))
                           "�ѹ���˾")))
                     (td (select
                          (@ (name "category"))
                          (option
                           (@ (value "global")
                              (selected "true"))
                           "����")
                          (option
                           (@ (value "section"))
                           "���������")))
                     (td (select
                          (@ (name "assign"))
                          (option (@ (value "")))
                          (option
                           (@ (value "cut-sea")
                              (selected "true"))
                           "cut-sea")))
                     (td (input (@ (value "���ߥå�")
                                   (type "submit")))))))
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

 (test* "�������ϥ��ꥢ"
        '(*TOP* (table (@ (class "extension"))
              (tr (td)
                  (td (span (@ (onclick ?_))
                            (span (@ (class "clickable")) "̼�ؤΥ��"))
                      (span (@ (onclick ?_))
                            (span (@ (class "clickable")) "�᡼�������о�"))))
              (tr (td "����")
                  (td (@ (id "melody-text")) 
		      (textarea
		       (@ (type "text")
			  (rows "10")
			  (name "melody")
			  (id "focus")
			  (cols "80")))))
              (tr (td "�ե�����")
                  (td (input (@ (type "file") (name "file")))))))
	
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (form (@ (equal? (id "mainedit")))) table ((// table) 3)))
        test-sxml-match?)

 (test* "���ȥ�󥯥��ꥢ"
        '(*TOP*
          (table (@ (id "links-table"))
                    (tr (th "�����") (th "��󥯸�"))
                    (tr (td (ul)) (td (ul)))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (table (@ (equal? (id "links-table"))))))
        test-sxml-match?)

 (test* "���ɽ�����ꥢ"
        '(*TOP*
          (dl (@ (id ?_))
              (dt (span (@ (class "song-no")) "��1.")
                  (span (@ (class "song-time")) ?_)
                  (span (@ (class "song-fan")) "[cut-sea]")
		  (a (@ (!permute (onclick ?_) (href ?_))) "[�ؾ�]")
                  (a (@ (onClick "return confirm('�����˺�����ޤ�����')?true:false")
                        (href ?_))
                     "[���]"))
              (dd (p (@ (class "rectangle")) "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�"))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                (//body '(dl)))
        test-sxml-match?)
 )

(test-end)
