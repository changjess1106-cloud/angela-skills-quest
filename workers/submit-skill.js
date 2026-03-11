export default {
 async fetch(request, env) {
 const url = new URL(request.url);
 if (request.method === "GET" && url.pathname === "/health") {
 return new Response(JSON.stringify({ ok: true, service: "submit-skill-worker" }), { headers: { "Content-Type": "application/json" } });
 }
 if (request.method === "POST" && url.pathname === "/submit-skill") {
 const body = await request.json();
 return new Response(JSON.stringify({ ok: true, submission_id: body.submission_id || "sub-demo" }), { headers: { "Content-Type": "application/json" } });
 }
 return new Response("Not Found", { status: 404 });
 }
};
