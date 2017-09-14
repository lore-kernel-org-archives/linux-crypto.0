From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: Use kcalloc instead of kzalloc
Date: Thu, 14 Sep 2017 17:45:53 +0530
Message-ID: <1505391353-4516-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use kcalloc instead of kzalloc to check for overflow before
multiplication. Done using the following semantic patch by
coccinelle.

http://coccinelle.lip6.fr/rules/kzalloc.cocci

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 0655658..65a0529 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -376,7 +376,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
 		return -ENOMEM;
 	/* allocate memory for directory's attributes list */
 	sys_dir->sys_dir_attr_list =
-		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
+		kcalloc((num_of_attrs + 1), sizeof(struct attribute *),
 			GFP_KERNEL);
 
 	if (!(sys_dir->sys_dir_attr_list)) {
-- 
2.7.4
