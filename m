Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AF23A1DB;
	Sun, 19 Apr 2026 18:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776624104; cv=none; b=hYLYRi59oDSXxu94DDyHWLhUgREY21LTtTuAOapANne4jfzJt8dB1qFUK5uka9ta9/VaHhfp9X5UkBLOOZhy0wngYdACbHLFoyiTeRjEAzEadg7s5hv1rEHjGF9XRAMBO0lFumvw8TQaiy8uzh/5EYoYPrxyo+A6AEfZcGHl35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776624104; c=relaxed/simple;
	bh=Z0nKu27p8C68xpJK5RZNADvF0bWMDnOcv0i/hztohBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jgor6yQzH7rFxbgqeZjQh9wwoRWuy4fkL6u30A72ODOCTTTHPWINOdZIGHUKpUov6g9GhMv3LWjOWkoXJhz+EM7iMgVlRRbDQ73yQdL7BK56BMXwZExKdvqMLizPpkigIoZrSIGSyWuu3m0dXLRb73FjbgQX9W5C2FNtvNCPU3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gu8ohDCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gu8ohDCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45175C2BCAF;
	Sun, 19 Apr 2026 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776624104;
	bh=Z0nKu27p8C68xpJK5RZNADvF0bWMDnOcv0i/hztohBY=;
	h=From:To:Cc:Subject:Date:From;
	b=gu8ohDCpt+6Lo/+XMd4SbJU74+WsntftR2nUltOWK6vsdbDHArAA10BVJlh6fE9hf
	 6E8COI5ZGycTM9QdI5SNTgMU3xoyBF+UP/Gp1lsr08nILoaWw8PKj6eGRazd/t0gcp
	 Fu+8gUT0YXhivqrQ4af0EBESHbei28XYLGlcPsahoiRJOG/gVw1YtWjWwE6D55B+Jm
	 iofwJMGdL2XOc3dqUN6rY8l2pZzHppjCjPZ6hE3QivmVFF4GXm802eDDrlm575YTKi
	 MvZ71RfEN6zfPCscdpMGnkf81Rp6U3HKDGS5eMrPoEhdgRUDRsTGBtV+OhQA+pcIz5
	 f1gpfCRbbcmjg==
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [RFC PATCH] rhashtable: Bounce deferred worker kick through irq_work
 when insecure_elasticity is set
Date: Sun, 19 Apr 2026 08:19:33 -1000
Message-ID: <67fedbf2-914b-44f7-9422-1fe97d833705@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

insecure_elasticity allows rhashtable inserts under raw spinlocks by
disabling the synchronous grow path. Inserts past 75% load still call
schedule_work(&ht->run_work) to kick an async resize. schedule_work()
under a raw spinlock records

  caller_lock -> pool->lock -> pi_lock -> rq->__lock

A cycle forms if any of these locks is acquired in the reverse
direction elsewhere. sched_ext, the only current user of the flag,
hits this: it holds scx_sched_lock across rhashtable inserts of
sub-schedulers, while scx_bypass() takes rq->__lock -> scx_sched_lock.
Exercising the resize path produces:

  Chain exists of:
    &pool->lock --> &rq->__lock --> scx_sched_lock

Route the kick through irq_work when insecure_elasticity is set so
schedule_work() runs from hard IRQ context with the caller's lock no
longer held.

Fixes: 73bd1227787b ("rhashtable: Restore insecure_elasticity toggle")
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Herbert,

The lockdep splat described above is reproducible on sched_ext (the
only current insecure_elasticity user) and this patch clears it.
Verified with CONFIG_PROVE_LOCKING=y.

What do you think? Could also be a separate flag if you'd prefer to
keep insecure_elasticity strictly about elasticity.

Thanks.

 include/linux/rhashtable-types.h |  4 ++++
 include/linux/rhashtable.h       | 17 +++++++++++++++++
 lib/rhashtable.c                 | 16 ++++++++++++----
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 72082428d6c6..50b70d470e02 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -12,6 +12,7 @@
 #include <linux/alloc_tag.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <linux/irq_work_types.h>
 #include <linux/mutex.h>
 #include <linux/workqueue_types.h>

