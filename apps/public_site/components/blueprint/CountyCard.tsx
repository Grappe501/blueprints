import Link from "next/link";
import { routes } from "@/lib/routes";
import type { County } from "@/lib/blueprint/counties";

type CountyCardProps = {
  county: County;
};

export function CountyCard({ county }: CountyCardProps) {
  return (
    <div className="flex items-center justify-between rounded-lg border p-4">
      <div>
        <h3 className="font-medium">{county.name} County</h3>
        <p className="text-sm text-muted-foreground">
          What we heard · Themes · Quotes · Trust markers
        </p>
      </div>

      <Link
        href={routes.county(county.slug)}
        className="text-sm font-medium hover:underline"
      >
        View →
      </Link>
    </div>
  );
}
