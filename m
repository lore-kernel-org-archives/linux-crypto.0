From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH v2 3/3] crypto: brcm: Add Broadcom SPU driver DT entry.
Date: Fri,  2 Dec 2016 16:34:59 -0500
Message-ID: <1480714499-1476-4-git-send-email-rob.rice@broadcom.com>
References: <1480714499-1476-1-git-send-email-rob.rice@broadcom.com>
Cc: Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480714499-1476-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Northstar2 device tree entry for Broadcom Secure Processing
Unit (SPU) crypto driver.

Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
Signed-off-by: Rob Rice <rob.rice@broadcom.com>
---
 arch/arm64/boot/dts/broadcom/ns2.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/ns2.dtsi b/arch/arm64/boot/dts/broadcom/ns2.dtsi
index d95dc40..8b81b0d 100644
--- a/arch/arm64/boot/dts/broadcom/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/ns2.dtsi
@@ -191,6 +191,18 @@
 
 		#include "ns2-clock.dtsi"
 
+		spu-crypto@612d0000 {
+			compatible = "brcm,spum-crypto";
+			reg = <0x612d0000 0x900>,    /* SPU 0 control regs */
+				<0x612f0000 0x900>,  /* SPU 1 control regs */
+				<0x61310000 0x900>,  /* SPU 2 control regs */
+				<0x61330000 0x900>;  /* SPU 3 control regs */
+			mboxes = <&pdc0 0>,
+				<&pdc1 0>,
+				<&pdc2 0>,
+				<&pdc3 0>;
+		};
+
 		dma0: dma@61360000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x61360000 0x1000>;
-- 
2.1.0
