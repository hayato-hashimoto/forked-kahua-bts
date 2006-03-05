;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: melody-list.scm,v 1.5 2006/03/05 16:58:30 cut-sea Exp $

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
                                //navigation)
        test-sxml-match?)

 (test* "��˥塼"
        '(*TOP*
          (ul ?@
              (li (a (@ (href ?_)
                        (class "clickable"))
                     "������̼��"))))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                //menu)
        test-sxml-match?)

 (test* "�֥å��ޡ����ܥ���"
        '(*TOP*
          (a ?@
             "�֥å��ޡ������ɲ�"))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                '(// (a (@ (equal? (id "bookmark-button"))))))
        test-sxml-match?)

 (test* "�����ư���"
        '(*TOP*
          (div (a (@ (onclick "copy_search(this)")
                     (href ?_)
                     (class "clickable"))
                  "<<")
               (a (@ (onclick "copy_search(this)")
                     (href ?_)
                     (class "clickable"))
                  ">>")))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(,@//body (div 2)))
        test-sxml-match?)

 (test* "�ڡ��������ȥ�"
        '(*TOP*
          (h3 "����̼��Test Proj. - 1���ƥ��Ȥ�̼�� - OPEN"))
        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(,@//body h3))
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
                          (option (@ (value "   ")))
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
                            (span (@ (class "clickable")) "�Ʒ�ؤΥ��"))))
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
		  (a (@ (!permute (onClick ?_) (href ?_))) "[�ؾ�]")
                  (a (@ (onClick "return confirm('�����˺�����ޤ�����')?true:false")
                        (href ?_))
                     "[���]"))
              (dd (p (@ (class "rectangle")) "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�"))))

        (call-worker/gsid->sxml w
                                '()
                                '()
                                `(,@//body dl))
        test-sxml-match?)
 )

(test-end)
