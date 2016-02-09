From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: qat - Set ctx->e to NULL in qat_rsa_exit_tfm
Date: Tue,  9 Feb 2016 11:21:35 +0000
Message-ID: <1455016895-22090-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbcBILVv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 06:21:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 51c594f..54e386e 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -709,7 +709,7 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	}
 	qat_crypto_put_instance(ctx->inst);
 	ctx->n = NULL;
-	ctx->d = NULL;
+	ctx->e = NULL;
 	ctx->d = NULL;
 }
 
-- 
1.9.1
