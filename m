From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v9 2/4] ARM: sun4i: dt: Add DT bindings documentation for SUN4I Security System
Date: Thu, 14 May 2015 14:58:59 +0200
Message-ID: <1431608341-10936-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	mchehab@osg.samsung.com, joe@perches.com, tj@kernel.org,
	arnd@arndb.de, boris.brezillon@free-electrons.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds documentation for Device-Tree bindings for the Security System
cryptographic accelerator driver.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 Documentation/devicetree/bindings/crypto/sun4i-ss.txt | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/sun4i-ss.txt

diff --git a/Documentation/devicetree/bindings/crypto/sun4i-ss.txt b/Documentation/devicetree/bindings/crypto/sun4i-ss.txt
new file mode 100644
index 0000000..f2192d4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/sun4i-ss.txt
@@ -0,0 +1,19 @@
+* Allwinner Security System found on A20 SoC
+
+Required properties:
+- compatible : Should be "allwinner,sun4i-a20-crypto".
+- reg: Should contain the Security System register location and length.
+- interrupts: Should contain the IRQ line for the Security System.
+- clocks : List of clock specifiers, corresponding to ahb and ss.
+- clock-names : Name of the functional clock, should be
+	* "ahb" : AHB gating clock
+	* "mod" : SS controller clock
+
+Example:
+	crypto: crypto-engine@01c15000 {
+		compatible = "allwinner,sun4i-a20-crypto";
+		reg = <0x01c15000 0x1000>;
+		interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&ahb_gates 5>, <&ss_clk>;
+		clock-names = "ahb", "mod";
+	};
-- 
2.3.6
