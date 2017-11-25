From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/4] staging: lustre: ldlm: Remove a attribute group from a kobject
Date: Sat, 25 Nov 2017 12:09:29 +0530
Message-ID: <1511591971-8615-3-git-send-email-arvind.yadav.cs@gmail.com>
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

All attribute group created during ldlm_setup() should be removed
in ldlm_cleanup().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 2d5a2c9..ada50b6 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -1093,8 +1093,10 @@ static int ldlm_cleanup(void)
 		kset_unregister(ldlm_ns_kset);
 	if (ldlm_svc_kset)
 		kset_unregister(ldlm_svc_kset);
-	if (ldlm_kobj)
+	if (ldlm_kobj) {
+		sysfs_remove_group(ldlm_kobj, &ldlm_attr_group);
 		kobject_put(ldlm_kobj);
+	}
 
 	ldlm_debugfs_cleanup();
 
-- 
2.7.4
