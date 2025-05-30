Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8D2235079;
	Fri, 30 May 2025 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621531; cv=none; b=BEFG24PauOgb8wFOvVXGC5HoziFpvqADCtF5qewy539BMyeNwgChVZtZZXQsGdiKi8O7RvZ/gIuoF6iVwNPSSs2yMOtNYA2faKti+hfZf0NRaPrSALOIhbH0mct4x/rNdAIaBiKvHIDv0J85gqhOuGbKLJSEsum8jQkE2QoKNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621531; c=relaxed/simple;
	bh=Z7hYRToBzVndugVw9/+VL1oIDvZ/G481tYi7Xm5XtUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dnHrdQ4hxGlcQ5V6g7McHVNL8K4TgYnFfyr2qCDoDP3snS8I8Pf/Cms2bQCBQEGfCg5xa/GgdfXHrg0l6x6+QwulhpjDA5plL/Rqu0SCmvynq56BE8v41pyATIJcyCOdld4hOJF1Ct1duVKefxVY4Y1HMRoN9C+qYM0RoLj5nOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmVzKZei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmVzKZei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F50AC4CEE9;
	Fri, 30 May 2025 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748621530;
	bh=Z7hYRToBzVndugVw9/+VL1oIDvZ/G481tYi7Xm5XtUw=;
	h=From:To:Cc:Subject:Date:From;
	b=VmVzKZeioeqaHpjIhbGPFl5Vfs4b4wDFUxHMnpf9qmBaVUAe1Ei+dxIhB80qmZxZP
	 b2EUuibXcVdoxa7/QqrA+MrPEfmCSOWxBvDq2Ujudd1rP1/Q+iM3eE0lbDVSlAButU
	 Yk41dX94rrDXLbpl2WIbMW52IIb0usKL2rnStsZIPUIM3tbLv5crN0YY4NvWReLLeP
	 bFj914ylOovL2Wc5HiWCg6p6obELgB8WnJFPMsbvNf5Pc6asIBl6NsAyluUJTVSbCU
	 /ZWJyESI3BWrdrfddgfHgrO5Urs8vQFmW14I6ZDYf++BOaHOaloiugciw4CVVv42KL
	 Lzghx6VtbBOhg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto/crc32c: register only one shash_alg
Date: Fri, 30 May 2025 09:10:42 -0700
Message-ID: <20250530161042.13106-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Stop unnecessarily registering a "crc32c-generic" shash_alg when a
"crc32c-$(ARCH)" shash_alg is registered too.

While every algorithm does need to have a generic implementation to
ensure uniformity of support across platforms, that doesn't mean that we
need to make the generic implementation available through crypto_shash
when an optimized implementation is also available.

Registering the generic shash_alg did allow users of the crypto_shash or
crypto_ahash APIs to request the generic implementation specifically,
instead of an optimized one.  However, the only known use case for that
was the differential fuzz tests in crypto/testmgr.c.  Equivalent test
coverage is now provided by crc_kunit.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this through the crc tree.

 crypto/crc32c.c | 70 +++++++------------------------------------------
 1 file changed, 10 insertions(+), 60 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index e5377898414a2..e160695682f16 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -83,19 +83,10 @@ static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 static int chksum_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int length)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	ctx->crc = crc32c_base(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_update_arch(struct shash_desc *desc, const u8 *data,
-			      unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
 	ctx->crc = crc32c(ctx->crc, data, length);
 	return 0;
 }
 
 static int chksum_final(struct shash_desc *desc, u8 *out)
@@ -105,17 +96,10 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 	put_unaligned_le32(~ctx->crc, out);
 	return 0;
 }
 
 static int __chksum_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
-{
-	put_unaligned_le32(~crc32c_base(*crcp, data, len), out);
-	return 0;
-}
-
-static int __chksum_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
-			       u8 *out)
 {
 	put_unaligned_le32(~crc32c(*crcp, data, len), out);
 	return 0;
 }
 
@@ -125,98 +109,64 @@ static int chksum_finup(struct shash_desc *desc, const u8 *data,
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
 	return __chksum_finup(&ctx->crc, data, len, out);
 }
 
-static int chksum_finup_arch(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup_arch(&ctx->crc, data, len, out);
-}
-
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
 	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
 
 	return __chksum_finup(&mctx->key, data, length, out);
 }
 
-static int chksum_digest_arch(struct shash_desc *desc, const u8 *data,
-			      unsigned int length, u8 *out)
-{
-	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
-
-	return __chksum_finup_arch(&mctx->key, data, length, out);
-}
-
 static int crc32c_cra_init(struct crypto_tfm *tfm)
 {
 	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
 
 	mctx->key = ~0;
 	return 0;
 }
 
-static struct shash_alg algs[] = {{
+static struct shash_alg alg = {
 	.digestsize		= CHKSUM_DIGEST_SIZE,
 	.setkey			= chksum_setkey,
 	.init			= chksum_init,
 	.update			= chksum_update,
 	.final			= chksum_final,
 	.finup			= chksum_finup,
 	.digest			= chksum_digest,
 	.descsize		= sizeof(struct chksum_desc_ctx),
 
 	.base.cra_name		= "crc32c",
-	.base.cra_driver_name	= "crc32c-generic",
 	.base.cra_priority	= 100,
 	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct chksum_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_init		= crc32c_cra_init,
-}, {
-	.digestsize		= CHKSUM_DIGEST_SIZE,
-	.setkey			= chksum_setkey,
-	.init			= chksum_init,
-	.update			= chksum_update_arch,
-	.final			= chksum_final,
-	.finup			= chksum_finup_arch,
-	.digest			= chksum_digest_arch,
-	.descsize		= sizeof(struct chksum_desc_ctx),
-
-	.base.cra_name		= "crc32c",
-	.base.cra_driver_name	= "crc32c-" __stringify(ARCH),
-	.base.cra_priority	= 150,
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct chksum_ctx),
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_init		= crc32c_cra_init,
-}};
-
-static int num_algs;
+};
 
 static int __init crc32c_mod_init(void)
 {
-	/* register the arch flavor only if it differs from the generic one */
-	num_algs = 1 + ((crc32_optimizations() & CRC32C_OPTIMIZATION) != 0);
+	const char *driver_name =
+		(crc32_optimizations() & CRC32C_OPTIMIZATION) ?
+			"crc32c-" __stringify(ARCH) :
+			"crc32c-generic";
+
+	strscpy(alg.base.cra_driver_name, driver_name, CRYPTO_MAX_ALG_NAME);
 
-	return crypto_register_shashes(algs, num_algs);
+	return crypto_register_shash(&alg);
 }
 
 static void __exit crc32c_mod_fini(void)
 {
-	crypto_unregister_shashes(algs, num_algs);
+	crypto_unregister_shash(&alg);
 }
 
 module_init(crc32c_mod_init);
 module_exit(crc32c_mod_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("crc32c");
-MODULE_ALIAS_CRYPTO("crc32c-generic");

base-commit: f66bc387efbee59978e076ce9bf123ac353b389c
-- 
2.49.0

