import Link from "next/link";

export type Crumb = {
  label: string;
  href?: string;
};

export function Breadcrumbs({ items }: { items: Crumb[] }) {
  if (!items || items.length === 0) return null;

  return (
    <nav aria-label="Breadcrumb" className="w-full">
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 pt-6">
        <ol className="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
          {items.map((item, idx) => {
            const isLast = idx === items.length - 1;
            return (
              <li key={`${item.label}-${idx}`} className="flex items-center gap-2">
                {item.href && !isLast ? (
                  <Link href={item.href} className="hover:text-foreground underline-offset-4 hover:underline">
                    {item.label}
                  </Link>
                ) : (
                  <span aria-current={isLast ? "page" : undefined} className={isLast ? "text-foreground" : ""}>
                    {item.label}
                  </span>
                )}
                {!isLast ? <span className="opacity-50">/</span> : null}
              </li>
            );
          })}
        </ol>
      </div>
    </nav>
  );
}
