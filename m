From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH v3 3/3] arm64: dts: ns2: Add Broadcom SPU driver DT entry.
Date: Wed, 25 Jan 2017 11:44:49 -0500
Message-ID: <1485362689-11294-4-git-send-email-rob.rice@broadcom.com>
References: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
Cc: Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Northstar2 device tree entry for Broadcom Secure Processing
Unit (SPU) crypto hardware.

Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
Signed-off-by: Rob Rice <rob.rice@broadcom.com>
---
 arch/arm64/boot/dts/broadcom/ns2.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/ns2.dtsi b/arch/arm64/boot/dts/broadcom/ns2.dtsi
index 4fcdeca..ec1a628 100644
--- a/arch/arm64/boot/dts/broadcom/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/ns2.dtsi
@@ -218,6 +218,12 @@
 			brcm,use-bcm-hdr;
 		};
 
+		crypto0: crypto@612d0000 {
+			compatible = "brcm,spum-crypto";
+			reg = <0x612d0000 0x900>;
+			mboxes = <&pdc0 0>;
+		};
+
 		pdc1: iproc-pdc1@612e0000 {
 			compatible = "brcm,iproc-pdc-mbox";
 			reg = <0x612e0000 0x445>;  /* PDC FS1 regs */
@@ -227,6 +233,12 @@
 			brcm,use-bcm-hdr;
 		};
 
+		crypto1: crypto@612f0000 {
+			compatible = "brcm,spum-crypto";
+			reg = <0x612f0000 0x900>;
+			mboxes = <&pdc1 0>;
+		};
+
 		pdc2: iproc-pdc2@61300000 {
 			compatible = "brcm,iproc-pdc-mbox";
 			reg = <0x61300000 0x445>;  /* PDC FS2 regs */
@@ -236,6 +248,12 @@
 			brcm,use-bcm-hdr;
 		};
 
+		crypto2: crypto@61310000 {
+			compatible = "brcm,spum-crypto";
+			reg = <0x61310000 0x900>;
+			mboxes = <&pdc2 0>;
+		};
+
 		pdc3: iproc-pdc3@61320000 {
 			compatible = "brcm,iproc-pdc-mbox";
 			reg = <0x61320000 0x445>;  /* PDC FS3 regs */
@@ -245,6 +263,12 @@
 			brcm,use-bcm-hdr;
 		};
 
+		crypto3: crypto@61330000 {
+			compatible = "brcm,spum-crypto";
+			reg = <0x61330000 0x900>;
+			mboxes = <&pdc3 0>;
+		};
+
 		dma0: dma@61360000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x61360000 0x1000>;
-- 
2.1.0
