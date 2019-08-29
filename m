Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BAFC3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF0422CF5
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K9As2e5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfH2Rh5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:37:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfH2Rh4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:37:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THXm9p125446;
        Thu, 29 Aug 2019 17:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=GgEbaSm1cURsHhVB8EY2Lx/d86Cacme/HQfya9phm7U=;
 b=K9As2e5kKQVy7Xx/YcLgIFhV1Zxx1X2oDNxWr+1IUkhfWDar/9FiYpFyZVoBmESz9V7/
 yav9wZ+br1p3NzZxMWAbWTgof2XEGRBUJCKh2gLBzk07qtNHGn04MK9qn30S2XiXS0aS
 cG+PIm0A4xUCUMFI8x3ZITfKvhg7NaBJoZ+TkL//honcVGkNxwC7llAx7kS64iH4Ue8K
 DdBQ2iLJd2Ju8AbqLj6PIbipBih9LtW0/x14yvo8xdbXqjTztsG0/deMF+tLSIWE7mux
 tTKQIvnc/aiN+pkb0pQvlYMQ41IOQP4BwdU6zgYY9N1e6AwCr8wK41DhiZy1Sd1JSTMg Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2upk56r2br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:37:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWYVr057171;
        Thu, 29 Aug 2019 17:32:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2upc8uy168-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7THWgle022091;
        Thu, 29 Aug 2019 17:32:42 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:32:41 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 8/9] padata: unbind parallel jobs from specific CPUs
Date:   Thu, 29 Aug 2019 13:30:37 -0400
Message-Id: <20190829173038.21040-9-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290186
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Padata binds the parallel part of a job to a single CPU and round-robins
over all CPUs in the system for each successive job.  Though the serial
parts rely on per-CPU queues for correct ordering, they're not necessary
for parallel work, and it improves performance to run the job locally on
NUMA machines and let the scheduler pick the CPU within a node on a busy
system.

So, make the parallel workqueue unbound.

Update the parallel workqueue's cpumask when the instance's parallel
cpumask changes.

Now that parallel jobs no longer run on max_active=1 workqueues, two or
more parallel works that hash to the same CPU may run simultaneously,
finish out of order, and so be serialized out of order.  Prevent this by
keeping the works sorted on the reorder list by sequence number and
checking that in the reordering logic.

padata_get_next becomes padata_find_next so it can be reused for the end
of padata_reorder, where it's used to avoid uselessly queueing work when
the next job by sequence number isn't finished yet but a later job that
hashed to the same CPU has.

