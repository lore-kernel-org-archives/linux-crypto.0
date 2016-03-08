From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove redundant arbiter configuration
Date: Tue,  8 Mar 2016 10:37:15 -0800
Message-ID: <1457462235-27433-1-git-send-email-tadeusz.struk@intel.com>
Cc: <linux-crypto@vger.kernel.org>, <ahsan.atta@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbcCHSmH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Mar 2016 13:42:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The default arbiter configuration for ring weights and response ordering
is exactly what we want so we don't need to configure anything more.
This will also fix the problem where number of bundles is different
between different devices.

Reported-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index f267d9e..d7dd18d 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -49,7 +49,6 @@
 #include "adf_transport_internal.h"
 
 #define ADF_ARB_NUM 4
-#define ADF_ARB_REQ_RING_NUM 8
 #define ADF_ARB_REG_SIZE 0x4
 #define ADF_ARB_WTR_SIZE 0x20
 #define ADF_ARB_OFFSET 0x30000
@@ -64,15 +63,6 @@
 	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
 	(ADF_ARB_REG_SLOT * index), value)
 
-#define WRITE_CSR_ARB_RESPORDERING(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_RO_EN_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
-
-#define WRITE_CSR_ARB_WEIGHT(csr_addr, arb, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_WTR_OFFSET) + (ADF_ARB_WTR_SIZE * arb) + \
-	(ADF_ARB_REG_SIZE * index), value)
-
 #define WRITE_CSR_ARB_SARCONFIG(csr_addr, index, value) \
 	ADF_CSR_WR(csr_addr, ADF_ARB_OFFSET + \
 	(ADF_ARB_REG_SIZE * index), value)
@@ -99,15 +89,6 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 	for (arb = 0; arb < ADF_ARB_NUM; arb++)
 		WRITE_CSR_ARB_SARCONFIG(csr, arb, arb_cfg);
 
-	/* Setup service weighting */
-	for (arb = 0; arb < ADF_ARB_NUM; arb++)
-		for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
-			WRITE_CSR_ARB_WEIGHT(csr, arb, i, 0xFFFFFFFF);
-
-	/* Setup ring response ordering */
-	for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
-		WRITE_CSR_ARB_RESPORDERING(csr, i, 0xFFFFFFFF);
-
 	/* Setup worker queue registers */
 	for (i = 0; i < hw_data->num_engines; i++)
 		WRITE_CSR_ARB_WQCFG(csr, i, i);
-- 
2.1.4
