---
title: Synthetic datasets and community tools for the rapid testing of ecological hypotheses
author:
  - family: Poisot
    given: Timothée
    affiliation: 1, 2
    email: tim@poisotlab.io
  - family: Gravel
    given: Dominique
    affiliation: 2,3
  - family: Leroux
    given: Shawn
    affiliation: 4
  - family: Woods
    given: Spencer A.
    affiliation: 5, 6
  - family: Fortin
    given: Marie-Josée
    affiliation: 7
  - family: Baiser
    given: Benjamin B.
    affiliation: 8
  - family: Stouffer
    given: Daniel B.
    affiliation: 9
affiliation:
  - id: 1
    text: Université de Montréal, Département de Sciences Biologiques
  - id: 2
    text: Québec Centre for Biodiversity Sciences
  - id: 3
    text: Université du Québec à Rimouski
  - id: 4
    text: Shawn
  - id: 5
    text: Woods Institute for the Environment, Stanford University, Stanford, CA, USA 
  - id: 6
    text: School for Environmental and Forest Science, University of Washington, Seattle, WA, USA 
  - id: 7
    text: University of Toronto
  - id: 8
    text: University of Florida
  - id: 9
    text: University of Canterbury
keyword:
  - k: open data
  - k: API
  - k: species distributions
  - k: computational ecology
  - k: trophic interactions
date: work in progress
abstract: ...
---

Ecologists are tasked with providing information on issues involving a variety
of organisational scales. Notable examples include, in addition to the global
biodiversity crisis [@xxx], predicting the consequences of the loss of trophic
structure [@este11], rapid shifts in species distributions [@gilm10], and
increased anthropogenic stress on species and their environment [@ref]. Most of
these pressing topics require to be addressed (i) at the global scale, or at
the very least across a variety of environments and landscapes, and (ii)
through the integration of several types of data [@thui13]. Because of these
requirements, new sampling is not always a viable solution on its own: there is
no funding structure to finance it, and there are time and scale constraints
involved that make it unrealistic. While it is obvious that data collection
should continue, we argue that there are a (potentially large) number of
macroecological questions that could be adressed (i) without additional data
and (ii) at minimal cost, by making use of open data and community-developed
software and platforms.

{>>  Halpern et al. 2008. A Global Map of Human Impact on Marine Ecosystems. Science 319: 948-952.  <<}

Existing data can, to an increasing extent, be used to *build* new datasets
(henceforth synthetic datasets). There are several parallel advances that make
this approach possible. First, the volume of data on ecological systems that
are available *openly* increases on a daily basis. This includes point-
occurrence data, as in *e.g.* GBIF, but also taxonomic knowledge (through ITIS,
NCBI or EOL), and trait and interactions data. A vast treasure trove of
ecological information is now available without having to contact and secure
authorization from every contributor individually. Second, this data is often
available in a *programmatic* way. As opposed to manual collection,
identification, and maintenance of datasets, most of these services implement
web APIs, *i.e.* services that allow users to query and/or upload data in a
standard format. These services can be queried, either once or on a regular
basis, to retrieve records with the desired properties. This ensures that the
process is repeatable, testable, transparent, and nearly error proof. Finally,
most of the heavy-lifting for these tasks can be done through a *burgeoning
ecosystem of packages and software*, that handles query formatting, data
retrieval, and associated tasks, all the while exposing simple interfaces to
researchers. None of these are *new* data, in the sense that these collections
represent the aggregation of thousands of ecological studies; the originality
lies in the ability to query, aggregate, curate, and use these data
consistently using open solutions.

