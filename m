From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/3] padata: ensure the reorder timer callback runs on the correct CPU
Date: Fri,  8 Sep 2017 20:57:10 +0200
Message-ID: <1504897031-27523-3-git-send-email-minipli@googlemail.com>
References: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33054 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756760AbdIHS5Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 14:57:25 -0400
Received: by mail-wm0-f68.google.com with SMTP id 187so2315755wmn.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Sep 2017 11:57:24 -0700 (PDT)
In-Reply-To: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The reorder timer function runs on the CPU where the timer interrupt was
handled which is not necessarily one of the CPUs of the 'pcpu' CPU mask
set.

Ensure the padata_reorder() callback runs on the correct CPU, which is
one in the 'pcpu' CPU mask set and, preferrably, the next expected one.
Do so by comparing the current CPU with the expected target CPU. If they
match, call padata_reorder() right away. If they differ, schedule a work
item on the target CPU that does the padata_reorder() call for us.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 include/linux/padata.h |    2 ++
 kernel/padata.c        |   43 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 2f9c1f93b1ce..5c0175bbc179 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -85,6 +85,7 @@ struct padata_serial_queue {
  * @swork: work struct for serialization.
  * @pd: Backpointer to the internal control structure.
  * @work: work struct for parallelization.
+ * @reorder_work: work struct for reordering.
  * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
@@ -93,6 +94,7 @@ struct padata_parallel_queue {
        struct padata_list    reorder;
        struct parallel_data *pd;
        struct work_struct    work;
+       struct work_struct    reorder_work;
        atomic_t              num_obj;
        int                   cpu_index;
 };
diff --git a/kernel/padata.c b/kernel/padata.c
index 1b9b4bac4a9b..b4066147bce4 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -275,11 +275,51 @@ static void padata_reorder(struct parallel_data *pd)
 	return;
 }
 
+static void invoke_padata_reorder(struct work_struct *work)
+{
+	struct padata_parallel_queue *pqueue;
+	struct parallel_data *pd;
+
+	local_bh_disable();
+	pqueue = container_of(work, struct padata_parallel_queue, reorder_work);
+	pd = pqueue->pd;
+	padata_reorder(pd);
+	local_bh_enable();
+}
+
 static void padata_reorder_timer(unsigned long arg)
 {
 	struct parallel_data *pd = (struct parallel_data *)arg;
+	unsigned int weight;
+	int target_cpu, cpu;
 
-	padata_reorder(pd);
+	cpu = get_cpu();
+
+	/* We don't lock pd here to not interfere with parallel processing
+	 * padata_reorder() calls on other CPUs. We just need any CPU out of
+	 * the cpumask.pcpu set. It would be nice if it's the right one but
+	 * it doesn't matter if we're off to the next one by using an outdated
+	 * pd->processed value.
+	 */
+	weight = cpumask_weight(pd->cpumask.pcpu);
+	target_cpu = padata_index_to_cpu(pd, pd->processed % weight);
+
+	/* ensure to call the reorder callback on the correct CPU */
+	if (cpu != target_cpu) {
+		struct padata_parallel_queue *pqueue;
+		struct padata_instance *pinst;
+
+		/* The timer function is serialized wrt itself -- no locking
+		 * needed.
+		 */
+		pinst = pd->pinst;
+		pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
+		queue_work_on(target_cpu, pinst->wq, &pqueue->reorder_work);
+	} else {
+		padata_reorder(pd);
+	}
+
+	put_cpu();
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
@@ -399,6 +439,7 @@ static void padata_init_pqueues(struct parallel_data *pd)
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
+		INIT_WORK(&pqueue->reorder_work, invoke_padata_reorder);
 		atomic_set(&pqueue->num_obj, 0);
 	}
 }
-- 
1.7.10.4
