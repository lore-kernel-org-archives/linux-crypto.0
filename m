From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 3/4] staging: lustre: obdclass: Remove a attribute group from a kobject
Date: Sat, 25 Nov 2017 12:09:30 +0530
Message-ID: <1511591971-8615-4-git-send-email-arvind.yadav.cs@gmail.com>
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

All attribute group created during class_procfs_init() should be
removed.
if class_procfs_init() will fail and also in class_procfs_clean().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index fc59f29..5795123 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -501,6 +501,7 @@ int class_procfs_init(void)
 		rc = debugfs_lustre_root ? PTR_ERR(debugfs_lustre_root)
 					 : -ENOMEM;
 		debugfs_lustre_root = NULL;
+		sysfs_remove_group(lustre_kobj, &lustre_attr_group);
 		kobject_put(lustre_kobj);
 		goto out;
 	}
@@ -509,6 +510,7 @@ int class_procfs_init(void)
 				   &obd_device_list_fops);
 	if (IS_ERR_OR_NULL(file)) {
 		rc = file ? PTR_ERR(file) : -ENOMEM;
+		sysfs_remove_group(lustre_kobj, &lustre_attr_group);
 		kobject_put(lustre_kobj);
 		goto out;
 	}
@@ -522,6 +524,7 @@ int class_procfs_clean(void)
 
 	debugfs_lustre_root = NULL;
 
+	sysfs_remove_group(lustre_kobj, &lustre_attr_group);
 	kobject_put(lustre_kobj);
 
 	return 0;
-- 
2.7.4
