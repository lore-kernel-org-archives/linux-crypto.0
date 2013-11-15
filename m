From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] crypto: fix potential NULL pointer dereference in skcipher_alloc_sgl()
Date: Fri, 15 Nov 2013 10:31:25 +0800
Message-ID: <5285877D.7020004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3KOCbg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Nov 2013 21:31:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

In skcipher_alloc_sgl(), there is a potential null pointer dereference
issue to retrieve the last item from ctx->tsgl list if the list is empty.

This patch fix it by checking if the list is empty or not at first.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 crypto/algif_skcipher.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a1c4f0a..bfa702e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -73,9 +73,10 @@ static int skcipher_alloc_sgl(struct sock *sk)
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg = NULL;
 
-	sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
-	if (!list_empty(&ctx->tsgl))
+	if (!list_empty(&ctx->tsgl)) {
+		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 		sg = sgl->sg;
+	}
 
 	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
 		sgl = sock_kmalloc(sk, sizeof(*sgl) +
-- 
1.8.3.2
