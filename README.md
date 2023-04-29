This is an R project created with projectR. 

Rationale:

Separate content and presentation. I dislike most of the markdown presentation formats because you end up with content interspersed with markdown fences (to delimit slides, etc.) and CSS (which I hate writing). I find it really confusing, and it means the value of the markdown approach - keeping it simple, focusing on content - seems really lost. 
There are some ways to use predefined layouts https://www.rostrum.blog/2020/03/22/ninja-scaffold/ and https://www.rostrum.blog/2019/05/24/xaringan-template/ with variables, but the use of the template still seems more complex than, say, Hugo. 
There are templating tools (Glue, Whisker https://github.com/edwindj/whisker, etc.)

I think it would be possible to create some functions to take e.g. a tibble of slides where content can be assigned to pre-defined structures (e.g. https://stackoverflow.com/questions/61078767/how-to-make-slide-deck-in-r-based-on-a-list), but I don't think any packages are currently setup for that, and it's not my skill set.

The `officer` package IS effectively setup for that, separating content from presentation through pre-creating template slides. 

Here I define a few functions:

1. cite_me
1. build_deck
1. build_slide
1. collate_yaml

These are used to...

The master slide can...

This is not feature complete. 






  It includes a default directory structure, gitignore templates, and a setup.R script 
  in the R directory. To use this script, run `source('R/setup.R')` from the project directory. 

  To connect to GitHub, run `usethis::use_github()` or `usethis::use_git()`. 

  You should check the LICENSE file, you might want to use an opensource license such as the MIT license,
  you might find https://choosealicense.com/licenses/ or similar helpful
