Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8950296BD1;
	Sun, 26 Oct 2025 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457990; cv=none; b=or+jq9IZT8hPnIDP0/F2IikO0Q5GDZOz+daywgKtwDzwZYqEU8fsiMz72FSIee0IXPZPHqKJyijmTqiaNqLect17MDhR1sYVKXLAc4MydjCsDVHzDo7xESBBB6p20vFrLTJCJoZoeD+3sgguAo1+y7R9Aci1zj/HMrybZuEeTU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457990; c=relaxed/simple;
	bh=Lzx62QBuaeOXq0bj2I+HZPtnTXKhz7ZQUxNW7xFMCUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/u1iDSHUbRgKGJpkBobjoxVnIXZOu4wQTN5Sg9CsPnSqL3CQ4Wo/HwkX8i0WL8JxbSl+AldO5DJm3as2zCmChoS1cBFHwBqj1JsUFrxdOYYeFlUXV54xNkw+Fell0BRzhc4xCpXMiUYM/Bgrn+1R1tvzK1ny73aqEf4yCyQTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFq2JDXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFq2JDXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA8C4AF16;
	Sun, 26 Oct 2025 05:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457989;
	bh=Lzx62QBuaeOXq0bj2I+HZPtnTXKhz7ZQUxNW7xFMCUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFq2JDXgvXOyXU2M+OjGTFwuhY6MD4rN2xC1cvgsdXAl3V6rUPyGIRL2IxGVBtbct
	 +cXMtc9F6yF/yPQNRX7D9e4nWj1NGTygsUXASKifPtPv3F8xLMSHbty1dd4nUrimWS
	 I/WWqgfkqmApZFfkeru8AzRLobi421VRAvggTJmyX6e4s6gbCFzmP5RHJqHnMZNLfM
	 r9e46Cs9yBxAGqgSNjIUA+wtzCv/uD+y/IDh7tQBL/nSEWchbrEaSYwPMwzSSDAlmg
	 LC0sdS6NJF3/8lzKgEeMl4qitupFl3egd7eV8cyuzMlQDgDQdmB638fqWzKbFPSDCO
	 rfNyKbE/z5O8g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/15] crypto: sha3 - Reimplement using library API
Date: Sat, 25 Oct 2025 22:50:31 -0700
Message-ID: <20251026055032.1413733-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace sha3_generic.c with a new file sha3.c which implements the SHA-3
crypto_shash algorithms on top of the SHA-3 library API.

Change the driver name suffix from "-generic" to "-lib" to reflect that
these algorithms now just use the (possibly arch-optimized) library.

This closely mirrors crypto/{md5,sha1,sha256,sha512,blake2b}.c.

Implement export_core and import_core, since crypto/hmac.c expects these
to be present.  (Note that there is no security purpose in wrapping
SHA-3 with HMAC.  HMAC was designed for older algorithms that don't
resist length extension attacks.  But since someone could be using
"hmac(sha3-*)" via crypto_shash anyway, keep supporting it for now.)

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig        |   1 +
 crypto/Makefile       |   2 +-
 crypto/sha3.c         | 166 ++++++++++++++++++++++++
 crypto/sha3_generic.c | 290 ------------------------------------------
 crypto/testmgr.c      |   8 ++
 include/crypto/sha3.h |   6 -
 6 files changed, 176 insertions(+), 297 deletions(-)
 create mode 100644 crypto/sha3.c
 delete mode 100644 crypto/sha3_generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0a7e74ac870b0..57b85e903cf0b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1004,10 +1004,11 @@ config CRYPTO_SHA512
 	  10118-3), including HMAC support.
 
 config CRYPTO_SHA3
 	tristate "SHA-3"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA3
 	help
 	  SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
 
 config CRYPTO_SM3_GENERIC
 	tristate "SM3 (ShangMi 3)"
diff --git a/crypto/Makefile b/crypto/Makefile
index 5b02ca2cb04e0..0388ff8d219d1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -76,11 +76,11 @@ obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
-obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
+obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
 obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
