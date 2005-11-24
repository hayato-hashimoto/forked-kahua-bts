;; -*- coding: euc-jp; mode: scheme -*-
;;
;;  Copyright (c) 2005 Kahua.Org, All rights reserved.
;;  See COPYING for terms and conditions of using this software
;;
;; $Id: test2.scm,v 1.13 2005/11/24 16:42:59 shibata Exp $

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

 (test* "kagoiri-musume top2"
	`(html
	  ,*head*
	  (body (div ?@
                     (h1 ?@ ?_)
		     (a ?@ "�ȥå�")
		     (a ?@ "�����ƥ����")
		     (a (@ (href ?&)) "��˥åȰ���")
		     (a ?@ "Login"))
                ,(*make-body*
                  (h2 ?_)
                  (ul ?@
                   (li (a ?@ "�����ƥ������������"))
                   (li (a ?@ "��˥åȰ���"))))
                ,*footer*))
        (call-worker/gsid w '() '() (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume unit-list link click without login"
	`(html
	  ,*head*
	  (body
           ,*header*
           ,(*make-body*
             (h1 "����̼���ؤ褦������")
             (h3 "��˥åȰ����ϰ��̥桼����������Ȥ�ɬ�פǤ�")
             (form (@ (action ?&) ?*)
                   (table
                    (tr (th "Login Name") (td (input (@ (value "") (type "text") (name "name") (id "focus")))))
                    (tr (th "Password") (td (input (@ (value "") (type "password") (name "pass"))))))
                   (input (@ (value "login") (type "submit") (name "submit")))))
           ,*footer*))
        (call-worker/gsid w '() '() (lambda (h b) (tree->string b)))
        (make-match&pick w))

 (test* "kagoiri-musume unit-list link click with login"
	`(html
	  ,*head*
	  (body
	   (div ?@
                (h1 ?@ ?_)
		(a ?@ "�ȥå�")
		(a ?@ "�����ƥ����")
                (a ?@ "��˥åȰ���")
		(a (@ (href ?&)) "�ѥ�����ѹ�")
                (span " Now login:" (a ?@ "cut-sea"))
		(a ?@ "Logout")
                (form ?@ "����:" (input ?@)))
           ,(*make-body*
             (h2 "��˥åȰ���")
             (table
              ?@
              (thead (tr (th) (th) (th "��˥å�̾") (th "����") (th "�ե���") (th "����")))
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
                    (tr
                     (td (select (@ (size "5")
                                    (name "priority")
                                    (multiple "true")
                                    (id "priority"))
                                 (!permute
                                  (option (@ (value "high")) "��")
                                  (option (@ (value "low")) "��")
                                  (option (@ (value "normal")) "����")
                                  (option (@ (value "super")) "Ķ��"))))
                     (td ?*)
                     (td (select (@ (size "5") (name "status") (multiple "true") (id "status"))
                                 (!permute
                                  (option (@ (value "completed")) "COMPLETED")
                                  (option (@ (value "on-hold")) "ON HOLD")
                                  (option (@ (value "open")) "OPEN")
                                  (option (@ (value "rejected")) "REJECTED")
                                  (option (@ (value "taken")) "TAKEN"))))
                     (td ?*)
                     (td (select (@ (size "5") (name "type") (multiple "true") (id "type"))
                                 (!permute
                                  (option (@ (value "bug")) "�Х�")
                                  (option (@ (value "discuss")) "����")
                                  (option (@ (value "etc")) "����¾")
                                  (option (@ (value "report")) "���")
                                  (option (@ (value "request")) "�ѹ���˾")
                                  (option (@ (value "task")) "������")
                                  (option (@ (value "term")) "�Ѹ�"))))
                     (td ?*)
                     (td (select (@ (size "5") (name "category") (multiple "true") (id "category"))
                                 (!permute
                                  (option (@ (value "global")) "����")
                                  (option (@ (value "infra")) "����ե�")
                                  (option (@ (value "master")) "�ޥ���")
                                  (option (@ (value "section")) "���������"))))
                     (td ?*)))
                   (table
                    (tr (td "��˥å�̾" ?_) (td (textarea ?@) ?*))
                    (tr (td "����") (td (@ (colspan "2")) (textarea ?@)))
                    (tr (@ (align "left"))
                        (td "�ե���" ?_)
                        (td
                         (table (tr (td
                                     (select ?@
                                             (option (@ (value "   ")))
                                             (option (@ (value "cut-sea")) "cut-sea")
					     (option (@ (value "guest")) "guest")
                                             (option (@ (value "kago")) "kago")))
                                    (td ?*)))))
                    (tr (td "���Υ��ɥ쥹") (td (textarea ?@) ?*)))
                   (input (@ (!permute
                              (value "����˥åȷ���")
                              (type "submit"))))))
           ,*footer*))
        (call-worker/gsid w
			  '()
			  '(("name" "cut-sea") ("pass" "cutsea"))
			  (lambda (h b) (tree->string b)))
        (make-match&pick w))

(test* "kagoiri-musume click change password"
       `(html
	 ,*head*
	 (body
	  ,(*header-logedin* "cut-sea")
          ,(*make-body*
            (h3 "cut-sea ����Υѥ�����ѹ�")
            (form (@ (action ?&) ?*)
                  (table
                   (tr (th "��ѥ����")
                       (td (input (@ (!permute (value "") (type "password") (name "old-pw") (id "focus"))))))
                   (tr (th "���ѥ����")
                       (td (input (@ (!permute (value "") (type "password") (name "new-pw"))))))
                   (tr (th "���ѥ����(��ǧ)")
                       (td (input (@ (!permute (value "") (type "password") (name "new-again-pw")))))))
                  (input (@ (!permute (value "�ѹ�") (type "submit") (name "submit"))))
                  (p (@ (class "warning")) ?*)))
          ,*footer*))
        (call-worker/gsid w
			  '()
			  '(("name" "cut-sea") ("pass" "cutsea"))
			  (lambda (h b) (tree->string b)))
        (make-match&pick w))

