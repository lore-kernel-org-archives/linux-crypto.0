Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5131387345;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402640; cv=none; b=OSP240W71AOwUQD6nvNH6QPv1LZRLVkGkFQnqAP+8rJH2APc0fLKVDMXywbT9LyOhvEqsw7AzjOJdfvdSRP82T4IncCY7qxTjFj8hmWS9qyD/AUxsgWTGvmV04pc1ayR2fTsMvh+zTQiinjOhgPCocl4J7wYzmaNRSlA/d1X0+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402640; c=relaxed/simple;
	bh=iyxFAOeYnJERj1OfShiy4wylnXTWTSFO1tOVxzhC47E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tL43y5OlOpXYmJqcgzOgvCwTxrVnjv3PnQLGVQc7PqEPnbXu4snHonR52w6fNezx/+x1hckvVDH4x9gKZ8HsVvRRJbZM0QvzxVbHVxNUt6a3mk+JFsg21ifKd9Kk+gdmIEpo9cFi3F176XKwhc+MBVm3xpdsznVnDFT/2Wqm3mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeZ0ISKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeZ0ISKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE491F00A3D;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402638;
	bh=1zBf59V02+A04DvUuUwIOWOouXgCZSmIL8o4smli37E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KeZ0ISKUdyMlGAgn75zfeRRjiSSPMRWVOvWIn9ojURaiTnr5Dr4qPecgV+ebwsfio
	 LX2sdHHTMvxcximzPsWmHYEMbn7dWWvqBHvVTSZ0PNIZBWUAaPxp/O7pNt6x8QTsi5
	 K8xRIUBzmaLcXe2aZJa7zIPGAXSFtp1eGmxgh4C8V5YAzTS3ws0srZTIS2UBsA9ycp
	 XqieD3GiFUqJT0jaFsdkhiC0aE0W7tAJNOABxR3s+Lbx8xtRG4qHkx3aDadzUmOKfS
	 RWUL0xkVoR+B1il2usagntp/8gaIBQnwlccuu04BKdIqKlK9fYJD4qMS6Ia8C1Ussg
	 HjIh720Eexieg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/33] crypto: aes - Add CBC and CBC-CTS support using library
Date: Mon,  6 Jul 2026 22:34:39 -0700
Message-ID: <20260707053503.209874-10-ebiggers@kernel.org>
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

Implement the "cbc(aes)" and "cts(cbc(aes))" crypto_skcipher algorithms
using the corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-CBC and
AES-CBC-CTS code to be migrated into the library while still leaving it
accessible via crypto_skcipher, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of these algorithms haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   1 +
 crypto/aes.c   | 163 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 093508d13b8c..3d30d79878c2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -358,6 +358,7 @@ config CRYPTO_AES
 	tristate "AES (Advanced Encryption Standard)"
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC || CRYPTO_CTS
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB
 	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
diff --git a/crypto/aes.c b/crypto/aes.c
index 162715a82be3..5999f8117ce7 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-cbc.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -328,6 +329,128 @@ static __maybe_unused int crypto_aes_ecb_decrypt(struct skcipher_request *req)
 	return 0;
 }
 
