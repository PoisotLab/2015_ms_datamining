---
title: Synthetic datasets for global ecology in a data-rich world
author: see CONTRIBUTORS (add your name)
date: work in progress
---

Ecologists are tasked with providing information on issues at the global scale.
Notable examples include, in addition to the global biodiversity crisis [@xxx],
predicting the consequences of the loss of trophic structure @este11, rapid
shifts in species distributions [@xxx], and <!-- TODO add a few -->. Most of
these pressing topics require to be addressed (i) at the global scale and (ii)
through the integration of several types of data [@thui13]. Because of these
requirements, new sampling is not a viable solution: there is no funding
structure to finance it, and there are time and scale constraints involved that
make it unrealistic.

Thankfully, developments in the recent years means that ecologists can now
leverage existing data to an increasing extent, and use them to *build* new datasets (henceforth
synthetic datasets) suitable for the questions at hand. There are several
parallel advances that make this approach possible. First, the volume of data on
ecological systems that are available *openly* increases on a daily basis. This
includes point-occurrence data, as in *e.g.* GBIF, ITIS, but also taxonomic
knowledge (through NCBI or EOL), and trait and interactions data. A vast
treasure trove of ecological information is now available without having to
contact and secure authorization from every contributor individually. Second,
this data is often available in a *programmatic* way. As opposed to manual collection,
identification, and curation of datasets, most of these services implement web
API **DBS: Shouldn't we define API?** that allow to query them, either once or on a regular basis, to retrieve
records with the desired properties. This ensures that the process is
repeatable, testable, transparent, and nearly error proof. Finally, most of the
heavy-lifting for these tasks can be done through a *burgeoning ecosystem of
packages and software*, that take care of handling query formatting, data
retrieval, etc, and expose simple interfaces to researchers.

To us, this opens no less than a new way for ecologists to ask critical
research questions, even at large spatial and organizational scales. Indeed, we live in a
data-rich world, and a very large amount of these data can now *easily* be
collected, reducing the need for additional costly and time-consuming sampling.
More importantly, this allows *rapid* evaluation of scenarios. In this
contribution, building on a real-life example, we (i) outline the basic
approach, (ii) identify technical bottlenecks, (iii) discuss issues related to scientific ethics and best practice,
and (iv) provide clear recommendations moving forward.

# An illustrative case-study

Food-web data, that is the determination of trophic interactions among species,
are notoriously difficult to collect. The usual approach is to assemble literature data,
expert knowledge, and additional information coming from field work, either as
direct observation of feeding events or through gut-content analysis.
Because of these technical constraints, food-web data are most often assembled
in a single location. This impedes our ability to address the variation of their
structure in space, which may both translate the action of macro-ecological
mechanisms, as well as hold key to our ability to predict the spatial variation
of ecological properties.

In this case study, we are interested in predicting the structure of the
pine-marsh food web worldwide. One example of this system has been described in
detail by @martins. We will show how coupling these data with additional
interactions reported in the literature, as well as species occurrence data,
allows us to build a predictive model that describes the spatial variation of this
system.

## Interactions data

Data from the pine-marsh food web were take from **REF**, as made available in
the `IWDB` database (URL). Marshes, like almost all wetlands, are critically
endangered and serve as a home to a host of endemic biodiversity [@fens11; @minc13]. They
represent a prime example of ecosystems for which data-based prediction can be
used to generate scenarios at a temporal scale relevant for conservation
decisions, and faster than what sampling could allow.

The data comprising the original food web (105 nodes, including vague denominations like
*Unidentified detritus* or *Terrestrial invertebrates*), were cleaned in the
following way. First, all nodes were aggregated to the *genus* level. Due to
high level of structure in trophic interactions emerging from taxonomic rank
alone [@eklo11,@stou12], aggregating to the genus level has the double advantage of (i)
removing ambiguities on the identification of species and (ii) allowing us to
integrate data when any two species from given genera interact. Second, all
nodes that were not identified (`Unidentified` or `Unknown` in the original
data) **DBS: Were what?**. The cleaned network documented 227 interactions, between 80 genera. Using
the name checking functions from the `taxize` package [@cham13a] revealed that
all of these genus names were valid.

Because the original food web was sampled *locally*, there is the possibility
that interactions between genera are not reported. To circumvent this, we
queried the *GLOBI* database [@poel14] for each genus name, and retrieved all
*feeding* interactions. For all *new* genera retrieved through this method, we also
retrieved their interactions with genera already in the network. This network
has 789 genera, and a total of 9328 interactions.

## Occurrence data and filtering

