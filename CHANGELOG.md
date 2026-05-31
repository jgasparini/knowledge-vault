# CHANGELOG

Running log of all librarian operations. Newest entry at the top.
One entry per operation: ingest, query promotion, lint pass, restructure.

Format:
```
## YYYY-MM-DD — [Operation] | [Title or description]
- [detail]
- [detail]
```

---

## 2026-05-29 — Consolidation pass [global]
- Duplicates merged: 1 (intra-page deduplication in [[human-agent-oversight]] — removed first incomplete Connections block and two duplicate section headers; second complete set retained)
- Status changes: none (wiki is 1–4 days old; no page meets the 60-day active→evergreen or 90-day archive thresholds)
- Synthesis actions: 2 (wikilink added between [[auto-mode-policy]] and [[production-signal-evals]] naming the shared "observe → iterate" loop; three-layer defence framing sentence added to [[agentic-security]] Connections naming the agentic-security → agent-containment → auto-mode-policy stack)

## 2026-05-29 — Ingest | Pioneering the Agentic Shift Within Salesforce Engineering (Tallapragada)
- Pages created: [[salesforce-agentic-shift-engineering-2026]], [[salesforce]] (entity), [[srinivas-tallapragada]] (entity)
- Pages updated: [[agentic-productivity-economics]] (Salesforce data: 50.8% work items, 79% PRs, 151.3% Effective Output, 18x migration speedup, incidents −5%), [[sdlc-transformation]] (rule-based framework pattern; autonomous loops; parallelised environments), [[career-framework-adaptation]] (Salesforce open questions: junior engineer paths, designer/PM roles, 1/3-person team unit experiments), [[claude-code-harness]] (skills as organisational infrastructure; CLAUDE.md quality variance), [[ai-native-engineering]] topic (evolving thesis: tenth signal — quality/productivity tradeoff breaking down; eleventh signal — skills as shared infrastructure)
- Structural suggestions: none (fits existing ai-native-engineering project)
- Contradictions cross-referenced: Salesforce incidents down 5% vs DORA delivery instability finding (cross-referenced in [[agentic-productivity-economics]] and [[sdlc-transformation]]); self-reported data caveat applied throughout
- Note: file moved from inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-05-29 — Ingest | How we rolled out Claude Code Auto Mode across our Engineering Team (Hedgineer)
- Pages created: [[hedgineer-claude-code-auto-mode-rollout]], [[auto-mode-policy]] (concept), [[hedgineer]] (entity)
- Pages updated: [[claude-code-harness]] (Auto Mode policy as managed governance layer; managed settings distribution; OTEL as design input; $defaults trap), [[human-agent-oversight]] (managed policy as scalable HITL replacement; hard_deny as deterministic outer boundary; OTEL observability)
- Structural suggestions: none (fits existing ai-native-engineering project)
- Contradictions cross-referenced: none; 89% drop in user overrides corroborates [[human-agent-oversight]] managed-policy thesis; hard_deny activations add nuance to [[agent-containment]]
- Note: content file (1.md) and URL stub both moved from inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-05-29 — Housekeeping | AWS AI-DLC stub file moved
- AWS stub URL clip moved from inbox/ → wiki/projects/ai-native-engineering/sources/ (already ingested 2026-05-28; Raw source reference updated in [[aws-ai-dlc-financial-services]])

## 2026-05-28 — Ingest | NCSC AI Vulnerability Discovery Checklist + CERT-EU Advisory (regulatory response to Glasswing)
- Pages created: [[ncsc-ai-vulnerability-checklist]], [[cert-eu-ai-vulnerability-discovery]], [[ncsc]] (entity), [[cert-eu]] (entity)
- Pages updated: [[patch-velocity]] (negative-seven-days data; NCSC focus-over-volume framing; regulatory pressure materialising), [[ai-vulnerability-discovery]] (NCSC board-level framing; CERT-EU pipeline; open-weight acceleration; defender asymmetry challenge), [[project-glasswing]] (regulatory response section added), [[ai-security]] topic (key entities added; evolving thesis updated with regulatory picture)
- Project INDEX.md, QUESTIONS.md updated; QUESTIONS.md item "Are UK/EU regulators moving to update guidance?" closed
- Contradictions cross-referenced: NCSC focus-vs-sprint tension with [[patch-velocity]] Forrester view; CERT-EU defender-advantage framing vs. asymmetry argument in [[ai-vulnerability-discovery]]
- Note: sources fetched directly from web (no inbox files); source summary pages written as processed pages in sources/ directly

