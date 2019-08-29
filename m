Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CB4C3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B5B921874
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WpPw99UE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfH2Rc6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:32:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44566 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbfH2Rc6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:32:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THTi5N121276;
        Thu, 29 Aug 2019 17:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=H0/g58Ti3RBu0trSXJbyxqtFqN/+XmUcOY+U5Vqoh2w=;
 b=WpPw99UEdBXdABNj+jLEUm8Oj6LncT4nRr/X6uLJjQbidSvowy5/STzNM8uSHjCxNW3P
 BEUhj4916uJYmUwoT+tBB1FsthEKTJcs23KRZesEJKdTXk3YmstxnH+8QdlwLrG4F0GX
 BQlZReFaLn0/qS+fF3pK/R0Eli3ezK42+PkkcFKKbosswdCcFH5QXsdAF4D2nVksXWTe
 +J9QyX46IuBrmffOudtDjh1C7hs+keYatUbUN0uG2TM+xZ5IsilzB+eXQtYeJvDY/siy
 OqXduKbAPrDzU0en5fEagUKdMfMjdkGKWgHDckwv0bfw6hxhYLcvb64DN9ZEVpdLLnju Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upk56r0rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWdBe008284;
        Thu, 29 Aug 2019 17:32:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0b2dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7THWf7W017326;
        Thu, 29 Aug 2019 17:32:41 GMT
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
Subject: [PATCH v2 7/9] padata: use separate workqueues for parallel and serial work
Date:   Thu, 29 Aug 2019 13:30:36 -0400
Message-Id: <20190829173038.21040-8-daniel.m.jordan@oracle.com>
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
 definitions=main-1908290185
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata currently uses one per-CPU workqueue per instance for all work.

Prepare for running parallel jobs on an unbound workqueue by introducing
dedicated workqueues for parallel and serial work.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  6 ++++--
 kernel/padata.c        | 28 ++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index e04f7d873adb..b5f18802d015 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -128,7 +128,8 @@ struct parallel_data {
  * struct padata_instance - The overall control structure.
  *
  * @cpu_notifier: cpu hotplug notifier.
- * @wq: The workqueue in use.
+ * @parallel_wq: The workqueue used for parallel work.
+ * @serial_wq: The workqueue used for serial work.
  * @pd: The internal control structure.
  * @cpumask: User supplied cpumasks for parallel and serial works.
  * @cpumask_change_notifier: Notifiers chain for user-defined notify
@@ -140,7 +141,8 @@ struct parallel_data {
  */
 struct padata_instance {
 	struct hlist_node		 node;
-	struct workqueue_struct		*wq;
+	struct workqueue_struct		*parallel_wq;
+	struct workqueue_struct		*serial_wq;
 	struct parallel_data		*pd;
 	struct padata_cpumask		cpumask;
 	struct blocking_notifier_head	 cpumask_change_notifier;
diff --git a/kernel/padata.c b/kernel/padata.c
index 29d44edd6733..eefe4dd3d979 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -152,7 +152,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	list_add_tail(&padata->list, &queue->parallel.list);
 	spin_unlock(&queue->parallel.lock);
 
-	queue_work_on(target_cpu, pinst->wq, &queue->work);
+	queue_work_on(target_cpu, pinst->parallel_wq, &queue->work);
 
 out:
 	rcu_read_unlock_bh();
@@ -260,7 +260,7 @@ static void padata_reorder(struct parallel_data *pd)
 		list_add_tail(&padata->list, &squeue->serial.list);
 		spin_unlock(&squeue->serial.lock);
 
-		queue_work_on(cb_cpu, pinst->wq, &squeue->work);
+		queue_work_on(cb_cpu, pinst->serial_wq, &squeue->work);
 	}
 
 	spin_unlock_bh(&pd->lock);
@@ -277,7 +277,7 @@ static void padata_reorder(struct parallel_data *pd)
 
 	next_queue = per_cpu_ptr(pd->pqueue, pd->cpu);
 	if (!list_empty(&next_queue->reorder.list))
-		queue_work(pinst->wq, &pd->reorder_work);
+		queue_work(pinst->serial_wq, &pd->reorder_work);
 }
 
 static void invoke_padata_reorder(struct work_struct *work)
@@ -770,7 +770,8 @@ static void __padata_free(struct padata_instance *pinst)
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
-	destroy_workqueue(pinst->wq);
+	destroy_workqueue(pinst->serial_wq);
+	destroy_workqueue(pinst->parallel_wq);
 	kfree(pinst);
 }
 
@@ -919,18 +920,23 @@ static struct padata_instance *padata_alloc(const char *name,
 	if (!pinst)
 		goto err;
 
-	pinst->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
-				    1, name);
-	if (!pinst->wq)
+	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_MEM_RECLAIM |
+					     WQ_CPU_INTENSIVE, 1, name);
+	if (!pinst->parallel_wq)
 		goto err_free_inst;
 
 	get_online_cpus();
 
-	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+	pinst->serial_wq = alloc_workqueue("%s_serial", WQ_MEM_RECLAIM |
+					   WQ_CPU_INTENSIVE, 1, name);
+	if (!pinst->serial_wq)
 		goto err_put_cpus;
+
+	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+		goto err_free_serial_wq;
 	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
 		free_cpumask_var(pinst->cpumask.pcpu);
-		goto err_put_cpus;
+		goto err_free_serial_wq;
 	}
 	if (!padata_validate_cpumask(pinst, pcpumask) ||
 	    !padata_validate_cpumask(pinst, cbcpumask))
@@ -964,9 +970,11 @@ static struct padata_instance *padata_alloc(const char *name,
 err_free_masks:
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
+err_free_serial_wq:
+	destroy_workqueue(pinst->serial_wq);
 err_put_cpus:
 	put_online_cpus();
-	destroy_workqueue(pinst->wq);
+	destroy_workqueue(pinst->parallel_wq);
 err_free_inst:
 	kfree(pinst);
 err:
-- 
2.23.0

