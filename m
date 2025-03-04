Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D39E201269
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080353; cv=none; b=Cy8RLFctFIqYG8krDBdsCO3fCS7xG1L8RjFfsusgnjuoQKphHBYkehbR9RK14K/UiXaC7ZnwRqLYB/fpvzz1wCmljkE/4D5vllSARq42/3YcILJm5ACNkyNXmES6C4LB1o2rjXxKo+Z+hM7RTkHDkGg12zUpb6zFMFJn5H//vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080353; c=relaxed/simple;
	bh=+dINVo1oJ9VhsO5ynOzD5Y4e9AFKu3wP28ZuDYXPff0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AdrCnoAE0mILp4x4+te1GeVJx1b32iVC0j7u8JTMcR/Aaww6Ohwky2X0rcu6XMKRcgijxZsnHIb10s6iTvy5PmNDemq9f3C3Ji0kmbTfKcmJ4rpQfA+UTy2o+mRJMOXtu5p7yzTWX4iuAyNW7g3NnHb5+0ersf1kGvQhTpFl2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tR/1HHRk; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tR/1HHRk"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bc97e6360so5941545e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080349; x=1741685149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IjZvxS6CXb9r/jfHcsWB9NCl/hhxYyJhywIjI+5O6TY=;
        b=tR/1HHRkDANpTXSvuUTUiRr9w8AgP6XqHvtRHjBj8zzsPG9UnCHLc1wBi8frgXutGH
         FGk4+dNEtfkHHPkfTkS/21qWILINhAgMBZ8zTW40pHW01lC+gR6iuE9839N0bJERnzM6
         Fag9N0tWa8j3AyVmm20THdtI81A+feNVfW4E4GZc3ZwCAZG0m6A8D0cx61TLX49vsHok
         JR4DuhkKpBNDt8khZ23mN3nqLZBC367oeXpXO0/3rfbB15p/hs92a7GSRZu7SzVS/Yz/
         eobAUtuYMs8ALhbX4LbYLLL2TKyKu9HaczPfyHVNRbzTvCkkAz+TKC1lxwIzwK4gLFSD
         0ZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080349; x=1741685149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjZvxS6CXb9r/jfHcsWB9NCl/hhxYyJhywIjI+5O6TY=;
        b=UJLUELxRfOg+cn1kTfyzltzSaWHD2JZbjOoHyAK1kwubHheW8ZZ7RIbT4nlQsj7xqK
         MF7Key9qWRx8uMEmDLZM5ZiGbrFCNqWBlII5JfR0MoVp2NScnmsx8Goh0RbJq3vn56ft
         kRilpc92XCc3Xu02RdauKrDG/voSuGkPU5MBosgxhqZ+0VJN9r+HiDpL79Bzbpvnl4qi
         NgvGAWAxo5ZFASK1yTfcKt6lVQqReNA0jXZxg5zzootZI5lgUCYmSlkTjBn6w4TiWVk2
         8AQboHgAyTK5A+6cxox4VUoFLuM0WFpj9XvX0hsC+pGXv0vtdkhwCNMQpu40gG2v1DlG
         Dyhw==
X-Forwarded-Encrypted: i=1; AJvYcCUQg8x5E7Pm/PESsd1TdO/rXMIpm3Tepz656i/7tRpgW442/Yhm7pmKjwBLt9dnQFsvnt+KPE2KwmpVifI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwguBy1DoucyVqnuOsyTsp7uGeMaZkovOFl2nU5oj2GjG72t23I
	8WCaI0Y26DITjk2d/fWsdwoKkTJy7ZBk9IZ6HFlMKoHw/621f+e7ElM055cjDO7hM0XdZr27kw=
	=
X-Google-Smtp-Source: AGHT+IFiYcMhAel+FfswKkfKCtzdpYKZ8TP8BDehixv81OEAKQOJ8MSR/SDR6vYPbtqm7/NxYsQVJMCTAg==
X-Received: from wmbg14.prod.google.com ([2002:a05:600c:a40e:b0:43b:cebe:8011])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3c9c:b0:439:89e9:4eff
 with SMTP id 5b1f17b1804b1-43ba66e6b5dmr142151345e9.10.1741080349701; Tue, 04
 Mar 2025 01:25:49 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:14 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-16-elver@google.com>
Subject: [PATCH v2 15/34] srcu: Support Clang's capability analysis
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

