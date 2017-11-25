From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/4] staging: ccree: Remove a attribute group from a kobject
Date: Sat, 25 Nov 2017 12:09:28 +0530
Message-ID: <1511591971-8615-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1511591971-8615-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        lustre-devel@lists.lustre.org
To: gilad@benyossef.com, gregkh@linuxfoundation.org,
        oleg.drokin@intel.com, andreas.dilger@intel.com,
        jsimmons@infradead.org, paulmck@linux.vnet.ibm.com,
        vitaly_fertman@xyratex.com, yawei.niu@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511591971-8615-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All attribute group created during sys_init_dir() should be removed
in sys_free_dir()

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/ccree/ssi_sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 5d39f15..14a3f32 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -145,8 +145,11 @@ static void sys_free_dir(struct sys_dir *sys_dir)
 
 	kfree(sys_dir->sys_dir_attr_list);
 
-	if (sys_dir->sys_dir_kobj)
+	if (sys_dir->sys_dir_kobj) {
+		sysfs_remove_group(sys_dir->sys_dir_kobj,
+				   &sys_dir->sys_dir_attr_group);
 		kobject_put(sys_dir->sys_dir_kobj);
+	}
 }
 
 int ssi_sysfs_init(struct kobject *sys_dev_obj, struct ssi_drvdata *drvdata)
-- 
2.7.4
