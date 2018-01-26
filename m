From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [PATCH v2 3/5] crypto: caam: do not use mem and emi_slow clock for imx7x
Date: Fri, 26 Jan 2018 17:00:02 +0000
Message-ID: <1516986004-25452-4-git-send-email-pure.logic@nexus-software.ie>
References: <1516986004-25452-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516986004-25452-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

I.MX7x only use two clocks for the CAAM module, so make sure we do not try to
use the mem and the emi_slow clock when running in that imx7d and imx7s machine
type.

[bod: fixed minor trailing whitespace issue]

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 drivers/crypto/caam/ctrl.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 0a1e96b..1f2dd6a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -333,7 +333,8 @@ static int caam_remove(struct platform_device *pdev)
 
 	/* shut clocks off before finalizing shutdown */
 	clk_disable_unprepare(ctrlpriv->caam_ipg);
-	clk_disable_unprepare(ctrlpriv->caam_mem);
+	if (ctrlpriv->caam_mem)
+		clk_disable_unprepare(ctrlpriv->caam_mem);
 	clk_disable_unprepare(ctrlpriv->caam_aclk);
 	if (ctrlpriv->caam_emi_slow)
 		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
@@ -462,14 +463,17 @@ static int caam_probe(struct platform_device *pdev)
 	}
 	ctrlpriv->caam_ipg = clk;
 
-	clk = caam_drv_identify_clk(&pdev->dev, "mem");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		dev_err(&pdev->dev,
-			"can't identify CAAM mem clk: %d\n", ret);
-		return ret;
+	if (!of_machine_is_compatible("fsl,imx7d") &&
+	    !of_machine_is_compatible("fsl,imx7s")) {
+		clk = caam_drv_identify_clk(&pdev->dev, "mem");
+		if (IS_ERR(clk)) {
+			ret = PTR_ERR(clk);
+			dev_err(&pdev->dev,
+				"can't identify CAAM mem clk: %d\n", ret);
+			return ret;
+		}
+		ctrlpriv->caam_mem = clk;
 	}
-	ctrlpriv->caam_mem = clk;
 
 	clk = caam_drv_identify_clk(&pdev->dev, "aclk");
 	if (IS_ERR(clk)) {
@@ -480,7 +484,9 @@ static int caam_probe(struct platform_device *pdev)
 	}
 	ctrlpriv->caam_aclk = clk;
 
-	if (!of_machine_is_compatible("fsl,imx6ul")) {
+	if (!of_machine_is_compatible("fsl,imx6ul") &&
+	    !of_machine_is_compatible("fsl,imx7d") &&
+	    !of_machine_is_compatible("fsl,imx7s")) {
 		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
@@ -497,11 +503,13 @@ static int caam_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = clk_prepare_enable(ctrlpriv->caam_mem);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
-			ret);
-		goto disable_caam_ipg;
+	if (ctrlpriv->caam_mem) {
+		ret = clk_prepare_enable(ctrlpriv->caam_mem);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
+				ret);
+			goto disable_caam_ipg;
+		}
 	}
 
 	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
@@ -823,7 +831,8 @@ static int caam_probe(struct platform_device *pdev)
 disable_caam_aclk:
 	clk_disable_unprepare(ctrlpriv->caam_aclk);
 disable_caam_mem:
-	clk_disable_unprepare(ctrlpriv->caam_mem);
+	if (ctrlpriv->caam_mem)
+		clk_disable_unprepare(ctrlpriv->caam_mem);
 disable_caam_ipg:
 	clk_disable_unprepare(ctrlpriv->caam_ipg);
 	return ret;
-- 
2.7.4
