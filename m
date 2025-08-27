Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FE819FA8D;
	Wed, 27 Aug 2025 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307697; cv=none; b=D2JCD/+WKId4PUo9jdYovCWHiQOyCPFiq8acaupCyMSOaywN6tpLxXBautB4CgVdAGoqdT4NU+lW3ItzfopyEsxUhfQy5L1EyVRUG7h8Xz22PAnhXUHEUdCjwnkE83p+FQkI5fcn/sBpKBYaXyjEGcYGpm3xuXn/87aE0YejqGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307697; c=relaxed/simple;
	bh=PEnNNwlelyhooGpaIQRTUv9wqpiqewuv20VIflQJ328=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0TwcLCWTuwODxWmWjPKip755dNUyq1sV5rzU2jDbl+EDlZr+KXayUKDcwkeMHhJygcEST7w3vDJ4g+eh/a+EqhBF/BhXSd63uVBRv0zpQa2nG+fCl0wK9oXDLxMXja37ElWRdsOi9Nhm/+wGTzezT7oesL+6mJHccTD40JbStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw1oT9XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw1oT9XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9775C4CEEB;
	Wed, 27 Aug 2025 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307697;
	bh=PEnNNwlelyhooGpaIQRTUv9wqpiqewuv20VIflQJ328=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw1oT9XENhcz7u6XoUZEjoyKNpmTN0wpPnqCQgNrdP03++iYsKgS3ZO4FwWNjtlv7
	 ZR5x8pCRO4Np+NJIvYMhYz9DkKgqx072wkoHkOrq3OyTuuPywHFTBV4cNCoctC9Ctj
	 lrkrd9tmpY830S0ADI1W4XSvoxC/DiQei8EZxhIFo2dOiShiOIekxbvPhihyU1BeYc
	 anb0SLcI5iKJUgvKuf1GaCtHnUdxdaq5TO0W5m1IdUqcogWuA3xRy+71wuuqEP7/Ie
	 +d+91fgr7m36K1+Knm0y1ecAfiik95v/0hsj/L8RGKnb4Fuoxzdki+MjJmfaCv1pll
	 Y9YC9cjJsRQQg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/12] crypto: chacha - register only "-lib" drivers
Date: Wed, 27 Aug 2025 08:11:21 -0700
Message-ID: <20250827151131.27733-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the "chacha20", "xchacha20", and "xchacha12" skcipher algorithms,
instead of registering "*-generic" drivers as well as conditionally
registering "*-$(ARCH)" drivers, instead just register "*-lib" drivers.
These just use the regular library functions, so they just do the right
thing and are fully accelerated when supported by the CPU.

This eliminates the need for the ChaCha library to support
chacha_crypt_generic() and hchacha_block_generic() as part of its
external interface.  A later commit will make chacha_crypt_generic() a
static function.

Since this commit removes several "*-generic" driver names which
crypto/testmgr.c expects to exist, update testmgr.c accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig   |   1 -
 crypto/chacha.c  | 129 ++++++++---------------------------------------
 crypto/testmgr.c |   9 +++-
 3 files changed, 29 insertions(+), 110 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e8ccf5f51b855..09e8fb6ee0813 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -646,11 +646,10 @@ config CRYPTO_ARC4
 	  weakness of the algorithm.
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha"
 	select CRYPTO_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_SKCIPHER
 	help
 	  The ChaCha20, XChaCha20, and XChaCha12 stream cipher algorithms
 
 	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
