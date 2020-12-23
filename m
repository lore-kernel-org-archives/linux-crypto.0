Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2810CC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE43224B0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727712AbgLWINg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgLWINg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:13:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCD62076D;
        Wed, 23 Dec 2020 08:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711175;
        bh=b6+wc7dgRM5d8Iyuv0PHYC4QdSJRATl+ajSSE/yxgHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRa2zcMw6Rm3uDgBsMUwzZH+xzMA7oJbWzMAHDqbnjsjtDxbsJphlhG7V6I0+Z0UY
         tpN2je5lhjEp+cvK49vFX+iEEna4bEBxYO19XVUOFQ1mjF3pejOqfRK11nLxcb/WGx
         J6mR468qOnvJK9VCgorYeKWYsEw3AIiEQc1Wfl9EdHMg7W37kvvbqz2aeGdPdP3Ulf
         UMU9NaDuh5fUIqqM1/Kxeuf3q+Ew8H2mZwSbx6Lbt2EeJ4JgbuBKcyIwCUvwaoV4p0
         dyGoLp8q6APyFZ4+pCn1opbF4JFTNeRUm6G6BQ36JgdK1ONwcwNcDKnjzpezJN901E
         4w5WZrKuAQleA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 04/14] crypto: blake2s - move update and final logic to internal/blake2s.h
Date:   Wed, 23 Dec 2020 00:09:53 -0800
Message-Id: <20201223081003.373663-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Move most of blake2s_update() and blake2s_final() into new inline
functions __blake2s_update() and __blake2s_final() in
include/crypto/internal/blake2s.h so that this logic can be shared by
the shash helper functions.  This will avoid duplicating this logic
between the library and shash implementations.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/blake2s.h | 41 ++++++++++++++++++++++++++
 lib/crypto/blake2s.c              | 48 ++++++-------------------------
 2 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 6e376ae6b6b58..42deba4b8ceef 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -4,6 +4,7 @@
 #define BLAKE2S_INTERNAL_H
 
 #include <crypto/blake2s.h>
+#include <linux/string.h>
 
 struct blake2s_tfm_ctx {
 	u8 key[BLAKE2S_KEY_SIZE];
@@ -23,4 +24,44 @@ static inline void blake2s_set_lastblock(struct blake2s_state *state)
 	state->f[0] = -1;
 }
 
+typedef void (*blake2s_compress_t)(struct blake2s_state *state,
+				   const u8 *block, size_t nblocks, u32 inc);
+
+static inline void __blake2s_update(struct blake2s_state *state,
+				    const u8 *in, size_t inlen,
+				    blake2s_compress_t compress)
+{
+	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
+
+	if (unlikely(!inlen))
+		return;
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
+}
+
+static inline void __blake2s_final(struct blake2s_state *state, u8 *out,
+				   blake2s_compress_t compress)
+{
+	blake2s_set_lastblock(state);
+	memset(state->buf + state->buflen, 0,
+	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
+	(*compress)(state, state->buf, 1, state->buflen);
+	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
+	memcpy(out, state->h, state->outlen);
+}
+
 #endif /* BLAKE2S_INTERNAL_H */
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 6a4b6b78d630f..c64ac8bfb6a97 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -15,55 +15,23 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/bug.h>
-#include <asm/unaligned.h>
+
+#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S)
+#  define blake2s_compress blake2s_compress_arch
+#else
+#  define blake2s_compress blake2s_compress_generic
+#endif
 
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, state->buf, 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, state->buf, 1,
-						 BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, in, nblocks - 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, in, nblocks - 1,
-						 BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
+	__blake2s_update(state, in, inlen, blake2s_compress);
 }
 EXPORT_SYMBOL(blake2s_update);
 
 void blake2s_final(struct blake2s_state *state, u8 *out)
 {
 	WARN_ON(IS_ENABLED(DEBUG) && !out);
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-		blake2s_compress_arch(state, state->buf, 1, state->buflen);
-	else
-		blake2s_compress_generic(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
+	__blake2s_final(state, out, blake2s_compress);
 	memzero_explicit(state, sizeof(*state));
 }
 EXPORT_SYMBOL(blake2s_final);
-- 
2.29.2

