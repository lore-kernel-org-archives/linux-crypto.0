From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - adf_ae_stop() is never called
Date: Fri, 09 Jan 2015 11:55:09 -0800
Message-ID: <20150109195509.28205.49333.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbbAITzB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 14:55:01 -0500
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id t09Jt9Do028271
	for <linux-crypto@vger.kernel.org>; Fri, 9 Jan 2015 11:55:09 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In adf_dev_stop(), adf_ae_stop() is never called because adf_dev_started()
will always return false since the ADF_STATUS_STARTED bit is cleared
earlier in the function.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/adf_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index edbf85a..8f0ca49 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -319,7 +319,7 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (wait)
 		msleep(100);
 
-	if (adf_dev_started(accel_dev)) {
+	if (test_bit(ADF_STATUS_AE_STARTED, &accel_dev->status)) {
 		if (adf_ae_stop(accel_dev))
 			pr_err("QAT: failed to stop AE\n");
 		else
