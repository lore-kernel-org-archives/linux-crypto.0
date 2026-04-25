Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E63F346E56;
	Sat, 25 Apr 2026 08:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777104897; cv=none; b=QDAejMF6THYrKXdM20TblfOhZXdaaAxGvjmmfUQeWIuGZ3RVc7Hn3unjHyat4SU30NwU01lzy78P0/+NAnNhsQunSdz9fkztjAcg8YDAU2Wazl5KyD0EG9vdHSCF0qIoJKIa0h66bvTGlIuVjoyiukFPwNctWQ9bdfVj+fvbikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777104897; c=relaxed/simple;
	bh=kqmTSRgoAuNXllU0bu0bKbI7j5dTCeUCOXI/C1A1lvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZk3kEEIrVTQxncWECNKtZbfxSvzcNMi+3SBVCOvnfZw14wVf5HimQGtDidV8QNQsaLoV0oTvHGJFqQOZw6DerizmHgFxR0HQeorUnNs/TWNMcm3o7aemS//En5AivVDb4zPgRpfHb8fcIIQmYtnBYFj/C0GGVKLxHDh/2GU5lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=IUD/5QEB; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="IUD/5QEB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=IUD/5QEBc9vblGgVkweIpE4UvM/Q3/od17Z9vLHO0yjry2UaY6f2LkRAwC9dA98JlA58+3R2Hj42M
	 oyAjQ9fk8Ik6kY5hBByQnzGYIm8e3WGx/8HGc8z6JMAET4C0DWr/LIt5ad2hB9vinn5ky8GHKhkrlc
	 WX+brSRvwSrGWqK8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from  (unknown[183.241.55.34])
	by rmsmtp-lg-appmail-42-12056 (RichMail) with SMTP id 2f1869ec77eaa3d-00a50;
	Sat, 25 Apr 2026 16:14:41 +0800 (CST)
X-RM-TRANSID:2f1869ec77eaa3d-00a50
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12.y 1/2] padata: Fix pd UAF once and for all
Date: Sat, 25 Apr 2026 16:14:29 +0800
Message-ID: <20260425081433.2763-2-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260425081433.2763-1-lanbincn@139.com>
References: <20260425081433.2763-1-lanbincn@139.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 71203f68c7749609d7fc8ae6ad054bdedeb24f91 ]

There is a race condition/UAF in padata_reorder that goes back
to the initial commit.  A reference count is taken at the start
of the process in padata_do_parallel, and released at the end in
padata_serial_worker.

This reference count is (and only is) required for padata_replace
to function correctly.  If padata_replace is never called then
there is no issue.

In the function padata_reorder which serves as the core of padata,
as soon as padata is added to queue->serial.list, and the associated
spin lock released, that padata may be processed and the reference
count on pd would go away.

Fix this by getting the next padata before the squeue->serial lock
is released.

In order to make this possible, simplify padata_reorder by only
calling it once the next padata arrives.

