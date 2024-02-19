
(setq wt-jira-url "https://jira.mongodb.org/browse")


(defun wiredtiger/browse-url ()
  "Browser to url at point, inferring the url if text at point
 matches different regexes."
  (interactive)
  (let ((target (thing-at-point 'symbol nil))
	(issue-re "\\(BACKPORT\\|BF\\|PM\\|WT\\|WTBUILD\\|SEAI\\|SERVER\\|HELP\\)-[[:digit:]]+"))
    (cond
     ((string-match issue-re target)
      (browse-url (format "%s/%s" wt-jira-url target)))
     (t (browse-url (thing-at-point 'url nil))))))


(defun wiredtiger/org-insert-jira-todo ()
  "Insert org todo item that references a jira ticket."
  (interactive)
  (let ((ticket-id (read-string "Jira issue: ")))
    (org-insert-todo-heading 1 t)
    (insert (org-link-make-string (format "%s/WT-%s" wt-jira-url ticket-id)
				  (format "WT-%s" ticket-id)))))

(require 'cc-mode)
(c-add-style "wiredtiger"
             '("bsd"
	       (c-indent-comments-syntactically t)
	       (indent-tabs-mode . nil)
	       (c-basic-offset . 4)
	       (c-offsets-alist
		(arglist-intro . *)
                (arglist-cont-nonempty . *))))

(add-to-list 'c-default-style '(other . "wiredtiger"))

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (setq fill-column 100
		  truncate-lines t)))
;	    (define-key c-mode-base-map (kbd "C-c g") 'marc/grep-project)))

(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(add-to-list 'tramp-connection-properties
             (list (regexp-quote "/ssh:.*")
                   "remote-shell" "/usr/bin/bash"))

(provide 'wiredtiger)
