Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86568357728
	for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815654; cv=none; b=EW/7P7LrTTr9MQ1PYG3TsOt4MEEPdpFiRLhVwjluP/rmZva9horCwqhktDFDT/l+onhUDOZqqW5d+qLY/7AkYSB2tUSMD9+Hz4bOkOMcwvRQFF0yO92vscSnxLoH85NPO9/5SAx2+9X8xwJNxyDB4YX/deDEWmBMb15/bB1xrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815654; c=relaxed/simple;
	bh=gYPjePwKj6eP1K5hbASZ5QpHpt6NcrjYVrUhGil1MoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1yl+bz30lwITwkryEaTMEbreQWSFZCS+v3fMhUhKy6uDL6AXh6H3283hOJ3HUL724tQ/rTHKu4fu410/Vm1HUyJvJJBjvpx+FZ6mKQ7hDYYjiB2nwZiP5NRud8OYVEsbYzrFW/+EpSZyT1G02mNr4y9nMKdQAFGWkP2i1w47h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V9pI/kLf; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V9pI/kLf"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ee33324e8so23744215e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 01:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768815651; x=1769420451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HreKJW6Uhd9IMPcJS7ezcF4nMQIgMSBOdw1/CLSMwUI=;
        b=V9pI/kLfZ8YReQ1cXoHEFYQJdotoYuZF4CtjU87J4Fs7VR4goUk0EbGbzg9aaXM+B9
         aDheBL7S6dZmCuoLvlb5nLoh4lO8h8OfLR7eWg7IiG8Jz+2pDmSchswspjB/EiPZRE1I
         41jOlv8Hhh31rTaic2tGzN4DKlZwFgxzIz5wsnxXu0M4QIFOskuwNosY3P5JIWeuSli5
         03WjmlLfjYX0o+wUepcNcF5LMRog1hnq/xyd9V8yOMnNUhE+Krs6nFjvYcODR5PtbYHU
         T/MJPeyp+pEP7mT4CGR7VqdSV5bSXkm9kL2K7MWwGF6m2XHrJjDVI8+PRu5FgeuNeiuu
         64/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815651; x=1769420451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HreKJW6Uhd9IMPcJS7ezcF4nMQIgMSBOdw1/CLSMwUI=;
        b=oOAAfhuUmQvM2pf1fAjc/4Yf6aCOsXk1L7P5uHi/ErFt1yrKfTSY8seZpKCchNrUMX
         THxJVD+tLOD2brvQKesxWCuZsWUXKFaqLxz7cItDDWrZrcLMHWY72oYWg/q2jXjVpPCI
         Ty+/mDpUEtqzENNb2SqHABu598yZEmn+ePWFqGXjVji+8NdG9G7ak856WZ5vpl2rxTVS
         LTOA5gkomkQbToU7fRciNavzmTeGJ8nOSUbblae2C+R9XQP0/qDCKDE9r8eelcIxVqcJ
         gZXVfEaV1SeaGzjhSYdvPS6HpgUKARmo/Dz1qU+kWHirtv+B3bp6sDLhtotWo+1E2BHo
         nHLA==
X-Forwarded-Encrypted: i=1; AJvYcCWocF1B3tKBXyIpiVoiGyp3sRp0NGDGYvmy/oPgI9eHgsLsmUzmMRY4Wm4cs4eBGlvqrYATKQJDqrCHLb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKya1nE9QC60ehfMBkx+YQtVVfBQGMDUue1INoxBow487j+40V
	oTHH4ffimWYhrqO2ZBbVlgSryycete1W3Wphh0CDYg+DHpDvS31Oj6VbLcQA00BIOt6mhDWQzrr
	OAA==
X-Received: from wmbd23.prod.google.com ([2002:a05:600c:58d7:b0:477:9654:b44c])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:138a:b0:477:1af2:f40a
 with SMTP id 5b1f17b1804b1-4801e33c066mr161283195e9.17.1768815650997; Mon, 19
 Jan 2026 01:40:50 -0800 (PST)
