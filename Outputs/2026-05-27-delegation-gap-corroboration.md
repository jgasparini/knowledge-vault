---
type: query
date: 2026-05-27
query: "Is the Anthropic figure (engineers fully delegate only 0–20% of tasks despite using AI in ~60% of work) consistent with independent research?"
scope: cross-cutting
---

## Answer

The wiki already holds this figure. [[agent-adoption-patterns]] documents it under "Delegation depth":

> Engineers using AI in ~60% of their work fully delegate only 0–20% of tasks. High usage figures do not mean high autonomy.

The source is [[anthropic-agentic-coding-trends-2026]] — a vendor report, bias noted at time of ingest. [[human-agent-oversight]] also cites the same figure and frames it as the expected state of a deeply collaborative working pattern rather than a failure of AI capability.

**What the wiki does not have:** independent corroboration from other research bodies. A web search against current sources (run after this query was raised) found consistent findings across five independent sources:

| Source | Finding |
|--------|---------|
| DORA 2025 (Google) | Only 3% of developers report high trust in AI output; 46% actively distrust it — low trust directly constrains full delegation |
| Stack Overflow Developer Survey 2025 | Trust in AI output fell year-on-year (31% → 46% distrusting); 66% spend more time debugging AI code than expected |
| GitClear (longitudinal) | AI adoption buckets show sharp growth in usage but full delegation remaining a small minority category |
| EY 2026 AI Sentiment Report | Only 16% had used fully autonomous AI systems, against 84% using AI in some form — near-identical gap ratio |
| Deloitte 2026 State of AI | Only 1 in 5 companies has mature governance for autonomous agents — governance ceiling limits delegation even where engineers want to delegate |

**Verdict:** The Anthropic figure is consistent with independent research and is not an outlier. If anything, it may be generous — the EY and Stack Overflow data suggest the fully-delegating population could be at the lower end of the 0–20% range.

**One caveat:** Anthropic's report surveyed their own platform users and employees, which is a self-selected, technically sophisticated population. This population would be expected to delegate *more* than average, not less. If that population is at 0–20%, the broader engineering population is likely at or below that floor.

*Note: DORA, EY, and Deloitte findings above draw on web search conducted 2026-05-27, not ingested wiki sources.*

## Gaps

1. The wiki has no ingested source providing independent cross-validation of the delegation gap figure. The corroborating sources identified above (DORA 2025, Stack Overflow 2025, EY 2026) are not yet in the wiki.
2. No wiki page currently addresses the *direction* of Anthropic's sampling bias (technically sophisticated users likely delegating more than average), which is a material consideration when using the figure as an enterprise benchmark.
