Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5118C433E4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BCA321527
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qNmGCxx8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgGNUOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:14:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbgGNUOK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:14:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKD8t2183123;
        Tue, 14 Jul 2020 20:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=vsjD5ee+bGgKLmwKIQKaNUvTUUyqivZPsjjxT08GgJQ=;
 b=qNmGCxx815FpgUGoFltG78CROZx40cltH8NvZFB8lCiLl71HSGjBaaVm2qXYnGjF3K6Y
 WYWbo2X96bS6kQA3Hd0FzRXXUUc9oqO+RIILGOdpUcERrXFKG5a3q1FaQvAEg4o3MNDn
 oJtbRU1OHyuupUaNYJx60k7aCvDbkUktdN6OfjzRMi1EF7bvP8Ta+aXaUiGl952rs9br
 Wkwl0a6qaOHKGggA9WGokwA6HCzU3kisb1jnjxtARj8RYA2vhBa36MMftLnx4cyo8zZc
 Tv8k5tD1SurwvPHezoPhOqUqk1yv5d0UP961vK49gptlN56gU2RuHqSPpE2MiOEGIYR+ Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm7mp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:14:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDaJY129988;
        Tue, 14 Jul 2020 20:14:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb54acg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06EKE3pU010033;
        Tue, 14 Jul 2020 20:14:03 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:03 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 6/6] padata: remove padata_parallel_queue
Date:   Tue, 14 Jul 2020 16:13:56 -0400
Message-Id: <20200714201356.889176-7-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Only its reorder field is actually used now, so remove the struct and
embed @reorder directly in parallel_data.

No functional change, just a cleanup.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h | 15 ++------------
 kernel/padata.c        | 46 ++++++++++++++++++------------------------
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 070a7d43e8af8..a433f13fc4bf7 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -66,17 +66,6 @@ struct padata_serial_queue {
        struct parallel_data *pd;
 };
 
-/**
- * struct padata_parallel_queue - The percpu padata parallel queue
- *
- * @reorder: List to wait for reordering after parallel processing.
- * @num_obj: Number of objects that are processed by this cpu.
- */
-struct padata_parallel_queue {
-       struct padata_list    reorder;
-       atomic_t              num_obj;
-};
-
 /**
  * struct padata_cpumask - The cpumasks for the parallel/serial workers
  *
@@ -93,7 +82,7 @@ struct padata_cpumask {
  * that depends on the cpumask in use.
  *
  * @ps: padata_shell object.
- * @pqueue: percpu padata queues used for parallelization.
+ * @reorder_list: percpu reorder lists
  * @squeue: percpu padata queues used for serialuzation.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @seq_nr: Sequence number of the parallelized data object.
@@ -105,7 +94,7 @@ struct padata_cpumask {
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-	struct padata_parallel_queue	__percpu *pqueue;
+	struct padata_list		__percpu *reorder_list;
 	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			refcnt;
 	unsigned int			seq_nr;
diff --git a/kernel/padata.c b/kernel/padata.c
index 1c0b97891edb8..16cb894dc272b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -250,13 +250,11 @@ EXPORT_SYMBOL(padata_do_parallel);
 static struct padata_priv *padata_find_next(struct parallel_data *pd,
 					    bool remove_object)
 {
-	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 	int cpu = pd->cpu;
 
-	next_queue = per_cpu_ptr(pd->pqueue, cpu);
-	reorder = &next_queue->reorder;
+	reorder = per_cpu_ptr(pd->reorder_list, cpu);
 
 	spin_lock(&reorder->lock);
 	if (list_empty(&reorder->list)) {
@@ -291,7 +289,7 @@ static void padata_reorder(struct parallel_data *pd)
 	int cb_cpu;
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
-	struct padata_parallel_queue *next_queue;
+	struct padata_list *reorder;
 
 	/*
 	 * We need to ensure that only one cpu can work on dequeueing of
@@ -339,9 +337,8 @@ static void padata_reorder(struct parallel_data *pd)
 	 */
 	smp_mb();
 
