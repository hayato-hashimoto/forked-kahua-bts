;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: test1.scm,v 1.13 2006/01/07 08:05:15 cut-sea Exp $

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

(test-start "kagoiri-musume admin-system enter check")

(*setup*)

;;------------------------------------------------------------
;; Run kagoiri-musume
(test-section "kahua-server kagoiri-musume.kahua")

(with-worker
 (w *worker-command*)

 (test* "run kagoiri-musume.kahua" #t (worker-running? w))

 (test* "kagoiri-musume top link click"
	`(html
          ,*head*
	  (body
           (div ?@
		(h1 ?@ ?_)
		(a (@ (href ?&) ?*) "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "Login"))
           ,(*make-body*
             (h1 "����̼���ؤ褦������")
             (h3 "��˥åȰ����ϰ��̥桼����������Ȥ�ɬ�פǤ�")
             (form ?@
                   (table
                    (tr (th "Login Name") (td (input (@ (value "") (type "text") (name "name") (id "focus")))))
                    (tr (th "Password") (td (input (@ (value "") (type "password") (name "pass"))))))
                   (input (@ (value "login") (type "submit") (name "submit")))))
           ,*footer*))
        (call-worker/gsid w '() '() (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume system admin link click without login"
	`(html
	  ,*head*
	  (body
           ,*header*
           ,(*make-body*
             (h1 ?_)
             (h3 "�����ƥ�����ԤΥ�������Ȥ�ɬ�פǤ�")
             (form (@ (action ?&) ?*)
		 (table
		  (tr 
		   (th "Login Name")
		   (td (input (@ (!permute
				  (value "")
				  (type "text")
				  (name "name")
                                  (id "focus"))))))
		  (tr
		   (th "Password")
		   (td (input (@ (!permute
				  (value "") 
				  (type "password")
				  (name "pass")))))))
		 (input (@ (!permute
			    (value "login")
			    (type "submit")
			    (name "submit"))))))
           ,*footer*))
        (call-worker/gsid w '() '() (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume system admin link click without admin role account"
	`(html
	  (head
	   (title ?_) (meta ?@) (link ?@) (script ?@))
	  (body
           ,*header*
           ,(*make-body*
             (h1 ?_)
             (h3 "�����ƥ�����ԤΥ�������Ȥ�ɬ�פǤ�")
             (form (@ (action ?&) ?*)
                   (table
                    (tr
                     (th "Login Name")
                     (td (input (@ (!permute
                                    (value "")
                                    (type "text")
                                    (name "name")
                                    (id "focus"))))))
                    (tr
                     (th "Password")
                     (td (input (@ (!permute
                                    (value "") 
                                    (type "password")
                                    (name "pass")))))))
                   (input (@ (!permute
                              (value "login")
                              (type "submit")
                              (name "submit"))))))
           ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '(("name" "cut-sea") ("pass" "cutsea"))
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume system admin link click with login"
	`(html
	  ,*head*
	  (body
           ,(*header-logedin* "kago")
           ,(*make-body*
             (h2 "����̼�������ƥ������������") (hr)
             (form ?@
                   (table
                    (thead "��Ͽ�桼������")
                    (tr (th "�����Ը���") (th "������̾") (th "�᡼�륢�ɥ쥹") (th "��ȯ") (th "�ܵ�") (th "��̩"))
                    (tr (td) (td "cut-sea") (td "cut-sea@kagoiri.org") (td "��") (td) (td))
                    (tr (td) (td "guest") (td) (td) (td) (td))
                    (tr (td "��") (td "kago") (td "cut-sea@kagoiri.org") (td "��") (td "��") (td)))
                   (table
                    (tr (th "�����Ը���") (th "������̾") (th "�ѥ����") (th "�᡼�륢�ɥ쥹") (th "��ȯ") (th "�ܵ�") (th "��̩"))
                    (tr (td (input (@ (type "checkbox") (name "admin"))))
                        (td (input (@ (type "text") (name "login-name"))))
                        (td (input (@ (type "password") (name "passwd"))))
                        (td (input (@ (type "text") (name "mail-address"))))
			(td (input (@ (type "checkbox") (name "devel"))))
			(td (input (@ (type "checkbox") (name "client"))))
                        (td (input (@ (type "checkbox") (name "delete")))))
                    (tr (td (input (@ (value "�ե�����Ͽ") (type "submit") (name "submit")))))))
             (hr)
             (form ?@
                   (table
                    (thead "��Ͽ��˥åȰ���")
                    (tr (th "��˥å�̾") (th "����") (th "��ư����"))))
             (hr)
             (form ?@
                   (table
                    (thead "��Ͽͥ���ٰ���")
                    (tr (th "ͥ����ID") (th "ɽ��̾") (th "��٥�") (th "̵��"))
                    (tr (td "high") (td "��") (td "4") (td))
                    (tr (td "low") (td "��") (td "2") (td))
                    (tr (td "normal") (td "����") (td "3") (td))
                    (tr (td "super") (td "Ķ��") (td "5") (td)))
                   (table
                    (tr (th "ͥ����ID") (th "ɽ��̾") (th "��٥�") (th "̵��"))
                    (tr (td (input (@ (type "text") (name "id"))))
                        (td (input (@ (type "text") (name "disp"))))
                        (td (select (@ (name "level"))
                                    (option (@ (value "1")) "1")
                                    (option (@ (value "2")) "2")
                                    (option (@ (value "3")) "3")
                                    (option (@ (value "4")) "4")
                                    (option (@ (value "5")) "5")))
                        (td (input (@ (type "checkbox") (name "delete")))))
                    (tr (td (input (@ (value "��Ͽ") (type "submit") (name "submit")))))))
             (hr)
             (form ?@
                   (table
                    (thead "��Ͽ���ơ���������")
                    (tr (th "���ơ�����ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td "completed") (td "COMPLETED") (td))
                    (tr (td "on-hold") (td "ON HOLD") (td))
                    (tr (td "open") (td "OPEN") (td))
                    (tr (td "rejected") (td "REJECTED") (td))
                    (tr (td "taken") (td "TAKEN") (td)))
                   (table
                    (tr (th "���ơ�����ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td (input (@ (type "text") (name "id"))))
                        (td (input (@ (type "text") (name "disp"))))
                        (td (input (@ (type "checkbox") (name "delete")))))
                    (tr (td (input (@ (value "��Ͽ") (type "submit") (name "submit")))))))
             (hr)
             (form ?@
                   (table
                    (thead "��Ͽ�����װ���")
                    (tr (th "������ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td "bug") (td "�Х�") (td))
                    (tr (td "discuss") (td "����") (td))
                    (tr (td "etc") (td "����¾") (td))
                    (tr (td "report") (td "���") (td))
                    (tr (td "request") (td "�ѹ���˾") (td))
                    (tr (td "task") (td "������") (td))
                    (tr (td "term") (td "�Ѹ�") (td)))
                   (table
                    (tr (th "������ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td (input (@ (type "text") (name "id"))))
                        (td (input (@ (type "text") (name "disp"))))
                        (td (input (@ (type "checkbox") (name "delete")))))
                    (tr (td (input (@ (value "��Ͽ") (type "submit") (name "submit")))))))
             (hr)
             (form ?@
                   (table
                    (thead "��Ͽ���ƥ������")
                    (tr (th "���ƥ���ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td "global") (td "����") (td))
                    (tr (td "infra") (td "����ե�") (td))
                    (tr (td "master") (td "�ޥ���") (td))
                    (tr (td "section") (td "���������") (td)))
                   (table
                    (tr (th "���ƥ���ID") (th "ɽ��̾") (th "̵��"))
                    (tr (td (input (@ (type "text") (name "id"))))
                        (td (input (@ (type "text") (name "disp"))))
                        (td (input (@ (type "checkbox") (name "delete")))))
                    (tr (td (input (@ (value "��Ͽ") (type "submit") (name "submit")))))))
             (hr)
             (form ?@
                   (table
                    (thead "����̼������")
                    (tr (th "����°��˥å�") (th "̼��No") (th "�����ȥ�") (th "������") (th "��ư����"))))
	     )
           ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '(("name" "kago") ("pass" "kago"))
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume logout"
	(header `((!contain ("Status" "302 Moved") (x-kahua-cgsid "logout"))))
	(call-worker/gsid
         w
         '()
         '(("name" "kago") ("pass" "kago"))
         header->sxml)
        test-sxml-match?)
 )

(test-end)