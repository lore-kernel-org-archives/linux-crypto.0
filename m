From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 8/9 v6] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Fri, 07 Feb 2014 10:56:36 +0530
Message-ID: <1391750796-27528-1-git-send-email-ch.naveen@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
changes since v5:
None

 drivers/crypto/s5p-sss.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index a890273..d35a477 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -648,7 +648,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	err = clk_prepare_enable(pdata->clk);
+	if (err < 0) {
+		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		return err;
+	}
 
 	spin_lock_init(&pdata->lock);
 	pdata->ioaddr = devm_ioremap(dev, res->start,
@@ -711,7 +715,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -731,7 +735,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5
