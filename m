From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 4/7] crypto: img-hash - Add suspend resume hooks for img hash
Date: Fri, 5 Aug 2016 14:00:17 +0100
Message-ID: <1470402020-10774-5-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Govindraj Raja <Govindraj.Raja@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:5751 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbcHENIN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:13 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Govindraj Raja <Govindraj.Raja@imgtec.com>

Current img hash claims sys and periph gate clocks
and this can be gated in system suspend scenarios.

Add support for Device pm ops for img hash to gate
the clocks claimed by img hash.

Signed-off-by: Govindraj Raja <Govindraj.Raja@imgtec.com>
Reviewed-by: Will Thomas <will.thomas@imgtec.com>
---
 drivers/crypto/img-hash.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index f8abbe3..2622c01 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1016,11 +1016,38 @@ static int img_hash_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int img_hash_suspend(struct device *dev)
+{
+	struct img_hash_dev *hdev = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(hdev->hash_clk);
+	clk_disable_unprepare(hdev->sys_clk);
+
+	return 0;
+}
+
+static int img_hash_resume(struct device *dev)
+{
+	struct img_hash_dev *hdev = dev_get_drvdata(dev);
+
+	clk_prepare_enable(hdev->hash_clk);
+	clk_prepare_enable(hdev->sys_clk);
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops img_hash_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(img_hash_suspend, img_hash_resume)
+};
+
 static struct platform_driver img_hash_driver = {
 	.probe		= img_hash_probe,
 	.remove		= img_hash_remove,
 	.driver		= {
 		.name	= "img-hash-accelerator",
+		.pm	= &img_hash_pm_ops,
 		.of_match_table	= of_match_ptr(img_hash_match),
 	}
 };
-- 
2.1.4