## 2026-05-28 — Ingest | Agentic Engineering: How Swarms of AI Agents Are Redefining Software Engineering (LangChain/Cisco)
- Pages created: [[agentic-engineering-swarms-langchain-2026]], [[langgraph]], [[langchain]]
- Pages updated: [[multi-agent-coordination]] (worker/leader model, A2A, LangGraph, measured outcomes), [[agentic-productivity-economics]] (93% debug, 65% dev pilot data), [[ai-native-engineering]] topic (evolving thesis)
- Structural suggestions: none (fits existing ai-native-engineering project)
- Contradictions cross-referenced: extraordinary pilot numbers vs. absence of independent validation (noted in source page); PR review bottleneck confirms [[verification-tax]] (corroboration, not contradiction)
- Raw file moved: inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-05-28 — Ingest | AI-Driven Development Lifecycle for Financial Services (AWS)
- Pages created: [[aws-ai-dlc-financial-services]], [[ai-dlc]]
- Pages updated: [[kiro]] (Mantle rebuild story, AI-DLC positioning), [[sdlc-transformation]] (AI Pods, mob format), [[spec-driven-development]] (steering files), [[agentic-productivity-economics]] (compression ratio data), [[ai-native-engineering]] topic (evolving thesis, new concept link)
- Structural suggestions: none
- Contradictions cross-referenced: vendor productivity claims vs. DORA brownfield caution (noted); AI Pod headcount implications vs. UK regulated employment context (noted); continuous review reframing vs. [[verification-tax]] (noted)
- Source note: inline web source fetched from AWS blog (2026-05-26); stub file in inbox/ retained

## 2026-05-27 — Ingest | Stack Overflow Developer Survey 2025 — AI section
- Pages created: [[stackoverflow-developer-survey-2025-ai]]
- Pages updated: [[agent-adoption-patterns]], [[human-agent-oversight]], [[ai-mainstream-adoption]]
- Structural suggestions: none
- Contradictions cross-referenced: trust decline vs. rapid AI improvement narrative (noted in source page)
- Note: inline web source; no file to move

## 2026-05-27 — Ingest | DORA 2025 State of AI-Assisted Software Development
- Pages created: [[dora-state-of-ai-2025]]
- Pages updated: [[agent-adoption-patterns]], [[human-agent-oversight]], [[ai-mainstream-adoption]]
- Structural suggestions: none
- Contradictions cross-referenced: individual productivity gains vs. system-level instability (noted in source page)
- Note: inline web source (accessed via InfoQ summary); no file to move

## 2026-05-27 — Ingest | EY Technology Pulse Poll 2026
- Pages created: [[ey-technology-pulse-poll-2026]]
- Pages updated: [[agent-adoption-patterns]], [[human-agent-oversight]]
- Structural suggestions: none
- Contradictions cross-referenced: 97% strategic priority vs. 52% without oversight (noted in source page); US-only sample vs. UK regulated context (noted)
- Note: inline web source; no file to move

## 2026-05-27 — Query | Delegation gap corroboration
- Output filed: Outputs/2026-05-27-delegation-gap-corroboration.md
- Scope: cross-cutting
- Open question resolved: "Is the Anthropic delegation gap figure consistent with independent research?" — yes, confirmed by all three sources above
- QUESTIONS.md updated: ai-native-engineering/QUESTIONS.md item closed

## 2026-05-27 — Query | Career framework adaptation (implementer→orchestrator shift)
- Output filed: projects/ai-native-engineering/outputs/2026-05-27-career-framework-adaptation.md
- Pages read: [[sdlc-transformation]], [[agent-adoption-patterns]], [[forward-deployed-engineer]], [[fiona-fung-scaling-ai-native-engineering-2026]]
- Promoted to wiki page: [[career-framework-adaptation]] (user confirmed)
- Pages updated: concepts/sdlc-transformation (link + connections entry), topics/ai-native-engineering (key concepts link + evolving thesis), projects/ai-native-engineering/INDEX.md (concept row), wiki/INDEX.md (concept row)
- Open question closed: "Career frameworks, levelling criteria, and hiring processes are not designed for the implementer→orchestrator shift"
- New gaps filed: governance literacy as levelling criterion; decomposition quality interview assessment (2 items added to QUESTIONS.md)

