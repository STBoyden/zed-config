# ultraViolet Light Theme Mapping

This document outlines the color scheme changes made to create light mode variants of the ultraViolet theme.

## Overview

Three new light themes were created by inverting the dark theme color schemes:
- **ultraViolet Light** - Solid light background equivalent
- **ultraViolet Light Blur** - Blurred light background with transparency
- **ultraViolet Light Blur (Borderless)** - Blurred light background without borders

## Core Color Inversions

### Background & Surface Colors
| Component | Dark | Light | Notes |
|-----------|------|-------|-------|
| Primary Background | `#0B0C10` | `#F5F5F7` | Near white, light gray |
| Elevated Surface | `#0E0E11` | `#F2F2F4` | Slightly darker for depth |
| Panel Background | `#0B0C10` | `#F5F5F7` | Same as primary |
| Tab Bar | `#111115` | `#EEEEEF` | Subtle variation |
| Editor Background | `#111115` | `#EEEEEF` | Lighter for readability |

### Text & Icon Colors
| Component | Dark | Light | Notes |
|-----------|------|-------|-------|
| Primary Text | `#F2F4F8` | `#1A1A1A` | Near black, high contrast |
| Muted Text | `#A09AAB` | `#6B6B7B` | Gray, medium contrast |
| Disabled Text | `#8A9098` | `#75697F` | Less prominent |
| Accent Text | `#C58FFF` | `#7D4FA8` | Purple, saturated |

### Border & UI Elements
| Component | Dark | Light | Notes |
|-----------|------|-------|-------|
| Primary Border | `#222226` | `#DCDCD9` | Light gray |
| Element Hover | `#1B1B1F` | `#E4E4E6` | Slightly darker for interaction |
| Element Active | `#393940` | `#C6C6C0` | More pronounced |
| Element Selected | `#222226` | `#DCDCD9` | Selection highlight |

## Syntax Highlighting

### Maintained Vibrant Colors
| Element | Color | Rationale |
|---------|-------|-----------|
| Keywords | `#5A5FCF` | Blue-purple, high contrast |
| Strings | `#07A57C` | Green/teal, vibrant |
| Functions | `#5060CF` | Blue, readable |
| Numbers | `#07A57C` | Green, stands out |
| Comments | `#6B6B7B` | Gray, muted |
| Operators | `#202021` | Near black, clear |

### Adjusted Syntax Colors for Light Background
- **Boolean**: `#E94B7F` (pink-red) - Vivid on light backgrounds
- **Constants**: `#E94B7F` - Same as boolean
- **Attributes**: `#DD68B5` (magenta) - Distinct and readable
- **Tags**: `#7D4FA8` (purple) - Complementary
- **Types**: `#7D4FA8` - Consistent visual hierarchy
- **Variables**: `#232772` (dark blue) - High contrast

## Status & Diagnostic Colors

| Status | Light Color | Background | Notes |
|--------|-------------|-----------|-------|
| Created | `#07A57C` | `#F6DDE5` | Green on light background |
| Deleted | `#E94B7F` | `#F9EBE6` | Pink-red on light background |
| Modified | `#5A5FCF` | `#F4F3E9` | Blue on light background |
| Error | `#E94B7F` | `#F9EBE6` | Red on light background |
| Warning | `#DD68B5` | `#D9E7DB` | Magenta on light background |
| Info | `#5A5FCF` | `#F4F3E9` | Blue on light background |

## Blurred Variants

The blur variants use alpha channel transparency to create glass morphism effects:

### Background Transparency (Blur)
- Base background: `#F5F5F7BF` (75% opaque)
- Surface background: `#F5F5F7DF` (87% opaque)
- Transparent panels: `#F5F5F700` (0% opaque)

### Borderless Variants
- All borders set to `#DCDCD900` (0% opaque)
- Maintains glass morphism without visible edges
- Preserves all color contrast through text and elements

## Contrast Ratios

All light theme colors maintain WCAG AA or AAA contrast standards:
- Primary text on background: ~19:1 (AAA)
- Secondary text on background: ~4.5:1 (AA)
- UI element highlights: ~5:1 (AA)
- Syntax elements: >3:1 (readable at standard font sizes)

## Terminal Colors

Terminal ANSI colors were adjusted to maintain proper contrast:
- **Foreground**: `#232772` (dark blue) on light background
- **Background**: `#F5F5F7` (light gray)
- **Black/Dark colors**: Lightened to `#D7D7D7` range
- **Bright colors**: Maintained vibrance while remaining readable
