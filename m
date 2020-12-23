Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BA5C433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3472070B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgLWIOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbgLWIOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA21C224BE;
        Wed, 23 Dec 2020 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711176;
        bh=2Mk6yVDnK8isqT8WqVj7WnmT/hEVWvBlhb17m29fzDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyvGYO50LAIkC6en4T6NgL8bCtRol2wPUXmW8YtS5O4t3A97KVXMp6Z/ghjuTsodD
         +w5JvJ4XxL91j4HtHRG0+PwmLKM21ZBb/jGaj9pB+xJPfDKGr0Su4as9ABL5EEsUS1
         G8zDs9ewAIPBSlmcHLz1S3+7+yqs0W+eOmbb4OjNmZoGR/SB4WH34QUt6+3+jTt2/X
         juTKeTGT+6q+7bQYWHSyNhxRjzRiBGZaZRfDw/Gi+k6Tk3SzAwbROqPZNb+OWMwMzP
         LUC2V10r3I+nNCskQbr8ZoXFCF3rOeKwyQLqAqxUaK5hMkPm3Mb9Sr6gnwFp4l0uDw
         cQiaQ5YkW4gpA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 06/14] crypto: blake2s - optimize blake2s initialization
Date:   Wed, 23 Dec 2020 00:09:55 -0800
Message-Id: <20201223081003.373663-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If no key was provided, then don't waste time initializing the block
buffer, as its initial contents won't be used.

Also, make crypto_blake2s_init() and blake2s() call a single internal
function __blake2s_init() which treats the key as optional, rather than
conditionally calling blake2s_init() or blake2s_init_key().  This
reduces the compiled code size, as previously both blake2s_init() and
blake2s_init_key() were being inlined into these two callers, except
when the key size passed to blake2s() was a compile-time constant.

These optimizations aren't that significant for BLAKE2s.  However, the
equivalent optimizations will be more significant for BLAKE2b, as
everything is twice as big in BLAKE2b.  And it's good to keep things
consistent rather than making optimizations for BLAKE2b but not BLAKE2s.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/blake2s.h          | 53 ++++++++++++++++---------------
 include/crypto/internal/blake2s.h |  5 +--
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index b471deac28ff8..734ed22b7a6aa 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -43,29 +43,34 @@ enum blake2s_iv {
 	BLAKE2S_IV7 = 0x5BE0CD19UL,
 };
 
-void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
-void blake2s_final(struct blake2s_state *state, u8 *out);
-
-static inline void blake2s_init_param(struct blake2s_state *state,
-				      const u32 param)
+static inline void __blake2s_init(struct blake2s_state *state, size_t outlen,
+				  const void *key, size_t keylen)
 {
-	*state = (struct blake2s_state){{
-		BLAKE2S_IV0 ^ param,
-		BLAKE2S_IV1,
-		BLAKE2S_IV2,
-		BLAKE2S_IV3,
-		BLAKE2S_IV4,
-		BLAKE2S_IV5,
-		BLAKE2S_IV6,
-		BLAKE2S_IV7,
-	}};
+	state->h[0] = BLAKE2S_IV0 ^ (0x01010000 | keylen << 8 | outlen);
+	state->h[1] = BLAKE2S_IV1;
+	state->h[2] = BLAKE2S_IV2;
+	state->h[3] = BLAKE2S_IV3;
+	state->h[4] = BLAKE2S_IV4;
+	state->h[5] = BLAKE2S_IV5;
+	state->h[6] = BLAKE2S_IV6;
+	state->h[7] = BLAKE2S_IV7;
+	state->t[0] = 0;
+	state->t[1] = 0;
+	state->f[0] = 0;
+	state->f[1] = 0;
+	state->buflen = 0;
+	state->outlen = outlen;
+	if (keylen) {
+		memcpy(state->buf, key, keylen);
+		memset(&state->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen);
+		state->buflen = BLAKE2S_BLOCK_SIZE;
+	}
 }
 
 static inline void blake2s_init(struct blake2s_state *state,
 				const size_t outlen)
 {
-	blake2s_init_param(state, 0x01010000 | outlen);
-	state->outlen = outlen;
+	__blake2s_init(state, outlen, NULL, 0);
 }
 
 static inline void blake2s_init_key(struct blake2s_state *state,
@@ -75,12 +80,12 @@ static inline void blake2s_init_key(struct blake2s_state *state,
 	WARN_ON(IS_ENABLED(DEBUG) && (!outlen || outlen > BLAKE2S_HASH_SIZE ||
 		!key || !keylen || keylen > BLAKE2S_KEY_SIZE));
 
-	blake2s_init_param(state, 0x01010000 | keylen << 8 | outlen);
-	memcpy(state->buf, key, keylen);
-	state->buflen = BLAKE2S_BLOCK_SIZE;
-	state->outlen = outlen;
+	__blake2s_init(state, outlen, key, keylen);
 }
 
+void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
+void blake2s_final(struct blake2s_state *state, u8 *out);
+
 static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
 			   const size_t outlen, const size_t inlen,
 			   const size_t keylen)
@@ -91,11 +96,7 @@ static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
 		outlen > BLAKE2S_HASH_SIZE || keylen > BLAKE2S_KEY_SIZE ||
 		(!key && keylen)));
 
-	if (keylen)
-		blake2s_init_key(&state, outlen, key, keylen);
-	else
-		blake2s_init(&state, outlen);
-
+	__blake2s_init(&state, outlen, key, keylen);
 	blake2s_update(&state, in, inlen);
 	blake2s_final(&state, out);
 }
diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 2ea0a8f5e7f41..867ef3753f5c1 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -93,10 +93,7 @@ static inline int crypto_blake2s_init(struct shash_desc *desc)
 	struct blake2s_state *state = shash_desc_ctx(desc);
 	unsigned int outlen = crypto_shash_digestsize(desc->tfm);
 
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
+	__blake2s_init(state, outlen, tctx->key, tctx->keylen);
 	return 0;
 }
 
-- 
2.29.2

