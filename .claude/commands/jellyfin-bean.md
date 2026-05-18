# Jellyfin Bean Command

Organize matched media into Jellyfin-compliant structure and download subtitles.

**Arguments:** `$ARGUMENTS` — a comma-separated or tuple-style list of movie/show names, e.g. `'Movie 1', 'Serie 2'` or `('Movie 1', 'Movie2', 'serie 1')`.

## Instructions

### Step 1 — Parse the input list

Extract individual names from `$ARGUMENTS`. Strip surrounding quotes, parentheses, and whitespace. Each item is a search query.

### Step 2 — Fuzzy match against local libraries

Use this Python snippet to find matches (run it via Bash):

```python
import difflib, os, re, json

def strip_year(name):
    return re.sub(r'\s*\(\d{4}\)\s*$', '', name).strip()

def best_match(query, entries, threshold=0.85):
    q = query.lower()
    best, score = None, 0.0
    for e in entries:
        r = difflib.SequenceMatcher(None, q, strip_year(e).lower()).ratio()
        if r > score:
            best, score = e, r
    return (best, score) if score >= threshold else (None, score)

movies_dir = os.path.expanduser('~/Videos/movies')
tvshows_dir = os.path.expanduser('~/Videos/tvshows')

movies  = [e for e in os.listdir(movies_dir)  if os.path.isdir(os.path.join(movies_dir, e))]
tvshows = [e for e in os.listdir(tvshows_dir) if os.path.isdir(os.path.join(tvshows_dir, e))]

queries = [q.strip().strip("'\"") for q in re.split(r',\s*', re.sub(r'[()]\s*$|^\s*[()]', '', """$ARGUMENTS"""))]

results = []
for q in queries:
    if not q:
        continue
    m, ms = best_match(q, movies)
    t, ts = best_match(q, tvshows)
    if m and ms >= ts:
        results.append({'query': q, 'match': m, 'type': 'movie',  'path': os.path.join(movies_dir, m),  'score': ms})
    elif t:
        results.append({'query': q, 'match': t, 'type': 'tvshow', 'path': os.path.join(tvshows_dir, t), 'score': ts})
    else:
        results.append({'query': q, 'match': None, 'type': None, 'path': None, 'score': max(ms, ts)})

print(json.dumps(results, indent=2))
```

For each result with `match: null`, inform the user that no match was found (score below 85%) and skip.

### Step 3 — Apply Jellyfin naming standards

#### Movies (`type: movie`)

Follow https://jellyfin.org/docs/general/server/media/movies/

Required structure:
```
Movie Name (Year)/
└── Movie Name (Year).ext
```

Rules:
- Folder name: `Title (Year)` — use spaces, not dots; no forbidden chars (`< > : " / \ | ? *`)
- Video file inside must match the folder name exactly (same extension)
- Subtitle files: `Movie Name (Year).en.srt`, `Movie Name (Year).pt-BR.srt`
- If the folder already matches the standard, skip renaming

Steps:
1. List all files inside `~/Videos/movies/<match>/`
2. Identify the video file (`.mkv`, `.mp4`, `.avi`, `.mov`, `.wmv`)
3. If the video filename ≠ `<FolderName>.<ext>`, rename it with `mv`
4. Apply the same clean name to any existing subtitle files

#### TV Shows (`type: tvshow`)

Follow https://jellyfin.org/docs/general/server/media/shows/

Required structure:
```
Show Name (Year)/
└── Season XX/
    ├── Show Name (Year) - S01E01.ext
    ├── Show Name (Year) - S01E02.ext
    └── Show Name (Year) - S01E03.ext
```

Rules:
- Root folder: `Show Name (Year)`
- Season folders: `Season XX` (zero-padded two-digit number)
- Episode files: `Show Name (Year) - SXXEYY.ext`
  - Derive `SXX` from the season folder name
  - Derive `EYY` from the current episode filename (look for patterns like `S01E05`, `1x05`, `ep05`, or positional numbering)
- Subtitle files alongside episodes: `Show Name (Year) - SXXEYY.en.srt`, `Show Name (Year) - SXXEYY.pt-BR.srt`

Steps:
1. For each `Season XX` subfolder inside `~/Videos/tvshows/<match>/`:
   - Extract the season number from the folder name
   - List all video files inside
   - For each video file, parse its current episode code (`SXXEYYformat`)
   - Rename to `Show Name (Year) - SXXEYY.ext` if not already in that format
   - Rename matching subtitle files the same way

### Step 4 — Download subtitles with subliminal

After renaming, download English and Brazilian Portuguese subtitles for the matched media:

**For a movie:**
```bash
subliminal download -l en -l pt-BR "$HOME/Videos/movies/<Match Name (Year)>/"
```

**For a TV show (download recursively for all seasons):**
```bash
subliminal download -l en -l pt-BR "$HOME/Videos/tvshows/<Match Name (Year)>/"
```

subliminal will skip files that already have subtitles in those languages.

### Step 5 — Report

Print a summary table:

| Query | Matched | Type | Score | Actions taken |
|-------|---------|------|-------|---------------|
| ...   | ...     | ...  | ...%  | renamed / subtitles downloaded / skipped |

## Safety Guidelines

- **NEVER** delete files — only rename and move
- **ALWAYS** confirm with the user before renaming if unsure about the correct episode code
- **PRESERVE** all file extensions
- **SKIP** items that already comply with Jellyfin standards (no unnecessary renames)
- If a match score is between 70–85%, show it to the user and ask for confirmation before acting
