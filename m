Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C231AF3B;
	Mon, 12 Jan 2026 19:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245798; cv=none; b=NlrJEwdREnKHZrWWXtRVxpXc3J2PAPOpSaIb5HMSRjh9LfHL8K/MphHtoob5lYyEv9U0KI4QcUOi557nribXdvFAR36pgdLcLfIXT7nybKYnNlahbrHg6c06/HUU6I4IQg5MshK5EBCNYjCpizdlwtiNewJeON41WfS+XJwOXrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245798; c=relaxed/simple;
	bh=JV1M038y5fd1Fii+AIq80mfwW2VT2ZAZq/Qain419Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAz1Cmj8A+FfEJfGYJ5+9sDDGjnPvCWP/PagLr9IxtRStOnHpyfV0wBUofADQaBEiZ/NudQTPF6p03fLw/xHKSPL9Rv8rMs6ckFElnvLYYvsWaYQUl9G7Tm2l4smpiYzxF4wQ1jB8ISY5fTvil3oZG7kcc2GJcWHfp+fqRJ+rNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQ/vnJyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQ/vnJyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39F0C19424;
	Mon, 12 Jan 2026 19:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245798;
	bh=JV1M038y5fd1Fii+AIq80mfwW2VT2ZAZq/Qain419Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ/vnJyka/X0XFbjFkcVN6G/B0jLA5ZQ6lT1j0NV1HnrydwRrKx6ievF5NaNQeFK2
	 En2/0NauYq26MK+TbhehCCIBL3ds60TW5Z1dCEMkqmaoNscKya6DAA88yY7Jnmi6ZD
	 wy86VZQvANV8MRWkR2lAJ7tChvw8hFgI/EgSn9xhjw+0tOcGU1Vwqi5Hu2bsZIMIeE
	 XLUzLjcQo5a4UFcXXFXdNcf9t+790gS1lKaLfIw7kKI/bp3v3HsnlyJg8MPxluIoS+
	 N7CgjSk/kPaDpOljRew2l7Ub+WjkD5a94TMHmF9gjmdLXkxvz22UlUSwiS8x2WPWD9
	 OYTzunf4AtPOg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 01/35] crypto: powerpc/aes - Rename struct aes_key
