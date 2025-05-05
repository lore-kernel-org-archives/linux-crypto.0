Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5996926E175
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=q7nf9dB1q4dPzlbP1ACYpVGcDUodloRtY7Nk2oEOnB+K1JTljzDeqUzrZtw3m5gnRK3QjWSTL6wZNX7c3OtCyZ/NShR7Zvdp2nx+DPmZAyvwBfydSbzUCqISzNrg6J3KS8HP+pJAArqNBaHDD1vXak1NKcRn4gvYvDGjtYhh064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=l+M5dpOFHFtihj6abcf696Sc9KhYLouQYRQjAQjIRHs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GttEtyEKkcFiVqmYYroOtft91IuSvX3mRJ4ZirI6joNFfyv0Hmohot9xm9C/rfB/xV4pWfIMWikqUxQNl/E0HKXncW2VGtuI3ij4pobYRJzSNOAZEAklkvwt9YtiNm2b4ZSWsHcSsILssbPW9DNMqjlCDL/rJ3ZxbqEMqyjTe/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgw7YAJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgw7YAJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB17FC4CEE9
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472296;
	bh=l+M5dpOFHFtihj6abcf696Sc9KhYLouQYRQjAQjIRHs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cgw7YAJMDesePRBDwQb9a5xBMAsfrky4nmmwI0XjBgR+HIxqNDNJhL/rTbB8T/g+X
	 qD5d2OkvQW6MuV6B9AtEb5NFpxwux1DFBIl1Rn3Ux4YwLLhj+NSUXFPt696sW/3K+t
	 Oy6JD+IZKm7SEPWdTW9oen34OMAvt48n+7vNNPruxpcQcu9UZrlDsDW31Bh0sSUuzq
	 QuXk11JDfXFtrtndGteUxnaWgiipRFO3bBEXzR61a/xQeROXwmsN8T/39VVX8+KgQS
	 lOUs9rkN5E5Ibj1rCaCzyI09qmthRdRllwoeXNTOPVrcavXoFeRIw5iZtloymChPIE
	 AynbkU1VNBXow==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 2/8] crypto: authenc - use memcpy_sglist() instead of null skcipher
Date: Mon,  5 May 2025 12:10:39 -0700
Message-ID: <20250505191045.763835-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

For copying data between two scatterlists, just use memcpy_sglist()
instead of the so-called "null skcipher".  This is much simpler.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig      |  1 -
 crypto/authenc.c    | 32 +-------------------------------
 crypto/authencesn.c | 38 +++-----------------------------------
 3 files changed, 4 insertions(+), 67 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 551eeeab3a0a..537602b8e60e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -226,11 +226,10 @@ config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
-	select CRYPTO_NULL
 	help
 	  Authenc: Combined mode wrapper for IPsec.
 
 	  This is required for IPSec ESP (XFRM_ESP).
 
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 9521ae2f112e..a723769c8777 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -7,11 +7,10 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
-#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -26,11 +25,10 @@ struct authenc_instance_ctx {
 };
 
 struct crypto_authenc_ctx {
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_sync_skcipher *null;
 };
 
 struct authenc_request_ctx {
 	struct scatterlist src[2];
 	struct scatterlist dst[2];
@@ -168,25 +166,10 @@ static void crypto_authenc_encrypt_done(void *data, int err)
 
 out:
 	authenc_request_complete(areq, err);
 }
 
-static int crypto_authenc_copy_assoc(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
-
-	skcipher_request_set_sync_tfm(skreq, ctx->null);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      NULL, NULL);
-	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
-				   NULL);
-
-	return crypto_skcipher_encrypt(skreq);
-}
-
 static int crypto_authenc_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
