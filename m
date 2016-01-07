From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH V3] crypto: qat - fix timeout issues
Date: Thu,  7 Jan 2016 09:39:46 +0800
Message-ID: <1452130786-147187-1-git-send-email-pingchao.yang@intel.com>
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Yang Pingchao <pingchao.yang@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:47376 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbcAGBji (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jan 2016 20:39:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the variable times data type and timeout conditon since the value
of times should be -1 after loop.

Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 0ac0ba8..7786e6e 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -389,7 +389,7 @@ static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
 {
 	unsigned int base_cnt, cur_cnt;
 	unsigned char ae;
-	unsigned int times = MAX_RETRY_TIMES;
+	int times = MAX_RETRY_TIMES;
 
 	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
 		qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT,
@@ -402,7 +402,7 @@ static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
 			cur_cnt &= 0xffff;
 		} while (times-- && (cur_cnt == base_cnt));
 
-		if (!times) {
+		if (times < 0) {
 			pr_err("QAT: AE%d is inactive!!\n", ae);
 			return -EFAULT;
 		}
@@ -453,7 +453,8 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 	void __iomem *csr_addr =
 			(void __iomem *)((uintptr_t)handle->hal_ep_csr_addr_v +
 			ESRAM_AUTO_INIT_CSR_OFFSET);
-	unsigned int csr_val, times = 30;
+	unsigned int csr_val;
+	int times = 30;
 
 	csr_val = ADF_CSR_RD(csr_addr, 0);
 	if ((csr_val & ESRAM_AUTO_TINIT) && (csr_val & ESRAM_AUTO_TINIT_DONE))
@@ -467,7 +468,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wait_cycles(handle, 0, ESRAM_AUTO_INIT_USED_CYCLES, 0);
 		csr_val = ADF_CSR_RD(csr_addr, 0);
 	} while (!(csr_val & ESRAM_AUTO_TINIT_DONE) && times--);
-	if ((!times)) {
+	if ((times < 0)) {
 		pr_err("QAT: Fail to init eSram!\n");
 		return -EFAULT;
 	}
@@ -658,7 +659,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 			ret = qat_hal_wait_cycles(handle, ae, 20, 1);
 		} while (ret && times--);
 
-		if (!times) {
+		if (times < 0) {
 			pr_err("QAT: clear GPR of AE %d failed", ae);
 			return -EINVAL;
 		}
-- 
2.6.4
