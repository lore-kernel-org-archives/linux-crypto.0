From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - standardize device tree naming convention to
 utilize '-vX.Y'
Date: Mon, 14 Mar 2011 17:42:47 -0500
Message-ID: <20110314174247.e5515448.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Kumar Gala <kumar.gala@freescale.com>,
	Steve Cornelius <sec@pobox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<devicetree-discuss@lists.ozlabs.org>,
	<linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:44089
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715Ab1CNWn0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Mar 2011 18:43:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Help clarify that the number trailing in compatible nomenclature
is the version number of the device, i.e., change:

"fsl,p4080-sec4.0", "fsl,sec4.0";

to:

"fsl,p4080-sec-v4.0", "fsl,sec-v4.0";

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Steve Cornelius <sec@pobox.com>
---
 .../devicetree/bindings/crypto/fsl-sec4.txt        |   68 ++++++++++----------
 arch/powerpc/boot/dts/p4080ds.dts                  |   41 ++++++------
 drivers/crypto/caam/caamalg.c                      |    4 +-
 drivers/crypto/caam/ctrl.c                         |    6 +-
 4 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index fce16a8..568aa3c 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -53,7 +53,7 @@ PROPERTIES
    - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,p4080-sec4.0","fsl,sec-4.0"
+      Definition: Must include "fsl,p4080-sec-v4.0","fsl,sec-v4.0"
 
    - #address-cells
        Usage: required
@@ -72,7 +72,7 @@ PROPERTIES
       Usage: required
       Value type: <prop-encoded-array>
       Definition: A standard property.  Specifies the physical
-          address and length of the SEC4.0 configuration registers.
+          address and length of the SEC4 configuration registers.
           registers
 
    - ranges
