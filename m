From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: [PATCH] crypto: rockchip/crypto - fix possible deadlock
Date: Sat, 28 Nov 2015 01:48:53 +0100
Message-ID: <2330117.Be8JzFqibx@diego>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Zain Wang <zain.wang@rock-chips.com>, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:52182 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbbK1AtF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 19:49:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lockdep warns about a possible deadlock resulting from the use of regular
spin_locks:

=================================
[ INFO: inconsistent lock state ]
4.4.0-rc2+ #2724 Not tainted
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/0/3 [HC0[0]:SC1[1]:HE1:SE0] takes:
(&(&crypto_info->lock)->rlock){+.?...}, at: [<bf14a65c>] rk_crypto_tasklet_cb+0x24/0xb4 [rk_crypto]
{SOFTIRQ-ON-W} state was registered at:
  [<c007f4ac>] lock_acquire+0x178/0x218
  [<c0759bac>] _raw_spin_lock+0x54/0x64
  [<bf14af88>] rk_handle_req+0x7c/0xbc [rk_crypto]
  [<bf14b040>] rk_des_ecb_encrypt+0x2c/0x30 [rk_crypto]
  [<bf14b05c>] rk_aes_ecb_encrypt+0x18/0x1c [rk_crypto]
  [<c028c820>] skcipher_encrypt_ablkcipher+0x64/0x68
  [<c0290770>] __test_skcipher+0x2a8/0x8dc
  [<c0292e94>] test_skcipher+0x38/0xc4
  [<c0292fb0>] alg_test_skcipher+0x90/0xb0
  [<c0292158>] alg_test+0x1e8/0x280
  [<c028f6f4>] cryptomgr_test+0x34/0x54
  [<c004bbe8>] kthread+0xf4/0x10c
  [<c0010010>] ret_from_fork+0x14/0x24
irq event stamp: 10672
hardirqs last  enabled at (10672): [<c002fac8>] tasklet_action+0x48/0x104
hardirqs last disabled at (10671): [<c002faa0>] tasklet_action+0x20/0x104
softirqs last  enabled at (10658): [<c002ef84>] __do_softirq+0x358/0x49c
softirqs last disabled at (10669): [<c002f108>] run_ksoftirqd+0x40/0x80

other info that might help us debug this:
Possible unsafe locking scenario:

    CPU0
    ----
  lock(&(&crypto_info->lock)->rlock);
  <Interrupt>
    lock(&(&crypto_info->lock)->rlock);

 *** DEADLOCK ***

Fix this by moving to irq-disabling spinlocks.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/crypto/rockchip/rk3288_crypto.c            | 10 ++++++----
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 6b72f8d..fb7b7dc 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -169,9 +169,10 @@ static irqreturn_t rk_crypto_irq_handle(int irq, void *dev_id)
 {
 	struct rk_crypto_info *dev  = platform_get_drvdata(dev_id);
 	u32 interrupt_status;
+	unsigned long flags;
 	int err = 0;
 
-	spin_lock(&dev->lock);
+	spin_lock_irqsave(&dev->lock, flags);
 	interrupt_status = CRYPTO_READ(dev, RK_CRYPTO_INTSTS);
 	CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, interrupt_status);
 	if (interrupt_status & 0x0a) {
@@ -182,7 +183,7 @@ static irqreturn_t rk_crypto_irq_handle(int irq, void *dev_id)
 	}
 	if (err)
 		dev->complete(dev, err);
-	spin_unlock(&dev->lock);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -190,12 +191,13 @@ static void rk_crypto_tasklet_cb(unsigned long data)
 {
 	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
 	struct crypto_async_request *async_req, *backlog;
+	unsigned long flags;
 	int err = 0;
 
-	spin_lock(&dev->lock);
+	spin_lock_irqsave(&dev->lock, flags);
 	backlog   = crypto_get_backlog(&dev->queue);
 	async_req = crypto_dequeue_request(&dev->queue);
-	spin_unlock(&dev->lock);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	if (!async_req) {
 		dev_err(dev->dev, "async_req is NULL !!\n");
 		return;
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 4a8f9de..d98b681 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -24,6 +24,7 @@ static void rk_crypto_complete(struct rk_crypto_info *dev, int err)
 static int rk_handle_req(struct rk_crypto_info *dev,
 			 struct ablkcipher_request *req)
 {
+	unsigned long flags;
 	int err;
 
 	if (!IS_ALIGNED(req->nbytes, dev->align_size))
@@ -38,9 +39,9 @@ static int rk_handle_req(struct rk_crypto_info *dev,
 	dev->aligned = 1;
 	dev->ablk_req = req;
 
-	spin_lock(&dev->lock);
+	spin_lock_irqsave(&dev->lock, flags);
 	err = ablkcipher_enqueue_request(&dev->queue, req);
-	spin_unlock(&dev->lock);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	tasklet_schedule(&dev->crypto_tasklet);
 	return err;
 }
@@ -267,12 +268,13 @@ static int rk_set_data_start(struct rk_crypto_info *dev)
 
 static int rk_ablk_start(struct rk_crypto_info *dev)
 {
+	unsigned long flags;
 	int err;
 
-	spin_lock(&dev->lock);
+	spin_lock_irqsave(&dev->lock, flags);
 	rk_ablk_hw_init(dev);
 	err = rk_set_data_start(dev);
-	spin_unlock(&dev->lock);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	return err;
 }
 
-- 
2.6.1
