Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D000F54774
	for <linux-crypto@vger.kernel.org>; Sat, 17 Aug 2024 03:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723867008; cv=none; b=l6vnYUSgKxW/j9GPLANDMLxVijau0xqXdwPb3hNYh58XWWqgZKHdJjIJlVNYtXTWr5gsNJjzcQ5oQihhFUZDlnuwsR98i5p9jawZ/YD3eN/qlN+EZhWZvnB0swYiEFg2jrQCIuyoSqeuCbn+A7TEJZVNNphDykVTCsFY3gFSGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723867008; c=relaxed/simple;
	bh=nvshWDz6sy+T6KNK6Ha/4qgolPZKDrl8Rcm90v1xM+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+0SyeDsHGTOgTUNofBEskUFlfKsXltupo6DiwJ90MTKeMGcXMcY5dDzOsUquG9gKyjWUmEIoJ71Lww+evtAbnZAbYomZRItxXcIAgNdRKSlB0Fz+14mm1pDzRgaI4SghwTyTcWBXHa2qYKbfn4g5VPq6XiD4IHpFCmj5bsB3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfAPs-005H2Z-2D;
	Sat, 17 Aug 2024 11:56:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 11:56:33 +0800
Date: Sat, 17 Aug 2024 11:56:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Srujana Challa <schalla@marvell.com>
Subject: [v2 PATCH] crypto: octeontx - Fix authenc setkey
Message-ID: <ZsAfcYN1wIeJJl2H@gondor.apana.org.au>
References: <Zr3ftZC585VPi8O7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr3ftZC585VPi8O7@gondor.apana.org.au>

v2 fixes a NULL-pointer dereference when ss is initialised because
there is no hash algorithm.

---8<---
Use the generic crypto_authenc_extractkeys helper instead of custom
parsing code that is slightly broken.  Also fix a number of memory
leaks by moving memory allocation from setkey to init_tfm (setkey
can be called multiple times over the life of a tfm).

Finally accept all hash key lengths by running the digest over
extra-long keys.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 3c5d577d8f0d..a8b2840551f7 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -17,7 +17,6 @@
 #include <crypto/sha2.h>
 #include <crypto/xts.h>
 #include <crypto/scatterwalk.h>
-#include <linux/rtnetlink.h>
 #include <linux/sort.h>
 #include <linux/module.h>
 #include "otx_cptvf.h"
@@ -66,6 +65,8 @@ static struct cpt_device_table ae_devices = {
 	.count = ATOMIC_INIT(0)
 };
 
