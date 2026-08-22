"""生成单条流动波浪 GIF — 参考 CyrisXD 等 Profile 的自托管动图方案"""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw

WIDTH = 640
HEIGHT = 48
FRAMES = 36
DURATION_MS = 60
OUTPUT = Path(__file__).resolve().parent.parent / "assets" / "wave.gif"


def wave_y(x: float, base: float, amp: float, freq: float, phase: float) -> float:
    return base + amp * math.sin(x * freq + phase)


def render_frame(phase: float) -> Image.Image:
    img = Image.new("RGBA", (WIDTH, HEIGHT), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    # 单条流动波浪
    points = [
        (x, wave_y(x, 24, 8, 0.028, phase))
        for x in range(0, WIDTH + 1, 4)
    ]
    draw.line(points, fill=(96, 165, 250, 230), width=3, joint="curve")

    return img


def main() -> None:
    frames = [render_frame(i * 0.28) for i in range(FRAMES)]
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    frames[0].save(
        OUTPUT,
        save_all=True,
        append_images=frames[1:],
        duration=DURATION_MS,
        loop=0,
        disposal=2,
        transparency=0,
        optimize=True,
    )
    print(f"Saved {OUTPUT}")


if __name__ == "__main__":
    main()
