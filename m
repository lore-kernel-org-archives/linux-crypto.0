Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C7B389E07;
	Tue,  7 Jul 2026 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402642; cv=none; b=qqagQyBhaTsOuOy+ajsbPjq+iq04MPJerD6s4jJf2zDZYB2/ntqeEr1anhlgYJrux190OqSM0rMpcJupbsHvJNTKNfM0PAlU2Egkp1tT1vL3EKl9jrrZsQIxCrZhtiePl51q+p7lXazdz7CmEan38WterkqbwOIZfuxvHMqgIgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402642; c=relaxed/simple;
	bh=JUvxLnL9vpa1qoGMo/a2pWEPEBy/aCKnlVR2i8ABYMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlKbj31CTc3lgUj/91IRzK1jlG1kXlhh3OUTSO7yTlv8turqpEyoX3deIOalEOVQhJbW6n1tXUAXGUiAqhHb8eCY6gUGkB6zU966rDX2DoWjK1fpUieMffc7Y+6xW0JmnLdqOa4jmfb114MxBiezGjTqWfQ6QZ6P//0GoZFgCTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njl4289U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njl4289U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731A01F01559;
	Tue,  7 Jul 2026 05:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402640;
	bh=LbNafXAY5xfOmZmZ537LeD5hPSYzOYozluS3k1H6r8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njl4289UX0+Lx2Uf/1RtupR10DRfjK2S2wrJxgORsI9av/p1/C58tGOV7LeRdvLbm
	 AupC0dE+lcNmghkBnK1qQhyOe0JgYKSfiS3viY594cWQMW7PLcAuhZWv2ILgn8h+b1
	 0HwUatkzjKoKXF4ByHFcF+vrDu+qB13NAr4s4T+xk0FyMZr4KYcspewqJ3mncelfFB
	 8b+X5j+em9T565XVuZ1b7oDOcbyGVa/WTegwHlW59RzGjFMFWMJ8YJznuwHWtJsGXK
	 BNfWSUF5Le9N0g2I/HnPEmf/SIXQW5AYrOQpp1VRWbN0Z/Ed7qrYq78TrlMqLBO96E
	 Fe4Mwq1ZYc5iw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/33] crypto: aes - Remove AES-CBC-MAC support
Date: Mon,  6 Jul 2026 22:34:46 -0700
Message-ID: <20260707053503.209874-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"cbcmac(aes)" is used only by the "ccm" template when instantiated as
"ccm(aes)".  Since native "ccm(aes)" support has been added to
crypto/aes.c, the "cbcmac(aes)" crypto_shash is no longer needed.

Note that "cmac(aes)" and "xcbc(aes)" remain supported.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                       |  4 +-
 crypto/aes.c                         | 62 ----------------------------
 crypto/testmgr.c                     |  6 +--
 drivers/crypto/starfive/jh7110-aes.c |  2 +-
 4 files changed, 6 insertions(+), 68 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e6b894dc784a..83adbd54d725 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -359,14 +359,14 @@ config CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC || CRYPTO_CTS
-	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC
 	select CRYPTO_LIB_AES_CCM if CRYPTO_CCM
 	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR || CRYPTO_XCTR
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB
 	select CRYPTO_LIB_AES_GCM if CRYPTO_GCM
 	select CRYPTO_LIB_AES_XTS if CRYPTO_XTS
 	select CRYPTO_AEAD if CRYPTO_GCM || CRYPTO_CCM
-	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
 	# enabled, but that doesn't work due to a recursive dependency caused by
 	# CRYPTO_SKCIPHER selecting CRYPTO_ECB.  So just always select it.
diff --git a/crypto/aes.c b/crypto/aes.c
index ac5190292b3c..5f9c8eab67b4 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -95,47 +95,6 @@ static int __maybe_unused crypto_aes_cmac_digest(struct shash_desc *desc,
 	return 0;
 }
 
