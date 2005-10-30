;; -*- coding: euc-jp; mode: scheme -*-
;; test kagoiri-musume script.
;; $Id: test4.scm,v 1.1 2005/10/30 15:01:27 cut-sea Exp $

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
			   (td (input (@ (value "") (type "text") (name "name")))))
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
		     (form ?@
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
			   (input (@ (value "����˥åȷ���") (type "submit") (name "submit")))))
		,*footer*))
	(call-worker/gsid w
			  '()
			  '(("name" "cut-sea") ("pass" "cutsea"))
			  (lambda (h b) (tree->string b)))
	(make-match&pick w))

 )

(test-end)
