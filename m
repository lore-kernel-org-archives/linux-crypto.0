From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/3] padata: ensure padata_do_serial() runs on the correct CPU
Date: Fri,  8 Sep 2017 20:57:11 +0200
Message-ID: <1504897031-27523-4-git-send-email-minipli@googlemail.com>
References: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37325 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756802AbdIHS5Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 14:57:25 -0400
Received: by mail-wm0-f66.google.com with SMTP id f4so2291419wmh.4
        for <linux-crypto@vger.kernel.org>; Fri, 08 Sep 2017 11:57:25 -0700 (PDT)
In-Reply-To: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the algorithm we're parallelizing is asynchronous we might change
CPUs between padata_do_parallel() and padata_do_serial(). However, we
don't expect this to happen as we need to enqueue the padata object into
the per-cpu reorder queue we took it from, i.e. the same-cpu's parallel
queue.

Ensure we're not switching CPUs for a given padata object by tracking
the CPU within the padata object. If the serial callback gets called on
the wrong CPU, defer invoking padata_reorder() via a kernel worker on
the CPU we're expected to run on.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 include/linux/padata.h |    2 ++
 kernel/padata.c        |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 5c0175bbc179..5d13d25da2c8 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -37,6 +37,7 @@
  * @list: List entry, to attach to the padata lists.
  * @pd: Pointer to the internal control structure.
  * @cb_cpu: Callback cpu for serializatioon.
+ * @cpu: Cpu for parallelization.
  * @seq_nr: Sequence number of the parallelized data object.
  * @info: Used to pass information from the parallel to the serial function.
  * @parallel: Parallel execution function.
@@ -46,6 +47,7 @@ struct padata_priv {
 	struct list_head	list;
 	struct parallel_data	*pd;
 	int			cb_cpu;
+	int			cpu;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
diff --git a/kernel/padata.c b/kernel/padata.c
index b4066147bce4..f262c9a4e70a 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -131,6 +131,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	padata->cb_cpu = cb_cpu;
 
 	target_cpu = padata_cpu_hash(pd);
+	padata->cpu = target_cpu;
 	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&queue->parallel.lock);
@@ -363,10 +364,21 @@ void padata_do_serial(struct padata_priv *padata)
 	int cpu;
 	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
+	int reorder_via_wq = 0;
 
 	pd = padata->pd;
 
 	cpu = get_cpu();
+
+	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
+	 * was called on -- or, at least, enqueue the padata object into the
+	 * correct per-cpu queue.
+	 */
+	if (cpu != padata->cpu) {
+		reorder_via_wq = 1;
+		cpu = padata->cpu;
+	}
+
 	pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
 	spin_lock(&pqueue->reorder.lock);
@@ -376,7 +388,13 @@ void padata_do_serial(struct padata_priv *padata)
 
 	put_cpu();
 
-	padata_reorder(pd);
+	/* If we're running on the wrong CPU, call padata_reorder() via a
+	 * kernel worker.
+	 */
+	if (reorder_via_wq)
+		queue_work_on(cpu, pd->pinst->wq, &pqueue->reorder_work);
+	else
+		padata_reorder(pd);
 }
 EXPORT_SYMBOL(padata_do_serial);
 
-- 
1.7.10.4
