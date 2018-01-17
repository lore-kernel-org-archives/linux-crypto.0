From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] crypto: stm32 - remove redundant dev_err call in stm32_cryp_probe()
Date: Wed, 17 Jan 2018 11:40:24 +0000
Message-ID: <1516189224-11877-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Fabien DESSENNE <fabien.dessenne@st.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4653 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752826AbeAQLeM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 06:34:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cf1dddb..4a06a7a 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1052,10 +1052,8 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	cryp->regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(cryp->regs)) {
-		dev_err(dev, "Cannot map CRYP IO\n");
+	if (IS_ERR(cryp->regs))
 		return PTR_ERR(cryp->regs);
-	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