-#define AES_CBCMAC_KEY(tfm) ((struct aes_enckey *)crypto_shash_ctx(tfm))
-#define AES_CBCMAC_CTX(desc) ((struct aes_cbcmac_ctx *)shash_desc_ctx(desc))
-
-static int __maybe_unused crypto_aes_cbcmac_setkey(struct crypto_shash *tfm,
-						   const u8 *in_key,
-						   unsigned int key_len)
-{
-	return aes_prepareenckey(AES_CBCMAC_KEY(tfm), in_key, key_len);
-}
-
-static int __maybe_unused crypto_aes_cbcmac_init(struct shash_desc *desc)
-{
-	aes_cbcmac_init(AES_CBCMAC_CTX(desc), AES_CBCMAC_KEY(desc->tfm));
-	return 0;
-}
-
-static int __maybe_unused crypto_aes_cbcmac_update(struct shash_desc *desc,
-						   const u8 *data,
-						   unsigned int len)
-{
-	aes_cbcmac_update(AES_CBCMAC_CTX(desc), data, len);
-	return 0;
-}
-
-static int __maybe_unused crypto_aes_cbcmac_final(struct shash_desc *desc,
-						  u8 *out)
-{
-	aes_cbcmac_final(AES_CBCMAC_CTX(desc), out);
-	return 0;
-}
-
-static int __maybe_unused crypto_aes_cbcmac_digest(struct shash_desc *desc,
-						   const u8 *data,
-						   unsigned int len, u8 *out)
-{
-	aes_cbcmac_init(AES_CBCMAC_CTX(desc), AES_CBCMAC_KEY(desc->tfm));
-	aes_cbcmac_update(AES_CBCMAC_CTX(desc), data, len);
-	aes_cbcmac_final(AES_CBCMAC_CTX(desc), out);
-	return 0;
-}
-
 static struct crypto_alg alg = {
 	.cra_name = "aes",
 	.cra_driver_name = "aes-lib",
@@ -190,23 +149,6 @@ static struct shash_alg mac_algs[] = {
 		.descsize = sizeof(struct aes_cmac_ctx),
 	},
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_CCM)
-	{
-		.base.cra_name = "cbcmac(aes)",
-		.base.cra_driver_name = "cbcmac-aes-lib",
-		.base.cra_priority = 300,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct aes_enckey),
-		.base.cra_module = THIS_MODULE,
-		.digestsize = AES_BLOCK_SIZE,
-		.setkey = crypto_aes_cbcmac_setkey,
-		.init = crypto_aes_cbcmac_init,
-		.update = crypto_aes_cbcmac_update,
-		.final = crypto_aes_cbcmac_final,
-		.digest = crypto_aes_cbcmac_digest,
-		.descsize = sizeof(struct aes_cbcmac_ctx),
-	},
-#endif
 };
 
 static __maybe_unused int
@@ -1096,10 +1038,6 @@ MODULE_ALIAS_CRYPTO("cmac-aes-lib");
 MODULE_ALIAS_CRYPTO("xcbc(aes)");
 MODULE_ALIAS_CRYPTO("xcbc-aes-lib");
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_CCM)
-MODULE_ALIAS_CRYPTO("cbcmac(aes)");
-MODULE_ALIAS_CRYPTO("cbcmac-aes-lib");
-#endif
 #if IS_ENABLED(CONFIG_CRYPTO_ECB)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("ecb-aes-lib");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4958211fbfa9..b25c15173c76 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4421,7 +4421,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #endif
 		.alg = "cbcmac(aes)",
-		.generic_driver = "cbcmac-aes-lib",
+		.generic_driver = "cbcmac(aes-lib)",
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(aes_cbcmac_tv_template)
@@ -4434,7 +4434,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ccm(aes)",
-		.generic_driver = "ccm_base(ctr(aes-lib),cbcmac-aes-lib)",
+		.generic_driver = "ccm_base(ctr(aes-lib),cbcmac(aes-lib))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -5239,7 +5239,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rfc4309(ccm(aes))",
-		.generic_driver = "rfc4309(ccm_base(ctr(aes-lib),cbcmac-aes-lib))",
+		.generic_driver = "rfc4309(ccm_base(ctr(aes-lib),cbcmac(aes-lib)))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index a0713aa21250..c591a850f093 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -1003,7 +1003,7 @@ static int starfive_aes_ctr_init_tfm(struct crypto_skcipher *tfm)
 
 static int starfive_aes_ccm_init_tfm(struct crypto_aead *tfm)
 {
-	return starfive_aes_aead_init_tfm(tfm, "ccm_base(ctr(aes-lib),cbcmac-aes-lib)");
+	return starfive_aes_aead_init_tfm(tfm, "ccm_base(ctr(aes-lib),cbcmac(aes-lib))");
 }
 
 static int starfive_aes_gcm_init_tfm(struct crypto_aead *tfm)
-- 
2.54.0

