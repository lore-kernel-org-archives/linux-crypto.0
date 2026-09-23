Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD93D41B8D6;
	Wed, 23 Sep 2026 05:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140337; cv=none; b=tFyIZ2RTAT7PoTz5IRml67htKvFSpMHosESpTBr1FPXRnd/UNgZKcIcdQOzDxXqBmahMU3xPWTHsMhud9527mvFNiUI/DtaMuXe7CaY7IncpKaR8RgXlmOsD9oUjVegeIpzQOeggUi2fbQCUPJwTX2SIvdjm0NWlWIvkIca3U3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140337; c=relaxed/simple;
	bh=ccDcc+vtxEOkADHIXag6afqQIkseu9nMQYgDHfiGGew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OjA/SXoCv+NaZNRw0o5wi7yCa/o4lLUhyoKRV0IE9czqPoE387SK2cL1LbS7104fuSn/JPWK95MivVidJEdRvTXYXd+979nLUeJyx+fVyHCpj4BnKjnHa0ZrO4B8U7GsIAPmtFL6v1/2VGVv+t1FyrbbCGT6FqdjzGWCqCgFvM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WC+Mrlud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WC+Mrlud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5551F000FF;
	Wed, 23 Sep 2026 05:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790140335;
	bh=aRCyzmLx4vT9ZmYbf/Bqh7Thxc/Lw7tIP307y1HBKfw=;
	h=From:To:Cc:Subject:Date;
	b=WC+MrludsL6f9O6uErmrFVS6pM4Dpzpjx6l6lm2uDapssOPAFVJ5LE7WqsxpmsxWL
	 QNAKF/ufiprNPGsv7ZxqRLgQLydbIw40xDTZr8oUqd1GEdPfQjQesH5Pz5bPW2R6yM
	 BoVJhPtEDK8aeGWXMXkKuRAA9dAOxPEdWehqAC0klP4x72ZICbgSrcNzU6Qn1MZ02q
	 xdRcFF+mR5AWLBYT/Z+tlFQPHjxwbciwGfb+sTXp9n7F9vhIf52GwjILuybjHYGeI5
	 N4lpdw3krkIJf6lpmzLGpnsbwgeQjTXUvLr3CTW1ogM8iuo9tYrWxbIvDi3uER3bRE
	 MDS+tl4NF41NQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Tero Kristo <t-kristo@ti.com>,
	Keerthy <j-keerthy@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: sa2ul - Fix HMAC key preparation
Date: Tue, 22 Sep 2026 22:11:16 -0700
Message-ID: <20260923051116.92741-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sa_prepare_iopads() has multiple bugs, as discussed at
https://lore.kernel.org/linux-crypto/20260831055141.1632832-1-s-vadapalli@ti.com/T/#u

- Commit 3bf533787910 ("crypto: sha256 - Use the partial block API")
  introduced a 1-byte buffer overflow in the SHA-256 case by making the
  crypto_shash_export() write 1 more than sizeof(struct sha256_state).

- It never worked for HMAC keys longer than 64 bytes in the first place.

Fix both of these bugs by just using the crypto library to prepare the
key, like what the chelsio and qat drivers do.  Also remove the
pointless use of an indirect call.