Date: Mon, 19 Jan 2026 10:05:52 +0100
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260119094029.1344361-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119094029.1344361-3-elver@google.com>
Subject: [PATCH tip/locking/core 2/6] compiler-context-analysis: Introduce
 scoped init guards
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, Bart Van Assche <bvanassche@acm.org>, 
	kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add scoped init guard definitions for common synchronization primitives
supported by context analysis.

The scoped init guards treat the context as active within initialization
scope of the underlying context lock, given initialization implies
exclusive access to the underlying object. This allows initialization of
guarded members without disabling context analysis, while documenting
initialization from subsequent usage.

The documentation is updated with the new recommendation. Where scoped
init guards are not provided or cannot be implemented (ww_mutex omitted
for lack of multi-arg guard initializers), the alternative is to just
disable context analysis where guarded members are initialized.

Link: https://lore.kernel.org/all/20251212095943.GM3911114@noisy.programming.kicks-ass.net/
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
---
 Documentation/dev-tools/context-analysis.rst | 30 ++++++++++++++++++--
 include/linux/compiler-context-analysis.h    |  9 ++----
 include/linux/local_lock.h                   |  8 ++++++
 include/linux/local_lock_internal.h          |  1 +
 include/linux/mutex.h                        |  3 ++
 include/linux/rwsem.h                        |  4 +++
 include/linux/seqlock.h                      |  5 ++++
 include/linux/spinlock.h                     | 12 ++++++++
 lib/test_context-analysis.c                  | 16 +++++------
 9 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index e69896e597b6..54d9ee28de98 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -83,9 +83,33 @@ Currently the following synchronization primitives are supported:
 `bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`,
 `ww_mutex`.
 
-For context locks with an initialization function (e.g., `spin_lock_init()`),
-calling this function before initializing any guarded members or globals
-prevents the compiler from issuing warnings about unguarded initialization.
+To initialize variables guarded by a context lock with an initialization
+function (``type_init(&lock)``), prefer using ``guard(type_init)(&lock)`` or
+``scoped_guard(type_init, &lock) { ... }`` to initialize such guarded members
+or globals in the enclosing scope. This initializes the context lock and treats
+the context as active within the initialization scope (initialization implies
+exclusive access to the underlying object).
+
+For example::
+
+    struct my_data {
+            spinlock_t lock;
+            int counter __guarded_by(&lock);
+    };
+
+    void init_my_data(struct my_data *d)
+    {
+            ...
+            guard(spinlock_init)(&d->lock);
+            d->counter = 0;
+            ...
+    }
+
+Alternatively, initializing guarded variables can be done with context analysis
+disabled, preferably in the smallest possible scope (due to lack of any other
+checking): either with a ``context_unsafe(var = init)`` expression, or by
+marking small initialization functions with the ``__context_unsafe(init)``
+attribute.
 
 Lockdep assertions, such as `lockdep_assert_held()`, inform the compiler's
 context analysis that the associated synchronization primitive is held after
diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
index db7e0d48d8f2..27ea01adeb2c 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -32,13 +32,8 @@
 /*
  * The "assert_capability" attribute is a bit confusingly named. It does not
  * generate a check. Instead, it tells the analysis to *assume* the capability
- * is held. This is used for:
- *
- * 1. Augmenting runtime assertions, that can then help with patterns beyond the
- *    compiler's static reasoning abilities.
- *
- * 2. Initialization of context locks, so we can access guarded variables right
- *    after initialization (nothing else should access the same object yet).
+ * is held. This is used for augmenting runtime assertions, that can then help
+ * with patterns beyond the compiler's static reasoning abilities.
  */
 # define __assumes_ctx_lock(...)		__attribute__((assert_capability(__VA_ARGS__)))
 # define __assumes_shared_ctx_lock(...)	__attribute__((assert_shared_capability(__VA_ARGS__)))
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 99c06e499375..b8830148a859 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -104,6 +104,8 @@ DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
 		    local_lock_nested_bh(_T->lock),
 		    local_unlock_nested_bh(_T->lock))
 
