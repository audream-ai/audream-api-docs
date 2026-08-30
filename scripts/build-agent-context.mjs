import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";

const rootDirectory = process.argv[2];
const outputPath = process.argv[3];

if (!rootDirectory || !outputPath) {
  throw new Error(
    "Usage: node scripts/build-agent-context.mjs <root-directory> <output-path>",
  );
}

const sourcePaths = [
  "index.mdx",
  "quickstart.mdx",
  "authentication.mdx",
  "guides/audio-to-insights.mdx",
  "guides/ask-across-notes.mdx",
  "guides/agent-integrations.mdx",
  "guides/processing-status.mdx",
  "guides/security.mdx",
];

function normalizeMdx(body) {
  return body
    .replace(/<CardGroup[^>]*>\s*/g, "")
    .replace(/\s*<\/CardGroup>/g, "")
    .replace(/<Card\s+([^>]+)>/g, (_match, attributes) => {
      const title = attributes.match(/\btitle="([^"]+)"/)?.[1] ?? "Resource";
      const href = attributes.match(/\bhref="([^"]+)"/)?.[1];
      const resourceUrl = href?.startsWith("/")
        ? `https://docs.audream.ai${href}`
        : href;

      return resourceUrl
        ? `### ${title}\n\nResource: ${resourceUrl}\n\n`
        : `### ${title}\n\n`;
    })
    .replace(/\s*<\/Card>/g, "")
    .replace(/<Note>/g, "**Note:**")
    .replace(/<\/Note>/g, "")
    .replace(/<Warning>/g, "**Warning:**")
    .replace(/<\/Warning>/g, "")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function parseDocument(source, sourcePath) {
  const frontmatterMatch = source.match(/^---\n([\s\S]*?)\n---\n?/);
  const frontmatter = frontmatterMatch?.[1] ?? "";
  const titleMatch = frontmatter.match(/^title:\s*["']?(.+?)["']?\s*$/m);
  const descriptionMatch = frontmatter.match(
    /^description:\s*["']?(.+?)["']?\s*$/m,
  );
  const title = titleMatch?.[1] ?? sourcePath;
  const description = descriptionMatch?.[1];
  const body = normalizeMdx(
    frontmatterMatch ? source.slice(frontmatterMatch[0].length) : source,
  );

  return [
    `# ${title}`,
    description ? `\n> ${description}` : "",
    `\n\nSource: https://docs.audream.ai/${sourcePath.replace(/(?:^index)?\.mdx$/, "").replace(/\.mdx$/, "")}`,
    `\n\n${body}`,
  ].join("");
}

const documents = await Promise.all(
  sourcePaths.map(async (sourcePath) => {
    const source = await readFile(path.join(rootDirectory, sourcePath), "utf8");
    return parseDocument(source, sourcePath);
  }),
);

const output = [
  "# Audream API complete documentation",
  "",
  "> Agent-ready context for building audio-to-insight workflows with Audream.",
  "",
  "OpenAPI specification: https://docs.audream.ai/openapi.yaml",
  "Production API: https://audream-api.tulingbc.com",
  "",
  ...documents.flatMap((document) => ["---", "", document, ""]),
].join("\n");

await writeFile(outputPath, `${output.trim()}\n`);
console.log(`Agent context written to ${outputPath}`);
