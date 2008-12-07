From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 1/2 v4] crypto: sha512 - Move message schedule W[80] to static percpu area
Date: Sun,  7 Dec 2008 23:17:28 +0100
Message-ID: <12286882501412-git-send-email-ken@codelabs.ch>
References: <20081207113302.GB13736@gondor.apana.org.au>
 <1228688249887-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:42644 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYLGWRd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 17:17:33 -0500
In-Reply-To: <1228688249887-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The message schedule W (u64[80]) is too big for the stack. In order
for this algorithm to be used with shash it is moved to a static
percpu area.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/sha512_generic.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index bc36861..cb85516 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -18,16 +18,17 @@
 #include <linux/crypto.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-
+#include <linux/percpu.h>
 #include <asm/byteorder.h>
 
 struct sha512_ctx {
 	u64 state[8];
 	u32 count[4];
 	u8 buf[128];
-	u64 W[80];
 };
 
+static DEFINE_PER_CPU(u64[80], msg_schedule);
+
 static inline u64 Ch(u64 x, u64 y, u64 z)
 {
         return z ^ (x & (y ^ z));
@@ -89,11 +90,12 @@ static inline void BLEND_OP(int I, u64 *W)
 }
 
 static void
-sha512_transform(u64 *state, u64 *W, const u8 *input)
+sha512_transform(u64 *state, const u8 *input)
 {
 	u64 a, b, c, d, e, f, g, h, t1, t2;
 
 	int i;
+	u64 *W = get_cpu_var(msg_schedule);
 
 	/* load the input */
         for (i = 0; i < 16; i++)
@@ -132,6 +134,8 @@ sha512_transform(u64 *state, u64 *W, const u8 *input)
 
 	/* erase our data */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
+	memset(W, 0, sizeof(__get_cpu_var(msg_schedule)));
+	put_cpu_var(msg_schedule);
 }
 
 static void
@@ -187,10 +191,10 @@ sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
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
@@ -199,9 +203,6 @@ sha512_update(struct crypto_tfm *tfm, const u8 *data, unsigned int len)
 
 	/* Buffer remaining input */
 	memcpy(&sctx->buf[index], &data[i], len - i);
