import { notFound } from "next/navigation";
import { Breadcrumbs } from "@/components/site/Breadcrumbs";
import { PageHeader } from "@/components/site/PageHeader";
import { SectionCard } from "@/components/site/SectionCard";
import { routes } from "@/lib/routes";
import { ar02Counties } from "@/lib/blueprint/counties";
import { issues } from "@/lib/blueprint/issues/issues";
import { IssueCard } from "@/components/blueprint/issues/IssueCard";

export default function CountyIssuesPage({
  params
}: {
  params: { county: string };
}) {
  const county = ar02Counties.find(c => c.slug === params.county);
  if (!county) return notFound();

  return (
    <>
      <Breadcrumbs
        items={[
          { label: "Home", href: routes.home() },
          { label: "Blueprint", href: routes.blueprintIndex() },
          { label: `${county.name} County`, href: routes.county(county.slug) },
          { label: "Issues" }
        ]}
      />

      <PageHeader
        title={`Issues in ${county.name} County`}
        subtitle="What people told us matters most — organized by issue area."
        ctaLabel="Back to county overview"
        ctaHref={routes.county(county.slug)}
      />

      <SectionCard title="Select an issue">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {issues.map(issue => (
            <IssueCard
              key={issue.slug}
              countySlug={county.slug}
              issue={issue}
            />
          ))}
        </div>
      </SectionCard>
    </>
  );
}
