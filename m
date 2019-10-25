Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA9FCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289FB21D71
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571980555;
	bh=CoaXSd4+bZYirYs2jBvZfCJxAcmE/gD2wja69FpuzqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bVR/4LObFU1P8IhWI6Ow3DbZ2+ge6uhDB/mGniy65PIUkIFY7jQa3EcYlHxq7YUhl
	 KVG52vafFSXc4b92j8Af2BbRDCC9pCwGI+eHW4bQJ3eo4+w2o/LH2Rfw4dvABkbvMS
	 WcU3W4BxbwRV2norRqAczyKInuJbgAQtLtmBFlAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392734AbfJYFPy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbfJYFPy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 01:15:54 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B4720867;
        Fri, 25 Oct 2019 05:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571980552;
        bh=CoaXSd4+bZYirYs2jBvZfCJxAcmE/gD2wja69FpuzqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HFDkS8KMr6I3aHkJk2TcBw1XkatFGZrHC/zHvdqZUusy6B1FY/CAsQvsY61atR8eP
         rRWQr/LRmrQ0rA0n26u9S6l6SoNGpYjrEntAq5IwUr42W88k/H3pCaK/6tj75wpIIq
         Np5hoYtAHVZQ1K7xLBO3ouF5rc/SQnFm5Ny6bAFE=
Date:   Thu, 24 Oct 2019 22:15:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v7 1/2] crypto: add blake2b generic implementation
Message-ID: <20191025051550.GA103313@sol.localdomain>
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1571934170.git.dsterba@suse.com>
 <79e47ab2c559c974d950a238e9db909795b4268d.1571934170.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79e47ab2c559c974d950a238e9db909795b4268d.1571934170.git.dsterba@suse.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 24, 2019 at 06:28:31PM +0200, David Sterba wrote:
> The patch brings support of several BLAKE2 variants (2b with various
> digest lengths).  The keyed digest is supported, using tfm->setkey call.
> The in-tree user will be btrfs (for checksumming), we're going to use
> the BLAKE2b-256 variant.
> 
> The code is reference implementation taken from the official sources and
> modified in terms of kernel coding style (whitespace, comments, uintXX_t
> -> uXX types, removed unused prototypes and #ifdefs, removed testing
> code, changed secure_zero_memory -> memzero_explicit, used own helpers
> for unaligned reads/writes and rotations).
> 
> Further changes removed sanity checks of key length or output size,
> these values are verified in the crypto API callbacks or hardcoded in
> shash_alg and not exposed to users.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  crypto/Kconfig           |  17 ++
>  crypto/Makefile          |   1 +
>  crypto/blake2b_generic.c | 435 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 453 insertions(+)
>  create mode 100644 crypto/blake2b_generic.c
> 

This looks good enough now, though it would be nice to clean up some more of the
cruft that isn't actually needed and add a few of the optimizations from the
BLAKE2s code that is being proposed.  E.g. we could easily save 120 lines with
the following:

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 8dab65612a41..22179ae3c7b7 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -32,10 +32,7 @@
 
 enum blake2b_constant {
 	BLAKE2B_BLOCKBYTES    = 128,
-	BLAKE2B_OUTBYTES      = 64,
 	BLAKE2B_KEYBYTES      = 64,
-	BLAKE2B_SALTBYTES     = 16,
-	BLAKE2B_PERSONALBYTES = 16
 };
 
 struct blake2b_state {
@@ -44,25 +41,8 @@ struct blake2b_state {
 	u64      f[2];
 	u8       buf[BLAKE2B_BLOCKBYTES];
 	size_t   buflen;
-	size_t   outlen;
-	u8       last_node;
 };
 
-struct blake2b_param {
-	u8 digest_length;			/* 1 */
-	u8 key_length;				/* 2 */
-	u8 fanout;				/* 3 */
-	u8 depth;				/* 4 */
-	__le32 leaf_length;			/* 8 */
-	__le32 node_offset;			/* 12 */
-	__le32 xof_length;			/* 16 */
-	u8 node_depth;				/* 17 */
-	u8 inner_length;			/* 18 */
-	u8 reserved[14];			/* 32 */
-	u8 salt[BLAKE2B_SALTBYTES];		/* 48 */
-	u8 personal[BLAKE2B_PERSONALBYTES];	/* 64 */
-} __packed;
-
 static const u64 blake2b_IV[8] = {
 	0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
 	0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
@@ -85,18 +65,8 @@ static const u8 blake2b_sigma[12][16] = {
 	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 }
 };
 
-static void blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen);
-
-static void blake2b_set_lastnode(struct blake2b_state *S)
-{
-	S->f[1] = (u64)-1;
-}
-
 static void blake2b_set_lastblock(struct blake2b_state *S)
 {
-	if (S->last_node)
-		blake2b_set_lastnode(S);
-
 	S->f[0] = (u64)-1;
 }
 
@@ -106,81 +76,6 @@ static void blake2b_increment_counter(struct blake2b_state *S, const u64 inc)
 	S->t[1] += (S->t[0] < inc);
 }
 
