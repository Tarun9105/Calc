# SmartCalc Design

## Visual Direction
SmartCalc should feel close to the native iOS calculator: dense black background, bright display, circular keys, and strong operator contrast.

## Theme Tokens
- Background: `#000000`
- Digit key: `#333333`
- Scientific key: `#1C1C1C`
- Function key: `#A5A5A5`
- Operator key: `#FF9500`
- Primary text on dark: `#FFFFFF`
- Text on function keys: `#000000`

## Typography
- Large right-aligned display number
- Smaller muted expression line above result
- Auto-shrinking display text for long values
- Clear, legible system-safe font until product font selection is finalized

## Layout
- Single-screen layout
- Portrait uses the standard calculator grid
- Landscape reveals scientific controls on the left
- `0` key spans two columns
- Maintain minimum 48x48dp hit targets

## Motion
- Brief press animation on keys
- Ripple or brightness feedback on touch
- Smooth orientation transition without changing arithmetic layout position

## Accessibility
- TalkBack-friendly semantic labels
- 200% text scaling support
- Error states use text and visual styling, not color alone

