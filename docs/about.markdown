---
layout: page
title: About
permalink: /about/
---
Hello out there my name is Stefan and I am currently a researcher at Roskilde University, [that's me][ruc].

I studied in Graz (second largest city of Austria) and did B.Sc. and M.Sc. in physics at the [University of Graz][kfu].
Had a lot of fun doing my master thesis with [Prof. Axel Maas][axel_maas].
The theory we took a look at was N=4 Super Yang Mills theory.
Where the name contains already quite a lot of information, but lets start from the back.
Yang Mills theory offer a way to describe the interaction of gauge bosons, e.g. the photon.
For the strong force this gauge boson is the gluon, and although still being a boson it is very much more complex than a photon.
The super in the name add the idea of supersymmetry to the theory.
Therefore every boson has an equal fermionic super partner and vise versa.
Again taking the photon, there has to be a photino if this was a real symmetry of our world (it is not). 
The last part N=4 states how many super partners there are, in this case e.g. four photinos.
This theory is more math than physics, because a lot of the assumptions that are made disagree with observations.
Nevertheless, in the end we wrote a [paper][epcj_paper] about the finding we made and funnly enough it was approved by the editor in less then three weeks.

After that uplifting time came a rather depressing period.
Looking for a PhD position within theoretical high energy physics, was not too pleasant.
Many professors did not reply to my applications at all.
Others invited me to an interview only to for legal reasons while having a candidate already chosen.
That time was a good learning experience.
I learned that I do not want to be part of this kind of research community.

Still doing research and actively solve hard problems was a nice experience and wanted to keep doing it.
I was rather happy when [Prof. Jens Harting](https://www.hi-ern.de/hi-ern/CompFlu/Team/Harting/harting.html?nn=2433100) offered me a job in his group.
Since then (2017) I work in the domain of computational fluid dynamics.
And within this broad domain I am interested in the small subset of thin film dynamics.
For example low Reynolds number flows such as biological flows, coatings and droplet dynamics.
To do numerical experiments I use the lattice Boltzmann method.
A method that builds on a distribution like approach (think of a gas and instead of describing the motion of every particle one uses a distribtuion over a subset) to solve for macroscopic fields, like the velocity.
The model we developed to this kind of simulations was in fact  [Julia][julia] and [Matlab][matlab].
This is a blog about the dynamics of thin liquid films and a numerical tool so simulate them [Swalbe.jl][swalbe.jl].

<!-- Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %} -->

[notebook][notebook1]

[kfu]: https://www.uni-graz.at/en/
[ruc]: https://forskning.ruc.dk/en/persons/zitz
[epcj_paper]: https://link.springer.com/article/10.1140/epjc/s10052-016-3942-y
[axel_maas]: https://homepage.uni-graz.at/de/axel.maas/
[swalbe.jl]: https://github.com/Zitzeronion/Swalbe.jl
[jen_harting]: https://www.hi-ern.de/hi-ern/CompFlu/Team/Harting/harting.html?nn=2433100
[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
[notebook1]: https://zitzeronion.github.io/Droplet-Coalescence/
