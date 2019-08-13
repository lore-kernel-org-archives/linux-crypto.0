Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFEFC32753
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C7E20842
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jjo4/Ieh";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TQBfQYNU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfHMAxK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57708 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMAxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nI2C169513;
        Tue, 13 Aug 2019 00:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=BT3Qu5ImazUq0glEJ/38QFS1wg4jo/CdGADNQX8MmGI=;
 b=jjo4/IehyhWwOy5LkPz1sCxrez0G3zFYFWaf9wcnH0Ved17AfCHNWTiDMBtmmGO1pHuE
 pOAsnqgj7/7GG7e8BgC8vxLKDpRVnQNv31j4dPvtAwbbKkoMABgg5ylEVSRS8TcJ2jds
 ZXDG1a3nxMwP0VXjWJyWAyFMHR1fVfjT6kI1oScYgcdvPR1NZyux8l3L+/IIN4WL+vW4
 IpP0MPHh7snzHSoUUepg1+nvIfb5d5d6k5zg16Cp62CTmDNchgMiy73+GvjiHyxmNEYx
 hoMFYqD8LU+QWDG/URjaYSQpYhmmz0wKcaJa7YeQ37Bf1DUJH04opn/fVFLz8d/oBqYn jQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=BT3Qu5ImazUq0glEJ/38QFS1wg4jo/CdGADNQX8MmGI=;
 b=TQBfQYNURzIGHKTm7VbWez+aWkeS4kYjIPDwJPAzAKEqK7eJ5w1aRmHpNHZxlcanJwuP
 pGg2j9ntsNAFerIOCerCOuhCHDOM75JL4C6gx/srxW4fLLga/f8+3a4im3sWcCLbHma5
 cW2G0KCfdu9wcAw5k3DL38mdMQQf1NJRG2wBQmFZ6cQ96HmYt3L3G8k8gYNR/I0v28Od
 6mDo7mZ6/BUFzN6gYUTbcZ0/mS1lCTfkk+1rJ4WgQI1aG7etfiXITekeafIfhXBbc8uH
 8dWzL2Z6OFIMkK2IefttOLGBOvst3xOaC7PftXunu71qWCILKrbiKmaJiKME+Ljapyy7 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u9pjqarj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nIqY152549;
        Tue, 13 Aug 2019 00:52:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u9k1vuuyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:47 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D0qkG0007372;
        Tue, 13 Aug 2019 00:52:46 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:46 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] padata: unbind parallel jobs from specific CPUs
Date:   Mon, 12 Aug 2019 20:52:23 -0400
Message-Id: <20190813005224.30779-9-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Padata binds the parallel part of a job to a single CPU.  Though the
serial parts rely on per-CPU queues, it's not necessary for the parallel
part, and it's beneficial to run the job locally on NUMA machines
and let the scheduler pick the CPU within a node on a busy system.

So, make the parallel workqueue unbound.

Update the parallel workqueue's cpumask when the instance's parallel
cpumask changes.

Now that parallel jobs no longer run on max_active=1 workqueues, two or
more parallel works that hash to the same CPU may run simultaneously,
finish out of order, and so be serialized out of order.  Prevent this by
keeping the works sorted on the reorder list by sequence number and
teaching padata_get_next about it.

The ENODATA case in padata_get_next no longer makes sense because
parallel jobs aren't bound to specific CPUs.  The EINPROGRESS case takes
care of the scenario where a parallel job is potentially running on the
same CPU as padata_get_next.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  4 +-
 kernel/padata.c        | 97 +++++++++++++++++++++++-------------------
 2 files changed, 57 insertions(+), 44 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index e7978f8942ca..cc420064186f 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -35,6 +35,7 @@ struct padata_priv {
 	struct parallel_data	*pd;
 	int			cb_cpu;
 	int			cpu;
+	unsigned int		seq_nr;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
@@ -104,7 +105,7 @@ struct padata_cpumask {
  * @squeue: percpu padata queues used for serialuzation.
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
- * @max_seq_nr:  Maximal used sequence number.
+ * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
  * @reorder_work: work struct for reordering.
@@ -117,6 +118,7 @@ struct parallel_data {
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	atomic_t			seq_nr;
+	unsigned int			processed;
 	int				cpu;
 	struct padata_cpumask		cpumask;
 	struct work_struct		reorder_work;
diff --git a/kernel/padata.c b/kernel/padata.c
index 1465f094640c..5615f6b60dab 100644
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
@@ -172,9 +168,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
- *
- * -ENODATA, if this cpu has to do the parallel processing for
- *  the next object.
  */
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
@@ -191,22 +184,25 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		padata = list_entry(reorder->list.next,
 				    struct padata_priv, list);
 
-		list_del_init(&padata->list);
-		atomic_dec(&pd->reorder_objects);
+		/*
+		 * The check fails in the unlikely event that two or more
+		 * parallel jobs have hashed to the same CPU and one of the
+		 * later ones finishes first.
+		 */
+		if (padata->seq_nr == pd->processed) {
+			list_del_init(&padata->list);
+			atomic_dec(&pd->reorder_objects);
 
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
-					    false);
+			++pd->processed;
+			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
+						    false);
 
-		spin_unlock(&reorder->lock);
-		goto out;
+			spin_unlock(&reorder->lock);
+			goto out;
+		}
 	}
 	spin_unlock(&reorder->lock);
 
-	if (__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
-		padata = ERR_PTR(-ENODATA);
-		goto out;
-	}
-
 	padata = ERR_PTR(-EINPROGRESS);
 out:
 	return padata;
@@ -244,16 +240,6 @@ static void padata_reorder(struct parallel_data *pd)
 		if (PTR_ERR(padata) == -EINPROGRESS)
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
 
@@ -332,9 +318,14 @@ void padata_do_serial(struct padata_priv *padata)
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
 	atomic_inc(&pd->reorder_objects);
 	spin_unlock(&pqueue->reorder.lock);
 
@@ -353,17 +344,36 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
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
@@ -429,6 +439,8 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	pd->squeue = alloc_percpu(struct padata_serial_queue);
 	if (!pd->squeue)
 		goto err_free_pqueue;
+
+	pd->pinst = pinst;
 	if (padata_setup_cpumasks(pd, pcpumask, cbcpumask) < 0)
 		goto err_free_squeue;
 
@@ -437,7 +449,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
-	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
@@ -978,8 +989,8 @@ static struct padata_instance *padata_alloc(const char *name,
 	if (!pinst)
 		goto err;
 
-	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_MEM_RECLAIM |
-					     WQ_CPU_INTENSIVE, 1, name);
+	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_UNBOUND, 0,
+					     name);
 	if (!pinst->parallel_wq)
 		goto err_free_inst;
 
-- 
2.22.0

