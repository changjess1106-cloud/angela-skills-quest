import json
import os
from datetime import datetime

def load_or_create_issue_cache(cache_path):
    if os.path.exists(cache_path):
        with open(cache_path, "r", encoding="utf-8") as f:
            return json.load(f)
    example = {
        "issues": [
            {
                "issue_number": 1,
                "name": "Angela-Worker-Lite",
                "skill_name": "Skill Example",
                "repo_or_file_url": "https://example.com",
                "skill_type": "AI",
                "short_description": "An example skill submission.",
                "status": "waiting",
                "created_at": "2026-03-08T10:00:00+08:00",
                "updated_at": "2026-03-08T10:00:00+08:00"
            }
        ]
    }
    with open(cache_path, "w", encoding="utf-8") as f:
        json.dump(example, f, indent=2, ensure_ascii=False)
    return example

def evaluate_submission(submission):
    if not submission.get("repo_or_file_url"):
        return "rejected", 100, "Missing URL"

    if submission.get("skill_type") not in ["Python", "JavaScript", "YAML", "JSON", "Markdown", "Other"]:
        return "rejected", 90, "Unapproved skill type"

    keywords = ["steal", "jailbreak", "export API key"]
    if any(kw in submission.get("short_description", "").lower() for kw in keywords):
        return "rejected", 75, "Risky keywords detected"

    # Default pass for scanning phase
    return "scanning", 0, "Initial scan passed"

def process_issues(cache_data):
    waiting, scanning, sandboxing, approved, rejected = 0, 0, 0, 0, 0

    for issue in cache_data["issues"]:
        if issue["status"] == "waiting":
            status, risk, note = evaluate_submission(issue)
            issue["status"] = status
            issue["review_note"] = note
            issue["risk_score"] = risk
            if status == "scanning": scanning += 1
            else: rejected += 1
        elif issue["status"] == "scanning":
            sandboxing += 1

    # Final simplified counters
    outcome = {
        "waiting": waiting,
        "scanning": scanning,
        "sandboxing": sandboxing,
        "approved": approved,
        "rejected": rejected
    }
    return cache_data, outcome

CACHE_PATH = "C:\\workspace\\angela-skills-quest\\storage\\queue\\issue-cache.json"
output = load_or_create_issue_cache(CACHE_PATH)
update=result ....