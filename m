From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: Merge assignment with return
Date: Sat,  9 Sep 2017 16:14:21 +0530
Message-ID: <1504953861-3221-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35064 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757364AbdIIKo2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Sep 2017 06:44:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Merge the assignment and return statements to return the value
directly. Done using coccinelle.

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
 drivers/staging/ccree/ssi_sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 0655658..9fa7be0 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -412,7 +412,6 @@ static void sys_free_dir(struct sys_dir *sys_dir)

 int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 {
-	int retval;

 #if defined CC_CYCLE_COUNT
 	/* Init. statistics */
@@ -423,10 +422,9 @@ int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
 	SSI_LOG_ERR("setup sysfs under %s\n", sys_dev_obj->name);

 	/* Initialize top directory */
-	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
+	return sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
 			      ssi_sys_top_level_attrs,
 			      ARRAY_SIZE(ssi_sys_top_level_attrs));
-	return retval;
 }

 void ssi_sysfs_fini(void)