For each genera, we then downloaded the known occurrences from GBIF and BISON. This
yielded 64763 point-presence records. Because the ultimate goal is to perform
spatial modeling of the structure of the network, we removed genera for which
fewer than 100 occurrences were known. This seems like a stringent filter, yet it
enables to (i) maintain sufficient predictive powers for SDMs, and (ii) only
work on the genera for which we have "high-quality" data. Genera with fewer than
100 records were removed from the occurrence data and from the metanetwork. The
final metanetwork therefore has 4271 interactions between 188 genera. Given the curated
publicly available data, it represents the current best description of feeding
interactions between species of this ecosystem. A visual depiction of the
network is given in *Fig. 1*.

On its own, the fact that filtering for genera with over 100 records reduced the
sample size from 739 genera to 188 indicates how crucial it is that observations
are reported in public databases. This is because the type of analysis we present here, although
cost-effective and enabling rapid evaluation of different scenarios, is only as
good as the underlying data. Since most modeling tools require a minimal sample
size in order to achieve acceptable accuracy, a concerted efforts by the
community and funding agencies to ensure that the minimal amount of data is
deposited upon publication or acquisition is needed.

## Species Distribution Model

For each species in this subset of data, we retrieved the nineteen `bioclim`
variables [@hijm05], with a resolution of 5 arc-minutes. This enabled us to
build climatic envelope models for each species. These models tend to be more
conservative than alternate modeling strategies, in that they predict smaller
range sizes [@hijm06], but they also perform well overall for presence-only data [@elit06].
The output of these models is, for species $i$, the probability of an
observation $\mathrm{P}(i)$ within each pixel. We appreciate that this is a
coarse analysis, but its purpose is only to highlight how the different data can
be combined. A discussion of the limitations of this approach is given below.

## Assembly

For each of the 4271 interactions in the metanetwork, we estimated the
probability of it being observed in each pixel as the product of the probabilities of
observing each species on its own: $\mathrm{P}(L_{ij}) \propto \mathrm{P}(i)\mathrm{P}(j)$.
This resulted in 4271 LDMs ("link distribution models"). Based on this
information, we generated the following illustrations. First, a map of species
richness (*Fig. 2A*) and number of interactions (*Fig. 2B*). Second, a map of
*connectance* (*Fig. 2C*), which is the number of interactions divided by the
squared species richness. Finally, a scatterplot of connectance as a function of
latitude (*Fig. 2D*), which reveals a systematic macroecological trend.
Interestingly, this last panel shows a strong response to this system to the
fact that the tropics in Africa are surrounded by deserts in which
the species studied here are not predicted to occur given the climatic
variables.

# Opportunities

Hypothesis testing for large-scale systems is inherently limited by the
availability of suitable datasets. Perhaps as a result, macro-ecology has been
guided by a search for patterns that are very broad both in  scale and nature
@REF, as opposed to the testing of pre-established hypotheses. While it is
obvious that collecting data at scales that are large enough to be relevant is
an insurmountable effort (both because of the monetary, time, and human costs
needed), we suggest that macroecologists should build on existing databases,
and aggregate them in a way that allows direct testing of proposals stemming
from theory.

# Challenges

**Attribution stacking and intellectual paternity:**

**DBS: Aren't there any reasonable references for this paragraph? Maybe even a BES editorial about why they now require authors to deposit data?**

The merging of large databases has already created a conflict of how to properly attribute
data paternity. Here there are at least two core issues that will require
community consultation in order to be resolved. First, *what is the proper mode
of attribution when a very large volume of data is aggregated*? Second, *what
should be the intellectual property of the synthetic dataset*? Currently,
citations (whether to articles or datasets) are only counted when they are part
of the main text. The simple example outlined here relies on well over a thousand references, and it
makes little sense to expect that they would be provided in the main text. One
intermediate solution would be to collate these references in a supplement, but
it is unclear that these would be counted, and therefore contribute to the
*impact* of each individual dataset. This is a problem that we argue is best
solved by publishers; proper attribution and credit is key to provide incentives
to data release. As citations are currently the currency of scientific impact,
publishers have a responsibility not only to ensure that data are available
(which many already do), but that they are recognized. The synthetic dataset, on
the other, can reasonably be understood as a novel product; there is technical
and intellectual effort involved in producing it, and although it is a
derivative work, we would encourage authors to deposit it anew.

**Computational literacy:**

