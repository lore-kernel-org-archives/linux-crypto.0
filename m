From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 2/8] dt-bindings: omap-rng: Document SafeXcel IP-76 device variant
Date: Fri, 16 Sep 2016 12:08:50 +0200
Message-ID: <20160916100856.31727-3-romain.perier@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60838 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757456AbcIPKMI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 06:12:08 -0400
In-Reply-To: <20160916100856.31727-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commits add missing fields in the documentation that are used
by the new device variant. It also includes DT example to show how
the variant should be used.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 Documentation/devicetree/bindings/rng/omap_rng.txt | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
index 6a62acd..4714772 100644
--- a/Documentation/devicetree/bindings/rng/omap_rng.txt
+++ b/Documentation/devicetree/bindings/rng/omap_rng.txt
@@ -1,4 +1,4 @@
-OMAP SoC HWRNG Module
+OMAP SoC and Inside-Secure HWRNG Module
 
 Required properties:
 
@@ -6,11 +6,13 @@ Required properties:
   RNG versions:
   - "ti,omap2-rng" for OMAP2.
   - "ti,omap4-rng" for OMAP4, OMAP5 and AM33XX.
+  - "inside-secure,safexcel-eip76" for SoCs with EIP76 IP block
   Note that these two versions are incompatible.
 - ti,hwmods: Name of the hwmod associated with the RNG module
 - reg : Offset and length of the register set for the module
 - interrupts : the interrupt number for the RNG module.
-		Only used for "ti,omap4-rng".
+		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
+- clocks: the trng clock source
 
 Example:
 /* AM335x */
@@ -20,3 +22,11 @@ rng: rng@48310000 {
 	reg = <0x48310000 0x2000>;
 	interrupts = <111>;
 };
+
+/* SafeXcel IP-76 */
+trng: rng@f2760000 {
+	compatible = "inside-secure,safexcel-eip76";
+	reg = <0xf2760000 0x7d>;
+	interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&cpm_syscon0 1 25>;
+};
-- 
2.9.3
