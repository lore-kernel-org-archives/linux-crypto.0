From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] hwrng/xgene-rng: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:38:34 -0700
Message-ID: <20171016233834.GA101719@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/hw_random/xgene-rng.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 3c77645405e5..71755790c32b 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -100,9 +100,9 @@ struct xgene_rng_dev {
 	struct clk *clk;
 };
 
-static void xgene_rng_expired_timer(unsigned long arg)
+static void xgene_rng_expired_timer(struct timer_list *t)
 {
-	struct xgene_rng_dev *ctx = (struct xgene_rng_dev *) arg;
+	struct xgene_rng_dev *ctx = from_timer(ctx, t, failure_timer);
 
 	/* Clear failure counter as timer expired */
 	disable_irq(ctx->irq);
@@ -113,8 +113,6 @@ static void xgene_rng_expired_timer(unsigned long arg)
 
 static void xgene_rng_start_timer(struct xgene_rng_dev *ctx)
 {
-	ctx->failure_timer.data = (unsigned long) ctx;
-	ctx->failure_timer.function = xgene_rng_expired_timer;
 	ctx->failure_timer.expires = jiffies + 120 * HZ;
 	add_timer(&ctx->failure_timer);
 }
@@ -292,7 +290,7 @@ static int xgene_rng_init(struct hwrng *rng)
 	struct xgene_rng_dev *ctx = (struct xgene_rng_dev *) rng->priv;
 
 	ctx->failure_cnt = 0;
-	init_timer(&ctx->failure_timer);
+	timer_setup(&ctx->failure_timer, xgene_rng_expired_timer, 0);
 
 	ctx->revision = readl(ctx->csr_base + RNG_EIP_REV);
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
