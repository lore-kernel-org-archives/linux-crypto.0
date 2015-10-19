From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] dt-bindings: rng: Describe Exynos4 PRNG bindings
Date: Mon, 19 Oct 2015 13:37:39 +0900
Message-ID: <1445229462-32395-2-git-send-email-k.kozlowski@samsung.com>
References: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Document the bindings used by exynos-rng Pseudo Random Number Generator
driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 .../devicetree/bindings/rng/samsung,exynos-rng4.txt     | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt b/Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
new file mode 100644
index 000000000000..4ca8dd4d7e66
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
@@ -0,0 +1,17 @@
+Exynos Pseudo Random Number Generator
+
+Required properties:
+
+- compatible  : Should be "samsung,exynos4-rng".
+- reg         : Specifies base physical address and size of the registers map.
+- clocks      : Phandle to clock-controller plus clock-specifier pair.
+- clock-names : "secss" as a clock name.
+
+Example:
+
+	rng@10830400 {
+		compatible = "samsung,exynos4-rng";
+		reg = <0x10830400 0x200>;
+		clocks = <&clock CLK_SSS>;
+		clock-names = "secss";
+	};
-- 
1.9.1
