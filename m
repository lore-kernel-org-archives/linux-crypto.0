From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] crypto: algif_skcipher: replace sg++ with sg_next()
Date: Wed,  4 May 2016 00:28:08 +0530
Message-ID: <1462301939-23578-1-git-send-email-falakreyaz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Never use sg++, always use sg = sg_next(sg). Scatterlist entries can
be combined if the memory is contiguous but sg++ won't know about
that. It sure would run on the slower side.
But regardless, sg++ should never be used, only sg_next is safe.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 crypto/algif_skcipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 28556fc..a668867 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -489,7 +489,7 @@ static int skcipher_all_sg_nents(struct skcipher_ctx *ctx)
 		sg = sgl->sg;
 
 		while (!sg->length)
-			sg++;
+			sg = sg_next(sg);
 
 		nents += sg_nents(sg);
 	}
@@ -553,7 +553,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 		sg = sgl->sg;
 
 		while (!sg->length)
-			sg++;
+			sg = sg_next(sg);
 
 		used = min_t(unsigned long, ctx->used,
 			     iov_iter_count(&msg->msg_iter));
@@ -676,7 +676,7 @@ static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
 		sg = sgl->sg;
 
 		while (!sg->length)
-			sg++;
+			sg = sg_next(sg);
 
 		skcipher_request_set_crypt(&ctx->req, sg, ctx->rsgl.sg, used,
 					   ctx->iv);
-- 
1.9.1
