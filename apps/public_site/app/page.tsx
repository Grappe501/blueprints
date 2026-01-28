import Link from "next/link";
import { PageHeader } from "@/components/site/PageHeader";
import { SectionCard } from "@/components/site/SectionCard";
import { routes } from "@/lib/routes";

export default function HomePage() {
  return (
    <>
      <PageHeader
        title="Blueprints"
        subtitle="A public record of what we heard across AR-02 — turned into clarity and action."
        ctaLabel="Enter the Blueprint"
        ctaHref={routes.blueprintIndex()}
      />

      <SectionCard title="How to use this site">
        <div className="space-y-3 text-sm text-muted-foreground">
          <p>
            Start with your county. See the themes, quotes, and trust markers that show when/where/how we listened.
          </p>
          <p>
            Then drill down into issues. Data and action layers come next — built on top of the same foundation.
          </p>
          <div className="pt-2">
            <Link href={routes.blueprintIndex()} className="underline underline-offset-4 hover:opacity-80">
              Go to Blueprint →
            </Link>
          </div>
        </div>
      </SectionCard>
    </>
  );
}