Date: Mon, 12 Jan 2026 11:19:59 -0800
Message-ID: <20260112192035.10427-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename struct aes_key in aesp8-ppc.h and aes-gcm-p10-glue.c to
p8_aes_key and p10_aes_key, respectively.  This frees up the name to use
in the library API in <crypto/aes.h>.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c |  4 ++--
 arch/powerpc/crypto/aes.c              |  4 ++--
 arch/powerpc/crypto/aes_cbc.c          |  4 ++--
 arch/powerpc/crypto/aes_ctr.c          |  2 +-
 arch/powerpc/crypto/aes_xts.c          |  6 +++---
 arch/powerpc/crypto/aesp8-ppc.h        | 23 ++++++++++++-----------
 6 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index 85f4fd4b1bdc..f3417436d3f7 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -42,11 +42,11 @@ asmlinkage void aes_p10_gcm_decrypt(const u8 *in, u8 *out, size_t len,
 asmlinkage void gcm_init_htable(unsigned char htable[], unsigned char Xi[]);
 asmlinkage void gcm_ghash_p10(unsigned char *Xi, unsigned char *Htable,
 			      unsigned char *aad, unsigned int alen);
 asmlinkage void gcm_update(u8 *iv, void *Xi);
 
-struct aes_key {
+struct p10_aes_key {
 	u8 key[AES_MAX_KEYLENGTH];
 	u64 rounds;
 };
 
 struct gcm_ctx {
@@ -61,11 +61,11 @@ struct Hash_ctx {
 	u8 H[16];	/* subkey */
 	u8 Htable[256];	/* Xi, Hash table(offset 32) */
 };
 
 struct p10_aes_gcm_ctx {
-	struct aes_key enc_key;
+	struct p10_aes_key enc_key;
 	u8 nonce[RFC4106_NONCE_SIZE];
 };
 
 static void vsx_begin(void)
 {
diff --git a/arch/powerpc/crypto/aes.c b/arch/powerpc/crypto/aes.c
index 3f1e5e894902..b7192ee719fc 100644
--- a/arch/powerpc/crypto/aes.c
+++ b/arch/powerpc/crypto/aes.c
@@ -19,12 +19,12 @@
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_ctx {
 	struct crypto_cipher *fallback;
-	struct aes_key enc_key;
-	struct aes_key dec_key;
+	struct p8_aes_key enc_key;
+	struct p8_aes_key dec_key;
 };
 
 static int p8_aes_init(struct crypto_tfm *tfm)
 {
 	const char *alg = crypto_tfm_alg_name(tfm);
diff --git a/arch/powerpc/crypto/aes_cbc.c b/arch/powerpc/crypto/aes_cbc.c
index 5f2a4f375eef..4a9f285f0970 100644
--- a/arch/powerpc/crypto/aes_cbc.c
+++ b/arch/powerpc/crypto/aes_cbc.c
@@ -19,12 +19,12 @@
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_cbc_ctx {
 	struct crypto_skcipher *fallback;
-	struct aes_key enc_key;
-	struct aes_key dec_key;
+	struct p8_aes_key enc_key;
+	struct p8_aes_key dec_key;
 };
 
 static int p8_aes_cbc_init(struct crypto_skcipher *tfm)
 {
 	struct p8_aes_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
diff --git a/arch/powerpc/crypto/aes_ctr.c b/arch/powerpc/crypto/aes_ctr.c
index e27c4036e711..7dbd06f442db 100644
--- a/arch/powerpc/crypto/aes_ctr.c
+++ b/arch/powerpc/crypto/aes_ctr.c
@@ -19,11 +19,11 @@
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_ctr_ctx {
 	struct crypto_skcipher *fallback;
-	struct aes_key enc_key;
+	struct p8_aes_key enc_key;
 };
 
 static int p8_aes_ctr_init(struct crypto_skcipher *tfm)
 {
 	struct p8_aes_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
diff --git a/arch/powerpc/crypto/aes_xts.c b/arch/powerpc/crypto/aes_xts.c
index 9440e771cede..b4c760e465ea 100644
--- a/arch/powerpc/crypto/aes_xts.c
+++ b/arch/powerpc/crypto/aes_xts.c
@@ -20,13 +20,13 @@
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_xts_ctx {
 	struct crypto_skcipher *fallback;
-	struct aes_key enc_key;
-	struct aes_key dec_key;
-	struct aes_key tweak_key;
+	struct p8_aes_key enc_key;
+	struct p8_aes_key dec_key;
+	struct p8_aes_key tweak_key;
 };
 
 static int p8_aes_xts_init(struct crypto_skcipher *tfm)
 {
 	struct p8_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
diff --git a/arch/powerpc/crypto/aesp8-ppc.h b/arch/powerpc/crypto/aesp8-ppc.h
index 5764d4438388..0bea010128cb 100644
--- a/arch/powerpc/crypto/aesp8-ppc.h
+++ b/arch/powerpc/crypto/aesp8-ppc.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/types.h>
 #include <crypto/aes.h>
 
-struct aes_key {
+struct p8_aes_key {
 	u8 key[AES_MAX_KEYLENGTH];
 	int rounds;
 };
 
 extern struct shash_alg p8_ghash_alg;
@@ -12,19 +12,20 @@ extern struct crypto_alg p8_aes_alg;
 extern struct skcipher_alg p8_aes_cbc_alg;
 extern struct skcipher_alg p8_aes_ctr_alg;
 extern struct skcipher_alg p8_aes_xts_alg;
 
 int aes_p8_set_encrypt_key(const u8 *userKey, const int bits,
-			   struct aes_key *key);
+			   struct p8_aes_key *key);
 int aes_p8_set_decrypt_key(const u8 *userKey, const int bits,
-			   struct aes_key *key);
-void aes_p8_encrypt(const u8 *in, u8 *out, const struct aes_key *key);
-void aes_p8_decrypt(const u8 *in, u8 *out, const struct aes_key *key);
+			   struct p8_aes_key *key);
+void aes_p8_encrypt(const u8 *in, u8 *out, const struct p8_aes_key *key);
+void aes_p8_decrypt(const u8 *in, u8 *out, const struct p8_aes_key *key);
 void aes_p8_cbc_encrypt(const u8 *in, u8 *out, size_t len,
-			const struct aes_key *key, u8 *iv, const int enc);
-void aes_p8_ctr32_encrypt_blocks(const u8 *in, u8 *out,
-				 size_t len, const struct aes_key *key,
-				 const u8 *iv);
+			const struct p8_aes_key *key, u8 *iv, const int enc);
+void aes_p8_ctr32_encrypt_blocks(const u8 *in, u8 *out, size_t len,
+				 const struct p8_aes_key *key, const u8 *iv);
 void aes_p8_xts_encrypt(const u8 *in, u8 *out, size_t len,
-			const struct aes_key *key1, const struct aes_key *key2, u8 *iv);
+			const struct p8_aes_key *key1,
+			const struct p8_aes_key *key2, u8 *iv);
 void aes_p8_xts_decrypt(const u8 *in, u8 *out, size_t len,
-			const struct aes_key *key1, const struct aes_key *key2, u8 *iv);
+			const struct p8_aes_key *key1,
+			const struct p8_aes_key *key2, u8 *iv);
-- 
2.52.0

