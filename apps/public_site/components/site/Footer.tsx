import Link from "next/link";
import { routes } from "@/lib/routes";

export function Footer() {
  return (
    <footer className="border-t mt-16">
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 py-10 flex flex-col gap-3 text-sm">
        <div className="flex flex-wrap gap-4">
          <Link className="text-muted-foreground hover:text-foreground" href={routes.sources()}>
            Sources
          </Link>
          <Link className="text-muted-foreground hover:text-foreground" href={routes.privacy()}>
            Privacy
          </Link>
          <Link className="text-muted-foreground hover:text-foreground" href={routes.terms?.() ?? "/terms"}>
            Terms
          </Link>
        </div>
        <p className="text-muted-foreground">
          © {new Date().getFullYear()} Chris Jones for Congress — AR-02. Built for transparency and action.
        </p>
      </div>
    </footer>
  );
}
