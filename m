From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] crypto: caam - Added property fsl,sec-era in SEC4.0 device tree binding.
Date: Wed, 23 Jan 2013 11:04:55 +0530
Message-ID: <1358919295-18151-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:47572
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab3AWFhc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jan 2013 00:37:32 -0500
Received: from mail89-co9 (localhost [127.0.0.1])	by mail89-co9-R.bigfish.com
 (Postfix) with ESMTP id EF7288C00D0	for <linux-crypto@vger.kernel.org>; Wed,
 23 Jan 2013 05:37:31 +0000 (UTC)
Received: from CO9EHSMHS016.bigfish.com (unknown [10.236.132.231])	by
 mail89-co9.bigfish.com (Postfix) with ESMTP id 2BA53A8005A	for
 <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2013 05:37:30 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r0N5bPVj005114	for
 <linux-crypto@vger.kernel.org>; Tue, 22 Jan 2013 22:37:26 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This new property defines the era of the particular SEC version.
The compatible property in device tree "crypto" node has been updated
not to contain SEC era numbers.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
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
+      Usage: required
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
+		fsl,sec-era = <0x2>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
-- 
1.7.7.6
