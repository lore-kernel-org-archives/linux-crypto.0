From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 10/38] hwrng: fix handling platform_get_irq
Date: Mon, 21 Sep 2015 15:33:42 +0200
Message-ID: <1442842450-29769-11-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The function can return negative value.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2038576

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/char/hw_random/xgene-rng.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index c37cf75..3c77645 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -344,11 +344,12 @@ static int xgene_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(ctx->csr_base))
 		return PTR_ERR(ctx->csr_base);
 
-	ctx->irq = platform_get_irq(pdev, 0);
-	if (ctx->irq < 0) {
+	rc = platform_get_irq(pdev, 0);
+	if (rc < 0) {
 		dev_err(&pdev->dev, "No IRQ resource\n");
-		return ctx->irq;
+		return rc;
 	}
+	ctx->irq = rc;
 
 	dev_dbg(&pdev->dev, "APM X-Gene RNG BASE %p ALARM IRQ %d",
 		ctx->csr_base, ctx->irq);
-- 
1.9.1
