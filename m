From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] kernel/padata: hide unused functions
Date: Sat, 16 Apr 2016 22:23:55 +0200
Message-ID: <1460838250-1243973-1-git-send-email-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Richard Cochran <rcochran@linutronix.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:51116 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbcDPUYf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 16 Apr 2016 16:24:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A recent cleanup removed some exported functions that were not
used anywhere, which in turn exposed the fact that some other
functions in the same file are only used in some configurations.

We now get a warning about them when CONFIG_HOTPLUG_CPU is
disabled:

kernel/padata.c:670:12: error: '__padata_remove_cpu' defined but not used [-Werror=unused-function]
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
            ^~~~~~~~~~~~~~~~~~~
kernel/padata.c:650:12: error: '__padata_add_cpu' defined but not used [-Werror=unused-function]
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)

This rearranges the code so the __padata_remove_cpu/__padata_add_cpu
functions are within the #ifdef that protects the code that calls
them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 4ba6d78c671e ("kernel/padata.c: removed unused code")
---
 kernel/padata.c | 74 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7436dd6b654c..6db4ea14fb2d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -647,6 +647,43 @@ out:
 }
 EXPORT_SYMBOL(padata_set_cpumask);
 
+/**
+ * padata_start - start the parallel processing
+ *
+ * @pinst: padata instance to start
+ */
+int padata_start(struct padata_instance *pinst)
+{
+	int err = 0;
+
+	mutex_lock(&pinst->lock);
+
+	if (pinst->flags & PADATA_INVALID)
+		err =-EINVAL;
+
+	 __padata_start(pinst);
+
+	mutex_unlock(&pinst->lock);
+
+	return err;
+}
+EXPORT_SYMBOL(padata_start);
+
+/**
+ * padata_stop - stop the parallel processing
+ *
+ * @pinst: padata instance to stop
+ */
+void padata_stop(struct padata_instance *pinst)
+{
+	mutex_lock(&pinst->lock);
+	__padata_stop(pinst);
+	mutex_unlock(&pinst->lock);
+}
+EXPORT_SYMBOL(padata_stop);
+
+#ifdef CONFIG_HOTPLUG_CPU
+
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd;
@@ -691,43 +728,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	return 0;
 }
 
-/**
- * padata_start - start the parallel processing
- *
- * @pinst: padata instance to start
- */
-int padata_start(struct padata_instance *pinst)
-{
-	int err = 0;
-
-	mutex_lock(&pinst->lock);
-
-	if (pinst->flags & PADATA_INVALID)
-		err =-EINVAL;
-
-	 __padata_start(pinst);
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_start);
-
-/**
- * padata_stop - stop the parallel processing
- *
- * @pinst: padata instance to stop
- */
-void padata_stop(struct padata_instance *pinst)
-{
-	mutex_lock(&pinst->lock);
-	__padata_stop(pinst);
-	mutex_unlock(&pinst->lock);
-}
-EXPORT_SYMBOL(padata_stop);
-
-#ifdef CONFIG_HOTPLUG_CPU
-
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
 {
 	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
-- 
2.7.0
