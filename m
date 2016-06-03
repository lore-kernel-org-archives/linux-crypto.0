From: Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 2/3] dt-bindings: hwrng: Add Amlogic Meson Hardware Random Generator bindings
Date: Fri,  3 Jun 2016 10:47:00 +0200
Message-ID: <1464943621-18278-3-git-send-email-narmstrong@baylibre.com>
References: <1464943621-18278-1-git-send-email-narmstrong@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464943621-18278-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../devicetree/bindings/rng/amlogic,meson-rng.txt          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
new file mode 100644
index 0000000..202f2d0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
@@ -0,0 +1,14 @@
+Amlogic Meson Random number generator
+=====================================
+
+Required properties:
+
+- compatible : should be "amlogic,meson-rng"
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+rng {
+        compatible = "amlogic,meson-rng";
+        reg = <0x0 0xc8834000 0x0 0x4>;
+};
-- 
2.7.0
