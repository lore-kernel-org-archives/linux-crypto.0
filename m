From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True
 RNG bindings
Date: Mon, 27 Nov 2017 10:58:02 +0100
Message-ID: <20171127095804.7128-2-l.stelmach@samsung.com>
References: <20171127095804.7128-1-l.stelmach@samsung.com>
        <CGME20171127095809eucas1p2988d8c9f37b995b08fb5ae694cf020a2@eucas1p2.samsung.com>
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
In-reply-to: <20171127095804.7128-1-l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add binding documentation for the True Random Number Generator
found on Samsung Exynos 5250+ SoCs.

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Łukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
new file mode 100644
index 000000000000..22dfe8cb21c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
@@ -0,0 +1,17 @@
+Exynos True Random Number Generator
+
+Required properties:
+
+- compatible  : Should be "samsung,exynos5250-trng".
+- reg         : Specifies base physical address and size of the registers map.
+- clocks      : Phandle to clock-controller plus clock-specifier pair.
+- clock-names : "secss" as a clock name.
+
+Example:
+
+	trng@10830600 {
+		compatible = "samsung,exynos5250-trng";
+		reg = <0x10830600 0x100>;
+		clocks = <&clock CLK_SSS>;
+		clock-names = "secss";
+	};
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
