Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638701FECB0
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080391; cv=none; b=lM5fpcTi4/nUt3t5DP1a/F4AOKkLUAWFjvrmP4hv7DBxeRBeawZIGpZqFBEvPiJIW/J7O71f5L+cra+DSdkYDNuQe/v/re49LsnSSA+Z6Uod9m4CvXdt02XpFBn0ORq4wkfmFcXGMs9AWNSfjmnB65Bf6TalfQ3Dtnw0UCJIvig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080391; c=relaxed/simple;
	bh=ny5w6oHqV2txpuQ0MsAltkXYUEne0mzXHdXbqKiPXa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K6nNtF+ULNZYFjxX/r/EKVMtQaczt2akvgPlkj1RdKAC4xpQtPEgKbyAoayPbrqvaZQVKSqGfvb7aO1m9cXjSnQJyHI/QDft0ysXo0w/96M/v4q2DVrDEONO+QeQ+ARN1XnU/4TUR+wmsNtHCUHveLVHcP9MDYbcOVNYiRD8kcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=obtYtow0; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="obtYtow0"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ac0f1651227so126969366b.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080388; x=1741685188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Oslc0Vw7rD1eBm5IrdyoxIc7gTLsk2fVXwffC4VNN0=;
        b=obtYtow0pvK7rc+zS/vuVRaMsYbrhKM1f8ajmQNs6Z3j1C7d09KbddFB0iPjH98UbR
         saxXR/IG2MfEMTqLy6Jw9JdbMccKW6P6rCK1VRDa1rIAPdc4GydABfAX0/vCsrjD5t20
         rkwaKUfsJHHWIN33ZLNcNp0b8A9UGMWEduxiHCRmAq1Wq7yLzTpdA0C47pCE3zGBLzWn
         UiphXOppLAgiWfECV8hu+Hj7Kn0NmeW6d16a3BS+NbRKC1e5OWtCOfC9qINRAIJniEiA
         qJZmhrVZtDv3xrcmxqRxk02Lrc2NIblh4TUjKYfIZDzdJ1LCG8ZMKf2dFAgntnTsyzPa
         B6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080388; x=1741685188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Oslc0Vw7rD1eBm5IrdyoxIc7gTLsk2fVXwffC4VNN0=;
        b=CcIeDnZpFZc9+loSrgPrHH7v3GYAhCQJwyVCCYCWd38RDNWQffEcolmcycexj47gps
         RhhRyKeakhMBxStGVAihUXJq9gbyw9SqNzmwMgA3HGXYtp1bGm+UDaQjLLdaDBX5TgUg
         XUKywFIiHvuacur71yCfH+5BZF+v0ReBDM4i+PRmY7F6zYcA4KIHO6vhNo2ky3ig7AXf
         LeZlsXAUO7DgRZrkX+puDj1hENgoo2CNShEmDGp0avH5kY3tPATLVtohfDqhDWnhi9Qc
         vPCPSNoFPjKj+RFmCMi2nGf1aRCxs+HGQmpJZrVN4aYTbIn8FjMhbTFppkVWUUAn/HpM
         gUQA==
X-Forwarded-Encrypted: i=1; AJvYcCXgFJQdbdoO9gaCDbAN1OYDp5JQ/Okz4hjM/D5W67WS91b/cNXzu2uPYyDigLAU66mNXw3LJfItfIoBt/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwwtD7/zNmBgbyAgMzsIUz+hqOKLVuTKDRKV5rfPJ2vzO7U7Ze
	fGDngw4XgvT0rA4qvn7lQFt8VWv32o4pjdmE6cfyw9FgQSDy3uem2CKYmxyVwzLKbTubruKZcA=
	=
