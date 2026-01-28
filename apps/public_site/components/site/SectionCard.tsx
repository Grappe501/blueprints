import { ReactNode } from "react";

export function SectionCard({
  title,
  children,
  right,
}: {
  title: string;
  children: ReactNode;
  right?: ReactNode;
}) {
  return (
    <section className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
      <div className="rounded-xl border bg-card text-card-foreground shadow-sm">
        <div className="flex items-start justify-between gap-4 border-b px-5 py-4">
          <h2 className="text-base font-semibold">{title}</h2>
          {right ? <div className="shrink-0">{right}</div> : null}
        </div>
        <div className="px-5 py-4">{children}</div>
      </div>
    </section>
  );
}
