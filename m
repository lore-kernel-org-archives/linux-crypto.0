Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FA3201113
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080351; cv=none; b=qHa0c5Ag9WnIVk/vqmAOZ35HR46Ei2weL9n8XErL2OCq+4f2UGQRIDLzaf7F/wRUyQ0eWW33zTpy6ExeBipT7RmPxjQP8qRfstqebV1Qavoetas3G7k1heUSl3r6CEinIItPXwguiy9T/OR1G4KSbpsLh4Zdd7dJ6NYC3TJqqoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080351; c=relaxed/simple;
	bh=Wqdc+WFhEaZMvjgCHc/zhoRNy3tiy2ObiXWVRytweCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ArkLqCOAKcZto4dipjDCceX3pLcLZKJFr352otVR7VUBZA/dRI5YEcZMnRUgEChEytDeg7TzR2GQ1eZP2xBERyEV7R0ZU8l0tyEC+kqAXA5LRFDiwkLAsUXKqEtY2kBJnQVznIwQf3YLwJmUGNEOz8MtSGrKWPI4xLoRIEpEvqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ErdcgKfJ; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ErdcgKfJ"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5da03762497so6780284a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080347; x=1741685147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGU1wvi0i2cL/7Vdis45pwSeF2hTx85fMwlXO1/FTUA=;
        b=ErdcgKfJndrKyJ17O00049zGXAsomluh0E8s1GNAkQBqpvPc5Lr3Yid7XLM048Iid5
         t+oD+wj4vhYvQFoIll3O7Vhstlg0qlbBRq2pJjBgMaY9ZOTeJiXOwCWrgvzY9PGAqBk9
         V9TC3UOEWT2aIEcADYHu+Mker6FYYFs0AMP7YdyMT3lrg2cVovQDTKD8Hb/kubY1Ufrq
         goQvJ0+H6iSv9WvQYXHI2VNwldL1KLzFTBBWesMyHvuwhKbyC05jCHilSvxzIhfeqi8p
         FKrnQNOcmVkJ1/vJPfkPb/7PRwVfjHRLDZXSpIcR6foIFhwl8U25+iBSy1a2pUrRp36B
         Nprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080347; x=1741685147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGU1wvi0i2cL/7Vdis45pwSeF2hTx85fMwlXO1/FTUA=;
        b=gICQVg9PICCXpFN1CggPhHAHJOOEfL4ZEd1SkJMj8ljb/hl6cBgBIcc9XKj12UoX9N
         2qqMeawnbzopic99i3oRgWPs+lSGA5o7CBtYNC242ki2DBiUA18kDgfwl23cZ9f1F37k
         N2WJ8UMF9TPFfuuRm3NcOqxgXgc3DbapxuQH2Yq9oIuUYmwu7OxIzbJw/+gWUI/W5MLy
         quLoeO1SdvnGxwIOhDPGP5zjlbFb6NlsfPp9NLH8xsiRc2qGWS5XvKBajCOSXkEslCXQ
         qaQDZmq9K6a5r7j6TU1Rz2E3rjNx0W2zyTDJeXaC4Z8rXFRkqx9wK2COsMXlxrpXAyVq
         zn0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWB5vBBl4L8xT4aj635APqdOKkyHYh706vuPAfiF5pJYdY87dq1JTiSGvuO5RMXrgZcWusLpHBJpHNmdoc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9b26WTGN3mqDs4AlryoB3CO4amAW4hCSDBd9wyhrBs6WHOax3
	uB+0lJqAaR/U4sp1cfeHbwBcTqMRvpw2DxFd6tbNTx1ngMyMhFJpfR8D7RLDLSM/Bm2RjrQA1Q=
	=