X-Google-Smtp-Source: AGHT+IHtToTtakBuhP4/+sNMLQALzVHMJHtjC5HLCinrcP/6hbX3DMvKPBSJ238d92jV7XTaug7SYLQQPg==
X-Received: from ejctb24.prod.google.com ([2002:a17:907:8b98:b0:ac1:4149:808d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:781:b0:abe:f6f5:93fa
 with SMTP id a640c23a62f3a-abf261d3b82mr1992742166b.33.1741080387611; Tue, 04
 Mar 2025 01:26:27 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:28 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-30-elver@google.com>
Subject: [PATCH v2 29/34] rhashtable: Enable capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Enable capability analysis for rhashtable, which was used as an initial
test as it contains a combination of RCU, mutex, and bit_spinlock usage.

Users of rhashtable now also benefit from annotations on the API, which
will now warn if the RCU read lock is not held where required.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove disable/enable_capability_analysis() around headers.
---
 include/linux/rhashtable.h | 14 +++++++++++---
 lib/Makefile               |  2 ++
 lib/rhashtable.c           |  5 +++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 8463a128e2f4..c6374691ccc7 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -245,16 +245,17 @@ void *rhashtable_insert_slow(struct rhashtable *ht, const void *key,
 void rhashtable_walk_enter(struct rhashtable *ht,
 			   struct rhashtable_iter *iter);
 void rhashtable_walk_exit(struct rhashtable_iter *iter);
-int rhashtable_walk_start_check(struct rhashtable_iter *iter) __acquires(RCU);
+int rhashtable_walk_start_check(struct rhashtable_iter *iter) __acquires_shared(RCU);
 
 static inline void rhashtable_walk_start(struct rhashtable_iter *iter)
+	__acquires_shared(RCU)
 {
 	(void)rhashtable_walk_start_check(iter);
 }
 
 void *rhashtable_walk_next(struct rhashtable_iter *iter);
 void *rhashtable_walk_peek(struct rhashtable_iter *iter);
-void rhashtable_walk_stop(struct rhashtable_iter *iter) __releases(RCU);
+void rhashtable_walk_stop(struct rhashtable_iter *iter) __releases_shared(RCU);
 
 void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void (*free_fn)(void *ptr, void *arg),
@@ -325,6 +326,7 @@ static inline struct rhash_lock_head __rcu **rht_bucket_insert(
 
 static inline unsigned long rht_lock(struct bucket_table *tbl,
 				     struct rhash_lock_head __rcu **bkt)
+	__acquires(__bitlock(0, bkt))
 {
 	unsigned long flags;
 
@@ -337,6 +339,7 @@ static inline unsigned long rht_lock(struct bucket_table *tbl,
 static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 					struct rhash_lock_head __rcu **bucket,
 					unsigned int subclass)
+	__acquires(__bitlock(0, bucket))
 {
 	unsigned long flags;
 
@@ -349,6 +352,7 @@ static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 static inline void rht_unlock(struct bucket_table *tbl,
 			      struct rhash_lock_head __rcu **bkt,
 			      unsigned long flags)
+	__releases(__bitlock(0, bkt))
 {
 	lock_map_release(&tbl->dep_map);
 	bit_spin_unlock(0, (unsigned long *)bkt);
@@ -402,13 +406,14 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
 				     struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj,
 				     unsigned long flags)
+	__releases(__bitlock(0, bkt))
 {
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
 	lock_map_release(&tbl->dep_map);
 	rcu_assign_pointer(*bkt, (void *)obj);
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(0, bkt));
 	local_irq_restore(flags);
 }
 
@@ -589,6 +594,7 @@ static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
 static inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -642,6 +648,7 @@ static inline struct rhash_head *__rhashtable_lookup(
 static inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(ht, key, params);
 
@@ -692,6 +699,7 @@ static inline void *rhashtable_lookup_fast(
 static inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params);
 
diff --git a/lib/Makefile b/lib/Makefile
index f40ba93c9a94..c7004270ad5f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -45,6 +45,8 @@ lib-$(CONFIG_MIN_HEAP) += min_heap.o
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
 
+CAPABILITY_ANALYSIS_rhashtable.o := y
+
 obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 3e555d012ed6..fe8dd776837c 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -358,6 +358,7 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 static int rhashtable_rehash_alloc(struct rhashtable *ht,
 				   struct bucket_table *old_tbl,
 				   unsigned int size)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *new_tbl;
 	int err;
@@ -392,6 +393,7 @@ static int rhashtable_rehash_alloc(struct rhashtable *ht,
  * bucket locks or concurrent RCU protected lookups and traversals.
  */
 static int rhashtable_shrink(struct rhashtable *ht)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
 	unsigned int nelems = atomic_read(&ht->nelems);
@@ -724,7 +726,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
  * resize events and always continue.
  */
 int rhashtable_walk_start_check(struct rhashtable_iter *iter)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct rhashtable *ht = iter->ht;
 	bool rhlist = ht->rhlist;
@@ -940,7 +942,6 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_peek);
  * hash table.
  */
 void rhashtable_walk_stop(struct rhashtable_iter *iter)
-	__releases(RCU)
 {
 	struct rhashtable *ht;
 	struct bucket_table *tbl = iter->walker.tbl;
-- 
2.48.1.711.g2feabab25a-goog