Hypothesis testing for large-scale systems is inherently limited by the
availability of suitable datasets -- most data collection results in small
scale, local data, and it is not always clear how these can be used at more
global scales. Perhaps as a result, developments in macroecology have primarily
been driven by a search for patterns that are very broad both in scale and
nature [@beck12c; @keit12]. While it is obvious that collecting exhaustive data
at scales that are large enough to be relevant can be an insurmountable effort
(both because of the monetary, time, and human costs needed), we suggest that
macroecologists could, in parallel, build on existing databases, and aggregate
them in a way that allows direct testing of proposals stemming from theory. To
us, this opens no less than a new way for ecologists to ask critical research
questions, spanning from the local to the global, and from the organismal to
the ecosystemic, scales. Indeed, we live in a data-rich world, and a very large
amount of these data can now *easily* be collected, reducing the need for
additional costly and time-consuming sampling. More importantly, this allows
*rapid* evaluation of both climate change scenarios [@albouy] and hypotheses.
In this contribution, building on a real-life example, we (i) outline the basic
approach of integrating data from a variety of sources (both in terms of
provenance, and type of ecological information), (ii) identify technical
bottlenecks, (iii) discuss issues related to scientific ethics and best
practice, and (iv) provide clear recommendations moving forward.

<!-- DG: The general objective of the paper is not clear--> 
<!-- DG:  and be careful, you start by a strong state (!) about hypothesis testing, but never provide one for this paper. It is essentially descriptive, again. I think there would be a way to do it, even if it is not central to the story --> 
<!-- DG: might worth putting some cautionary remark about the interpretation of the results; the paper is essentially a proof of concept and not the place to debate about the validity of the analysis - for this, you can cite Camille's paper in GCB in 2014 to say that you build on an already established method. Otherwise we'll get reviewers criticizing the ecology, not the computations. --> 

# An illustrative case-study

Food-web data, that is the determination of trophic interactions among species,
are notoriously difficult to collect. The usual approach is to assemble
literature data, expert knowledge, and additional information coming from field
work, either as direct observation of feeding events or through gut-content
analysis. Because of these technical constraints, food-web data are most often
assembled in a single location. This impedes our ability to address the
variation of their structure in space, which may both translate the action of
macroecological mechanisms, as well as hold key to our ability to predict the
spatial variation of ecological properties. As a consequence, most of the
properties of food web over large (continental, global) spatial extents remain
undocumented. For example, what is the relationship between latitude and
connectance (the density of feeding interactions)?

One possible way to approach this question would be to collect data from
different localities, and document through *e.g.* regressions the relationship
between latitude and connected. The approach we will illustrate here uses
broad-scale data integration to forecast the structure of a single system at
the global scale. We are interested in predicting the structure of a pine-
marsh food web, worldwide.

## Interactions data

Food web data were take from **REF**, as made available in the `IWDB` database
(URL). Marshes, like almost all wetlands, are critically endangered and serve
as a home to a host of endemic biodiversity [@fens11;
@minc13]. Stream food webs in particular are important, both because they
provide coupling between terrestrial and aquatic communities and ensure the
maintenance of ecosystem services, but also because the increased pressure on
wetlands makes them particularly threatened. They represent a prime example of
ecosystems for which data-based prediction can be used to generate scenarios at
a temporal scale relevant for conservation decisions, and faster than what
sampling could allow.

The data comprising the original food web (105 nodes, including vague
denominations like *Unidentified detritus* or *Terrestrial invertebrates*),
were cleaned in the following way. First, all nodes were aggregated to the
*genus* level. Due to high level of structure in trophic interactions emerging
from taxonomic rank alone [@eklo11,@stou12], aggregating to the genus level has
the double advantage of (i) removing ambiguities on the identification of
species and (ii) allowing us to integrate data when any two species from given
genera interact. Second, all nodes that were not identified (`Unidentified` or
`Unknown` in the original data) were removed. The cleaned network documented
227 interactions, between 80 genera.

{>>CHECK AND REDO IF NEEDED<<}

Using the name checking functions from the `taxize` package [@cham13a] revealed
that all of these genus names were valid.

Because the original food web was sampled *locally*, there is the possibility
that interactions between genera are not reported; either because species from
these genera do not interact, or co-occur, in the sampling location. To
circumvent this, we queried the *GLOBI* database [@poel14] for each genus name,
and retrieved all *feeding* interactions. For all *new* genera retrieved
through this method, we also retrieved their interactions with genera already
in the network. The inflated network (original data, and data from *GLOBI*) has
789 genera, and a total of 9328 interactions between them.

