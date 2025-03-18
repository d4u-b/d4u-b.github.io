;;; ORG MODE CONFIGURATION ;;;

;; Basic Setup
(require 'org)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; Directory & File Setup
(setq org-directory "~/org/")
(setq org-default-notes-file "~/org/inbox.org")

;; Define agenda files
(setq org-agenda-files '("~/org/inbox.org"
                         "~/org/gtd.org"
                         "~/org/work.org"
                         "~/org/personal.org"
                         "~/org/projects.org"))

;; Define archive location
(setq org-archive-location "~/org/archive/%s_archive::")

;; Task States
(setq org-todo-keywords
      '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i!)" "WAITING(w@/!)" "|" "DONE(d)" "CANCELED(c@/!)")))

;; Custom colors for TODO states
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("PLANNING" . (:foreground "orange" :weight bold))
        ("IN-PROGRESS" . (:foreground "light blue" :weight bold))
        ("WAITING" . (:foreground "magenta" :weight bold))
        ("DONE" . (:foreground "forest green" :weight bold))
        ("CANCELED" . (:foreground "gray" :weight bold))))

;; Logging
(setq org-log-done 'time)  ;; Log when tasks are completed
(setq org-log-into-drawer t)  ;; Put logs into LOGBOOK drawer
(setq org-log-reschedule 'note)  ;; Add note when rescheduling
(setq org-log-redeadline 'note)  ;; Add note when changing deadline
(setq org-log-note-clock-out t)  ;; Add note when clocking out

;; Task Priorities
(setq org-highest-priority ?A)
(setq org-lowest-priority ?C)
(setq org-default-priority ?B)
(setq org-priority-faces '((?A . (:foreground "red" :weight bold))
                          (?B . (:foreground "orange"))
                          (?C . (:foreground "yellow"))))

;; Tags
(setq org-tag-alist '((:startgroup)
                      ("@work" . ?w) ("@home" . ?h) ("@errands" . ?e)
                      ("@phone" . ?p) ("@computer" . ?c)
                      (:endgroup)
                      ("urgent" . ?u) ("project" . ?j) ("planning" . ?l)
                      ("study" . ?s) ("personal" . ?r) ("client" . ?t)
                      ("idea" . ?i) ("followup" . ?f) ("waiting" . ?a)))

;; Capture Templates
(setq org-capture-templates
      '(("t" "Todo" entry (file "~/org/inbox.org")
         "* TODO %?\n%i\n%U\n" :empty-lines 1)
        ("n" "Note" entry (file "~/org/inbox.org")
         "* %? :NOTE:\n%i\n%U\n" :empty-lines 1)
        ("m" "Meeting" entry (file+headline "~/org/work.org" "Meetings")
         "* %? :meeting:\n%^T\n\n** Attendees\n\n** Agenda\n\n** Notes\n\n" :empty-lines 1)
        ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n" :empty-lines 1)
        ("i" "Idea" entry (file+headline "~/org/personal.org" "Ideas")
         "* %? :idea:\n%i\n%U\n" :empty-lines 1)
        ("w" "Work Task" entry (file+headline "~/org/work.org" "Tasks")
         "* TODO %? :@work:\n%i\n%U\n" :empty-lines 1)
        ("p" "Personal Task" entry (file+headline "~/org/personal.org" "Tasks")
         "* TODO %? :@personal:\n%i\n%U\n" :empty-lines 1)
        ("P" "Project" entry (file+headline "~/org/projects.org" "Projects")
         "* TODO %? :project:\n%i\n%U\n** Project Goals\n\n** Tasks [/]\n\n" :empty-lines 1)))

