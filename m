Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D3D3D810D;
	Tue, 15 Sep 2026 06:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789452282; cv=none; b=Gf/n0oEp1ySsAfIHHTW2USRBjAdoHXno3iw3ouI9p8XRYRcqvSdtQhySAPzmzGXYy1Axf1W9I6pt7R13keH5UkGOuP2fj21/C/6c8a0HX8YRXU2om4kn3GKnnJh4R+KbU8CLMO6DeA5BP4vAGA4C+rEd+nuJnhq8j6L6NObzy3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789452282; c=relaxed/simple;
	bh=fQU8Y/TjGzEbCBHbYKX2kLXq0pcEXR0TtcKeXeVP4vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxsakLLUATQX4s1wznPBhSfPhOi5j95/axvfPl0THL4247akkrSvNAEE3TWCn9jDl96qYe/10v4w8I4UqscnS+Xkiah/jiCZVrqygzDGn64mxh/5V+yoU/xd9nuNh1imox/p2vbdM5vrPGYkBDXk/HuSxmuDhmPRmBVzPaC+jjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HNao7bFe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HNao7bFe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2YZiibc/bXVRXD1UnU5ITV7I8YK2sNqAjajxZP9oZrA=; 
	b=HNao7bFep1+cjJ8RvkgmToZNZ9GYEAd1GKYgq7c0yjKY0oyfk/zqwWrLsOF3PlTY6g5QqJGC6//
	wy1oqOJZ755mS3+WFUXNncAOH9z1DNRNzZVeWvJ6W59KBarv9hNjAPxKS8GLoK7Aez527zpV0J7ZM
	QM76ecMFl4misMU+7IRmet8uT8KVJzBUWhwqbhWWlIHk3eeIPoNNC8g1PzLfuBM0dXWIodgbiAeFg
	3HF76mTSClwwbbq6tfJB/5m1EL3A2hB+hbasyDGFWdJG5uaD2A8smu3psdP3QH6KqdWchZ/T579Dv
	Xn8n+nFZWFZKEvEdQQtjbLxBqAK/hsCLxoiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6MHM-0000000E5xo-4BEB;
	Tue, 15 Sep 2026 14:04:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Sep 2026 16:04:28 +1000
Date: Tue, 15 Sep 2026 16:04:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Dumazet <edumazet@google.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	syzbot <syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com>,
	bridge@lists.linux.dev, davem@davemloft.net, horms@kernel.org,
	idosch@nvidia.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, razor@blackwall.org,
	steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
	Thomas Graf <tgraf@suug.ch>, linux-crypto@vger.kernel.org,
	NeilBrown <neilb@ownmail.net>, quanyeyang <quanyemostima@gmail.com>
Subject: [PATCH] rhashtable: Use separate lockdep keys for each lock
Message-ID: <aqjf7LNmE6InABpw@gondor.apana.org.au>
References: <6aa5fcf6.f2639fcc.29487d.0048.GAE@google.com>
 <aqi7fpazv2KDDdvn@shinmob>
 <CANn89iJd0QnoDo0tjrFED2myec38U8joyqR05d6BVnJ-sX=NVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJd0QnoDo0tjrFED2myec38U8joyqR05d6BVnJ-sX=NVg@mail.gmail.com>

