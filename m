From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v1 2/2] dt-bindings: crypto: remove mediatek ethif clock
Date: Thu, 1 Jun 2017 10:30:22 +0800
Message-ID: <1496284222-12560-3-git-send-email-ryder.lee@mediatek.com>
References: <1496284222-12560-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496284222-12560-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch removes the parent clock 'ethif' in bindings, since we don't
need to control the parent of a clock in current clock framework.

Moreover, the clocks are get by name in the driver, thus this change
does not break backwards compatibility.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
index c204725..450da36 100644
--- a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
@@ -6,8 +6,7 @@ Required properties:
 - interrupts: Should contain the five crypto engines interrupts in numeric
 	order. These are global system and four descriptor rings.
 - clocks: the clock used by the core
-- clock-names: the names of the clock listed in the clocks property. These are
-	"ethif", "cryp"
+- clock-names: Must contain "cryp".
 - power-domains: Must contain a reference to the PM domain.
 
 
@@ -20,8 +19,7 @@ Example:
 			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
-		clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
-			 <&ethsys CLK_ETHSYS_CRYPTO>;
-		clock-names = "ethif","cryp";
+		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
+		clock-names = "cryp";
 		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
 	};
-- 
1.9.1