## 2026-05-27 — Ingest | How we contain Claude across products (Anthropic Engineering)
- Pages created: sources/how-we-contain-claude-across-products, concepts/agent-containment
- Pages updated: concepts/human-agent-oversight (approval fatigue data, HITL volume limits, pre-trust vulnerability class, direct user injection vector), concepts/agentic-security (containment-first principle, egress-as-capability-grant, EDR opacity), concepts/claude-code-harness (sandbox architecture, pre-trust vulnerability class), concepts/multi-agent-coordination (trust escalation, agent identity), concepts/long-running-agents (persistent memory poisoning), entities/anthropic (containment architecture, incident disclosures); wiki/INDEX.md (agent-containment added), projects/ai-native-engineering/INDEX.md (source + concept rows), projects/ai-native-engineering/QUESTIONS.md (3 NatWest-specific questions added), CHANGELOG.md
- Raw source file moved: inbox/How we contain Claude across products.md → wiki/projects/ai-native-engineering/sources/
- Structural suggestions: none
- Contradictions cross-referenced: HITL volume limits (93% approval rate) qualify existing [[human-agent-oversight]] coverage — cross-referenced in both pages

## 2026-05-27 — Lint pass [global]
- Orphans: none (82 pages, 0 orphans)
- Missing pages: none (98 links, 0 missing)
- Index drift: none (0 entries added, 0 removed)
- Stubs ready to expand: none (4 entity stubs — broadcom, forrester, google, jeff-pollard — each have only 1 source page referencing them; threshold not met)
- Stale active pages: none (all pages updated 2026-05-25 or 2026-05-26)
- Contradictions without cross-references: none found
- Archive candidates: none
- QUESTIONS hygiene: 0 items closed, 0 stale (all questions raised within 2 days)

## 2026-05-26 — Ingest | DORA ROI of AI-Assisted Software Development 2026 (Google/DORA)
- Pages created: sources/dora-roi-of-ai-assisted-software-development-2026, concepts/verification-tax
- Pages updated: agentic-productivity-economics (J-Curve, instability finding, brownfield caveat, DORA ROI model, verification-tax link), human-agent-oversight (verification tax as oversight cost, pipeline adaptation controls), sdlc-transformation (pipeline adaptation as third J-Curve component, instability as measurable failure mode), process-debt (DORA "amplifier" thesis, AI does not remediate dysfunction — it accelerates it), wiki/INDEX.md (verification-tax added), projects/ai-native-engineering/INDEX.md (source row + concept row), projects/ai-native-engineering/QUESTIONS.md (4 NatWest-specific DORA questions added), CHANGELOG.md
- Raw source file moved: inbox/dora-roi-of-ai-assisted-software-development-2026.pdf → wiki/projects/ai-native-engineering/sources/
- Structural suggestions: none
- Contradictions cross-referenced: DORA instability finding and brownfield caveat tensions noted in agentic-productivity-economics against existing Anthropic/McKinsey optimistic data; DORA "amplifier" thesis confirmed consistent with fiona-fung process-debt framing

## 2026-05-26 — Ingest (batch) | AI Security project — 8 sources (Project Glasswing / Claude Mythos Preview corpus)
- Pages created: wiki/projects/ai-security/_overview, wiki/projects/ai-security/INDEX, wiki/projects/ai-security/QUESTIONS; sources/anthropic-project-glasswing, sources/anthropic-glasswing-initial-update, sources/aisi-cyber-capability-doubling-rate, sources/cloudflare-glasswing-mythos, sources/broadcom-frontier-ai-security-testing, sources/xbow-mythos-offensive-security, sources/forrester-glasswing-10-consequences, sources/aisi-mythos-cyber-evaluation (stub); concepts/ai-vulnerability-discovery, concepts/vulnerability-chaining, concepts/patch-velocity, concepts/ai-security-harness, concepts/open-source-security-bottleneck; entities/claude-mythos-preview, entities/project-glasswing, entities/aisi, entities/cloudflare, entities/xbow, entities/broadcom, entities/forrester, entities/jeff-pollard; topics/ai-security
- Pages updated: concepts/agentic-security (expanded with Glasswing evidence; linked to ai-security topic hub); entities/anthropic (added Glasswing, Mythos Preview); entities/microsoft (added Glasswing partner status); entities/google (added Glasswing partner status); wiki/INDEX.md (new project, topic, 5 concepts, 8 entities); CHANGELOG.md
- Raw source files moved: All 9 inbox files moved to wiki/projects/ai-security/sources/ (including Claude Mythos Preview System Card.pdf — not yet processed)
- Structural suggestions: New Topic hub [[ai-security]] confirmed by user
- Contradictions cross-referenced: Cloudflare (architectural resilience > raw speed) ↔ Broadcom (velocity framing) — cross-referenced in patch-velocity

