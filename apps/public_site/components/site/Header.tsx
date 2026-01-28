import Link from "next/link";
import { routes } from "@/lib/routes";

export function Header() {
  return (
    <header className="sticky top-0 z-20 border-b bg-background/80 backdrop-blur">
      <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 h-14 flex items-center justify-between">
        <Link href={routes.home()} className="font-semibold tracking-tight">
          BLUEPRINTS
        </Link>

        <nav className="flex items-center gap-4 text-sm">
          <Link href={routes.blueprintIndex()} className="text-muted-foreground hover:text-foreground">
            Blueprint
          </Link>
          <Link href={routes.glossary()} className="text-muted-foreground hover:text-foreground">
            Glossary
          </Link>
          <Link href={routes.methodology()} className="text-muted-foreground hover:text-foreground">
            Method
          </Link>
          <Link href={routes.about()} className="text-muted-foreground hover:text-foreground">
            About
          </Link>
        </nav>
      </div>
    </header>
  );
}