The code to reproduce this analysis is in the `1_get_data.r` suppl. file.

{>>CHECK ALL NUMERICAL VALUES<<}

## Occurrence data and filtering

For each genera, we downloaded the known occurrences from GBIF and BISON.
This yielded 64 763 point-presence records. Because the ultimate goal is to
perform spatial modeling of the structure of the network, we removed genera for
which fewer than 100 occurrences were known. This seems like a stringent
filter, yet it enables to (i) maintain sufficient predictive powers for SDMs,
and (ii) only work on the genera for which we have "high-quality" data. Genera
with fewer than 100 records were removed from the occurrence data and from the
metanetwork. The final metanetwork therefore has 4271 interactions between 188
genera. Given the curated publicly available data, it represents the current
best description of feeding interactions between species of this ecosystem. A
visual depiction of the network is given in *Fig. 1*.

<!-- DG: first time you mention metanetwork. Would be great to define it. --> 
<!-- DG: not clear how you dropped back to 188. is it only because you filtered out other species with insufficient occurrences ? - the answer comes in the following paragrpha. should be here.--> 
<!-- DG: the automatization of the whole process makes it easy to perform sensitivity analysis. might be a good example to assess the robustness of the approach to you 100 occurrence threshold --> 

On its own, the fact that filtering for genera with over 100 records reduced
the sample size from 739 genera to 188 indicates how crucial it is that
observations are reported in public databases. This is because the type of
analysis we present here, although cost-effective and enabling rapid evaluation
of different scenarios, is only as good as the underlying data. Since most
modeling tools require a minimal sample size in order to achieve acceptable
accuracy, concerted efforts by the community and funding agencies to ensure
that the minimal amount of data is deposited upon publication or acquisition is
needed.

The code to reproduce this analysis is in the `1_get_data.r` suppl. file.

## Species Distribution Model

<!-- DG:  define your climatic envelope models. The tirm is not precise enough--> 

For each species in this subset of data, we retrieved the nineteen `bioclim`
variables [@hijm05], with a resolution of 5 arc-minutes. This enabled us to
build climatic envelope models for each species. These models tend to be more
conservative than alternate modeling strategies, in that they predict smaller
range sizes [@hijm06], but they also perform well overall for presence-only
data [@elit06]. The output of these models is, for species $i$, the probability
of an observation $\mathrm{P}(i)$ within each pixel. We appreciate that this is
a coarse analysis, but its purpose is only to highlight how the different data
can be combined. A discussion of the limitations of this approach is given
below.

The code to reproduce this analysis is in the `2_get_sdm.r` suppl. file.

## Assembly

