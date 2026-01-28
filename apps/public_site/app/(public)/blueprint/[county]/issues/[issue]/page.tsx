import { notFound } from "next/navigation";
import { Breadcrumbs } from "@/components/site/Breadcrumbs";
import { PageHeader } from "@/components/site/PageHeader";
import { SectionCard } from "@/components/site/SectionCard";
import { TrustMarkers } from "@/components/site/TrustMarkers";
import { routes } from "@/lib/routes";
import { ar02Counties } from "@/lib/blueprint/counties";
import { issues } from "@/lib/blueprint/issues/issues";

export default function CountyIssuePage({
  params
}: {
  params: { county: string; issue: string };
}) {
  const county = ar02Counties.find(c => c.slug === params.county);
  const issue = issues.find(i => i.slug === params.issue);

  if (!county || !issue) return notFound();

  return (
    <>
      <Breadcrumbs
        items={[
          { label: "Home", href: routes.home() },
          { label: "Blueprint", href: routes.blueprintIndex() },
          { label: `${county.name} County`, href: routes.county(county.slug) },
          { label: "Issues", href: `${routes.county(county.slug)}/issues` },
          { label: issue.name }
        ]}
      />

      <PageHeader
        title={`${issue.name} — ${county.name} County`}
        subtitle={issue.description}
        ctaLabel="Back to issues"
        ctaHref={`${routes.county(county.slug)}/issues`}
      />

      <SectionCard title="Trust markers">
        <TrustMarkers />
      </SectionCard>

      <div className="h-6" />

      <SectionCard title="What we heard (MVP)">
        <p className="text-sm text-muted-foreground">
          Placeholder for county-specific narratives, quotes, and patterns
          related to this issue. This content will be populated from
          Blueprint sessions and reviewed AI summaries in Phase 4.
        </p>
      </SectionCard>

      <SectionCard title="What the data will show (next)">
        <p className="text-sm text-muted-foreground">
          Phase 5 will add Census, BLS, and other public data relevant to
          this issue — clearly explained and cited.
        </p>
      </SectionCard>
    </>
  );
}
