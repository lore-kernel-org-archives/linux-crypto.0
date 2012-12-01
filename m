From: Vakul Garg <vakul@freescale.com>
Subject: [PATCHv2] crypto: caam - Updated SEC-4.0 device tree binding for ERA information.
Date: Sat, 1 Dec 2012 08:46:54 +0530
Message-ID: <1354331814-2660-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.180.30] ([216.32.180.30]:4508 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab2LADUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Nov 2012 22:20:19 -0500
Received: from mail251-va3 (localhost [127.0.0.1])	by
 mail251-va3-R.bigfish.com (Postfix) with ESMTP id 45275920234	for
 <linux-crypto@vger.kernel.org>; Sat,  1 Dec 2012 03:18:33 +0000 (UTC)
Received: from VA3EHSMHS011.bigfish.com (unknown [10.7.14.244])	by
 mail251-va3.bigfish.com (Postfix) with ESMTP id D75BD1040051	for
 <linux-crypto@vger.kernel.org>; Sat,  1 Dec 2012 03:18:31 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with ESMTP id qB13IS9U001650	for
 <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2012 20:18:29 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The compatible property in device tree "crypto" node has been enhanced
to provide SEC ERA information to the applications.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index bf57ecd..a07f000 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -53,7 +53,8 @@ PROPERTIES
    - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,sec-v4.0"
+      Definition: Must include "fsl,sec-v4.0". Also includes SEC
+           ERA versions (optional) with which the device is compatible.
 
    - #address-cells
        Usage: required
@@ -105,7 +106,7 @@ PROPERTIES
 
 EXAMPLE
 	crypto@300000 {
-		compatible = "fsl,sec-v4.0";
+		compatible = "fsl,sec-v4.0", "fsl,sec-era-v2.0";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
-- 
1.7.7.6