diff --git a/crypto/sha3.c b/crypto/sha3.c
new file mode 100644
index 0000000000000..8f364979ec890
--- /dev/null
+++ b/crypto/sha3.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Crypto API support for SHA-3
+ * (https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf)
+ */
+#include <crypto/internal/hash.h>
+#include <crypto/sha3.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define SHA3_CTX(desc) ((struct sha3_ctx *)shash_desc_ctx(desc))
+
+static int crypto_sha3_224_init(struct shash_desc *desc)
+{
+	sha3_224_init(SHA3_CTX(desc));
+	return 0;
+}
+
+static int crypto_sha3_256_init(struct shash_desc *desc)
+{
+	sha3_256_init(SHA3_CTX(desc));
+	return 0;
+}
+
+static int crypto_sha3_384_init(struct shash_desc *desc)
+{
+	sha3_384_init(SHA3_CTX(desc));
+	return 0;
+}
+
+static int crypto_sha3_512_init(struct shash_desc *desc)
+{
+	sha3_512_init(SHA3_CTX(desc));
+	return 0;
+}
+
+static int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
+{
+	sha3_update(SHA3_CTX(desc), data, len);
+	return 0;
+}
+
+static int crypto_sha3_final(struct shash_desc *desc, u8 *out)
+{
+	sha3_final(SHA3_CTX(desc), out);
+	return 0;
+}
+
+static int crypto_sha3_224_digest(struct shash_desc *desc,
+				  const u8 *data, unsigned int len, u8 *out)
+{
+	sha3_224(data, len, out);
+	return 0;
+}
+
+static int crypto_sha3_256_digest(struct shash_desc *desc,
+				  const u8 *data, unsigned int len, u8 *out)
+{
+	sha3_256(data, len, out);
+	return 0;
+}
+
+static int crypto_sha3_384_digest(struct shash_desc *desc,
+				  const u8 *data, unsigned int len, u8 *out)
+{
+	sha3_384(data, len, out);
+	return 0;
+}
+
+static int crypto_sha3_512_digest(struct shash_desc *desc,
+				  const u8 *data, unsigned int len, u8 *out)
+{
+	sha3_512(data, len, out);
+	return 0;
+}
+
+static int crypto_sha3_export_core(struct shash_desc *desc, void *out)
+{
+	memcpy(out, SHA3_CTX(desc), sizeof(struct sha3_ctx));
+	return 0;
+}
+
+static int crypto_sha3_import_core(struct shash_desc *desc, const void *in)
+{
+	memcpy(SHA3_CTX(desc), in, sizeof(struct sha3_ctx));
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
+	.digestsize		= SHA3_224_DIGEST_SIZE,
+	.init			= crypto_sha3_224_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
+	.digest			= crypto_sha3_224_digest,
+	.export_core		= crypto_sha3_export_core,
+	.import_core		= crypto_sha3_import_core,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "sha3-224",
+	.base.cra_driver_name	= "sha3-224-lib",
+	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_256_DIGEST_SIZE,
+	.init			= crypto_sha3_256_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
+	.digest			= crypto_sha3_256_digest,
+	.export_core		= crypto_sha3_export_core,
+	.import_core		= crypto_sha3_import_core,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "sha3-256",
+	.base.cra_driver_name	= "sha3-256-lib",
+	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_384_DIGEST_SIZE,
+	.init			= crypto_sha3_384_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
+	.digest			= crypto_sha3_384_digest,
+	.export_core		= crypto_sha3_export_core,
+	.import_core		= crypto_sha3_import_core,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "sha3-384",
+	.base.cra_driver_name	= "sha3-384-lib",
+	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHA3_512_DIGEST_SIZE,
+	.init			= crypto_sha3_512_init,
+	.update			= crypto_sha3_update,
+	.final			= crypto_sha3_final,
+	.digest			= crypto_sha3_512_digest,
+	.export_core		= crypto_sha3_export_core,
+	.import_core		= crypto_sha3_import_core,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "sha3-512",
+	.base.cra_driver_name	= "sha3-512-lib",
+	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+} };
+
+static int __init crypto_sha3_mod_init(void)
+{
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+module_init(crypto_sha3_mod_init);
+
+static void __exit crypto_sha3_mod_exit(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+module_exit(crypto_sha3_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Crypto API support for SHA-3");
+
+MODULE_ALIAS_CRYPTO("sha3-224");
+MODULE_ALIAS_CRYPTO("sha3-224-lib");
+MODULE_ALIAS_CRYPTO("sha3-256");
+MODULE_ALIAS_CRYPTO("sha3-256-lib");
+MODULE_ALIAS_CRYPTO("sha3-384");
+MODULE_ALIAS_CRYPTO("sha3-384-lib");
+MODULE_ALIAS_CRYPTO("sha3-512");
+MODULE_ALIAS_CRYPTO("sha3-512-lib");
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
deleted file mode 100644
index 41d1e506e6dea..0000000000000
--- a/crypto/sha3_generic.c
+++ /dev/null
@@ -1,290 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * SHA-3, as specified in
- * https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
- *
- * SHA-3 code by Jeff Garzik <jeff@garzik.org>
- *               Ard Biesheuvel <ard.biesheuvel@linaro.org>
- */
-#include <crypto/internal/hash.h>
-#include <crypto/sha3.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/unaligned.h>
-
-/*
- * On some 32-bit architectures (h8300), GCC ends up using
- * over 1 KB of stack if we inline the round calculation into the loop
- * in keccakf(). On the other hand, on 64-bit architectures with plenty
- * of [64-bit wide] general purpose registers, not inlining it severely
- * hurts performance. So let's use 64-bitness as a heuristic to decide
- * whether to inline or not.
- */
-#ifdef CONFIG_64BIT
-#define SHA3_INLINE	inline
-#else
-#define SHA3_INLINE	noinline
-#endif
-
-#define KECCAK_ROUNDS 24
-
-static const u64 keccakf_rndc[24] = {
-	0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
-	0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
-	0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008aULL,
-	0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
-	0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL,
-	0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
-	0x000000000000800aULL, 0x800000008000000aULL, 0x8000000080008081ULL,
-	0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
-};
-
-/* update the state with given number of rounds */
-
-static SHA3_INLINE void keccakf_round(u64 st[25])
-{
-	u64 t[5], tt, bc[5];
-
-	/* Theta */
-	bc[0] = st[0] ^ st[5] ^ st[10] ^ st[15] ^ st[20];
-	bc[1] = st[1] ^ st[6] ^ st[11] ^ st[16] ^ st[21];
-	bc[2] = st[2] ^ st[7] ^ st[12] ^ st[17] ^ st[22];
-	bc[3] = st[3] ^ st[8] ^ st[13] ^ st[18] ^ st[23];
-	bc[4] = st[4] ^ st[9] ^ st[14] ^ st[19] ^ st[24];
-
-	t[0] = bc[4] ^ rol64(bc[1], 1);
-	t[1] = bc[0] ^ rol64(bc[2], 1);
-	t[2] = bc[1] ^ rol64(bc[3], 1);
-	t[3] = bc[2] ^ rol64(bc[4], 1);
-	t[4] = bc[3] ^ rol64(bc[0], 1);
-
-	st[0] ^= t[0];
-
-	/* Rho Pi */
-	tt = st[1];
-	st[ 1] = rol64(st[ 6] ^ t[1], 44);
-	st[ 6] = rol64(st[ 9] ^ t[4], 20);
-	st[ 9] = rol64(st[22] ^ t[2], 61);
-	st[22] = rol64(st[14] ^ t[4], 39);
-	st[14] = rol64(st[20] ^ t[0], 18);
-	st[20] = rol64(st[ 2] ^ t[2], 62);
-	st[ 2] = rol64(st[12] ^ t[2], 43);
-	st[12] = rol64(st[13] ^ t[3], 25);
-	st[13] = rol64(st[19] ^ t[4],  8);
-	st[19] = rol64(st[23] ^ t[3], 56);
-	st[23] = rol64(st[15] ^ t[0], 41);
-	st[15] = rol64(st[ 4] ^ t[4], 27);
-	st[ 4] = rol64(st[24] ^ t[4], 14);
-	st[24] = rol64(st[21] ^ t[1],  2);
-	st[21] = rol64(st[ 8] ^ t[3], 55);
-	st[ 8] = rol64(st[16] ^ t[1], 45);
-	st[16] = rol64(st[ 5] ^ t[0], 36);
-	st[ 5] = rol64(st[ 3] ^ t[3], 28);
-	st[ 3] = rol64(st[18] ^ t[3], 21);
-	st[18] = rol64(st[17] ^ t[2], 15);
-	st[17] = rol64(st[11] ^ t[1], 10);
-	st[11] = rol64(st[ 7] ^ t[2],  6);
-	st[ 7] = rol64(st[10] ^ t[0],  3);
-	st[10] = rol64(    tt ^ t[1],  1);
-
-	/* Chi */
-	bc[ 0] = ~st[ 1] & st[ 2];
-	bc[ 1] = ~st[ 2] & st[ 3];
-	bc[ 2] = ~st[ 3] & st[ 4];
-	bc[ 3] = ~st[ 4] & st[ 0];
-	bc[ 4] = ~st[ 0] & st[ 1];
-	st[ 0] ^= bc[ 0];
-	st[ 1] ^= bc[ 1];
-	st[ 2] ^= bc[ 2];
-	st[ 3] ^= bc[ 3];
-	st[ 4] ^= bc[ 4];
-
-	bc[ 0] = ~st[ 6] & st[ 7];
-	bc[ 1] = ~st[ 7] & st[ 8];
-	bc[ 2] = ~st[ 8] & st[ 9];
-	bc[ 3] = ~st[ 9] & st[ 5];
-	bc[ 4] = ~st[ 5] & st[ 6];
-	st[ 5] ^= bc[ 0];
-	st[ 6] ^= bc[ 1];
-	st[ 7] ^= bc[ 2];
-	st[ 8] ^= bc[ 3];
-	st[ 9] ^= bc[ 4];
-
-	bc[ 0] = ~st[11] & st[12];
-	bc[ 1] = ~st[12] & st[13];
-	bc[ 2] = ~st[13] & st[14];
-	bc[ 3] = ~st[14] & st[10];
-	bc[ 4] = ~st[10] & st[11];
-	st[10] ^= bc[ 0];
-	st[11] ^= bc[ 1];
-	st[12] ^= bc[ 2];
-	st[13] ^= bc[ 3];
-	st[14] ^= bc[ 4];
-
-	bc[ 0] = ~st[16] & st[17];
-	bc[ 1] = ~st[17] & st[18];
-	bc[ 2] = ~st[18] & st[19];
-	bc[ 3] = ~st[19] & st[15];
-	bc[ 4] = ~st[15] & st[16];
-	st[15] ^= bc[ 0];
-	st[16] ^= bc[ 1];
-	st[17] ^= bc[ 2];
-	st[18] ^= bc[ 3];
-	st[19] ^= bc[ 4];
-
-	bc[ 0] = ~st[21] & st[22];
-	bc[ 1] = ~st[22] & st[23];
-	bc[ 2] = ~st[23] & st[24];
-	bc[ 3] = ~st[24] & st[20];
-	bc[ 4] = ~st[20] & st[21];
-	st[20] ^= bc[ 0];
-	st[21] ^= bc[ 1];
-	st[22] ^= bc[ 2];
-	st[23] ^= bc[ 3];
-	st[24] ^= bc[ 4];
-}
-
-static void keccakf(u64 st[25])
-{
-	int round;
-
-	for (round = 0; round < KECCAK_ROUNDS; round++) {
-		keccakf_round(st);
-		/* Iota */
-		st[0] ^= keccakf_rndc[round];
-	}
-}
-
-int crypto_sha3_init(struct shash_desc *desc)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-
-	memset(sctx->st, 0, sizeof(sctx->st));
-	return 0;
-}
-EXPORT_SYMBOL(crypto_sha3_init);
-
-static int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len)
-{
-	unsigned int rsiz = crypto_shash_blocksize(desc->tfm);
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int rsizw = rsiz / 8;
-
-	do {
-		int i;
-
-		for (i = 0; i < rsizw; i++)
-			sctx->st[i] ^= get_unaligned_le64(data + 8 * i);
-		keccakf(sctx->st);
-
-		data += rsiz;
-		len -= rsiz;
-	} while (len >= rsiz);
-	return len;
-}
-
-static int crypto_sha3_finup(struct shash_desc *desc, const u8 *src,
-			     unsigned int len, u8 *out)
-{
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
-	unsigned int rsiz = crypto_shash_blocksize(desc->tfm);
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-	__le64 block[SHA3_224_BLOCK_SIZE / 8] = {};
-	__le64 *digest = (__le64 *)out;
-	unsigned int rsizw = rsiz / 8;
-	u8 *p;
-	int i;
-
-	p = memcpy(block, src, len);
-	p[len++] = 0x06;
-	p[rsiz - 1] |= 0x80;
-
-	for (i = 0; i < rsizw; i++)
-		sctx->st[i] ^= le64_to_cpu(block[i]);
-	memzero_explicit(block, sizeof(block));
-
-	keccakf(sctx->st);
-
-	for (i = 0; i < digest_size / 8; i++)
-		put_unaligned_le64(sctx->st[i], digest++);
-
-	if (digest_size & 4)
-		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
-
-	return 0;
-}
-
-static struct shash_alg algs[] = { {
-	.digestsize		= SHA3_224_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= crypto_sha3_update,
-	.finup			= crypto_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-224",
-	.base.cra_driver_name	= "sha3-224-generic",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}, {
-	.digestsize		= SHA3_256_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= crypto_sha3_update,
-	.finup			= crypto_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-256",
-	.base.cra_driver_name	= "sha3-256-generic",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}, {
-	.digestsize		= SHA3_384_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= crypto_sha3_update,
-	.finup			= crypto_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-384",
-	.base.cra_driver_name	= "sha3-384-generic",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}, {
-	.digestsize		= SHA3_512_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= crypto_sha3_update,
-	.finup			= crypto_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-512",
-	.base.cra_driver_name	= "sha3-512-generic",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-} };
-
-static int __init sha3_generic_mod_init(void)
-{
-	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
-}
-
-static void __exit sha3_generic_mod_fini(void)
-{
-	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
-}
-
-module_init(sha3_generic_mod_init);
-module_exit(sha3_generic_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA-3 Secure Hash Algorithm");
-
-MODULE_ALIAS_CRYPTO("sha3-224");
-MODULE_ALIAS_CRYPTO("sha3-224-generic");
-MODULE_ALIAS_CRYPTO("sha3-256");
-MODULE_ALIAS_CRYPTO("sha3-256-generic");
-MODULE_ALIAS_CRYPTO("sha3-384");
-MODULE_ALIAS_CRYPTO("sha3-384-generic");
-MODULE_ALIAS_CRYPTO("sha3-512");
-MODULE_ALIAS_CRYPTO("sha3-512-generic");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3ab7adc1cdce5..90d06c3ec9679 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5102,31 +5102,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(hmac_sha256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-224)",
+		.generic_driver = "hmac(sha3-224-lib)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha3_224_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-256)",
+		.generic_driver = "hmac(sha3-256-lib)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha3_256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-384)",
+		.generic_driver = "hmac(sha3-384-lib)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha3_384_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-512)",
+		.generic_driver = "hmac(sha3-512-lib)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha3_512_tv_template)
 		}
@@ -5476,31 +5480,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(sha256_tv_template)
 		}
 	}, {
 		.alg = "sha3-224",
+		.generic_driver = "sha3-224-lib",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha3_224_tv_template)
 		}
 	}, {
 		.alg = "sha3-256",
+		.generic_driver = "sha3-256-lib",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha3_256_tv_template)
 		}
 	}, {
 		.alg = "sha3-384",
+		.generic_driver = "sha3-384-lib",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha3_384_tv_template)
 		}
 	}, {
 		.alg = "sha3-512",
+		.generic_driver = "sha3-512-lib",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha3_512_tv_template)
 		}
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index a7503dfc1a044..d713b5e3d6956 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -35,14 +35,10 @@
 #define SHAKE256_DEFAULT_SIZE	(256 / 8)
 #define SHAKE256_BLOCK_SIZE	(200 - 2 * SHAKE256_DEFAULT_SIZE)
 
 #define SHA3_STATE_SIZE		200
 
-struct shash_desc;
-
-int crypto_sha3_init(struct shash_desc *desc);
-
 /*
  * State for the Keccak-f[1600] permutation: 25 64-bit words.
  *
  * We usually keep the state words as little-endian, to make absorbing and
  * squeezing easier.  (It means that absorbing and squeezing can just treat the
@@ -50,12 +46,10 @@ int crypto_sha3_init(struct shash_desc *desc);
  * temporarily by implementations of the permutation that need native-endian
  * words.  Of course, that conversion is a no-op on little-endian machines.
  */
 struct sha3_state {
 	union {
-		u64 st[SHA3_STATE_SIZE / 8]; /* temporarily retained for compatibility purposes */
-
 		__le64 words[SHA3_STATE_SIZE / 8];
 		u8 bytes[SHA3_STATE_SIZE];
 
 		u64 native_words[SHA3_STATE_SIZE / 8]; /* see comment above */
 	};
-- 
2.51.1.dirty

