Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6298EC4332E
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4982A2070B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgLWIOR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbgLWIOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3E0207D2;
        Wed, 23 Dec 2020 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711175;
        bh=WKu9KmHZC5G9NukKoENOJnSDAufpaL5SSKOah6FCBwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8GePN2uB3p2OU8kKCvb9acrjfwUDhc9Px6iQRG267EudQrUobwiSmqxl2rs+jR7h
         zuY7RVcLV9U1EcI4JJoy0rnOGBw1xXvwXfsIVFRzoaJkOtdH6hg/oqJ3pRk/9mJkcL
         asdSkhODZiuVcxKWfcsLM8v2atxSP52nisrrkZMU37do8INWsMI7cZEWOVX5iiGX19
         s9QAiPeULcmxAev6wCMhEwCDzF2eC5qG6yKh0l0mkY6tMiGAYfasQ8CAXdugJ3So/w
         5yFxbt1XRB/EUJUfJDkSS6l0ZoDFgMPvSwldxe3UcH8d6zpcQT5nhgSKIThYajnH11
         EH6YrKrom79BA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 05/14] crypto: blake2s - share the "shash" API boilerplate code
Date:   Wed, 23 Dec 2020 00:09:54 -0800
Message-Id: <20201223081003.373663-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add helper functions for shash implementations of BLAKE2s to
include/crypto/internal/blake2s.h, taking advantage of
__blake2s_update() and __blake2s_final() that were added by the previous
patch to share more code between the library and shash implementations.

crypto_blake2s_setkey() and crypto_blake2s_init() are usable as
shash_alg::setkey and shash_alg::init directly, while
crypto_blake2s_update() and crypto_blake2s_final() take an extra
'blake2s_compress_t' function pointer parameter.  This allows the
implementation of the compression function to be overridden, which is
the only part that optimized implementations really care about.

The new functions are inline functions (similar to those in sha1_base.h,
sha256_base.h, and sm3_base.h) because this avoids needing to add a new
module blake2s_helpers.ko, they aren't *too* long, and this avoids
indirect calls which are expensive these days.  Note that they can't go
in blake2s_generic.ko, as that would require selecting CRYPTO_BLAKE2S
from CRYPTO_BLAKE2S_X86, which would cause a recursive dependency.

Finally, use these new helper functions in the x86 implementation of
BLAKE2s.  (This part should be a separate patch, but unfortunately the
x86 implementation used the exact same function names like
"crypto_blake2s_update()", so it had to be updated at the same time.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/blake2s-glue.c    | 74 +++---------------------------
 crypto/blake2s_generic.c          | 76 ++++---------------------------
 include/crypto/internal/blake2s.h | 65 ++++++++++++++++++++++++--
 3 files changed, 76 insertions(+), 139 deletions(-)

diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 4dcb2ee89efc9..a40365ab301ee 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -58,75 +58,15 @@ void blake2s_compress_arch(struct blake2s_state *state,
 }
 EXPORT_SYMBOL(blake2s_compress_arch);
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
+static int crypto_blake2s_update_x86(struct shash_desc *desc,
+				     const u8 *in, unsigned int inlen)
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
 
diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index b89536c3671cf..72fe480f9bd67 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR MIT
 /*
+ * shash interface to the generic implementation of BLAKE2s
+ *
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
@@ -10,75 +12,15 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
+static int crypto_blake2s_update_generic(struct shash_desc *desc,
+					 const u8 *in, unsigned int inlen)
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
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_generic);
 }
 
-static int crypto_blake2s_init(struct shash_desc *desc)
+static int crypto_blake2s_final_generic(struct shash_desc *desc, u8 *out)
 {
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
-}
-
-static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
-{
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
@@ -93,8 +35,8 @@ static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
 		.digestsize		= digest_size,			\
 		.setkey			= crypto_blake2s_setkey,	\
 		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update,	\
-		.final			= crypto_blake2s_final,		\
+		.update			= crypto_blake2s_update_generic, \
+		.final			= crypto_blake2s_final_generic,	\
 		.descsize		= sizeof(struct blake2s_state),	\
 	}
 
diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 42deba4b8ceef..2ea0a8f5e7f41 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -1,16 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Helper functions for BLAKE2s implementations.
+ * Keep this in sync with the corresponding BLAKE2b header.
+ */
 
 #ifndef BLAKE2S_INTERNAL_H
 #define BLAKE2S_INTERNAL_H
 
 #include <crypto/blake2s.h>
+#include <crypto/internal/hash.h>
 #include <linux/string.h>
 
-struct blake2s_tfm_ctx {
-	u8 key[BLAKE2S_KEY_SIZE];
-	unsigned int keylen;
-};
-
 void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
 			      size_t nblocks, const u32 inc);
 
@@ -27,6 +27,8 @@ static inline void blake2s_set_lastblock(struct blake2s_state *state)
 typedef void (*blake2s_compress_t)(struct blake2s_state *state,
 				   const u8 *block, size_t nblocks, u32 inc);
 
+/* Helper functions for BLAKE2s shared by the library and shash APIs */
+
 static inline void __blake2s_update(struct blake2s_state *state,
 				    const u8 *in, size_t inlen,
 				    blake2s_compress_t compress)
@@ -64,4 +66,57 @@ static inline void __blake2s_final(struct blake2s_state *state, u8 *out,
 	memcpy(out, state->h, state->outlen);
 }
 
+/* Helper functions for shash implementations of BLAKE2s */
+
+struct blake2s_tfm_ctx {
+	u8 key[BLAKE2S_KEY_SIZE];
+	unsigned int keylen;
+};
+
+static inline int crypto_blake2s_setkey(struct crypto_shash *tfm,
+					const u8 *key, unsigned int keylen)
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
+
+static inline int crypto_blake2s_init(struct shash_desc *desc)
+{
+	const struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	unsigned int outlen = crypto_shash_digestsize(desc->tfm);
+
+	if (tctx->keylen)
+		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
+	else
+		blake2s_init(state, outlen);
+	return 0;
+}
+
+static inline int crypto_blake2s_update(struct shash_desc *desc,
+					const u8 *in, unsigned int inlen,
+					blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	__blake2s_update(state, in, inlen, compress);
+	return 0;
+}
+
+static inline int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
+				       blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	__blake2s_final(state, out, compress);
+	return 0;
+}
+
 #endif /* BLAKE2S_INTERNAL_H */
-- 
2.29.2