## 2026-05-26 — Stub expansion (5 entities) + orphan link fix
- Expanded: antigravity, posthog, stagehand, tessl, wix — all promoted from stub to active
- Inbound link added: agent-factory → agent-factory-legacy-enterprise-platform (output)
- agent-factory.md updated: 2026-05-26

## 2026-05-26 — Lint pass [ai-native-engineering]
- Missing pages: 0
- Orphans: 1 found — outputs/agent-factory-legacy-enterprise-platform.md (0 inbound links); flagged for user decision
- Stubs ready to expand: 5 flagged — antigravity, posthog, stagehand, tessl, wix (all have 4–7 inbound links; flagged for user decision — same as previous lint)
- Stale active pages: 0 (all pages created 2026-05-25/26)
- Contradictions without cross-references: 0 (DORA/McKinsey tension already cross-referenced)
- Archive candidates: 0
- QUESTIONS.md hygiene: 0 items closed (agent-factory platform question already closed [x]); 0 stale items
- Index drift: 1 entry added (outputs/agent-factory-legacy-enterprise-platform.md added to project INDEX.md)

## 2026-05-26 — Lint pass [global]
- Missing pages: 0
- Orphans: 0 (56 pages checked)
- Stubs ready to expand: 6 flagged — antigravity, google, posthog, stagehand, tessl, wix (all have 4–7 inbound links; not expanded — flagged for user decision)
- Stale active pages: 0 (vault is 1 day old)
- Contradictions auto-fixed: 3 cross-references added
  - sdlc-transformation ↔ spec-driven-development: code-wins norm vs. spec-first requirement
  - long-running-agents → agent-adoption-patterns: aspirational autonomy vs. 0–20% full delegation finding
  - claude-code-harness → devops-claude-code-token-drain / agentic-productivity-economics: force consumption FinOps risk
- Archive candidates: 0
- QUESTIONS.md hygiene: 0 items closed (24 open; all require external research or future ingests)
- Index drift: 0 entries added, 0 removed
- Script fix: find-orphans.sh and check-index-drift.sh updated to use `! -name "* *"` instead of `grep -v " "` to correctly exclude raw source files without filtering out paths containing spaces (e.g. "Agenitic OS")

## 2026-05-26 — Ingest | Scaling AI Native Engineering — Fiona Fung (Anthropic London, May 2026)
- Pages created: sources/fiona-fung-scaling-ai-native-engineering-2026, concepts/process-debt, entities/fiona-fung
- Pages updated: sdlc-transformation (bottleneck shift, code-wins debates, process audit discipline, org shape), human-agent-oversight (taste/risk/trust boundaries division), agent-adoption-patterns (Anthropic internal metrics), claude-code-harness (force consumption, process debt maintenance), anthropic (key people), ai-native-engineering (key concepts + evolving thesis), all registries
- Structural suggestions: none
- Contradictions cross-referenced: code-wins/no-design-docs in tension with spec-driven-development; force consumption / 100% claude-assisted commits in tension with FinOps risk from devops-claude-code-token-drain
- Note: source provided inline, no file to move

## 2026-05-26 — Ingest | Scaling Challenges at Base44 (Anthropic London, May 2026)
- Pages created: sources/base44-scaling-challenges-anthropic-london-2026, concepts/production-signal-evals, concepts/commit-driven-onboarding, entities/base44, entities/wix, entities/stagehand, entities/posthog
- Pages updated: claude-code-harness (taste extraction, shift-left QA via skills), human-agent-oversight (production frustration signal), agent-adoption-patterns (speed benchmarks), ai-native-engineering (key concepts + evolving thesis), projects/ai-native-engineering/INDEX.md, projects/ai-native-engineering/QUESTIONS.md, wiki/INDEX.md
- Structural suggestions: none (fits AI Native Engineering project)
- Contradictions cross-referenced: production signal evals limited to consumer products; enterprise/B2B silent failure noted; Base44 simplicity patterns need adaptation for regulated environments
- Note: source provided inline, no file to move

