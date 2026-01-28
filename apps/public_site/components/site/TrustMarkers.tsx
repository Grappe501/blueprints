type TrustMarkersProps = {
    heardAt?: string;   // e.g., "Jan 10–12, 2026"
    where?: string;     // e.g., "Harrison, AR"
    how?: string;       // e.g., "Community listening session"
    sourcesNote?: string; // e.g., "Notes recorded + anonymized"
  };
  
  export function TrustMarkers({ heardAt, where, how, sourcesNote }: TrustMarkersProps) {
    const rows: Array<{ k: string; v?: string }> = [
      { k: "When we heard you", v: heardAt },
      { k: "Where", v: where },
      { k: "How", v: how },
      { k: "Sources", v: sourcesNote },
    ];
  
    return (
      <div className="rounded-lg border bg-muted/30">
        <div className="px-4 py-3 border-b">
          <p className="text-sm font-medium">Trust markers</p>
          <p className="text-xs text-muted-foreground">
            We show dates, method, and sources so you can judge credibility.
          </p>
        </div>
        <dl className="px-4 py-3 grid grid-cols-1 sm:grid-cols-2 gap-3">
          {rows.map((r) => (
            <div key={r.k} className="flex flex-col gap-0.5">
              <dt className="text-xs text-muted-foreground">{r.k}</dt>
              <dd className="text-sm">{r.v ?? <span className="text-muted-foreground">Coming soon</span>}</dd>
            </div>
          ))}
        </dl>
      </div>
    );
  }
  