From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/3] True RNG driver for Samsung Exynos 5250+ SoCs
Date: Mon, 27 Nov 2017 10:58:01 +0100
Message-ID: <20171127095804.7128-1-l.stelmach@samsung.com>
References: <CGME20171127095808eucas1p22ded3526ec44c8b9edf3e4480a811820@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello.

The following patches add support for the true random number generator
found in Samsung Exynos 5250+ SoCs.

Patch #1 adds documentation for devicetree bindings.

Patch #2 introduces the driver and appropriate changes in Makefile and Kconfig.

Patch #3 adds nodes in devicetree files for Exynos SoCs.

Changes in v2:
- Fixed indentation in drivers/char/hw_random/Kconfig.
- Defined TRNG_CTRL_RGNEN.
- Removed global variable exynos_trng_dev.
- Removed exynos_trng_{set,get}_reg() functions.
- Used the min_t() macro instead of the ternary operator in
  exynos_trng_do_read().
- Moved trng initialisation to the variable declaration in
  exynos_trng_init().
- Fixed comment formating.
- Removed unnecessary "TODO" comments.
- Return ENOMEM, if devm_kzalloc() devm_kstrdup() fail.
- Rephrased and unified error messages in exynos_trng_probe().
- Removed nullification of trng->mem.
- Added err_pm_get label at the end of exynos_trng_probe().
- Removed double error message at the end of exynos_trng_probe().
- Implemented exynos_trng_remove().

Thank you, Krzysztof Kozlowski, Andrew F. Davis, PrasannaKumar
Muralidharan, Rob Herring.

v1 can be found:

https://www.spinics.net/lists/linux-samsung-soc/msg61253.html
https://patchwork.kernel.org/patch/10072967/
https://patchwork.kernel.org/patch/10072971/
https://patchwork.kernel.org/patch/10072963/

Łukasz Stelmach (3):
  dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG bindings
  hwrng: exynos - add Samsung Exynos True RNG driver
  ARM: dts: exynos: Add nodes for True Random Number Generator

 .../bindings/rng/samsung,exynos5250-trng.txt       |  17 ++
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/exynos5.dtsi                     |   5 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   5 +
 arch/arm/boot/dts/exynos5410.dtsi                  |   5 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   5 +
 drivers/char/hw_random/Kconfig                     |  12 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/exynos-trng.c               | 245 +++++++++++++++++++++
 9 files changed, 302 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
 create mode 100644 drivers/char/hw_random/exynos-trng.c

-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
