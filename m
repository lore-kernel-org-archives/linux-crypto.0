From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 03/20] padata: Make padata_alloc() static
Date: Sat, 15 Apr 2017 19:01:10 +0200
Message-ID: <20170415171651.483363066@linutronix.de>
References: <20170415170107.643253702@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=padata--Make-padata_alloc---static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

No users outside of padata.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
---
 include/linux/padata.h |    3 ---
 kernel/padata.c        |   34 +++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 20 deletions(-)

--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -166,9 +166,6 @@ struct padata_instance {
 
 extern struct padata_instance *padata_alloc_possible(
 					struct workqueue_struct *wq);
-extern struct padata_instance *padata_alloc(struct workqueue_struct *wq,
-					    const struct cpumask *pcpumask,
-					    const struct cpumask *cbcpumask);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -913,7 +913,7 @@ static ssize_t padata_sysfs_show(struct
 }
 
 static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
+s				  const char *buf, size_t count)
 {
 	struct padata_instance *pinst;
 	struct padata_sysfs_entry *pentry;
@@ -939,19 +939,6 @@ static struct kobj_type padata_attr_type
 };
 
 /**
- * padata_alloc_possible - Allocate and initialize padata instance.
- *                         Use the cpu_possible_mask for serial and
- *                         parallel workers.
- *
- * @wq: workqueue to use for the allocated padata instance
- */
-struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq)
-{
-	return padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
-}
-EXPORT_SYMBOL(padata_alloc_possible);
-
-/**
  * padata_alloc - allocate and initialize a padata instance and specify
  *                cpumasks for serial and parallel workers.
  *
@@ -959,9 +946,9 @@ EXPORT_SYMBOL(padata_alloc_possible);
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
  */
-struct padata_instance *padata_alloc(struct workqueue_struct *wq,
-				     const struct cpumask *pcpumask,
-				     const struct cpumask *cbcpumask)
+static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+					    const struct cpumask *pcpumask,
+					    const struct cpumask *cbcpumask)
 {
 	struct padata_instance *pinst;
 	struct parallel_data *pd = NULL;
@@ -1016,6 +1003,19 @@ struct padata_instance *padata_alloc(str
 }
 
 /**
+ * padata_alloc_possible - Allocate and initialize padata instance.
+ *                         Use the cpu_possible_mask for serial and
+ *                         parallel workers.
+ *
+ * @wq: workqueue to use for the allocated padata instance
+ */
+struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq)
+{
+	return padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
+}
+EXPORT_SYMBOL(padata_alloc_possible);
+
+/**
  * padata_free - free a padata instance
  *
  * @padata_inst: padata instance to free
