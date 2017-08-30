From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - remove SGL end indicator when chaining
Date: Wed, 30 Aug 2017 18:59:07 +0200
Message-ID: <1913314.pET67Fvxje@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34524 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbdH3Q7V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 12:59:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SGL is MAX_SGL_ENTS + 1 in size. The last SG entry is used for the
chaining and is properly updated with the sg_chain invocation. During
the filling-in of the initial SG entries, sg_mark_end is called for each
SG entry. This is appropriate as long as no additional SGL is chained
with the current SGL. However, when a new SGL is chained and the last
SG entry is updated with sg_chain, the last but one entry still contains
the end marker from the sg_mark_end. This end marker must be removed as
otherwise a walk of the chained SGLs will cause a NULL pointer
dereference at the last but one SG entry, because sg_next will return
NULL.

Fixes: 8ff590903d5fc ("crypto: algif_skcipher - User-space interface
for skcipher operations")
CC: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 43839b00fe6c..62449a8f14ce 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -139,8 +139,10 @@ static int skcipher_alloc_sgl(struct sock *sk)
 		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
 		sgl->cur = 0;
 
-		if (sg)
+		if (sg) {
 			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+			sg_unmark_end(sg + (MAX_SGL_ENTS - 1));
+		}
 
 		list_add_tail(&sgl->list, &ctx->tsgl);
 	}
-- 
2.13.5
