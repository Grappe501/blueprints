# make_skeleton.ps1
# Creates (or repairs) the full Blueprints skeleton in the current directory.
# Idempotent: safe to run multiple times without errors.

$ErrorActionPreference = "Stop"

function Touch($path) {
  $dir = Split-Path $path
  if ($dir -and !(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  if (!(Test-Path $path)) {
    New-Item -ItemType File -Path $path -Force | Out-Null
  }
}

function Mkdir($path) {
  if (!(Test-Path $path)) {
    New-Item -ItemType Directory -Path $path -Force | Out-Null
  }
}

Write-Host "Creating Blueprints skeleton..." -ForegroundColor Cyan

# Root files
Touch ".\master_build.md"
Touch ".\README.md"
Touch ".\LICENSE.md"
Touch ".\.gitignore"
Touch ".\.editorconfig"

# Docs
Mkdir ".\docs\decisions"
Mkdir ".\docs\product"
Mkdir ".\docs\data"
Mkdir ".\docs\dev"

@(
  ".\docs\decisions\ADR-0001-architecture.md",
  ".\docs\decisions\ADR-0002-data-zones-public-vs-private.md",
  ".\docs\decisions\ADR-0003-ai-grounding-and-citations.md",
  ".\docs\decisions\ADR-0004-auth-and-roles.md",
  ".\docs\decisions\ADR-0005-netlify-deploy.md",
  ".\docs\product\vision.md",
  ".\docs\product\information_architecture.md",
  ".\docs\product\content_style_guide.md",
  ".\docs\product\accessibility.md",
  ".\docs\product\trust_and_transparency.md",
  ".\docs\data\sources_catalog.md",
  ".\docs\data\county_content_contract.md",
  ".\docs\data\ai_output_contract.md",
  ".\docs\data\voter_file_handling.md",
  ".\docs\data\election_results_ingestion.md",
  ".\docs\data\geo_crosswalk_strategy.md",
  ".\docs\dev\local_setup.md",
  ".\docs\dev\env_vars.md",
  ".\docs\dev\scripts.md",
  ".\docs\dev\testing.md",
  ".\docs\dev\ci_cd.md"
) | ForEach-Object { Touch $_ }

# Data
Mkdir ".\data\raw\blueprint_docs\counties"
Mkdir ".\data\raw\voter_files_private"
Mkdir ".\data\raw\public_election_results"
Mkdir ".\data\raw\geo\precincts"
Mkdir ".\data\raw\geo\districts"
Mkdir ".\data\raw\geo\zips"
Mkdir ".\data\raw\geo\crosswalks"

Touch ".\data\raw\blueprint_docs\README.md"
Touch ".\data\raw\voter_files_private\README.md"
Touch ".\data\raw\public_election_results\README.md"
Touch ".\data\raw\geo\precincts\README.md"
Touch ".\data\raw\geo\districts\README.md"
Touch ".\data\raw\geo\zips\README.md"
Touch ".\data\raw\geo\crosswalks\README.md"

$countySlugs = @("conway","faulkner","perry","pulaski","saline","van-buren","white","cleburne")
foreach ($c in $countySlugs) {
  Mkdir ".\data\raw\blueprint_docs\counties\$c"
  Touch ".\data\raw\blueprint_docs\counties\$c\README.md"
}

Mkdir ".\data\processed\seed"
Mkdir ".\data\processed\ingestion_logs"
Mkdir ".\data\processed\caches\census"
Mkdir ".\data\processed\caches\bls"
Mkdir ".\data\processed\caches\civics"
Touch ".\data\processed\README.md"
Touch ".\data\processed\seed\blueprint_seed.json"
Touch ".\data\processed\seed\glossary_seed.json"
Touch ".\data\processed\ingestion_logs\README.md"
Touch ".\data\processed\caches\census\README.md"
Touch ".\data\processed\caches\bls\README.md"
Touch ".\data\processed\caches\civics\README.md"

# Apps skeleton (public_site)
Mkdir ".\apps\public_site"
Touch ".\apps\public_site\README.md"
@(
  ".\apps\public_site\package.json",
  ".\apps\public_site\next.config.js",
  ".\apps\public_site\tsconfig.json",
  ".\apps\public_site\netlify.toml",
  ".\apps\public_site\postcss.config.js",
  ".\apps\public_site\tailwind.config.ts",
  ".\apps\public_site\.eslintrc.json"
) | ForEach-Object { Touch $_ }

# Next app routes (public + admin)
$paths = @(
  ".\apps\public_site\app\layout.tsx",
  ".\apps\public_site\app\page.tsx",

  ".\apps\public_site\app\(public)\blueprint\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\issues\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\issues\[issue]\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\issues\[issue]\deep-dive\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\issues\[issue]\deep-dive\[topic]\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\data\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\data\[zip]\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\actions\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\actions\[issue]\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\teams\page.tsx",
  ".\apps\public_site\app\(public)\blueprint\[county]\teams\[team]\page.tsx",

  ".\apps\public_site\app\(public)\insights\page.tsx",
  ".\apps\public_site\app\(public)\insights\[scope]\page.tsx",
  ".\apps\public_site\app\(public)\insights\[scope]\[id]\page.tsx",

  ".\apps\public_site\app\(public)\glossary\page.tsx",
  ".\apps\public_site\app\(public)\glossary\[term]\page.tsx",

  ".\apps\public_site\app\(public)\about\page.tsx",
  ".\apps\public_site\app\(public)\methodology\page.tsx",
  ".\apps\public_site\app\(public)\sources\page.tsx",
  ".\apps\public_site\app\(public)\privacy\page.tsx",
  ".\apps\public_site\app\(public)\terms\page.tsx",

  ".\apps\public_site\app\(admin)\admin\layout.tsx",
  ".\apps\public_site\app\(admin)\admin\page.tsx",
  ".\apps\public_site\app\(admin)\admin\auth\page.tsx",

  ".\apps\public_site\app\(admin)\admin\content\page.tsx",
  ".\apps\public_site\app\(admin)\admin\content\counties\page.tsx",
  ".\apps\public_site\app\(admin)\admin\content\counties\[county]\page.tsx",
  ".\apps\public_site\app\(admin)\admin\content\glossary\page.tsx",
  ".\apps\public_site\app\(admin)\admin\content\uploads\page.tsx",

  ".\apps\public_site\app\(admin)\admin\ai\page.tsx",
  ".\apps\public_site\app\(admin)\admin\ai\prompts\page.tsx",
  ".\apps\public_site\app\(admin)\admin\ai\prompts\[promptId]\page.tsx",
  ".\apps\public_site\app\(admin)\admin\ai\runs\page.tsx",
  ".\apps\public_site\app\(admin)\admin\ai\runs\[runId]\page.tsx",

  ".\apps\public_site\app\(admin)\admin\data\page.tsx",
  ".\apps\public_site\app\(admin)\admin\data\census\page.tsx",
  ".\apps\public_site\app\(admin)\admin\data\bls\page.tsx",
  ".\apps\public_site\app\(admin)\admin\data\civics\page.tsx",
  ".\apps\public_site\app\(admin)\admin\data\elections\page.tsx",
  ".\apps\public_site\app\(admin)\admin\data\geo\page.tsx",

  ".\apps\public_site\app\(admin)\admin\voters-private\page.tsx",
  ".\apps\public_site\app\(admin)\admin\voters-private\imports\page.tsx",
  ".\apps\public_site\app\(admin)\admin\voters-private\lookups\page.tsx",
  ".\apps\public_site\app\(admin)\admin\voters-private\segments\page.tsx",
  ".\apps\public_site\app\(admin)\admin\voters-private\audit\page.tsx"
)

$paths | ForEach-Object { Touch $_ }

# Components
$componentPaths = @(
  ".\apps\public_site\components\ui\README.md",
  ".\apps\public_site\components\layout\SiteHeader.tsx",
  ".\apps\public_site\components\layout\SiteFooter.tsx",
  ".\apps\public_site\components\layout\Breadcrumbs.tsx",
  ".\apps\public_site\components\layout\PageShell.tsx",
  ".\apps\public_site\components\layout\SectionHeader.tsx",

  ".\apps\public_site\components\content\CountySnapshotCard.tsx",
  ".\apps\public_site\components\content\IssueCard.tsx",
  ".\apps\public_site\components\content\QuoteBlock.tsx",
  ".\apps\public_site\components\content\ExpandableSection.tsx",
  ".\apps\public_site\components\content\HoverDefinition.tsx",
  ".\apps\public_site\components\content\TrustMarkers.tsx",
  ".\apps\public_site\components\content\SourceCitations.tsx",
  ".\apps\public_site\components\content\PhotoGallery.tsx",

  ".\apps\public_site\components\charts\ChartContainer.tsx",
  ".\apps\public_site\components\charts\CountyIssueStackedBar.tsx",
  ".\apps\public_site\components\charts\IssueFrequencyBar.tsx",
  ".\apps\public_site\components\charts\ZipMetricTrendLine.tsx",
  ".\apps\public_site\components\charts\TurnoutTrendLine.tsx",
  ".\apps\public_site\components\charts\ResultsMarginBar.tsx",

  ".\apps\public_site\components\controls\FilterBar.tsx",
  ".\apps\public_site\components\controls\SearchBox.tsx",
  ".\apps\public_site\components\controls\TogglePlainLanguage.tsx",
  ".\apps\public_site\components\controls\ShareLinkButton.tsx"
)
$componentPaths | ForEach-Object { Touch $_ }

# Lib
@(
  ".\apps\public_site\lib\db\client.ts",
  ".\apps\public_site\lib\db\publicQueries.ts",
  ".\apps\public_site\lib\db\privateQueries.ts",
  ".\apps\public_site\lib\ai\promptRegistry.ts",
  ".\apps\public_site\lib\ai\runAI.ts",
  ".\apps\public_site\lib\ai\guardrails.ts",
  ".\apps\public_site\lib\ai\citations.ts",
  ".\apps\public_site\lib\data\contentParser.ts",
  ".\apps\public_site\lib\data\markdown.ts",
  ".\apps\public_site\lib\data\validators.ts",
  ".\apps\public_site\lib\data\constants.ts",
  ".\apps\public_site\lib\auth\roles.ts",
  ".\apps\public_site\lib\auth\requireAuth.ts",
  ".\apps\public_site\lib\auth\sessions.ts",
  ".\apps\public_site\lib\geo\crosswalk.ts",
  ".\apps\public_site\lib\geo\normalize.ts",
  ".\apps\public_site\styles\globals.css",
  ".\apps\public_site\styles\theme.css",
  ".\apps\public_site\public\brand\README.md",
  ".\apps\public_site\public\images\README.md",
  ".\apps\public_site\tests\README.md",
  ".\apps\public_site\tests\unit\placeholder.test.ts",
  ".\apps\public_site\tests\e2e\placeholder.spec.ts"
) | ForEach-Object { Touch $_ }

# Netlify functions
Mkdir ".\netlify\functions\public"
Mkdir ".\netlify\functions\admin"
Mkdir ".\netlify\functions\data"
Mkdir ".\netlify\functions\ai"
Mkdir ".\netlify\functions\voters_private"
Touch ".\netlify\functions\README.md"

@(
  ".\netlify\functions\public\get_counties.ts",
  ".\netlify\functions\public\get_county_page.ts",
  ".\netlify\functions\public\get_glossary.ts",
  ".\netlify\functions\public\get_issue_page.ts",
  ".\netlify\functions\public\get_zip_snapshot.ts",
  ".\netlify\functions\public\get_sources.ts",

  ".\netlify\functions\admin\admin_auth.ts",
  ".\netlify\functions\admin\admin_upload.ts",
  ".\netlify\functions\admin\admin_seed.ts",
  ".\netlify\functions\admin\admin_revalidate.ts",

  ".\netlify\functions\data\fetch_census.ts",
  ".\netlify\functions\data\fetch_bls.ts",
  ".\netlify\functions\data\fetch_civics.ts",
  ".\netlify\functions\data\fetch_election_results.ts",
  ".\netlify\functions\data\fetch_geo.ts",

  ".\netlify\functions\ai\ai_generate_county_brief.ts",
  ".\netlify\functions\ai\ai_generate_issue_brief.ts",
  ".\netlify\functions\ai\ai_generate_zip_snapshot.ts",
  ".\netlify\functions\ai\ai_generate_talking_points.ts",
  ".\netlify\functions\ai\ai_generate_action_options.ts",
  ".\netlify\functions\ai\ai_generate_glossary_terms.ts",

  ".\netlify\functions\voters_private\import_vr.ts",
  ".\netlify\functions\voters_private\import_vh.ts",
  ".\netlify\functions\voters_private\lookup_voter.ts",
  ".\netlify\functions\voters_private\segment_builder.ts",
  ".\netlify\functions\voters_private\audit_log.ts"
) | ForEach-Object { Touch $_ }

# DB
Mkdir ".\db\prisma\migrations"
Mkdir ".\db\sql"
Mkdir ".\db\diagrams"
Touch ".\db\README.md"
Touch ".\db\prisma\schema.prisma"
Touch ".\db\prisma\migrations\README.md"
Touch ".\db\prisma\seed.ts"
Touch ".\db\sql\001_public_schema.sql"
Touch ".\db\sql\002_private_voters_schema.sql"
Touch ".\db\sql\003_indexes.sql"
Touch ".\db\sql\004_views.sql"
Touch ".\db\sql\005_rls_policies.sql"
Touch ".\db\diagrams\ERD.md"

# Scripts
Mkdir ".\scripts\scaffold"
Mkdir ".\scripts\ingest"
Mkdir ".\scripts\data"
Mkdir ".\scripts\ai"
Mkdir ".\scripts\voters_private"
Touch ".\scripts\README.md"
Touch ".\scripts\scaffold\make_skeleton.sh"

@(
  ".\scripts\ingest\parse_blueprint_docx.ts",
  ".\scripts\ingest\extract_photos.ts",
  ".\scripts\ingest\normalize_county_slugs.ts",
  ".\scripts\ingest\build_seed_json.ts",

  ".\scripts\data\census_cache_warm.ts",
  ".\scripts\data\bls_cache_warm.ts",
  ".\scripts\data\civics_cache_warm.ts",
  ".\scripts\data\election_results_ingest.ts",
  ".\scripts\data\geo_ingest.ts",

  ".\scripts\ai\generate_all_county_briefs.ts",
  ".\scripts\ai\generate_all_issue_briefs.ts",
  ".\scripts\ai\generate_all_zip_snapshots.ts",
  ".\scripts\ai\regenerate_prompt.ts",

  ".\scripts\voters_private\import_all_vr.ts",
  ".\scripts\voters_private\import_all_vh.ts",
  ".\scripts\voters_private\reconcile_vrvh.ts"
) | ForEach-Object { Touch $_ }

# GitHub actions + ops
Mkdir ".\.github\workflows"
Touch ".\.github\workflows\ci.yml"

Mkdir ".\ops\netlify"
Mkdir ".\ops\runbooks"
Touch ".\ops\README.md"
Touch ".\ops\netlify\env_template.md"
Touch ".\ops\netlify\redirects.txt"
Touch ".\ops\netlify\headers.txt"
@(
  ".\ops\runbooks\incident_response.md",
  ".\ops\runbooks\data_privacy.md",
  ".\ops\runbooks\key_rotation.md",
  ".\ops\runbooks\backups.md"
) | ForEach-Object { Touch $_ }

Write-Host "DONE. Skeleton created." -ForegroundColor Green
Write-Host "Next: paste master_build.md content into .\master_build.md" -ForegroundColor Yellow
