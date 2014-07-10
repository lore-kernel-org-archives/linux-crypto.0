From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Base AXI DMA cache settings on device tree
Date: Thu, 10 Jul 2014 10:58:35 -0500
Message-ID: <20140710155835.17665.84896.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:22867
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752009AbaGJP6x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2014 11:58:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The default cache operations for ARM64 were changed during 3.15.
To use coherent operations a "dma-coherent" device tree property
is required.  If that property is not present in the device tree
node then the non-coherent operations are assigned for the device.

Add support to the ccp driver to assign the AXI DMA cache settings
based on whether the "dma-coherent" property is present in the device
node.  If present, use settings that work with the caches.  If not
present, use settings that do not look at the caches.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 .../devicetree/bindings/crypto/amd-ccp.txt         |    3 +++
 drivers/crypto/ccp/Kconfig                         |    1 +
 drivers/crypto/ccp/ccp-dev.c                       |    2 +-
 drivers/crypto/ccp/ccp-dev.h                       |    4 ++++
 drivers/crypto/ccp/ccp-platform.c                  |    6 ++++++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/amd-ccp.txt b/Documentation/devicetree/bindings/crypto/amd-ccp.txt
index 6e0b11a..8c61183 100644
--- a/Documentation/devicetree/bindings/crypto/amd-ccp.txt
+++ b/Documentation/devicetree/bindings/crypto/amd-ccp.txt
@@ -7,6 +7,9 @@ Required properties:
   that services interrupts for this device
 - interrupts: Should contain the CCP interrupt
 
+Optional properties:
+- dma-coherent: Present if dma operations are coherent
+
 Example:
 	ccp@e0100000 {
 		compatible = "amd,ccp-seattle-v1a";
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 7639ffc..474382d 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -3,6 +3,7 @@ config CRYPTO_DEV_CCP_DD
 	depends on CRYPTO_DEV_CCP
 	default m
 	select HW_RANDOM
+	select OF if ARM64
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index fa1ab10..a7d1106 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -364,7 +364,7 @@ int ccp_init(struct ccp_device *ccp)
 
 #ifdef CONFIG_ARM64
 		/* For arm64 set the recommended queue cache settings */
-		iowrite32(CACHE_WB_NO_ALLOC, ccp->io_regs + CMD_Q_CACHE_BASE +
+		iowrite32(ccp->axcache, ccp->io_regs + CMD_Q_CACHE_BASE +
 			  (CMD_Q_CACHE_INC * i));
 #endif
 
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 1c5651b..62ff35a 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -30,6 +30,7 @@
 
 #define TRNG_RETRIES			10
 
+#define CACHE_NONE			0x00
 #define CACHE_WB_NO_ALLOC		0xb7
 
 
@@ -255,6 +256,9 @@ struct ccp_device {
 	/* Suspend support */
 	unsigned int suspending;
 	wait_queue_head_t suspend_queue;
+
+	/* DMA caching attribute support */
+	unsigned int axcache;
 };
 
 
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 65e5829..b0a2806 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/ccp.h>
+#include <linux/of.h>
 
 #include "ccp-dev.h"
 
@@ -112,6 +113,11 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	*(dev->dma_mask) = DMA_BIT_MASK(48);
 	dev->coherent_dma_mask = DMA_BIT_MASK(48);
 
+	if (of_property_read_bool(dev->of_node, "dma-coherent"))
+		ccp->axcache = CACHE_WB_NO_ALLOC;
+	else
+		ccp->axcache = CACHE_NONE;
+
 	dev_set_drvdata(dev, ccp);
 
 	ret = ccp_init(ccp);