+static struct otx_cpt_sdesc *alloc_sdesc(struct crypto_shash *alg);
+
 static inline int get_se_device(struct pci_dev **pdev, int *cpu_num)
 {
 	int count, ret = 0;
@@ -509,44 +510,65 @@ static int cpt_aead_init(struct crypto_aead *tfm, u8 cipher_type, u8 mac_type)
 	ctx->cipher_type = cipher_type;
 	ctx->mac_type = mac_type;
 
+	switch (ctx->mac_type) {
+	case OTX_CPT_SHA1:
+		ctx->hashalg = crypto_alloc_shash("sha1", 0,
+						  CRYPTO_ALG_ASYNC);
+		break;
+
+	case OTX_CPT_SHA256:
+		ctx->hashalg = crypto_alloc_shash("sha256", 0,
+						  CRYPTO_ALG_ASYNC);
+		break;
+
+	case OTX_CPT_SHA384:
+		ctx->hashalg = crypto_alloc_shash("sha384", 0,
+						  CRYPTO_ALG_ASYNC);
+		break;
+
+	case OTX_CPT_SHA512:
+		ctx->hashalg = crypto_alloc_shash("sha512", 0,
+						  CRYPTO_ALG_ASYNC);
+		break;
+	}
+
+	if (IS_ERR(ctx->hashalg))
+		return PTR_ERR(ctx->hashalg);
+
+	crypto_aead_set_reqsize_dma(tfm, sizeof(struct otx_cpt_req_ctx));
+
+	if (!ctx->hashalg)
+		return 0;
+
 	/*
 	 * When selected cipher is NULL we use HMAC opcode instead of
 	 * FLEXICRYPTO opcode therefore we don't need to use HASH algorithms
 	 * for calculating ipad and opad
 	 */
 	if (ctx->cipher_type != OTX_CPT_CIPHER_NULL) {
-		switch (ctx->mac_type) {
-		case OTX_CPT_SHA1:
-			ctx->hashalg = crypto_alloc_shash("sha1", 0,
-							  CRYPTO_ALG_ASYNC);
-			if (IS_ERR(ctx->hashalg))
-				return PTR_ERR(ctx->hashalg);
-			break;
+		int ss = crypto_shash_statesize(ctx->hashalg);
 
-		case OTX_CPT_SHA256:
-			ctx->hashalg = crypto_alloc_shash("sha256", 0,
-							  CRYPTO_ALG_ASYNC);
-			if (IS_ERR(ctx->hashalg))
-				return PTR_ERR(ctx->hashalg);
-			break;
+		ctx->ipad = kzalloc(ss, GFP_KERNEL);
+		if (!ctx->ipad) {
+			crypto_free_shash(ctx->hashalg);
+			return -ENOMEM;
+		}
 
-		case OTX_CPT_SHA384:
-			ctx->hashalg = crypto_alloc_shash("sha384", 0,
-							  CRYPTO_ALG_ASYNC);
-			if (IS_ERR(ctx->hashalg))
-				return PTR_ERR(ctx->hashalg);
-			break;
-
-		case OTX_CPT_SHA512:
-			ctx->hashalg = crypto_alloc_shash("sha512", 0,
-							  CRYPTO_ALG_ASYNC);
-			if (IS_ERR(ctx->hashalg))
-				return PTR_ERR(ctx->hashalg);
-			break;
+		ctx->opad = kzalloc(ss, GFP_KERNEL);
+		if (!ctx->opad) {
+			kfree(ctx->ipad);
+			crypto_free_shash(ctx->hashalg);
+			return -ENOMEM;
 		}
 	}
 
-	crypto_aead_set_reqsize_dma(tfm, sizeof(struct otx_cpt_req_ctx));
+	ctx->sdesc = alloc_sdesc(ctx->hashalg);
+	if (!ctx->sdesc) {
+		kfree(ctx->opad);
+		kfree(ctx->ipad);
+		crypto_free_shash(ctx->hashalg);
+		return -ENOMEM;
+	}
 
 	return 0;
 }
@@ -602,8 +624,7 @@ static void otx_cpt_aead_exit(struct crypto_aead *tfm)
 
 	kfree(ctx->ipad);
 	kfree(ctx->opad);
-	if (ctx->hashalg)
-		crypto_free_shash(ctx->hashalg);
+	crypto_free_shash(ctx->hashalg);
 	kfree(ctx->sdesc);
 }
 
@@ -699,7 +720,7 @@ static inline void swap_data64(void *buf, u32 len)
 		*dst = cpu_to_be64p(src);
 }
 
