From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2] crypto: qat - enable VF irq after guest exits
 ungracefully
Date: Wed, 09 Dec 2015 21:38:30 -0800
Message-ID: <20151210053830.16048.86205.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: xin.zeng@intel.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbbLJFlq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 00:41:46 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Zeng Xin <xin.zeng@intel.com>

The VF bundle interrupt is not triggered any more in
the case when guest is shut down with sample app running.
Need to clear the flag interrupt bit when restarting to fix
this irrecoverable state.

Signed-off-by: Zeng Xin <xin.zeng@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c      |    3 ++-
 .../qat/qat_common/adf_transport_access_macros.h   |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index a6f3766..57d2622 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -345,7 +345,7 @@ void adf_response_handler(uintptr_t bank_addr)
 {
 	struct adf_etr_bank_data *bank = (void *)bank_addr;
 
-	/* Handle all the responses nad reenable IRQs */
+	/* Handle all the responses and reenable IRQs */
 	adf_ring_response_handler(bank);
 	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 				   bank->irq_mask);
@@ -434,6 +434,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 		goto err;
 	}
 
+	WRITE_CSR_INT_FLAG(csr_addr, bank_num, ADF_BANK_INT_FLAG_CLEAR_MASK);
 	WRITE_CSR_INT_SRCSEL(csr_addr, bank_num);
 	return 0;
 err:
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 6ad7e4e..80e02a2 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -50,12 +50,14 @@
 #include "adf_accel_devices.h"
 #define ADF_BANK_INT_SRC_SEL_MASK_0 0x4444444CUL
 #define ADF_BANK_INT_SRC_SEL_MASK_X 0x44444444UL
+#define ADF_BANK_INT_FLAG_CLEAR_MASK 0xFFFF
 #define ADF_RING_CSR_RING_CONFIG 0x000
 #define ADF_RING_CSR_RING_LBASE 0x040
 #define ADF_RING_CSR_RING_UBASE 0x080
 #define ADF_RING_CSR_RING_HEAD 0x0C0
 #define ADF_RING_CSR_RING_TAIL 0x100
 #define ADF_RING_CSR_E_STAT 0x14C
+#define ADF_RING_CSR_INT_FLAG	0x170
 #define ADF_RING_CSR_INT_SRCSEL 0x174
 #define ADF_RING_CSR_INT_SRCSEL_2 0x178
 #define ADF_RING_CSR_INT_COL_EN 0x17C
@@ -144,6 +146,9 @@ do { \
 #define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
 		ADF_RING_CSR_RING_TAIL + (ring << 2), value)
+#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+			ADF_RING_CSR_INT_FLAG, value)
 #define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
 do { \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
