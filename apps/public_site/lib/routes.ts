export const routes = {
    home: () => "/",
    blueprintIndex: () => "/blueprint",
    county: (countySlug: string) => `/blueprint/${countySlug}`,
    countyIssues: (countySlug: string) => `/blueprint/${countySlug}/issues`,
    glossary: () => "/glossary",
    methodology: () => "/methodology",
    sources: () => "/sources",
    privacy: () => "/privacy",
    terms: () => "/terms",
    about: () => "/about",
  } as const;
  