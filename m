Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A4266581
	for <linux-crypto@vger.kernel.org>; Sun, 13 Sep 2026 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789263266; cv=none; b=EptsquaXNKhQ5xuYfZ1Heuyjv6mZmeAYg3mXzGvMI8DkJYgvY1owJ87ucof1rGDr8dfM69NgS88j/kzG/r4Wreikre6azGFcLe5VpJv/t5dAsi+bucLpCH+fAqhQXVIakpncBIuI2J8miQfiKjwhkT57gEkGEGC+01SbVg6Yxv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789263266; c=relaxed/simple;
	bh=9zwp3oi7098R+Snk1I1TAK5a7LYGpVf6KLDF4veYrhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/sPBqZ1eQXUTE/+XsaSloXlwyV3W61mtMls9Pucz5n3jDc4IisWSvIkB5eBpJzIeVdh2CciqN2f8eCSegWJwqvfKeGeTEcYGdkG2hAOpUl9p81v6RrwKgaaZgfLOF8qmTbGCs7JNblFQaxgk8CWINAg4OLWFaOqde+pI0Z3yKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lLgelXD6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lLgelXD6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PBqph7RwliAwTTlSUpsQ4DnvxGz2ZsccuGEor9yQVdU=; 
	b=lLgelXD6cO0CrseR+5J00GmmdsGO8CoV+nerXIJRbf06fCr0712ZRSrfITO0mqYd38/QpPaTVQZ
	rbgivWPhaPbKjxpLIg9iysRkbgDu0TQqot/4lIyJPHgsyftFQyIk9u5mpErmgd4X7JP20IbKwVoZS
	CNKDpucUKP4/Bqvje9feeBlBxuPKSPKUWhL1PrRK81mrN/U7/Rv6LS9KJvcs65+qKdMJt1a5WeTJz
	wsqpOIf5IQBjRm3hHY+BeF2IC4OA5GGcp015MvrQbMIz6h8c/wNVPNX1vrswpt/lKgba0giBIArCU
	Eic4NiBQBBrBcHF2yu0/YosbE2I1etsN9Ldw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x5Z6l-0000000DR8M-0X2v;
	Sun, 13 Sep 2026 09:34:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Sep 2026 11:34:15 +1000
Date: Sun, 13 Sep 2026 11:34:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: [v4 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqXqftkCP3Jv1CXK@gondor.apana.org.au>

v4 makes the following changes:

- Set iter->p to NULL when detaching walkers.
- Wait for another RCU grace period after detaching walkers.

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

Finally, walkers are detached from the old table, and the entries in
the old table are freed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 6c5e6d9accba..9b31ebd340e3 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -255,6 +255,10 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
+void rhashtable_flush_and_free(struct rhashtable *ht,
+			       void (*free_fn)(void *ptr, void *arg),
+			       void *arg);
+
 struct rhash_lock_head __rcu **rht_bucket_nested(
 	const struct bucket_table *tbl, unsigned int hash);
 struct rhash_lock_head __rcu **__rht_bucket_nested(
@@ -621,6 +625,9 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 
 	BUILD_BUG_ON(!__builtin_constant_p(freq));
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		goto out;
+
 restart:
 	hash = rht_key_hashfn(ht, tbl, key, params);
 	bkt = rht_bucket(tbl, hash);
@@ -644,6 +651,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 	if (unlikely(tbl))
 		goto restart;
 
+out:
 	return NULL;
 }
 
@@ -759,16 +767,19 @@ static __always_inline void *__rhashtable_insert_fast(
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
@@ -1127,11 +1138,13 @@ static __always_inline int __rhashtable_remove_fast(
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
@@ -1143,6 +1156,7 @@ static __always_inline int __rhashtable_remove_fast(
 	       (tbl = rht_dereference_rcu(tbl->future_tbl, ht)))
 		;
 
+out:
 	rcu_read_unlock();
 
 	return err;
@@ -1262,11 +1276,13 @@ static __always_inline int rhashtable_replace_fast(
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
@@ -1278,6 +1294,7 @@ static __always_inline int rhashtable_replace_fast(
 	       (tbl = rht_dereference_rcu(tbl->future_tbl, ht)))
 		;
 
+out:
 	rcu_read_unlock();
 
 	return err;
@@ -1331,4 +1348,19 @@ static inline void rhltable_destroy(struct rhltable *hlt)
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
index 5da0e53a8d42..6f39fdce0233 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -435,6 +435,9 @@ static void rht_deferred_worker(struct work_struct *work)
 	mutex_lock_nested(&ht->mutex, 1);
 
 	tbl = rht_dereference(ht->tbl, ht);
+	if (!tbl)
+		goto out;
+
 	tbl = rhashtable_last_table(ht, tbl);
 
 	if (rht_grow_above_75(ht, tbl))
@@ -451,18 +454,11 @@ static void rht_deferred_worker(struct work_struct *work)
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
@@ -489,6 +485,8 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 	int err;
 
 	old_tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!old_tbl)
+		return -EAGAIN;
 
 	size = tbl->size;
 
@@ -636,6 +634,8 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 	void *data;
 
 	new_tbl = rcu_dereference(ht->tbl);
+	if (!new_tbl)
+		return ERR_PTR(-ESTALE);
 
 	do {
 		tbl = new_tbl;
@@ -779,6 +779,8 @@ void *rhashtable_next_key(struct rhashtable *ht, const void *prev_key)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	tbl = rht_dereference_rcu(ht->tbl, ht);
+	if (!tbl)
+		return NULL;
 	do {
 		he = __rhashtable_next_in_table(ht, tbl, prev_key);
 		if (!IS_ERR_OR_NULL(he))
@@ -820,13 +822,15 @@ void rhashtable_walk_enter(struct rhashtable *ht, struct rhashtable_iter *iter)
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
 
@@ -880,6 +884,10 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
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
@@ -1276,45 +1284,12 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
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
@@ -1339,6 +1314,36 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
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
@@ -1415,3 +1420,78 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(
 
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
