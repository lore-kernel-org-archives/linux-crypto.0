From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix section mismatch warning
Date: Fri, 15 Apr 2016 10:54:07 -0700
Message-ID: <1460742847-10350-1-git-send-email-tadeusz.struk@intel.com>
References: <201604160011.1WGwhONj%fengguang.wu@intel.com>
Cc: <tadeusz.struk@intel.com>, <linux-crypto@vger.kernel.org>,
	<fengguang.wu@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43839 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbcDOR7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 13:59:22 -0400
In-Reply-To: <201604160011.1WGwhONj%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Subject: [PATCH] crypto: qat - fix section mismatch warning

Fix Section mismatch warinig in adf_exit_vf_wq()

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index c3d5016..1b36b84 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -324,7 +324,7 @@ int __init adf_init_vf_wq(void)
 	return !adf_vf_stop_wq ? -EFAULT : 0;
 }
 
-void __exit adf_exit_vf_wq(void)
+void adf_exit_vf_wq(void)
 {
 	if (adf_vf_stop_wq)
 		destroy_workqueue(adf_vf_stop_wq);
-- 
2.1.4