@@ -201,14 +184,11 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
 	dst = src;
 
 	if (req->src != req->dst) {
-		err = crypto_authenc_copy_assoc(req);
-		if (err)
-			return err;
-
+		memcpy_sglist(req->dst, req->src, req->assoclen);
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 	}
 
 	skcipher_request_set_tfm(skreq, enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
@@ -301,11 +281,10 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_sync_skcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
@@ -313,18 +292,12 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher();
-	err = PTR_ERR(null);
-	if (IS_ERR(null))
-		goto err_free_skcipher;
-
 	ctx->auth = auth;
 	ctx->enc = enc;
-	ctx->null = null;
 
 	crypto_aead_set_reqsize(
 		tfm,
 		sizeof(struct authenc_request_ctx) +
 		ictx->reqoff +
@@ -334,12 +307,10 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
-err_free_skcipher:
-	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
@@ -347,11 +318,10 @@ static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
 {
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_skcipher(ctx->enc);
-	crypto_put_default_null_skcipher();
 }
 
 static void crypto_authenc_free(struct aead_instance *inst)
 {
 	struct authenc_instance_ctx *ctx = aead_instance_ctx(inst);
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index b1c78313cbc1..d1bf0fda3f2e 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -10,11 +10,10 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
-#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -29,11 +28,10 @@ struct authenc_esn_instance_ctx {
 
 struct crypto_authenc_esn_ctx {
 	unsigned int reqoff;
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_sync_skcipher *null;
 };
 
 struct authenc_esn_request_ctx {
 	struct scatterlist src[2];
 	struct scatterlist dst[2];
@@ -156,24 +154,10 @@ static void crypto_authenc_esn_encrypt_done(void *data, int err)
 		err = crypto_authenc_esn_genicv(areq, 0);
 
 	authenc_esn_request_complete(areq, err);
 }
 
-static int crypto_authenc_esn_copy(struct aead_request *req, unsigned int len)
-{
-	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
-	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
-
-	skcipher_request_set_sync_tfm(skreq, ctx->null);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      NULL, NULL);
-	skcipher_request_set_crypt(skreq, req->src, req->dst, len, NULL);
-
-	return crypto_skcipher_encrypt(skreq);
-}
-
 static int crypto_authenc_esn_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
@@ -188,14 +172,11 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
 
 	if (req->src != req->dst) {
-		err = crypto_authenc_esn_copy(req, assoclen);
-		if (err)
-			return err;
-
+		memcpy_sglist(req->dst, req->src, assoclen);
 		sg_init_table(areq_ctx->dst, 2);
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, assoclen);
 	}
 
 	skcipher_request_set_tfm(skreq, enc);
@@ -275,15 +256,12 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
 	cryptlen -= authsize;
 
-	if (req->src != dst) {
-		err = crypto_authenc_esn_copy(req, assoclen + cryptlen);
-		if (err)
-			return err;
-	}
+	if (req->src != dst)
+		memcpy_sglist(dst, req->src, assoclen + cryptlen);
 
 	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
 				 authsize, 0);
 
 	if (!authsize)
@@ -315,11 +293,10 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct authenc_esn_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
 	struct crypto_skcipher *enc;
-	struct crypto_sync_skcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
@@ -327,18 +304,12 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 	enc = crypto_spawn_skcipher(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher();
-	err = PTR_ERR(null);
-	if (IS_ERR(null))
-		goto err_free_skcipher;
-
 	ctx->auth = auth;
 	ctx->enc = enc;
-	ctx->null = null;
 
 	ctx->reqoff = 2 * crypto_ahash_digestsize(auth);
 
 	crypto_aead_set_reqsize(
 		tfm,
@@ -350,12 +321,10 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
-err_free_skcipher:
-	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
@@ -363,11 +332,10 @@ static void crypto_authenc_esn_exit_tfm(struct crypto_aead *tfm)
 {
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
 	crypto_free_skcipher(ctx->enc);
-	crypto_put_default_null_skcipher();
 }
 
 static void crypto_authenc_esn_free(struct aead_instance *inst)
 {
 	struct authenc_esn_instance_ctx *ctx = aead_instance_ctx(inst);
-- 
2.49.0

