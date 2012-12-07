From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree binding for ERA information."
Date: Fri, 7 Dec 2012 14:27:29 +0530
Message-ID: <1354870649-3656-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:32900 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab2LGI7T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2012 03:59:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit a2c0911c09190125f52c9941b9d187f601c2f7be.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
Instead of adding SEC era information in crypto node's compatible, a new
property 'fsl,sec-era' is being introduced into crypto node.

 .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index fc9ce6f..bd7ce12 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -54,8 +54,7 @@ PROPERTIES
    - compatible
       Usage: required
       Value type: <string>
-      Definition: Must include "fsl,sec-v4.0". Also includes SEC
-           ERA versions (optional) with which the device is compatible.
+      Definition: Must include "fsl,sec-v4.0"
 
    - #address-cells
        Usage: required
@@ -107,7 +106,7 @@ PROPERTIES
 
 EXAMPLE
 	crypto@300000 {
-		compatible = "fsl,sec-v4.0", "fsl,sec-era-v2.0";
+		compatible = "fsl,sec-v4.0";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x300000 0x10000>;
-- 
1.7.7.6
