From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/8] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Sun,  3 Sep 2017 17:57:36 +0300
Message-ID: <1504450664-28252-2-git-send-email-gilad@benyossef.com>
References: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Suniel Mahesh <sunil.m@techveda.org>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

It is recommended to use managed function devm_kzalloc, which
simplifies driver cleanup paths and driver code.
This patch does the following:
(a) replace kzalloc with devm_kzalloc.
(b) drop kfree(), because memory allocated with devm_kzalloc() is
automatically freed on driver detach, otherwise it leads to a double
free.
(c) remove unnecessary blank lines.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
[gby: rebase on top of latest coding style fixes changes]
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 9c6f120..47e0880 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -223,14 +223,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
-	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(*new_drvdata),
-						  GFP_KERNEL);
+	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
 	int rc = 0;
 
-	if (unlikely(!new_drvdata)) {
+	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(*new_drvdata),
+				   GFP_KERNEL);
+	if (!new_drvdata) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto init_cc_res_err;
@@ -435,10 +436,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 					   resource_size(new_drvdata->res_mem));
 			new_drvdata->res_mem = NULL;
 		}
-		kfree(new_drvdata);
 		dev_set_drvdata(&plat_dev->dev, NULL);
 	}
-
 	return rc;
 }
 
@@ -479,8 +478,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 		drvdata->cc_base = NULL;
 		drvdata->res_mem = NULL;
 	}
-
-	kfree(drvdata);
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
-- 
2.1.4