-static void blake2b_init0(struct blake2b_state *S)
-{
-	size_t i;
-
-	memset(S, 0, sizeof(struct blake2b_state));
-
-	for (i = 0; i < 8; ++i)
-		S->h[i] = blake2b_IV[i];
-}
-
-/* init xors IV with input parameter block */
-static void blake2b_init_param(struct blake2b_state *S,
-			       const struct blake2b_param *P)
-{
-	const u8 *p = (const u8 *)(P);
-	size_t i;
-
-	blake2b_init0(S);
-
-	/* IV XOR ParamBlock */
-	for (i = 0; i < 8; ++i)
-		S->h[i] ^= get_unaligned_le64(p + sizeof(S->h[i]) * i);
-
-	S->outlen = P->digest_length;
-}
-
-static void blake2b_init(struct blake2b_state *S, size_t outlen)
-{
-	struct blake2b_param P;
-
-	P.digest_length = (u8)outlen;
-	P.key_length    = 0;
-	P.fanout        = 1;
-	P.depth         = 1;
-	P.leaf_length   = 0;
-	P.node_offset   = 0;
-	P.xof_length    = 0;
-	P.node_depth    = 0;
-	P.inner_length  = 0;
-	memset(P.reserved, 0, sizeof(P.reserved));
-	memset(P.salt,     0, sizeof(P.salt));
-	memset(P.personal, 0, sizeof(P.personal));
-	blake2b_init_param(S, &P);
-}
-
-static void blake2b_init_key(struct blake2b_state *S, size_t outlen,
-			     const void *key, size_t keylen)
-{
-	struct blake2b_param P;
-
-	P.digest_length = (u8)outlen;
-	P.key_length    = (u8)keylen;
-	P.fanout        = 1;
-	P.depth         = 1;
-	P.leaf_length   = 0;
-	P.node_offset   = 0;
-	P.xof_length    = 0;
-	P.node_depth    = 0;
-	P.inner_length  = 0;
-	memset(P.reserved, 0, sizeof(P.reserved));
-	memset(P.salt,     0, sizeof(P.salt));
-	memset(P.personal, 0, sizeof(P.personal));
-
-	blake2b_init_param(S, &P);
-
-	{
-		u8 block[BLAKE2B_BLOCKBYTES];
-
-		memset(block, 0, BLAKE2B_BLOCKBYTES);
-		memcpy(block, key, keylen);
-		blake2b_update(S, block, BLAKE2B_BLOCKBYTES);
-		memzero_explicit(block, BLAKE2B_BLOCKBYTES);
-	}
-}
-
 #define G(r,i,a,b,c,d)                                  \
 	do {                                            \
 		a = a + b + m[blake2b_sigma[r][2*i+0]]; \
@@ -247,103 +142,86 @@ static void blake2b_compress(struct blake2b_state *S,
 #undef G
 #undef ROUND
 
-static void blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)
-{
-	const u8 *in = (const u8 *)pin;
-
-	if (inlen > 0) {
-		size_t left = S->buflen;
-		size_t fill = BLAKE2B_BLOCKBYTES - left;
-
-		if (inlen > fill) {
-			S->buflen = 0;
-			/* Fill buffer */
-			memcpy(S->buf + left, in, fill);
-			blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
-			/* Compress */
-			blake2b_compress(S, S->buf);
-			in += fill;
-			inlen -= fill;
-			while (inlen > BLAKE2B_BLOCKBYTES) {
-				blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
-				blake2b_compress(S, in);
-				in += BLAKE2B_BLOCKBYTES;
-				inlen -= BLAKE2B_BLOCKBYTES;
-			}
-		}
-		memcpy(S->buf + S->buflen, in, inlen);
-		S->buflen += inlen;
-	}
-}
-
-static void blake2b_final(struct blake2b_state *S, void *out, size_t outlen)
-{
-	u8 buffer[BLAKE2B_OUTBYTES] = {0};
-	size_t i;
-
-	blake2b_increment_counter(S, S->buflen);
-	blake2b_set_lastblock(S);
-	/* Padding */
-	memset(S->buf + S->buflen, 0, BLAKE2B_BLOCKBYTES - S->buflen);
-	blake2b_compress(S, S->buf);
-
-	/* Output full hash to temp buffer */
-	for (i = 0; i < 8; ++i)
-		put_unaligned_le64(S->h[i], buffer + sizeof(S->h[i]) * i);
-
-	memcpy(out, buffer, S->outlen);
-	memzero_explicit(buffer, sizeof(buffer));
-}
-
-struct digest_tfm_ctx {
+struct blake2b_tfm_ctx {
 	u8 key[BLAKE2B_KEYBYTES];
 	unsigned int keylen;
 };
 
-static int digest_setkey(struct crypto_shash *tfm, const u8 *key,
-			 unsigned int keylen)
+static int blake2b_setkey(struct crypto_shash *tfm, const u8 *key,
+			  unsigned int keylen)
 {
-	struct digest_tfm_ctx *mctx = crypto_shash_ctx(tfm);
+	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
 	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	memcpy(mctx->key, key, keylen);
-	mctx->keylen = keylen;
-
+	memcpy(tctx->key, key, keylen);
+	tctx->keylen = keylen;
 	return 0;
 }
 
-static int digest_init(struct shash_desc *desc)
+static int blake2b_init(struct shash_desc *desc)
 {
-	struct digest_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
-	struct blake2b_state *state = shash_desc_ctx(desc);
-	const int digestsize = crypto_shash_digestsize(desc->tfm);
-
-	if (mctx->keylen == 0)
-		blake2b_init(state, digestsize);
-	else
-		blake2b_init_key(state, digestsize, mctx->key, mctx->keylen);
+	struct blake2b_state *S = shash_desc_ctx(desc);
+	const struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const unsigned int outlen = crypto_shash_digestsize(desc->tfm);
+
+	memset(S, 0, sizeof(*S));
+	memcpy(S->h, blake2b_IV, sizeof(S->h));
+	S->h[0] ^= 0x01010000 | tctx->keylen << 8 | outlen;
+	if (tctx->keylen) {
+		memcpy(S->buf, tctx->key, tctx->keylen);
+		S->buflen = BLAKE2B_BLOCKBYTES;
+	}
 	return 0;
 }
 
-static int digest_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
+static int blake2b_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen)
 {
-	struct blake2b_state *state = shash_desc_ctx(desc);
-
-	blake2b_update(state, data, length);
+	struct blake2b_state *S = shash_desc_ctx(desc);
+	size_t left = S->buflen;
+	size_t fill = BLAKE2B_BLOCKBYTES - left;
+
+	if (!inlen)
+		return 0;
+	if (inlen > fill) {
+		S->buflen = 0;
+		/* Fill buffer */
+		memcpy(S->buf + left, in, fill);
+		blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
+		/* Compress */
+		blake2b_compress(S, S->buf);
+		in += fill;
+		inlen -= fill;
+		while (inlen > BLAKE2B_BLOCKBYTES) {
+			blake2b_increment_counter(S, BLAKE2B_BLOCKBYTES);
+			blake2b_compress(S, in);
+			in += BLAKE2B_BLOCKBYTES;
+			inlen -= BLAKE2B_BLOCKBYTES;
+		}
+	}
+	memcpy(S->buf + S->buflen, in, inlen);
+	S->buflen += inlen;
 	return 0;
 }
 
-static int digest_final(struct shash_desc *desc, u8 *out)
+static int blake2b_final(struct shash_desc *desc, u8 *out)
 {
-	struct blake2b_state *state = shash_desc_ctx(desc);
-	const int digestsize = crypto_shash_digestsize(desc->tfm);
+	struct blake2b_state *S = shash_desc_ctx(desc);
+	const unsigned int outlen = crypto_shash_digestsize(desc->tfm);
+	size_t i;
 
-	blake2b_final(state, out, digestsize);
+	blake2b_increment_counter(S, S->buflen);
+	blake2b_set_lastblock(S);
+	/* Padding */
+	memset(S->buf + S->buflen, 0, BLAKE2B_BLOCKBYTES - S->buflen);
+	blake2b_compress(S, S->buf);
+	for (i = 0; i < 8; ++i)
+		__cpu_to_le64s(&S->h[i]);
+	memcpy(out, S->h, outlen);
 	return 0;
 }
 
@@ -354,13 +232,13 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_160_DIGEST_SIZE,
-		.setkey			= digest_setkey,
-		.init			= digest_init,
-		.update			= digest_update,
-		.final			= digest_final,
+		.setkey			= blake2b_setkey,
+		.init			= blake2b_init,
+		.update			= blake2b_update,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-256",
@@ -368,13 +246,13 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_256_DIGEST_SIZE,
-		.setkey			= digest_setkey,
-		.init			= digest_init,
-		.update			= digest_update,
-		.final			= digest_final,
+		.setkey			= blake2b_setkey,
+		.init			= blake2b_init,
+		.update			= blake2b_update,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-384",
@@ -382,13 +260,13 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_384_DIGEST_SIZE,
-		.setkey			= digest_setkey,
-		.init			= digest_init,
-		.update			= digest_update,
-		.final			= digest_final,
+		.setkey			= blake2b_setkey,
+		.init			= blake2b_init,
+		.update			= blake2b_update,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-512",
@@ -396,21 +274,19 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
-		.setkey			= digest_setkey,
-		.init			= digest_init,
-		.update			= digest_update,
-		.final			= digest_final,
+		.setkey			= blake2b_setkey,
+		.init			= blake2b_init,
+		.update			= blake2b_update,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}
 };
 
 static int __init blake2b_mod_init(void)
 {
-	BUILD_BUG_ON(sizeof(struct blake2b_param) != BLAKE2B_OUTBYTES);
-
 	return crypto_register_shashes(blake2b_algs, ARRAY_SIZE(blake2b_algs));
 }
 
-- 
2.23.0

