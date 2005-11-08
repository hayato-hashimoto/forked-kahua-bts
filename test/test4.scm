;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: test4.scm,v 1.6 2005/11/08 12:35:37 cut-sea Exp $

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

(test-start "kagoiri-musume operate admin-system parameters")

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
	   (body (div ?@
		      (h1 ?@ ?_)
		      (a ?@ "�ȥå�")
		      (a ?@ "�����ƥ����")
		      (a ?@ "��˥åȰ���")
		      (a ?@ "Login"))
		 ,(*make-body*
		   (h2 ?_)
		   (ul ?@
		       (li (a ?@ "�����ƥ������������"))
		       (li (a (@ (href ?&)) "��˥åȰ���"))))
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
		     (a ?@ "�ȥå�")
		     (a ?@ "�����ƥ����")
		     (a ?@ "��˥åȰ���")
		     (a ?@ "�ѥ�����ѹ�")
		     (span " Now login:" (a ?@ "cut-sea"))
		     (a ?@ "Logout")
		     (form ?@ "����:" (input ?@)))
		(div ?@
		     (h2 "��˥åȰ���")
		     (table ?@
			    (thead (tr (th) (th) (th "��˥å�̾") (th "����") (th "�ե���")))
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
					       (option (@ (value "kago")) "kago")))
				   (td (div ?@ "��")
				       (div ?@ "��")))))))
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
		 (thead (tr (th) (th) (th "��˥å�̾") (th "����") (th "�ե���")))
		 (tbody (tr ?@
			    (td (a (@ (href ?&)) "�Խ�"))
			    (td (a ?@ "���"))
			    (td (a ?@ "����̼��Test Proj.") " (0)")
			    (td "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")
			    (td "cut-sea")))))
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
		(a ?@ "�ȥå�")
		(a ?@ "�����ƥ����")
		(a ?@ "��˥åȰ���")
		(a ?@ "�ѥ�����ѹ�")
		(span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
		(form ?@ "����:" (input ?@)))
	   (div ?@ (h2 "������̼��Test Proj.�٥�˥å��Խ�")
		(hr)
		(form ?@
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
			   (td (textarea ?@ "����̼���ΥХ��ȥ�å��󥰤�Ԥ���˥å�")))
		       (tr ?@
			   (td "�ե���" (span ?@ "(��)"))
			   (td
			    (table
			     (tr (td (select ?@
					     (option (@ (value "   ") (selected "#t")))
					     (option (@ (value "cut-sea") (selected "#t")) "cut-sea")
					     (option (@ (value "kago")) "kago")))
				 (td (div ?@ "��")
				     (div ?@ "��")))))))
		      (input ?@)))
	   ,*footer*))
        (call-worker/gsid
	 w
	 '()
	 '()
	 (lambda (h b) (tree->string b)))
        (make-match&pick w))

 )

(test-end)
