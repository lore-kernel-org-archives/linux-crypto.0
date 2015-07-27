From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove unnecessary list iteration
Date: Mon, 27 Jul 2015 12:58:32 -0700
Message-ID: <20150727195832.30021.94483.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bruce.w.allan@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22554 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbbG0T7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jul 2015 15:59:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Bruce Allan <bruce.w.allan@intel.com>

There's no need to iterate through the list for instances in the
accel_table since the number of devices is already known in this file.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 3f0ff9e..46cfa7f 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -182,12 +182,7 @@ int adf_devmgr_verify_id(uint32_t id)
 
 void adf_devmgr_get_num_dev(uint32_t *num)
 {
-	struct list_head *itr;
-
-	*num = 0;
-	list_for_each(itr, &accel_table) {
-		(*num)++;
-	}
+	*num = num_devices;
 }
 
 int adf_dev_in_use(struct adf_accel_dev *accel_dev)
