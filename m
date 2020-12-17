Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7CEC2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35698238E8
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbgLQW0W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732077AbgLQW0W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 17:26:22 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 09/11] crypto: blake2s - share the "shash" API boilerplate code
Date:   Thu, 17 Dec 2020 14:21:36 -0800
Message-Id: <20201217222138.170526-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217222138.170526-1-ebiggers@kernel.org>
References: <20201217222138.170526-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Move the boilerplate code for setkey(), init(), update(), and final()
from blake2s_generic.ko into a new module blake2s_helpers.ko, and export
it so that it can be used by other shash implementations of BLAKE2s.

setkey() and init() are exported as-is, while update() and final() have
a blake2s_compress_t function pointer argument added.  This allows the
implementation of the compression function to be overridden, which is
the only part that optimized implementations really care about.

The helper functions are defined in a separate module blake2s_helpers.ko
(rather than just than in blake2s_generic.ko) because we can't simply
select CRYPTO_BLAKE2B from CRYPTO_BLAKE2S_X86.  Doing this selection
unconditionally would make the library API select the shash API, while
doing it conditionally on CRYPTO_HASH would create a recursive kconfig
dependency on CRYPTO_HASH.  As a bonus, using a separate module also
allows the generic implementation to be omitted when unneeded.

These helper functions very closely match the ones I defined for
BLAKE2b, except the BLAKE2b ones didn't go in a separate module yet
because BLAKE2b isn't exposed through the library API yet.

