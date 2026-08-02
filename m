Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97267339383;
	Sun,  2 Aug 2026 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709499; cv=none; b=L2K0fOOcgpdTgn1XvZFU0KDUsioDF8BLSwWUCghU3tCFxwbzitTVRz3qdq8iaow/1iqZ+HX+ZBYoAV/WE9Ff3ETtOp5x88SlzgbkT+s1bxCZSne9bpptif+y4h5Fk6zG0rmP6T3FdtFbJ1XfjC/e+tUgP/9LM0bJPceeqSYXDE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709499; c=relaxed/simple;
	bh=xqZgx/O9WpRyP4ZKdQj/XpGbKIOdjEFmq89FbW+0V7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbRjG7AF2gya/4QRjXHrRuLKj1+rMfhSE60ZURzMkXo2poodoXv9Ueb0P/xiNB30vCMOPCsXd4R63MVYcitCaxWEnn9Ub+PS1ToglwyHNzNvruLv66BOF/wRDScd9ZWgTlCn8BZstKgt8642IxmP8ZN8Iut2nDxE1SEb6M8dUk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5Qje7uG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5Qje7uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1475F1F00AC4;
	Sun,  2 Aug 2026 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785709498;
	bh=f43uyzOhFRcbS8DIL5LfQmcZIB/iVAmcYeNPPdOhx0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5Qje7uG1dfav7mqeHrgsNtYSIY6Od04dVgQ9QlK1yDFzsa686+RDmohg9PJsZKRj
	 lnF0OynHCDZ8gNKDrqZW+G9BmcLtLjNvDx2Wjm4ONRFBhSblWzJ88lVS8OM14XE6XK
	 cf5IV61PTSDeenyz7gYsraaqQR9JZYV8a99Ri7xpRI/IeuoHG43ObNkdfHgUgDwUTR
	 Vr3b0d3met4vVu6OQUnLrpS4AL5txxcPnR/49yVVdyXKuIexj4tg0RdVZ8DhJW1oEl
	 iMLNl6tY/gfMuXFzCE0BtsBiPK5J90hlnbgwRojXDG1NHlI44wh9J2PWA5R3XHrTsv
	 iKyUwvDyX4iwA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] lib/crypto: aes: Add FIPS self-tests for GCM and CCM
Date: Sun,  2 Aug 2026 15:24:08 -0700
Message-ID: <20260802222408.91757-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802222408.91757-1-ebiggers@kernel.org>
References: <20260802222408.91757-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upcoming changes will wire up architecture-optimized implementations of
GCM and CCM.  FIPS labs can consider such designs to meet the threshold
for separate self-tests to be needed.

Therefore, add FIPS self-tests for encryption and decryption in these
modes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c                    | 81 +++++++++++++++++++++++++----
 lib/crypto/fips-aes.h               | 19 +++++++
 scripts/crypto/gen-fips-testvecs.py | 23 ++++++++
 3 files changed, 113 insertions(+), 10 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index e9119f82b0cc..41aaa82cb1a1 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -737,14 +737,7 @@ void aes_cbcmac_final(struct aes_cbcmac_ctx *ctx, u8 out[AES_BLOCK_SIZE])
 }
 EXPORT_SYMBOL_NS_GPL(aes_cbcmac_final, "CRYPTO_INTERNAL");
 
-/*
- * FIPS cryptographic algorithm self-test for AES-CMAC.  As per the FIPS 140-3
- * Implementation Guidance, a cryptographic algorithm self-test for at least one
- * of AES-GCM, AES-CCM, AES-CMAC, or AES-GMAC is required if any of those modes
- * is implemented.  This fulfills that requirement via AES-CMAC.
- *
- * This is just for FIPS.  The full tests are in the KUnit test suite.
- */
+/* FIPS cryptographic algorithm self-test for AES-CMAC */
 static void __init aes_cmac_fips_test(void)
 {
 	struct aes_cmac_key key;
@@ -1745,7 +1738,37 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
 }
 EXPORT_SYMBOL_GPL(aes_gcm_decrypt);
 
