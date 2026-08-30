import { readdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";

const buildDirectory = process.argv[2];

if (!buildDirectory) {
  throw new Error("Usage: node scripts/postprocess-cloudflare.mjs <build-directory>");
}

const stylesheet =
  '<link rel="stylesheet" href="/audream-overrides.css" data-audream-override="true"/>';
const generatorMetadata = '<meta name="generator" content="Mintlify"/>';

async function collectHtmlFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const nestedFiles = await Promise.all(
    entries.map(async (entry) => {
      const entryPath = path.join(directory, entry.name);

      if (entry.isDirectory()) {
        return collectHtmlFiles(entryPath);
      }

      return entry.isFile() && entry.name.endsWith(".html") ? [entryPath] : [];
    }),
  );

  return nestedFiles.flat();
}

const htmlFiles = await collectHtmlFiles(buildDirectory);

if (htmlFiles.length === 0) {
  throw new Error(`No HTML files found in ${buildDirectory}`);
}

for (const htmlFile of htmlFiles) {
  const originalHtml = await readFile(htmlFile, "utf8");

  if (!originalHtml.includes("</head>")) {
    throw new Error(`Missing </head> in ${htmlFile}`);
  }

  const htmlWithoutGenerator = originalHtml.replaceAll(generatorMetadata, "");
  const processedHtml = htmlWithoutGenerator.includes(stylesheet)
    ? htmlWithoutGenerator
    : htmlWithoutGenerator.replace("</head>", `${stylesheet}</head>`);

  if (processedHtml !== originalHtml) {
    await writeFile(htmlFile, processedHtml);
  }
}

console.log(`Post-processed ${htmlFiles.length} HTML files`);