On Mon, Sep 14, 2026 at 09:06:49PM -0700, Eric Dumazet wrote:
>
> Try to revert 4333ab90aaae ("rhashtable: use private lockdep class for
> all locks.")

Yes this is indeed buggy.  I know nothing about lockdep but Gemini
reckons that it should use separate keys instead of different
depths which seems fair enough:

---8<---
Use separate lockdep keys for the different types of locks in
rhashtable (mutex, spin lock, and bucket locks).  They are
separate and not normally nested with respect to each other.

Also move the rhashtable_init/rhltable_init kdoc to the header
file as that's where the macros are defined.

Fixes: 4333ab90aaae ("rhashtable: use private lockdep class for all locks.")
Reported-by: syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com
Assisted-by: Gemini:gemini-3.6-flash
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 0e1b172a4f6c..afbc12ba71f5 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -70,6 +70,14 @@ struct rhashtable_params {
 	rht_obj_cmpfn_t		obj_cmpfn;
 };
 
+struct rhashtable_lockdep_keys {
+#ifdef CONFIG_LOCKDEP
+	struct lock_class_key lock_key;
+	struct lock_class_key mutex_key;
+	struct lock_class_key bucket_key;
+#endif
+};
+
 /**
  * struct rhashtable - Hash table handle
  * @tbl: Bucket table
@@ -141,24 +149,77 @@ struct rhashtable_iter {
 
 int __rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params,
-		    struct lock_class_key *key);
+		    struct rhashtable_lockdep_keys *keys);
 #define rhashtable_init_noprof(ht, params)				\
 ({									\
-	static struct lock_class_key __key;				\
+	static struct rhashtable_lockdep_keys __keys;			\
 									\
-	__rhashtable_init_noprof(ht, params, &__key);			\
+	__rhashtable_init_noprof(ht, params, &__keys);			\
 })
+
+/**
+ * rhashtable_init - initialize a new hash table
+ * @ht:		hash table to be initialized
+ * @params:	configuration parameters
+ *
+ * Initializes a new hash table based on the provided configuration
+ * parameters. A table can be configured either with a variable or
+ * fixed length key:
+ *
+ * Configuration Example 1: Fixed length keys
+ * struct test_obj {
+ *	int			key;
+ *	void *			my_member;
+ *	struct rhash_head	node;
+ * };
+ *
+ * struct rhashtable_params params = {
+ *	.head_offset = offsetof(struct test_obj, node),
+ *	.key_offset = offsetof(struct test_obj, key),
+ *	.key_len = sizeof(int),
+ *	.hashfn = jhash,
+ * };
+ *
+ * Configuration Example 2: Variable length keys
+ * struct test_obj {
+ *	[...]
+ *	struct rhash_head	node;
+ * };
+ *
+ * u32 my_hash_fn(const void *data, u32 len, u32 seed)
+ * {
+ *	struct test_obj *obj = data;
+ *
+ *	return [... hash ...];
+ * }
+ *
+ * struct rhashtable_params params = {
+ *	.head_offset = offsetof(struct test_obj, node),
+ *	.hashfn = jhash,
+ *	.obj_hashfn = my_hash_fn,
+ * };
+ */
 #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
 
 int __rhltable_init_noprof(struct rhltable *hlt,
 		  const struct rhashtable_params *params,
-		  struct lock_class_key *key);
+		  struct rhashtable_lockdep_keys *keys);
 #define rhltable_init_noprof(hlt, params)				\
 ({									\
-	static struct lock_class_key __key;				\
+	static struct rhashtable_lockdep_keys __keys;			\
 									\
-	__rhltable_init_noprof(hlt, params, &__key);			\
+	__rhltable_init_noprof(hlt, params, &__keys);			\
 })
+
+/**
+ * rhltable_init - initialize a new hash list table
+ * @hlt:	hash list table to be initialized
+ * @params:	configuration parameters
+ *
+ * Initializes a new hash list table.
+ *
+ * See documentation for rhashtable_init.
+ */
 #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
 
 #endif /* _LINUX_RHASHTABLE_TYPES_H */
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 6c5e6d9accba..ec853c1b9af3 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -328,8 +328,7 @@ static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 
 	local_irq_save(flags);
 	bit_spin_lock(0, (unsigned long *)bucket);
-	/* subclass 0 is used for ->lock and 1 for ->mutex. 2+ for bitlocks */
-	lock_acquire_exclusive(&tbl->dep_map, subclass+2, 0, NULL, _THIS_IP_);
+	lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
 	return flags;
 }
 
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 5da0e53a8d42..918f15a2ac69 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -432,7 +432,7 @@ static void rht_deferred_worker(struct work_struct *work)
 	int err = 0;
 
 	ht = container_of(work, struct rhashtable, run_work);
