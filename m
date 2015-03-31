From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH] crypto: omap-sham: Use pm_runtime_irq_safe()
Date: Tue, 31 Mar 2015 09:52:24 +0530
Message-ID: <1427775745-4674-2-git-send-email-lokeshvutla@ti.com>
References: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nsekhar@ti.com>, <t-kristo@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

omap_sham_handle_queue() can be called as part of done_task tasklet.
During this its atomic and any calls to pm functions cannot sleep.

But there is a call to pm_runtime_get_sync() (which can sleep) in
omap_sham_handle_queue(), because of which the following appears:
" [  116.169969] BUG: scheduling while atomic: kworker/0:2/2676/0x00000100"

Add pm_runtime_irq_safe() to avoid this.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ace5852..81ed511 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1949,6 +1949,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	dd->flags |= dd->pdata->flags;
 
 	pm_runtime_enable(dev);
+	pm_runtime_irq_safe(dev);
 	pm_runtime_get_sync(dev);
 	rev = omap_sham_read(dd, SHA_REG_REV(dd));
 	pm_runtime_put_sync(&pdev->dev);
-- 
1.9.1
