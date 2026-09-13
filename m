Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE10376BD7
	for <linux-crypto@vger.kernel.org>; Sun, 13 Sep 2026 02:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789268015; cv=none; b=PHS+bwXMZqdtwyUA0mzAD+sgV0EQ/lFlO2FsjQTobimRBOQwqZ06w8JbdLVxjyXUi9lk39mF5f0GGgEyP/KTIp0Zt5zb4BXKTcyHuQc0qfWjWsDOsL/vpQXuJy5e4gwMpwMi3ok6xq6m6xrV3a4QJv8L3f+yme/yQlrY+OFkKPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789268015; c=relaxed/simple;
	bh=g1zGbA7jZHjuNIlDGXU9/j+eFnj6cOZ2LN+gBFaJypU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxT9iwr6eoHtyhdR/pgGg3J+Yb27O/zqzg2Zfv1mDDh4riKHBTnq4ukzU5n8fYqL4/BpC4fPGvrVFMd5JqCctR9YhamdaffsHvVywebQcBgLNaoproJgGYRd+RSUjcP5wtABTm7DJ73mtsAZiOkodkt/mOFNcEnuYoK27bsqYek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Xbrch+5e; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Xbrch+5e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZabprtI1R/5cX7YS50ZfXE5Gzb6LFhiAJOs4CDcIULY=; 
	b=Xbrch+5ehT4R8J9LROOsslVQRIpw7aSNvFw9BsdjlVOyhib3sM97D8i/hpU3q4PsH7+9yqm4+C6
	iSnSzGYDjTf4P210NPnMOfUmE+9Vuo7WSDEOKvBG5We+xuzGyrPdF5LpkTW8C5yibZSHrwdHtZhPZ
	xWxAnygaKKWERx+2nKrap1aCoiBLvi9OMUlO1oqVXM6F8SfnBWqt4tz6JjzzNt5dyW+C/BsrR254N
	ZjrWAD/YLPLbBnm6nQYTM6I2QhTbh3Xto2YOVErmA5Vpj01238WBkNsooDqij8qsMc+bYW/EvjDLB
	rAnGobVPJb2VhsePKXXYRN7fMiHvbu5L0UXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x5aLO-0000000DRgA-3M5c;
	Sun, 13 Sep 2026 10:53:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Sep 2026 12:53:26 +1000
Date: Sun, 13 Sep 2026 12:53:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqX9l6vIJdzBSiUE@gondor.apana.org.au>

v5 makes the following changes:

- Add bucket_table dying flag to fix walker race.

---8<---
This patch adds the helper rhashtable_flush_and_free and its
rhltable counter-part.  The intended user is netfilter:

https://sashiko.dev/#/patchset/20260828152256.8759-1-fw%40strlen.de

The hash table briefly becomes NULL during the flush call in order
to quiesce insertions on the old table so that ht->nelems can be
reset to zero safely.

The rest of the code is updated to handle ht->tbl being NULL.

In order to ensure that rehashes are fully disabled during the
flush, the self-rearming in rht_deferred_worker is moved inside
the mutex.

Incidentally, this allows the removal of the special hack where
it had to bypass the IRQ work. However, as the existing
rhashtable_free_and_destroy helper does not set the hash table
to NULL, change it to use disable_work_sync instead.

If concurrent insertions and removals hit the old table during
the call, they act directly on the old table.

If they see a NULL ht->tbl, they fail immediately.

Concurrent insertions and removals that see the new table act
on it.

After setting ht->tbl to NULL, the new helper waits for concurrent
insertions and removals on the old ht->tbl to complete, and then
cancels existing rehashes.

Once rehashes are completely gone, ht->nelems is reset to zero,
and the new table is installed.

Walkers are detached from the old table, and the dying flag is
set on the old table so that other walkers cannot reattach themselves
to the dying table.  Replace the rcu_head_after_call_rcu check
in rhashtable_walk_stop with the dying flag.

Finally, the entries in the old table are freed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 6c5e6d9accba..cb6f5aeab538 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -67,6 +67,7 @@ struct rhash_lock_head {};
  * @nest: Number of bits of first-level nested table.
  * @rehash: Current bucket being rehashed
  * @hash_rnd: Random seed to fold into hash
+ * @dying: True if table is about to be freed
  * @walkers: List of active walkers
  * @rcu: RCU structure for freeing the table
  * @future_tbl: Table under construction during rehashing
