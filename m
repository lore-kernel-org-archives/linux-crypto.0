From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: algif - removed unneeded code
Date: Fri, 28 Nov 2014 10:40:45 -0800
Message-ID: <20141128184045.11444.46049.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19103 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaK1Snk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2014 13:43:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remover unneeded code.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 46a0758..1bf31bc 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -359,8 +359,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	err = 0;
 
 	ctx->more = msg->msg_flags & MSG_MORE;
-	if (!ctx->more && !list_empty(&ctx->tsgl))
-		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 
 unlock:
 	skcipher_data_wakeup(sk);
@@ -408,8 +406,6 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 
 done:
 	ctx->more = flags & MSG_MORE;
-	if (!ctx->more && !list_empty(&ctx->tsgl))
-		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 
 unlock:
 	skcipher_data_wakeup(sk);