-#endif /* CONFIG_CRYPTO_LIB_AES_GCM */
+/* FIPS cryptographic algorithm self-test for AES-GCM */
+static void __init aes_gcm_fips_test(void)
+{
+	const size_t data_len = sizeof(fips_test_data);
+	u8 buf[sizeof(fips_test_data) + AES_BLOCK_SIZE];
+	struct aes_gcm_key key;
+	int err;
+
+	if (aes_gcm_preparekey(&key, fips_test_key, sizeof(fips_test_key),
+			       AES_BLOCK_SIZE) != 0)
+		panic("aes: GCM FIPS self-test failed (preparekey)\n");
+
+	aes_gcm_encrypt(buf, fips_test_data, data_len, &buf[data_len],
+			fips_test_ad, sizeof(fips_test_ad), fips_test_iv, &key);
+	if (memcmp(fips_test_aes_gcm_ctext_and_tag, buf, sizeof(buf)) != 0)
+		panic("aes: GCM FIPS self-test failed (wrong ciphertext and/or tag)\n");
+
+	err = aes_gcm_decrypt(buf, buf, data_len, &buf[data_len], fips_test_ad,
+			      sizeof(fips_test_ad), fips_test_iv, &key);
+	if (err != 0)
+		panic("aes: GCM FIPS self-test failed (decryption failed)\n");
+	if (memcmp(fips_test_data, buf, data_len) != 0)
+		panic("aes: GCM FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+#else /* CONFIG_CRYPTO_LIB_AES_GCM */
+static inline void aes_gcm_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_GCM */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CCM)
 int aes_ccm_preparekey(struct aes_ccm_key *key, const u8 *in_key,
@@ -2057,7 +2080,43 @@ int aes_ccm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
 	return err;
 }
 EXPORT_SYMBOL_GPL(aes_ccm_decrypt);
-#endif /* CONFIG_CRYPTO_LIB_AES_CCM */
+
+/* FIPS cryptographic algorithm self-test for AES-CCM */
+static void __init aes_ccm_fips_test(void)
+{
+	const size_t data_len = sizeof(fips_test_data);
+	const size_t nonce_len = 13;
+	u8 buf[sizeof(fips_test_data) + AES_BLOCK_SIZE];
+	struct aes_ccm_key key;
+	int err;
+
+	if (aes_ccm_preparekey(&key, fips_test_key, sizeof(fips_test_key),
+			       AES_BLOCK_SIZE) != 0)
+		panic("aes: CCM FIPS self-test failed (preparekey)\n");
+
+	err = aes_ccm_encrypt(buf, fips_test_data, data_len, &buf[data_len],
+			      fips_test_ad, sizeof(fips_test_ad), fips_test_iv,
+			      nonce_len, &key);
+	if (err != 0)
+		panic("aes: CCM FIPS self-test failed (encryption failed)\n");
+	if (memcmp(fips_test_aes_ccm_ctext_and_tag, buf, sizeof(buf)) != 0)
+		panic("aes: CCM FIPS self-test failed (wrong ciphertext and/or tag)\n");
+
+	err = aes_ccm_decrypt(buf, buf, data_len, &buf[data_len], fips_test_ad,
+			      sizeof(fips_test_ad), fips_test_iv, nonce_len,
+			      &key);
+	if (err != 0)
+		panic("aes: CCM FIPS self-test failed (decryption failed)\n");
+	if (memcmp(fips_test_data, buf, data_len) != 0)
+		panic("aes: CCM FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+#else /* CONFIG_CRYPTO_LIB_AES_CCM */
+static inline void aes_ccm_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_CCM */
 
 static int __init aes_mod_init(void)
 {
@@ -2072,6 +2131,8 @@ static int __init aes_mod_init(void)
 		aes_cbc_cts_fips_test();
 		aes_ctr_fips_test();
 		aes_xts_fips_test();
+		aes_gcm_fips_test();
+		aes_ccm_fips_test();
 	}
 	return 0;
 }
diff --git a/lib/crypto/fips-aes.h b/lib/crypto/fips-aes.h
index cfacf5d98e07..2a1746606533 100644
--- a/lib/crypto/fips-aes.h
+++ b/lib/crypto/fips-aes.h
@@ -9,6 +9,11 @@ static const u8 fips_test_data[] __initconst __maybe_unused = {
 	0x74, 0x20, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00,
 };
 
+static const u8 fips_test_ad[] __initconst __maybe_unused = {
+	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
+	0x74, 0x20, 0x61, 0x64, 0x00, 0x00, 0x00, 0x00,
+};
+
 static const u8 fips_test_iv[] __initconst __maybe_unused = {
 	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
 	0x74, 0x20, 0x69, 0x76, 0x00, 0x00, 0x00, 0x00,
@@ -57,3 +62,17 @@ static const u8 fips_test_aes_xts_ctext[] __initconst __maybe_unused = {
 	0xd4, 0x51, 0x7f, 0x01, 0x14, 0x91, 0x16, 0x29,
 	0x26, 0xbe, 0xec, 0x9b, 0x90, 0xed, 0x59, 0x30,
 };
+
+static const u8 fips_test_aes_gcm_ctext_and_tag[] __initconst __maybe_unused = {
+	0x12, 0x0c, 0x5d, 0x03, 0x32, 0x93, 0x13, 0x44,
+	0x06, 0x35, 0x26, 0x9d, 0xe0, 0xea, 0xbc, 0xe2,
+	0x30, 0xa9, 0xa4, 0x15, 0xc5, 0x3d, 0xb3, 0xf9,
+	0x30, 0x82, 0xdf, 0x9c, 0xd8, 0xc4, 0x3f, 0x2f,
+};
+
+static const u8 fips_test_aes_ccm_ctext_and_tag[] __initconst __maybe_unused = {
+	0x11, 0x8e, 0x01, 0xcb, 0xb5, 0x22, 0x6d, 0xb4,
+	0x66, 0x98, 0x97, 0x1d, 0x35, 0x53, 0x78, 0xdd,
+	0xd1, 0xc5, 0xff, 0xb6, 0x90, 0xcf, 0xb1, 0xf2,
+	0x87, 0x99, 0xd6, 0x1e, 0xd5, 0xd1, 0xed, 0x63,
+};
diff --git a/scripts/crypto/gen-fips-testvecs.py b/scripts/crypto/gen-fips-testvecs.py
index a79eaf081c26..b8c8a78cb8a8 100755
--- a/scripts/crypto/gen-fips-testvecs.py
+++ b/scripts/crypto/gen-fips-testvecs.py
@@ -8,6 +8,7 @@
 # Copyright 2025 Google LLC
 
 import cryptography.hazmat.primitives.ciphers
+import cryptography.hazmat.primitives.ciphers.aead
 import cryptography.hazmat.primitives.cmac
 import hashlib
 import hmac
@@ -32,12 +33,14 @@ def print_header(file):
 
 def gen_aes_test_data(file):
     fips_test_data = b"fips test data\0\0"
+    fips_test_ad = b"fips test ad\0\0\0\0"
     fips_test_iv = b"fips test iv\0\0\0\0"
     fips_test_key = b"fips test key\0\0\0"
     fips_test_xts_key = b"key1" + (b"\0" * 12) + b"key2" + (b"\0" * 12)
 
     print_header(file)
     print_static_u8_array_definition(file, "fips_test_data", fips_test_data)
+    print_static_u8_array_definition(file, "fips_test_ad", fips_test_ad)
     print_static_u8_array_definition(file, "fips_test_iv", fips_test_iv)
     print_static_u8_array_definition(file, "fips_test_key", fips_test_key)
     print_static_u8_array_definition(file, "fips_test_xts_key", fips_test_xts_key)
@@ -93,6 +96,26 @@ def gen_aes_test_data(file):
     ctext = encryptor.update(fips_test_data) + encryptor.finalize()
     print_static_u8_array_definition(file, "fips_test_aes_xts_ctext", ctext)
 
+    # AES-GCM
+    cipher = cryptography.hazmat.primitives.ciphers.aead.AESGCM(fips_test_key)
+    ct_and_tag = cipher.encrypt(
+        nonce=fips_test_iv[:12], data=fips_test_data, associated_data=fips_test_ad
+    )
+    print_static_u8_array_definition(
+        file, "fips_test_aes_gcm_ctext_and_tag", ct_and_tag
+    )
+
+    # AES-CCM
+    cipher = cryptography.hazmat.primitives.ciphers.aead.AESCCM(
+        fips_test_key, tag_length=16
+    )
+    ct_and_tag = cipher.encrypt(
+        nonce=fips_test_iv[:13], data=fips_test_data, associated_data=fips_test_ad
+    )
+    print_static_u8_array_definition(
+        file, "fips_test_aes_ccm_ctext_and_tag", ct_and_tag
+    )
+
 
 def gen_sha_test_data(file):
     fips_test_data = b"fips test data\0\0"
-- 
2.55.0

