Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2618C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 22:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6935622DA7
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 22:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lZTMkDlh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfH1WS4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:18:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfH1WS4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 18:18:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMHIY2115541;
        Wed, 28 Aug 2019 22:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=q8UPrkMM/CujGokBaxFV4506SVYZkFz/veRW9ukkyvA=;
 b=lZTMkDlh6Dr2ZxANHoruFlDG3UO6nz6SA2jvkXZX2kksbMz1s9ypxfP2yHnA/ov4gUIm
 gQWGTTSm5TSZ6Ok6vL+7cQU7Cw8dib2QvT42jBC2ezuAlGr6W76WQMYgyzOD6cyC3bHZ
 UVfPu1+BE5jKGWozX9KbPDEvq6G8LmBN6MhIE1n+VnGOVs7V8v69r3uXmBWWKnLlDrXK
 z4laFGxF6GxmCTLAXad8ak0JZYkBbYOpOUyMKpVzoHOBbAYtiNCNUmZEFKTB6XLnnj7Z
 imZAdWncEZ8fYWV1DBoPgTIOtkzsSfTFp2vFneMw5RsTGtiTjqqvgVQU8CLJzrFLTqQo Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2up296g0h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:18:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMDOiP007293;
        Wed, 28 Aug 2019 22:16:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2untetyqh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SMGU3i020531;
        Wed, 28 Aug 2019 22:16:30 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:16:30 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 1/5] padata: make flushing work with async users
Date:   Wed, 28 Aug 2019 18:14:21 -0400
Message-Id: <20190828221425.22701-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280214
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata_flush_queues() is broken for an async ->parallel() function
because flush_work() can't wait on it:

  # modprobe tcrypt alg="pcrypt(cryptd(rfc4106(gcm_base(ctr(aes-generic),ghash-generic))))" type=3
  # modprobe tcrypt mode=215 sec=1 &
  # sleep 5; echo 7 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

  kernel BUG at kernel/padata.c:473!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 0 PID: 282 Comm: sh Not tainted 5.3.0-rc5-padata-base+ #3
  RIP: 0010:padata_flush_queues+0xa7/0xb0
  Call Trace:
   padata_replace+0xa1/0x110
   padata_set_cpumask+0xae/0x130
   store_cpumask+0x75/0xa0
   padata_sysfs_store+0x20/0x30
   ...

Wait instead for the parallel_data (pd) object's refcount to drop to
zero.

Simplify by taking an initial reference on a pd when allocating an
instance.  That ref is dropped during flushing, which allows calling
wait_for_completion() unconditionally.

If the initial ref weren't used, the only other alternative I could
think of is that complete() would be conditional on !PADATA_INIT or
PADATA_REPLACE (in addition to zero pd->refcnt), and
wait_for_completion() on nonzero pd->refcnt.  But then complete() could
be called without a matching wait:

completer                     waiter
---------                     ------
DEC pd->refcnt    // 0
                              pinst->flags |= PADATA_REPLACE
LOAD pinst->flags // REPLACE
                              LOAD pd->refcnt // 0
                              /* return without wait_for_completion() */
complete()

No more flushing per-CPU work items, so no more CPU hotplug lock in
__padata_stop.

Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Suggested-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  3 +++
 kernel/padata.c        | 32 ++++++++++++--------------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8da673861d99..1c73f9cc7b72 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/kobject.h>
+#include <linux/completion.h>
 
 #define PADATA_CPU_SERIAL   0x01
 #define PADATA_CPU_PARALLEL 0x02
@@ -104,6 +105,7 @@ struct padata_cpumask {
  * @squeue: percpu padata queues used for serialuzation.
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
+ * @flushing_done: Wait for all objects to be sent out.
  * @max_seq_nr:  Maximal used sequence number.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
@@ -116,6 +118,7 @@ struct parallel_data {
 	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
+	struct completion		flushing_done;
 	atomic_t			seq_nr;
 	int				cpu;
 	struct padata_cpumask		cpumask;
diff --git a/kernel/padata.c b/kernel/padata.c
index b60cc3dcee58..958166e23123 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -301,7 +301,8 @@ static void padata_serial_worker(struct work_struct *serial_work)
 		list_del_init(&padata->list);
 
 		padata->serial(padata);
-		atomic_dec(&pd->refcnt);
+		if (atomic_dec_return(&pd->refcnt) == 0)
+			complete(&pd->flushing_done);
 	}
 	local_bh_enable();
 }
@@ -423,7 +424,9 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_squeues(pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
-	atomic_set(&pd->refcnt, 0);
+	/* Initial ref dropped in padata_flush_queues. */
+	atomic_set(&pd->refcnt, 1);
+	init_completion(&pd->flushing_done);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
@@ -453,24 +456,15 @@ static void padata_free_pd(struct parallel_data *pd)
 /* Flush all objects out of the padata queues. */
 static void padata_flush_queues(struct parallel_data *pd)
 {
-	int cpu;
-	struct padata_parallel_queue *pqueue;
-	struct padata_serial_queue *squeue;
-
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		pqueue = per_cpu_ptr(pd->pqueue, cpu);
-		flush_work(&pqueue->work);
-	}
-
-	if (atomic_read(&pd->reorder_objects))
-		padata_reorder(pd);
+	if (!(pd->pinst->flags & PADATA_INIT))
+		return;
 
-	for_each_cpu(cpu, pd->cpumask.cbcpu) {
-		squeue = per_cpu_ptr(pd->squeue, cpu);
-		flush_work(&squeue->work);
-	}
+	if (atomic_dec_return(&pd->refcnt) == 0)
+		complete(&pd->flushing_done);
 
-	BUG_ON(atomic_read(&pd->refcnt) != 0);
+	wait_for_completion(&pd->flushing_done);
+	reinit_completion(&pd->flushing_done);
+	atomic_set(&pd->refcnt, 1);
 }
 
 static void __padata_start(struct padata_instance *pinst)
@@ -487,9 +481,7 @@ static void __padata_stop(struct padata_instance *pinst)
 
 	synchronize_rcu();
 
-	get_online_cpus();
 	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
-- 
2.23.0

