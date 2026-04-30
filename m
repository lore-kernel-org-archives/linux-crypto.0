Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96F394462;
	Thu, 30 Apr 2026 07:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532612; cv=none; b=t3TsCTKOtmWrZvnTtvrFAdCDnOonpfI86MARkYeCKmBDjNohLOrZa/et3LQdRT32yh+6ReEsn+IZaYriuPMK2XNU3difjlJ9747ucveht/oPAu9y1brOE1NGsW3zBhEIGzfr9nMLuV9SlXgHg2DQkr5GtqLcf67guSP38G/pWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532612; c=relaxed/simple;
	bh=HwUf+7C8QCp+3ijvjxi+KC4J4mj0yHMZ6ob9jF7Zudk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0AT7rr0uUACh8/4FhNfyVFSRpWjlWHl7NZQDGvUMkK7NyfwWcMmZ9KinOOXVoGUs59fMAEN97gd58jMlqO1odfLznwtBYV0/ZkfiprPxeaJG5cu/7xLDXJ4p/OIzN96/8o00URwmEYB4UIwkRGrYd881Dvar7YWhPjan9Oe7eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4pD+JOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4pD+JOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B05BC2BCB3;
	Thu, 30 Apr 2026 07:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532612;
	bh=HwUf+7C8QCp+3ijvjxi+KC4J4mj0yHMZ6ob9jF7Zudk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4pD+JOsMfZO4X3vfdJ8eLA1ds32P5D+kmFMpiXA/fKJR1O+eT5Brmaw74HeiDYMQ
	 JbswwRPJ7JYdm8IIKht7Hu492P/rFwuKgWQaZfbAVhKA7ZvPbjA5QeqNLaBvEZlGMh
	 9ZMmqTsJiFqAJ54NK5maCBE4yEfruscSOdIRryNlyBqOKyozPBJpGeb5SyTg+grAr4
	 h19UU/L2Xza7MZseNgbfv9yY6NcJBTZS53/7mbHv8qkIWEYmqCeThA8pd4j72T/hIU
	 G2/GIGKnETyQLEF0tDirISs6ZVt1SI3hq+mijXwsKCRVfqi68hwbeK/yNGROEXFYkz
	 SCL/83sQE50Yg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@google.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 06/10] crypto: authenc - use memcpy_sglist() instead of null skcipher
Date: Thu, 30 Apr 2026 00:01:24 -0700
Message-ID: <20260430070128.219863-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
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
index c83f23fcc940..a5673a31bfeb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -193,11 +193,10 @@ config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
-	select CRYPTO_NULL
 	help
 	  Authenc: Combined mode wrapper for IPsec.
 	  This is required for IPSec.
 
 config CRYPTO_TEST
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

