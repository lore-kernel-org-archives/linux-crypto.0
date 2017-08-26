From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 2/2] crypto: inside-secure - remove null check before kfree
Date: Sun, 27 Aug 2017 02:45:30 +0530
Message-ID: <1503782130-10137-3-git-send-email-himanshujha199640@gmail.com>
References: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Kfree on NULL pointer is a no-op and therefore checking is redundant.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3f81939..9c32bbb 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -308,10 +308,8 @@ static int safexcel_ahash_send(struct crypto_async_request *async, int ring,
 		ctx->base.cache_sz = 0;
 	}
 free_cache:
-	if (ctx->base.cache) {
-		kfree(ctx->base.cache);
-		ctx->base.cache = NULL;
-	}
+	kfree(ctx->base.cache);
+	ctx->base.cache = NULL;
 
 unlock:
 	spin_unlock_bh(&priv->ring[ring].egress_lock);
-- 
2.7.4
