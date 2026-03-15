export const API_BASE = "https://angela-skill-api.changjess1106.workers.dev";

export async function submitSkill(payload) {
  const res = await fetch(API_BASE + "/submit", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error("Submit failed: " + text);
  }

  return await res.json();
}

export async function getSkills() {
  const res = await fetch(API_BASE + "/skills");

  if (!res.ok) {
    const text = await res.text();
    throw new Error("Load skills failed: " + text);
  }

  return await res.json();
}
