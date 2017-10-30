From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0 device tree binding
Date: Mon, 30 Oct 2017 15:46:51 +0200
Message-ID: <20171030134654.13729-2-horia.geanta@nxp.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <dmaengine@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>
To: Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Radu Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0072.outbound.protection.outlook.com ([104.47.33.72]:13097
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751969AbdJ3NrN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 09:47:13 -0400
In-Reply-To: <20171030134654.13729-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
---
 .../devicetree/bindings/crypto/fsl-sec4.txt         | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
index 7aef0eae58d4..97b37c15d793 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
@@ -6,6 +6,7 @@ Copyright (C) 2008-2011 Freescale Semiconductor Inc.
    -Overview
    -SEC 4 Node
    -Job Ring Node
+   -CAAM DMA Node
    -Run Time Integrity Check (RTIC) Node
    -Run Time Integrity Check (RTIC) Memory Node
    -Secure Non-Volatile Storage (SNVS) Node
@@ -215,6 +216,26 @@ EXAMPLE
 		interrupts = <88 2>;
 	};
 
+=====================================================================
+CAAM DMA Node
+
+    Child node of the crypto node that enables the use of the DMA capabilities
+    of the CAAM by a stand-alone driver. The only required property is the
+    "compatible" property. All the other properties are determined from
+    the job rings on which the CAAM DMA driver depends (ex: the number of
+    dma-channels is equal to the number of defined job rings).
+
+  - compatible
+      Usage: required
+      Value type: <string>
+      Definition: Must include "fsl,sec-v4.0-dma"
+
+EXAMPLE
+  caam-dma {
+    compatible = "fsl,sec-v5.4-dma",
+                 "fsl,sec-v5.0-dma",
+                 "fsl,sec-v4.0-dma";
+  }
 
 =====================================================================
 Run Time Integrity Check (RTIC) Node
-- 
2.14.2.606.g7451fcd
