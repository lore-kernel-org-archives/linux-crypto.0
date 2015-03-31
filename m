From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix checkpatch COMPARISON_TO_NULL issue
Date: Tue, 31 Mar 2015 09:30:50 -0700
Message-ID: <20150331163050.6379.93257.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbCaQav (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:51 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUokX006470
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:50 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CHECK:COMPARISON_TO_NULL: Comparison to NULL could be written
"!device_reset_wq"

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 82e23b8..2dbc733 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -239,7 +239,7 @@ EXPORT_SYMBOL_GPL(adf_disable_aer);
 int adf_init_aer(void)
 {
 	device_reset_wq = create_workqueue("qat_device_reset_wq");
-	return (device_reset_wq == NULL) ? -EFAULT : 0;
+	return !device_reset_wq ? -EFAULT : 0;
 }
 
 void adf_exit_aer(void)
