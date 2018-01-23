From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] hwrng: make symbol imx_rngc_pm_ops static
Date: Tue, 23 Jan 2018 02:08:56 +0000
Message-ID: <1516673336-170194-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fixes the following sparse warnings:

drivers/char/hw_random/imx-rngc.c:303:1: warning:
 symbol 'imx_rngc_pm_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/imx-rngc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index eca8724..250123b 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -300,7 +300,7 @@ static int __maybe_unused imx_rngc_resume(struct device *dev)
 	return 0;
 }
 
-SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
+static SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
 
 static const struct of_device_id imx_rngc_dt_ids[] = {
 	{ .compatible = "fsl,imx25-rngb", .data = NULL, },

