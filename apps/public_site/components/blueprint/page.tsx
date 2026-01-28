import { PageHeader } from "@/components/site/PageHeader";
import { SectionCard } from "@/components/site/SectionCard";
import { Breadcrumbs } from "@/components/site/Breadcrumbs";
import { routes } from "@/lib/routes";
import { ar02Counties } from "@/lib/blueprint/counties";
import { CountyCard } from "@/components/blueprint/CountyCard";

export default function BlueprintIndexPage() {
  return (
    <>
      <Breadcrumbs items={[{ label: "Home", href: routes.home() }, { label: "Blueprint" }]} />
      <PageHeader
        title="Blueprint"
        subtitle="County-by-county: what we heard, how we heard it, and what it means."
        ctaLabel="Start with your county"
        ctaHref={routes.county(ar02Counties[0].slug)}
      />

      <SectionCard title="Choose a county">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {ar02Counties.map((c) => (
            <CountyCard key={c.slug} county={c} />
          ))}
        </div>
      </SectionCard>

      <div className="h-6" />

      <SectionCard title="What you’ll see here (MVP)">
        <ul className="list-disc pl-5 text-sm text-muted-foreground space-y-2">
          <li>Trust markers (date, place, method, source notes)</li>
          <li>Top themes and issue categories (initially placeholders)</li>
          <li>Quotes (privacy-aware) and photos (where permitted)</li>
          <li>County Snapshot panel scaffold (data comes in Phase 5)</li>
        </ul>
      </SectionCard>
    </>
  );
}
