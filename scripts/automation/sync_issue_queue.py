import json
import os
from datetime import datetime

def generate_sample_cache():
    sample_data = {
        "issues": [
            {
                "issue_number": 1,
                "title": "[Skill Submission] Angela-Example",
                "angela_name": "Angela-Example",
                "skill_name": "Example Skill",
                "repo_or_file_url": "https://github.com/example/repo",
                "skill_type": "AI",
                "short_description": "An example skill submission.",
                "status": "waiting",
                "created_at": "2026-03-08T10:00:00+08:00",
                "updated_at": "2026-03-08T10:00:00+08:00"
            }
        ]
    }
    return sample_data

def update_submission_status(issue_cache, status_file):
    current_time = datetime.now().isoformat()
    queue = {"waiting": 0, "scanning": 0, "sandboxing": 0, "approved": 0, "rejected": 0}
    recent = []

    for issue in issue_cache.get("issues", []):
        queue[issue.get("status", "waiting")] += 1
        recent.append({
            "issue_number": issue["issue_number"],
            "name": issue["angela_name"],
            "skill_name": issue["skill_name"],
            "status": issue["status"],
            "note": "Submission received and queued."
        })

    recent = sorted(recent, key=lambda x: x["issue_number"], reverse=True)[:10]

    submission_status = {
        "updated_at": current_time,
        "queue": queue,
        "recent": recent
    }

    with open(status_file, "w", encoding="utf-8") as f:
        json.dump(submission_status, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    repo_path = "C:\\workspace\\angela-skills-quest"
    cache_path = os.path.join(repo_path, "storage", "queue", "issue-cache.json")
    status_path = os.path.join(repo_path, "docs", "data", "submission-status.json")

    if not os.path.exists(cache_path):
        issue_cache = generate_sample_cache()
        with open(cache_path, "w", encoding="utf-8") as f:
            json.dump(issue_cache, f, ensure_ascii=False, indent=2)
    else:
        with open(cache_path, "r", encoding="utf-8") as f:
            issue_cache = json.load(f)

    update_submission_status(issue_cache, status_path)
    print("Sync complete. Updated submission-status.json.")