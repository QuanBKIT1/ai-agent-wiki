# AI Agent Wiki

Knowledge base về AI/LLM — song ngữ Việt-Anh.

Được xây dựng theo [Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): LLM compile raw sources thành wiki cross-linked, kiến thức tích lũy theo thời gian.

## Categories

- **AI Agents Production** — Deploy, vận hành, kiến trúc AI agents trong production
- *(thêm categories mới theo thời gian)*

## Cách đóng góp

1. Thêm bài mới vào `raw/<category>/`
2. Dùng Claude agent với llm-wiki skill để ingest
3. Review wiki pages trong `wiki/`
4. File feedback qua web viewer hoặc Obsidian plugin

## Local preview

```bash
# Web viewer (từ llm-wiki-skill)
cd ~/workspace/llm-wiki-skill/web
npm start -- --wiki ~/workspace/ai-agent-wiki --port 4175

# MkDocs
pip install mkdocs-material pymdown-extensions
cd ~/workspace/ai-agent-wiki
mkdocs serve
```

## Tech stack

- [llm-wiki-skill](https://github.com/LewisLiu819/llm-wiki-skill) — Karpathy-style wiki skill
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) — GitHub Pages
- GitHub Actions — auto deploy on push
