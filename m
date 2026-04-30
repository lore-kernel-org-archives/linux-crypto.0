Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BA2378803;
	Thu, 30 Apr 2026 06:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530584; cv=none; b=V6ldct7WSCqOSSFgn/+rVWQqAcWa72PeXUd08IctAabLpy4BCCeUxSkT+tI1DpnZ7Y3eXS99rECcMIYBtb8JgHePn4gv6Xvch9janMlLeT1OrbT2Jd9s6orBTr4d+4mAHwJZFidN85g/BadtDQ8pvXbQSgMYgnTVgD0uD3L7Uuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530584; c=relaxed/simple;
	bh=nKHFkgJHOsS0PfL7xM8SEXj5ouXwvmwr/zfBfAOhI2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVEq9KB6tZWW88wq3YWDPMomWSM8Mr4728qJFrWanhpLOyPn1YX1pl3x/J4zTDHrbez4Ww8hKCgw91heaPh+1E1R9tVHIv6nGHKVtaAQLG7y1BJjDTlMzp2iKLn07gGJIKAIxFcZrDGliw+s2maZmqdlskRfoPc5Fr7Sm6/1k9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEMqBzB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEMqBzB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436EC2BCC9;
	Thu, 30 Apr 2026 06:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530583;
	bh=nKHFkgJHOsS0PfL7xM8SEXj5ouXwvmwr/zfBfAOhI2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEMqBzB4f3Wtggea35wM0s8AD60YkZj4oLq1ZA4SUBP8IUE0c/2yt44BJ3PQJVgdA
	 4Q9jvOIDwrxgeZx93XJ57/1ec1K9tBMFeytvToxc4eglOIYXOR7xDDXMv6iVOfcoPK
	 BXXU9RsHBw4nSbsvbKmfJidgd5WXuZkG2D5eq+xocqEWjePOLw6huHbarNQ22BXl+N
	 qNnCLhdY1NZt2wO7TWJJc6v/pVDI8Lj+sNp0x/p/qoFUxeeB1SUNNyMIDIxtvhlQo0
	 ZeNAiHtn94hjdRE8R8dCN4GFZwlfNPdleGPED2D50TDnh7AE7rDRq6NHV5cOdqiMrp
	 rkqAocFKaeYHA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@google.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 5/9] crypto: authenc - use memcpy_sglist() instead of null skcipher
Date: Wed, 29 Apr 2026 23:27:27 -0700
Message-ID: <20260430062731.140497-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430062731.140497-1-ebiggers@kernel.org>
References: <20260430062731.140497-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit dbc4b1458e931e47198c3165ff5853bc1ad6bd7a upstream.

For copying data between two scatterlists, just use memcpy_sglist()
instead of the so-called "null skcipher".  This is much simpler.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig      |  1 -
 crypto/authenc.c    | 32 +-------------------------------
 crypto/authencesn.c | 38 +++-----------------------------------
 3 files changed, 4 insertions(+), 67 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 649619df922c..2e2978e2939f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -214,11 +214,10 @@ config CRYPTO_AUTHENC
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
index 17f674a7cdff..2b402e764529 100644
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
@@ -172,25 +170,10 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 
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
@@ -205,14 +188,11 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 
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
@@ -309,11 +289,10 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
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
@@ -321,18 +300,12 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
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
@@ -342,12 +315,10 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
-err_free_skcipher:
-	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
@@ -355,11 +326,10 @@ static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
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
index 6487b35851d5..fceee6d67d34 100644
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
@@ -162,24 +160,10 @@ static void crypto_authenc_esn_encrypt_done(struct crypto_async_request *req,
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
@@ -197,14 +181,11 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
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
@@ -290,15 +271,12 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	if (assoclen < 8)
 		return -EINVAL;
 
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
@@ -330,11 +308,10 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
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
@@ -342,18 +319,12 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
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
 
 	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth),
 			    crypto_ahash_alignmask(auth) + 1);
 
 	crypto_aead_set_reqsize(
@@ -366,12 +337,10 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 		      sizeof(struct skcipher_request) +
 		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
-err_free_skcipher:
-	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
 }
 
@@ -379,11 +348,10 @@ static void crypto_authenc_esn_exit_tfm(struct crypto_aead *tfm)
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
2.54.0

