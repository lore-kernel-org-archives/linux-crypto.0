Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D86B175A6D;
	Tue, 21 Apr 2026 06:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751408; cv=none; b=YCy23bd2wg1DagGad1CRdUzuPdMjJ4tRhDJ7r2hPXoY4jl0VzoFBC4YvmQHvjLVQPMpt8jkz9Ms4C8bXeU0sFikZq5Jwg4CzlsirssBH/zqggRb4w/SrMI8h+4Baas+jczzpg+rjGlfZM538TME8isxZ6piZnw97qEacnTcrtq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751408; c=relaxed/simple;
	bh=whQ008b5yWkz0etQqM6x8nLHNmxTWdiN4BVTahBWr2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNtM6a1JP/p5cD75NsDRgv36vw9GzofX4Kqw33lNbKGYMXxCcOTG7TlFQ/z/WqpetM6MEv8MbZT3xmAXFdazxLWKAKg/DU1bCDZW4jcPqf2Z/u4zgpnpfDYvM26WqLAdBJqi+S8vm84YnVyHCNIgDrkg2JwB+LTxasI5b3mAxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+PE1vom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+PE1vom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34B0C2BCB0;
	Tue, 21 Apr 2026 06:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776751408;
	bh=whQ008b5yWkz0etQqM6x8nLHNmxTWdiN4BVTahBWr2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+PE1vomFdClkDN6okvCTd/lw2Keyxew6XCTHOfBLQsVtPVWKw7gWht40B4i+wqtj
	 RFrYBEEi1BqCdNSsxWa5F2wLDehDNgbNrUo4P9k+Jup63uokVqVN6EhW1hp5oFUzhQ
	 iiemKglouPbFNJguWvcqUv7bZJqzvghVVeCzkJxYMiBDg/Ge6i+ygVAMScC6Es1BNx
	 6qFZmJuur9+PloDZvOFyogu6f8GwMrjJ8OHx/Ies7pMlzvL6QjVeBphDuUaHU/YwGT
	 veMZpt7+y/A7xr8iKH2PPbpg5X36xhdBg5qDsNE+GAczmGeZxFrLkvPRIqduan27WG
	 urih0I+pwPvaQ==
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] rhashtable: Bounce deferred worker kick through irq_work
Date: Mon, 20 Apr 2026 20:03:26 -1000
Message-ID: <20260421060326.2836354-1-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4ff731fc-3791-4b96-a997-89c3bcd2d69b@kernel.org>
References: <4ff731fc-3791-4b96-a997-89c3bcd2d69b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Inserts past 75% load call schedule_work(&ht->run_work) to kick an
async resize. If a caller holds a raw spinlock (e.g. an
insecure_elasticity user), schedule_work() under that lock records

  caller_lock -> pool->lock -> pi_lock -> rq->__lock

A cycle forms if any of these locks is acquired in the reverse
direction elsewhere. sched_ext, the only current insecure_elasticity
user, hits this: it holds scx_sched_lock across rhashtable inserts of
sub-schedulers, while scx_bypass() takes rq->__lock -> scx_sched_lock.
Exercising the resize path produces:

  Chain exists of:
    &pool->lock --> &rq->__lock --> scx_sched_lock

Bounce the kick from the insert paths through irq_work so
schedule_work() runs from hard IRQ context with the caller's lock no
longer held. rht_deferred_worker()'s self-rearm on error stays on
schedule_work(&ht->run_work) - the worker runs in process context with
no caller lock held, and keeping the self-requeue on @run_work lets
cancel_work_sync() in rhashtable_free_and_destroy() drain it.

v3: Keep rht_deferred_worker()'s self-rearm on schedule_work(&run_work).
    Routing it through irq_work in v2 broke cancel_work_sync()'s
    self-requeue handling - an irq_work queued after irq_work_sync()
    returned but while cancel_work_sync() was still waiting could fire
    post-teardown.

v2: Bounce unconditionally instead of gating on insecure_elasticity,
    as suggested by Herbert.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Herbert, dropped your Ack on v2. v2 routed rht_deferred_worker()'s
self-rearm through irq_work, which would race with
cancel_work_sync() in rhashtable_free_and_destroy(). v3 keeps only
the insert-path kicks on irq_work; the worker's self-rearm stays on
schedule_work(&ht->run_work).

 include/linux/rhashtable-types.h |  3 +++
 include/linux/rhashtable.h       |  3 ++-
 lib/rhashtable.c                 | 31 ++++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 72082428d6c6..fc2f596a6df1 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -12,6 +12,7 @@
 #include <linux/alloc_tag.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <linux/irq_work_types.h>
 #include <linux/mutex.h>
 #include <linux/workqueue_types.h>
 
