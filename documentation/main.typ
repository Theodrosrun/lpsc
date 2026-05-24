#import "@preview/latexlike-report:1.0.0": *

#show: latexlike-report.with(
  // ======== Cover ============
  //Use content [] or none, except in author.
  author: "Andrè Costa & Theodros Mulugeta",
  title: [LPSC],
  subtitle: [Laboratoire],

  participants: [],

  affiliation: [Computer Science],
  year: [2026],
  class: [Master of Science HES - Engineering],
  other: none,

  date: [#datetime.today().display("[day].[month].[year]")],

  logo: image("images/logo.svg", width: 4cm),

  //==========Theme ===============
  theme-color: rgb("#000000"),
  lang: "fr",
  participants-supplement: "Auteurs:",


  //=========Font =================
  title-font: "New Computer Modern",
  font: "New Computer Modern",
  font-size: 13pt,
  font-weight: 400,

  //============ Math =============

  math-font: "New Computer Modern Math",
  math-weight: 400,
  math-ref-supplement: auto, //Use none for no supplement, auto for language based or any other function or string you like
  math-numbering: "(1.1)", // The numbering style you like

  // ---- Equate package ---
  // For more information, you can refer to equate documentation

  math-number-mode: "label", //Can be "label" or "line"
  math-sub-numbering: true, // true or false

  //===========Page style===============
  pagebreak-section: false, //For pagebreak after adding a new level one heading (=)
  show-outline: false, //true or false
  page-paper: "a4",

  //-----chic header package----
  // customize the left/center/right header and left/center/right footer
  // you can add images, text, the number of the current page, etc, or put none if you don't want some part of the header or footer.
  //some usefull function: chic-page-number(), chic-heading-name()

  h-l: [#smallcaps[GesSec - Labo 3]],
  h-r: [#image("images/logo.svg", width: 25%)],
  h-c: none,

  f-l: [],
  f-r: [],
  f-c: chic-page-number(),
  //=======================================
  //For more customitation you can check the documentation. !! Enjoy :D !!
)


///////////////////////////Document starts/////////////////////////////

TODO: Mesurer le nombre d'itérations avec vio
TODO: Ajouter les scripts de test

