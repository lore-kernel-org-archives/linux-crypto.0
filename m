From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 02/27] Drivers: ccree: ssi_sysfs.c - align block comments
Date: Wed, 24 May 2017 16:41:11 +1200
Message-ID: <20170524044111.29959-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36059 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdEXElU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 00:41:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 89021c009872..69e1ae491098 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -355,7 +355,8 @@ static struct ssi_drvdata *sys_get_drvdata(void)
 {
 	/* TODO: supporting multiple SeP devices would require avoiding
 	 * global "top_dir" and finding associated "top_dir" by traversing
-	 * up the tree to the kobject which matches one of the top_dir's */
+	 * up the tree to the kobject which matches one of the top_dir's
+	 */
 	return sys_top_dir.drvdata;
 }
 
-- 
2.12.2
