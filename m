From: <sean.wang@mediatek.com>
Subject: [PATCH 1/2] dt-bindings: hwrng: Add Mediatek hardware random generator bindings
Date: Thu, 13 Apr 2017 15:05:07 +0800
Message-ID: <1492067108-14748-2-git-send-email-sean.wang@mediatek.com>
References: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1@huawei.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <clabbe.montjoie@gmail.com>, <prasannatsmkumar@gmail.com>,
        <romain.perier@free-electrons.com>, <shannon.nelson@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Document the devicetree bindings for Mediatek random number
generator which could be found on MT7623 SoC or other similar
Mediatek SoCs.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 Documentation/devicetree/bindings/rng/mtk-rng.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
new file mode 100644
index 0000000..a6d62a2
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
@@ -0,0 +1,18 @@
+Device-Tree bindings for Mediatek random number generator
+found in Mediatek SoC family
+
+Required properties:
+- compatible	    : Should be "mediatek,mt7623-rng"
+- clocks	    : list of clock specifiers, corresponding to
+		      entries in clock-names property;
+- clock-names	    : Should contain "rng" entries;
+- reg 		    : Specifies base physical address and size of the registers
+
+Example:
+
+rng: rng@1020f000 {
+	compatible = "mediatek,mt7623-rng";
+	reg = <0 0x1020f000 0 0x1000>;
+	clocks = <&infracfg CLK_INFRA_TRNG>;
+	clock-names = "rng";
+};
-- 
1.9.1
