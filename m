From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 1/4] crypto: sha512 - Remove W (message schedule) from struct sha512_ctx
Date: Thu,  4 Dec 2008 01:18:09 +0100
Message-ID: <12283498932360-git-send-email-ken@codelabs.ch>
References: <12283498922490-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:40684 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYLDASR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 19:18:17 -0500
In-Reply-To: <12283498922490-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The message schedule W[80] is calculated anew when sha512_transform
is executed. Therefore it is local to that function and does not need
to be defined in struct sha512_ctx.
Note: the sha256 algorithm already does it this way.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/sha512_generic.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index bc36861..e0b0303 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -25,7 +25,6 @@ struct sha512_ctx {
 	u64 state[8];
 	u32 count[4];
 	u8 buf[128];
-	u64 W[80];
 };
 
 static inline u64 Ch(u64 x, u64 y, u64 z)
@@ -89,10 +88,10 @@ static inline void BLEND_OP(int I, u64 *W)
 }
 
 static void
-sha512_transform(u64 *state, u64 *W, const u8 *input)
+sha512_transform(u64 *state, const u8 *input)
 {
 	u64 a, b, c, d, e, f, g, h, t1, t2;
-
+	u64 W[80];
 	int i;
 
 	/* load the input */
@@ -132,6 +131,7 @@ sha512_transform(u64 *state, u64 *W, const u8 *input)
 
 	/* erase our data */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
+	memset(W, 0, 80 * sizeof(u64));
 }
 
 static void
@@ -187,10 +187,10 @@ sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 	/* Transform as many times as possible. */
 	if (len >= part_len) {
 		memcpy(&sctx->buf[index], data, part_len);
-		sha512_transform(sctx->state, sctx->W, sctx->buf);
+		sha512_transform(sctx->state, sctx->buf);
 
 		for (i = part_len; i + 127 < len; i+=128)
-			sha512_transform(sctx->state, sctx->W, &data[i]);
+			sha512_transform(sctx->state, &data[i]);
 
 		index = 0;
 	} else {
@@ -199,9 +199,6 @@ sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 
 	/* Buffer remaining input */
 	memcpy(&sctx->buf[index], &data[i], len - i);