diff --git a/crypto/chacha.c b/crypto/chacha.c
index c3a11f4e2d13d..ec16d5a33f3cd 100644
--- a/crypto/chacha.c
+++ b/crypto/chacha.c
@@ -45,11 +45,11 @@ static int chacha12_setkey(struct crypto_skcipher *tfm,
 	return chacha_setkey(tfm, key, keysize, 12);
 }
 
 static int chacha_stream_xor(struct skcipher_request *req,
 			     const struct chacha_ctx *ctx,
-			     const u8 iv[CHACHA_IV_SIZE], bool arch)
+			     const u8 iv[CHACHA_IV_SIZE])
 {
 	struct skcipher_walk walk;
 	struct chacha_state state;
 	int err;
 
@@ -61,200 +61,115 @@ static int chacha_stream_xor(struct skcipher_request *req,
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
 
-		if (arch)
-			chacha_crypt(&state, walk.dst.virt.addr,
-				     walk.src.virt.addr, nbytes, ctx->nrounds);
-		else
-			chacha_crypt_generic(&state, walk.dst.virt.addr,
-					     walk.src.virt.addr, nbytes,
-					     ctx->nrounds);
+		chacha_crypt(&state, walk.dst.virt.addr, walk.src.virt.addr,
+			     nbytes, ctx->nrounds);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
 }
 
-static int crypto_chacha_crypt_generic(struct skcipher_request *req)
+static int crypto_chacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_stream_xor(req, ctx, req->iv, false);
+	return chacha_stream_xor(req, ctx, req->iv);
 }
 
-static int crypto_chacha_crypt_arch(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return chacha_stream_xor(req, ctx, req->iv, true);
-}
-
-static int crypto_xchacha_crypt(struct skcipher_request *req, bool arch)
+static int crypto_xchacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct chacha_ctx subctx;
 	struct chacha_state state;
 	u8 real_iv[16];
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
 	chacha_init(&state, ctx->key, req->iv);
-	if (arch)
-		hchacha_block(&state, subctx.key, ctx->nrounds);
-	else
-		hchacha_block_generic(&state, subctx.key, ctx->nrounds);
+	hchacha_block(&state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	/* Build the real IV */
 	memcpy(&real_iv[0], req->iv + 24, 8); /* stream position */
 	memcpy(&real_iv[8], req->iv + 16, 8); /* remaining 64 nonce bits */
 
 	/* Generate the stream and XOR it with the data */
-	return chacha_stream_xor(req, &subctx, real_iv, arch);
-}
-
-static int crypto_xchacha_crypt_generic(struct skcipher_request *req)
-{
-	return crypto_xchacha_crypt(req, false);
-}
-
-static int crypto_xchacha_crypt_arch(struct skcipher_request *req)
-{
-	return crypto_xchacha_crypt(req, true);
+	return chacha_stream_xor(req, &subctx, real_iv);
 }
 
 static struct skcipher_alg algs[] = {
 	{
 		.base.cra_name		= "chacha20",
-		.base.cra_driver_name	= "chacha20-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= CHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_chacha_crypt_generic,
-		.decrypt		= crypto_chacha_crypt_generic,
-	},
-	{
-		.base.cra_name		= "xchacha20",
-		.base.cra_driver_name	= "xchacha20-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_xchacha_crypt_generic,
-		.decrypt		= crypto_xchacha_crypt_generic,
-	},
-	{
-		.base.cra_name		= "xchacha12",
-		.base.cra_driver_name	= "xchacha12-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha12_setkey,
-		.encrypt		= crypto_xchacha_crypt_generic,
-		.decrypt		= crypto_xchacha_crypt_generic,
-	},
-	{
-		.base.cra_name		= "chacha20",
-		.base.cra_driver_name	= "chacha20-" __stringify(ARCH),
+		.base.cra_driver_name	= "chacha20-lib",
 		.base.cra_priority	= 300,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
 		.base.cra_module	= THIS_MODULE,
 
 		.min_keysize		= CHACHA_KEY_SIZE,
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_chacha_crypt_arch,
-		.decrypt		= crypto_chacha_crypt_arch,
+		.encrypt		= crypto_chacha_crypt,
+		.decrypt		= crypto_chacha_crypt,
 	},
 	{
 		.base.cra_name		= "xchacha20",
-		.base.cra_driver_name	= "xchacha20-" __stringify(ARCH),
+		.base.cra_driver_name	= "xchacha20-lib",
 		.base.cra_priority	= 300,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
 		.base.cra_module	= THIS_MODULE,
 
 		.min_keysize		= CHACHA_KEY_SIZE,
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_xchacha_crypt_arch,
-		.decrypt		= crypto_xchacha_crypt_arch,
+		.encrypt		= crypto_xchacha_crypt,
+		.decrypt		= crypto_xchacha_crypt,
 	},
 	{
 		.base.cra_name		= "xchacha12",
-		.base.cra_driver_name	= "xchacha12-" __stringify(ARCH),
+		.base.cra_driver_name	= "xchacha12-lib",
 		.base.cra_priority	= 300,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
 		.base.cra_module	= THIS_MODULE,
 
 		.min_keysize		= CHACHA_KEY_SIZE,
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.setkey			= chacha12_setkey,
-		.encrypt		= crypto_xchacha_crypt_arch,
-		.decrypt		= crypto_xchacha_crypt_arch,
+		.encrypt		= crypto_xchacha_crypt,
+		.decrypt		= crypto_xchacha_crypt,
 	}
 };
 
