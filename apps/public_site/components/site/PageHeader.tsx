import Link from "next/link";

type PageHeaderProps = {
  title: string;
  subtitle?: string;
  ctaLabel?: string;
  ctaHref?: string;
};

export function PageHeader({ title, subtitle, ctaLabel, ctaHref }: PageHeaderProps) {
  return (
    <section className="w-full">
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex flex-col gap-4">
          <div>
            <h1 className="text-3xl sm:text-4xl font-semibold tracking-tight">{title}</h1>
            {subtitle ? (
              <p className="mt-2 text-base sm:text-lg text-muted-foreground max-w-3xl">
                {subtitle}
              </p>
            ) : null}
          </div>

          {ctaLabel && ctaHref ? (
            <div>
              <Link
                href={ctaHref}
                className="inline-flex items-center justify-center rounded-md bg-primary px-4 py-2 text-primary-foreground text-sm font-medium hover:opacity-90 transition"
              >
                {ctaLabel}
              </Link>
            </div>
          ) : null}
        </div>
      </div>
    </section>
  );
}
