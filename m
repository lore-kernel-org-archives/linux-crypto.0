From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - initialize cra_flags before register into kpp
Date: Thu, 22 Dec 2016 15:00:51 +0000
Message-ID: <20161222150051.6284-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sushil Kumar <sushilx.kumar@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:15580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934269AbcLVPA5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 10:00:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initialize dh.base.cra_flags before registering the dh algorithm.
Without this fix, the registration of the dh algorithm might fail
if the qat driver is restarted.

Signed-off-by: Sushil Kumar <sushilx.kumar@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 0d35dca..d3518e6 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1343,6 +1343,7 @@ int qat_asym_algs_register(void)
 		ret = crypto_register_akcipher(&rsa);
 		if (ret)
 			goto unlock;
+		dh.base.cra_flags = 0;
 		ret = crypto_register_kpp(&dh);
 	}
 unlock:
-- 
2.9.3
