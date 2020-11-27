(TeX-add-style-hook
 "polydep"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("llncs" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("nag" "l2tabu" "orthodox") ("inputenc" "utf8")))
   (TeX-run-style-hooks
    "latex2e"
    "nag"
    "llncs"
    "llncs12"
    "inputenc"
    "url"))
 :latex)

