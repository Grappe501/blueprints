import Link from "next/link";
import { routes } from "@/lib/routes";
import type { County } from "@/lib/blueprint/counties";

export function CountyCard({ county }: { county: County }) {
  return (
    <Link
      href={routes.county(county.slug)}
      className="block rounded-xl border bg-card shadow-sm hover:shadow transition p-5"
    >
      <div className="flex items-center justify-between gap-3">
        <div>
          <h3 className="text-base font-semibold">{county.name} County</h3>
          <p className="text-sm text-muted-foreground mt-1">
            What we heard • Themes • Quotes • Trust markers
          </p>
        </div>
        <span className="text-sm text-muted-foreground">View →</span>
      </div>
    </Link>
  );
}
