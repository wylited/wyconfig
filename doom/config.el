;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "wylited"
      user-mail-address "wylited@gmail.com")

;; Minimal UI
(package-initialize)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Org-Modern-mode config

(modify-all-frames-parameters
 '((right-divider-width . 40)
   (internal-border-width . 40)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-fold-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

(global-org-modern-mode)

; Edit defaults

(setq doom-theme 'doom-ayu-mirage ; theme
      doom-font (font-spec :family "FuraMono Nerd Font Mono" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Cousine Nerd Font" :size 24 :weight 'medium)
      display-line-numbers-type 'relative ; makes it easier to jump lines
      org-directory "~/org/") ; FIXME: Fix wylinotation location and possibly name

(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom") ; Nicer buffer names

(remove-hook 'window-setup-hook #'doom-init-theme-h)
(add-hook 'after-init-hook #'doom-init-theme-h 'append)
(delq! t custom-theme-load-path)

(setq-default
 delete-by-moving-to-trash t                    ; Deletes file to .trash
 window-combination-resize t                    ; Takes new window space from all other windows
 x-stretch-cursor t)                            ; Stretch color to glyph width

(setq undo-limit 80000000                       ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                     ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                       ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"              ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                 ; I can trust my computers ... can't I?
      scroll-margin 2)                          ; It's nice to maintain a little margin

; Modeline changes

(display-time-mode 1)                           ; Enable time in the mode-line

(unless (string-match-p "^Power N/A" (battery)) ; On laptops...
  (display-battery-mode 1))                     ; it's nice to know how much power you have

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

; Dashboard changes

(defun +doom-dashboard-setup-modified-keymap ()
  (setq +doom-dashboard-mode-map (make-sparse-keymap))
  (map! :map +doom-dashboard-mode-map
        :desc "Find file" :ne "f" #'find-file
        :desc "Recent files" :ne "r" #'consult-recent-file
        :desc "Config dir" :ne "C" #'doom/open-private-config
        :desc "Open dotfiles" :ne "." (cmd! (doom-project-find-file "~/.config/"))
        :desc "Notes (roam)" :ne "n" #'org-roam-node-find
        :desc "Set theme" :ne "t" #'consult-theme
        :desc "Quit" :ne "Q" #'save-buffers-kill-terminal
        :desc "Show keybindings" :ne "h" (cmd! (which-key-show-keymap '+doom-dashboard-mode-map))))

(add-transient-hook! #'+doom-dashboard-mode (+doom-dashboard-setup-modified-keymap))
(add-transient-hook! #'+doom-dashboard-mode :append (+doom-dashboard-setup-modified-keymap))
(add-hook! 'doom-init-ui-hook :append (+doom-dashboard-setup-modified-keymap))


; Edited keybinds

(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open) ; Doom dashboard is great and useful
(map! :leader :desc "yank" "y" #'yank) ; Fix pasting, (S-insertchar) doesn't work for

(map! :leader :desc "quick functions" "z")
(map! :leader :desc "open config" "z c" #'config)
(map! :leader :desc "open doom config" "z d" #'doomconfig)
(map! :leader :desc "sync config files" "z s" #'configsync)
(map! :leader :desc "open wynotes" "z w" #'wynotes)


; SVG-Tags
; from https://github.com/rougier/svg-tag-mode

; This replaces any occurence of :#TAG1:#TAG2:…:$ with a dyanmic collection of SVG tags.
(setq svg-tag-tags
      '(("\\(:[A-Z]+\\)\|[a-zA-Z#0-9]+:" . ((lambda (tag)
                                           (svg-tag-make tag :beg 1 :inverse t
                                                          :margin 0 :crop-right t))))
        (":[A-Z]+\\(\|[a-zA-Z#0-9]+:\\)" . ((lambda (tag)
                                           (svg-tag-make tag :beg 1 :end -1
                                                         :margin 0 :crop-left t))))))
; Replaces any occurence of :XXX|YYY: with two adjacent dynamic SVG tags displaying XXX and YYY
(setq svg-tag-tags
      '(("\\(:#[A-Za-z0-9]+\\)" . ((lambda (tag)
                                     (svg-tag-make tag :beg 2))))
        ("\\(:#[A-Za-z0-9]+:\\)$" . ((lambda (tag)
                                       (svg-tag-make tag :beg 2 :end -1))))))

; Replaces any occurence of :XXX: with a dynamic SVG tag displaying XXX
(setq svg-tag-tags
      '(("\\(:[A-Z]+:\\)" . ((lambda (tag)
                               (svg-tag-make tag :beg 1 :end -1))))))

; Custom functions

; Config
(defun config ()
  "switch to the config directory"
  (interactive)
  (find-file "~/wyconfig/README.md"))

(defun doomconfig ()
  "switch to the emacs config directory"
  (interactive)
  (find-file "~/wyconfig/doom/config.el")) ; NOTE: OMG its the file

(defun configsync ()
  "sync the ~/wyconfig directory to ~/.config"
  (interactive)
  (shell-command-on-region
   ;; beginning and end of buffer
   (point-min)
   (point-max)
   ;; command and parameters
   "rsync -a ~/wyconfig/ ~/.config/"
   ;; replace?

   ;; name of the error buffer
   "*rsync Error Buffer*"
   t)) ;; also consider that it is possible to run shell comands in emacs using M+!

; Notational velocity

(defun wynotes ()
  "switch to wynotes directory"
  (interactive)
  (find-file "~/Documents/wynotation/index.org")) ; FIXME: Is this name too long? could change to wynotes or wynotation

(defun header ()
  "insert header for notes"
  (interactive)
  )

;; Auto completion provided by my g copilot

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))