@@ -77,6 +78,7 @@ struct rhashtable_params {
  * @p: Configuration parameters
  * @rhlist: True if this is an rhltable
  * @run_work: Deferred worker to expand/shrink asynchronously
+ * @run_irq_work: Bounces the @run_work kick through hard IRQ context.
  * @mutex: Mutex to protect current/future table swapping
  * @lock: Spin lock to protect walker list
  * @nelems: Number of elements in table
@@ -88,6 +90,7 @@ struct rhashtable {
 	struct rhashtable_params	p;
 	bool				rhlist;
 	struct work_struct		run_work;
+	struct irq_work			run_irq_work;
 	struct mutex                    mutex;
 	spinlock_t			lock;
 	atomic_t			nelems;
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 7def3f0f556b..ef5230cece36 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -20,6 +20,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/irq_work.h>
 #include <linux/jhash.h>
 #include <linux/list_nulls.h>
 #include <linux/workqueue.h>
@@ -847,7 +848,7 @@ static __always_inline void *__rhashtable_insert_fast(
 	rht_assign_unlock(tbl, bkt, obj, flags);
 
 	if (rht_grow_above_75(ht, tbl))
-		schedule_work(&ht->run_work);
+		irq_work_queue(&ht->run_irq_work);
 
 	data = NULL;
 out:
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index fb2b7bc137ba..7a67ef5b67b6 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -441,10 +441,33 @@ static void rht_deferred_worker(struct work_struct *work)
 
 	mutex_unlock(&ht->mutex);
 
+	/*
+	 * Re-arm via @run_work, not @run_irq_work.
+	 * rhashtable_free_and_destroy() drains async work as irq_work_sync()
+	 * followed by cancel_work_sync(). If this site queued irq_work while
+	 * cancel_work_sync() was waiting for us, irq_work_sync() would already
+	 * have returned and the stale irq_work could fire post-teardown.
+	 * cancel_work_sync() natively handles self-requeue on @run_work.
+	 */
 	if (err)
 		schedule_work(&ht->run_work);
 }
 
+/*
+ * Insert-path callers can run under a raw spinlock (e.g. an insecure_elasticity
+ * user). Calling schedule_work() under that lock records caller_lock ->
+ * pool->lock -> pi_lock -> rq->__lock, closing a locking cycle if any of
+ * these is acquired in the reverse direction elsewhere. Bounce through
+ * irq_work so the schedule_work() runs with the caller's lock no longer held.
+ */
+static void rht_deferred_irq_work(struct irq_work *irq_work)
+{
+	struct rhashtable *ht = container_of(irq_work, struct rhashtable,
+					     run_irq_work);
+
+	schedule_work(&ht->run_work);
+}
+
 static int rhashtable_insert_rehash(struct rhashtable *ht,
 				    struct bucket_table *tbl)
 {
@@ -477,7 +500,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 		if (err == -EEXIST)
 			err = 0;
 	} else
-		schedule_work(&ht->run_work);
+		irq_work_queue(&ht->run_irq_work);
 
 	return err;
 
@@ -488,7 +511,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 
 	/* Schedule async rehash to retry allocation in process context. */
 	if (err == -ENOMEM)
-		schedule_work(&ht->run_work);
+		irq_work_queue(&ht->run_irq_work);
 
 	return err;
 }
@@ -630,7 +653,7 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 			rht_unlock(tbl, bkt, flags);
 
 			if (inserted && rht_grow_above_75(ht, tbl))
-				schedule_work(&ht->run_work);
+				irq_work_queue(&ht->run_irq_work);
 		}
 	} while (!IS_ERR_OR_NULL(new_tbl));
 
@@ -1085,6 +1108,7 @@ int rhashtable_init_noprof(struct rhashtable *ht,
 	RCU_INIT_POINTER(ht->tbl, tbl);
 
 	INIT_WORK(&ht->run_work, rht_deferred_worker);
+	init_irq_work(&ht->run_irq_work, rht_deferred_irq_work);
 
 	return 0;
 }
@@ -1150,6 +1174,7 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 	struct bucket_table *tbl, *next_tbl;
 	unsigned int i;
 
+	irq_work_sync(&ht->run_irq_work);
 	cancel_work_sync(&ht->run_work);
 
 	mutex_lock(&ht->mutex);
-- 
2.53.0