This approach hardly qualifies as *big data*; nevertheless, it relies on the
management and integration of a large volume of heterogeneous information, both
qualitatively larger than the current "norm". The first challenge is being able
to *manage* this data; it requires data management skills that are not usually
needed when the scale of the dataset is small, and, fallible though the process
may be, when data can reasonably be inspected manually. The second challenge is being
able to *manipulate* these data; even within the context of this simple
use-case, the data do not fit in the memory of `R` (arguably the most commonly
known and used software in ecology) without some adjustments. Once these issues
were overcome, running the analysis involved a few hours worth of computation
time. **DBS: I know you want to say this, but I think this paragraph works without simultaneously taking a dig at `R` and promoting alternatives. Or, see my suggestion at the end of this paragraph.** It is now worth asking whether our total reliance on this tool (as opposed
to more performing yet equally user-friendly languages as `python` or `julia`)
is going to pay off in the long term. Since there is little doubt that
computational approaches are going to become increasingly common in ecology
[@hamp13], and are identified by the community as both in-demand skills and as not
receiving enough attention in current ecological curricula [@barr13a], it seems
that efforts should be allocated to raise the computational literacy of
ecologists, and recognize that there is value in the diversity of tools one can
use to carry out more demanding studies. **DBS suggests the following instead of what is above: For example, both `Python` and `Julia` are equally as user friendly as `R` while also being more powerful and better suited for computationally- or memory-intensive analyses.**

**Standards and best practices:**

In conducting this analysis, we noticed that a common issue was the
identification of species and genera. All of these datasets were deposited by
individual scientists; whether we like it or not, individuals are prone to failure in a very different way that the "Garbage in, garbage out" idea that applies to computer programs. Using tools such as `taxize` [@cham13a] can allow
us to resolve a few of the uncertainties, yet this must be done every time the
data are queried and requires the end user to make educated guesses as to what
the "true" identity of the species is. These limitations can be overcome, on two
conditions. Database maintainers should implement automated curation of the data
they have the stewardship of, and identify potential mistakes and correct them
upstream, so that users download high-quality, high-reliability data. Data
contributors should rely more extensively on biodiversity identifiers (such as
TSN, GBIF, NCBI Taxonomy ID, ...), to make sure that even when there are typos
in the species name, they can be matched across datasets. Constructing this
dataset highlighted a fundamental issue: the rate-limiting step is rarely the
availability of appropriate tools or platforms, but instead it is the adoption of common standards and
the publication of data in a way that conforms to them.

**Propagation of error:**

There are always caveats to using synthetic datasets. First, the extent to which
each component dataset is adequately sampled is unknown. This can create gaps in
the information that is available *in fine* **DBS: I think *in fine* must be something coming from French; what do you want to say here?**. Second, because it is unlikely that
all component datasets were acquired using reconcilable standards and protocol,
it is likely that much of the quantitative information needs be discarded, and therefore
the conservative position is to do qualitative analyses only. Although these
have to be kept in mind, we do not think they should prevent use and evaluation
of the approach we suggest. For one thing, at large spatial and organizational
scales, coarse-grained analyses are still able to pick up qualitative
differences in community structure. Second, most emergent properties are
relatively insensitive to fine-scale error; for example, @grav13 show that even
though a simple statistical model of food-web structure mispredicts some
individual interactions, it produces communities with realistic emergent
properties. Which level of error is acceptable needs to be determined for each
application, but we argue that the use of synthetic datasets is a particularly cost- and time-effective approach for broad-scale description of community-level measures.

**DBS: Is the following section really necessary for this editorial? I feel like the challenges section is already a nice way to culminate things. Also, most of it is implicit or explicit above (except the pipeline stuff), so maybe we're better off adding discussion of the pipeline somewhere else?**

# Recommendations

1. Publish data (even the small one!)

Ideally, authors should release their analysis *pipeline* in addition to the
data and explanation of the steps. The pipeline can take the form of a
`makefile` (which allows to generate the results, from the raw data, without
human intervention), or be all of the relevant code that allows to re-generate
the figures and results. For example, we have released all of the `R` code that
was used to generate the figures at **XXX**. Sharing the analysis pipeline has
several advantages. First, it is a first steps towards ensuring the quality of
analyses, since reviewers can (and should reasonably be expected to) look at the
source code. Second, it provides a *template* for future analyses -- instead of
re-developing the pipeline from scratch, authors can re-use (and acknowledge)
the previous codebase and build on it. Finally, it helps identifying areas of
future improvement. The development of software should primarily aim to make the
work of researchers easier. Looking at commonalities in the analytical pipelines
for which no ready-made solutions exists will be a great way to influence
priorities in software development.

3. Pay attention to standard when releasing data

**Acknowledgments --** This work was funded in part through a grant from the
Canadian Institute of Ecology and Evolution. TP was funded by a Starting grant
from the Université de Montréal. DBS acknowledges a Marsden Fund Fast-Start grant (UOC-1101) and Rutherford
Discovery Fellowship, both administered by the Royal Society of New Zealand.

# References
