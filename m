Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F8FC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C8221A49
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKLKUg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 05:20:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:56718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbfKLKUg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 05:20:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B026BB3E7;
        Tue, 12 Nov 2019 10:20:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1641EDA7AF; Tue, 12 Nov 2019 11:20:38 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/7] crypto: blake2b: merge _final implementation to callback
Date:   Tue, 12 Nov 2019 11:20:24 +0100
Message-Id: <c820ee486dd6d0e19e9ad52b6b2ac0d283164613.1573553665.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573553665.git.dsterba@suse.com>
References: <cover.1573553665.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

blake2b_final is called only once, merge it to the crypto API callback
and simplify. This avoids the temporary buffer and swaps the bytes of
internal buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 42 ++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 8dab65612a41..743905fabd65 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -276,25 +276,6 @@ static void blake2b_update(struct blake2b_state *S, const void *pin, size_t inle
 	}
 }
 
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
 struct digest_tfm_ctx {
 	u8 key[BLAKE2B_KEYBYTES];
 	unsigned int keylen;
@@ -338,12 +319,23 @@ static int digest_update(struct shash_desc *desc, const u8 *data,
 	return 0;
 }
 
-static int digest_final(struct shash_desc *desc, u8 *out)
+static int blake2b_final(struct shash_desc *desc, u8 *out)
 {
 	struct blake2b_state *state = shash_desc_ctx(desc);
 	const int digestsize = crypto_shash_digestsize(desc->tfm);
+	size_t i;
+
+	blake2b_increment_counter(state, state->buflen);
+	blake2b_set_lastblock(state);
+	/* Padding */
+	memset(state->buf + state->buflen, 0, BLAKE2B_BLOCKBYTES - state->buflen);
+	blake2b_compress(state, state->buf);
+
+	/* Avoid temporary buffer and switch the internal output to LE order */
+	for (i = 0; i < ARRAY_SIZE(state->h); i++)
+		__cpu_to_le64s(&state->h[i]);
 
-	blake2b_final(state, out, digestsize);
+	memcpy(out, state->h, digestsize);
 	return 0;
 }
 
@@ -360,7 +352,7 @@ static struct shash_alg blake2b_algs[] = {
 		.setkey			= digest_setkey,
 		.init			= digest_init,
 		.update			= digest_update,
-		.final			= digest_final,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-256",
@@ -374,7 +366,7 @@ static struct shash_alg blake2b_algs[] = {
 		.setkey			= digest_setkey,
 		.init			= digest_init,
 		.update			= digest_update,
-		.final			= digest_final,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-384",
@@ -388,7 +380,7 @@ static struct shash_alg blake2b_algs[] = {
 		.setkey			= digest_setkey,
 		.init			= digest_init,
 		.update			= digest_update,
-		.final			= digest_final,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}, {
 		.base.cra_name		= "blake2b-512",
@@ -402,7 +394,7 @@ static struct shash_alg blake2b_algs[] = {
 		.setkey			= digest_setkey,
 		.init			= digest_init,
 		.update			= digest_update,
-		.final			= digest_final,
+		.final			= blake2b_final,
 		.descsize		= sizeof(struct blake2b_state),
 	}
 };
-- 
2.23.0

