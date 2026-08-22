"""生成流动波浪 GIF（不透明背景，兼容 GitHub 显示）"""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw

WIDTH = 640
HEIGHT = 72
FRAMES = 40
DURATION_MS = 55
BG = (255, 250, 245)
OUTPUT = Path(__file__).resolve().parent.parent / "assets" / "wave.gif"


def wave_y(x: float, base: float, amp: float, freq: float, phase: float) -> float:
    return base + amp * math.sin(x * freq + phase)


def render_frame(phase: float) -> Image.Image:
    img = Image.new("RGB", (WIDTH, HEIGHT), BG)
    draw = ImageDraw.Draw(img)

    pink = [
        (x, wave_y(x, 34, 10, 0.03, phase))
        for x in range(0, WIDTH + 1, 3)
    ]
    blue = [
        (x, wave_y(x, 42, 7, 0.026, phase + 1.2))
        for x in range(0, WIDTH + 1, 3)
    ]

    draw.line(pink, fill=(244, 114, 182), width=4, joint="curve")
    draw.line(blue, fill=(59, 130, 246), width=3, joint="curve")

    return img


def main() -> None:
    frames = [render_frame(i * 0.25) for i in range(FRAMES)]
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    frames[0].save(
        OUTPUT,
        save_all=True,
        append_images=frames[1:],
        duration=DURATION_MS,
        loop=0,
        optimize=True,
    )
    print(f"Saved {OUTPUT} ({len(frames)} frames)")


if __name__ == "__main__":
    main()
