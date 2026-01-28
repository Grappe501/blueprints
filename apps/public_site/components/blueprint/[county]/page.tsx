import { notFound } from "next/navigation";
import { PageHeader } from "@/components/site/PageHeader";
import { SectionCard } from "@/components/site/SectionCard";
import { Breadcrumbs } from "@/components/site/Breadcrumbs";
import { TrustMarkers } from "@/components/site/TrustMarkers";
import { routes } from "@/lib/routes";
import { ar02Counties } from "@/lib/blueprint/counties";
import { CountySnapshotCard } from "@/components/blueprint/CountySnapshotCard";

export default function CountyPage({ params }: { params: { county: string } }) {
  const county = ar02Counties.find((c) => c.slug === params.county);
  if (!county) return notFound();

  return (
    <>
      <Breadcrumbs
        items={[
          { label: "Home", href: routes.home() },
          { label: "Blueprint", href: routes.blueprintIndex() },
          { label: `${county.name} County` }
        ]}
      />

      <PageHeader
        title={`${county.name} County`}
        subtitle="What we heard, surfaced clearly — with trust markers and a path to action."
        ctaLabel="Back to Blueprint"
        ctaHref={routes.blueprintIndex()}
      />

      <SectionCard title="Trust markers">
        <TrustMarkers
          heardAt={undefined}
          where={undefined}
          how={undefined}
          sourcesNote={undefined}
        />
      </SectionCard>

      <div className="h-6" />

      <section className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <div className="rounded-xl border bg-card shadow-sm">
            <div className="border-b px-5 py-4">
              <h2 className="text-base font-semibold">What we heard (MVP)</h2>
              <p className="text-sm text-muted-foreground mt-1">
                Placeholder until county narratives + quotes are loaded.
              </p>
            </div>
            <div className="px-5 py-4 text-sm text-muted-foreground space-y-2">
              <p>• Top themes: coming soon</p>
              <p>• Quotes: coming soon</p>
              <p>• Photos: coming soon</p>
            </div>
          </div>

          <div className="rounded-xl border bg-card shadow-sm">
            <div className="border-b px-5 py-4">
              <h2 className="text-base font-semibold">Issues (next)</h2>
              <p className="text-sm text-muted-foreground mt-1">
                Module 3.3 will add /issues and issue drilldowns.
              </p>
            </div>
            <div className="px-5 py-4 text-sm text-muted-foreground">
              Issue taxonomy scaffold coming next.
            </div>
          </div>
        </div>

        <div className="lg:col-span-1">
          <CountySnapshotCard />
        </div>
      </section>
    </>
  );
}