-static int copy_pad(u8 mac_type, u8 *out_pad, u8 *in_pad)
+static int swap_pad(u8 mac_type, u8 *pad)
 {
 	struct sha512_state *sha512;
 	struct sha256_state *sha256;
@@ -707,22 +728,19 @@ static int copy_pad(u8 mac_type, u8 *out_pad, u8 *in_pad)
 
 	switch (mac_type) {
 	case OTX_CPT_SHA1:
-		sha1 = (struct sha1_state *) in_pad;
+		sha1 = (struct sha1_state *)pad;
 		swap_data32(sha1->state, SHA1_DIGEST_SIZE);
-		memcpy(out_pad, &sha1->state, SHA1_DIGEST_SIZE);
 		break;
 
 	case OTX_CPT_SHA256:
-		sha256 = (struct sha256_state *) in_pad;
+		sha256 = (struct sha256_state *)pad;
 		swap_data32(sha256->state, SHA256_DIGEST_SIZE);
-		memcpy(out_pad, &sha256->state, SHA256_DIGEST_SIZE);
 		break;
 
 	case OTX_CPT_SHA384:
 	case OTX_CPT_SHA512:
-		sha512 = (struct sha512_state *) in_pad;
+		sha512 = (struct sha512_state *)pad;
 		swap_data64(sha512->state, SHA512_DIGEST_SIZE);
-		memcpy(out_pad, &sha512->state, SHA512_DIGEST_SIZE);
 		break;
 
 	default:
@@ -732,55 +750,52 @@ static int copy_pad(u8 mac_type, u8 *out_pad, u8 *in_pad)
 	return 0;
 }
 
-static int aead_hmac_init(struct crypto_aead *cipher)
+static int aead_hmac_init(struct crypto_aead *cipher,
+			  struct crypto_authenc_keys *keys)
 {
 	struct otx_cpt_aead_ctx *ctx = crypto_aead_ctx_dma(cipher);
-	int state_size = crypto_shash_statesize(ctx->hashalg);
-	int ds = crypto_shash_digestsize(ctx->hashalg);
 	int bs = crypto_shash_blocksize(ctx->hashalg);
-	int authkeylen = ctx->auth_key_len;
+	int authkeylen = keys->authkeylen;
 	u8 *ipad = NULL, *opad = NULL;
-	int ret = 0, icount = 0;
-
-	ctx->sdesc = alloc_sdesc(ctx->hashalg);
-	if (!ctx->sdesc)
-		return -ENOMEM;
-
-	ctx->ipad = kzalloc(bs, GFP_KERNEL);
-	if (!ctx->ipad) {
-		ret = -ENOMEM;
-		goto calc_fail;
-	}
-
-	ctx->opad = kzalloc(bs, GFP_KERNEL);
-	if (!ctx->opad) {
-		ret = -ENOMEM;
-		goto calc_fail;
-	}
-
-	ipad = kzalloc(state_size, GFP_KERNEL);
-	if (!ipad) {
-		ret = -ENOMEM;
-		goto calc_fail;
-	}
-
-	opad = kzalloc(state_size, GFP_KERNEL);
-	if (!opad) {
-		ret = -ENOMEM;
-		goto calc_fail;
-	}
+	int icount = 0;
+	int ret;
 
 	if (authkeylen > bs) {
-		ret = crypto_shash_digest(&ctx->sdesc->shash, ctx->key,
-					  authkeylen, ipad);
+		ret = crypto_shash_digest(&ctx->sdesc->shash, keys->authkey,
+					  authkeylen, ctx->key);
 		if (ret)
-			goto calc_fail;
+			return ret;
+		authkeylen = bs;
+	} else
+		memcpy(ctx->key, keys->authkey, authkeylen);
 
-		authkeylen = ds;
-	} else {
-		memcpy(ipad, ctx->key, authkeylen);
+	ctx->enc_key_len = keys->enckeylen;
+	ctx->auth_key_len = authkeylen;
+
+	if (ctx->cipher_type == OTX_CPT_CIPHER_NULL)
+		return keys->enckeylen ? -EINVAL : 0;
+
+	switch (keys->enckeylen) {
+	case AES_KEYSIZE_128:
+		ctx->key_type = OTX_CPT_AES_128_BIT;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->key_type = OTX_CPT_AES_192_BIT;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->key_type = OTX_CPT_AES_256_BIT;
+		break;
+	default:
+		/* Invalid key length */
+		return -EINVAL;
 	}
 
+	memcpy(ctx->key + authkeylen, keys->enckey, keys->enckeylen);
+
+	ipad = ctx->ipad;
+	opad = ctx->opad;
+
+	memcpy(ipad, ctx->key, authkeylen);
 	memset(ipad + authkeylen, 0, bs - authkeylen);
 	memcpy(opad, ipad, bs);
 
@@ -798,7 +813,7 @@ static int aead_hmac_init(struct crypto_aead *cipher)
 	crypto_shash_init(&ctx->sdesc->shash);
 	crypto_shash_update(&ctx->sdesc->shash, ipad, bs);
 	crypto_shash_export(&ctx->sdesc->shash, ipad);
-	ret = copy_pad(ctx->mac_type, ctx->ipad, ipad);
+	ret = swap_pad(ctx->mac_type, ipad);
 	if (ret)
 		goto calc_fail;
 
@@ -806,25 +821,9 @@ static int aead_hmac_init(struct crypto_aead *cipher)
 	crypto_shash_init(&ctx->sdesc->shash);
 	crypto_shash_update(&ctx->sdesc->shash, opad, bs);
 	crypto_shash_export(&ctx->sdesc->shash, opad);
-	ret = copy_pad(ctx->mac_type, ctx->opad, opad);
-	if (ret)
-		goto calc_fail;
-
-	kfree(ipad);
-	kfree(opad);
-
-	return 0;
+	ret = swap_pad(ctx->mac_type, opad);
 
 calc_fail:
-	kfree(ctx->ipad);
-	ctx->ipad = NULL;
-	kfree(ctx->opad);
-	ctx->opad = NULL;
-	kfree(ipad);
-	kfree(opad);
-	kfree(ctx->sdesc);
-	ctx->sdesc = NULL;
-
 	return ret;
 }
 
@@ -832,57 +831,15 @@ static int otx_cpt_aead_cbc_aes_sha_setkey(struct crypto_aead *cipher,
 					   const unsigned char *key,
 					   unsigned int keylen)
 {
-	struct otx_cpt_aead_ctx *ctx = crypto_aead_ctx_dma(cipher);
-	struct crypto_authenc_key_param *param;
-	int enckeylen = 0, authkeylen = 0;
-	struct rtattr *rta = (void *)key;
-	int status = -EINVAL;
+	struct crypto_authenc_keys authenc_keys;
+	int status;
 
-	if (!RTA_OK(rta, keylen))
-		goto badkey;
-
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-		goto badkey;
-
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
-		goto badkey;
-
-	param = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
-	key += RTA_ALIGN(rta->rta_len);
-	keylen -= RTA_ALIGN(rta->rta_len);
-	if (keylen < enckeylen)
-		goto badkey;
-
-	if (keylen > OTX_CPT_MAX_KEY_SIZE)
-		goto badkey;
-
-	authkeylen = keylen - enckeylen;
-	memcpy(ctx->key, key, keylen);
-
-	switch (enckeylen) {
-	case AES_KEYSIZE_128:
-		ctx->key_type = OTX_CPT_AES_128_BIT;
-		break;
-	case AES_KEYSIZE_192:
-		ctx->key_type = OTX_CPT_AES_192_BIT;
-		break;
-	case AES_KEYSIZE_256:
-		ctx->key_type = OTX_CPT_AES_256_BIT;
-		break;
-	default:
-		/* Invalid key length */
-		goto badkey;
-	}
-
-	ctx->enc_key_len = enckeylen;
-	ctx->auth_key_len = authkeylen;
-
-	status = aead_hmac_init(cipher);
+	status = crypto_authenc_extractkeys(&authenc_keys, key, keylen);
 	if (status)
 		goto badkey;
 
-	return 0;
+	status = aead_hmac_init(cipher, &authenc_keys);
+
 badkey:
 	return status;
 }
@@ -891,36 +848,7 @@ static int otx_cpt_aead_ecb_null_sha_setkey(struct crypto_aead *cipher,
 					    const unsigned char *key,
 					    unsigned int keylen)
 {
-	struct otx_cpt_aead_ctx *ctx = crypto_aead_ctx_dma(cipher);
-	struct crypto_authenc_key_param *param;
-	struct rtattr *rta = (void *)key;
-	int enckeylen = 0;
-
-	if (!RTA_OK(rta, keylen))
-		goto badkey;
-
-	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
-		goto badkey;
-
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
-		goto badkey;
-
-	param = RTA_DATA(rta);
-	enckeylen = be32_to_cpu(param->enckeylen);
-	key += RTA_ALIGN(rta->rta_len);
-	keylen -= RTA_ALIGN(rta->rta_len);
-	if (enckeylen != 0)
-		goto badkey;
-
-	if (keylen > OTX_CPT_MAX_KEY_SIZE)
-		goto badkey;
-
-	memcpy(ctx->key, key, keylen);
-	ctx->enc_key_len = enckeylen;
-	ctx->auth_key_len = keylen;
-	return 0;
-badkey:
-	return -EINVAL;
+	return otx_cpt_aead_cbc_aes_sha_setkey(cipher, key, keylen);
 }
 
 static int otx_cpt_aead_gcm_aes_setkey(struct crypto_aead *cipher,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