For each of the 4271 interactions in the metanetwork, we estimated the
probability of it being observed in each pixel as the product of the
probabilities of observing each species on its own: $\mathrm{P}(L_{ij}) \propto
\mathrm{P}(i)\mathrm{P}(j)$. This resulted in 4271 LDMs ("link distribution
models"). The code to reproduce this analysis is in the `3_get_ldm.r` suppl.
file.

<!-- DG:  I understand the space limitations, and also the fact that it is illustrative, but avoid putting some important details under the carpet. Here for instance, co-occurrence is totally neutral (as usually done in SDMs). Just make it explicit. Pi is also a function of the climate. Finally, you assume that interactions happen as long as species are found at same location. --> 
<!-- DG:  It's gonna be like that all the time, but I understand that some people get irritated if you don't recognize limits to the approach. --> 
<!-- DG:  Further, there are different sources of uncertainties. the occurrence is probabilistic because of at least two reasons: first, the data and the models are pretty bad, with uncertainties caused by lack of knowledge. secondly, distribution on its own could be stochastic (e.g. metapop). while the second makes sense to get at a probability of an interaction to happen, the first one not --> 

Based on this information, we generated the following illustrations (using
`4_draw_figures.r`). First, a map of species richness (*Fig. 2A*) and number of
interactions (*Fig. 2B*). Second, a map of *connectance* (*Fig. 2C*), which is
the number of interactions divided by the squared species richness. Finally, a
scatterplot of connectance as a function of latitude (*Fig. 2D*), which reveals
a systematic macroecological trend.
<!-- DG:  describe it !--> 
 Interestingly, this last panel shows a
strong response to this system to the fact that the tropics in Africa are
surrounded by deserts in which the species studied here are not predicted to
occur given the climatic variables.

# Challenges moving forward

<!-- DG:  a transition is lacking. something like the example nicely illustrates the promises of data intensive approaches. it builds on new data availability, new statistical and computational tools. But as with every technical development in science comes a number of challenges and limitations. Here we discuss a few we believe are important. We essentially define these issues and emphasize that each of them, on their own, should be the subject of further debates. --> 

**Attribution stacking and intellectual provenance:**

The merging of large databases has already created a conflict of how to
properly attribute data provenance. Here there are at least two core issues
that will require community consultation in order to be resolved. First, *what
is the proper mode of attribution when a very large volume of data is
aggregated*?  Second, *what should be the intellectual property of the
synthetic dataset*?  Currently, citations (whether to articles or datasets) are
only counted when they are part of the main text. The simple example outlined
here relies on well over a thousand references, and it makes little sense to
expect that they would be provided in the main text. One intermediate solution
would be to collate these references in a supplement, but it is unclear that
these would be counted, and therefore contribute to the *impact* of each
individual dataset. This is a problem that we argue is best solved by
publishers; proper attribution and credit is key to provide incentives to data
release [@whel14; @kena14]. As citations are currently the currency of
scientific impact, publishers have a responsibility not only to ensure that
data are available (which many already do), but that they are recognized; data
citation, no matter how many data are cited, is a way to achieve this goal. The
synthetic dataset, on the other, can reasonably be understood as a novel
product; there is technical and intellectual effort involved in producing it,
and although it is a derivative work, we would encourage authors to deposit it
anew.

<!-- DG:  which means that we should give credit to both the original
contributors and teh one that assembled it ? I do fully agree with that
position, but I don't think it will be very operational. As suggested above,
some rewording would help in this section and the other ones just to underline
that you adequately point at new challenges, but do not explore them in full
details and obviously do not solve them. Otherwise the reader might be
systematically disappointed. -->

**Sharing of code and analysis pipeline:**

<!-- DG:  provide a definition for pipeline --> 
Ideally, authors should release their analysis *pipeline* in addition to the
data and explanation of the steps. The pipeline can take the form of a
`makefile` (which allows to generate the results, from the raw data, without
human intervention), or be all of the relevant code that allows to re-generate
the figures and results. For example, we have released all of the `R` code that
was used to generate the figures at **XXX**. Sharing the analysis pipeline has
several advantages. First, it is a first stepv towards ensuring the quality of
analyses, since reviewers can (and should reasonably be expected to) look at the
source code. Second, it provides a *template* for future analyses -- instead of
re-developing the pipeline from scratch, authors can re-use (and acknowledge)
the previous codebase and build on it. Finally, it helps identifying areas of
future improvement. The development of software should primarily aim to make the
work of researchers easier. Looking at commonalities in the analytical pipelines
for which no ready-made solutions exists will be a great way to influence
priorities in software development.
<!-- DG:  what should we do with version control ? and with software versions ? Papers do last much longer than the longevity of pieces of code, and that will be a major issue. Standard practices should include a complete listing of the packages and software details that were used to make sure that someone could reproduce your work in 15 years from now. --> 

**Computational literacy:**

This approach hardly qualifies as *big data*; nevertheless, it relies on the
management and integration of a large volume of heterogeneous information, both
qualitatively larger than the current "norm". The first challenge is being able
to *manage* this data; it requires data management skills that are not usually
needed when the scale of the dataset is small, and, fallible though the process
may be, when data can reasonably be inspected manually. The second challenge is
being able to *manipulate* these data; even within the context of this simple
use-case, the data do not fit in the memory of `R` (arguably the most commonly
known and used software in ecology) without some adjustments. Once these issues
were overcome, running the analysis involved a few hours worth of computation
time. Since there is little doubt that computational approaches are going to
become increasingly common in ecology [@hamp13], and are identified by the
community as both in-demand skills and as not receiving enough attention in
current ecological curricula [@barr13a], it seems that efforts should be
allocated to raise the computational literacy of ecologists, and recognize that
there is value in the diversity of tools one can use to carry out more
demanding studies. For example, both `Python` and `Julia` are equally as user
friendly as `R` while also being more powerful and better suited for
computationally- or memory-intensive analyses.

<!-- DG:  tu n'as pas pu t'empêcher de faire ce commentaire ! Pour la mémoire, je trouve ces débats sur les langages de programmation aussi pertinents et objectifs qu'en aurait un sur la langue des publications scientifiques ou la couleur de la margarine (on a eu ça ici!); il y a d'autres critères que l'élégance ou la performance du code, l'historique, la facilité de partage et d'accès sont aussi importants --> 


**Standards and best practices:**

In conducting this analysis, we noticed that a common issue was the
identification of species and genera. All of these datasets were deposited by
individual scientists; whether we like it or not, individuals are prone to
failure in a very different way that the "Garbage in, garbage out" idea that
applies to computer programs. Using tools such as `taxize` [@cham13a] can allow
us to resolve a few of the uncertainties, yet this must be done every time the
data are queried and requires the end user to make educated guesses as to what
the "true" identity of the species is. These limitations can be overcome, on
two conditions. Database maintainers should implement automated curation of the
data they have the stewardship of, and identify potential mistakes and correct
them upstream, so that users download high-quality, high-reliability data. Data
contributors should rely more extensively on biodiversity identifiers (such as
TSN, GBIF, NCBI Taxonomy ID, ...), to make sure that even when there are typos
in the species name, they can be matched across datasets. Constructing this
dataset highlighted a fundamental issue: the rate-limiting step is rarely the
availability of appropriate tools or platforms, but instead it is the adoption
of common standards and the publication of data in a way that conforms to them.
In addition, @mald15 emphasize that point-occurence data are not always
properly reported -- for example, the center of a country or region can be used
when no other information is known; this requires an improved dialogues
betweent data collectors and data curators, to highlight which practices have
the highest risk of biasing future analyses.

**Propagation of error:**

There are always caveats to using synthetic datasets. First, the extent to
which each component dataset is adequately sampled is unknown (although there
exist ways to assess the overall representativeness of the assembled dataset;
@schm14). This can create gaps in the information that is available when all
component datasets are being merged.  Second, because it is unlikely that all
component datasets were acquired using reconcilable standards and protocol, it
is likely that much of the quantitative information needs be discarded, and
therefore the conservative position is to do qualitative analyses only.
Although these have to be kept in mind, we do not think they should prevent use
and evaluation of the approach we suggest. For one thing, as we illustrate, at
large spatial and organizational scales, coarse- grained analyses are still
able to pick up qualitative differences in community structure. Second, most
emergent properties are relatively insensitive to fine- scale error; for
example, @grav13 show that even though a simple statistical model of food-web
structure mispredicts some individual interactions, it produces communities
with realistic emergent properties. Which level of error is acceptable needs to
be determined for each application, but we argue that the use of synthetic
datasets is a particularly cost- and time-effective approach for broad-scale
description of community- level measures.

<!-- DG:  There is no strong conclusion to the paper. I think it would be great to revisit the first paragraph in light of this example and discuss the promises of new data-intensive approaches. -->

# Conclusion -- why not?

- need to try
- fast, and relies on existing "classical" data
- generate testable predictions
- can identify gaps in knowledge -- missing data!
- necessary step before real-time predictions @anto14

**Acknowledgments --** This work was funded in part through a grant from the
Canadian Institute of Ecology and Evolution. TP was funded by a Starting grant
from the Université de Montréal, and a NSERC Discovery Grant. DBS acknowledges
a Marsden Fund Fast-Start grant (UOC-1101) and Rutherford Discovery Fellowship,
both administered by the Royal Society of New Zealand. We thank Kévin Cazelles
for constructive comments on the manuscript.

# References
