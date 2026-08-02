Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD1B29C35A;
	Sun,  2 Aug 2026 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709499; cv=none; b=Wz5zUOJuhyRV9kEXud4YZDAkwrJh7PXrc8fix7iZjpAG/fYOVc9/iZNfT9xljvlV1KOWRd5v/+uj3RdeF6WLkBZpH5XP1wvu89+6QbvnRC6oui5vEkmWT/ekF7N67gfFQI3R49EoEK7Pk2b7PpoixQS+TX2en/sMbTTsLo1Hmsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709499; c=relaxed/simple;
	bh=hUvSITSaDRxL50PMtyAzPgYnL7smIFvJucc6fI4h6m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC6dHTsGZwnvg15nnIKN8BOJkD09u4cYeXP1AO0207BxETDPwPtnhHgHDxmh7BFAVVbtPuSdO2NybURANiWACG3rdC97f9uMsK1ikT1EzDxGPebM1JSIG3oY3qr8ueIJq92+SPpm90hyrTv3Vngv7EKTy7sbhWyJNq9tCZcMKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diau56UP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diau56UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87EF1F00A3F;
	Sun,  2 Aug 2026 22:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785709497;
	bh=jNx6qI6JUX7COnXFEZ/z2+Yl6IaA80PSmQcMGwUIt+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diau56UPOTjJn0dmPDm76bF9Q6SAPd7/Q1DUzd574Fw80fnls+kLCWq+tp0IkfZB2
	 9TqpUs9iqy9iyAtitQaqfWdFCOVI5c8flrOOCiMaJEa2l2y781DAAoANH3qG+Zv9Ga
	 i9+L3cZb7KZtgRDgKuLz8W5v3y4g52QLiH84oWeNL8S5/k36oiQoz4g8b7tLW84Jly
	 k0K3e8Smnpo3dkYm5CgKuCEe6pPZ8eZbdgpmJXNb3CzX7Ti7UfM61CgyRVf0vHkE4e
	 lZ+CnsvjqMwJSiCbjsTFJWw5mDaQiNyKcffKB9nOn/u6XX9ky1VjZ7vTrWVMyLG55F
	 O0j7I9RMjptCQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] lib/crypto: aes: Add FIPS self-tests for unauthenticated modes
Date: Sun,  2 Aug 2026 15:24:07 -0700
Message-ID: <20260802222408.91757-3-ebiggers@kernel.org>
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
ECB, CBC, CBC-CTS, CTR, and XTS.  FIPS labs can consider such designs to
meet the threshold for separate self-tests to be needed.

The inverse direction of the block cipher also needs to be exercised,
which the existing CMAC self-test doesn't do.

Therefore, add FIPS self-tests for encryption and decryption in these
modes as well as the "bare" AES.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c                    | 176 +++++++++++++++++++++++++++-
 lib/crypto/fips-aes.h               |  39 ++++++
 scripts/crypto/gen-fips-testvecs.py |  48 ++++++++
 3 files changed, 258 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 617c913d512e..e9119f82b0cc 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -522,6 +522,26 @@ void aes_decrypt(const struct aes_key *key, u8 out[AES_BLOCK_SIZE],
 }
 EXPORT_SYMBOL(aes_decrypt);
 