@@ -105,7 +105,7 @@ PROPERTIES
 
 EXAMPLE
 	crypto@300000 {
-		compatible = "fsl,p4080-sec4.0", "fsl,sec4.0";
+		compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
@@ -127,7 +127,7 @@ P4080 Job Ring (JR) Node
   - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,p4080-sec4.0-job-ring","fsl,sec4.0-job-ring"
+      Definition: Must include "fsl,p4080-sec-v4.0-job-ring","fsl,sec-v4.0-job-ring"
 
   - reg
       Usage: required
@@ -163,8 +163,8 @@ P4080 Job Ring (JR) Node
 
 EXAMPLE
 	jr@1000 {
-		compatible = "fsl,p4080-sec4.0-job-ring",
-			     "fsl,sec4.0-job-ring";
+		compatible = "fsl,p4080-sec-v4.0-job-ring",
+			     "fsl,sec-v4.0-job-ring";
 		reg = <0x1000 0x1000>;
 		fsl,liodn = <0x081>;
 		interrupt-parent = <&mpic>;
@@ -186,7 +186,7 @@ P4080 Run Time Integrity Check (RTIC) Node
   - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,p4080-sec4.0-rtic","fsl,sec4.0-rtic".
+      Definition: Must include "fsl,p4080-sec-v4.0-rtic","fsl,sec-v4.0-rtic".
 
    - #address-cells
        Usage: required
@@ -219,8 +219,8 @@ P4080 Run Time Integrity Check (RTIC) Node
 
 EXAMPLE
 	rtic@6000 {
-		compatible = "fsl,p4080-sec4.0-rtic",
-			     "fsl,sec4.0-rtic";
+		compatible = "fsl,p4080-sec-v4.0-rtic",
+			     "fsl,sec-v4.0-rtic";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x6000 0x100>;
@@ -238,7 +238,7 @@ P4080 Run Time Integrity Check (RTIC) Memory Node
   - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,p4080-sec4.0-rtic-memory","fsl,sec4.0-rtic-memory".
+      Definition: Must include "fsl,p4080-sec-v4.0-rtic-memory","fsl,sec-v4.0-rtic-memory".
 
   - reg
       Usage: required
@@ -270,8 +270,8 @@ P4080 Run Time Integrity Check (RTIC) Memory Node
 
 EXAMPLE
 	rtic-a@0 {
-		compatible = "fsl,p4080-sec4.0-rtic-memory",
-			     "fsl,sec4.0-rtic-memory";
+		compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+			     "fsl,sec-v4.0-rtic-memory";
 		reg = <0x00 0x20 0x100 0x80>;
 		fsl,liodn   = <0x03c>;
 		fsl,rtic-region  = <0x12345678 0x12345678 0x12345678>;
@@ -288,7 +288,7 @@ P4080 Secure Non-Volatile Storage (SNVS) Node
   - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,p4080-sec4.0-mon", "fsl,sec4.0-mon".
+      Definition: Must include "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon".
 
   - reg
       Usage: required
@@ -315,7 +315,7 @@ P4080 Secure Non-Volatile Storage (SNVS) Node
 
 EXAMPLE
 	sec_mon@314000 {
-		compatible = "fsl,p4080-sec4.0-mon", "fsl,sec4.0-mon";
+		compatible = "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon";
 		reg = <0x314000 0x1000>;
 		interrupt-parent = <&mpic>;
 		interrupts = <93 2>;
@@ -325,7 +325,7 @@ EXAMPLE
 FULL EXAMPLE
 
 	crypto: crypto@300000 {
-		compatible = "fsl,p4080-sec4.0", "fsl,sec4.0";
+		compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
@@ -334,73 +334,73 @@ FULL EXAMPLE
 		interrupts = <92 2>;
 
 		sec_jr0: jr@1000 {
-			compatible = "fsl,p4080-sec4.0-job-ring",
-				     "fsl,sec4.0-job-ring";
+			compatible = "fsl,p4080-sec-v4.0-job-ring",
+				     "fsl,sec-v4.0-job-ring";
 			reg = <0x1000 0x1000>;
 			interrupt-parent = <&mpic>;
 			interrupts = <88 2>;
 		};
 
 		sec_jr1: jr@2000 {
-			compatible = "fsl,p4080-sec4.0-job-ring",
-				     "fsl,sec4.0-job-ring";
+			compatible = "fsl,p4080-sec-v4.0-job-ring",
+				     "fsl,sec-v4.0-job-ring";
 			reg = <0x2000 0x1000>;
 			interrupt-parent = <&mpic>;
 			interrupts = <89 2>;
 		};
 
 		sec_jr2: jr@3000 {
-			compatible = "fsl,p4080-sec4.0-job-ring",
-				     "fsl,sec4.0-job-ring";
+			compatible = "fsl,p4080-sec-v4.0-job-ring",
+				     "fsl,sec-v4.0-job-ring";
 			reg = <0x3000 0x1000>;
 			interrupt-parent = <&mpic>;
 			interrupts = <90 2>;
 		};
 
 		sec_jr3: jr@4000 {
-			compatible = "fsl,p4080-sec4.0-job-ring",
-				     "fsl,sec4.0-job-ring";
+			compatible = "fsl,p4080-sec-v4.0-job-ring",
+				     "fsl,sec-v4.0-job-ring";
 			reg = <0x4000 0x1000>;
 			interrupt-parent = <&mpic>;
 			interrupts = <91 2>;
 		};
 
 		rtic@6000 {
-			compatible = "fsl,p4080-sec4.0-rtic",
-				     "fsl,sec4.0-rtic";
+			compatible = "fsl,p4080-sec-v4.0-rtic",
+				     "fsl,sec-v4.0-rtic";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0x6000 0x100>;
 			ranges = <0x0 0x6100 0xe00>;
 
 			rtic_a: rtic-a@0 {
-				compatible = "fsl,p4080-sec4.0-rtic-memory",
-					     "fsl,sec4.0-rtic-memory";
+				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+					     "fsl,sec-v4.0-rtic-memory";
 				reg = <0x00 0x20 0x100 0x80>;
 			};
 
 			rtic_b: rtic-b@20 {
-				compatible = "fsl,p4080-sec4.0-rtic-memory",
-					     "fsl,sec4.0-rtic-memory";
+				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+					     "fsl,sec-v4.0-rtic-memory";
 				reg = <0x20 0x20 0x200 0x80>;
 			};
 
 			rtic_c: rtic-c@40 {
-				compatible = "fsl,p4080-sec4.0-rtic-memory",
-					     "fsl,sec4.0-rtic-memory";
+				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+					     "fsl,sec-v4.0-rtic-memory";
 				reg = <0x40 0x20 0x300 0x80>;
 			};
 
 			rtic_d: rtic-d@60 {
-				compatible = "fsl,p4080-sec4.0-rtic-memory",
-					     "fsl,sec4.0-rtic-memory";
+				compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+					     "fsl,sec-v4.0-rtic-memory";
 				reg = <0x60 0x20 0x500 0x80>;
 			};
 		};
 	};
 
 	sec_mon: sec_mon@314000 {
-		compatible = "fsl,p4080-sec4.0-mon", "fsl,sec4.0-mon";
+		compatible = "fsl,p4080-sec-v4.0-mon", "fsl,sec-v4.0-mon";
 		reg = <0x314000 0x1000>;
 		interrupt-parent = <&mpic>;
 		interrupts = <93 2>;
diff --git a/arch/powerpc/boot/dts/p4080ds.dts b/arch/powerpc/boot/dts/p4080ds.dts
index c78e801..0430d24 100644
--- a/arch/powerpc/boot/dts/p4080ds.dts
+++ b/arch/powerpc/boot/dts/p4080ds.dts
@@ -423,7 +423,7 @@
 		};
 
 		crypto: crypto@300000 {
-			compatible = "fsl,p4080-sec4.0", "fsl,sec4.0";
+			compatible = "fsl,p4080-sec-v4.0", "fsl,sec-v4.0";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			reg = <0x300000 0x10000>;
@@ -432,73 +432,74 @@
 			interrupts = <92 2>;
 
 			sec_jr0: jr@1000 {
-				compatible = "fsl,p4080-sec4.0-job-ring",
-					     "fsl,sec4.0-job-ring";
+				compatible = "fsl,p4080-sec-v4.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
 				reg = <0x1000 0x1000>;
 				interrupt-parent = <&mpic>;
 				interrupts = <88 2>;
 			};
 
 			sec_jr1: jr@2000 {
-				compatible = "fsl,p4080-sec4.0-job-ring",
-					     "fsl,sec4.0-job-ring";
+				compatible = "fsl,p4080-sec-v4.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
 				reg = <0x2000 0x1000>;
 				interrupt-parent = <&mpic>;
 				interrupts = <89 2>;
 			};
 
 			sec_jr2: jr@3000 {
-				compatible = "fsl,p4080-sec4.0-job-ring",
-					     "fsl,sec4.0-job-ring";
+				compatible = "fsl,p4080-sec-v4.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
 				reg = <0x3000 0x1000>;
 				interrupt-parent = <&mpic>;
 				interrupts = <90 2>;
 			};
 
 			sec_jr3: jr@4000 {
-				compatible = "fsl,p4080-sec4.0-job-ring",
-					     "fsl,sec4.0-job-ring";
+				compatible = "fsl,p4080-sec-v4.0-job-ring",
+					     "fsl,sec-v4.0-job-ring";
 				reg = <0x4000 0x1000>;
 				interrupt-parent = <&mpic>;
 				interrupts = <91 2>;
 			};
 
 			rtic@6000 {
-				compatible = "fsl,p4080-sec4.0-rtic",
-					     "fsl,sec4.0-rtic";
+				compatible = "fsl,p4080-sec-v4.0-rtic",
+					     "fsl,sec-v4.0-rtic";
 				#address-cells = <1>;
 				#size-cells = <1>;
 				reg = <0x6000 0x100>;
 				ranges = <0x0 0x6100 0xe00>;
 
 				rtic_a: rtic-a@0 {
-					compatible = "fsl,p4080-sec4.0-rtic-memory",
-						     "fsl,sec4.0-rtic-memory";
+					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+						     "fsl,sec-v4.0-rtic-memory";
 					reg = <0x00 0x20 0x100 0x80>;
 				};
 
 				rtic_b: rtic-b@20 {
-					compatible = "fsl,p4080-sec4.0-rtic-memory",
-						     "fsl,sec4.0-rtic-memory";
+					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+						     "fsl,sec-v4.0-rtic-memory";
 					reg = <0x20 0x20 0x200 0x80>;
 				};
 
 				rtic_c: rtic-c@40 {
-					compatible = "fsl,p4080-sec4.0-rtic-memory",
-						     "fsl,sec4.0-rtic-memory";
+					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+						     "fsl,sec-v4.0-rtic-memory";
 					reg = <0x40 0x20 0x300 0x80>;
 				};
 
 				rtic_d: rtic-d@60 {
-					compatible = "fsl,p4080-sec4.0-rtic-memory",
-						     "fsl,sec4.0-rtic-memory";
+					compatible = "fsl,p4080-sec-v4.0-rtic-memory",
+						     "fsl,sec-v4.0-rtic-memory";
 					reg = <0x60 0x20 0x500 0x80>;
 				};
 			};
 		};
 
 		sec_mon: sec_mon@314000 {
-			compatible = "fsl,p4080-sec4.0-mon", "fsl,sec4.0-mon";
+			compatible = "fsl,p4080-sec-v4.0-mon",
+				     "fsl,sec-v4.0-mon";
 			reg = <0x314000 0x1000>;
 			interrupt-parent = <&mpic>;
 			interrupts = <93 2>;
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d7fe3d3..1403434 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1020,7 +1020,7 @@ static void __exit caam_algapi_exit(void)
 	struct caam_crypto_alg *t_alg, *n;
 	int i, err;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
 	if (!dev_node)
 		return;
 
@@ -1094,7 +1094,7 @@ static int __init caam_algapi_init(void)
 	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
 	if (!dev_node)
 		return -ENODEV;
 
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index aa22161..59aae4e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -108,7 +108,7 @@ static int caam_probe(struct platform_device *pdev,
 	 * for all, then go probe each one.
 	 */
 	rspec = 0;
-	for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring")
+	for_each_compatible_node(np, NULL, "fsl,sec-v4.0-job-ring")
 		rspec++;
 	ctrlpriv->jrdev = kzalloc(sizeof(struct device *) * rspec, GFP_KERNEL);
 	if (ctrlpriv->jrdev == NULL) {
@@ -118,7 +118,7 @@ static int caam_probe(struct platform_device *pdev,
 
 	ring = 0;
 	ctrlpriv->total_jobrs = 0;
-	for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring") {
+	for_each_compatible_node(np, NULL, "fsl,sec-v4.0-job-ring") {
 		caam_jr_probe(pdev, np, ring);
 		ctrlpriv->total_jobrs++;
 		ring++;
@@ -236,7 +236,7 @@ static int caam_probe(struct platform_device *pdev,
 
 static struct of_device_id caam_match[] = {
 	{
-		.compatible = "fsl,sec4.0",
+		.compatible = "fsl,sec-v4.0",
 	},
 	{},
 };
-- 
1.7.4.1
