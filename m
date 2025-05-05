Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFCF26F44E
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=lldPEDIo4XR1ZdDnGbWBX3SZvXss0jHckTowPqeU9rjX9QVxlkNiL0bMNmJ2ueQcsBCPuoGqlXbN1k+3QjXoAjMj4takS9Jm8pMJet5Lc9mQDUINwnkpNwCsbP9nGfL4MYke7rhH0M8C6o4TLput0dEWn5+btrtCaP+l2N493/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=1B6sDRX1WskvsadgsOPI+1LsNAsBz/m9k3PHvJzF4wc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iczndbc4a+Iogg/424AUhEI47Sm0KBwmypUKcV8qz5JZTX7UeHtfieb4cVHJMuCx76RrITxM0e8BmxRN2dNtOe/KBcmYqpYOQsPE1c8pEvttJRnS4Zm+Bt+SadR2t3hQlOfyP/1VVUVuIQux+b80CGhFTR+LL/R1s/0xHb/VhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3Zl2DMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3Zl2DMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B62C4CEEF
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=1B6sDRX1WskvsadgsOPI+1LsNAsBz/m9k3PHvJzF4wc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=I3Zl2DMBZxLLPU2bfVPHr0M8eIXEG/9gPOSGepC930PH5JOlCOMKd2XWpl8bDk5Xc
	 /lpuadMnTepqiP5l68X9IZzvt+YZcEO1cQWFglHUL6hYMUo5MGXxQqTlYkAQnuo2Qc
	 lI14QUFoGlm758UJldY6c6sgrrJXTpZFug6ZVH5NUP+EIanmfYRfyXzBuIk7jg0ST9
	 DPknC3u0Nk7hP7NqZfFSnlctANPoJuEeUFt9kjGpu4hXstkCF0m9AU0eeobEfuceOD
	 ww2OC5tiJ9bGzI1aeUVQ3xmy4I7baA/R6xSKBByx9octoW7ibB0Ay13BuppnmLDl46
	 k1A1yq6zfkhrg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 3/8] crypto: gcm - use memcpy_sglist() instead of null skcipher
Date: Mon,  5 May 2025 12:10:40 -0700
Message-ID: <20250505191045.763835-4-ebiggers@kernel.org>
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
 crypto/Kconfig |  1 -
 crypto/gcm.c   | 41 ++++-------------------------------------
 2 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 537602b8e60e..231791703594 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -803,11 +803,10 @@ config CRYPTO_CCM
 config CRYPTO_GCM
 	tristate "GCM (Galois/Counter Mode) and GMAC (GCM MAC)"
 	select CRYPTO_CTR
 	select CRYPTO_AEAD
 	select CRYPTO_GHASH
-	select CRYPTO_NULL
 	select CRYPTO_MANAGER
 	help
 	  GCM (Galois/Counter Mode) authenticated encryption mode and GMAC
 	  (GCM Message Authentication Code) (NIST SP800-38D)
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 54ca9faf0e0c..97716482bed0 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -7,11 +7,10 @@
 
 #include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
-#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/gcm.h>
 #include <crypto/hash.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -44,11 +43,10 @@ struct crypto_rfc4543_instance_ctx {
 	struct crypto_aead_spawn aead;
 };
 
 struct crypto_rfc4543_ctx {
 	struct crypto_aead *child;
-	struct crypto_sync_skcipher *null;
 	u8 nonce[4];
 };
 
 struct crypto_rfc4543_req_ctx {
 	struct aead_request subreq;
@@ -77,12 +75,10 @@ struct crypto_gcm_req_priv_ctx {
 static struct {
 	u8 buf[16];
 	struct scatterlist sg;
 } *gcm_zeroes;
 
-static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc);
-
 static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	struct aead_request *req)
 {
 	unsigned long align = crypto_aead_alignmask(crypto_aead_reqtfm(req));
 
@@ -928,16 +924,16 @@ static int crypto_rfc4543_crypt(struct aead_request *req, bool enc)
 	struct crypto_rfc4543_req_ctx *rctx = aead_request_ctx(req);
 	struct aead_request *subreq = &rctx->subreq;
 	unsigned int authsize = crypto_aead_authsize(aead);
 	u8 *iv = PTR_ALIGN((u8 *)(rctx + 1) + crypto_aead_reqsize(ctx->child),
 			   crypto_aead_alignmask(ctx->child) + 1);
-	int err;
 
 	if (req->src != req->dst) {
-		err = crypto_rfc4543_copy_src_to_dst(req, enc);
-		if (err)
-			return err;
+		unsigned int nbytes = req->assoclen + req->cryptlen -
+				      (enc ? 0 : authsize);
+
+		memcpy_sglist(req->dst, req->src, nbytes);
 	}
 
 	memcpy(iv, ctx->nonce, 4);
 	memcpy(iv + 4, req->iv, 8);
 
@@ -950,26 +946,10 @@ static int crypto_rfc4543_crypt(struct aead_request *req, bool enc)
 				    subreq->cryptlen);
 
 	return enc ? crypto_aead_encrypt(subreq) : crypto_aead_decrypt(subreq);
 }
 
-static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(aead);
-	unsigned int authsize = crypto_aead_authsize(aead);
-	unsigned int nbytes = req->assoclen + req->cryptlen -
-			      (enc ? 0 : authsize);
-	SYNC_SKCIPHER_REQUEST_ON_STACK(nreq, ctx->null);
-
-	skcipher_request_set_sync_tfm(nreq, ctx->null);
-	skcipher_request_set_callback(nreq, req->base.flags, NULL, NULL);
-	skcipher_request_set_crypt(nreq, req->src, req->dst, nbytes, NULL);
-
-	return crypto_skcipher_encrypt(nreq);
-}
-
 static int crypto_rfc4543_encrypt(struct aead_request *req)
 {
 	return crypto_ipsec_check_assoclen(req->assoclen) ?:
 	       crypto_rfc4543_crypt(req, true);
 }
@@ -985,47 +965,34 @@ static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct crypto_rfc4543_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_aead_spawn *spawn = &ictx->aead;
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *aead;
-	struct crypto_sync_skcipher *null;
 	unsigned long align;
-	int err = 0;
 
 	aead = crypto_spawn_aead(spawn);
 	if (IS_ERR(aead))
 		return PTR_ERR(aead);
 
-	null = crypto_get_default_null_skcipher();
-	err = PTR_ERR(null);
-	if (IS_ERR(null))
-		goto err_free_aead;
-
 	ctx->child = aead;
-	ctx->null = null;
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	crypto_aead_set_reqsize(
 		tfm,
 		sizeof(struct crypto_rfc4543_req_ctx) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
 		align + GCM_AES_IV_SIZE);
 
 	return 0;
-
-err_free_aead:
-	crypto_free_aead(aead);
-	return err;
 }
 
 static void crypto_rfc4543_exit_tfm(struct crypto_aead *tfm)
 {
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher();
 }
 
 static void crypto_rfc4543_free(struct aead_instance *inst)
 {
 	struct crypto_rfc4543_instance_ctx *ctx = aead_instance_ctx(inst);
-- 
2.49.0