Add support for Clang's capability analysis for SRCU.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/srcu.h                          | 61 +++++++++++++------
 lib/test_capability-analysis.c                | 24 ++++++++
 3 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index a14d796bcd0e..918e35d110df 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`).
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d7ba46e74f58..fde8bba191a5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -21,7 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
-struct srcu_struct;
+struct_with_capability(srcu_struct);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -60,14 +60,14 @@ int init_srcu_struct(struct srcu_struct *ssp);
 void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
 		void (*func)(struct rcu_head *head));
 void cleanup_srcu_struct(struct srcu_struct *ssp);
-int __srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp);
-void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
+int __srcu_read_lock(struct srcu_struct *ssp) __acquires_shared(ssp);
+void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 #ifdef CONFIG_TINY_SRCU
 #define __srcu_read_lock_lite __srcu_read_lock
 #define __srcu_read_unlock_lite __srcu_read_unlock
 #else // #ifdef CONFIG_TINY_SRCU
-int __srcu_read_lock_lite(struct srcu_struct *ssp) __acquires(ssp);
-void __srcu_read_unlock_lite(struct srcu_struct *ssp, int idx) __releases(ssp);
+int __srcu_read_lock_lite(struct srcu_struct *ssp) __acquires_shared(ssp);
+void __srcu_read_unlock_lite(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 #endif // #else // #ifdef CONFIG_TINY_SRCU
 void synchronize_srcu(struct srcu_struct *ssp);
 
@@ -110,14 +110,16 @@ static inline bool same_state_synchronize_srcu(unsigned long oldstate1, unsigned
 }
 
 #ifdef CONFIG_NEED_SRCU_NMI_SAFE
-int __srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp);
-void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx) __releases(ssp);
+int __srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires_shared(ssp);
+void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 #else
 static inline int __srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	return __srcu_read_lock(ssp);
 }
 static inline void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
+	__releases_shared(ssp)
 {
 	__srcu_read_unlock(ssp, idx);
 }
@@ -189,6 +191,14 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/*
+ * No-op helper to denote that ssp must be held. Because SRCU-protected pointers
+ * should still be marked with __rcu_guarded, and we do not want to mark them
+ * with __guarded_by(ssp) as it would complicate annotations for writers, we
+ * choose the following strategy: srcu_dereference_check() calls this helper
+ * that checks that the passed ssp is held, and then fake-acquires 'RCU'.
+ */
+static inline void __srcu_read_lock_must_hold(const struct srcu_struct *ssp) __must_hold_shared(ssp) { }
 
 /**
  * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
@@ -202,9 +212,15 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * to 1.  The @c argument will normally be a logical expression containing
  * lockdep_is_held() calls.
  */
-#define srcu_dereference_check(p, ssp, c) \
-	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
-				(c) || srcu_read_lock_held(ssp), __rcu)
+#define srcu_dereference_check(p, ssp, c)					\
+({										\
+	__srcu_read_lock_must_hold(ssp);					\
+	__acquire_shared_cap(RCU);						\
+	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
+				(c) || srcu_read_lock_held(ssp), __rcu);	\
+	__release_shared_cap(RCU);						\
+	__v;									\
+})
 
 /**
  * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
@@ -247,7 +263,8 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * invoke srcu_read_unlock() from one task and the matching srcu_read_lock()
  * from another.
  */
-static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -274,7 +291,8 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
  * where RCU is watching, that is, from contexts where it would be legal
  * to invoke rcu_read_lock().  Otherwise, lockdep will complain.
  */
-static inline int srcu_read_lock_lite(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock_lite(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -295,7 +313,8 @@ static inline int srcu_read_lock_lite(struct srcu_struct *ssp) __acquires(ssp)
  * then none of the other flavors may be used, whether before, during,
  * or after.
  */
-static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -307,7 +326,8 @@ static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp
 
 /* Used by tracing, cannot be traced and cannot invoke lockdep. */
 static inline notrace int
-srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
+srcu_read_lock_notrace(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -337,7 +357,8 @@ srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
  * Calls to srcu_down_read() may be nested, similar to the manner in
  * which calls to down_read() may be nested.
  */
-static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_down_read(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	WARN_ON_ONCE(in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -352,7 +373,7 @@ static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
  * Exit an SRCU read-side critical section.
  */
 static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -368,7 +389,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
  * Exit a light-weight SRCU read-side critical section.
  */
 static inline void srcu_read_unlock_lite(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_LITE);
@@ -384,7 +405,7 @@ static inline void srcu_read_unlock_lite(struct srcu_struct *ssp, int idx)
  * Exit an SRCU read-side critical section, but in an NMI-safe manner.
  */
 static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NMI);
@@ -394,7 +415,7 @@ static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
 
 /* Used by tracing, cannot be traced and cannot call lockdep. */
 static inline notrace void
-srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
+srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
 	__srcu_read_unlock(ssp, idx);
@@ -409,7 +430,7 @@ srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
  * the same context as the maching srcu_down_read().
  */
 static inline void srcu_up_read(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	WARN_ON_ONCE(in_nmi());
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 050fa7c9fcba..63d81ad1562f 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 
 /*
  * Test that helper macros work as expected.
@@ -345,3 +346,26 @@ static void __used test_rcu_assert_variants(void)
 	lockdep_assert_in_rcu_read_lock_sched();
 	wants_rcu_held_sched();
 }
+
+struct test_srcu_data {
+	struct srcu_struct srcu;
+	long __rcu_guarded *data;
+};
+
+static void __used test_srcu(struct test_srcu_data *d)
+{
+	init_srcu_struct(&d->srcu);
+
+	int idx = srcu_read_lock(&d->srcu);
+	long *data = srcu_dereference(d->data, &d->srcu);
+	(void)data;
+	srcu_read_unlock(&d->srcu, idx);
+
+	rcu_assign_pointer(d->data, NULL);
+}
+
+static void __used test_srcu_guard(struct test_srcu_data *d)
+{
+	guard(srcu)(&d->srcu);
+	(void)srcu_dereference(d->data, &d->srcu);
+}
-- 
2.48.1.711.g2feabab25a-goog

