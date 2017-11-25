From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 4/4] staging: most: Remove a attribute group from a kobject
Date: Sat, 25 Nov 2017 12:09:31 +0530
Message-ID: <1511591971-8615-5-git-send-email-arvind.yadav.cs@gmail.com>
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

All attribute group created during dim2_sysfs_probe() should be removed
in dim2_sysfs_destroy().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/most/hdm-dim2/dim2_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/most/hdm-dim2/dim2_sysfs.c b/drivers/staging/most/hdm-dim2/dim2_sysfs.c
index d8b22f9..c038ff5 100644
--- a/drivers/staging/most/hdm-dim2/dim2_sysfs.c
+++ b/drivers/staging/most/hdm-dim2/dim2_sysfs.c
@@ -111,5 +111,6 @@ int dim2_sysfs_probe(struct medialb_bus *bus, struct kobject *parent_kobj)
 
 void dim2_sysfs_destroy(struct medialb_bus *bus)
 {
+	sysfs_remove_group(&bus->kobj_group, &bus_attr_group);
 	kobject_put(&bus->kobj_group);
 }
-- 
2.7.4