Fixes: 16295bec6398 ("padata: Generic parallelization/serialization interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ Adjust context of padata_find_next(). Replace
cpumask_next_wrap(cpu, pd->cpumask.pcpu) with
cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false) in padata_reorder() in
v6.12 according to dc5bb9b769c9 ("cpumask: deprecate cpumask_next_wrap()") and
f954a2d37637 ("padata: switch padata_find_next() to using cpumask_next_wrap()")
. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
---
 include/linux/padata.h |   3 -
 kernel/padata.c        | 136 +++++++++++------------------------------
 2 files changed, 37 insertions(+), 102 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 0146daf34430..b486c7359de2 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -91,7 +91,6 @@ struct padata_cpumask {
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
  * @reorder_work: work struct for reordering.
- * @lock: Reorder lock.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
@@ -102,8 +101,6 @@ struct parallel_data {
 	unsigned int			processed;
 	int				cpu;
 	struct padata_cpumask		cpumask;
-	struct work_struct		reorder_work;
-	spinlock_t                      ____cacheline_aligned lock;
 };
 
 /**
diff --git a/kernel/padata.c b/kernel/padata.c
index c3810f5bd715..e61bdc248551 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -261,20 +261,17 @@ EXPORT_SYMBOL(padata_do_parallel);
  *   be parallel processed by another cpu and is not yet present in
  *   the cpu's reorder queue.
  */
-static struct padata_priv *padata_find_next(struct parallel_data *pd,
-					    bool remove_object)
+static struct padata_priv *padata_find_next(struct parallel_data *pd, int cpu,
+					    unsigned int processed)
 {
 	struct padata_priv *padata;
 	struct padata_list *reorder;
-	int cpu = pd->cpu;
 
 	reorder = per_cpu_ptr(pd->reorder_list, cpu);
 
 	spin_lock(&reorder->lock);
-	if (list_empty(&reorder->list)) {
-		spin_unlock(&reorder->lock);
-		return NULL;
-	}
+	if (list_empty(&reorder->list))
+		goto notfound;
 
 	padata = list_entry(reorder->list.next, struct padata_priv, list);
 
@@ -282,101 +279,52 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 	 * Checks the rare case where two or more parallel jobs have hashed to
 	 * the same CPU and one of the later ones finishes first.
 	 */
-	if (padata->seq_nr != pd->processed) {
-		spin_unlock(&reorder->lock);
-		return NULL;
-	}
-
-	if (remove_object) {
-		list_del_init(&padata->list);
-		++pd->processed;
-		/* When sequence wraps around, reset to the first CPU. */
-		if (unlikely(pd->processed == 0))
-			pd->cpu = cpumask_first(pd->cpumask.pcpu);
-		else
-			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
-	}
+	if (padata->seq_nr != processed)
+		goto notfound;
 
+	list_del_init(&padata->list);
 	spin_unlock(&reorder->lock);
 	return padata;
+
+notfound:
+	pd->processed = processed;
+	pd->cpu = cpu;
+	spin_unlock(&reorder->lock);
+	return NULL;
 }
 
-static void padata_reorder(struct parallel_data *pd)
+static void padata_reorder(struct padata_priv *padata)
 {
+	struct parallel_data *pd = padata->pd;
 	struct padata_instance *pinst = pd->ps->pinst;
-	int cb_cpu;
-	struct padata_priv *padata;
-	struct padata_serial_queue *squeue;
-	struct padata_list *reorder;
+	unsigned int processed;
+	int cpu;
 
-	/*
-	 * We need to ensure that only one cpu can work on dequeueing of
-	 * the reorder queue the time. Calculating in which percpu reorder
-	 * queue the next object will arrive takes some time. A spinlock
-	 * would be highly contended. Also it is not clear in which order
-	 * the objects arrive to the reorder queues. So a cpu could wait to
-	 * get the lock just to notice that there is nothing to do at the
-	 * moment. Therefore we use a trylock and let the holder of the lock
-	 * care for all the objects enqueued during the holdtime of the lock.
-	 */
-	if (!spin_trylock_bh(&pd->lock))
-		return;
+	processed = pd->processed;
+	cpu = pd->cpu;
 
-	while (1) {
-		padata = padata_find_next(pd, true);
+	do {
+		struct padata_serial_queue *squeue;
+		int cb_cpu;
 
-		/*
-		 * If the next object that needs serialization is parallel
-		 * processed by another cpu and is still on it's way to the
-		 * cpu's reorder queue, nothing to do for now.
-		 */
-		if (!padata)
-			break;
+		cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
+		processed++;
 
 		cb_cpu = padata->cb_cpu;
 		squeue = per_cpu_ptr(pd->squeue, cb_cpu);
 
 		spin_lock(&squeue->serial.lock);
 		list_add_tail(&padata->list, &squeue->serial.list);
-		spin_unlock(&squeue->serial.lock);
-
 		queue_work_on(cb_cpu, pinst->serial_wq, &squeue->work);
-	}
 
-	spin_unlock_bh(&pd->lock);
-
-	/*
-	 * The next object that needs serialization might have arrived to
-	 * the reorder queues in the meantime.
-	 *
-	 * Ensure reorder queue is read after pd->lock is dropped so we see
-	 * new objects from another task in padata_do_serial.  Pairs with
-	 * smp_mb in padata_do_serial.
-	 */
-	smp_mb();
-
-	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
-	if (!list_empty(&reorder->list) && padata_find_next(pd, false)) {
 		/*
-		 * Other context(eg. the padata_serial_worker) can finish the request.
-		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
+		 * If the next object that needs serialization is parallel
+		 * processed by another cpu and is still on it's way to the
+		 * cpu's reorder queue, end the loop.
 		 */
-		padata_get_pd(pd);
-		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
-			padata_put_pd(pd);
-	}
-}
-
-static void invoke_padata_reorder(struct work_struct *work)
-{
-	struct parallel_data *pd;
-
-	local_bh_disable();
-	pd = container_of(work, struct parallel_data, reorder_work);
-	padata_reorder(pd);
-	local_bh_enable();
-	/* Pairs with putting the reorder_work in the serial_wq */
-	padata_put_pd(pd);
+		padata = padata_find_next(pd, cpu, processed);
+		spin_unlock(&squeue->serial.lock);
+	} while (padata);
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
@@ -427,6 +375,7 @@ void padata_do_serial(struct padata_priv *padata)
 	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
 	struct padata_priv *cur;
 	struct list_head *pos;
+	bool gotit = true;
 
 	spin_lock(&reorder->lock);
 	/* Sort in ascending order of sequence number. */
@@ -436,17 +385,14 @@ void padata_do_serial(struct padata_priv *padata)
 		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
 			break;
 	}
-	list_add(&padata->list, pos);
+	if (padata->seq_nr != pd->processed) {
+		gotit = false;
+		list_add(&padata->list, pos);
+	}
 	spin_unlock(&reorder->lock);
 
-	/*
-	 * Ensure the addition to the reorder list is ordered correctly
-	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
-	 * in padata_reorder.
-	 */
-	smp_mb();
-
-	padata_reorder(pd);
+	if (gotit)
+		padata_reorder(padata);
 }
 EXPORT_SYMBOL(padata_do_serial);
 
@@ -643,9 +589,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_squeues(pd);
 	pd->seq_nr = -1;
 	refcount_set(&pd->refcnt, 1);
-	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
-	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
 
@@ -1155,12 +1099,6 @@ void padata_free_shell(struct padata_shell *ps)
 	if (!ps)
 		return;
 
-	/*
-	 * Wait for all _do_serial calls to finish to avoid touching
-	 * freed pd's and ps's.
-	 */
-	synchronize_rcu();
-
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	pd = rcu_dereference_protected(ps->pd, 1);
-- 
2.43.0


