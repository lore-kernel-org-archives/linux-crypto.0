From: Vakul Garg <vakul@freescale.com>
Subject: [PATCHv2] crypto: caam - Added property fsl,sec-era in SEC4.0 device tree binding.
Date: Thu, 24 Jan 2013 12:13:46 +0530
Message-ID: <1359009826-32483-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	Stephen Boyd <sboyd@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vakul Garg <vakul@freescale.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	<devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This new property defines the era of the particular SEC version.
The compatible property in device tree "crypto" node has been updated
not to contain SEC era numbers.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
Changes in v1:
	1. Marked fsl,sec-era as 'optional'.

Changes in v2:
	1. Changed 'fsl,sec-era' in example from hex to decimal.

 .../devicetree/bindings/crypto/fsl-sec4.txt        |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index fc9ce6f..dc40055 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -54,8 +54,13 @@ PROPERTIES
    - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,sec-v4.0". Also includes SEC
-           ERA versions (optional) with which the device is compatible.
+      Definition: Must include "fsl,sec-v4.0"
+
+   - fsl,sec-era
+      Usage: optional
+      Value type: <u32>
+      Definition: A standard property. Define the 'ERA' of the SEC
+          device.
 
    - #address-cells
        Usage: required
@@ -107,7 +112,8 @@ PROPERTIES
 
 EXAMPLE
 	crypto@300000 {
-		compatible = "fsl,sec-v4.0", "fsl,sec-era-v2.0";
+		compatible = "fsl,sec-v4.0";
+		fsl,sec-era = <2>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
-- 
1.7.7.6