@@ -77,6 +78,8 @@ struct rhashtable_params {
  * @p: Configuration parameters
  * @rhlist: True if this is an rhltable
  * @run_work: Deferred worker to expand/shrink asynchronously
+ * @run_irq_work: Used in place of @run_work when @p.insecure_elasticity is
+ *		  set. See rhashtable_kick_deferred_worker().
  * @mutex: Mutex to protect current/future table swapping
  * @lock: Spin lock to protect walker list
  * @nelems: Number of elements in table
@@ -88,6 +91,7 @@ struct rhashtable {
 	struct rhashtable_params	p;
 	bool				rhlist;
 	struct work_struct		run_work;
+	struct irq_work			run_irq_work;
 	struct mutex                    mutex;
 	spinlock_t			lock;
 	atomic_t			nelems;
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 7def3f0f556b..300e1139cdca 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -20,6 +20,7 @@

 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/irq_work.h>
 #include <linux/jhash.h>
 #include <linux/list_nulls.h>
 #include <linux/workqueue.h>
@@ -747,6 +748,22 @@ static __always_inline struct rhlist_head *rhltable_lookup_likely(
 	return likely(he) ? container_of(he, struct rhlist_head, rhead) : NULL;
 }

+/*
+ * Kick the deferred rehash worker. With insecure_elasticity the caller may
+ * hold a raw spinlock. schedule_work() under a raw spinlock records
+ * caller_lock -> pool->lock -> pi_lock -> rq->__lock. If any of these
+ * locks is acquired in the reverse direction elsewhere, the cycle closes.
+ * Bounce through irq_work so schedule_work() runs from hard IRQ context
+ * with the caller's lock no longer held.
+ */
+static void rhashtable_kick_deferred_worker(struct rhashtable *ht)
+{
+	if (ht->p.insecure_elasticity)
+		irq_work_queue(&ht->run_irq_work);
+	else
+		schedule_work(&ht->run_work);
+}
+
 /* Internal function, please use rhashtable_insert_fast() instead. This
  * function returns the existing element already in hashes if there is a clash,
  * otherwise it returns an error via ERR_PTR().
@@ -847,7 +864,7 @@ static __always_inline void *__rhashtable_insert_fast(
 	rht_assign_unlock(tbl, bkt, obj, flags);

 	if (rht_grow_above_75(ht, tbl))
-		schedule_work(&ht->run_work);
+		rhashtable_kick_deferred_worker(ht);

 	data = NULL;
 out:
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index fb2b7bc137ba..951e90116889 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -442,7 +442,15 @@ static void rht_deferred_worker(struct work_struct *work)
 	mutex_unlock(&ht->mutex);

 	if (err)
-		schedule_work(&ht->run_work);
+		rhashtable_kick_deferred_worker(ht);
+}
+
+static void rht_deferred_irq_work(struct irq_work *irq_work)
+{
+	struct rhashtable *ht = container_of(irq_work, struct rhashtable,
+					     run_irq_work);
+
+	schedule_work(&ht->run_work);
 }

 static int rhashtable_insert_rehash(struct rhashtable *ht,
@@ -477,7 +485,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 		if (err == -EEXIST)
 			err = 0;
 	} else
-		schedule_work(&ht->run_work);
+		rhashtable_kick_deferred_worker(ht);

 	return err;

@@ -488,7 +496,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,

 	/* Schedule async rehash to retry allocation in process context. */
 	if (err == -ENOMEM)
-		schedule_work(&ht->run_work);
+		rhashtable_kick_deferred_worker(ht);

 	return err;
 }
@@ -630,7 +638,7 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 			rht_unlock(tbl, bkt, flags);

 			if (inserted && rht_grow_above_75(ht, tbl))
-				schedule_work(&ht->run_work);
+				rhashtable_kick_deferred_worker(ht);
 		}
 	} while (!IS_ERR_OR_NULL(new_tbl));

@@ -1085,6 +1093,8 @@ int rhashtable_init_noprof(struct rhashtable *ht,
 	RCU_INIT_POINTER(ht->tbl, tbl);

 	INIT_WORK(&ht->run_work, rht_deferred_worker);
+	if (ht->p.insecure_elasticity)
+		init_irq_work(&ht->run_irq_work, rht_deferred_irq_work);

 	return 0;
 }
@@ -1150,6 +1160,8 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 	struct bucket_table *tbl, *next_tbl;
 	unsigned int i;

+	if (ht->p.insecure_elasticity)
+		irq_work_sync(&ht->run_irq_work);
 	cancel_work_sync(&ht->run_work);

 	mutex_lock(&ht->mutex);
