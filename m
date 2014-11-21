From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: algif - Mark sgl end at the end of data.
Date: Fri, 21 Nov 2014 09:14:06 -0800
Message-ID: <20141121171406.1147.31491.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53378 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbaKURRH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Nov 2014 12:17:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
algif_skcipher sends 127 sgl buffers for encryption regardless of how many
buffers acctually have data to process, where the few first with valid len
and the rest with zero len. This is not very eficient and may cause problems
when algs do something like this without checking the buff lenght:
for_each_sg(sgl, sg, sg_nents, i)
	sg_virt(sg)

This patch marks the last one with data as the last one to process.
Also removed some unneeded code.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 85e3bdb..e393c71 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -359,8 +359,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	err = 0;
 
 	ctx->more = msg->msg_flags & MSG_MORE;
-	if (!ctx->more && !list_empty(&ctx->tsgl))
-		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 
 unlock:
 	skcipher_data_wakeup(sk);
@@ -408,9 +406,6 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 
 done:
 	ctx->more = flags & MSG_MORE;
-	if (!ctx->more && !list_empty(&ctx->tsgl))
-		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
-
 unlock:
 	skcipher_data_wakeup(sk);
 	release_sock(sk);
@@ -469,6 +464,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			if (!used)
 				goto free;
 
+			sg_mark_end(&sg[sgl->cur - 1]);
 			ablkcipher_request_set_crypt(&ctx->req, sg,
 						     ctx->rsgl.sg, used,
 						     ctx->iv);
