Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6258EC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41B12222C1
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKLKUv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 05:20:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:57376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727183AbfKLKUv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 05:20:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA194B4EF;
        Tue, 12 Nov 2019 10:20:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3B90ADA7AF; Tue, 12 Nov 2019 11:20:51 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 6/7] crypto: blake2b: merge _update to api callback
Date:   Tue, 12 Nov 2019 11:20:29 +0100
Message-Id: <1a1f60e343ce6658d1528d7f983f91a55a28e4aa.1573553665.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573553665.git.dsterba@suse.com>
References: <cover.1573553665.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that there's only one call to blake2b_update, we can merge it to the
callback and simplify. The empty input check is split and the rest of
code un-indented.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 66 ++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 463ac597ef04..2c756a7dcc21 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -137,35 +137,6 @@ static void blake2b_compress(struct blake2b_state *S,
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
 struct digest_tfm_ctx {
 	u8 key[BLAKE2B_KEYBYTES];
 	unsigned int keylen;
@@ -210,12 +181,35 @@ static int blake2b_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int digest_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
+static int blake2b_update(struct shash_desc *desc, const u8 *in,
+			  unsigned int inlen)
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
+	const size_t left = state->buflen;
+	const size_t fill = BLAKE2B_BLOCKBYTES - left;
+
+	if (!inlen)
+		return 0;
+
+	if (inlen > fill) {
+		state->buflen = 0;
+		/* Fill buffer */
+		memcpy(state->buf + left, in, fill);
+		blake2b_increment_counter(state, BLAKE2B_BLOCKBYTES);
+		/* Compress */
+		blake2b_compress(state, state->buf);
+		in += fill;
+		inlen -= fill;
+		while (inlen > BLAKE2B_BLOCKBYTES) {
+			blake2b_increment_counter(state, BLAKE2B_BLOCKBYTES);
+			blake2b_compress(state, in);
+			in += BLAKE2B_BLOCKBYTES;
+			inlen -= BLAKE2B_BLOCKBYTES;
+		}
+	}
+	memcpy(state->buf + state->buflen, in, inlen);
+	state->buflen += inlen;
 
-	blake2b_update(state, data, length);
 	return 0;
 }
 
@@ -252,7 +246,7 @@ static struct shash_alg blake2b_algs[] = {
 		.digestsize		= BLAKE2B_160_DIGEST_SIZE,
 		.setkey			= digest_setkey,
 		.init			= blake2b_init,
-		.update			= digest_update,
+		.update			= blake2b_update,
 		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
@@ -266,7 +260,7 @@ static struct shash_alg blake2b_algs[] = {
 		.digestsize		= BLAKE2B_256_DIGEST_SIZE,
 		.setkey			= digest_setkey,
 		.init			= blake2b_init,
-		.update			= digest_update,
+		.update			= blake2b_update,
 		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
@@ -280,7 +274,7 @@ static struct shash_alg blake2b_algs[] = {
 		.digestsize		= BLAKE2B_384_DIGEST_SIZE,
 		.setkey			= digest_setkey,
 		.init			= blake2b_init,
-		.update			= digest_update,
+		.update			= blake2b_update,
 		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
@@ -294,7 +288,7 @@ static struct shash_alg blake2b_algs[] = {
 		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
 		.setkey			= digest_setkey,
 		.init			= blake2b_init,
-		.update			= digest_update,
+		.update			= blake2b_update,
 		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}
-- 
2.23.0