+/* FIPS cryptographic algorithm self-test for "bare" AES */
+static void __init aes_fips_test(void)
+{
+	struct aes_key key;
+	u8 data[AES_BLOCK_SIZE];
+
+	if (aes_preparekey(&key, fips_test_key, sizeof(fips_test_key)) != 0)
+		panic("aes: FIPS self-test failed (preparekey)\n");
+
+	aes_encrypt(&key, data, fips_test_data);
+	if (memcmp(fips_test_aes_ecb_ctext, data, sizeof(data)) != 0)
+		panic("aes: FIPS self-test failed (wrong ciphertext)\n");
+
+	aes_decrypt(&key, data, data);
+	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
+		panic("aes: FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC_MACS)
 
 #ifndef aes_cbcmac_blocks_arch
@@ -797,7 +817,31 @@ void aes_ecb_decrypt(u8 *dst, const u8 *src, size_t len,
 		aes_decrypt(key, &dst[i], &src[i]);
 }
 EXPORT_SYMBOL_GPL(aes_ecb_decrypt);
-#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
+
+/* FIPS cryptographic algorithm self-test for AES-ECB */
+static void __init aes_ecb_fips_test(void)
+{
+	struct aes_key key;
+	u8 data[sizeof(fips_test_data)];
+
+	if (aes_preparekey(&key, fips_test_key, sizeof(fips_test_key)) != 0)
+		panic("aes: ECB FIPS self-test failed (preparekey)\n");
+
+	aes_ecb_encrypt(data, fips_test_data, sizeof(data), &key);
+	if (memcmp(fips_test_aes_ecb_ctext, data, sizeof(data)) != 0)
+		panic("aes: ECB FIPS self-test failed (wrong ciphertext)\n");
+
+	aes_ecb_decrypt(data, data, sizeof(data), &key);
+	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
+		panic("aes: ECB FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+#else /* CONFIG_CRYPTO_LIB_AES_ECB */
+static inline void aes_ecb_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_ECB */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
 /*
@@ -983,7 +1027,66 @@ void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
 	crypto_xor(pad, iv, AES_BLOCK_SIZE); /* P[n - 1] */
 }
 EXPORT_SYMBOL_GPL(aes_cbc_cts_decrypt);
-#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
+
+/* FIPS cryptographic algorithm self-test for AES-CBC */
+static void __init aes_cbc_fips_test(void)
+{
+	struct aes_key key;
+	u8 iv[AES_BLOCK_SIZE];
+	u8 data[sizeof(fips_test_data)];
+
+	if (aes_preparekey(&key, fips_test_key, sizeof(fips_test_key)) != 0)
+		panic("aes: CBC FIPS self-test failed (preparekey)\n");
+
+	memcpy(iv, fips_test_iv, sizeof(iv));
+	aes_cbc_encrypt(data, fips_test_data, sizeof(data), iv, &key);
+	if (memcmp(fips_test_aes_cbc_ctext, data, sizeof(data)) != 0)
+		panic("aes: CBC FIPS self-test failed (wrong ciphertext)\n");
+
+	memcpy(iv, fips_test_iv, sizeof(iv));
+	aes_cbc_decrypt(data, data, sizeof(data), iv, &key);
+	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
+		panic("aes: CBC FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+
+/* FIPS cryptographic algorithm self-test for AES-CBC-CTS */
+static void __init aes_cbc_cts_fips_test(void)
+{
+	struct aes_key key;
+	u8 iv[AES_BLOCK_SIZE];
+	const size_t data_len = 2 * AES_BLOCK_SIZE;
+	u8 ptext[2 * AES_BLOCK_SIZE];
+	u8 data[2 * AES_BLOCK_SIZE];
+
+	/* ptext = fips_test_data || fips_test_data */
+	memcpy(ptext, fips_test_data, AES_BLOCK_SIZE);
+	memcpy(&ptext[AES_BLOCK_SIZE], ptext, AES_BLOCK_SIZE);
+
+	if (aes_preparekey(&key, fips_test_key, sizeof(fips_test_key)) != 0)
+		panic("aes: CBC-CTS FIPS self-test failed (preparekey)\n");
+
+	memcpy(iv, fips_test_iv, sizeof(iv));
+	aes_cbc_cts_encrypt(data, ptext, data_len, iv, &key);
+	if (memcmp(fips_test_aes_cbc_cts_ctext, data, data_len) != 0)
+		panic("aes: CBC-CTS FIPS self-test failed (wrong ciphertext)\n");
+
+	memcpy(iv, fips_test_iv, sizeof(iv));
+	aes_cbc_cts_decrypt(data, data, data_len, iv, &key);
+	if (memcmp(ptext, data, data_len) != 0)
+		panic("aes: CBC-CTS FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+#else /* CONFIG_CRYPTO_LIB_AES_CBC */
+static inline void aes_cbc_fips_test(void)
+{
+}
+static inline void aes_cbc_cts_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_CBC */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
 /*
@@ -1078,7 +1181,34 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
 	memzero_explicit(aes_input, sizeof(aes_input));
 }
 EXPORT_SYMBOL_GPL(aes_xctr);
-#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
+
+/* FIPS cryptographic algorithm self-test for AES-CTR */
+static void __init aes_ctr_fips_test(void)
+{
+	struct aes_enckey key;
+	u8 ctr[AES_BLOCK_SIZE];
+	u8 data[sizeof(fips_test_data)];
+
+	if (aes_prepareenckey(&key, fips_test_key, sizeof(fips_test_key)) != 0)
+		panic("aes: CTR FIPS self-test failed (preparekey)\n");
+
+	memcpy(ctr, fips_test_iv, sizeof(ctr));
+	aes_ctr(data, fips_test_data, sizeof(data), ctr, &key);
+	if (memcmp(fips_test_aes_ctr_ctext, data, sizeof(data)) != 0)
+		panic("aes: CTR FIPS self-test failed (wrong ciphertext)\n");
+
+	memcpy(ctr, fips_test_iv, sizeof(ctr));
+	aes_ctr(data, data, sizeof(data), ctr, &key);
+	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
+		panic("aes: CTR FIPS self-test failed (wrong plaintext)\n");
+
+	memzero_explicit(&key, sizeof(key));
+}
+#else /* CONFIG_CRYPTO_LIB_AES_CTR */
+static inline void aes_ctr_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_CTR */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
 int aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
@@ -1307,7 +1437,36 @@ void aes_xts_decrypt(u8 *dst, const u8 *src, size_t len,
 	aes_xts_decrypt_nocts(dst, src, len, tweak, key, cont);
 }
 EXPORT_SYMBOL_GPL(aes_xts_decrypt);
-#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
+
+/* FIPS cryptographic algorithm self-test for AES-XTS */
+static void __init aes_xts_fips_test(void)
+{
+	struct aes_xts_key *key __free(kfree_sensitive) = kmalloc_obj(*key);
+	u8 tweak[AES_BLOCK_SIZE];
+	u8 data[sizeof(fips_test_data)];
+
+	if (key == NULL)
+		panic("aes: XTS FIPS self-test failed (kmalloc)\n");
+
+	if (aes_xts_preparekey(key, fips_test_xts_key,
+			       sizeof(fips_test_xts_key), 0) != 0)
+		panic("aes: XTS FIPS self-test failed (preparekey)\n");
+
+	memcpy(tweak, fips_test_iv, sizeof(tweak));
+	aes_xts_encrypt(data, fips_test_data, sizeof(data), tweak, key, false);
+	if (memcmp(fips_test_aes_xts_ctext, data, sizeof(data)) != 0)
+		panic("aes: XTS FIPS self-test failed (wrong ciphertext)\n");
+
+	memcpy(tweak, fips_test_iv, sizeof(tweak));
+	aes_xts_decrypt(data, data, sizeof(data), tweak, key, false);
+	if (memcmp(fips_test_data, data, sizeof(data)) != 0)
+		panic("aes: XTS FIPS self-test failed (wrong plaintext)\n");
+}
+#else /* CONFIG_CRYPTO_LIB_AES_XTS */
+static inline void aes_xts_fips_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_LIB_AES_XTS */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_GCM)
 /*
@@ -1905,8 +2064,15 @@ static int __init aes_mod_init(void)
 #ifdef aes_mod_init_arch
 	aes_mod_init_arch();
 #endif
-	if (fips_enabled)
+	if (fips_enabled) {
+		aes_fips_test();
 		aes_cmac_fips_test();
+		aes_ecb_fips_test();
+		aes_cbc_fips_test();
+		aes_cbc_cts_fips_test();
+		aes_ctr_fips_test();
+		aes_xts_fips_test();
+	}
 	return 0;
 }
 subsys_initcall(aes_mod_init);
diff --git a/lib/crypto/fips-aes.h b/lib/crypto/fips-aes.h
index b257cb216871..cfacf5d98e07 100644
--- a/lib/crypto/fips-aes.h
+++ b/lib/crypto/fips-aes.h
@@ -9,12 +9,51 @@ static const u8 fips_test_data[] __initconst __maybe_unused = {
 	0x74, 0x20, 0x64, 0x61, 0x74, 0x61, 0x00, 0x00,
 };
 
+static const u8 fips_test_iv[] __initconst __maybe_unused = {
+	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
+	0x74, 0x20, 0x69, 0x76, 0x00, 0x00, 0x00, 0x00,
+};
+
 static const u8 fips_test_key[] __initconst __maybe_unused = {
 	0x66, 0x69, 0x70, 0x73, 0x20, 0x74, 0x65, 0x73,
 	0x74, 0x20, 0x6b, 0x65, 0x79, 0x00, 0x00, 0x00,
 };
 
+static const u8 fips_test_xts_key[] __initconst __maybe_unused = {
+	0x6b, 0x65, 0x79, 0x31, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x6b, 0x65, 0x79, 0x32, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
 static const u8 fips_test_aes_cmac_value[] __initconst __maybe_unused = {
 	0xc5, 0x88, 0x28, 0x55, 0xd7, 0x2c, 0x00, 0xb6,
 	0x6a, 0xa7, 0xfc, 0x82, 0x90, 0x81, 0xcf, 0x18,
 };
+
+static const u8 fips_test_aes_ecb_ctext[] __initconst __maybe_unused = {
+	0x47, 0x76, 0x48, 0xaf, 0x1b, 0xd8, 0x4c, 0xe6,
+	0xb5, 0xa7, 0x20, 0x8d, 0x64, 0x88, 0xbc, 0x3f,
+};
+
+static const u8 fips_test_aes_cbc_ctext[] __initconst __maybe_unused = {
+	0xc8, 0x7d, 0x7c, 0x25, 0xba, 0x15, 0xf7, 0xe1,
+	0x08, 0xa0, 0xd0, 0x7a, 0x20, 0x37, 0xaf, 0x5e,
+};
+
+static const u8 fips_test_aes_cbc_cts_ctext[] __initconst __maybe_unused = {
+	0x36, 0x8e, 0x37, 0xb4, 0x78, 0xe2, 0x88, 0x59,
+	0xd5, 0xe8, 0x17, 0x65, 0x5c, 0xa1, 0x25, 0xe6,
+	0xc8, 0x7d, 0x7c, 0x25, 0xba, 0x15, 0xf7, 0xe1,
+	0x08, 0xa0, 0xd0, 0x7a, 0x20, 0x37, 0xaf, 0x5e,
+};
+
+static const u8 fips_test_aes_ctr_ctext[] __initconst __maybe_unused = {
+	0x95, 0xf4, 0xf4, 0x7a, 0xc8, 0xa2, 0x53, 0x73,
+	0x53, 0x8f, 0x95, 0xfc, 0x18, 0xfe, 0x58, 0x2f,
+};
+
+static const u8 fips_test_aes_xts_ctext[] __initconst __maybe_unused = {
+	0xd4, 0x51, 0x7f, 0x01, 0x14, 0x91, 0x16, 0x29,
+	0x26, 0xbe, 0xec, 0x9b, 0x90, 0xed, 0x59, 0x30,
+};
diff --git a/scripts/crypto/gen-fips-testvecs.py b/scripts/crypto/gen-fips-testvecs.py
index aa6c0a81fbf8..a79eaf081c26 100755
--- a/scripts/crypto/gen-fips-testvecs.py
+++ b/scripts/crypto/gen-fips-testvecs.py
@@ -32,19 +32,67 @@ def print_header(file):
 
 def gen_aes_test_data(file):
     fips_test_data = b"fips test data\0\0"
+    fips_test_iv = b"fips test iv\0\0\0\0"
     fips_test_key = b"fips test key\0\0\0"
+    fips_test_xts_key = b"key1" + (b"\0" * 12) + b"key2" + (b"\0" * 12)
 
     print_header(file)
     print_static_u8_array_definition(file, "fips_test_data", fips_test_data)
+    print_static_u8_array_definition(file, "fips_test_iv", fips_test_iv)
     print_static_u8_array_definition(file, "fips_test_key", fips_test_key)
+    print_static_u8_array_definition(file, "fips_test_xts_key", fips_test_xts_key)
 
     aes = cryptography.hazmat.primitives.ciphers.algorithms.AES(fips_test_key)
+
+    # AES-CMAC
     aes_cmac = cryptography.hazmat.primitives.cmac.CMAC(aes)
     aes_cmac.update(fips_test_data)
     print_static_u8_array_definition(
         file, "fips_test_aes_cmac_value", aes_cmac.finalize()
     )
 
+    # AES-ECB
+    cipher = cryptography.hazmat.primitives.ciphers.Cipher(
+        aes, cryptography.hazmat.primitives.ciphers.modes.ECB()
+    )
+    encryptor = cipher.encryptor()
+    ctext = encryptor.update(fips_test_data) + encryptor.finalize()
+    print_static_u8_array_definition(file, "fips_test_aes_ecb_ctext", ctext)
+
+    # AES-CBC
+    cipher = cryptography.hazmat.primitives.ciphers.Cipher(
+        aes, cryptography.hazmat.primitives.ciphers.modes.CBC(fips_test_iv)
+    )
+    encryptor = cipher.encryptor()
+    ctext = encryptor.update(fips_test_data) + encryptor.finalize()
+    print_static_u8_array_definition(file, "fips_test_aes_cbc_ctext", ctext)
+
+    # AES-CBC-CTS
+    cipher = cryptography.hazmat.primitives.ciphers.Cipher(
+        aes, cryptography.hazmat.primitives.ciphers.modes.CBC(fips_test_iv)
+    )
+    encryptor = cipher.encryptor()
+    ctext = encryptor.update(fips_test_data * 2) + encryptor.finalize()
+    ctext = ctext[16:32] + ctext[0:16]
+    print_static_u8_array_definition(file, "fips_test_aes_cbc_cts_ctext", ctext)
+
+    # AES-CTR
+    cipher = cryptography.hazmat.primitives.ciphers.Cipher(
+        aes, cryptography.hazmat.primitives.ciphers.modes.CTR(fips_test_iv)
+    )
+    encryptor = cipher.encryptor()
+    ctext = encryptor.update(fips_test_data) + encryptor.finalize()
+    print_static_u8_array_definition(file, "fips_test_aes_ctr_ctext", ctext)
+
+    # AES-XTS
+    cipher = cryptography.hazmat.primitives.ciphers.Cipher(
+        cryptography.hazmat.primitives.ciphers.algorithms.AES(fips_test_xts_key),
+        cryptography.hazmat.primitives.ciphers.modes.XTS(fips_test_iv),
+    )
+    encryptor = cipher.encryptor()
+    ctext = encryptor.update(fips_test_data) + encryptor.finalize()
+    print_static_u8_array_definition(file, "fips_test_aes_xts_ctext", ctext)
+
 
 def gen_sha_test_data(file):
     fips_test_data = b"fips test data\0\0"
-- 
2.55.0

