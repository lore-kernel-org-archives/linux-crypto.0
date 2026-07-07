Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7760386C21;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402640; cv=none; b=CMXrKU6WFE31CbqYbBirQHPXlXZj3xltVaUlTg9d2iGQAdUQLJUQXKd2Vfw4iTCOn4y+yCRNoegLK94/4tx9rivO1cFfLZ/7ZlcfoCV1i7yqkxiLuGcVAUztGWgX4YmlqSmD/6fChWSgDYUxSv4fAkUtykiysJFlsZ9FjuiN3xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402640; c=relaxed/simple;
	bh=Z6z9Yw0yYULaXYM2r74iDJZV7oXy1xgIz4HOwuUNSTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L63KoxXj9MuZiB52HLWHQA1h8Ed13lXSpnbNr25XhntzlSlvUiNiAUE+MNDc3oh20am4nJZQ++oVnESDZR5CGboDCQXg7+V2QHoK9htLMNsON9y4ksi/2dbDTyu0NFXO1whwWe2wNwpRRsZD63U8Kvy5beWl2W/7O0IFIYR0W2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnM+fTSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnM+fTSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EB81F00ACF;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402638;
	bh=UrTSJNBDi+rhE0SZnitqOXaQ20Kh2MPyko2qEz3vbxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnM+fTSoGyXjrUCKvy48pIPVC2lsYGeY5ZtEDw048mF3PHI/bKVn6Arjt0R3nqVvK
	 EB6/SbcqwFErsA4J3DGwvQq3Lha6jjtN4l8lOt8LlufXVRV28zFyQi8WXSLHJ6wwqZ
	 96dGp4fTGOsqu3xSDUAD5y577adKGKai8h0NXBum9Y4fQfX+AOTb8C+9CKmgRd55iP
	 X0zvV9/svvatn3DdozYAooUPLqu6TSulmDGYjg5YdbUOfZ2PZzzWG/10TxTLgSHA16
	 f7uBxYRFqPN0//nCyFQQXB2cFdbQunCs6u7HVZO/LWp4/V9k+hiLUh4xG86ueO/Bpm
	 3glJLgsvb41QA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/33] crypto: aes - Add ECB support using library
Date: Mon,  6 Jul 2026 22:34:38 -0700
Message-ID: <20260707053503.209874-9-ebiggers@kernel.org>
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

Implement the "ecb(aes)" crypto_skcipher algorithm using the
corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-ECB
code to be migrated into the library while still leaving it accessible
via crypto_skcipher, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of this algorithm haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   5 ++
 crypto/aes.c   | 165 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f1e372195273..093508d13b8c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -359,7 +359,12 @@ config CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB
 	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
+	# enabled, but that doesn't work due to a recursive dependency caused by
+	# CRYPTO_SKCIPHER selecting CRYPTO_ECB.  So just always select it.
+	select CRYPTO_SKCIPHER
 	help
 	  AES cipher algorithms (Rijndael)(FIPS-197, ISO/IEC 18033-3)
 
diff --git a/crypto/aes.c b/crypto/aes.c
index 6bf23eb0503f..162715a82be3 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -6,12 +6,16 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
 static_assert(__alignof__(struct aes_key) <= CRYPTO_MINALIGN);
+static_assert(__alignof__(struct aes_enckey) <= CRYPTO_MINALIGN);
 
 static int crypto_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 			     unsigned int key_len)
@@ -85,7 +89,6 @@ static int __maybe_unused crypto_aes_cmac_digest(struct shash_desc *desc,
 	return 0;
 }
 
-static_assert(__alignof__(struct aes_enckey) <= CRYPTO_MINALIGN);
 #define AES_CBCMAC_KEY(tfm) ((struct aes_enckey *)crypto_shash_ctx(tfm))
 #define AES_CBCMAC_CTX(desc) ((struct aes_cbcmac_ctx *)shash_desc_ctx(desc))
 
@@ -200,6 +203,149 @@ static struct shash_alg mac_algs[] = {
 #endif
 };
 