-static unsigned int num_algs;
-
 static int __init crypto_chacha_mod_init(void)
 {
-	/* register the arch flavours only if they differ from generic */
-	num_algs = ARRAY_SIZE(algs);
-	BUILD_BUG_ON(ARRAY_SIZE(algs) % 2 != 0);
-	if (!chacha_is_arch_optimized())
-		num_algs /= 2;
-
-	return crypto_register_skciphers(algs, num_algs);
+	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit crypto_chacha_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, num_algs);
+	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(crypto_chacha_mod_init);
 module_exit(crypto_chacha_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("Crypto API wrappers for the ChaCha20, XChaCha20, and XChaCha12 stream ciphers");
 MODULE_ALIAS_CRYPTO("chacha20");
-MODULE_ALIAS_CRYPTO("chacha20-generic");
-MODULE_ALIAS_CRYPTO("chacha20-"  __stringify(ARCH));
+MODULE_ALIAS_CRYPTO("chacha20-lib");
 MODULE_ALIAS_CRYPTO("xchacha20");
-MODULE_ALIAS_CRYPTO("xchacha20-generic");
-MODULE_ALIAS_CRYPTO("xchacha20-"  __stringify(ARCH));
+MODULE_ALIAS_CRYPTO("xchacha20-lib");
 MODULE_ALIAS_CRYPTO("xchacha12");
-MODULE_ALIAS_CRYPTO("xchacha12-generic");
-MODULE_ALIAS_CRYPTO("xchacha12-"  __stringify(ARCH));
+MODULE_ALIAS_CRYPTO("xchacha12-lib");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index beab926ba102e..781445f5f56a6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4150,18 +4150,18 @@ static int alg_test_null(const struct alg_test_desc *desc,
 
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "adiantum(xchacha12,aes)",
-		.generic_driver = "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)",
+		.generic_driver = "adiantum(xchacha12-lib,aes-generic,nhpoly1305-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha12_aes_tv_template)
 		},
 	}, {
 		.alg = "adiantum(xchacha20,aes)",
-		.generic_driver = "adiantum(xchacha20-generic,aes-generic,nhpoly1305-generic)",
+		.generic_driver = "adiantum(xchacha20-lib,aes-generic,nhpoly1305-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha20_aes_tv_template)
 		},
 	}, {
@@ -4483,10 +4483,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.einval_allowed = 1,
 			}
 		}
 	}, {
 		.alg = "chacha20",
+		.generic_driver = "chacha20-lib",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(chacha20_tv_template)
 		},
 	}, {
@@ -5418,16 +5419,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.aad_iv = 1,
 			}
 		}
 	}, {
 		.alg = "rfc7539(chacha20,poly1305)",
+		.generic_driver = "rfc7539(chacha20-lib,poly1305-generic)",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(rfc7539_tv_template)
 		}
 	}, {
 		.alg = "rfc7539esp(chacha20,poly1305)",
+		.generic_driver = "rfc7539esp(chacha20-lib,poly1305-generic)",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
 				____VECS(rfc7539esp_tv_template),
 				.einval_allowed = 1,
@@ -5589,16 +5592,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(sm4_xcbc128_tv_template)
 		}
 	}, {
 		.alg = "xchacha12",
+		.generic_driver = "xchacha12-lib",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(xchacha12_tv_template)
 		},
 	}, {
 		.alg = "xchacha20",
+		.generic_driver = "xchacha20-lib",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(xchacha20_tv_template)
 		},
 	}, {
-- 
2.50.1

