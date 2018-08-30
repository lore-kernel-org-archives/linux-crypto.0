From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/6] dt-bindings: crypto: Add Freescale Vybrid CRC
Date: Thu, 30 Aug 2018 19:15:34 +0200
Message-ID: <20180830171539.20008-2-krzk@kernel.org>
References: <20180830171539.20008-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830171539.20008-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add bindings for Freescale/NXP Vybrid CRC HW accelerator.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../devicetree/bindings/crypto/fsl-vf610-crc.txt         | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt

diff --git a/Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt b/Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt
new file mode 100644
index 000000000000..cdd7e26baeac
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-vf610-crc.txt
@@ -0,0 +1,16 @@
+Freescale/NXP Vybrid VF500/VF610 CRC HW accelerator
+
+Required properties:
+- compatible : Should be "fsl,vf610-crc"
+- reg : Should contain register location and length.
+- clocks : Should contain the clock driving the CRC block.
+- clock-names : Should be set to "crc".
+
+Example:
+
+crc@40033000 {
+	compatible = "fsl,vf610-crc";
+	reg = <0x40033000 0x10>;
+	clocks = <&clks VF610_CLK_CRC>;
+	clock-names = "crc";
+};
-- 
2.14.1