@@ -77,6 +78,7 @@ struct bucket_table {
 	unsigned int		size;
 	unsigned int		nest;
 	u32			hash_rnd;
+	u32			dying;
 	struct list_head	walkers;
 	struct rcu_head		rcu;
 
@@ -255,6 +257,10 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
+void rhashtable_flush_and_free(struct rhashtable *ht,
+			       void (*free_fn)(void *ptr, void *arg),
+			       void *arg);
+
 struct rhash_lock_head __rcu **rht_bucket_nested(
 	const struct bucket_table *tbl, unsigned int hash);
 struct rhash_lock_head __rcu **__rht_bucket_nested(
@@ -621,6 +627,9 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 
 	BUILD_BUG_ON(!__builtin_constant_p(freq));
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		goto out;
+
 restart:
 	hash = rht_key_hashfn(ht, tbl, key, params);
 	bkt = rht_bucket(tbl, hash);
@@ -644,6 +653,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 	if (unlikely(tbl))
 		goto restart;
 
+out:
 	return NULL;
 }
 
@@ -759,16 +769,19 @@ static __always_inline void *__rhashtable_insert_fast(
 	};
 	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
+	void *data = ERR_PTR(-ESTALE);
 	struct bucket_table *tbl;
 	struct rhash_head *head;
 	unsigned long flags;
 	unsigned int hash;
 	int elasticity;
-	void *data;
 
 	rcu_read_lock();
 
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		goto out;
+
 	hash = rht_head_hashfn(ht, tbl, obj, params);
 	elasticity = RHT_ELASTICITY;
 	bkt = rht_bucket_insert(ht, tbl, hash);
@@ -1127,11 +1140,13 @@ static __always_inline int __rhashtable_remove_fast(
 	const struct rhashtable_params params, bool rhlist)
 {
 	struct bucket_table *tbl;
-	int err;
+	int err = -ENOENT;
 
 	rcu_read_lock();
 
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		goto out;
 
 	/* Because we have already taken (and released) the bucket
 	 * lock in old_tbl, if we find that future_tbl is not yet
@@ -1143,6 +1158,7 @@ static __always_inline int __rhashtable_remove_fast(
 	       (tbl = rht_dereference_rcu(tbl->future_tbl, ht)))
 		;
 
+out:
 	rcu_read_unlock();
 
 	return err;
@@ -1262,11 +1278,13 @@ static __always_inline int rhashtable_replace_fast(
 	const struct rhashtable_params params)
 {
 	struct bucket_table *tbl;
-	int err;
+	int err = -ENOENT;
 
 	rcu_read_lock();
 
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		goto out;
 
 	/* Because we have already taken (and released) the bucket
 	 * lock in old_tbl, if we find that future_tbl is not yet
@@ -1278,6 +1296,7 @@ static __always_inline int rhashtable_replace_fast(
 	       (tbl = rht_dereference_rcu(tbl->future_tbl, ht)))
 		;
 
+out:
 	rcu_read_unlock();
 
 	return err;
@@ -1331,4 +1350,19 @@ static inline void rhltable_destroy(struct rhltable *hlt)
 	rhltable_free_and_destroy(hlt, NULL, NULL);
 }
 
+/**
+ * rhltable_flush_and_free - unlink and free all elements in the hash list table
+ * @hlt:	the hash list table to destroy
+ * @free_fn:	callback to release resources of element
+ * @arg:	pointer passed to free_fn
+ *
+ * See documentation for rhashtable_flush_and_free.
+ */
+static inline void rhltable_flush_and_free(struct rhltable *hlt,
+					   void (*free_fn)(void *ptr,
+							   void *arg),
+					   void *arg)
+{
+	rhashtable_flush_and_free(&hlt->ht, free_fn, arg);
+}
 #endif /* _LINUX_RHASHTABLE_H */
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 5da0e53a8d42..c8bf0eed00b5 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -350,6 +350,8 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 	/* Publish the new table pointer. */
 	rcu_assign_pointer(ht->tbl, new_tbl);
 
+	old_tbl->dying = true;
+
 	spin_lock(&ht->lock);
 	list_for_each_entry(walker, &old_tbl->walkers, list)
 		walker->tbl = NULL;
@@ -435,6 +437,9 @@ static void rht_deferred_worker(struct work_struct *work)
 	mutex_lock_nested(&ht->mutex, 1);
 
 	tbl = rht_dereference(ht->tbl, ht);
+	if (!tbl)
+		goto out;
+
 	tbl = rhashtable_last_table(ht, tbl);
 
 	if (rht_grow_above_75(ht, tbl))
@@ -451,18 +456,11 @@ static void rht_deferred_worker(struct work_struct *work)
 		err = err ?: nerr;
 	}
 
-	mutex_unlock(&ht->mutex);
-
-	/*
-	 * Re-arm via @run_work, not @run_irq_work.
-	 * rhashtable_free_and_destroy() drains async work as irq_work_sync()
-	 * followed by cancel_work_sync(). If this site queued irq_work while
-	 * cancel_work_sync() was waiting for us, irq_work_sync() would already
-	 * have returned and the stale irq_work could fire post-teardown.
-	 * cancel_work_sync() natively handles self-requeue on @run_work.
-	 */
 	if (err)
-		schedule_work(&ht->run_work);
+		irq_work_queue(&ht->run_irq_work);
+
+out:
+	mutex_unlock(&ht->mutex);
 }
 
 /*
@@ -489,6 +487,8 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 	int err;
 
 	old_tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!old_tbl)
+		return -EAGAIN;
 
 	size = tbl->size;
 
@@ -636,6 +636,8 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 	void *data;
 
 	new_tbl = rcu_dereference(ht->tbl);
+	if (!new_tbl)
+		return ERR_PTR(-ESTALE);
 
 	do {
 		tbl = new_tbl;
@@ -779,6 +781,8 @@ void *rhashtable_next_key(struct rhashtable *ht, const void *prev_key)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		return NULL;
 	do {
 		he = __rhashtable_next_in_table(ht, tbl, prev_key);
 		if (!IS_ERR_OR_NULL(he))
@@ -820,13 +824,15 @@ void rhashtable_walk_enter(struct rhashtable *ht, struct rhashtable_iter *iter)
 	iter->p = NULL;
 	iter->slot = 0;
 	iter->skip = 0;
-	iter->end_of_table = 0;
 
 	spin_lock(&ht->lock);
 	iter->walker.tbl =
 		rcu_dereference_protected(ht->tbl, lockdep_is_held(&ht->lock));
-	list_add(&iter->walker.list, &iter->walker.tbl->walkers);
+	if (iter->walker.tbl)
+		list_add(&iter->walker.list, &iter->walker.tbl->walkers);
 	spin_unlock(&ht->lock);
+
+	iter->end_of_table = !iter->walker.tbl;
 }
 EXPORT_SYMBOL_GPL(rhashtable_walk_enter);
 
@@ -880,6 +886,10 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
 		return 0;
 	if (!iter->walker.tbl) {
 		iter->walker.tbl = rht_dereference_rcu(ht->tbl, ht);
+		if (!iter->walker.tbl) {
+			iter->end_of_table = true;
+			return 0;
+		}
 		iter->slot = 0;
 		iter->skip = 0;
 		iter->p = NULL;
@@ -1091,7 +1101,7 @@ void rhashtable_walk_stop(struct rhashtable_iter *iter)
 	ht = iter->ht;
 
 	spin_lock(&ht->lock);
-	if (rcu_head_after_call_rcu(&tbl->rcu, bucket_table_free_rcu))
+	if (tbl->dying)
 		/* This bucket table is being freed, don't re-link it. */
 		iter->walker.tbl = NULL;
 	else
