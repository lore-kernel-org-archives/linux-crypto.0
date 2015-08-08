From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH] Removing CTR mode from NX driver
Date: Sat, 8 Aug 2015 18:31:01 -0300
Message-ID: <20150808213058.GA5932@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, pfsmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53376 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992672AbbHHVbI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Aug 2015 17:31:08 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Sat, 8 Aug 2015 18:31:06 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CTR hardware implementation does not match with kernel spec causing a counter bug
where just low 8 bytes are used for counter, when should be all 16bytes.

Since we already have other counter modes working according with specs
not worth to keep CTR itself on NX.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-ctr.c | 21 ---------------------
 drivers/crypto/nx/nx.c         |  9 +--------
 drivers/crypto/nx/nx.h         |  1 -
 3 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index dd7e9f3..898c0a2 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -144,27 +144,6 @@ static int ctr3686_aes_nx_crypt(struct blkcipher_desc *desc,
 	return ctr_aes_nx_crypt(desc, dst, src, nbytes);
 }
 
-struct crypto_alg nx_ctr_aes_alg = {
-	.cra_name        = "ctr(aes)",
-	.cra_driver_name = "ctr-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize   = 1,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_blkcipher_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_ctr_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_blkcipher = {
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize      = AES_BLOCK_SIZE,
-		.setkey      = ctr_aes_nx_set_key,
-		.encrypt     = ctr_aes_nx_crypt,
-		.decrypt     = ctr_aes_nx_crypt,
-	}
-};
-
 struct crypto_alg nx_ctr3686_aes_alg = {
 	.cra_name        = "rfc3686(ctr(aes))",
 	.cra_driver_name = "rfc3686-ctr-aes-nx",
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 4369713..42fd3e6 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -596,13 +596,9 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_ecb;
 
-	rc = nx_register_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
-	if (rc)
-		goto out_unreg_cbc;
-
 	rc = nx_register_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 	if (rc)
-		goto out_unreg_ctr;
+		goto out_unreg_cbc;
 
 	rc = nx_register_aead(&nx_gcm_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 	if (rc)
@@ -653,8 +649,6 @@ out_unreg_gcm:
 	nx_unregister_aead(&nx_gcm_aes_alg, NX_FC_AES, NX_MODE_AES_GCM);
 out_unreg_ctr3686:
 	nx_unregister_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
-out_unreg_ctr:
-	nx_unregister_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 out_unreg_cbc:
 	nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 out_unreg_ecb:
@@ -822,7 +816,6 @@ static int nx_remove(struct vio_dev *viodev)
 				   NX_FC_AES, NX_MODE_AES_GCM);
 		nx_unregister_alg(&nx_ctr3686_aes_alg,
 				  NX_FC_AES, NX_MODE_AES_CTR);
-		nx_unregister_alg(&nx_ctr_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 		nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 		nx_unregister_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 	}
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index cdff03a..b8fc1ad 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -187,7 +187,6 @@ extern struct crypto_alg nx_cbc_aes_alg;
 extern struct crypto_alg nx_ecb_aes_alg;
 extern struct aead_alg nx_gcm_aes_alg;
 extern struct aead_alg nx_gcm4106_aes_alg;
-extern struct crypto_alg nx_ctr_aes_alg;
 extern struct crypto_alg nx_ctr3686_aes_alg;
 extern struct crypto_alg nx_ccm_aes_alg;
 extern struct crypto_alg nx_ccm4309_aes_alg;
-- 
1.8.3.1
