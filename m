From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 4/6] crypto: img-hash - Add suspend resume hooks for img hash
Date: Mon, 11 Jul 2016 10:33:34 +0100
Message-ID: <1468229616-3888-5-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Govindraj Raja <Govindraj.Raja@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:35614 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185AbcGKJeO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:14 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 27D8E5376A5CD
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:09 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
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
index fbed47a..ed4408a 100644
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
