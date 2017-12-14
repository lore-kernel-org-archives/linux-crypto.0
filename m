From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 04/17] crypto: inside-secure - comment the caching function
Date: Thu, 14 Dec 2017 15:26:46 +0100
Message-ID: <20171214142659.16987-5-antoine.tenart@free-electrons.com>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36758 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753127AbdLNOaE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:04 -0500
In-Reply-To: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cosmetic patch adding a few comments to the ahash caching function to
understand easily what calculations are made in the functions; and how
the function is working.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ac922b91b2d7..e53e6b2331db 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -484,13 +484,23 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	return 0;
 }
 
+/* safexcel_ahash_cache: cache data until at least one request can be sent to
+ * the engine, aka. when there is at least 1 block size in the pipe.
+ */
 static int safexcel_ahash_cache(struct ahash_request *areq)
 {
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
 	int queued, cache_len;
 
+	/* cache_len: everyting accepted by the driver but not sent yet,
+	 * tot sz handled by update() - last req sz - tot sz handled by send()
+	 */
 	cache_len = req->len - areq->nbytes - req->processed;
+	/* queued: everything accepted by the driver which will be handled by
+	 * the next send() calls.
+	 * tot sz handled by update() - tot sz handled by send()
+	 */
 	queued = req->len - req->processed;
 
 	/*
-- 
2.14.3
