# CHANGELOG

Running log of all librarian operations. Newest entry at the top.

## 2026-06-07 — Consolidation pass [global]
- Duplicates merged: none
- Status changes: none
- Synthesis actions: 3 (cross-area links added)
- Cross-area links added: 3 — [[agent-containment]] and [[multi-agent-coordination]] added to both [[ai-security/ai-security]] and [[ai-native-engineering/ai-native-engineering]] Key resources (sources filed in the engineering area; threat-surface content — blast radius, supply chain, trust escalation, privilege inheritance — squarely security-area territory); [[human-agent-oversight]] added to [[ai-security/ai-security]] Key resources (Forrester names "documented human oversight between AI discovery and action" as a coming compliance field). Reciprocal links added to each concept's Connections section pointing to both area overviews.

## 2026-06-07 — Ingest | Fine-tuning hallucination research (2 sources)
- Pages created: [[does-fine-tuning-encourage-hallucinations-2024]], [[understanding-new-knowledge-induced-hallucinations-2025]] (source summary pages)
- Pages updated: [[claude-code]] (fine-tuning anti-pattern section deepened with primary citation chain — linear new-knowledge → hallucination relationship, unfamiliarity-vs-proportion mechanism, cross-task propagation, late-training mitigation), [[ai-native-engineering]] (evolving thesis — fourteenth signal closing the open question), wiki/areas/ai-native-engineering/INDEX.md, wiki/areas/ai-native-engineering/QUESTIONS.md
- Structural suggestions: none — both sources fit the existing [[ai-native-engineering]] area and deepen the existing [[claude-code]] fine-tuning anti-pattern note rather than requiring new structure
- Contradictions cross-referenced: none — both sources corroborate the ICL-only position in [[anthropic-london-customising-agents-at-scale-2026]], converting it from an asserted to an evidenced claim
- Note: traced and ingested in response to the open question raised 2026-05-26 ("the Anthropic speaker references late 2025 papers... these papers have not been ingested") — resolved [[does-fine-tuning-encourage-hallucinations-2024]] (Gekhman et al., EMNLP 2024 — the foundational study, predating "late 2025" but establishing the linear relationship) and [[understanding-new-knowledge-induced-hallucinations-2025]] (Dang et al., submitted 2025-11-04 — the mechanism study, the most likely "late 2025" reference); files moved from inbox/ to wiki/areas/ai-native-engineering/sources/

## 2026-06-07 — Schema | Domain-aware lint staleness threshold (resolves issue #11)
- meta/CLAUDE.md Section 3.4 — added optional `decay-rate: fast|slow|stable` field to topic
  hub frontmatter (fast = 45-day, slow = 90-day, stable = 180-day staleness threshold; absent
  field keeps the 30-day default)
- Topic hubs updated with `decay-rate`: [[agentic-systems]] (fast), [[ai-native-engineering]]
  (fast), [[ai-security]] (fast), [[personal-ai-operating-system]] (slow)
- skills/wiki-lint/SKILL.md Check 3 rewritten — resolves the threshold per page: topic hubs
  use their own `decay-rate`; concepts/entities inherit it from the parent hub found via
  reverse wikilink lookup in "Key concepts"/"Key entities" sections (no clear single parent →
  30-day default); everything else keeps the 30-day default
- Note: flat 30-day threshold was producing false positives for slow-moving domains (e.g.
  core banking) and could miss drift in fast-moving ones (e.g. AI security); no new
  `parent-topic` frontmatter field added to concept/entity pages — existing hub→page wikilinks
  are reused for the reverse lookup

## 2026-06-06 — Ingest | Zero Trust for AI Agents (Anthropic ebook)
- Pages created: [[anthropic-zero-trust-ai-agents-2026]] (source summary), [[least-agency]] (concept), [[owasp]] (entity stub)
- Pages updated: [[agentic-security]] (OWASP threat taxonomy; "impossible vs tedious" test; three-tier model; compliance context), [[agent-containment]] (supply chain risks; configuration integrity; source references), [[human-agent-oversight]] ("automate bookkeeping not decisions"; dwell time/coverage as priority metrics; emergency change procedures), [[multi-agent-coordination]] (unscoped privilege inheritance; memory-based privilege retention; credential isolation per agent)
- Structural suggestions: none — no new project, area, or topic hub; all content files into ai-native-engineering
- Contradictions cross-referenced: Foundation tier requirements (cryptographic identity, short-lived tokens) are materially higher than current typical Claude Code deployment posture; tension noted in source summary and [[agent-containment]]
- Note: file moved from inbox/ to wiki/areas/ai-native-engineering/sources/

