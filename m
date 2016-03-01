From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 1/4] crypto: ccp - Remove check for x86 family and model
Date: Tue, 1 Mar 2016 13:48:54 -0600
Message-ID: <20160301194854.6788.20633.stgit@taos.amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:47872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbcCAUEx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 15:04:53 -0500
In-Reply-To: <20160301194831.6788.2154.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Each x86 SoC will make use of a unique PCI ID for the CCP
device so it is not necessary to check for the CPU family
and model.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |   47 ++++++++++--------------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 861bacc..725c590 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) driver
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -577,41 +577,22 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 }
 #endif
 
-#ifdef CONFIG_X86
-static const struct x86_cpu_id ccp_support[] = {
-	{ X86_VENDOR_AMD, 22, },
-	{ },
-};
-#endif
-
 static int __init ccp_mod_init(void)
 {
 #ifdef CONFIG_X86
-	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
 	int ret;
 
-	if (!x86_match_cpu(ccp_support))
-		return -ENODEV;
-
-	switch (cpuinfo->x86) {
-	case 22:
-		if ((cpuinfo->x86_model < 48) || (cpuinfo->x86_model > 63))
-			return -ENODEV;
-
-		ret = ccp_pci_init();
-		if (ret)
-			return ret;
-
-		/* Don't leave the driver loaded if init failed */
-		if (!ccp_get_device()) {
-			ccp_pci_exit();
-			return -ENODEV;
-		}
-
-		return 0;
+	ret = ccp_pci_init();
+	if (ret)
+		return ret;
 
-		break;
+	/* Don't leave the driver loaded if init failed */
+	if (!ccp_get_device()) {
+		ccp_pci_exit();
+		return -ENODEV;
 	}
+
+	return 0;
 #endif
 
 #ifdef CONFIG_ARM64
@@ -636,13 +617,7 @@ static int __init ccp_mod_init(void)
 static void __exit ccp_mod_exit(void)
 {
 #ifdef CONFIG_X86
-	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
-
-	switch (cpuinfo->x86) {
-	case 22:
-		ccp_pci_exit();
-		break;
-	}
+	ccp_pci_exit();
 #endif
 
 #ifdef CONFIG_ARM64
