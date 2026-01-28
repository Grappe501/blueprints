export function CountySnapshotCard() {
    // Phase 5 will power this from Census/BLS/Civics.
    return (
      <div className="rounded-xl border bg-card shadow-sm">
        <div className="border-b px-5 py-4">
          <h2 className="text-base font-semibold">County Snapshot</h2>
          <p className="text-sm text-muted-foreground mt-1">
            Coming soon: population, income, jobs, representation — with sources.
          </p>
        </div>
        <div className="px-5 py-4 grid grid-cols-1 sm:grid-cols-2 gap-3 text-sm">
          <div className="rounded-lg border bg-muted/30 p-3">
            <div className="text-xs text-muted-foreground">Population</div>
            <div className="mt-1">—</div>
          </div>
          <div className="rounded-lg border bg-muted/30 p-3">
            <div className="text-xs text-muted-foreground">Median income</div>
            <div className="mt-1">—</div>
          </div>
          <div className="rounded-lg border bg-muted/30 p-3">
            <div className="text-xs text-muted-foreground">Jobs / unemployment</div>
            <div className="mt-1">—</div>
          </div>
          <div className="rounded-lg border bg-muted/30 p-3">
            <div className="text-xs text-muted-foreground">Representation</div>
            <div className="mt-1">—</div>
          </div>
        </div>
      </div>
    );
  }
  