## 2026-05-26 — Restructure | Project-scoped sources folders
- wiki/projects/ai-native-engineering/sources/ created
- All 10 processed source summaries moved from wiki/resources/sources/ to project sources/
- 11 matched raw source files moved from inbox/ to project sources/
- Raw source references in all summary pages updated to new paths
- meta/CLAUDE.md updated: folder layout, inbox rule, hard rules, project folder description
- skills/wiki-ingest/SKILL.md updated: Step 4 points to project sources/; new Step 8 (file move); workflow renumbered to 10 steps
- inbox/ retains 6 files: 2 pending ingestion (encoding issue + URL stub), 4 possible duplicates pending review

## 2026-05-26 — Ingest | Customising AI Coding Agents for Scale (Anthropic London, May 2026)
- Pages created: sources/anthropic-london-customising-agents-at-scale-2026, concepts/context-window-engineering
- Pages updated: claude-code-harness (access pillar, hooks as red squiggly, ICL knowledge section, tooling philosophy), claude-code (fine-tuning anti-pattern), ai-native-engineering (key concepts + evolving thesis), projects/ai-native-engineering/INDEX.md, projects/ai-native-engineering/QUESTIONS.md, wiki/INDEX.md
- Structural suggestions: none (fits AI Native Engineering project)
- Contradictions cross-referenced: ICL-only position noted against any org-level fine-tuning investment; access pillar gap in anthropic-claude-code-large-codebases noted
- Note: transcript partial — MCP deep-dive section not captured; flagged in QUESTIONS.md

## 2026-05-25 — Restructure | Scripted lint (scaled architecture change 2)
- skills/wiki-lint/scripts/find-orphans.sh — counts inbound wikilinks per page, flags < 2
- skills/wiki-lint/scripts/find-missing-pages.sh — finds [[wikilinks]] with 2+ refs but no file
- skills/wiki-lint/scripts/check-index-drift.sh — finds pages not in INDEX.md and broken INDEX entries
- skills/wiki-lint/SKILL.md updated — scripted checks (1, 5, 8) run first; manual checks (2, 3, 4, 6, 7) follow; report only after all 8
- All scripts tested against current vault: 44 pages, 0 orphans, 0 missing, 0 index drift

## 2026-05-25 — Restructure | Project-level navigation (scaled architecture change 1)
- wiki/projects/ai-native-engineering/INDEX.md created — scoped catalog of all project sources, concepts, entities
- wiki/projects/ai-native-engineering/QUESTIONS.md created — all project-specific questions migrated from root
- wiki/INDEX.md reshaped — now a project directory + global resources catalog, not a flat page catalog
- wiki/QUESTIONS.md reshaped — cross-project only; currently empty
- meta/CLAUDE.md updated — vault structure section reflects new project subfolder layout and hard rules
- skills/wiki-ingest/SKILL.md updated — reads project INDEX/QUESTIONS first; Step 8 now updates 4 files
- skills/wiki-lint/SKILL.md updated — project-scoped lint as default; global lint for explicit full passes

## 2026-05-25 — Ingest | 3 sources (FDE, Token Drain, Palantir FDSE)
- Pages created: sources/gigged-forward-deployed-engineer-2026, sources/devops-claude-code-token-drain, concepts/forward-deployed-engineer
- Pages updated: sdlc-transformation (new roles section), claude-code (FinOps risk), agentic-productivity-economics (FinOps risk), ai-native-engineering (topic + project overview), INDEX.md, QUESTIONS.md
- Palantir FDSE blog (2020) folded into forward-deployed-engineer concept page — background context only, no own source page
- Duplicate file (How Claude Code works...1.md) identified and skipped — identical to already-ingested file
- QUESTIONS.md: 3 URL stubs closed, 1 still outstanding (Discover and install prebuilt plugins)
- Structural suggestions: none
- Contradictions cross-referenced: token drain / enterprise readiness tension noted in devops source page vs [[anthropic-claude-code-large-codebases]]

## 2026-05-25 — Ingest | How Claude Code works in large codebases (Anthropic)
- Pages created: sources/anthropic-claude-code-large-codebases, concepts/claude-code-harness, entities/agent-manager
- Pages updated: claude-code (entity), agent-adoption-patterns (concept), ai-native-engineering (topic), projects/ai-native-engineering/_overview, INDEX.md
- Structural suggestions: none (fits within existing AI Native Engineering project)
- Contradictions cross-referenced: none