## 2026-06-06 — Ingest | How Anthropic Founders ACTUALLY Pick What to Build with Claude
- Pages created: [[anthropic-founders-what-to-build-with-claude]] (source summary), [[middle-to-middle]] (concept), [[cost-of-error]] (concept), [[dario-amodei]] (entity stub), [[daniela-amodei]] (entity stub), [[boris-cherny]] (entity stub)
- Pages updated: [[agentic-productivity-economics]] (recalibration framing; Claude Cowork build-time; 80x Q1 2026), [[human-agent-oversight]] (middle-to-middle section; Dario's 5%/95% comparative advantage), [[anthropic]] (developer-focus strategy; Q1 2026 growth; build philosophy summary), [[claude-code]] (Boris Cherny verification loop principle), [[verification-tax]] (cost-of-error as upstream build-selection gate)
- Structural suggestions: none — no new project, area, or topic hub needed; all content fits within ai-native-engineering
- Contradictions cross-referenced: none — source reinforces existing concepts without contradiction; tensions with end-to-end AI noted in [[middle-to-middle]]
- Note: source provided as YouTube URL; transcript retrieved via yt-dlp; reliability rated secondary (third-party synthesis of primary Anthropic founder statements)

## 2026-06-05 — Ingest | The Rise of the Talent Orchestrator (Gigged.AI)
- Pages created: [[talent-orchestrator-gigged-ai-2026]] (source summary), [[talent-orchestration]] (concept), [[gigged-ai]] (entity)
- Pages updated: [[sdlc-transformation]] (40/20/40 model added; tension with AI Pod compression noted), [[career-framework-adaptation]] (leadership layer section added), [[personal-ai-operating-system]] (evolving thesis extended; talent-orchestration added to key concepts), [[ai-operating-system/_overview]] (current status updated)
- Structural suggestions: none — source fits within existing ai-operating-system project and personal-ai-operating-system topic hub
- Contradictions cross-referenced: tension between 40/20/40 FTE floor and AI Pod compression noted in [[sdlc-transformation]] and [[talent-orchestration]]; 55% employer regret figure tensions with positive productivity narrative in [[agentic-productivity-economics]] (cross-reference noted in source page)
- Note: inbox file was a URL stub; article fetched from gigged.ai; file moved from inbox/ to wiki/projects/ai-operating-system/sources/

## 2026-06-04 — Ingest | Tokenomics Foundation
- Pages created: [[tokenomics-foundation-2026]] (source summary), [[tokenomics-foundation]] (entity), [[token-economics]] (concept)
- Pages updated: [[agentic-productivity-economics]] (Tokenomics Foundation as industry FinOps standards signal; [[token-economics]] concept linked)
- Structural suggestions: token-economics topic hub flagged as a future candidate; current source is a website homepage (thin signal) — concept page is appropriate for now
- Contradictions cross-referenced: none — source confirms and extends the FinOps risk already documented in [[agentic-productivity-economics]]
- Note: web article fetched from tokeneconomics.com; file moved from inbox/ to wiki/areas/ai-native-engineering/sources/

## 2026-06-04 — Ingest | How Anthropic enables self-service data analytics with Claude
- Pages created: [[anthropic-self-service-analytics-2026]] (source summary), [[agentic-analytics]] (concept)
- Pages updated: [[claude-code-harness]] (21% → 95%+ skills accuracy benchmark added), [[context-window-engineering]] (context-as-accuracy evidence added), [[production-signal-evals]] (offline evals as complementary methodology for non-conversational agentic products), [[personal-ai-operating-system]] (evolving thesis updated with fifth source)
- Structural suggestions: none — no new project, area, or topic hub needed
- Contradictions cross-referenced: none — source directly corroborates the skills investment thesis and context-window-engineering framing
- Note: web article fetched from claude.com/blog; file moved from inbox/ to wiki/projects/ai-operating-system/sources/

## 2026-06-03 — Lint pass [global]
- Missing pages: 1 stub created ([[ask-the-board]] — 3 wiki references, no page existed)
- Orphans: 2 wiki files flagged (wiki/areas/ai-native-engineering/outputs/2026-05-27-career-framework-adaptation.md — promoted query output, archive artifact; wiki/areas/core-banking/sources/cash-management-requirements-draft.md — draft source file). 25 system/infrastructure files excluded from scope.
- Stubs ready to expand: none (all stubs have <2 sources in frontmatter)
- Contradictions: 1 auto-fixed — tacit code sharing vs. harness abstraction tension cross-referenced in [[claude-code-harness]]
- QUESTIONS hygiene: none closed, none stale, none archived (vault <30 days old)
- Index drift: 1 entry added (ask-the-board to project and root INDEX); system files excluded

## 2026-06-03 — Ingest | Claude Code Can Be Your Second Brain (Every podcast, YouTube)
- Pages created: [[claude-code-second-brain-every-podcast-2026]] (source summary), [[thinking-partner-agent]] (concept), [[noah-bryer]] (entity), [[every]] (entity)
- Pages updated: [[personal-ai-operating-system]] (thinking-partner-agent + noah-bryer + every added; evolving thesis updated with thinking/writing mode distinction and reading capability reframe), [[claude-code-harness]] (thinking mode / writing mode section added; catch-me-up pattern; source ref), [[llm-wiki]] (Noah Bryer's independent implementation added as corroborating evidence)
- Structural suggestions: none — no new project, area, or topic hub needed
- Contradictions cross-referenced: tacit code sharing sits in mild tension with the harness investment thesis (skip abstraction vs. build shared skills); noted in source summary as context-dependent, not a true contradiction
- Note: transcript extracted via yt-dlp from Every YouTube channel; host Dan Shipper, guest Noah Bryer

## 2026-06-03 — Ingest | Claude Code + Karpathy's NEW Self-Evolving System (YouTube)
- Pages created: [[karpathy-llm-wiki-self-evolving-system-2026]] (source summary), [[llm-wiki]] (concept), [[andrej-karpathy]] (entity), [[world-of-ai]] (entity)
- Pages updated: [[personal-ai-operating-system]] (llm-wiki + andrej-karpathy added to key concepts/entities; evolving thesis updated with three-framework synthesis), [[ai-operating-system/_overview]] (current status updated with third source)
- Structural suggestions: none — no new project, area, or topic hub needed
- Contradictions cross-referenced: none; this source provides the conceptual origin for the architecture this vault already implements
- Note: transcript extracted via yt-dlp; creator is WorldofAI, subject is Andrej Karpathy's LLM Wiki concept; saved to wiki/projects/ai-operating-system/sources/

## 2026-06-03 — Ingest | How I Use Claude Cowork to Automate 99% Of My Life (YouTube)
- Pages created: [[cowork-os-automate-life-guide-2026]] (source summary), [[scheduled-tasks]] (concept), [[paul-j-lipsky]] (entity)
- Pages updated: [[personal-ai-operating-system]] (evolving thesis updated; scheduled-tasks and paul-j-lipsky added to key concepts/entities), [[claude-code-harness]] (skill-capture pattern + scheduled-tasks connection + source ref), [[context-window-engineering]] (folder-scoping principle added as evidence + source ref), [[ai-operating-system/_overview]] (current status updated), [[6-skills-10x-claude-projects-2026]] (creator entity link added)
- Structural suggestions: none — no new project, area, or topic hub needed
- Contradictions cross-referenced: none — folder-scoping principle consistent with existing context-window-engineering framing
- Note: transcript extracted via yt-dlp; saved to wiki/projects/ai-operating-system/sources/; no inbox file

## 2026-06-03 — Ingest | The ONLY 6 Skills You Need to 10x Your Claude Projects (YouTube)
- Pages created: [[6-skills-10x-claude-projects-2026]] (source summary), [[internal-focus-group]] (concept)
- Pages updated: [[personal-ai-operating-system]] (populated from stub: evolving thesis, key concepts, key entities, sources), [[claude-code-harness]] (connections + source ref added), [[ai-operating-system/_overview]] (current status updated with first source)
- Structural suggestions: none — no new project, area, or topic hub needed
- Contradictions cross-referenced: minor framing difference between browser scraping (this source) and MCP connections (claude-code-harness) as primary data access mechanisms; noted as complementary in source summary
- Note: transcript extracted via yt-dlp; saved to wiki/projects/ai-operating-system/sources/; no inbox file

## 2026-06-03 — Structural | Promote AI Native Engineering from project to area
- Moved: wiki/projects/ai-native-engineering/ → wiki/areas/ai-native-engineering/
- Renamed: _overview.md → ai-native-engineering.md (area convention)
- Reframed: frontmatter type: project → area; removed deadline/stakeholders/review-date/goal fields; restructured sections to area schema (What this covers, Current focus, Key resources, Related projects, People)
- Updated: wiki/INDEX.md — AI Native Engineering row moved from Projects table to Areas table; link updated to [[ai-native-engineering/ai-native-engineering]]; Projects section retained for AI Operating System
- Updated: wiki/areas/ai-native-engineering/INDEX.md — header and section labels updated from "project" to "area"
- Rationale: area has no end date or completion state; it is a standing research responsibility

## 2026-06-03 — Structural | Promote AI Security from project to area
- Moved: wiki/projects/ai-security/ → wiki/areas/ai-security/
- Renamed: _overview.md → ai-security.md (area convention)
- Reframed: frontmatter type: project → area; removed deadline/stakeholders/review-date/goal fields; restructured sections to area schema (What this covers, Current focus, Key resources, Related projects, People)
- Updated: wiki/INDEX.md — AI Security row moved from Projects table to Areas table; link updated to [[ai-security/ai-security]]
- Updated: wiki/areas/ai-security/INDEX.md — header and section labels updated from "project" to "area"
- Rationale: area has no end date or completion state; it is a standing research responsibility that will continue to grow

## 2026-06-03 — Setup | AI Operating System
- Project folder created: wiki/projects/ai-operating-system/
- Files created: _overview.md, INDEX.md, QUESTIONS.md, sources/
- Topic hub created: [[personal-ai-operating-system]]
- Root INDEX.md updated: project row and topic hub row added

## 2026-06-03 — Ingest | Cash Management Capability — Requirements & Estimable Specification
- Pages created: [[cash-management-requirements]] (source summary), [[cash-management]] (concept)
- Pages updated: [[core-banking/core-banking]] (current focus and key resources), [[wiki/INDEX]] (cash-management concept added)
- Structural suggestions: flagged possibility of dedicated project for cash management capability; user chose to file as area source
- Contradictions cross-referenced: none — new domain
- Note: file moved from inbox/ → wiki/areas/core-banking/sources/

## 2026-06-03 — Structural | Create core banking area
- Area created: [[core-banking/core-banking]]
- wiki/INDEX.md updated: core-banking row added to Areas section
- Note: stub page, no sources ingested yet

## 2026-06-03 — Ingest | Caveman — the token-efficient stack for agent-native builders
- Pages created: [[caveman-token-efficient-stack]] (source summary), [[caveman]] (entity stub)
- Pages updated: [[context-window-engineering]] (compression vs. placement note; Caveman added to connections), [[spec-driven-development]] (Cavekit added to tools), [[ai-tooling-landscape]] (open-source community category added), [[ai-native-engineering]] (topic hub — thirteenth signal added to evolving thesis; Caveman added to entities)
- Structural suggestions: none — no new Project, Area, or Topic hub needed
- Contradictions cross-referenced: Caveman's compression approach (~75–77%) noted as complementary to (not contradictory with) [[context-window-engineering]]'s placement discipline; claims self-reported and unverified
- Note: file moved from inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-06-03 — Ingest | A harness for every task: dynamic workflows in Claude Code
- Pages created: [[anthropic-dynamic-workflows-claude-code]] (source summary), [[dynamic-workflows]] (concept)
- Pages updated: [[claude-code-harness]] (dynamic workflows added as orchestration tier; new section; connections updated), [[multi-agent-coordination]] (seven workflow patterns taxonomy added), [[claude-code]] entity (dynamic workflows section added), [[ai-native-engineering]] (topic hub — dynamic-workflows added to key concepts; thirteenth signal added to evolving thesis)
- Structural suggestions: none — no new Project, Area, or Topic hub needed
- Contradictions cross-referenced: none — additive to existing pages
- Note: file moved from inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-06-02 — Consolidation pass [global]
- Duplicates merged: none
- Status changes: [[google]] stub → active (2 sources, substantive content across four sections)
- Synthesis actions: 4 wikilinks added to [[ai-native-engineering]] topic hub Key concepts section ([[long-running-agents]], [[verification-tax]], [[agent-containment]], [[auto-mode-policy]]); missing reciprocal link [[agentic-security]] added to [[auto-mode-policy]] How it connects section

## 2026-06-02 — Ingest | Expanding Project Glasswing | Anthropic
- Pages created: [[anthropic-glasswing-expansion]] (source summary), [[claude-security]] (entity)
- Pages updated: [[project-glasswing]] (partner count, sectors, patching shift, Claude Security link), [[ai-security]] (topic hub — evolving thesis, entities list), [[patch-velocity]] (Anthropic patching commitment added), [[ai-security/INDEX]] (new source and entity rows), [[ai-security/QUESTIONS]] (Claude Security question partially resolved; three new questions added), [[wiki/INDEX]] (project-glasswing summary updated; claude-security entity added)
- Structural suggestions: none — no new Project, Area, or Topic hub needed
- Contradictions cross-referenced: expansion pace vs. controlled-rollout framing noted in [[anthropic-glasswing-expansion]] and [[project-glasswing]]; Opus 4.8 vs. Mythos Preview capability distinction noted in [[claude-security]] and [[anthropic-glasswing-expansion]]
- Note: file moved from inbox/ → wiki/projects/ai-security/sources/

## 2026-06-02 — Ingest | Microsoft Build 2026 Recap: Windows Is Now an Agent Platform, and Project Polaris Cuts the OpenAI Cord
- Pages created: [[microsoft-build-2026-recap]] (source summary), [[project-polaris]], [[windows-agent-framework]], [[azure-agent-mesh]], [[copilot-workspace]]
- Pages updated: [[microsoft]], [[github-copilot]], [[ai-tooling-landscape]], [[multi-agent-coordination]], [[long-running-agents]], [[ai-native-engineering]] (topic hub, twelfth thesis signal)
- Structural suggestions: none — no new Project, Area, or Topic hub needed
- Contradictions cross-referenced: Microsoft "dual exposure" framing (investment in OpenAI vs. Project Polaris cutting coding model dependency) noted in [[microsoft]] and [[microsoft-build-2026-recap]]; Copilot competitive characterisation tension (pre-Polaris survey data) noted in [[github-copilot]] and [[microsoft-build-2026-recap]]
- Note: file moved from inbox/ → wiki/projects/ai-native-engineering/sources/

## 2026-06-01 — Ingest | Nuffield Health MRI appointment confirmation (21 May 2026)
- Pages created: [[nuffield-health-mri-appointment-confirmation-2026-05-21]], [[nuffield-health-edinburgh]] (entity stub)
- Pages updated: [[health/health]] (current focus: MRI completed 28 May; results with Cowie; next step in-person review), [[cowie-clinic-letter-2026-05-18]] (cross-referenced as trigger for scan), [[wiki/INDEX]] (nuffield-health-edinburgh entity added)
- Structural suggestions: none
- Contradictions cross-referenced: none
- Note: source provided inline from Outlook inbox; no file to move

## 2026-06-01 — Ingest | Mr Cowie clinic letter (18 May 2026) + Square Health referral letter (actual PDF)
- Pages created: [[cowie-clinic-letter-2026-05-18]], [[jonathan-cowie]] (entity stub)
- Pages updated: [[square-health-referral-letter-2026-05-07]] (actual referral letter content incorporated; gap from prior email ingest resolved), [[health/health]] (current focus: MRI scan next step; Cowie contact details and hospital reference added), [[aviva-health-authorisation-251215-25]] (cross-reference to first clinical follow-on), [[wiki/INDEX]] (jonathan-cowie entity added)
- Structural suggestions: none
- Contradictions cross-referenced: none
- Note: both files moved from inbox/ → wiki/areas/health/sources/

## 2026-06-01 — Ingest | Square Health referral letter, Dr Hsaung Nadi
- Pages created: [[square-health-referral-letter-2026-05-07]], [[square-health]]
- Pages updated: [[health/health]] (key resources), [[wiki/INDEX]] (entity added), [[aviva-health-authorisation-251215-25]] (cross-reference added)
- Structural suggestions: none
- Contradictions cross-referenced: none — sequential with Aviva authorisation
- Note: source provided inline from Outlook inbox; referral letter attachment to be ingested separately

## 2026-06-01 — Ingest | Aviva Health claim authorisation 251215/25
- Pages created: [[aviva-health-authorisation-251215-25]], [[aviva-health]]
- Pages updated: [[health/health]] (current focus), [[wiki/INDEX]] (entity added)
- Structural suggestions: none
- Contradictions cross-referenced: none
- Note: source provided inline from Outlook inbox (no file to move); suspected meniscus tear, knee network, Spire Murrayfield Edinburgh

## 2026-06-01 — Structural | Create health area
- Area created: [[health/health]]
- wiki/INDEX.md updated: Areas section added
- Note: stub page, no sources ingested yet
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
