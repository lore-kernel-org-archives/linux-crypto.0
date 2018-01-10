From: <sean.wang@mediatek.com>
Subject: [PATCH] hw_random: mediatek: Setup default RNG quality
Date: Wed, 10 Jan 2018 12:02:46 +0800
Message-ID: <134f98ae3270cc6040121cf75d50c916adfe58dc.1515556571.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <clabbe.montjoie@gmail.com>, <prasannatsmkumar@gmail.com>,
        <romain.perier@free-electrons.com>, <shannon.nelson@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:58482 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S965185AbeAJEC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jan 2018 23:02:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

When hw_random device's quality is non-zero, it will automatically fill
the kernel's entropy pool at boot.  For the purpose, one conservative
quality value is being picked up as the default value.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/char/hw_random/mtk-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 8da7bcf..7f99cd5 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -135,6 +135,7 @@ static int mtk_rng_probe(struct platform_device *pdev)
 #endif
 	priv->rng.read = mtk_rng_read;
 	priv->rng.priv = (unsigned long)&pdev->dev;
+	priv->rng.quality = 900;
 
 	priv->clk = devm_clk_get(&pdev->dev, "rng");
 	if (IS_ERR(priv->clk)) {
-- 
2.7.4
