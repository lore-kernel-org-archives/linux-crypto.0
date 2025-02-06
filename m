Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEFA221D8F
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865930; cv=none; b=sZjfcfA+PbNLtxDyChOql7UEvKmyHZHSlVivUPlTT+XL6iLFSxq8VBzieDn+09tPPpdEGS2lNKTD4jbINS1ok8K6573Z4nNq/HRo4o4SA+sWfO02gDJkOZW5cpFt2qWknbPk9KJ+m0suDY/MulZXpjQJdxPYo/KWPS0H6Q6bPjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865930; c=relaxed/simple;
	bh=U9Zquo+I28n7D6l89QyMvjgCk9CUHGORATxUF8MOC08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bw7jVbUFSI3yFvdBSveQm18oidZF6kvbzIpZNWRCl473Bbtujc8UvVaTb6qrVM80h6oM5Gr75IGfKNQgBhkXUiLp9VK+3dpYDNOpcJa+LQzCjsv1r5CE0UW+qU2IBGQvx58oe3xa5SjICAF/s0JEXYVXZHlrgHOuH0sxnbBlNQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A+GK6fsN; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+GK6fsN"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aaf901a0ef9so137831366b.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865927; x=1739470727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3npqKmcD7idosYB3Rql5Qlei3J/L1gfZsrIz0sfHUY=;
        b=A+GK6fsN+2c85B+5EKDZCkfcxGL7P6scNyLnfK+CHqN6foBu1qIF6e2K+NNB95n2S+
         6xnG1+oZ5RhZz5N0joU84U/SYrh40hejsc0NBZb4FAqJbGQluNXqUoJD6W3oyejuz/zL
         RYqNjjU9+HtqZ6ZIhckIvogQ0nx8IhqVjlrYDbFmB/fAIwEtk2o30h9GPHCLgaIAPrt3
         I0wDd+7cW2sMhc7qt+U4ljMnaBytf5BpwoI5rfWi9dnHwXHP4ql7YTswPl6YmMxcb+GI
         /2soRC52FgK92YYLUSO25R1mHXv5pfOEI4S3b/tNH72zuH1HUUVrsVzRQHIR18AZpt9s
         yAIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865927; x=1739470727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3npqKmcD7idosYB3Rql5Qlei3J/L1gfZsrIz0sfHUY=;
        b=wPF15VIaYwBgJbAwkOqrFfiGWjV4hEN4stuwCXeLL1CvAaoyOyIIQoOEBtKjjJu1gu
         Ob425NPg7l86zYCr8Gkw4b4aT6j2zFtJAVUrTa4th/m+Barw71kMz4FGI1opC2uKzPf2
         N81rFTN1EeHgTFuDIWyNShvFTuk7bpk0uFNC5GqQG7kdUAJiGXi5629GEN2tcSY7rPL2
         V7vmE7Sg0aLQPkgfKHC1CC6nqsJ5WRmzAIBd0vJUt+8vf+5IMsnVVWO96Pv3+OdQajEy
         cxjYBOfjnBTUu9uwm/UkWi5ZV1wnP31CApSSCQfHOksbNdFQPXd9X1GGdgGFWZ4UU0bS
         9l9A==
X-Forwarded-Encrypted: i=1; AJvYcCUp0hb8XuMzQe8l9yQPbqtS8nMfOG03U/b1bEfNw362PTPL6jv77QSS13BR42v82Yzwx0c9KgoeG+PsyjM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw1eQo9LXI7tNyQYBJ56AOtrMR1uA7k92jJ4sud1xD5sV9NKop
	YBms6+R71+sFe4iQdc6Iv/AsI+w0hk527bjH/ZSfmuz/bzzynb2l3hlwfmOUqHLLHmuOegtHZw=
	=
X-Google-Smtp-Source: AGHT+IHaR4OtYgVkoAVUDStYqYv+9thvNuzjxTMXa8LJQryBI8+iut5U512tyfYG9g1hUPYb+umuGfZNFg==
X-Received: from edben5.prod.google.com ([2002:a05:6402:5285:b0:5dc:c943:7c1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:dc8d:b0:aac:622:8f6
 with SMTP id a640c23a62f3a-ab75e26558fmr633944866b.17.1738865926699; Thu, 06
 Feb 2025 10:18:46 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:18 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-25-elver@google.com>
Subject: [PATCH RFC 24/24] rhashtable: Enable capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Enable capability analysis for rhashtable, which was used as an initial
test as it contains a combination of RCU, mutex, and bit_spinlock usage.

Users of rhashtable now also benefit from annotations on the API, which
will now warn if the RCU read lock is not held where required.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/rhashtable.h | 14 +++++++++++---
 lib/Makefile               |  2 ++
 lib/rhashtable.c           | 12 +++++++++---
 3 files changed, 22 insertions(+), 6 deletions(-)

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
index 3e555d012ed6..47a61e214621 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -11,6 +11,10 @@
  * pointer as suggested by Josh Triplett
  */
 
+#include <linux/rhashtable.h>
+
+disable_capability_analysis();
+
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -22,10 +26,11 @@
 #include <linux/mm.h>
 #include <linux/jhash.h>
 #include <linux/random.h>
-#include <linux/rhashtable.h>
 #include <linux/err.h>
 #include <linux/export.h>
 
+enable_capability_analysis();
+
 #define HASH_DEFAULT_SIZE	64UL
 #define HASH_MIN_SIZE		4U
 
@@ -358,6 +363,7 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 static int rhashtable_rehash_alloc(struct rhashtable *ht,
 				   struct bucket_table *old_tbl,
 				   unsigned int size)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *new_tbl;
 	int err;
@@ -392,6 +398,7 @@ static int rhashtable_rehash_alloc(struct rhashtable *ht,
  * bucket locks or concurrent RCU protected lookups and traversals.
  */
 static int rhashtable_shrink(struct rhashtable *ht)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
 	unsigned int nelems = atomic_read(&ht->nelems);
@@ -724,7 +731,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
  * resize events and always continue.
  */
 int rhashtable_walk_start_check(struct rhashtable_iter *iter)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct rhashtable *ht = iter->ht;
 	bool rhlist = ht->rhlist;
@@ -940,7 +947,6 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_peek);
  * hash table.
  */
 void rhashtable_walk_stop(struct rhashtable_iter *iter)
-	__releases(RCU)
 {
 	struct rhashtable *ht;
 	struct bucket_table *tbl = iter->walker.tbl;
-- 
2.48.1.502.g6dc24dfdaf-goog