@@ -1276,45 +1286,12 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 	} while (list);
 }
 
-/**
- * rhashtable_free_and_destroy - free elements and destroy hash table
- * @ht:		the hash table to destroy
- * @free_fn:	callback to release resources of element
- * @arg:	pointer passed to free_fn
- *
- * Stops an eventual async resize. If defined, invokes free_fn for each
- * element to releasal resources. Please note that RCU protected
- * readers may still be accessing the elements. Releasing of resources
- * must occur in a compatible manner. Then frees the bucket array.
- *
- * This function will eventually sleep to wait for an async resize
- * to complete. The caller is responsible that no further write operations
- * occurs in parallel.
- *
- * After cancel_work_sync() has returned, the deferred rehash worker is
- * quiesced and, per the contract above, no other concurrent access to the
- * rhashtable is possible. The tables are therefore owned exclusively by
- * this function and can be walked without ht->mutex held.
- */
-void rhashtable_free_and_destroy(struct rhashtable *ht,
-				 void (*free_fn)(void *ptr, void *arg),
-				 void *arg)
+static void rhashtable_free(struct rhashtable *ht, struct bucket_table *tbl,
+			    void (*free_fn)(void *ptr, void *arg), void *arg)
 {
-	struct bucket_table *tbl, *next_tbl;
+	struct bucket_table *next_tbl;
 	unsigned int i;
 
-	irq_work_sync(&ht->run_irq_work);
-	cancel_work_sync(&ht->run_work);
-
-	/*
-	 * Do NOT take ht->mutex here. The rehash worker establishes
-	 * ht->mutex -> fs_reclaim via GFP_KERNEL bucket allocation under
-	 * the mutex; callers on the reclaim path (e.g. simple_xattr_ht_free()
-	 * from evict() under the dcache shrinker for shmem/kernfs/pidfs
-	 * inodes) would otherwise close a circular dependency
-	 * fs_reclaim -> ht->mutex.
-	 */
-	tbl = rcu_dereference_raw(ht->tbl);
 restart:
 	if (free_fn) {
 		for (i = 0; i < tbl->size; i++) {
@@ -1339,6 +1316,36 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 		goto restart;
 	}
 }
+
+/**
+ * rhashtable_free_and_destroy - free elements and destroy hash table
+ * @ht:		the hash table to destroy
+ * @free_fn:	callback to release resources of element
+ * @arg:	pointer passed to free_fn
+ *
+ * Stops an eventual async resize. If defined, invokes free_fn for each
+ * element to releasal resources. Please note that RCU protected
+ * readers may still be accessing the elements. Releasing of resources
+ * must occur in a compatible manner. Then frees the bucket array.
+ *
+ * This function will eventually sleep to wait for an async resize
+ * to complete. The caller is responsible that no further write operations
+ * occurs in parallel.
+ *
+ * After disable_work_sync() has returned, the deferred rehash worker is
+ * quiesced and, per the contract above, no other concurrent access to the
+ * rhashtable is possible. The tables are therefore owned exclusively by
+ * this function and can be walked without ht->mutex held.
+ */
+void rhashtable_free_and_destroy(struct rhashtable *ht,
+				 void (*free_fn)(void *ptr, void *arg),
+				 void *arg)
+{
+	disable_work_sync(&ht->run_work);
+	irq_work_sync(&ht->run_irq_work);
+
+	rhashtable_free(ht, rcu_dereference_raw(ht->tbl), free_fn, arg);
+}
 EXPORT_SYMBOL_GPL(rhashtable_free_and_destroy);
 
 void rhashtable_destroy(struct rhashtable *ht)
@@ -1415,3 +1422,79 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(
 
 }
 EXPORT_SYMBOL_GPL(rht_bucket_nested_insert);
+
+/**
+ * rhashtable_flush_and_free - detach and discard all current elements
+ * @ht:		the hash table to flush
+ * @free_fn:	callback to release resources of an element, may be %NULL
+ * @arg:	pointer passed to free_fn
+ *
+ * Swaps the bucket table backing @ht for a new, empty table.
+ *
+ * The detached table is then walked and every element found is
+ * unlinked, and, if @free_fn is given, handed to it for release.
+ *
+ * Unlike rhashtable_destroy(), @ht is left fully initialized and may
+ * continue to be used for lookups, insertions, and removals.
+ *
+ * This function may sleep, it cannot be called from atomic context or
+ * RCU read-side critical sections.
+ *
+ * The caller must not make concurrent rhashtable_flush_and_free calls.
+ * That is, a subsequent call can only be made once the first call has
+ * returned.
+ */
+void rhashtable_flush_and_free(struct rhashtable *ht,
+			       void (*free_fn)(void *ptr, void *arg),
+			       void *arg)
+{
+	struct bucket_table *tbl, *old_tbl, *new_tbl;
+	struct rhashtable_walker *walker;
+
+	new_tbl = bucket_table_alloc(ht, rounded_hashtable_size(&ht->p),
+				     GFP_KERNEL);
+	if (!new_tbl)
+		new_tbl = bucket_table_alloc(ht, ht->p.min_size,
+					     GFP_KERNEL | __GFP_NOFAIL);
+
+	mutex_lock(&ht->mutex);
+	old_tbl = rht_dereference(ht->tbl, ht);
+	RCU_INIT_POINTER(ht->tbl, NULL);
+	mutex_unlock(&ht->mutex);
+
+	/* Wait for insertions/removals on the old ht->tbl to complete. */
+	synchronize_rcu();
+
+	/* Cancel resizes/rehashes. */
+	irq_work_sync(&ht->run_irq_work);
+	cancel_work_sync(&ht->run_work);
+
+	atomic_set(&ht->nelems, 0);
+
+	/* No need for mutex as rehashes have all stopped. */
+	rcu_assign_pointer(ht->tbl, new_tbl);
+
+	/* Detach walkers from the old hash table. */
+	tbl = old_tbl;
+	spin_lock(&ht->lock);
+	do {
+		tbl->dying = true;
+		list_for_each_entry(walker, &tbl->walkers, list) {
+			struct rhashtable_iter *iter = container_of(
+				walker, struct rhashtable_iter, walker);
+
+			walker->tbl = NULL;
+			iter->end_of_table = true;
+			iter->p = NULL;
+		}
+
+		tbl = rcu_dereference_raw(tbl->future_tbl);
+	} while (tbl);
+	spin_unlock(&ht->lock);
+
+	/* Wait for walkers on old table to complete. */
+	synchronize_rcu();
+
+	rhashtable_free(ht, old_tbl, free_fn, arg);
+}
+EXPORT_SYMBOL_GPL(rhashtable_flush_and_free);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
