;;; packages.el --- calendar layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Markus Johansson <markus.johansson@me.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

(defconst google-calendar-packages
  '(calfw
    calfw-org
    org-gcal
    alert))

(defun google-calendar/init-org-gcal ()
  "Initializes org-gcal and adds keybindings for it's exposed functions"
  (use-package org-gcal
    :init
    (progn
      (spacemacs/set-leader-keys
        "aGr" 'org-gcal-request-token
        "aGs" 'org-gcal-sync
        "aGd" 'org-gcal-delete-at-point
        "aGp" 'org-gcal-post-at-point
        "aGx" 'google-calendar/delete-and-sync-all
        "aGf" 'org-gcal-fetch))
    :config
    (add-hook 'after-init-hook 'org-gcal-fetch)
    (add-hook 'kill-emacs-hook 'org-gcal-sync)
    (add-hook 'org-capture-after-finalize-hook 'google-calendar/sync-cal-after-capture)
    (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync)))
    (run-with-idle-timer 600 t 'google-calendar/org-gcal-update)))

(defun google-calendar/init-calfw ()
  "Initialize calfw"

  (use-package calfw
    :defer t
    :commands (cfw:open-calendar-buffer)
    :init
    (spacemacs/set-leader-keys "AC" 'cfw:open-calendar-buffer)
    (evil-set-initial-state 'cfw:calendar-mode 'normal)
    (defvar calfw-org-agenda-view "a"
      "Key for opening the current week or day view in org-agenda.")

    (defvar calfw-window-conf nil
      "Current window config")

    (defcustom calfw-restore-windows-after-quit 't
      "Non-nil means restore window configuration upon exiting calfw calendar view.
The window configuration is stored when entering calendar view.
When the view is exited and this option is set the previous layout is restored."
      :type 'boolean)

    (defcustom calfw-calendar-window-setup 'only-window
      "How the calfw calendar buffer should be displayed. This variable overrides org-agenda-window-setup.
Possible values for this option are:

current-window              Show calendar in the current window, keeping all other windows.
other-window                Use `switch-to-buffer-other-window' to display calendar.
only-window                 Show calendar, deleting all other windows.
reorganize-frame            Show only two windows on the current frame, the current
                            window and the calendar.
other-frame                 Use `switch-to-buffer-other-frame' to display calendar.
                            Also, when exiting the calendar, kill that frame. "
      :type '(choice
              (const current-window)
              (const other-frame)
              (const other-window)
              (const only-window)
              (const reorganize-frame)))

    :config
    (progn
      (evil-make-overriding-map cfw:calendar-mode-map)
      (define-key cfw:calendar-mode-map (kbd "SPC") 'spacemacs-cmds)
      (define-key cfw:calendar-mode-map (kbd "TAB") 'cfw:show-details-command)
      (define-key cfw:calendar-mode-map (kbd "C-j") 'cfw:navi-next-item-command)
      (define-key cfw:calendar-mode-map (kbd "C-k") 'cfw:navi-prev-item-command)
      (define-key cfw:calendar-mode-map "N" 'cfw:navi-next-month-command)
      (define-key cfw:calendar-mode-map "P" 'cfw:navi-previous-month-command)
      (define-key cfw:calendar-mode-map "c" 'cfw:org-capture)
      (define-key cfw:calendar-mode-map "v" 'cfw:org-open-agenda-day))))

(defun google-calendar/init-calfw-org ()
  "Initialize calfw-org and add key-bindings"
  (use-package calfw-org
    :defer t
    :commands (cfw:open-org-calendar)
    :init
    (spacemacs/set-leader-keys
      "aGc" 'google-calendar/calfw-view)
    (spacemacs/declare-prefix "aGc" "open-org-calendar")
    (add-hook 'cfw:calendar-mode-hook (lambda () (org-gcal-sync)))

    :config
    (define-key cfw:org-schedule-map "q" 'google-calendar/calfw-restore-windows)

(defun google-calendar/init-alert ()
  "Initialize alert"
  (use-package alert
    :defer t))
;;; packages.el ends here
