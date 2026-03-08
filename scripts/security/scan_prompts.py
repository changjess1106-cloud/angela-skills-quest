import os
import json
import datetime

# 專案根目錄
BASE_DIR = r"C:\workspace\angela-skills-quest"
# 目前沒有 skills 資料夾，就先掃整個專案（排除 .git、報告資料夾）
SCAN_ROOT = BASE_DIR
REPORT_DIR = r"C:\workspace\storage\reports\security-scan"
RULES_PATH = os.path.join(BASE_DIR, "scripts", "security", "rules.json")

os.makedirs(REPORT_DIR, exist_ok=True)

def load_rules():
    """
    你的 rules.json 是一個 list：
    [
      {"id": "...", "pattern": "...", "severity": "...", "description": "..."},
      ...
    ]
    這裡直接原樣讀進來。
    """
    with open(RULES_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
    # 確保都是 dict，且包含 pattern
    rules = []
    for item in data:
        if isinstance(item, dict) and "pattern" in item:
            rules.append(item)
    return rules

def scan_file(filepath, rules):
    findings = []
    try:
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read().lower()

        for rule in rules:
            pattern = rule.get("pattern", "").lower()
            if not pattern:
                continue
            if pattern in content:
                findings.append({
                    "id": rule.get("id"),
                    "pattern": rule.get("pattern"),
                    "severity": rule.get("severity"),
                    "description": rule.get("description"),
                })

    except Exception as e:
        findings.append({
            "id": "read-error",
            "pattern": "",
            "severity": "unknown",
            "description": f"讀檔錯誤: {str(e)}",
        })

    return findings

def main():
    rules = load_rules()
    report = {
        "timestamp": str(datetime.datetime.now()),
        "scan_root": SCAN_ROOT,
        "rules_count": len(rules),
        "results": []
    }

    print("🔍 開始掃描專案目錄…")
    print(f"   根目錄: {SCAN_ROOT}")
    print(f"   使用規則數量: {len(rules)}\n")

    if not os.path.isdir(SCAN_ROOT):
        print(f"❌ 找不到掃描根目錄：{SCAN_ROOT}")
        return

    total_files = 0
    hit_files = 0
    total_findings = 0

    for root, dirs, files in os.walk(SCAN_ROOT):
        # 排除 .git 和報告資料夾避免自己掃自己
        dirs[:] = [
            d for d in dirs
            if d not in [".git", ".github"]
            and not (root.startswith(REPORT_DIR) or d == "security-scan")
        ]

        for file in files:
            path = os.path.join(root, file)

            # ⛔ 不掃自己（規則檔）
            if os.path.abspath(path) == os.path.abspath(RULES_PATH):
                continue

            total_files += 1

            findings = scan_file(path, rules)
            if findings:
                hit_files += 1
                total_findings += len(findings)
                print(f"⚠️  檔案疑似含惡意提示：{path}")
                for fnd in findings:
                    print(f"    - [{fnd.get('severity')}] {fnd.get('id')}: {fnd.get('pattern')}")
                print("")

            report["results"].append({
                "file": path,
                "findings": findings,
            })

    # 寫入報告
    out_json = os.path.join(REPORT_DIR, "scan_report.json")
    out_txt = os.path.join(REPORT_DIR, "scan_summary.txt")

    with open(out_json, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=4, ensure_ascii=False)

    with open(out_txt, "w", encoding="utf-8") as f:
        f.write(f"掃描根目錄: {SCAN_ROOT}\n")
        f.write(f"規則數量: {len(rules)}\n")
        f.write(f"總檔案數: {total_files}\n")
        f.write(f"命中檔案數: {hit_files}\n")
        f.write(f"總命中規則次數: {total_findings}\n\n")

        for entry in report["results"]:
            if entry["findings"]:
                f.write(f"[檔案] {entry['file']}\n")
                for fnd in entry["findings"]:
                    f.write(
                        f"  - [{fnd.get('severity')}] {fnd.get('id')}: "
                        f"{fnd.get('pattern')}  # {fnd.get('description')}\n"
                )
                f.write("\n")

    print("✅ 掃描完成！")
    print(f"   📄 JSON 報告: {out_json}")
    print(f"   📄 TXT 摘要: {out_txt}")
    print(f"\n統計：共掃描 {total_files} 個檔案，其中 {hit_files} 個檔案有命中規則，總命中 {total_findings} 次。")

if __name__ == "__main__":
    main()