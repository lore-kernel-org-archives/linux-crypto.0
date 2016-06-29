From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/28] crypto: aesni - Use crypto_cipher to derive rfc4106 subkey
Date: Wed, 29 Jun 2016 18:03:59 +0800
Message-ID: <E1bICLf-0006uE-B5@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53929 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcF2KED (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLf-0005Iu-Gr
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently aesni uses an async ctr(aes) to derive the rfc4106
subkey, which was presumably copied over from the generic rfc4106
code.  Over there it's done that way because we already have a
ctr(aes) spawn.  But it is simply overkill for aesni since we
have to go get a ctr(aes) from scratch anyway.

This patch simplifies the subkey derivation by using a straight
aes cipher instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |   76 +++++--------------------------------
 1 file changed, 11 insertions(+), 65 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 9e15572e..0ab5ee1 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -59,17 +59,6 @@ struct aesni_rfc4106_gcm_ctx {
 	u8 nonce[4];
 };
 
-struct aesni_gcm_set_hash_subkey_result {
-	int err;
-	struct completion completion;
-};
-
-struct aesni_hash_subkey_req_data {
-	u8 iv[16];
-	struct aesni_gcm_set_hash_subkey_result result;
-	struct scatterlist sg;
-};
-
 struct aesni_lrw_ctx {
 	struct lrw_table_ctx lrw_table;
 	u8 raw_aes_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
@@ -809,71 +798,28 @@ static void rfc4106_exit(struct crypto_aead *aead)
 	cryptd_free_aead(*ctx);
 }
 
-static void
-rfc4106_set_hash_subkey_done(struct crypto_async_request *req, int err)
-{
-	struct aesni_gcm_set_hash_subkey_result *result = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-	result->err = err;
-	complete(&result->completion);
-}
-
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
-	struct crypto_ablkcipher *ctr_tfm;
-	struct ablkcipher_request *req;
-	int ret = -EINVAL;
-	struct aesni_hash_subkey_req_data *req_data;
+	struct crypto_cipher *tfm;
+	int ret;
 
-	ctr_tfm = crypto_alloc_ablkcipher("ctr(aes)", 0, 0);
-	if (IS_ERR(ctr_tfm))
-		return PTR_ERR(ctr_tfm);
+	tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
-	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
+	ret = crypto_cipher_setkey(tfm, key, key_len);
 	if (ret)
-		goto out_free_ablkcipher;
-
-	ret = -ENOMEM;
-	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
-	if (!req)
-		goto out_free_ablkcipher;
-
-	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
-	if (!req_data)
-		goto out_free_request;
-
-	memset(req_data->iv, 0, sizeof(req_data->iv));
+		goto out_free_cipher;
 
 	/* Clear the data in the hash sub key container to zero.*/
 	/* We want to cipher all zeros to create the hash sub key. */
 	memset(hash_subkey, 0, RFC4106_HASH_SUBKEY_SIZE);
 
-	init_completion(&req_data->result.completion);
-	sg_init_one(&req_data->sg, hash_subkey, RFC4106_HASH_SUBKEY_SIZE);
-	ablkcipher_request_set_tfm(req, ctr_tfm);
-	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
-					CRYPTO_TFM_REQ_MAY_BACKLOG,
-					rfc4106_set_hash_subkey_done,
-					&req_data->result);
-
-	ablkcipher_request_set_crypt(req, &req_data->sg,
-		&req_data->sg, RFC4106_HASH_SUBKEY_SIZE, req_data->iv);
-
-	ret = crypto_ablkcipher_encrypt(req);
-	if (ret == -EINPROGRESS || ret == -EBUSY) {
-		ret = wait_for_completion_interruptible
-			(&req_data->result.completion);
-		if (!ret)
-			ret = req_data->result.err;
-	}
-	kfree(req_data);
-out_free_request:
-	ablkcipher_request_free(req);
-out_free_ablkcipher:
-	crypto_free_ablkcipher(ctr_tfm);
+	crypto_cipher_encrypt_one(tfm, hash_subkey, hash_subkey);
+
+out_free_cipher:
+	crypto_free_cipher(tfm);
 	return ret;
 }
 
