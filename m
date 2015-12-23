From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix SKU definiftion for c3xxx dev
Date: Wed, 23 Dec 2015 07:36:28 -0800
Message-ID: <20151223153628.8771.71889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39691 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbbLWPj5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 10:39:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

c3xxx doesn't have the esram BAR and only has 6 ue.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c |   22 ++++++----------------
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h |    5 ++---
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index bda8f9f..c5bd5a9 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -50,14 +50,9 @@
 #include "adf_c3xxx_hw_data.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
-static const u32 thrd_to_arb_map_8_me_sku[] = {
-	0x10000888, 0x11000888, 0x10000888, 0x11000888, 0x10000888,
-	0x11000888, 0x10000888, 0x11000888, 0, 0
-};
-
-static const u32 thrd_to_arb_map_10_me_sku[] = {
-	0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA,
-	0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA
+static const u32 thrd_to_arb_map_6_me_sku[] = {
+	0x12222AAA, 0x11222AAA, 0x12222AAA,
+	0x11222AAA, 0x12222AAA, 0x11222AAA
 };
 
 static struct adf_hw_device_class c3xxx_class = {
@@ -117,16 +112,14 @@ static u32 get_etr_bar_id(struct adf_hw_device_data *self)
 
 static u32 get_sram_bar_id(struct adf_hw_device_data *self)
 {
-	return ADF_C3XXX_SRAM_BAR;
+	return 0;
 }
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
 	int aes = get_num_aes(self);
 
-	if (aes == 8)
-		return DEV_SKU_2;
-	else if (aes == 10)
+	if (aes == 6)
 		return DEV_SKU_4;
 
 	return DEV_SKU_UNKNOWN;
@@ -136,11 +129,8 @@ static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
 				    u32 const **arb_map_config)
 {
 	switch (accel_dev->accel_pci_dev.sku) {
-	case DEV_SKU_2:
-		*arb_map_config = thrd_to_arb_map_8_me_sku;
-		break;
 	case DEV_SKU_4:
-		*arb_map_config = thrd_to_arb_map_10_me_sku;
+		*arb_map_config = thrd_to_arb_map_6_me_sku;
 		break;
 	default:
 		dev_err(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index f2fa234..2f2681d 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -48,9 +48,8 @@
 #define ADF_C3XXX_HW_DATA_H_
 
 /* PCIe configuration space */
-#define ADF_C3XXX_SRAM_BAR 0
-#define ADF_C3XXX_PMISC_BAR 1
-#define ADF_C3XXX_ETR_BAR 2
+#define ADF_C3XXX_PMISC_BAR 0
+#define ADF_C3XXX_ETR_BAR 1
 #define ADF_C3XXX_RX_RINGS_OFFSET 8
 #define ADF_C3XXX_TX_RINGS_MASK 0xFF
 #define ADF_C3XXX_MAX_ACCELERATORS 3
