From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 08/14] crypto: caam - Added clocks and clock-names properties to SEC4.0 device tree binding
Date: Wed, 5 Aug 2015 11:28:42 -0700
Message-ID: <1438799328-10757-9-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:51232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753477AbbHES2y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:54 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The clocks and clock-names properties describe input clocks that may be
required for enablement of CAAM.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 Documentation/devicetree/bindings/crypto/fsl-sec4.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index e402277..1003073 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -106,6 +106,18 @@ PROPERTIES
           to the interrupt parent to which the child domain
           is being mapped.
 
+   - clocks
+      Usage: required if SEC 4.0 requires explicit enablement of clocks
+      Value type: <prop_encoded-array>
+      Definition:  A list of phandle and clock specifier pairs describing
+          the clocks required for enabling and disabling SEC 4.0.
+
+   - clock-names
+      Usage: required if SEC 4.0 requires explicit enablement of clocks
+      Value type: <string>
+      Definition: A list of clock name strings in the same order as the
+          clocks property.
+
    Note: All other standard properties (see the ePAPR) are allowed
    but are optional.
 
@@ -120,6 +132,11 @@ EXAMPLE
 		ranges = <0 0x300000 0x10000>;
 		interrupt-parent = <&mpic>;
 		interrupts = <92 2>;
+		clocks = <&clks IMX6QDL_CLK_CAAM_MEM>,
+			 <&clks IMX6QDL_CLK_CAAM_ACLK>,
+			 <&clks IMX6QDL_CLK_CAAM_IPG>,
+			 <&clks IMX6QDL_CLK_EIM_SLOW>;
+		clock-names = "mem", "aclk", "ipg", "emi_slow";
 	};
 
 =====================================================================
-- 
2.1.4
