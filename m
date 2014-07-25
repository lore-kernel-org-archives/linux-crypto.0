From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 10/10] crypto: qat: Fixed SKU1 dev issue
Date: Fri, 25 Jul 2014 15:56:03 -0700
Message-ID: <20140725225603.24909.4383.stgit@gitlad.jf.intel.com>
References: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57440 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaGYW4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:56:04 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix for issue with SKU1 device.
SKU1 device has 8 micro engines as opposed to 12 in other SKUs
so it was not possible to start the non-existing micro engines.

Signed-off-by: Bo Cui <bo.cui@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/qat_uclo.c           |    6 +-----
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 2580091..1e27f9f 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -256,10 +256,6 @@ static int qat_uclo_fetch_initmem_ae(struct icp_qat_fw_loader_handle *handle,
 		pr_err("QAT: Parse num for AE number failed\n");
 		return -EINVAL;
 	}
-	if (!test_bit(*ae, (unsigned long *)&handle->hal_handle->ae_mask)) {
-		pr_err("QAT: ae %d to be init is fused off\n", *ae);
-		return -EINVAL;
-	}
 	if (*ae >= ICP_QAT_UCLO_MAX_AE) {
 		pr_err("QAT: ae %d out of range\n", *ae);
 		return -EINVAL;
@@ -456,7 +452,7 @@ static int qat_uclo_init_memory(struct icp_qat_fw_loader_handle *handle)
 			(sizeof(struct icp_qat_uof_memvar_attr) *
 			initmem->val_attr_num));
 	}
-	for (ae = 0; ae < ICP_QAT_UCLO_MAX_AE; ae++) {
+	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
 		if (qat_hal_batch_wr_lm(handle, ae,
 					obj_handle->lm_init_tab[ae])) {
 			pr_err("QAT: fail to batch init lmem for AE %d\n", ae);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index c5ce236..b707f29 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -59,7 +59,7 @@
 #define ADF_DH895XCC_FUSECTL_SKU_4 0x3
 #define ADF_DH895XCC_MAX_ACCELERATORS 6
 #define ADF_DH895XCC_MAX_ACCELENGINES 12
-#define ADF_DH895XCC_ACCELERATORS_REG_OFFSET 18
+#define ADF_DH895XCC_ACCELERATORS_REG_OFFSET 13
 #define ADF_DH895XCC_ACCELERATORS_MASK 0x3F
 #define ADF_DH895XCC_ACCELENGINES_MASK 0xFFF
 #define ADF_DH895XCC_LEGFUSE_OFFSET 0x4C
