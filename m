From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] drivers/crypto: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:18:42 -0700
Message-ID: <20171025101842.GA145495@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:54742 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932523AbdJYKSq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2017 06:18:46 -0400
Received: by mail-pg0-f66.google.com with SMTP id l24so16935546pgu.11
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2017 03:18:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Niklas Cassel <niklas.cassel@axis.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: linux-arm-kernel@axis.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 6 +++---
 drivers/crypto/mv_cesa.c             | 4 ++--
 drivers/crypto/picoxcell_crypto.c    | 7 +++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 0f9754e07719..456278440863 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2072,9 +2072,9 @@ static void artpec6_crypto_process_queue(struct artpec6_crypto *ac)
 		del_timer(&ac->timer);
 }
 
-static void artpec6_crypto_timeout(unsigned long data)
+static void artpec6_crypto_timeout(struct timer_list *t)
 {
-	struct artpec6_crypto *ac = (struct artpec6_crypto *) data;
+	struct artpec6_crypto *ac = from_timer(ac, t, timer);
 
 	dev_info_ratelimited(artpec6_crypto_dev, "timeout\n");
 
@@ -3063,7 +3063,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	spin_lock_init(&ac->queue_lock);
 	INIT_LIST_HEAD(&ac->queue);
 	INIT_LIST_HEAD(&ac->pending);
-	setup_timer(&ac->timer, artpec6_crypto_timeout, (unsigned long) ac);
+	timer_setup(&ac->timer, artpec6_crypto_timeout, 0);
 
 	ac->base = base;
 
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index c3883b49f56e..6a8275f017a8 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -149,7 +149,7 @@ struct mv_req_hash_ctx {
 	int count_add;
 };
 
-static void mv_completion_timer_callback(unsigned long unused)
+static void mv_completion_timer_callback(struct timer_list *unused)
 {
 	int active = readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_EN_SEC_ACCL0;
 
@@ -167,7 +167,7 @@ static void mv_completion_timer_callback(unsigned long unused)
 
 static void mv_setup_timer(void)
 {
-	setup_timer(&cpg->completion_timer, &mv_completion_timer_callback, 0);
+	timer_setup(&cpg->completion_timer, mv_completion_timer_callback, 0);
 	mod_timer(&cpg->completion_timer,
 			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
 }
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index b6f14844702e..5a6dc53b2b9d 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1125,9 +1125,9 @@ static irqreturn_t spacc_spacc_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void spacc_packet_timeout(unsigned long data)
+static void spacc_packet_timeout(struct timer_list *t)
 {
-	struct spacc_engine *engine = (struct spacc_engine *)data;
+	struct spacc_engine *engine = from_timer(engine, t, packet_timeout);
 
 	spacc_process_done(engine);
 }
@@ -1714,8 +1714,7 @@ static int spacc_probe(struct platform_device *pdev)
 	writel(SPA_IRQ_EN_STAT_EN | SPA_IRQ_EN_GLBL_EN,
 	       engine->regs + SPA_IRQ_EN_REG_OFFSET);
 
-	setup_timer(&engine->packet_timeout, spacc_packet_timeout,
-		    (unsigned long)engine);
+	timer_setup(&engine->packet_timeout, spacc_packet_timeout, 0);
 
 	INIT_LIST_HEAD(&engine->pending);
 	INIT_LIST_HEAD(&engine->completed);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
