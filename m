From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 15/18] crypto: algif_skcipher - Load TX SG list after waiting
Date: Thu, 27 Oct 2016 17:29:48 +0300
Message-ID: <1477578591-28924-16-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0095.outbound.protection.outlook.com ([104.47.1.95]:14380
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934646AbcJ0SEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 14:04:40 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 4f0414e54e4d1893c6f08260693f8ef84c929293 upstream.

We need to load the TX SG list in sendmsg(2) after waiting for
incoming data, not before.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_skcipher.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 13fd26e..ea05c53 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -446,13 +446,6 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 		char __user *from = iov->iov_base;
 
 		while (seglen) {
-			sgl = list_first_entry(&ctx->tsgl,
-					       struct skcipher_sg_list, list);
-			sg = sgl->sg;
-
-			while (!sg->length)
-				sg++;
-
 			used = ctx->used;
 			if (!used) {
 				err = skcipher_wait_for_data(sk, flags);
@@ -474,6 +467,13 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			if (!used)
 				goto free;
 
+			sgl = list_first_entry(&ctx->tsgl,
+					       struct skcipher_sg_list, list);
+			sg = sgl->sg;
+
+			while (!sg->length)
+				sg++;
+
 			ablkcipher_request_set_crypt(&ctx->req, sg,
 						     ctx->rsgl.sg, used,
 						     ctx->iv);
-- 
2.7.3