-	next_queue = per_cpu_ptr(pd->pqueue, pd->cpu);
-	if (!list_empty(&next_queue->reorder.list) &&
-	    padata_find_next(pd, false))
+	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
+	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
 		queue_work(pinst->serial_wq, &pd->reorder_work);
 }
 
@@ -401,17 +398,16 @@ void padata_do_serial(struct padata_priv *padata)
 {
 	struct parallel_data *pd = padata->pd;
 	int hashed_cpu = padata_cpu_hash(pd, padata->seq_nr);
-	struct padata_parallel_queue *pqueue = per_cpu_ptr(pd->pqueue,
-							   hashed_cpu);
+	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
 	struct padata_priv *cur;
 
-	spin_lock(&pqueue->reorder.lock);
+	spin_lock(&reorder->lock);
 	/* Sort in ascending order of sequence number. */
-	list_for_each_entry_reverse(cur, &pqueue->reorder.list, list)
+	list_for_each_entry_reverse(cur, &reorder->list, list)
 		if (cur->seq_nr < padata->seq_nr)
 			break;
 	list_add(&padata->list, &cur->list);
-	spin_unlock(&pqueue->reorder.lock);
+	spin_unlock(&reorder->lock);
 
 	/*
 	 * Ensure the addition to the reorder list is ordered correctly
@@ -553,17 +549,15 @@ static void padata_init_squeues(struct parallel_data *pd)
 	}
 }
 
-/* Initialize all percpu queues used by parallel workers */
-static void padata_init_pqueues(struct parallel_data *pd)
+/* Initialize per-CPU reorder lists */
+static void padata_init_reorder_list(struct parallel_data *pd)
 {
 	int cpu;
-	struct padata_parallel_queue *pqueue;
+	struct padata_list *list;
 
 	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		pqueue = per_cpu_ptr(pd->pqueue, cpu);
-
-		__padata_list_init(&pqueue->reorder);
-		atomic_set(&pqueue->num_obj, 0);
+		list = per_cpu_ptr(pd->reorder_list, cpu);
+		__padata_list_init(list);
 	}
 }
 
@@ -577,13 +571,13 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	if (!pd)
 		goto err;
 
-	pd->pqueue = alloc_percpu(struct padata_parallel_queue);
-	if (!pd->pqueue)
+	pd->reorder_list = alloc_percpu(struct padata_list);
+	if (!pd->reorder_list)
 		goto err_free_pd;
 
 	pd->squeue = alloc_percpu(struct padata_serial_queue);
 	if (!pd->squeue)
-		goto err_free_pqueue;
+		goto err_free_reorder_list;
 
 	pd->ps = ps;
 
@@ -595,7 +589,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	cpumask_and(pd->cpumask.pcpu, pinst->cpumask.pcpu, cpu_online_mask);
 	cpumask_and(pd->cpumask.cbcpu, pinst->cpumask.cbcpu, cpu_online_mask);
 
-	padata_init_pqueues(pd);
+	padata_init_reorder_list(pd);
 	padata_init_squeues(pd);
 	pd->seq_nr = -1;
 	atomic_set(&pd->refcnt, 1);
@@ -609,8 +603,8 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	free_cpumask_var(pd->cpumask.pcpu);
 err_free_squeue:
 	free_percpu(pd->squeue);
-err_free_pqueue:
-	free_percpu(pd->pqueue);
+err_free_reorder_list:
+	free_percpu(pd->reorder_list);
 err_free_pd:
 	kfree(pd);
 err:
@@ -621,7 +615,7 @@ static void padata_free_pd(struct parallel_data *pd)
 {
 	free_cpumask_var(pd->cpumask.pcpu);
 	free_cpumask_var(pd->cpumask.cbcpu);
-	free_percpu(pd->pqueue);
+	free_percpu(pd->reorder_list);
 	free_percpu(pd->squeue);
 	kfree(pd);
 }
-- 
2.27.0