+static __maybe_unused int
+crypto_aes_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			   unsigned int key_len)
+{
+	struct aes_key *key = crypto_skcipher_ctx(tfm);
+
+	return aes_preparekey(key, in_key, key_len);
+}
+
+static __maybe_unused int
+crypto_aes_skcipher_setenckey(struct crypto_skcipher *tfm, const u8 *in_key,
+			      unsigned int key_len)
+{
+	struct aes_enckey *key = crypto_skcipher_ctx(tfm);
+
+	return aes_prepareenckey(key, in_key, key_len);
+}
+
+/*
+ * Call crypt_func() (a function that operates on simple virtual addresses) zero
+ * or more times to en/decrypt 'cryptlen' bytes of data from the source
+ * scatterlist 'src' and write it into the destination scatterlist 'dst',
+ * starting at 'start_pos' bytes into both.
+ *
+ * This always calls crypt_func() with a length that's a multiple of
+ * AES_BLOCK_SIZE, except the last call which includes any remainder.  This is
+ * implemented by using an on-stack bounce buffer when necessary.  The current
+ * implementation also tries to prefer passing at least 4 blocks, so e.g.
+ * scatterlist entries [16,16,16,16] result in a single 64-byte call.
+ *
+ * The scatterlists must describe either entirely different memory
+ * (out-of-place) or entirely the same memory (in-place).  In the latter case,
+ * crypt_func() is always called with the source and dest pointers the same.
+ */
+#define AES_CRYPT_SG(crypt_func, dst, src, cryptlen, start_pos, ...)           \
+	({                                                                     \
+		unsigned int remaining = (cryptlen);                           \
+                                                                               \
+		if ((remaining) != 0) {                                        \
+			struct scatter_walk src_walk, dst_walk;                \
+			u8 tmp[4 * AES_BLOCK_SIZE] __aligned(                  \
+				__alignof__(long));                            \
+                                                                               \
+			scatterwalk_start_at_pos(&src_walk, (src),             \
+						 (start_pos));                 \
+			scatterwalk_start_at_pos(&dst_walk, (dst),             \
+						 (start_pos));                 \
+			do {                                                   \
+				unsigned int src_avail = scatterwalk_clamp(    \
+					&src_walk, (remaining));               \
+				unsigned int dst_avail = scatterwalk_clamp(    \
+					&dst_walk, (remaining));               \
+				unsigned int n = min(src_avail, dst_avail);    \
+				const u8 *src_virt;                            \
+				u8 *dst_virt;                                  \
+                                                                               \
+				if (n < (remaining)) {                         \
+					if (n < sizeof(tmp)) {                 \
+						n = min((remaining),           \
+							sizeof(tmp));          \
+						memcpy_from_scatterwalk(       \
+							tmp, &src_walk, n);    \
+						crypt_func(tmp, tmp, n,        \
+							   ##__VA_ARGS__);     \
+						memcpy_to_scatterwalk(         \
+							&dst_walk, tmp, n);    \
+						(remaining) -= n;              \
+						continue;                      \
+					}                                      \
+					n = round_down(n, AES_BLOCK_SIZE);     \
+				}                                              \
+                                                                               \
+				scatterwalk_map(&dst_walk);                    \
+				dst_virt = dst_walk.addr;                      \
+				if (IS_ENABLED(CONFIG_HIGHMEM) &&              \
+				    offset_in_page(src_walk.offset) ==         \
+					    offset_in_page(dst_walk.offset) && \
+				    sg_page(src_walk.sg) + (src_walk.offset /  \
+							    PAGE_SIZE) ==      \
+					    sg_page(dst_walk.sg) +             \
+						    (dst_walk.offset /         \
+						     PAGE_SIZE)) {             \
+					src_virt = dst_virt;                   \
+				} else {                                       \
+					scatterwalk_map(&src_walk);            \
+					src_virt = src_walk.addr;              \
+				}                                              \
+				crypt_func(dst_virt, src_virt, n,              \
+					   ##__VA_ARGS__);                     \
+				if (src_virt != dst_virt)                      \
+					scatterwalk_unmap(&src_walk);          \
+				scatterwalk_advance(&src_walk, n);             \
+				scatterwalk_done_dst(&dst_walk, n);            \
+				(remaining) -= n;                              \
+			} while (remaining);                                   \
+			memzero_explicit(tmp, sizeof(tmp));                    \
+		}                                                              \
+	})
+
+/* AES-ECB */
+
+static __maybe_unused int crypto_aes_ecb_encrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	AES_CRYPT_SG(aes_ecb_encrypt, req->dst, req->src, req->cryptlen, 0,
+		     key);
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_ecb_decrypt(struct skcipher_request *req)
+{
+	const struct aes_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen % AES_BLOCK_SIZE))
+		return -EINVAL;
+	AES_CRYPT_SG(aes_ecb_decrypt, req->dst, req->src, req->cryptlen, 0,
+		     key);
+	return 0;
+}
+
+static struct skcipher_alg skcipher_algs[] = {
+#if IS_ENABLED(CONFIG_CRYPTO_ECB)
+	{
+		.base.cra_name = "ecb(aes)",
+		.base.cra_driver_name = "ecb-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.setkey = crypto_aes_skcipher_setkey,
+		.encrypt = crypto_aes_ecb_encrypt,
+		.decrypt = crypto_aes_ecb_decrypt,
+	},
+#endif
+};
+
 static int __init crypto_aes_mod_init(void)
 {
 	int err = crypto_register_alg(&alg);
@@ -212,8 +358,18 @@ static int __init crypto_aes_mod_init(void)
 		if (err)
 			goto err_unregister_alg;
 	} /* Else, CONFIG_CRYPTO_HASH might not be enabled. */
+
+	if (ARRAY_SIZE(skcipher_algs) > 0) {
+		err = crypto_register_skciphers(skcipher_algs,
+						ARRAY_SIZE(skcipher_algs));
+		if (err)
+			goto err_unregister_macs;
+	}
 	return 0;
 
+err_unregister_macs:
+	if (ARRAY_SIZE(mac_algs) > 0)
+		crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
 err_unregister_alg:
 	crypto_unregister_alg(&alg);
 	return err;
@@ -222,6 +378,9 @@ module_init(crypto_aes_mod_init);
 
 static void __exit crypto_aes_mod_exit(void)
 {
+	if (ARRAY_SIZE(skcipher_algs) > 0)
+		crypto_unregister_skciphers(skcipher_algs,
+					    ARRAY_SIZE(skcipher_algs));
 	if (ARRAY_SIZE(mac_algs) > 0)
 		crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
 	crypto_unregister_alg(&alg);
@@ -245,3 +404,7 @@ MODULE_ALIAS_CRYPTO("xcbc-aes-lib");
 MODULE_ALIAS_CRYPTO("cbcmac(aes)");
 MODULE_ALIAS_CRYPTO("cbcmac-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_ECB)
+MODULE_ALIAS_CRYPTO("ecb(aes)");
+MODULE_ALIAS_CRYPTO("ecb-aes-lib");
+#endif
-- 
2.54.0