The ENODATA case in padata_find_next no longer makes sense because
parallel jobs aren't bound to specific CPUs.  The EINPROGRESS case takes
care of the scenario where a parallel job is potentially running on the
same CPU as padata_find_next, and with only one error code left, just
use NULL instead.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |   3 ++
 kernel/padata.c        | 116 +++++++++++++++++++++++------------------
 2 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index b5f18802d015..4d2ba38d99fc 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -36,6 +36,7 @@ struct padata_priv {
 	struct parallel_data	*pd;
 	int			cb_cpu;
 	int			cpu;
+	unsigned int		seq_nr;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
@@ -106,6 +107,7 @@ struct padata_cpumask {
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @flushing_done: Wait for all objects to be sent out.
  * @max_seq_nr:  Maximal used sequence number.
+ * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
  * @reorder_work: work struct for reordering.
@@ -118,6 +120,7 @@ struct parallel_data {
 	atomic_t			refcnt;
 	struct completion		flushing_done;
 	atomic_t			seq_nr;
+	unsigned int			processed;
 	int				cpu;
 	struct padata_cpumask		cpumask;
 	struct work_struct		reorder_work;
diff --git a/kernel/padata.c b/kernel/padata.c
index eefe4dd3d979..83889e0bf1c4 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -46,18 +46,13 @@ static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 	return target_cpu;
 }
 
-static int padata_cpu_hash(struct parallel_data *pd)
+static int padata_cpu_hash(struct parallel_data *pd, unsigned int seq_nr)
 {
-	unsigned int seq_nr;
-	int cpu_index;
-
 	/*
 	 * Hash the sequence numbers to the cpus by taking
 	 * seq_nr mod. number of cpus in use.
 	 */
-
-	seq_nr = atomic_inc_return(&pd->seq_nr);
-	cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
+	int cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
 
 	return padata_index_to_cpu(pd, cpu_index);
 }
@@ -144,7 +139,8 @@ int padata_do_parallel(struct padata_instance *pinst,
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
-	target_cpu = padata_cpu_hash(pd);
+	padata->seq_nr = atomic_inc_return(&pd->seq_nr);
+	target_cpu = padata_cpu_hash(pd, padata->seq_nr);
 	padata->cpu = target_cpu;
 	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
@@ -152,7 +148,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	list_add_tail(&padata->list, &queue->parallel.list);
 	spin_unlock(&queue->parallel.lock);
 
-	queue_work_on(target_cpu, pinst->parallel_wq, &queue->work);
+	queue_work(pinst->parallel_wq, &queue->work);
 
 out:
 	rcu_read_unlock_bh();
@@ -162,21 +158,19 @@ int padata_do_parallel(struct padata_instance *pinst,
 EXPORT_SYMBOL(padata_do_parallel);
 
 /*
- * padata_get_next - Get the next object that needs serialization.
+ * padata_find_next - Find the next object that needs serialization.
  *
  * Return values are:
  *
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * -EINPROGRESS, if the next object that needs serialization will
+ * NULL, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
- *
- * -ENODATA, if this cpu has to do the parallel processing for
- *  the next object.
  */
-static struct padata_priv *padata_get_next(struct parallel_data *pd)
+static struct padata_priv *padata_find_next(struct parallel_data *pd,
+					    bool remove_object)
 {
 	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
@@ -187,27 +181,29 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
-	if (!list_empty(&reorder->list)) {
-		padata = list_entry(reorder->list.next,
-				    struct padata_priv, list);
-
-		list_del_init(&padata->list);
+	if (list_empty(&reorder->list)) {
+		spin_unlock(&reorder->lock);
+		return NULL;
+	}
 
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
-					    false);
+	padata = list_entry(reorder->list.next, struct padata_priv, list);
 
+	/*
+	 * Checks the rare case where two or more parallel jobs have hashed to
+	 * the same CPU and one of the later ones finishes first.
+	 */
+	if (padata->seq_nr != pd->processed) {
 		spin_unlock(&reorder->lock);
-		goto out;
+		return NULL;
 	}
-	spin_unlock(&reorder->lock);
 
-	if (__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
-		padata = ERR_PTR(-ENODATA);
-		goto out;
+	if (remove_object) {
+		list_del_init(&padata->list);
+		++pd->processed;
+		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
 	}
 
-	padata = ERR_PTR(-EINPROGRESS);
-out:
+	spin_unlock(&reorder->lock);
 	return padata;
 }
 
@@ -233,26 +229,16 @@ static void padata_reorder(struct parallel_data *pd)
 		return;
 
 	while (1) {
-		padata = padata_get_next(pd);
+		padata = padata_find_next(pd, true);
 
 		/*
 		 * If the next object that needs serialization is parallel
 		 * processed by another cpu and is still on it's way to the
 		 * cpu's reorder queue, nothing to do for now.
 		 */
-		if (PTR_ERR(padata) == -EINPROGRESS)
+		if (!padata)
 			break;
 
-		/*
-		 * This cpu has to do the parallel processing of the next
-		 * object. It's waiting in the cpu's parallelization queue,
-		 * so exit immediately.
-		 */
-		if (PTR_ERR(padata) == -ENODATA) {
-			spin_unlock_bh(&pd->lock);
-			return;
-		}
-
 		cb_cpu = padata->cb_cpu;
 		squeue = per_cpu_ptr(pd->squeue, cb_cpu);
 
@@ -276,7 +262,8 @@ static void padata_reorder(struct parallel_data *pd)
 	smp_mb();
 
 	next_queue = per_cpu_ptr(pd->pqueue, pd->cpu);
-	if (!list_empty(&next_queue->reorder.list))
+	if (!list_empty(&next_queue->reorder.list) &&
+	    padata_find_next(pd, false))
 		queue_work(pinst->serial_wq, &pd->reorder_work);
 }
 
@@ -332,9 +319,14 @@ void padata_do_serial(struct padata_priv *padata)
 	struct parallel_data *pd = padata->pd;
 	struct padata_parallel_queue *pqueue = per_cpu_ptr(pd->pqueue,
 							   padata->cpu);
+	struct padata_priv *cur;
 
 	spin_lock(&pqueue->reorder.lock);
-	list_add_tail(&padata->list, &pqueue->reorder.list);
+	/* Sort in ascending order of sequence number. */
+	list_for_each_entry_reverse(cur, &pqueue->reorder.list, list)
+		if (cur->seq_nr < padata->seq_nr)
+			break;
+	list_add(&padata->list, &cur->list);
 	spin_unlock(&pqueue->reorder.lock);
 
 	/*
@@ -352,17 +344,36 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
 				 const struct cpumask *pcpumask,
 				 const struct cpumask *cbcpumask)
 {
-	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
-		return -ENOMEM;
+	struct workqueue_attrs *attrs;
+	int err = -ENOMEM;
 
+	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
+		goto out;
 	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_online_mask);
-	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
-		free_cpumask_var(pd->cpumask.pcpu);
-		return -ENOMEM;
-	}
 
+	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL))
+		goto free_pcpu_mask;
 	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_online_mask);
+
+	attrs = alloc_workqueue_attrs();
+	if (!attrs)
+		goto free_cbcpu_mask;
+
+	/* Restrict parallel_wq workers to pd->cpumask.pcpu. */
+	cpumask_copy(attrs->cpumask, pd->cpumask.pcpu);
+	err = apply_workqueue_attrs(pd->pinst->parallel_wq, attrs);
+	free_workqueue_attrs(attrs);
+	if (err < 0)
+		goto free_cbcpu_mask;
+
 	return 0;
+
+free_cbcpu_mask:
+	free_cpumask_var(pd->cpumask.cbcpu);
+free_pcpu_mask:
+	free_cpumask_var(pd->cpumask.pcpu);
+out:
+	return err;
 }
 
 static void __padata_list_init(struct padata_list *pd_list)
@@ -428,6 +439,8 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	pd->squeue = alloc_percpu(struct padata_serial_queue);
 	if (!pd->squeue)
 		goto err_free_pqueue;
+
+	pd->pinst = pinst;
 	if (padata_setup_cpumasks(pd, pcpumask, cbcpumask) < 0)
 		goto err_free_squeue;
 
@@ -437,7 +450,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	/* Initial ref dropped in padata_flush_queues. */
 	atomic_set(&pd->refcnt, 1);
 	init_completion(&pd->flushing_done);
-	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
@@ -920,8 +932,8 @@ static struct padata_instance *padata_alloc(const char *name,
 	if (!pinst)
 		goto err;
 
-	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_MEM_RECLAIM |
-					     WQ_CPU_INTENSIVE, 1, name);
+	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_UNBOUND, 0,
+					     name);
 	if (!pinst->parallel_wq)
 		goto err_free_inst;
 
-- 
2.23.0

