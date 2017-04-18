From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 03/24] padata: Make padata_alloc() static
Date: Tue, 18 Apr 2017 19:04:45 +0200
Message-ID: <20170418170552.619297328@linutronix.de>
References: <20170418170442.665445272@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:53048 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756031AbdDRTtL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 15:49:11 -0400
Content-Disposition: inline; filename=padata--Make-padata_alloc---static.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No users outside of padata.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
---
 include/linux/padata.h |    3 ---
 kernel/padata.c        |   32 ++++++++++++++++----------------
 2 files changed, 16 insertions(+), 19 deletions(-)

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