+DEFINE_LOCK_GUARD_1(local_lock_init, local_lock_t, local_lock_init(_T->lock), /* */)
+
 DECLARE_LOCK_GUARD_1_ATTRS(local_lock, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
 #define class_local_lock_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock, _T)
 DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irq, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
@@ -112,5 +114,11 @@ DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irqsave, __acquires(_T), __releases(*(loca
 #define class_local_lock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_irqsave, _T)
 DECLARE_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
 #define class_local_lock_nested_bh_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_init, __acquires(_T), __releases(*(local_lock_t **)_T))
+#define class_local_lock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_init, _T)
+
+DEFINE_LOCK_GUARD_1(local_trylock_init, local_trylock_t, local_trylock_init(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_trylock_init, __acquires(_T), __releases(*(local_trylock_t **)_T))
+#define class_local_trylock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_trylock_init, _T)
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index e8c4803d8db4..4521c40895f8 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -6,6 +6,7 @@
 #include <linux/percpu-defs.h>
 #include <linux/irqflags.h>
 #include <linux/lockdep.h>
+#include <linux/debug_locks.h>
 #include <asm/current.h>
 
 #ifndef CONFIG_PREEMPT_RT
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 89977c215cbd..6b12009351d2 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -254,6 +254,7 @@ extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_a
 DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
 DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
 DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)
+DEFINE_LOCK_GUARD_1(mutex_init, struct mutex, mutex_init(_T->lock), /* */)
 
 DECLARE_LOCK_GUARD_1_ATTRS(mutex,	__acquires(_T), __releases(*(struct mutex **)_T))
 #define class_mutex_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex, _T)
@@ -261,6 +262,8 @@ DECLARE_LOCK_GUARD_1_ATTRS(mutex_try,	__acquires(_T), __releases(*(struct mutex
 #define class_mutex_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_try, _T)
 DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr,	__acquires(_T), __releases(*(struct mutex **)_T))
 #define class_mutex_intr_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_intr, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_init,	__acquires(_T), __releases(*(struct mutex **)_T))
+#define class_mutex_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(mutex_init, _T)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8da14a08a4e1..ea1bbdb57a47 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -280,6 +280,10 @@ DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_try, __acquires(_T), __releases(*(struct
 DECLARE_LOCK_GUARD_1_ATTRS(rwsem_write_kill, __acquires(_T), __releases(*(struct rw_semaphore **)_T))
 #define class_rwsem_write_kill_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_write_kill, _T)
 
+DEFINE_LOCK_GUARD_1(rwsem_init, struct rw_semaphore, init_rwsem(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwsem_init, __acquires(_T), __releases(*(struct rw_semaphore **)_T))
+#define class_rwsem_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwsem_init, _T)
+
 /*
  * downgrade write lock to read lock
  */
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 113320911a09..22216df47b0f 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -14,6 +14,7 @@
  */
 
 #include <linux/compiler.h>
+#include <linux/cleanup.h>
 #include <linux/kcsan-checks.h>
 #include <linux/lockdep.h>
 #include <linux/mutex.h>
@@ -1359,4 +1360,8 @@ static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
 #define scoped_seqlock_read(_seqlock, _target)				\
 	__scoped_seqlock_read(_seqlock, _target, __UNIQUE_ID(seqlock))
 
+DEFINE_LOCK_GUARD_1(seqlock_init, seqlock_t, seqlock_init(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(seqlock_init, __acquires(_T), __releases(*(seqlock_t **)_T))
+#define class_seqlock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(seqlock_init, _T)
+
 #endif /* __LINUX_SEQLOCK_H */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 396b8c5d6c1b..7b11991c742a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -582,6 +582,10 @@ DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irqsave, _try,
 DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_irqsave_try, __acquires(_T), __releases(*(raw_spinlock_t **)_T))
 #define class_raw_spinlock_irqsave_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(raw_spinlock_irqsave_try, _T)
 
+DEFINE_LOCK_GUARD_1(raw_spinlock_init, raw_spinlock_t, raw_spin_lock_init(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_init, __acquires(_T), __releases(*(raw_spinlock_t **)_T))
+#define class_raw_spinlock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(raw_spinlock_init, _T)
+
 DEFINE_LOCK_GUARD_1(spinlock, spinlock_t,
 		    spin_lock(_T->lock),
 		    spin_unlock(_T->lock))
@@ -626,6 +630,10 @@ DEFINE_LOCK_GUARD_1_COND(spinlock_irqsave, _try,
 DECLARE_LOCK_GUARD_1_ATTRS(spinlock_irqsave_try, __acquires(_T), __releases(*(spinlock_t **)_T))
 #define class_spinlock_irqsave_try_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(spinlock_irqsave_try, _T)
 
+DEFINE_LOCK_GUARD_1(spinlock_init, spinlock_t, spin_lock_init(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_init, __acquires(_T), __releases(*(spinlock_t **)_T))
+#define class_spinlock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(spinlock_init, _T)
+
 DEFINE_LOCK_GUARD_1(read_lock, rwlock_t,
 		    read_lock(_T->lock),
 		    read_unlock(_T->lock))
@@ -664,5 +672,9 @@ DEFINE_LOCK_GUARD_1(write_lock_irqsave, rwlock_t,
 DECLARE_LOCK_GUARD_1_ATTRS(write_lock_irqsave, __acquires(_T), __releases(*(rwlock_t **)_T))
 #define class_write_lock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(write_lock_irqsave, _T)
 
+DEFINE_LOCK_GUARD_1(rwlock_init, rwlock_t, rwlock_init(_T->lock), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(rwlock_init, __acquires(_T), __releases(*(rwlock_t **)_T))
+#define class_rwlock_init_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(rwlock_init, _T)
+
 #undef __LINUX_INSIDE_SPINLOCK_H
 #endif /* __LINUX_SPINLOCK_H */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 1c5a381461fc..0f05943d957f 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -35,7 +35,7 @@ static void __used test_common_helpers(void)
 	};											\
 	static void __used test_##class##_init(struct test_##class##_data *d)			\
 	{											\
-		type_init(&d->lock);								\
+		guard(type_init)(&d->lock);							\
 		d->counter = 0;									\
 	}											\
 	static void __used test_##class(struct test_##class##_data *d)				\
@@ -83,7 +83,7 @@ static void __used test_common_helpers(void)
 
 TEST_SPINLOCK_COMMON(raw_spinlock,
 		     raw_spinlock_t,
-		     raw_spin_lock_init,
+		     raw_spinlock_init,
 		     raw_spin_lock,
 		     raw_spin_unlock,
 		     raw_spin_trylock,
@@ -109,7 +109,7 @@ static void __used test_raw_spinlock_trylock_extra(struct test_raw_spinlock_data
 
 TEST_SPINLOCK_COMMON(spinlock,
 		     spinlock_t,
-		     spin_lock_init,
+		     spinlock_init,
 		     spin_lock,
 		     spin_unlock,
 		     spin_trylock,
@@ -163,7 +163,7 @@ struct test_mutex_data {
 
 static void __used test_mutex_init(struct test_mutex_data *d)
 {
-	mutex_init(&d->mtx);
+	guard(mutex_init)(&d->mtx);
 	d->counter = 0;
 }
 
@@ -226,7 +226,7 @@ struct test_seqlock_data {
 
 static void __used test_seqlock_init(struct test_seqlock_data *d)
 {
-	seqlock_init(&d->sl);
+	guard(seqlock_init)(&d->sl);
 	d->counter = 0;
 }
 
@@ -275,7 +275,7 @@ struct test_rwsem_data {
 
 static void __used test_rwsem_init(struct test_rwsem_data *d)
 {
-	init_rwsem(&d->sem);
+	guard(rwsem_init)(&d->sem);
 	d->counter = 0;
 }
 
@@ -475,7 +475,7 @@ static DEFINE_PER_CPU(struct test_local_lock_data, test_local_lock_data) = {
 
 static void __used test_local_lock_init(struct test_local_lock_data *d)
 {
-	local_lock_init(&d->lock);
+	guard(local_lock_init)(&d->lock);
 	d->counter = 0;
 }
 
@@ -519,7 +519,7 @@ static DEFINE_PER_CPU(struct test_local_trylock_data, test_local_trylock_data) =
 
 static void __used test_local_trylock_init(struct test_local_trylock_data *d)
 {
-	local_trylock_init(&d->lock);
+	guard(local_trylock_init)(&d->lock);
 	d->counter = 0;
 }
 
-- 
2.52.0.457.g6b5491de43-goog

