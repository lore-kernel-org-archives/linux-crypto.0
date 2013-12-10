From: Marek Vasut <marex@denx.de>
Subject: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Tue, 10 Dec 2013 20:26:19 +0100
Message-ID: <1386703583-8386-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37912 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3LJT0f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Dec 2013 14:26:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When finishing the ahash request, the ahash_op_unaligned_done() will
call complete() on the request. Yet, this will not call the correct
complete callback. The correct complete callback was previously stored
in the requests' private data, as seen in ahash_op_unaligned(). This
patch restores the correct complete callback and .data field of the
request before calling complete() on it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-crypto@vger.kernel.org
---
 crypto/ahash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 793a27f..a92dc38 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -213,7 +213,10 @@ static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
 
 	ahash_op_unaligned_finish(areq, err);
 
-	complete(data, err);
+	areq->base.complete = complete;
+	areq->base.data = data;
+
+	complete(&areq->base, err);
 }
 
 static int ahash_op_unaligned(struct ahash_request *req,
-- 
1.8.4.3