X-Google-Smtp-Source: AGHT+IEzpwBNdOV6S2p5H0ctMRiwI9pS2G54haANPvgkRgxFQlowUFQGknXrYikTwfs7UGOz8UW7jP5rjg==
X-Received: from edbek14.prod.google.com ([2002:a05:6402:370e:b0:5e5:2f33:208a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2546:b0:5e0:8a34:3b5c
 with SMTP id 4fb4d7f45d1cf-5e584d16ff6mr2399224a12.0.1741080347066; Tue, 04
 Mar 2025 01:25:47 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:13 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-15-elver@google.com>
Subject: [PATCH v2 14/34] rcu: Support Clang's capability analysis
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

Improve the existing annotations to properly support Clang's capability
analysis.

The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED;
however, to more easily be able to express that "hold the RCU read lock"
without caring if the normal, _bh(), or _sched() variant was used we'd
have to remove the distinction of the latter variants: change the _bh()
and _sched() variants to also acquire "RCU".

When (and if) we introduce capabilities to denote more generally that
"IRQ", "BH", "PREEMPT" are disabled, it would make sense to acquire
these capabilities instead of RCU_BH and RCU_SCHED respectively.

The above change also simplified introducing __guarded_by support, where
only the "RCU" capability needs to be held: introduce __rcu_guarded,
where Clang's capability analysis warns if a pointer is dereferenced
without any of the RCU locks held, or updated without the appropriate
helpers.

 | Note: A limitation of the compiler's analysis is re-entrancy; a pattern
 | such as the below will result in a warning:
 |
 |   rcu_read_lock();       // acquires RCU
 |   ..
 |   rcu_read_lock_bh();    // error: acquiring __capability_RCU 'RCU' that is already held
 |   ..
 |   rcu_read_unlock_bh();  // releases RCU
 |   ..
 |   rcu_read_unlock();     // error: releasing __capability_RCU 'RCU' that was not held
 |
 | Such patterns should generally be uncommon, and initial usage in enabled
 | subsystems did not result in any false positives due to re-entrancy.
 | Until the compiler supports re-entrancy, keeping the analysis disabled
 | for code relying on re-entrancy is the only option.

The primitives rcu_assign_pointer() and friends are wrapped with
capability_unsafe(), which enforces using them to update RCU-protected
pointers marked with __rcu_guarded.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Reword commit message and point out re-entrancy caveat.
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/cleanup.h                       |  4 +
 include/linux/rcupdate.h                      | 73 +++++++++++++------
 lib/test_capability-analysis.c                | 68 +++++++++++++++++
 4 files changed, 123 insertions(+), 24 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 65972d1e9570..a14d796bcd0e 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`.
+`bit_spinlock`, RCU.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 93a166549add..7d70d308357a 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -404,6 +404,10 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
 	return _t;							\
 }
 
+#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock
+
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 48e5c03df1dd..ef8875c4e621 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -31,6 +31,16 @@
 #include <asm/processor.h>
 #include <linux/context_tracking_irq.h>
 
+token_capability(RCU);
+token_capability_instance(RCU, RCU_SCHED);
+token_capability_instance(RCU, RCU_BH);
+
+/*
+ * A convenience macro that can be used for RCU-protected globals or struct
+ * members; adds type qualifier __rcu, and also enforces __guarded_by(RCU).
+ */
+#define __rcu_guarded __rcu __guarded_by(RCU)
+
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
@@ -431,7 +441,8 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 // See RCU_LOCKDEP_WARN() for an explanation of the double call to
 // debug_lockdep_rcu_enabled().
-static inline bool lockdep_assert_rcu_helper(bool c)
+static inline bool lockdep_assert_rcu_helper(bool c, const struct __capability_RCU *cap)
+	__asserts_shared_cap(RCU) __asserts_shared_cap(cap)
 {
 	return debug_lockdep_rcu_enabled() &&
 	       (c || !rcu_is_watching() || !rcu_lockdep_current_cpu_online()) &&
@@ -444,7 +455,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * Splats if lockdep is enabled and there is no rcu_read_lock() in effect.
  */
 #define lockdep_assert_in_rcu_read_lock() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map), RCU))
 
 /**
  * lockdep_assert_in_rcu_read_lock_bh - WARN if not protected by rcu_read_lock_bh()
@@ -454,7 +465,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * actual rcu_read_lock_bh() is required.
  */
 #define lockdep_assert_in_rcu_read_lock_bh() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map), RCU_BH))
 
 /**
  * lockdep_assert_in_rcu_read_lock_sched - WARN if not protected by rcu_read_lock_sched()
@@ -464,7 +475,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * instead an actual rcu_read_lock_sched() is required.
  */
 #define lockdep_assert_in_rcu_read_lock_sched() \
-	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map)))
+	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map), RCU_SCHED))
 
 /**
  * lockdep_assert_in_rcu_reader - WARN if not within some type of RCU reader
@@ -482,17 +493,17 @@ static inline bool lockdep_assert_rcu_helper(bool c)
 	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map) &&			\
 					       !lock_is_held(&rcu_bh_lock_map) &&		\
 					       !lock_is_held(&rcu_sched_lock_map) &&		\
-					       preemptible()))
+					       preemptible(), RCU))
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
 #define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
 #define rcu_sleep_check() do { } while (0)
 
-#define lockdep_assert_in_rcu_read_lock() do { } while (0)
-#define lockdep_assert_in_rcu_read_lock_bh() do { } while (0)
-#define lockdep_assert_in_rcu_read_lock_sched() do { } while (0)
-#define lockdep_assert_in_rcu_reader() do { } while (0)
+#define lockdep_assert_in_rcu_read_lock() __assert_shared_cap(RCU)
+#define lockdep_assert_in_rcu_read_lock_bh() __assert_shared_cap(RCU_BH)
+#define lockdep_assert_in_rcu_read_lock_sched() __assert_shared_cap(RCU_SCHED)
+#define lockdep_assert_in_rcu_reader() __assert_shared_cap(RCU)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -512,11 +523,11 @@ static inline bool lockdep_assert_rcu_helper(bool c)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __unrcu_pointer(p, local)					\
-({									\
+capability_unsafe(							\
 	typeof(*p) *local = (typeof(*p) *__force)(p);			\
 	rcu_check_sparse(p, __rcu);					\
 	((typeof(*p) __force __kernel *)(local)); 			\
-})
+)
 /**
  * unrcu_pointer - mark a pointer as not being RCU protected
  * @p: pointer needing to lose its __rcu property
@@ -592,7 +603,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
  * other macros that it invokes.
  */
 #define rcu_assign_pointer(p, v)					      \
-do {									      \
+capability_unsafe(							      \
 	uintptr_t _r_a_p__v = (uintptr_t)(v);				      \
 	rcu_check_sparse(p, __rcu);					      \
 									      \
@@ -600,7 +611,7 @@ do {									      \
 		WRITE_ONCE((p), (typeof(p))(_r_a_p__v));		      \
 	else								      \
 		smp_store_release(&p, RCU_INITIALIZER((typeof(p))_r_a_p__v)); \
-} while (0)
+)
 
 /**
  * rcu_replace_pointer() - replace an RCU pointer, returning its old value
@@ -843,9 +854,10 @@ do {									      \
  * only when acquiring spinlocks that are subject to priority inheritance.
  */
 static __always_inline void rcu_read_lock(void)
+	__acquires_shared(RCU)
 {
 	__rcu_read_lock();
-	__acquire(RCU);
+	__acquire_shared(RCU);
 	rcu_lock_acquire(&rcu_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock() used illegally while idle");
@@ -874,11 +886,12 @@ static __always_inline void rcu_read_lock(void)
  * See rcu_read_lock() for more information.
  */
 static inline void rcu_read_unlock(void)
+	__releases_shared(RCU)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
-	__release(RCU);
+	__release_shared(RCU);
 	__rcu_read_unlock();
 }
 
@@ -897,9 +910,11 @@ static inline void rcu_read_unlock(void)
  * was invoked from some other task.
  */
 static inline void rcu_read_lock_bh(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_BH)
 {
 	local_bh_disable();
-	__acquire(RCU_BH);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_BH);
 	rcu_lock_acquire(&rcu_bh_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock_bh() used illegally while idle");
@@ -911,11 +926,13 @@ static inline void rcu_read_lock_bh(void)
  * See rcu_read_lock_bh() for more information.
  */
 static inline void rcu_read_unlock_bh(void)
+	__releases_shared(RCU) __releases_shared(RCU_BH)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock_bh() used illegally while idle");
 	rcu_lock_release(&rcu_bh_lock_map);
-	__release(RCU_BH);
+	__release_shared(RCU_BH);
+	__release_shared(RCU);
 	local_bh_enable();
 }
 
@@ -935,9 +952,11 @@ static inline void rcu_read_unlock_bh(void)
  * rcu_read_lock_sched() was invoked from an NMI handler.
  */
 static inline void rcu_read_lock_sched(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
 {
 	preempt_disable();
-	__acquire(RCU_SCHED);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_lock_sched() used illegally while idle");
@@ -945,9 +964,11 @@ static inline void rcu_read_lock_sched(void)
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_lock_sched_notrace(void)
+	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
 {
 	preempt_disable_notrace();
-	__acquire(RCU_SCHED);
+	__acquire_shared(RCU);
+	__acquire_shared(RCU_SCHED);
 }
 
 /**
@@ -956,18 +977,22 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  * See rcu_read_lock_sched() for more information.
  */
 static inline void rcu_read_unlock_sched(void)
+	__releases_shared(RCU) __releases_shared(RCU_SCHED)
 {
 	RCU_LOCKDEP_WARN(!rcu_is_watching(),
 			 "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
-	__release(RCU_SCHED);
+	__release_shared(RCU_SCHED);
+	__release_shared(RCU);
 	preempt_enable();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
 static inline notrace void rcu_read_unlock_sched_notrace(void)
+	__releases_shared(RCU) __releases_shared(RCU_SCHED)
 {
-	__release(RCU_SCHED);
+	__release_shared(RCU_SCHED);
+	__release_shared(RCU);
 	preempt_enable_notrace();
 }
 
@@ -1010,10 +1035,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * ordering guarantees for either the CPU or the compiler.
  */
 #define RCU_INIT_POINTER(p, v) \
-	do { \
+	capability_unsafe( \
 		rcu_check_sparse(p, __rcu); \
 		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
-	} while (0)
+	)
 
 /**
  * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
@@ -1172,4 +1197,6 @@ DEFINE_LOCK_GUARD_0(rcu,
 	} while (0),
 	rcu_read_unlock())
 
+DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU));
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index ad362d5a7916..050fa7c9fcba 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -7,6 +7,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
@@ -277,3 +278,70 @@ static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
 		bit_spin_unlock(3, &d->bits);
 	}
 }
+
+/*
+ * Test that we can mark a variable guarded by RCU, and we can dereference and
+ * write to the pointer with RCU's primitives.
+ */
+struct test_rcu_data {
+	long __rcu_guarded *data;
+};
+
+static void __used test_rcu_guarded_reader(struct test_rcu_data *d)
+{
+	rcu_read_lock();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock();
+
+	rcu_read_lock_bh();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock_bh();
+
+	rcu_read_lock_sched();
+	(void)rcu_dereference(d->data);
+	rcu_read_unlock_sched();
+}
+
+static void __used test_rcu_guard(struct test_rcu_data *d)
+{
+	guard(rcu)();
+	(void)rcu_dereference(d->data);
+}
+
+static void __used test_rcu_guarded_updater(struct test_rcu_data *d)
+{
+	rcu_assign_pointer(d->data, NULL);
+	RCU_INIT_POINTER(d->data, NULL);
+	(void)unrcu_pointer(d->data);
+}
+
+static void wants_rcu_held(void)	__must_hold_shared(RCU)       { }
+static void wants_rcu_held_bh(void)	__must_hold_shared(RCU_BH)    { }
+static void wants_rcu_held_sched(void)	__must_hold_shared(RCU_SCHED) { }
+
+static void __used test_rcu_lock_variants(void)
+{
+	rcu_read_lock();
+	wants_rcu_held();
+	rcu_read_unlock();
+
+	rcu_read_lock_bh();
+	wants_rcu_held_bh();
+	rcu_read_unlock_bh();
+
+	rcu_read_lock_sched();
+	wants_rcu_held_sched();
+	rcu_read_unlock_sched();
+}
+
+static void __used test_rcu_assert_variants(void)
+{
+	lockdep_assert_in_rcu_read_lock();
+	wants_rcu_held();
+
+	lockdep_assert_in_rcu_read_lock_bh();
+	wants_rcu_held_bh();
+
+	lockdep_assert_in_rcu_read_lock_sched();
+	wants_rcu_held_sched();
+}
-- 
2.48.1.711.g2feabab25a-goog

