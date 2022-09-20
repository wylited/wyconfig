;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; https://github.com/doomemacs/doomemacs/blob/develop/core/templates/config.example.el

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "wylited"
      user-mail-address "wylited@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom's fault.

;; Minimal UI
(package-initialize)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Choose some fonts
;; (set-face-attribute 'default nil :family "Iosevka")
;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

;; Add frame borders and window dividers
;;q
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

(setq doom-theme 'doom-ayu-mirage
      doom-font (font-spec :family "FuraMono Nerd Font Mono" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Cousine Nerd Font" :size 24 :weight 'medium))

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

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

(display-time-mode 1)                           ; Enable time in the mode-line

(unless (string-match-p "^Power N/A" (battery)) ; On laptops...
  (display-battery-mode 1))                     ; it's nice to know how much power you have

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

(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)
