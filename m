From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 1/3] crypto: s5p-sss - Minor coding cleanups
Date: Tue, 22 Mar 2016 10:58:23 +0900
Message-ID: <1458611905-30157-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38530 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbcCVB7F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 21:59:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Krzysztof Kozlowski <krzk@kernel.org>

Remove unneeded inclusion of delay.h and get rid of indentation from
labels.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>

---

Changes since v2:
1. None.

Changes since v1:
1. Add Vladimir's acked-by.
---
 drivers/crypto/s5p-sss.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 5f161a9777e3..60f835455a41 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -284,7 +283,7 @@ static int s5p_set_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 	dev->sg_dst = sg;
 	err = 0;
 
- exit:
+exit:
 	return err;
 }
 
@@ -310,7 +309,7 @@ static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 	dev->sg_src = sg;
 	err = 0;
 
- exit:
+exit:
 	return err;
 }
 
@@ -452,10 +451,10 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 
 	return;
 
- outdata_error:
+outdata_error:
 	s5p_unset_indata(dev);
 
- indata_error:
+indata_error:
 	s5p_aes_complete(dev, err);
 	spin_unlock_irqrestore(&dev->lock, flags);
 }
@@ -506,7 +505,7 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 
 	tasklet_schedule(&dev->tasklet);
 
- exit:
+exit:
 	return err;
 }
 
@@ -705,7 +704,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	return 0;
 
- err_algs:
+err_algs:
 	dev_err(dev, "can't register '%s': %d\n", algs[i].cra_name, err);
 
 	for (j = 0; j < i; j++)
@@ -713,7 +712,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
- err_irq:
+err_irq:
 	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
-- 
2.5.0