-	mutex_lock_nested(&ht->mutex, 1);
+	mutex_lock(&ht->mutex);
 
 	tbl = rht_dereference(ht->tbl, ht);
 	tbl = rhashtable_last_table(ht, tbl);
@@ -1122,51 +1122,9 @@ static u32 rhashtable_jhash2(const void *key, u32 length, u32 seed)
 	return jhash2(key, length, seed);
 }
 
-/**
- * rhashtable_init - initialize a new hash table
- * @ht:		hash table to be initialized
- * @params:	configuration parameters
- *
- * Initializes a new hash table based on the provided configuration
- * parameters. A table can be configured either with a variable or
- * fixed length key:
- *
- * Configuration Example 1: Fixed length keys
- * struct test_obj {
- *	int			key;
- *	void *			my_member;
- *	struct rhash_head	node;
- * };
- *
- * struct rhashtable_params params = {
- *	.head_offset = offsetof(struct test_obj, node),
- *	.key_offset = offsetof(struct test_obj, key),
- *	.key_len = sizeof(int),
- *	.hashfn = jhash,
- * };
- *
- * Configuration Example 2: Variable length keys
- * struct test_obj {
- *	[...]
- *	struct rhash_head	node;
- * };
- *
- * u32 my_hash_fn(const void *data, u32 len, u32 seed)
- * {
- *	struct test_obj *obj = data;
- *
- *	return [... hash ...];
- * }
- *
- * struct rhashtable_params params = {
- *	.head_offset = offsetof(struct test_obj, node),
- *	.hashfn = jhash,
- *	.obj_hashfn = my_hash_fn,
- * };
- */
 int __rhashtable_init_noprof(struct rhashtable *ht,
-		    const struct rhashtable_params *params,
-		    struct lock_class_key *key)
+			     const struct rhashtable_params *params,
+			     struct rhashtable_lockdep_keys *keys)
 {
 	struct bucket_table *tbl;
 	size_t size;
@@ -1176,13 +1134,11 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 		return -EINVAL;
 
 	memset(ht, 0, sizeof(*ht));
-	/* mutex_lock must use nesting level 1 */
-	mutex_init_with_key(&ht->mutex, key);
+	mutex_init_with_key(&ht->mutex, &keys->mutex_key);
 	spin_lock_init(&ht->lock);
-	/* spin_lock can use nesting level 0 */
-	lockdep_set_class(&ht->lock, key);
+	lockdep_set_class(&ht->lock, &keys->lock_key);
 #ifdef CONFIG_LOCKDEP
-	ht->lockdep_key = key;
+	ht->lockdep_key = &keys->bucket_key;
 #endif
 	memcpy(&ht->p, params, sizeof(*params));
 
@@ -1236,22 +1192,13 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 }
 EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
 
-/**
- * rhltable_init - initialize a new hash list table
- * @hlt:	hash list table to be initialized
- * @params:	configuration parameters
- *
- * Initializes a new hash list table.
- *
- * See documentation for rhashtable_init.
- */
 int __rhltable_init_noprof(struct rhltable *hlt,
 			   const struct rhashtable_params *params,
-			   struct lock_class_key *key)
+			   struct rhashtable_lockdep_keys *keys)
 {
 	int err;
 
-	err = __rhashtable_init_noprof(&hlt->ht, params, key);
+	err = __rhashtable_init_noprof(&hlt->ht, params, keys);
 	hlt->ht.rhlist = true;
 	return err;
 }
diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index 85a615e74591..b767a38a74f9 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -477,7 +477,7 @@ static unsigned int __init print_ht(struct rhltable *rhlt)
 
 	ht = &rhlt->ht;
 	/* Take the mutex to avoid RCU warning */
-	mutex_lock_nested(&ht->mutex, 1);
+	mutex_lock(&ht->mutex);
 	tbl = rht_dereference(ht->tbl, ht);
 	for (i = 0; i < tbl->size; i++) {
 		struct rhash_head *pos, *next;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
