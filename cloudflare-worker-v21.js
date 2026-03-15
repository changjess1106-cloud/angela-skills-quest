export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (request.method === "POST" && url.pathname === "/submit") {
      const data = await request.json();

      const skill = {
        skill: data.skill,
        author: data.author,
        score: parseInt(data.score),
        time: new Date().toISOString()
      };

      const listRaw = await env.SKILLS.get("skills");
      const list = listRaw ? JSON.parse(listRaw) : [];

      list.push(skill);

      await env.SKILLS.put("skills", JSON.stringify(list));

      return new Response(JSON.stringify({ ok: true, skill }), {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
        }
      });
    }

    if (url.pathname === "/skills") {
      const listRaw = await env.SKILLS.get("skills");
      const list = listRaw ? JSON.parse(listRaw) : [];

      return new Response(JSON.stringify(list), {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
        }
      });
    }

    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type"
        }
      });
    }

    return new Response("Angela Skill API");
  }
}