+/* AES-CBC */
+
+static void crypto_aes_cbc_encrypt_sg(struct scatterlist *dst,
+				      struct scatterlist *src,
+				      unsigned int cryptlen,
+				      u8 iv[AES_BLOCK_SIZE],
+				      const struct aes_key *key)
+{
+	AES_CRYPT_SG(aes_cbc_encrypt, dst, src, cryptlen, 0, iv, key);
+}
+
+static void crypto_aes_cbc_decrypt_sg(struct scatterlist *dst,
+				      struct scatterlist *src,
+				      unsigned int cryptlen,
+				      u8 iv[AES_BLOCK_SIZE],
+				      const struct aes_key *key)
+{
+	AES_CRYPT_SG(aes_cbc_decrypt, dst, src, cryptlen, 0, iv, key);
+}
+
+static __maybe_unused int crypto_aes_cbc_encrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	crypto_aes_cbc_encrypt_sg(req->dst, req->src, req->cryptlen, req->iv,
+				  key);
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_cbc_decrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	crypto_aes_cbc_decrypt_sg(req->dst, req->src, req->cryptlen, req->iv,
+				  key);
+	return 0;
+}
+
+/* AES-CBC-CTS */
+
+static noinline int
+crypto_aes_cbc_cts_crypt_nonlinear(struct skcipher_request *req, bool enc)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	unsigned int main_len = req->cryptlen;
+	unsigned int tail_len =
+		((main_len - 1) % AES_BLOCK_SIZE) + 1 + AES_BLOCK_SIZE;
+	u8 tmp[2 * AES_BLOCK_SIZE] __aligned(__alignof__(long));
+
+	if (main_len == AES_BLOCK_SIZE) {
+		/* Single block is a special case that just does CBC. */
+		if (enc)
+			crypto_aes_cbc_encrypt_sg(req->dst, req->src, main_len,
+						  req->iv, key);
+		else
+			crypto_aes_cbc_decrypt_sg(req->dst, req->src, main_len,
+						  req->iv, key);
+		return 0;
+	}
+	/* Just do the last two blocks separately. */
+	main_len -= tail_len;
+	if (enc)
+		crypto_aes_cbc_encrypt_sg(req->dst, req->src, main_len, req->iv,
+					  key);
+	else
+		crypto_aes_cbc_decrypt_sg(req->dst, req->src, main_len, req->iv,
+					  key);
+	memcpy_from_sglist(tmp, req->src, main_len, tail_len);
+	if (enc)
+		aes_cbc_cts_encrypt(tmp, tmp, tail_len, req->iv, key);
+	else
+		aes_cbc_cts_decrypt(tmp, tmp, tail_len, req->iv, key);
+	memcpy_to_sglist(req->dst, main_len, tmp, tail_len);
+	memzero_explicit(tmp, sizeof(tmp));
+	return 0;
+}
+
+static __maybe_unused int
+crypto_aes_cbc_cts_encrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (!IS_ENABLED(CONFIG_HIGHMEM) &&
+	    likely(req->src->length >= req->cryptlen &&
+		   req->dst->length >= req->cryptlen)) {
+		/* Fast path */
+		aes_cbc_cts_encrypt(sg_virt(req->dst), sg_virt(req->src),
+				    req->cryptlen, req->iv, key);
+		return 0;
+	}
+	return crypto_aes_cbc_cts_crypt_nonlinear(req, /* enc= */ true);
+}
+
+static __maybe_unused int
+crypto_aes_cbc_cts_decrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (!IS_ENABLED(CONFIG_HIGHMEM) &&
+	    likely(req->src->length >= req->cryptlen &&
+		   req->dst->length >= req->cryptlen)) {
+		/* Fast path */
+		aes_cbc_cts_decrypt(sg_virt(req->dst), sg_virt(req->src),
+				    req->cryptlen, req->iv, key);
+		return 0;
+	}
+	return crypto_aes_cbc_cts_crypt_nonlinear(req, /* enc= */ false);
+}
+
 static struct skcipher_alg skcipher_algs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_ECB)
 	{
@@ -344,6 +467,38 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_ecb_decrypt,
 	},
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CBC)
+	{
+		.base.cra_name = "cbc(aes)",
+		.base.cra_driver_name = "cbc-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setkey,
+		.encrypt = crypto_aes_cbc_encrypt,
+		.decrypt = crypto_aes_cbc_decrypt,
+	},
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+	{
+		.base.cra_name = "cts(cbc(aes))",
+		.base.cra_driver_name = "cts-cbc-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_skcipher_setkey,
+		.encrypt = crypto_aes_cbc_cts_encrypt,
+		.decrypt = crypto_aes_cbc_cts_decrypt,
+	},
+#endif
 };
 
 static int __init crypto_aes_mod_init(void)
@@ -408,3 +563,11 @@ MODULE_ALIAS_CRYPTO("cbcmac-aes-lib");
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("ecb-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CBC)
+MODULE_ALIAS_CRYPTO("cbc(aes)");
+MODULE_ALIAS_CRYPTO("cbc-aes-lib");
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
+MODULE_ALIAS_CRYPTO("cts-cbc-aes-lib");
+#endif
-- 
2.54.0