## 2026-05-25 — Restructure | Extracted ingest and lint workflows to skills
- skills/wiki-ingest/SKILL.md created — full 9-step ingest workflow
- skills/wiki-lint/SKILL.md created — 8-check lint workflow with auto-fix and report format
- meta/CLAUDE.md updated: ingest workflow section removed; lint workflow replaced with pointer to skill; skills/ reference added to hard rules; Query Workflow renumbered to Section 4
- Both skills read meta/CLAUDE.md at runtime for schema — vault-portable by design

## 2026-05-25 — Lint pass
- Missing pages: 0
- Orphans fixed: birgitta-bockeler (added to spec-driven-development), mckinsey (added to agent-factory and agentic-productivity-economics)
- Low inbound fixed: microsoft (added to ai-tooling-landscape)
- Stubs promoted: gemini-cli → active
- QUESTIONS hygiene: 1 item already closed; remaining items valid
- Index drift: 0

## 2026-05-25 — Restructure | Removed raw/ folder
- raw/ folder deleted (empty; purpose served by CHANGELOG.md)
- meta/CLAUDE.md updated: raw/ removed from folder structure, file naming, source frontmatter template, ingest workflow (Step 7 dropped, Step 8 references updated)
- inbox/ is now the permanent home for all source files

## 2026-05-25 — Restructure | Dropped _INGESTED.md
- raw/_INGESTED.md deleted (redundant with CHANGELOG.md)
- meta/CLAUDE.md updated: removed all references to _INGESTED.md, Step 8 now lists two registries not three

## 2026-05-25 — Ingest | 5 articles (McKinsey, CIO, GitHub Spec Kit, Thoughtworks SDD, Kiro docs)
- Pages created: sources/mckinsey-ai-revolution-in-software-development, sources/cio-how-agentic-ai-reshapes-engineering-2026, sources/github-spec-driven-development-spec-kit, sources/thoughtworks-understanding-spec-driven-development
- Concepts created: spec-driven-development, agent-factory
- Entities created: mckinsey, spec-kit, kiro, tessl, birgitta-bockeler
- Pages updated: sdlc-transformation, agentic-productivity-economics, ai-native-engineering (topic), projects/ai-native-engineering/_overview, INDEX.md, QUESTIONS.md
- Kiro docs (Specs - IDE - Docs.md) treated as reference; folded into kiro entity page, not given own source page
- Scaffolding gap in QUESTIONS.md closed — resolved in [[spec-driven-development]] and [[agent-factory]]
- 4 URL stubs and 1 unreadable file flagged in QUESTIONS.md for re-clipping
- Structural suggestions: none
- Contradictions cross-referenced: none

## 2026-05-25 — Ingest | 2026 Agentic Coding Trends Report (Anthropic)
- Pages created: sources/anthropic-agentic-coding-trends-2026
- Concepts created: sdlc-transformation, multi-agent-coordination, long-running-agents, human-agent-oversight, agentic-productivity-economics, agentic-security
- Pages updated: agent-adoption-patterns, agentic-systems (topic), ai-native-engineering (topic), projects/ai-native-engineering/_overview, INDEX.md, QUESTIONS.md
- Vendor bias noted in source page and source summary
- Structural suggestions: none
- Contradictions cross-referenced: "fully delegate 0–20%" finding vs. "agents working for days" narrative — tension noted in anthropic source page

## 2026-05-25 — Ingest | AI Tooling for Software Engineers in 2026 (Pragmatic Engineer)
- Pages created: sources/ai-tooling-for-software-engineers-2026
- Concepts created: enterprise-tool-divergence, agent-adoption-patterns, ai-mainstream-adoption, ai-tooling-landscape
- Entities created: claude-code, cursor, github-copilot, codex, gemini-cli, anthropic, openai, microsoft, google, antigravity, gergely-orosz, the-pragmatic-engineer
- Pages updated: ai-native-engineering (topic), agentic-systems (topic), projects/ai-native-engineering/_overview, INDEX.md, QUESTIONS.md
- Structural suggestions: none
- Contradictions cross-referenced: none (first ingest)

## 2026-05-25 — Setup | Vault initialised

- Folder structure created
- CLAUDE.md schema written (6 sections)
- Navigation files created: INDEX.md, QUESTIONS.md, CHANGELOG.md, _INGESTED.md
- Templates created: note, project, person, concept, entity, topic, source
- Starter wiki pages created: ai-native-engineering (topic + project overview), agentic-systems (topic)
- Dataview dashboard created
- Vault ready for first ingest