;; Refile settings
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; Agenda Settings
(setq org-agenda-span 'week)
(setq org-agenda-start-on-weekday nil) ;; Start agenda on current day
(setq org-agenda-start-with-log-mode t)
(setq org-agenda-log-mode-items '(closed clock state))
(setq org-agenda-include-deadlines t)
(setq org-agenda-include-diary t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-todo-list-sublevels t)
(setq org-agenda-window-setup 'current-window)
(setq org-deadline-warning-days 7)
(setq org-agenda-block-separator "━━━━━━━━━━━━━━━━━━━━━━━━")

;; Agenda Format
(setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
                                 (todo . " %i %-12:c")
                                 (tags . " %i %-12:c")
                                 (search . " %i %-12:c")))

;; Custom Agenda Views
(setq org-agenda-custom-commands
      '(("d" "Daily Dashboard"
         ((agenda "" ((org-agenda-span 'day)
                      (org-agenda-start-day nil)))
          (tags-todo "+PRIORITY=\"A\""
                     ((org-agenda-overriding-header "❗ High Priority Tasks")))
          (tags-todo "+NEXT|+IN-PROGRESS"
                     ((org-agenda-overriding-header "⚡ Currently Working On")))
          (todo "WAITING"
                ((org-agenda-overriding-header "⏱️ Waiting For")))
          (tags-todo "+@home|+personal"
                     ((org-agenda-overriding-header "🏡 Personal Tasks")))
          (tags-todo "+@work|+client"
                     ((org-agenda-overriding-header "💼 Work Tasks")))))

        ("w" "Work Focus"
         ((agenda "" ((org-agenda-span 'day)
                      (org-agenda-start-day nil)
                      (org-agenda-tag-filter-preset '("+@work"))))
          (tags-todo "+@work+PRIORITY=\"A\""
                     ((org-agenda-overriding-header "High Priority Work")))
          (tags-todo "+@work-WAITING"
                     ((org-agenda-overriding-header "Work Tasks")))))

        ("p" "Project Overview"
         ((tags "project+LEVEL=2"
                ((org-agenda-overriding-header "🚀 Active Projects")))
          (tags-todo "project+LEVEL=3"
                     ((org-agenda-overriding-header "📋 Project Tasks")))))

        ("r" "Weekly Review"
         (
          ;;(stuck "")
          (todo "DONE"
                ((org-agenda-overriding-header "✅ Completed Tasks")
                 (org-agenda-files org-agenda-files)
                 (org-agenda-span 'week)
                 (org-agenda-start-day "-6d")))

          (todo "IN-PROGRESS"
                ((org-agenda-overriding-header "⚡ Currently Working On")))

          (todo "WAITING"
                ((org-agenda-overriding-header "⏱️  Waiting Tasks")))

          (todo "PLANNING"
                ((org-agenda-overriding-header "💼 Planning tasks")))))

        ("n" "Next Actions" todo "NEXT"
         ((org-agenda-overriding-header "⚡ Next Actions")))

        ("i" "Inbox" tags-todo "inbox"
         ((org-agenda-files '("~/org/inbox.org"))
          (org-agenda-overriding-header "📥 Inbox")))))

;; Clock settings
(setq org-clock-persist t)
(setq org-clock-in-resume t)
(setq org-clock-persist-query-resume nil)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-report-include-clocking-task t)
(org-clock-persistence-insinuate)

;; Time tracking
(setq org-time-stamp-custom-formats '("<%Y-%m-%d %a>" . "<%Y-%m-%d %a %H:%M>"))
(setq org-agenda-time-grid '((daily today require-timed)
                           (800 1000 1200 1400 1600 1800 2000)
                           "......" "----------------"))

;; Org habits
(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 80)
(setq org-habit-preceding-days 21)
(setq org-habit-following-days 7)
(setq org-habit-show-habits-only-for-today t)

;; Org appearance
(setq org-hide-leading-stars t)
(setq org-startup-indented t)
(setq org-startup-folded t)
(setq org-pretty-entities t)
(setq org-ellipsis " ↴") ;; Show this when headings are folded

;; Add special highlight for NEXT, WAITING, etc.
(font-lock-add-keywords 'org-mode
                        '(("\\(\\b\\(NEXT\\|IN-PROGRESS\\|WAITING\\)\\b\\)"
                           1 '((:foreground "red") (:weight bold)) t)))

;; Export settings
(setq org-export-with-toc t)
(setq org-export-with-section-numbers t)
(setq org-export-with-smart-quotes t)
(setq org-export-with-sub-superscripts '{})
(setq org-html-validation-link nil)

;; Hook to enable auto-fill-mode in org-mode
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'hl-line-mode)
(add-hook 'org-agenda-mode-hook 'hl-line-mode)

;; Enable org-indent-mode by default
(add-hook 'org-mode-hook 'org-indent-mode)

;; Install useful packages for org-mode
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


;; For linking to web browsers, PDFs, etc.
(use-package org-noter
  :ensure t
  :after org)

;; Improved org-mode keys
(define-key global-map (kbd "C-c o a") 'org-agenda)
(define-key global-map (kbd "C-c o c") 'org-capture)
(define-key global-map (kbd "C-c o b") 'org-switchb)
(define-key global-map (kbd "C-c o l") 'org-store-link)
(define-key global-map (kbd "C-c o r") 'org-refile)
(define-key global-map (kbd "C-c o i") 'org-clock-in)
(define-key global-map (kbd "C-c o o") 'org-clock-out)
