From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 04/24] padata: Avoid nested calls to get_online_cpus() in
 pcrypt_init_padata()
Date: Tue, 18 Apr 2017 19:04:46 +0200
Message-ID: <20170418170552.697398655@linutronix.de>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=kernelpadata_Avoid_get_online_cpus()_recursion_via_pcrypt_init_padata().patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

pcrypt_init_padata()
   get_online_cpus()
   padata_alloc_possible()
     padata_alloc()
       get_online_cpus()

The nested call to get_online_cpus() works with the current implementation,
but prevents the conversion to a percpu rwsem.

The other caller of padata_alloc_possible() is pcrypt_init_padata() which
calls from a get_online_cpus() protected region as well.

Remove the get_online_cpus() call in padata_alloc() and document the
calling convention.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org

---
 kernel/padata.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -945,6 +945,8 @@ static struct kobj_type padata_attr_type
  * @wq: workqueue to use for the allocated padata instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
+ *
+ * Must be called from a get_online_cpus() protected region
  */
 static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 					    const struct cpumask *pcpumask,
@@ -957,7 +959,6 @@ static struct padata_instance *padata_al
 	if (!pinst)
 		goto err;
 
-	get_online_cpus();
 	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
 		goto err_free_inst;
 	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
@@ -997,7 +998,6 @@ static struct padata_instance *padata_al
 	free_cpumask_var(pinst->cpumask.cbcpu);
 err_free_inst:
 	kfree(pinst);
-	put_online_cpus();
 err:
 	return NULL;
 }
@@ -1008,6 +1008,8 @@ static struct padata_instance *padata_al
  *                         parallel workers.
  *
  * @wq: workqueue to use for the allocated padata instance
+ *
+ * Must be called from a get_online_cpus() protected region
  */
 struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq)
 {
