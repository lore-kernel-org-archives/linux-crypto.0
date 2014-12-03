From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix problem with coalescing enable logic
Date: Tue, 02 Dec 2014 21:08:48 -0800
Message-ID: <20141203050847.10558.83640.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: joern@logfs.org, davem@davemloft.net, qat-linux@intel.com,
	dan.carpenter@oracle.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaLCFL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 00:11:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed issue reported by Dan Carpenter

410          if (adf_get_cfg_int(accel_dev, "Accelerator0",
411				 ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
412                              bank_num, &coalesc_enabled) && coalesc_enabled)
This condition is reversed, so it only enables coalescing on error.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 5f3fa45..5890992 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -376,8 +376,9 @@ static inline int adf_get_cfg_int(struct adf_accel_dev *accel_dev,
 	return 0;
 }
 
-static void adf_enable_coalesc(struct adf_etr_bank_data *bank,
-			       const char *section, uint32_t bank_num_in_accel)
+static void adf_get_coalesc_timer(struct adf_etr_bank_data *bank,
+				  const char *section,
+				  uint32_t bank_num_in_accel)
 {
 	if (adf_get_cfg_int(bank->accel_dev, section,
 			    ADF_ETRMGR_COALESCE_TIMER_FORMAT,
@@ -396,7 +397,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_etr_ring_data *ring;
 	struct adf_etr_ring_data *tx_ring;
-	uint32_t i, coalesc_enabled;
+	uint32_t i, coalesc_enabled = 0;
 
 	memset(bank, 0, sizeof(*bank));
 	bank->bank_number = bank_num;
@@ -407,10 +408,10 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	/* Enable IRQ coalescing always. This will allow to use
 	 * the optimised flag and coalesc register.
 	 * If it is disabled in the config file just use min time value */
-	if (adf_get_cfg_int(accel_dev, "Accelerator0",
-			    ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
-			    bank_num, &coalesc_enabled) && coalesc_enabled)
-		adf_enable_coalesc(bank, "Accelerator0", bank_num);
+	if ((adf_get_cfg_int(accel_dev, "Accelerator0",
+			     ADF_ETRMGR_COALESCING_ENABLED_FORMAT, bank_num,
+			     &coalesc_enabled) == 0) && coalesc_enabled)
+		adf_get_coalesc_timer(bank, "Accelerator0", bank_num);
 	else
 		bank->irq_coalesc_timer = ADF_COALESCING_MIN_TIME;
 
