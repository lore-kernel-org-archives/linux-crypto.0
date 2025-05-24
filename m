Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B74194A44;
	Sat, 24 May 2025 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748083871; cv=none; b=bnTA0I1JBmrdylvUvyXEznK4APaQ41zvveu1KIPnm4kcoQrw4GTcezpjF2VSGnTAEPKo8vw9hwhFPHd/qyOGcuFtczB5UPIev590vNoa+eQfNgh1O33r/IDg0A9+rAzrN2yirss5OMjAl9Z0gctTLWsg3gRh4sX0v2FmcF/dDXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748083871; c=relaxed/simple;
	bh=JFu+VS20vdBLFIFDEhWFhFFvqU64yvYzJ6PwaZnXicM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tWqK2nkIIF0SmcdLOmZ9mq2UW4dZTziNZ210186TaRVQQ/MFeYmRjANC4L+FQg19a94VclaP39HffXylA9scZVt7ZNw65qVLyPAjFyhxo9qWwk36Y7tMIsYCwd9FqLShA7I64El1UzsfGAq90Zz9gEcLOvgRJiQ2LyNaozkXYmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dkV7GpPc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dkV7GpPc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lAAhk3vaszMpnBqCvw+YiMCd4Qo0RXVUB1sigsGC61U=; b=dkV7GpPcIe15ZJMkZ5AokG5mwl
	hzoihBhR8BdFYGMdKFTeAQrSXvrPoqP3jyAeTc5jGellq5wHPiWJ3GBSOIEIRBIksetaVyGWy8jhB
	bqRfNAcAXikWtOwuUvIo1L5WtC5wilUqPFJOdgcx5Of0Ta96fGWcWckv8mdnpHIuVHAhV9kYc/JZw
	xRP0UcQCwMA/3WmPwX0/DrF2XLh7AquJsS4IF+hrI0+xxpzhGrmfmN5jXorbDWE/y4+ovKt4Roapi
	pVO0CmkRlxUElvBZb2Dgh+TsBZjHa85TgbizqwDahbUOjo9Ol95i/KE1pahuY2u19JPP5SxDzTvfC
	CQvTsfAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uImSy-008WmO-2a;
	Sat, 24 May 2025 18:51:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 May 2025 18:51:00 +0800
Date: Sat, 24 May 2025 18:51:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
	Chen Ridong <chenridong@huawei.com>,
	WangJinchao <wangjinchao@xfusion.com>
Subject: [PATCH] padata: Fix pd UAF once and for all
Message-ID: <aDGklJE5JKOpM7A_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
---
 include/linux/padata.h |   3 -
 kernel/padata.c        | 135 ++++++++++++-----------------------------
 2 files changed, 39 insertions(+), 99 deletions(-)

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
index 7eee94166357..45aeed9a0e55 100644
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
 
@@ -282,97 +279,52 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
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
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
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
+		cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
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
@@ -423,6 +375,7 @@ void padata_do_serial(struct padata_priv *padata)
 	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
 	struct padata_priv *cur;
 	struct list_head *pos;
+	bool gotit = true;
 
 	spin_lock(&reorder->lock);
 	/* Sort in ascending order of sequence number. */
@@ -432,17 +385,14 @@ void padata_do_serial(struct padata_priv *padata)
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
 
@@ -632,9 +582,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_squeues(pd);
 	pd->seq_nr = -1;
 	refcount_set(&pd->refcnt, 1);
-	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
-	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
 
@@ -1144,16 +1092,11 @@ void padata_free_shell(struct padata_shell *ps)
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
-	padata_put_pd(pd);
+	if (!WARN_ON(refcount_read(&pd->refcnt) != 1))
+		padata_free_pd(pd);
 	mutex_unlock(&ps->pinst->lock);
 
 	kfree(ps);

base-commit: b2df03ed4052e97126267e8c13ad4204ea6ba9b6
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
