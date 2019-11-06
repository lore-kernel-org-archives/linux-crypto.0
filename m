Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=FUZZY_XPILL,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A72C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 13:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C77EF214D8
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 13:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfKFNsy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 08:48:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:32954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbfKFNsy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 08:48:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19E05B387;
        Wed,  6 Nov 2019 13:48:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CF982DA79A; Wed,  6 Nov 2019 14:48:58 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] crypto: blake2b: rename tfm context
Date:   Wed,  6 Nov 2019 14:48:31 +0100
Message-Id: <848741ecbafbe7c7be81fd9b3a8e4229a43c3eaf.1573047517.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573047517.git.dsterba@suse.com>
References: <cover.1573047517.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The TFM context can be renamed to a more appropriate name and the local
varaibles as well, using 'tctx' which seems to be more common than
'mctx'.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index b05dfc2724e8..38d49deceae6 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -137,7 +137,7 @@ static void blake2b_compress(struct blake2b_state *S,
 #undef G
 #undef ROUND
 
-struct digest_tfm_ctx {
+struct blake2b_tfm_ctx {
 	u8 key[BLAKE2B_KEYBYTES];
 	unsigned int keylen;
 };
@@ -145,22 +145,22 @@ struct digest_tfm_ctx {
 static int digest_setkey(struct crypto_shash *tfm, const u8 *key,
 			 unsigned int keylen)
 {
-	struct digest_tfm_ctx *mctx = crypto_shash_ctx(tfm);
+	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(tfm);
 
 	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	memcpy(mctx->key, key, keylen);
-	mctx->keylen = keylen;
+	memcpy(tctx->key, key, keylen);
+	tctx->keylen = keylen;
 
 	return 0;
 }
 
 static int blake2b_init(struct shash_desc *desc)
 {
-	struct digest_tfm_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	struct blake2b_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const int digestsize = crypto_shash_digestsize(desc->tfm);
 
@@ -168,14 +168,14 @@ static int blake2b_init(struct shash_desc *desc)
 	memcpy(state->h, blake2b_IV, sizeof(state->h));
 
 	/* Parameter block is all zeros except index 0, no xor for 1..7 */
-	state->h[0] ^= 0x01010000 | mctx->keylen << 8 | digestsize;
+	state->h[0] ^= 0x01010000 | tctx->keylen << 8 | digestsize;
 
-	if (mctx->keylen) {
+	if (tctx->keylen) {
 		/*
 		 * Prefill the buffer with the key, next call to _update or
 		 * _final will process it
 		 */
-		memcpy(state->buf, mctx->key, mctx->keylen);
+		memcpy(state->buf, tctx->key, tctx->keylen);
 		state->buflen = BLAKE2B_BLOCKBYTES;
 	}
 	return 0;
@@ -241,7 +241,7 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_160_DIGEST_SIZE,
 		.setkey			= digest_setkey,
@@ -255,7 +255,7 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_256_DIGEST_SIZE,
 		.setkey			= digest_setkey,
@@ -269,7 +269,7 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_384_DIGEST_SIZE,
 		.setkey			= digest_setkey,
@@ -283,7 +283,7 @@ static struct shash_alg blake2b_algs[] = {
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
-		.base.cra_ctxsize	= sizeof(struct digest_tfm_ctx),
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
 		.setkey			= digest_setkey,
-- 
2.23.0