Fixes: 3bf533787910 ("crypto: sha256 - Use the partial block API")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/sa2ul.c | 121 +++++++++--------------------------------
 1 file changed, 27 insertions(+), 94 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 0dce2b98886a8..b014350a3da0a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -125,9 +125,7 @@ struct sa_cmdl_cfg {
  * @mci_enc: Mode Control Instruction for Encryption algorithm
  * @mci_dec: Mode Control Instruction for Decryption
  * @inv_key: Whether the encryption algorithm demands key inversion
- * @ctx: Pointer to the algorithm context
  * @keyed_mac: Whether the authentication algorithm has key
- * @prep_iopad: Function pointer to generate intermediate ipad/opad
  */
 struct algo_data {
 	struct sa_eng_info enc_eng;
@@ -141,10 +139,7 @@ struct algo_data {
 	u8 *mci_enc;
 	u8 *mci_dec;
 	bool inv_key;
-	struct sa_tfm_ctx *ctx;
 	bool keyed_mac;
-	void (*prep_iopad)(struct algo_data *algo, const u8 *key,
-			   u16 key_sz, __be32 *ipad, __be32 *opad);
 };
 
 /**
@@ -381,86 +376,36 @@ static void sa_swiz_128(u8 *in, u16 len)
 	}
 }
 
-/* Prepare the ipad and opad from key as per SHA algorithm step 1*/
-static void prepare_kipad(u8 *k_ipad, const u8 *key, u16 key_sz)
+static void sa_prepare_iopads(struct algo_data *data, const u8 *key, u16 key_sz,
+			      __be32 *ipad, __be32 *opad)
 {
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_ipad[i] = key[i] ^ 0x36;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_ipad[i] = 0x36;
-}
-
-static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
-{
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_opad[i] = key[i] ^ 0x5c;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_opad[i] = 0x5c;
-}
-
-static void sa_export_shash(void *state, struct shash_desc *hash,
-			    int digest_size, __be32 *out)
-{
-	struct sha1_state *sha1;
-	struct sha256_state *sha256;
-	u32 *result;
-
-	switch (digest_size) {
-	case SHA1_DIGEST_SIZE:
-		sha1 = state;
-		result = sha1->state;
+	union {
+		struct hmac_sha1_key sha1;
+		struct hmac_sha256_key sha256;
+	} k;
+
+	switch (data->aalg_id) {
+	case SA_AALG_ID_HMAC_SHA1:
+		hmac_sha1_preparekey(&k.sha1, key, key_sz);
+		cpu_to_be32_array(ipad, k.sha1.istate.h,
+				  ARRAY_SIZE(k.sha1.istate.h));
+		cpu_to_be32_array(opad, k.sha1.ostate.h,
+				  ARRAY_SIZE(k.sha1.ostate.h));
 		break;
-	case SHA256_DIGEST_SIZE:
-		sha256 = state;
-		result = sha256->state;
+	case SA_AALG_ID_HMAC_SHA2_256:
+		hmac_sha256_preparekey(&k.sha256, key, key_sz);
+		cpu_to_be32_array(ipad, k.sha256.key.istate.h,
+				  ARRAY_SIZE(k.sha256.key.istate.h));
+		cpu_to_be32_array(opad, k.sha256.key.ostate.h,
+				  ARRAY_SIZE(k.sha256.key.ostate.h));
 		break;
 	default:
-		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
-			digest_size);
+		dev_err(sa_k3_dev, "%s: bad aalg_id=%d\n", __func__,
+			data->aalg_id);
 		return;
 	}
 
-	crypto_shash_export(hash, state);
-
-	cpu_to_be32_array(out, result, digest_size / 4);
-}
-
-static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
-			      u16 key_sz, __be32 *ipad, __be32 *opad)
-{
-	SHASH_DESC_ON_STACK(shash, data->ctx->shash);
-	int block_size = crypto_shash_blocksize(data->ctx->shash);
-	int digest_size = crypto_shash_digestsize(data->ctx->shash);
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		u8 k_pad[SHA1_BLOCK_SIZE];
-	} sha;
-
-	shash->tfm = data->ctx->shash;
-
-	prepare_kipad(sha.k_pad, key, key_sz);
-
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-	sa_export_shash(&sha, shash, digest_size, ipad);
-
-	prepare_kopad(sha.k_pad, key, key_sz);
-
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-
-	sa_export_shash(&sha, shash, digest_size, opad);
-
-	memzero_explicit(&sha, sizeof(sha));
+	memzero_explicit(&k, sizeof(k));
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
@@ -544,7 +489,7 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 
 	/* Copy the keys or ipad/opad */
 	if (ad->keyed_mac)
-		ad->prep_iopad(ad, key, key_sz, ipad, opad);
+		sa_prepare_iopads(ad, key, key_sz, ipad, opad);
 	else {
 		/* basic hash */
 		sc_buf[1] |= SA_BASIC_HASH;
@@ -1697,8 +1642,7 @@ static void sa_aead_dma_in_callback(void *data)
 	aead_request_complete(req, err);
 }
 
-static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
-			    const char *fallback)
+static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 {
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
@@ -1707,12 +1651,6 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	memzero_explicit(ctx, sizeof(*ctx));
 	ctx->dev_data = data;
 
-	ctx->shash = crypto_alloc_shash(hash, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->shash)) {
-		dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n", hash);
-		return PTR_ERR(ctx->shash);
-	}
-
 	ctx->fallback.aead = crypto_alloc_aead(fallback, 0,
 					       CRYPTO_ALG_NEED_FALLBACK);
 
@@ -1744,14 +1682,12 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "sha1",
-				"authenc(hmac(sha1),cbc(aes))");
+	return sa_cra_init_aead(tfm, "authenc(hmac(sha1),cbc(aes))");
 }
 
 static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "sha256",
-				"authenc(hmac(sha256),cbc(aes))");
+	return sa_cra_init_aead(tfm, "authenc(hmac(sha256),cbc(aes))");
 }
 
 static void sa_exit_tfm_aead(struct crypto_aead *tfm)
@@ -1759,7 +1695,6 @@ static void sa_exit_tfm_aead(struct crypto_aead *tfm)
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 
-	crypto_free_shash(ctx->shash);
 	crypto_free_aead(ctx->fallback.aead);
 
 	sa_free_ctx_info(&ctx->enc, data);
@@ -1785,7 +1720,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	if (key_idx >= 3)
 		return -EINVAL;
 
-	ad->ctx = ctx;
 	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
 	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
 	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
@@ -1795,7 +1729,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	ad->inv_key = true;
 	ad->keyed_mac = true;
 	ad->ealg_id = SA_EALG_ID_AES_CBC;
-	ad->prep_iopad = sa_prepare_iopads;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.enc = true;

base-commit: a9a2152d292fd0bc73814eb4a127278ee7dd3f6a
-- 
2.55.0

