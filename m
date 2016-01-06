From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH] crypto: qat - fix timeout issues
Date: Wed,  6 Jan 2016 17:53:15 +0800
Message-ID: <1452073995-114905-1-git-send-email-pingchao.yang@intel.com>
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Yang Pingchao <pingchao.yang@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3127 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbcAFJzJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jan 2016 04:55:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the timeout conditon since the value of times should be -1
after loop.

Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 0ac0ba8..0d0b5ed 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -402,7 +402,7 @@ static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
 			cur_cnt &= 0xffff;
 		} while (times-- && (cur_cnt == base_cnt));
 
-		if (!times) {
+		if (times < 0) {
 			pr_err("QAT: AE%d is inactive!!\n", ae);
 			return -EFAULT;
 		}
@@ -467,7 +467,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wait_cycles(handle, 0, ESRAM_AUTO_INIT_USED_CYCLES, 0);
 		csr_val = ADF_CSR_RD(csr_addr, 0);
 	} while (!(csr_val & ESRAM_AUTO_TINIT_DONE) && times--);
-	if ((!times)) {
+	if ((times < 0)) {
 		pr_err("QAT: Fail to init eSram!\n");
 		return -EFAULT;
 	}
@@ -658,7 +658,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 			ret = qat_hal_wait_cycles(handle, ae, 20, 1);
 		} while (ret && times--);
 
-		if (!times) {
+		if (times < 0) {
 			pr_err("QAT: clear GPR of AE %d failed", ae);
 			return -EINVAL;
 		}
-- 
2.6.4
