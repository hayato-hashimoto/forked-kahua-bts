;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: test4.scm,v 1.30 2006/02/12 03:05:17 cut-sea Exp $

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

(test-start "kagoiri-musume operate unit&musume&melody")

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
		(a ?@ "�����ƥ����")
		(a (@ (href ?&) ?*) "��˥åȰ���")
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

 (test* "kagoiri-musume unit-list link click without login"
	'(*TOP*
	  (form (@ (action ?&) ?*)
		(table (tr (th "Login Name")
			   (td (input (@ (value "") (type "text") (name "name") (id "focus")))))
		       (tr (th "Password")
			   (td (input (@ (value "") (type "password") (name "pass"))))))
		(input (@ (value "login") (type "submit") (name "submit")))))
	(call-worker/gsid->sxml w '() '() '(// form))
	(make-match&pick w))

 (test* "kagoiri-musume unit-list link click with login"
	`(html
	  ,*head*
	  (body (div ?@
		     (h1 ?@ ?_)
		     (a ?@ "�����ƥ����")
		     (a ?@ "��˥åȰ���")
		     (a ?@ "�ѥ�����ѹ�")
		     (span " Now login:" (a ?@ "cut-sea"))
		     (a ?@ "Logout")
		     (form ?@ (input ?@) (input ?@)))
		(div ?@
		     (h2 "��˥åȰ���")
		     (table ?@
			    (thead (tr (th) (th "��˥å�̾") (th "����") (th "�ե���") (th "����")))
			    (tbody))
		     (hr)
		     (h2 "����˥åȷ���")
		     (form (@ (action ?&) ?*)
			   (table
			    (tr ?@
				(th ?@ (span ?@ "ͥ����"))
				(th ?@ (span ?@ "���ơ�����"))
				(th ?@ (span ?@ "������"))
				(th ?@ (span ?@ "���ƥ���")))
			    (tr (td (select ?@
					    (option (@ (value "high")) "��")
					    (option (@ (value "low")) "��")
					    (option (@ (value "normal")) "����")
					    (option (@ (value "super")) "Ķ��")))
				(td (div ?@ "��")
				    (div ?@ "��"))
				(td (select ?@
					    (option (@ (value "completed")) "COMPLETED")
					    (option (@ (value "on-hold")) "ON HOLD")
					    (option (@ (value "open")) "OPEN")
					    (option (@ (value "rejected")) "REJECTED")
					    (option (@ (value "taken")) "TAKEN")))
				(td (div ?@ "��")
				    (div ?@ "��"))
				(td (select ?@
					    (option (@ (value "bug")) "�Х�")
					    (option (@ (value "discuss")) "����")
					    (option (@ (value "etc")) "����¾")
					    (option (@ (value "report")) "���")
					    (option (@ (value "request")) "�ѹ���˾")
					    (option (@ (value "task")) "������")
					    (option (@ (value "term")) "�Ѹ�")))
				(td (div ?@ "��")
				    (div ?@ "��"))
				(td (select ?@
					    (option (@ (value "global")) "����")
					    (option (@ (value "infra")) "����ե�")
					    (option (@ (value "master")) "�ޥ���")
					    (option (@ (value "section")) "���������")))
				(td (div ?@ "��")
				    (div ?@ "��"))))
			   (table
			    (tr
			     (td "��˥å�̾" (span (|@| (class "warning")) "(��)"))
			     (td (textarea (|@| (type "text") (rows "1") (name "name") (cols "32")))))
			    (tr
			     (td "����")
			     (td (|@| (colspan "2")) (textarea (|@| (type "text") (rows "10") (name "desc") (cols "80")))))
			    (tr ?@
				(td "�ե���" (span ?@ "(��)"))
				(td
				 (table
				  (tr
				   (td (select ?@
					       (option (@ (value "   ")))
					       (option (@ (value "cut-sea")) "cut-sea")
					       (option (@ (value "guest")) "guest")
					       (option (@ (value "kago")) "kago")))
				   (td (div ?@ "��")
				       (div ?@ "��"))))))
                            (tr (td "���Υ��ɥ쥹") (td (textarea ?@) ?*)))
			   (input (@ (value "����˥åȷ���") (type "submit")))))
		,*footer*))
	(call-worker/gsid w
			  '()
			  '(("name" "cut-sea") ("pass" "cutsea"))
			  (lambda (h b) (tree->string b)))
	(make-match&pick w))

 (test/send&pick "kagoiri-musume add new unit"
                 w
                 '(("priority" "normal" "low" "high")
		   ("status" "open" "completed")
		   ("type" "bug" "task" "request")
		   ("category" "global" "section")
		   ("name" "����̼��Test Proj.")
		   ("desc" "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
		   ("fans" "   " "cut-sea")))

 (test* "kagoiri-musume check new unit"
	`(*TOP*
	  (table ?@
		 (thead (tr (th) (th "��˥å�̾") (th "����") (th "�ե���") (th "����")))
		 (tbody (tr ?@
			    (td (a (@ (href ?&)) "����"))
			    (td (a ?@ "����̼��Test Proj.") " (0)")
			    (td "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
			    (td "cut-sea")
                            (td (a ?@ "��"))))))
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
	 '(// body div table))
        (make-match&pick w))

 (test* "kagoiri-musume edit unit"
	`(html
	  ,*head*
	  (body
	   (div ?@ (h1 ?@ "����̼�� - Groupie System")
		(a ?@ "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "�ѥ�����ѹ�")
		(span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
		(form ?@ (input ?@) (input ?@)))
	   (div ?@ (h2 "������̼��Test Proj.�٥�˥å�����")
		(form (@ (action ?&) ?*)
		      (table
		       (tr ?@
			   (th ?@ (span ?@ "ͥ����"))
			   (th ?@ (span ?@ "���ơ�����"))
			   (th ?@ (span ?@ "������"))
			   (th ?@ (span ?@ "���ƥ���")))
		       (tr
			(td (select ?@
				    (option (@ (value "normal") (selected "#t")) "����")
				    (option (@ (value "low") (selected "#t")) "��")
				    (option (@ (value "high") (selected "#t")) "��")
				    (option (@ (value "super")) "Ķ��")))
			(td (div ?@ "��")
			    (div ?@ "��"))
			(td (select ?@
				    (option (@ (value "open") (selected "#t")) "OPEN")
				    (option (@ (value "completed") (selected "#t")) "COMPLETED")
				    (option (@ (value "on-hold")) "ON HOLD")
				    (option (@ (value "rejected")) "REJECTED")
				    (option (@ (value "taken")) "TAKEN")))
			(td (div ?@ "��")
			    (div ?@ "��"))
			(td (select ?@
				    (option (@ (value "bug") (selected "#t")) "�Х�")
				    (option (@ (value "task") (selected "#t")) "������")
				    (option (@ (value "request") (selected "#t")) "�ѹ���˾")
				    (option (@ (value "discuss")) "����")
				    (option (@ (value "etc")) "����¾")
				    (option (@ (value "report")) "���")
				    (option (@ (value "term")) "�Ѹ�")))
			(td (div ?@ "��")
			    (div ?@ "��"))
			(td (select ?@
				    (option (@ (value "global") (selected "#t")) "����")
				    (option (@ (value "section") (selected "#t")) "���������")
				    (option (@ (value "infra")) "����ե�")
				    (option (@ (value "master")) "�ޥ���")))
			(td (div ?@ "��")
			    (div ?@ "��"))))
		      (table
		       (tr (td "��˥å�̾" (span ?@ "(��)"))
			   (td (textarea ?@ "����̼��Test Proj.")))
		       (tr (td "����")
			   (td ?@ (textarea ?@ "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")))
		       (tr ?@
			   (td "�ե���" (span ?@ "(��)"))
			   (td
			    (table
			     (tr (td (select ?@
					     (option (@ (value "   ") (selected "#t")))
					     (option (@ (value "cut-sea") (selected "#t")) "cut-sea")
					     (option (@ (value "guest")) "guest")
					     (option (@ (value "kago")) "kago")))
				 (td (div ?@ "��")
				     (div ?@ "��"))))))
                       (tr (td "���Υ��ɥ쥹") (td (textarea ?@) ?*)))
		      (input ?@)))
	   ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '()
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test/send&pick "kagoiri-musume modify unit setting"
                 w
                 '(("priority" "normal" "super" "high")
		   ("status" "open" "on-hold" "completed")
		   ("type" "task" "request" "discuss")
		   ("category" "master" "infra" "global" "section")
		   ("name" "����̼��Test Project.")
		   ("desc" "����̼���ΥХ��ȥ�å��󥰤ȥ������ޥ͡������Ȥ�Ԥ���˥å�")
		   ("fans" "   " "cut-sea" "guest")))

 (test* "kagoiri-musume check modified unit"
	`(*TOP*
	  (table ?@
		 (thead (tr (th) (th "��˥å�̾") (th "����") (th "�ե���") (th "����")))
		 (tbody (tr ?@
			    (td (a ?@ "����"))
			    (td (a (@ (href ?&) ?*) "����̼��Test Project.") " (0)")
			    (td "����̼���ΥХ��ȥ�å��󥰤ȥ������ޥ͡������Ȥ�Ԥ���˥å�")
			    (td "cut-sea , guest")
                            (td (a ?@ "��"))))))
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
	 '(// body div table))
        (make-match&pick w))

 (test* "kagoiri-musume view unit's empty musume-list"
	`(html
	  ,*head*
	  (body
	   (div ?@
		(h1 ?@ "����̼�� - Groupie System")
		(a ?@ "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "�ѥ�����ѹ�")
		(span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
		(form ?@ (input ?@) (input ?@)))
	   (div ?@
		(ul ?@
		    (li (a ?@ "̼������"))
		    (li (a (@ (href ?&) ?*) "������̼��")))
		(div ?@
		     (form ?@ (input ?@) "��˥å��⸡��:"
			   (input ?@)
			   (input (@ (value "����") (type "submit")))))
		(h2 "����̼��Test Project. - ̼������")
		(form ?@
		      (table ?@
			     (tr ?@
				 (th (span ?@ "ͥ����"))
				 (th (span (@ (class "clickable")) "���ơ�����"))
				 (th (span (@ (class "clickable")) "������"))
				 (th (span (@ (class "clickable")) "���ƥ���"))
				 (th (span (@ (class "clickable")) "��������"))
				 (th "ɽ�����"))
			     (tr ?@
				 (td (select (@ (onchange ?_) (name "priority"))
					     (option (@ (value "*all*")) "����")
					     (option (@ (value "normal")) "����")
					     (option (@ (value "super")) "Ķ��")
					     (option (@ (value "high")) "��")))
				 (td (select (@ (onchange ?_) (name "status"))
					     (option (@ (value "*all*")) "����")
					     (option (@ (value "open")) "OPEN")
					     (option (@ (value "on-hold")) "ON HOLD")
					     (option (@ (value "completed")) "COMPLETED")))
				 (td (select (@ (onchange ?_) (name "type"))
					     (option (@ (value "*all*")) "����")
					     (option (@ (value "task")) "������")
					     (option (@ (value "request")) "�ѹ���˾")
					     (option (@ (value "discuss")) "����")))
				 (td (select (@ (onchange ?_) (name "category"))
					     (option (@ (value "*all*")) "����")
					     (option (@ (value "master")) "�ޥ���")
					     (option (@ (value "infra")) "����ե�")
					     (option (@ (value "global")) "����")
					     (option (@ (value "section")) "���������")))
				 (td (select (@ (onchange ?_) (name "assign"))
					     (option (@ (value "*all*")) "����")
					     (option (@ (value "   ")))
					     (option (@ (value "cut-sea")) "cut-sea")
					     (option (@ (value "guest")) "guest")))
				 (td (select (@ (name "limit"))
					     (option (@ (value "")))
					     (option (@ (value "20")) "20")
					     (option (@ (value "50")) "50")
					     (option (@ (value "200") (selected "true")) "200")
					     (option (@ (value "500")) "500")
					     (option (@ (value "1000")) "1000")))
				 (td (input (@ (value "�ʤ����") (type "submit") (name "submit"))))))
		      (table ?@
			     (thead "˨������̼�������ޤ���(T^T)"
				    (div ?@
					 (span (a ?@ "OPEN") "(0) ")
					 (span (a ?@ "ON HOLD") "(0) ")
					 (span (a ?@ "COMPLETED") "(0) "))
				    (tr ?@
					(th)
					(th ?@ "No.")
					(th ?@ "�����ȥ�")
					(th ?@ "ͥ����")
					(th ?@ "���ơ�����")
					(th ?@ "������")
					(th ?@ "���ƥ���")
					(th ?@ "��������")
					(th ?@ "����")
					(th ?@ "��Ͽ��")
					(th ?@ "������"))) (tbody))))
	   ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '()
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume musume-new link click"
	`(html
	  ,*head*
	  (body
	   (div ?@ (h1 ?@ "����̼�� - Groupie System")
		(a ?@ "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "�ѥ�����ѹ�")
		(span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
		(form ?@ (input ?@) (input ?@)))
	   (div ?@
		(ul ?@
		    (li (a ?@ "̼������"))
		    (li (a ?@ "������̼��")))
		(h2 "����̼��Test Project. - ������̼��")
		(form (@ (action ?&) ?*)
		      (table
		       (tr
			(td
			 (table
			  (tr (th "ͥ����")
			      (th "���ơ�����")
			      (th "������")
			      (th "���ƥ���")
			      (th "��������"))
			  (tr
			   (td
			    (select (@ (name "priority"))
				    (option (@ (value "normal")) "����")
				    (option (@ (value "super")) "Ķ��")
				    (option (@ (value "high")) "��")))
			   (td
			    (select (@ (name "status"))
				    (option (@ (value "open")) "OPEN")
				    (option (@ (value "on-hold")) "ON HOLD")
				    (option (@ (value "completed")) "COMPLETED")))
			   (td
			    (select (@ (name "type"))
				    (option (@ (value "task")) "������")
				    (option (@ (value "request")) "�ѹ���˾")
				    (option (@ (value "discuss")) "����")))
			   (td
			    (select (@ (name "category"))
				    (option (@ (value "master")) "�ޥ���")
				    (option (@ (value "infra")) "����ե�")
				    (option (@ (value "global")) "����")
				    (option (@ (value "section")) "���������")))
			   (td
			    (select (@ (name "assign"))
				    (option (@ (value "   ")))
				    (option (@ (value "cut-sea")) "cut-sea")
				    (option (@ (value "guest")) "guest")))
			   (td
			    (input (@ (value "������̼������") (onclick "submit();") (type "button")))))))
			(td ?@ (table ?*)))
		       (tr (td
			    (table
			     (tr
			      (td "�����ȥ�" (span ?@ "(��)"))
			      (td (input (@ (!permute (type "text") (name "name") ?*)))))
			     (tr (td "����")
				 (td (textarea (@ (!permute (type "text") (name "melody") ?*)))))
			     (tr (td "�ե�����")
				 (td (input (@ (type "file") (name "file")))
				     (input (@ (value "") (type "hidden") (name "filename"))))))))
		       (tr (td
			    (input (@ (value "������̼������") (onclick "submit();") (type "button"))))))))
	   ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '()
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test/send&pick "kagoiri-musume musume-new create"
                 w
                 '(("priority" "high")
		   ("status" "open")
		   ("type" "task")
		   ("category" "global")
		   ("name" "�ƥ��Ȥ�̼��")
		   ("melody" "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�")
		   ("assign" "cut-sea")))

 (test* "kagoiri-musume check melody-list"
	`(html
	  ,*head*
	  (body
	   (div ?@ (h1 ?@ "����̼�� - Groupie System")
		(a ?@ "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "�ѥ�����ѹ�")
		(span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
		(form ?@ (input ?@) (input ?@)))
	   (div ?@
		(ul ?@
		    (li (a ?@ "̼������"))
		    (li (a ?@ "������̼��")))
                (a ?@ "�֥å��ޡ������ɲ�")
		(div (a ?@ "<<")
		     (a ?@ ">>"))
		(h3 "����̼��Test Project. - 1���ƥ��Ȥ�̼�� - OPEN")
		(form (@ (action ?&) ?*)
		      (table
		       (tr
			(td
			 (table
			  (tr
			   (th "ͥ����")
			   (th "���ơ�����")
			   (th "������")
			   (th "���ƥ���")
			   (th "��������"))
			  (tr
			   (td
			    (select (@ (name "priority"))
				    (option (@ (value "normal")) "����")
				    (option (@ (value "super")) "Ķ��")
				    (option (@ (value "high") (selected "true")) "��")))
			   (td
			    (select (@ (name "status"))
				    (option (@ (value "open") (selected "true")) "OPEN")
				    (option (@ (value "on-hold")) "ON HOLD")
				    (option (@ (value "completed")) "COMPLETED")))
			   (td
			    (select (@ (name "type"))
				    (option (@ (value "task") (selected "true")) "������")
				    (option (@ (value "request")) "�ѹ���˾")
				    (option (@ (value "discuss")) "����")))
			   (td
			    (select (@ (name "category"))
				    (option (@ (value "master")) "�ޥ���")
				    (option (@ (value "infra")) "����ե�")
				    (option (@ (value "global") (selected "true")) "����")
				    (option (@ (value "section")) "���������")))
			   (td
			    (select (@ (name "assign"))
				    (option (@ (value "   ")))
				    (option (@ (value "cut-sea") (selected "true")) "cut-sea")
				    (option (@ (value "guest")) "guest")))
			   (td
			    (input (@ (value "���ߥå�") (type "submit")))))))
			(td ?@ (table ?*)))
		       (tr
			(td
			 (table ?@
				(tr (td "����")
				    (td (textarea (@ (!permute (type "text") (name "melody") ?*)))))
				(tr (td "�ե�����")
				    (td (input (@ (type "file") (name "file"))))))))))
		(dl ?@ 
		    (dt (span ?@ "��1.") (span ?@ ?_)
			(span ?@ "[cut-sea]")
			?*)
		    (dd (pre "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�"))))
	   ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '()
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test/send&pick "kagoiri-musume check melody-list"
                 w
                 '(("priority" "super")
		   ("status" "completed")
		   ("type" "discuss")
		   ("category" "section")
		   ("melody" "����������")
		   ("assign" "   ")))

 (test* "kagoiri-musume check melody-list complete"
	`(*TOP*
	  (div ?@ (h1 ?@ "����̼�� - Groupie System")
	       (a ?@ "�����ƥ����")
	       (a ?@ "��˥åȰ���")
	       (a ?@ "�ѥ�����ѹ�")
	       (span " Now login:" (a ?@ "cut-sea"))
	       (a ?@ "Logout")
	       (form ?@ (input ?@) (input ?@)))
	  (div ?@
	       (ul ?@
		   (li (a ?@ "̼������"))
		   (li (a ?@ "������̼��")))
               (a ?@ "�֥å��ޡ������ɲ�")
	       (div
		(a ?@ "<<")
		(a ?@ ">>"))
	       (h3 "����̼��Test Project. - 1���ƥ��Ȥ�̼�� - COMPLETED")
	       (form ?@
		     (table
		      (tr
		       (td
			(table
			 (tr (th "ͥ����") (th "���ơ�����") (th "������") (th "���ƥ���") (th "��������"))
			 (tr
			  (td
			   (select (@ (name "priority"))
				   (option (@ (value "normal")) "����")
				   (option (@ (value "super") (selected "true")) "Ķ��")
				   (option (@ (value "high")) "��")))
			  (td
			   (select (@ (name "status"))
				   (option (@ (value "open")) "OPEN")
				   (option (@ (value "on-hold")) "ON HOLD")
				   (option (@ (value "completed") (selected "true")) "COMPLETED")))
			  (td
			   (select (@ (name "type"))
				   (option (@ (value "task")) "������")
				   (option (@ (value "request")) "�ѹ���˾")
				   (option (@ (value "discuss") (selected "true")) "����")))
			  (td
			   (select (@ (name "category"))
				   (option (@ (value "master")) "�ޥ���")
				   (option (@ (value "infra")) "����ե�")
				   (option (@ (value "global")) "����")
				   (option (@ (value "section") (selected "true")) "���������")))
			  (td
			   (select (@ (name "assign"))
				   (option (@ (value "   ") (selected "true")))
				   (option (@ (value "cut-sea")) "cut-sea")
				   (option (@ (value "guest")) "guest")))
			  (td (input (@ (value "���ߥå�") (type "submit")))))))
		       (td ?@ (table ?*)))
		      (tr
		       (td
			(table ?@
			       (tr (td "����")
				   (td (textarea (@ (!permute (type "text") (name "melody") ?*)))))
			       (tr (td "�ե�����")
				   (td (input (@ (type "file") (name "file"))))))))))
	       (dl ?@
		   (dt (span ?@ "��2.") (span ?@ ?_) (span ?@ "[cut-sea]") ?*)
		   (dd (pre "����������")))
	       (dl ?@
		   (dt (span ?@ "��1.") (span ?@ ?_) (span ?@ "[cut-sea]") ?*)
		   (dd (pre "�ƥ��Ȥ򤹤�ɬ�פ�����ΤǤ���ʤ�"))))
	  ,*footer*)
        (call-worker/gsid->sxml
	 w
	 '()
	 '()
	 '(// body div))
        (make-match&pick w))

 )

(test-end)
