From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH v1] crypto: img-hash - Handle return value of clk_prepare_enable
Date: Tue, 16 May 2017 13:57:41 +0530
Message-ID: <1494923261-18884-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        will.thomas@imgtec.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36464 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdEPI3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2017 04:29:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here, Clock enable can failed. So adding an error check for
clk_prepare_enable.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/img-hash.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 9b07f3d8..0c6a917 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1088,9 +1088,17 @@ static int img_hash_suspend(struct device *dev)
 static int img_hash_resume(struct device *dev)
 {
 	struct img_hash_dev *hdev = dev_get_drvdata(dev);
+	int ret;
 
-	clk_prepare_enable(hdev->hash_clk);
-	clk_prepare_enable(hdev->sys_clk);
+	ret = clk_prepare_enable(hdev->hash_clk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(hdev->sys_clk);
+	if (ret) {
+		clk_disable_unprepare(hdev->hash_clk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
1.9.1
