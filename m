From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH RESEND] crypto: sun4i-ss: Replace spinlock_bh by spin_lock_irq{save|restore}
Date: Wed, 23 Mar 2016 16:11:24 +0100
Message-ID: <1458745884-27798-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	stable <stable@vger.kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The current sun4i-ss driver could generate data corruption when ciphering/deciphering.
It occurs randomly on end of handled data.
No root cause have been found and the only way to remove it is to replace
all spin_lock_bh by their irq counterparts.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 7be3fbc..3830d7c 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -35,6 +35,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo; /* offset for in and out */
+	unsigned long flags;
 
 	if (areq->nbytes == 0)
 		return 0;
@@ -49,7 +50,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 		return -EINVAL;
 	}
 
-	spin_lock_bh(&ss->slock);
+	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
@@ -117,7 +118,7 @@ release_ss:
 	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
-	spin_unlock_bh(&ss->slock);
+	spin_unlock_irqrestore(&ss->slock, flags);
 	return err;
 }
 
@@ -149,6 +150,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	unsigned int ob = 0;	/* offset in buf */
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
+	unsigned long flags;
 
 	if (areq->nbytes == 0)
 		return 0;
@@ -181,7 +183,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	if (no_chunk == 1)
 		return sun4i_ss_opti_poll(areq);
 
-	spin_lock_bh(&ss->slock);
+	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
 		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
@@ -307,7 +309,7 @@ release_ss:
 	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
-	spin_unlock_bh(&ss->slock);
+	spin_unlock_irqrestore(&ss->slock, flags);
 
 	return err;
 }
-- 
2.7.3
