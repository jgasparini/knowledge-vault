# Wiki Index

Project directory and global resources catalog.
Each project maintains its own scoped index. This file is the entry point — not the full catalog.

---

## Projects

| Project | Index | Summary |
|---------|-------|---------|
| AI Native Engineering | [[ai-native-engineering/INDEX]] | How teams, roles, tooling, and measurement evolve in AI native engineering |
| AI Security | [[ai-security/INDEX]] | How AI is reshaping offensive and defensive security; organisational response to new capabilities and threats |

---

## Global Resources

Concepts, entities, and topics available to all projects.
These pages are created during project ingests but belong to the shared knowledge graph.

### Topics

| Page | Summary |
|------|---------|
| [[ai-native-engineering]] | Overview of AI Native Engineering as a discipline and active project domain |
| [[agentic-systems]] | Overview of agentic AI systems — architectures, patterns, and emerging practice |
| [[ai-security]] | Offensive and defensive AI security; capability growth; enterprise and regulatory response |

### Concepts

| Page | Summary |
|------|---------|
| [[agent-adoption-patterns]] | How agent use varies by seniority and company size; Staff+ lead at 63.5%; full delegation only 0–20% of tasks |
| [[agentic-productivity-economics]] | Productivity gains: output volume not just speed; ~27% is new work; FinOps risk at scale |
| [[agentic-security]] | Dual-use threat surface; security-first architecture; critical for regulated industries |
| [[ai-mainstream-adoption]] | The threshold crossed: 95% weekly AI use, 75% using AI for 50%+ of work |
| [[ai-tooling-landscape]] | Market map of AI coding tools as of early 2026 — categories, players, dynamics |
| [[enterprise-tool-divergence]] | Company size drives tool choice via procurement, not preference |
| [[human-agent-oversight]] | Scaling human attention through intelligent escalation; agents learn when to ask for help |
| [[long-running-agents]] | Agents working hours to days autonomously; new project viability; new failure modes |
| [[multi-agent-coordination]] | Coordinated teams of specialised agents working in parallel; orchestration patterns |
| [[sdlc-transformation]] | SDLC restructures around agentic implementation; engineers shift to orchestrators; new role archetypes |
| [[spec-driven-development]] | Specs as living artefacts driving agent implementation; SDD levels, tools, critical open questions |
| [[agent-factory]] | Two-shift operating model: humans day shift, AI agents night shift; McKinsey's Level 4 |
| [[claude-code-harness]] | Layered extension ecosystem around Claude Code: CLAUDE.md → hooks → skills → plugins → MCP → LSP → subagents |
| [[context-window-engineering]] | Discipline of context placement, KV cache awareness, and zero-overhead abstraction for agentic workloads |
| [[commit-driven-onboarding]] | Using git history and Claude prompts to replace static onboarding docs; always current, zero maintenance overhead |
| [[production-signal-evals]] | Using production user frustration signals as a lightweight quality gate; viable alternative to formal eval suites at early/mid scale |
| [[process-debt]] | Accumulation of team norms that outlive the constraints they were designed to manage; requires active auditing and deletion |
| [[forward-deployed-engineer]] | Customer-embedded engineer who ships production code inside client environments; 800%+ job posting growth 2025 |
| [[ai-vulnerability-discovery]] | AI finds vulnerabilities at machine speed and human-expert quality; capability doubling every 4.7 months |
| [[vulnerability-chaining]] | Combining low-severity findings into high-severity exploits; breaks triage-based vulnerability management |
| [[patch-velocity]] | Shift from triage precision to patching speed; MTTR as the primary defender metric |
| [[ai-security-harness]] | Orchestration architecture for effective AI-assisted vulnerability research |
| [[open-source-security-bottleneck]] | Maintainer capacity as the constraint after AI makes discovery easy |
| [[verification-tax]] | Additional review burden from AI-generated code volume; primary drag on translating individual productivity gains into organisational throughput |
| [[agent-containment]] | Environment-layer architecture for capping agent blast radius: isolation patterns, egress controls, EDR opacity, and the pre-trust vulnerability class |
| [[career-framework-adaptation]] | What Heads of Engineering need to change in levelling, hiring, and performance review for the implementer-to-orchestrator shift |
| [[ai-dlc]] | AWS AI-Driven Development Lifecycle: Inception/Construction/Operation stages; AI Pods (2-3 devs); steering files as embedded governance; financial services framing |
| [[auto-mode-policy]] | The autoMode block design; four-section structure; $defaults trap; OTEL as design input; tool-call governance at team scale |

