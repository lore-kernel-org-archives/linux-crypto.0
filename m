From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix indentation
Date: Thu, 22 Dec 2016 14:58:23 +0000
Message-ID: <20161222145823.5782-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Ahsan Atta <ahsan.atta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:5528 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756592AbcLVO64 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 09:58:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index b3ebb25..8afac52 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -152,7 +152,7 @@ void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data)
 			ptr->hw_device->instance_id = i++;
 
 		if (i == class->instances)
-				break;
+			break;
 	}
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_update_class_index);
-- 
2.9.3
