From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: Merge assignment with return
Date: Sun, 10 Sep 2017 11:05:37 +0530
Message-ID: <1505021737-4674-1-git-send-email-srishtishar@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37683 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdIJFfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Sep 2017 01:35:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Merge the assignment and return statements to return the value
directly. Done using the following semantic patch by
coccinelle.

@@
local idexpression ret;
expression e;
@@

-ret =
+return
     e;
-return ret;

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 -Correct coding style problems

 drivers/staging/ccree/ssi_sysfs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 0655658..ed662cb 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -412,8 +412,6 @@ static void sys_free_dir(struct sys_dir *sys_dir)

 int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 {
-	int retval;
-
 #if defined CC_CYCLE_COUNT
 	/* Init. statistics */
 	init_db(stat_host_db);
@@ -423,10 +421,9 @@ int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 	SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);

 	/* Initialize top directory */
-	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
-			      ssi_sys_top_level_attrs,
-			      ARRAY_SIZE(ssi_sys_top_level_attrs));
-	return retval;
+	return sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
+			    ssi_sys_top_level_attrs,
+			    ARRAY_SIZE(ssi_sys_top_level_attrs));
 }

 void ssi_sysfs_fini(void)
