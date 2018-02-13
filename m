From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 6/8] crypto: inside-secure - fix the invalidation step during cra_exit
Date: Tue, 13 Feb 2018 09:26:55 +0100
Message-ID: <20180213082657.4759-7-antoine.tenart@bootlin.com>
References: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44280 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933682AbeBMIaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:22 -0500
In-Reply-To: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When exiting a transformation, the cra_exit() helper is called in each
driver providing one. The Inside Secure SafeXcel driver has one, which
is responsible of freeing some areas and of sending one invalidation
request to the crypto engine, to invalidate the context that was used
during the transformation.

We could see in some setups (when lots of transformations were being
used with a short lifetime, and hence lots of cra_exit() calls) NULL
pointer dereferences and other weird issues. All these issues were
coming from accessing the tfm context.

The issue is the invalidation request completion is checked using a
wait_for_completion_interruptible() call in both the cipher and hash
cra_exit() helpers. In some cases this was interrupted while the
invalidation request wasn't processed yet. And then cra_exit() returned,
and its caller was freeing the tfm instance. Only then the request was
being handled by the SafeXcel driver, which lead to the said issues.

This patch fixes this by using wait_for_completion() calls in these
specific cases.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 63a8768ed2ae..17a7725a6f6d 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -456,7 +456,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 	queue_work(priv->ring[ring].workqueue,
 		   &priv->ring[ring].work_data.work);
 
-	wait_for_completion_interruptible(&result.completion);
+	wait_for_completion(&result.completion);
 
 	if (result.error) {
 		dev_warn(priv->dev,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 2951101e1831..43e94cd59c86 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -493,7 +493,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	queue_work(priv->ring[ring].workqueue,
 		   &priv->ring[ring].work_data.work);
 
-	wait_for_completion_interruptible(&result.completion);
+	wait_for_completion(&result.completion);
 
 	if (result.error) {
 		dev_warn(priv->dev, "hash: completion error (%d)\n",
-- 
2.14.3
