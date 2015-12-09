From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - enable VF irq after guest exits ungracefully
Date: Wed, 09 Dec 2015 11:59:46 -0800
Message-ID: <20151209195946.17574.50691.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: xin.zeng@intel.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbbLIUDA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 15:03:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Signed-off-by: Zeng Xin <xin.zeng@intel.com>

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
index a6f3766..9baafce 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -104,6 +104,7 @@ static void adf_enable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
 	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
 	WRITE_CSR_INT_COL_CTL(bank->csr_addr, bank->bank_number,
 			      bank->irq_coalesc_timer);
+	WRITE_CSR_INT_FLAG(bank->csr_addr, bank->bank_number, bank->irq_mask);
 }
 
 static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
@@ -345,7 +346,7 @@ void adf_response_handler(uintptr_t bank_addr)
 {
 	struct adf_etr_bank_data *bank = (void *)bank_addr;
 
-	/* Handle all the responses nad reenable IRQs */
+	/* Handle all the responses and reenable IRQs */
 	adf_ring_response_handler(bank);
 	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 				   bank->irq_mask);
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 6ad7e4e..d5be2a3 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -56,6 +56,7 @@
 #define ADF_RING_CSR_RING_HEAD 0x0C0
 #define ADF_RING_CSR_RING_TAIL 0x100
 #define ADF_RING_CSR_E_STAT 0x14C
+#define ADF_RING_CSR_INT_FLAG	0x170
 #define ADF_RING_CSR_INT_SRCSEL 0x174
 #define ADF_RING_CSR_INT_SRCSEL_2 0x178
 #define ADF_RING_CSR_INT_COL_EN 0x17C
@@ -144,6 +145,9 @@ do { \
 #define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
 		ADF_RING_CSR_RING_TAIL + (ring << 2), value)
+#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+			ADF_RING_CSR_INT_FLAG, value)
 #define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
 do { \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
@@ -161,4 +165,5 @@ do { \
 #define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
 			ADF_RING_CSR_INT_FLAG_AND_COL, value)
+
 #endif
