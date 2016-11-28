From: Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] crypto: caam: check caam_emi_slow instead of re-lookup
 platform
Date: Mon, 28 Nov 2016 12:53:28 -0500
Message-ID: <20161128175328.GA29713@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alex Porosanu <alexandru.porosanu@nxp.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34911 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbcK1Lxj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 06:53:39 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---

Russel King, sorry, I did not see your comment until now.

 drivers/crypto/caam/ctrl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 5abaf3743b86..4993c90ceb3f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -329,7 +329,7 @@ static int caam_remove(struct platform_device *pdev)
 	clk_disable_unprepare(ctrlpriv->caam_ipg);
 	clk_disable_unprepare(ctrlpriv->caam_mem);
 	clk_disable_unprepare(ctrlpriv->caam_aclk);
-	if (!of_machine_is_compatible("fsl,imx6ul"))
+	if (ctrlpriv->caam_emi_slow)
 		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
 	return 0;
 }
@@ -511,7 +511,7 @@ static int caam_probe(struct platform_device *pdev)
 		goto disable_caam_mem;
 	}
 
-	if (!of_machine_is_compatible("fsl,imx6ul")) {
+	if (ctrlpriv->caam_emi_slow) {
 		ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
@@ -833,7 +833,7 @@ caam_remove:
 iounmap_ctrl:
 	iounmap(ctrl);
 disable_caam_emi_slow:
-	if (!of_machine_is_compatible("fsl,imx6ul"))
+	if (ctrlpriv->caam_emi_slow)
 		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
 disable_caam_aclk:
 	clk_disable_unprepare(ctrlpriv->caam_aclk);
-- 
2.11.0.rc2
