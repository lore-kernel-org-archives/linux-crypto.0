From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH] The AE id should be less than the maximal AE number
Date: Wed, 17 Feb 2016 22:29:02 -0500
Message-ID: <1455766142-57666-1-git-send-email-pingchao.yang@intel.com>
Cc: <tadeusz.struk@intel.com>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, Yang Pingchao <pingchao.yang@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:61615 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424609AbcBRDb1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2016 22:31:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 25d15f1..9b961b3 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -688,7 +688,7 @@ static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
 	int mflag = 0;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 
-	for (ae = 0; ae <= max_ae; ae++) {
+	for (ae = 0; ae < max_ae; ae++) {
 		if (!test_bit(ae,
 			      (unsigned long *)&handle->hal_handle->ae_mask))
 			continue;
-- 
2.4.3
