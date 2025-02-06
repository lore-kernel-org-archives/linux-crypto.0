Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FED81F868F
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865911; cv=none; b=H3UqlRC28qhUyd3oogNOTktEkMPNagnrnOkyPM5y8CbBiaewFTCtxJuF0KFCvtrMR187JcenHOQycv70erYhws2vI/1mXLG72PqzuTGFDtFy6y4jS06dfQ4cB9u0EHqzFRq8MSi6BZc4yRz2+/m27zUKpmc4hEy6JtB6MlkFClo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865911; c=relaxed/simple;
	bh=9NvpT1xaNJVbVqSm8G/+XOo08oZlb8dEjdT0tJE3yMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AvlrszA6T9Y3VZOLXDdNFq2uyaIWEMbyVNGlpI9aUXXicUGF5jGmEx8frFfP0oeakUPizLOQDr86Nqe/roXQ0OafamdUzq0NT6YbZkQQhboLtvyyIDPcW8XwIzf/Z9cgfzSVFO3lTmVpELnGBJZKigsXtpf8v6T5uGXrhKkhCEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P5Ktb/gZ; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P5Ktb/gZ"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa689b88293so130821566b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865906; x=1739470706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQXyMw84n+KN7BKVw/OtNJwL/he84+ejRwU4F35ugF4=;
        b=P5Ktb/gZNFX/xvBTGLBEvLoCScSWyrrt8ZxPV97etNVly1lVvMIFdwE7n4kIgNb3Yk
         abw9O2IPRiybtujuwrB9VQpO7ZAGBV/rW+xjVM+6ONDA8kIj2jTCrzNOY4DuVaFtNE6V
         o9NP4AcnEGNQSEpnRozG5OlEPOmPGkeEZbKRrB1ZkHjgXdXKOw3dyhClhAvDzBjawHMG
         ymRtpzwJv+0CaVQszdG/8l2tbXTsq7M1XV0kwoXWLJK8UOwjYSsXrh9XtVWDPLj0dkd1
         B6dCCOLMsc2x+WAQ1tn3lcNC+YP/jvQtqCqRI5hYvwTQbtVuhFqnq4/l0t+ieZalm9xX
         35TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865906; x=1739470706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQXyMw84n+KN7BKVw/OtNJwL/he84+ejRwU4F35ugF4=;
        b=bWB3JZb4FPk/GShJPo/UVUlConyfhUwYL7bReXNwkqctkGslCZQDzx/Bmkf0Ze7IDp
         1x+SagJ1SbGPKZsHG8v47ZeM6pa4fxUXobuyH/mN8i2GHs7HuoOPs0GA8ilBNhMbWVZ1
         nVcH0z/8Vt3CgYzcJod++2KcdyMZLb/nhGcokQ1xIkGUQAzK/WA3xq4MkGIbEBy/ka7E
         MKPBVz7LXukxax4x/+lfuAeZbopGxS6g1I88wU9rK4ATcMvOdbnu4OGhjMSd24Ag4xWY
         tILcCizfhj/PgRn0LeifgoELlNwhUiICAWkmqPuwD0aw5+HtTKRO+z8rdVXoACDPebur
         /7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCX5qWc5zt4WMBsngYk9JwsJacdHUE/aXsZt7Kt4KmF5iUK8Mron8u79afzksO0GPnLUjI4VOiApC5LAgdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcX2MVhx7sH3Q7TnwF1ZTdt875fn+NJCGJO3qRPAjcmxdr2tdz
	NFwcNvDcAxfCJ/g5Arc9NoRMgC8XDPLyxnkwzCnt2LsjNpgiRSyilGABDcDWPBM89c89FcLIBA=
	=
X-Google-Smtp-Source: AGHT+IHZYxOsD+xJIbdoA+mMUNGhu0UIVcbIEjPgFMgubaFg9/8FZuVYQVxxJZ4RkmKxQO8jomuTw/hsWQ==
X-Received: from ejcss11.prod.google.com ([2002:a17:907:c00b:b0:ab7:822d:f553])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:856:b0:ab7:6606:a8d5
 with SMTP id a640c23a62f3a-ab76606b5camr644091966b.48.1738865906398; Thu, 06
 Feb 2025 10:18:26 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:10 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-17-elver@google.com>
Subject: [PATCH RFC 16/24] srcu: Support Clang's capability analysis
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

Add support for Clang's capability analysis for SRCU.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/srcu.h                          | 61 +++++++++++++------
 lib/test_capability-analysis.c                | 24 ++++++++
 3 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 73dd28a23b11..3766ac466470 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -86,7 +86,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`).
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d7ba46e74f58..560310643c54 100644
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
+ * with __var_guarded_by(ssp) as it would complicate annotations for writers, we
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
index f5a1dda6ca38..8bc8c3e6cb5c 100644
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
2.48.1.502.g6dc24dfdaf-goog

