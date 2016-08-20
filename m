From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next v2] crypto: sun4i-ss - fix missing unlock on error in sun4i_hash()
Date: Sat, 20 Aug 2016 10:48:53 +0000
Message-ID: <1471690133-24396-1-git-send-email-weiyj.lk@gmail.com>
References: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34408 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbcHTKtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 06:49:07 -0400
Received: by mail-pa0-f65.google.com with SMTP id hh10so4810725pac.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Aug 2016 03:49:07 -0700 (PDT)
In-Reply-To: <1471560130-5265-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the missing unlock before return from function sun4i_hash()
in the error handling case.

Fixes: 477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
v1 -> v2: goto release_ss as LABBE Corentin's suggestion
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 2ee3b59..1afeb8e 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -245,7 +245,8 @@ int sun4i_hash(struct ahash_request *areq)
 		if (end > areq->nbytes || areq->nbytes - end > 63) {
 			dev_err(ss->dev, "ERROR: Bound error %u %u\n",
 				end, areq->nbytes);
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_ss;
 		}
 	} else {
 		/* Since we have the flag final, we can go up to modulo 4 */