### Entities

| Page | Summary |
|------|---------|
| [[anthropic]] | Builder of Claude Code and dominant model provider for coding tasks |
| [[antigravity]] | Google's agentic IDE; too new for meaningful survey data |
| [[claude-code]] | #1 AI coding tool (Feb 2026); terminal-first; enterprise harness model; FinOps risk |
| [[codex]] | OpenAI's coding agent; explosive growth — 60% of Cursor's usage within 9 months |
| [[cursor]] | AI-powered IDE; #2 overall, 35% growth, strong with mid-level engineers |
| [[gemini-cli]] | Google's terminal agent; ~10% usage, unusually flat across company sizes |
| [[gergely-orosz]] | Author of The Pragmatic Engineer and the 2026 AI tooling survey |
| [[github-copilot]] | Microsoft's coding assistant; dominant at enterprise via procurement |
| [[google]] | Builder of Gemini CLI and Antigravity |
| [[microsoft]] | Owner of GitHub; distributes Copilot through enterprise agreements |
| [[openai]] | Builder of Codex; faces Anthropic's dominance in coding tasks |
| [[birgitta-bockeler]] | Thoughtworks principal; author of the most rigorous SDD critical analysis |
| [[kiro]] | AWS agentic IDE with built-in spec workflow: Requirements → Design → Tasks |
| [[mckinsey]] | Global consulting firm; source of independent quantitative data on enterprise AI adoption |
| [[spec-kit]] | GitHub's open source SDD toolkit; CLI-based, works with most coding agents |
| [[tessl]] | Private-beta SDD framework; most ambitious spec-as-source approach |
| [[the-pragmatic-engineer]] | Newsletter and platform behind the 2026 survey source |
| [[agent-manager]] | Emerging hybrid PM/engineer role owning Claude Code ecosystem configuration and adoption |
| [[base44]] | Vibe-coding platform; richest available case study for AI-native engineering at startup scale |
| [[wix]] | Acquirer of Base44; no-code platform |
| [[stagehand]] | Browser automation tool for AI-driven QA |
| [[posthog]] | A/B testing and product analytics; MCP-connected for guideline extraction |
| [[fiona-fung]] | Engineering and product lead for Claude Code at Anthropic; primary source for internal Anthropic engineering practice |
| [[claude-mythos-preview]] | Anthropic's unreleased frontier model; first to complete both AISI cyber ranges; centre of Project Glasswing |
| [[project-glasswing]] | 12-company coalition for defensive AI vulnerability research; $100M commitment; ~50 partners |
| [[aisi]] | UK AI Security Institute; produces the most rigorous public AI cyber capability measurements |
| [[cloudflare]] | Glasswing partner; most detailed public harness architecture account |
| [[xbow]] | Independent security platform; offensive AI evaluation; cost-efficiency analysis |
| [[broadcom]] | Glasswing partner; methodology reframe; three-phase industry impact model |
| [[forrester]] | Analyst firm; second- and third-order consequence analysis of Glasswing |
| [[jeff-pollard]] | Forrester security analyst; author of 10-consequences analysis |
| [[langgraph]] | LangChain's stateful agent orchestration framework; used in Cisco multi-agent pilot (93% debug improvement, 65% dev improvement) |
| [[langchain]] | Company and framework suite (LangGraph, LangMem, LangSmith); production multi-agent orchestration |
| [[hedgineer]] | Engineering organisation; primary source for Auto Mode policy design; OTEL-driven managed settings rollout |
| [[salesforce]] | Enterprise software company; most detailed large-enterprise agentic SDLC account; 50.8% work items growth, 151.3% Effective Output growth |
| [[srinivas-tallapragada]] | President and CECSO at Salesforce; author of the Salesforce agentic shift account |