(test* "kagoiri-musume change password with bad new-password"
       '(*TOP*
	 ?*
	 (form (@ (action ?&) ?*)
	       (table
		(tr (th "��ѥ����")
		    (td (input (@ (!permute (value "") (type "password") (name "old-pw") (id "focus"))))))
		(tr (th "���ѥ����")
		    (td (input (@ (!permute (value "") (type "password") (name "new-pw"))))))
		(tr (th "���ѥ����(��ǧ)")
		    (td (input (@ (!permute (value "") (type "password") (name "new-again-pw")))))))
	       (input (@ (!permute (value "�ѹ�") (type "submit") (name "submit"))))
	       (p (@ (class "warning")) "���ѥ���ɤ������Ǥ�"))
	 ?*
	 )
       (call-worker/gsid->sxml w
			       '()
			       '(("old-pw" "cutsea") ("new-pw" "badsea") ("new-again-pw" "newsea"))
			       '(// form))
       (make-match&pick w))

(test* "kagoiri-musume change password with bad old-password"
       '(*TOP*
	 ?*
	 (form (@ (action ?&) ?*)
		(table
		 (tr (th "��ѥ����")
		     (td (input (@ (!permute (value "") (type "password") (name "old-pw") (id "focus"))))))
		 (tr (th "���ѥ����")
		     (td (input (@ (!permute (value "") (type "password") (name "new-pw"))))))
		 (tr (th "���ѥ����(��ǧ)")
		     (td (input (@ (!permute (value "") (type "password") (name "new-again-pw")))))))
		(input (@ (!permute (value "�ѹ�") (type "submit") (name "submit"))))
		(p (@ (class "warning")) "��ѥ���ɤ������Ǥ�"))
	 ?*
	 )
        (call-worker/gsid->sxml w
			       '()
			       '(("old-pw" "badsea") ("new-pw" "newsea") ("new-again-pw" "newsea"))
			       '(// form))
        (make-match&pick w))

(test* "kagoiri-musume change password with good password"
       `(html
	 ,*head*
	 (body
	  (div ?@
           (h1 ?@ ?_)
           (a ?@ "�ȥå�")
           (a ?@ "�����ƥ����")
           (a ?@ "��˥åȰ���")
           (a (@ (href ?&)) "�ѥ�����ѹ�")
           (span " Now login:" (a ?@ "cut-sea"))
           (a ?@ "Logout")
           (form ?@ "����:" (input ?@)))
	  ,(*make-body*
            (div ?@ (h3 "cut-sea ����Υѥ���ɤ��ѹ����ޤ���")))
          ,*footer*))
       (call-worker/gsid w
			 '()
			 '(("old-pw" "cutsea") ("new-pw" "goodsea") ("new-again-pw" "goodsea"))
			 (lambda (h b) (tree->string b)))
       (make-match&pick w))

(test* "kagoiri-musume change password again"
       '(*TOP*
	 ?*
	 (form (@ (action ?&) ?*)
		(table
		 (tr (th "��ѥ����")
		     (td (input (@ (!permute (value "") (type "password") (name "old-pw") (id "focus"))))))
		 (tr (th "���ѥ����")
		     (td (input (@ (!permute (value "") (type "password") (name "new-pw"))))))
		 (tr (th "���ѥ����(��ǧ)")
		     (td (input (@ (!permute (value "") (type "password") (name "new-again-pw")))))))
		(input (@ (!permute (value "�ѹ�") (type "submit") (name "submit"))))
		(p (@ (class "warning"))))
	 ?*
	 )
        (call-worker/gsid->sxml w
			       '()
			       '(("old-pw" "badsea") ("new-pw" "newsea") ("new-again-pw" "newsea"))
			       '(// form))
        (make-match&pick w))

(test* "kagoiri-musume change password back to original password"
       '(*TOP*
         ?*
	 (div ?@ (h3 "cut-sea ����Υѥ���ɤ��ѹ����ޤ���"))
         ?*)
       (call-worker/gsid->sxml w
			       '()
			       '(("old-pw" "goodsea") ("new-pw" "cutsea") ("new-again-pw" "cutsea"))
			       '(// div))
       (make-match&pick w))


 )

(test-end)
