From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 13/14] arm64: dts: marvell: armada-cp110: update the crypto engine compatible
Date: Thu, 28 Jun 2018 17:15:43 +0200
Message-ID: <20180628151544.22134-14-antoine.tenart@bootlin.com>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        gregory.clement@bootlin.com, andrew@lunn.ch, jason@lakedaemon.net,
        sebastian.hesselbarth@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

New compatibles are now supported by the Inside Secure SafeXcel driver.
As they are more specific than the old ones, they should be used
whenever possible. This patch updates the Marvell cp110 device tree
accordingly.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
index 2bf083272a87..bb2914f90048 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
@@ -427,7 +427,7 @@
 		};
 
 		CP110_LABEL(crypto): crypto@800000 {
-			compatible = "inside-secure,safexcel-eip197";
+			compatible = "inside-secure,safexcel-eip197b";
 			reg = <0x800000 0x200000>;
 			interrupts = <ICU_GRP_NSR 87 IRQ_TYPE_LEVEL_HIGH>,
 				<ICU_GRP_NSR 88 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.17.1