Finally, use these new helper functions in the x86 implementation of
BLAKE2s.  (This part should be a separate patch, but unfortunately the
x86 implementation used the exact same function names like
"crypto_blake2s_update()", so it had to be updated at the same time.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/blake2s-glue.c    | 74 +++-----------------------
 crypto/Kconfig                    |  5 ++
 crypto/Makefile                   |  1 +
 crypto/blake2s_generic.c          | 79 ++++------------------------
 crypto/blake2s_helpers.c          | 87 +++++++++++++++++++++++++++++++
 include/crypto/internal/blake2s.h | 17 ++++++
 6 files changed, 126 insertions(+), 137 deletions(-)
 create mode 100644 crypto/blake2s_helpers.c

diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 4dcb2ee89efc9..1306b3272c77f 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -58,75 +58,15 @@ void blake2s_compress_arch(struct blake2s_state *state,
 }
 EXPORT_SYMBOL(blake2s_compress_arch);
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
+static int crypto_blake2s_update_x86(struct shash_desc *desc, const u8 *in,
+				     unsigned int inlen)
 {
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(tctx->key, key, keylen);
-	tctx->keylen = keylen;
-
-	return 0;
-}
-
-static int crypto_blake2s_init(struct shash_desc *desc)
-{
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const int outlen = crypto_shash_digestsize(desc->tfm);
-
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
-
-	return 0;
-}
-
-static int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
-				 unsigned int inlen)
-{
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return 0;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		blake2s_compress_arch(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		blake2s_compress_arch(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
-
-	return 0;
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_arch);
 }
 
-static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
+static int crypto_blake2s_final_x86(struct shash_desc *desc, u8 *out)
 {
-	struct blake2s_state *state = shash_desc_ctx(desc);
-
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	blake2s_compress_arch(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
-	memzero_explicit(state, sizeof(*state));
-
-	return 0;
+	return crypto_blake2s_final(desc, out, blake2s_compress_arch);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
@@ -141,8 +81,8 @@ static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
 		.digestsize		= digest_size,			\
 		.setkey			= crypto_blake2s_setkey,	\
 		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update,	\
-		.final			= crypto_blake2s_final,		\
+		.update			= crypto_blake2s_update_x86,	\
+		.final			= crypto_blake2s_final_x86,	\
 		.descsize		= sizeof(struct blake2s_state),	\
 	}
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a367fcfeb5d45..e3a51154ac0cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -681,6 +681,7 @@ config CRYPTO_BLAKE2B
 config CRYPTO_BLAKE2S
 	tristate "BLAKE2s digest algorithm"
 	select CRYPTO_LIB_BLAKE2S_GENERIC
+	select CRYPTO_BLAKE2S_HELPERS
 	select CRYPTO_HASH
 	help
 	  Implementation of cryptographic hash function BLAKE2s
@@ -696,11 +697,15 @@ config CRYPTO_BLAKE2S
 
 	  See https://blake2.net for further information.
 
+config CRYPTO_BLAKE2S_HELPERS
+	tristate
+
 config CRYPTO_BLAKE2S_X86
 	tristate "BLAKE2s digest algorithm (x86 accelerated version)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_BLAKE2S_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
+	select CRYPTO_BLAKE2S_HELPERS if CRYPTO_HASH
 
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50b..75f99ab82bfc2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -82,6 +82,7 @@ CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/b
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
 obj-$(CONFIG_CRYPTO_BLAKE2S) += blake2s_generic.o
+obj-$(CONFIG_CRYPTO_BLAKE2S_HELPERS) += blake2s_helpers.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index b89536c3671cf..ea2f1c6eb3231 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -1,84 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0 OR MIT
 /*
+ * shash interface to the generic implementation of BLAKE2s
+ *
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #include <crypto/internal/blake2s.h>
 #include <crypto/internal/hash.h>
-
-#include <linux/types.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
-{
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(tctx->key, key, keylen);
-	tctx->keylen = keylen;
-
-	return 0;
-}
-
-static int crypto_blake2s_init(struct shash_desc *desc)
-{
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const int outlen = crypto_shash_digestsize(desc->tfm);
-
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
-
-	return 0;
-}
-
-static int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
-				 unsigned int inlen)
+static int crypto_blake2s_update_generic(struct shash_desc *desc,
+					 const u8 *in, unsigned int inlen)
 {
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return 0;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		blake2s_compress_generic(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		blake2s_compress_generic(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
-
-	return 0;
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_generic);
 }
 
-static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
+static int crypto_blake2s_final_generic(struct shash_desc *desc, u8 *out)
 {
-	struct blake2s_state *state = shash_desc_ctx(desc);
-
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	blake2s_compress_generic(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
-	memzero_explicit(state, sizeof(*state));
-
-	return 0;
+	return crypto_blake2s_final(desc, out, blake2s_compress_generic);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
@@ -93,8 +32,8 @@ static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
 		.digestsize		= digest_size,			\
 		.setkey			= crypto_blake2s_setkey,	\
 		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update,	\
-		.final			= crypto_blake2s_final,		\
+		.update			= crypto_blake2s_update_generic, \
+		.final			= crypto_blake2s_final_generic,	\
 		.descsize		= sizeof(struct blake2s_state),	\
 	}
 
diff --git a/crypto/blake2s_helpers.c b/crypto/blake2s_helpers.c
new file mode 100644
index 0000000000000..0c3b9fcbd022c
--- /dev/null
+++ b/crypto/blake2s_helpers.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Helper functions for shash implementations of BLAKE2s.  The caller must
+ * provide a pointer to their blake2s_compress_t implementation.
+ *
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <crypto/internal/blake2s.h>
+#include <crypto/internal/hash.h>
+#include <linux/export.h>
+
+int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
+			  unsigned int keylen)
+{
+	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
+		return -EINVAL;
+
+	memcpy(tctx->key, key, keylen);
+	tctx->keylen = keylen;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_blake2s_setkey);
+
+int crypto_blake2s_init(struct shash_desc *desc)
+{
+	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	const int outlen = crypto_shash_digestsize(desc->tfm);
+
+	if (tctx->keylen)
+		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
+	else
+		blake2s_init(state, outlen);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_blake2s_init);
+
+int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen, blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
+
+	if (unlikely(!inlen))
+		return 0;
+	if (inlen > fill) {
+		memcpy(state->buf + state->buflen, in, fill);
+		(*compress)(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
+		state->buflen = 0;
+		in += fill;
+		inlen -= fill;
+	}
+	if (inlen > BLAKE2S_BLOCK_SIZE) {
+		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
+		/* Hash one less (full) block than strictly possible */
+		(*compress)(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
+		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+	}
+	memcpy(state->buf + state->buflen, in, inlen);
+	state->buflen += inlen;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_blake2s_update);
+
+int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
+			 blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	blake2s_set_lastblock(state);
+	memset(state->buf + state->buflen, 0,
+	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
+	(*compress)(state, state->buf, 1, state->buflen);
+	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
+	memcpy(out, state->h, state->outlen);
+	memzero_explicit(state, sizeof(*state));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_blake2s_final);
diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 6e376ae6b6b58..8c79af7662aa2 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -23,4 +23,21 @@ static inline void blake2s_set_lastblock(struct blake2s_state *state)
 	state->f[0] = -1;
 }
 
+typedef void (*blake2s_compress_t)(struct blake2s_state *state,
+				   const u8 *block, size_t nblocks, u32 inc);
+
+struct crypto_shash;
+struct shash_desc;
+
+int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
+			  unsigned int keylen);
+
+int crypto_blake2s_init(struct shash_desc *desc);
+
+int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen, blake2s_compress_t compress);
+
+int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
+			 blake2s_compress_t compress);
+
 #endif /* BLAKE2S_INTERNAL_H */
-- 
2.29.2

