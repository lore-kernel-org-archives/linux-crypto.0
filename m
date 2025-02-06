Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7588F2010E6
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865918; cv=none; b=iZH1wlgf1GKmPzhhTQyFza472eR8zvJYUZiQPcdBubNv8CJsHkfCVtATEdn/doqGjqIzPUG64nkd1dZXK8YjH13jjsfOz/V8zvoUhnI5H+q472/dL5V7jDI17foqul3SuHU2lQyXsWA6VmBIqUNCNCh0fGXQgmyuHX7fLBtUoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865918; c=relaxed/simple;
	bh=L1EG/Pog/Bknty3ffiiK6+CRlNE7aUcIt8NuXQ0NddY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oqrq/hkpNBFf0sBlAUJp14y0FrlZybGCi9P74XQPWBh+U71d/5ikVk816xdANudCc1v9bcvBjtlpMw12eW0FqPYG2ekkiqcxHRcrJ7cPR/3LdtBJ90FrHBmp4X3+m93M/AMI478aX3/L2FJ8omI5HrzQpnc1fWeqQJhBQyguofk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OaCaW8wx; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OaCaW8wx"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ab773dd745fso119608166b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865914; x=1739470714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4B3dc+uw3kIUoAQrEfaYRIJGMzUFqPSDxrvx8H6TaQ=;
        b=OaCaW8wxR30KrYECejUg+jwXmaBa+/tqpjJBLR/m86M4DqHw1aeSYEZ8vchx0MtaL3
         SUKaMyzzp9KouPx/Ag0WXu9u+ka3E+9AsN29HrNI9mgvfTTQQ4T1t19Uvm/+S5jQf8lU
         KpkBTZ03wxUUriJUmvObAggQHgkc5ulijYHPnmbxSzJfP6WBpLH87bwTEE0f9yKY3JWT
         Gy0R1gszxw1W+hACh5rKCibSDWgACuSrV/CKgcoh7ddLrSBZsS3aockX9C1dtCbObrIw
         2IL6c9BTDBVpG2dhGPq2ZOKP4ij8QiycZny5Ry6hG+eRMg+eCuj4KkEBWWoyKl0c6kbB
         5xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865914; x=1739470714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4B3dc+uw3kIUoAQrEfaYRIJGMzUFqPSDxrvx8H6TaQ=;
        b=WoMI0zylYqyUNd2FGZUqWOsDhq7Pc2XQavK3ZBJvTfv1z0D4p5xPWU2sw+1zpoK/RK
         aHE2EElv5qIEm5TFmKhMpgMWVU/tUO7O698s6xuwALiBs9Tm+vs0zDjPNZztGvfpFyjv
         pr2xdnjgYgl/pOJlZ4n6CRdYjEVxTU8ShYHEtqVd9NKvkVUv9Zkf+nEIruIKA9bwfr6E
         mywBuGz5lBAHG21jmD1NybsXHWGzUYK7GVd8Ugti7CPA5Q+EEEMldIVTvUi4KwBBVIdD
         YUqNqIqXkC6oOfz9M4NCJL6OglVGqG0U9cYEF4nKZDiq1xKKjAa/9/G1FZsb34FSHEHp
         Y8zw==
X-Forwarded-Encrypted: i=1; AJvYcCX/PMljiHp/0loi5pLLMi/EoHzLjSXEBCXufG9jgULk72iQY7iS0pSl4y2JRRHu8NRRYEn5b6ehL1OXzQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS19YUsTTgrti4nquyLOlgvHxOF6sF+jjDLlRYCU5K8s5sThUO
	JFO1KKpQoHf+MrjVTXQR1JWcGLlBoUfKN1VS7AOaogYUbxHX3Rzuufjj7G69HOHOZtr/zVuEqg=
	=
X-Google-Smtp-Source: AGHT+IGoGX/frEP3WONTFmzfntA7mN3pNwgZKUAdg2rEUwf3T8agPxmffbfAd5hLQ1tVZvBZMMK7mObHWw==
X-Received: from ejctl25.prod.google.com ([2002:a17:907:c319:b0:aa6:a222:16ac])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6094:b0:ab6:f4e7:52f9
 with SMTP id a640c23a62f3a-ab75e26494emr827537866b.25.1738865914032; Thu, 06
 Feb 2025 10:18:34 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:13 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-20-elver@google.com>
Subject: [PATCH RFC 19/24] locking/local_lock: Support Clang's capability analysis
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

Add support for Clang's capability analysis for local_lock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/local_lock.h                    | 18 ++++----
 include/linux/local_lock_internal.h           | 41 ++++++++++++++---
 lib/test_capability-analysis.c                | 46 +++++++++++++++++++
 4 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 719986739b0e..1e9ce018e30e 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -86,7 +86,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 091dc0b6bdfb..63fadcf66216 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -51,12 +51,12 @@
 #define local_unlock_irqrestore(lock, flags)			\
 	__local_unlock_irqrestore(lock, flags)
 
-DEFINE_GUARD(local_lock, local_lock_t __percpu*,
-	     local_lock(_T),
-	     local_unlock(_T))
-DEFINE_GUARD(local_lock_irq, local_lock_t __percpu*,
-	     local_lock_irq(_T),
-	     local_unlock_irq(_T))
+DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
+		    local_lock(_T->lock),
+		    local_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu,
+		    local_lock_irq(_T->lock),
+		    local_unlock_irq(_T->lock))
 DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 		    local_lock_irqsave(_T->lock, _T->flags),
 		    local_unlock_irqrestore(_T->lock, _T->flags),
@@ -68,8 +68,8 @@ DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 #define local_unlock_nested_bh(_lock)				\
 	__local_unlock_nested_bh(_lock)
 
-DEFINE_GUARD(local_lock_nested_bh, local_lock_t __percpu*,
-	     local_lock_nested_bh(_T),
-	     local_unlock_nested_bh(_T))
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+		    local_lock_nested_bh(_T->lock),
+		    local_unlock_nested_bh(_T->lock))
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 8dd71fbbb6d2..031de28d8ffb 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -8,12 +8,13 @@
 
 #ifndef CONFIG_PREEMPT_RT
 
-typedef struct {
+struct_with_capability(local_lock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
-} local_lock_t;
+};
+typedef struct local_lock local_lock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define LOCAL_LOCK_DEBUG_INIT(lockname)		\
@@ -60,6 +61,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assert_cap(lock);					\
 } while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
@@ -71,40 +73,47 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
+	__assert_cap(lock);					\
 } while (0)
 
 #define __local_lock(lock)					\
 	do {							\
 		preempt_disable();				\
 		local_lock_acquire(this_cpu_ptr(lock));		\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irq(lock)					\
 	do {							\
 		local_irq_disable();				\
 		local_lock_acquire(this_cpu_ptr(lock));		\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irqsave(lock, flags)			\
 	do {							\
 		local_irq_save(flags);				\
 		local_lock_acquire(this_cpu_ptr(lock));		\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_unlock(lock)					\
 	do {							\
+		__release(lock);				\
 		local_lock_release(this_cpu_ptr(lock));		\
 		preempt_enable();				\
 	} while (0)
 
 #define __local_unlock_irq(lock)				\
 	do {							\
+		__release(lock);				\
 		local_lock_release(this_cpu_ptr(lock));		\
 		local_irq_enable();				\
 	} while (0)
 
 #define __local_unlock_irqrestore(lock, flags)			\
 	do {							\
+		__release(lock);				\
 		local_lock_release(this_cpu_ptr(lock));		\
 		local_irq_restore(flags);			\
 	} while (0)
@@ -113,19 +122,37 @@ do {								\
 	do {							\
 		lockdep_assert_in_softirq();			\
 		local_lock_acquire(this_cpu_ptr(lock));	\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_unlock_nested_bh(lock)				\
-	local_lock_release(this_cpu_ptr(lock))
+	do {							\
+		__release(lock);				\
+		local_lock_release(this_cpu_ptr(lock));		\
+	} while (0)
 
 #else /* !CONFIG_PREEMPT_RT */
 
+#include <linux/spinlock.h>
+
 /*
  * On PREEMPT_RT local_lock maps to a per CPU spinlock, which protects the
  * critical section while staying preemptible.
  */
 typedef spinlock_t local_lock_t;
 
+/*
+ * Because the compiler only knows about the base per-CPU variable, use this
+ * helper function to make the compiler think we lock/unlock the @base variable,
+ * and hide the fact we actually pass the per-CPU instance @pcpu to lock/unlock
+ * functions.
+ */
+static inline local_lock_t *__local_lock_alias(local_lock_t __percpu *base, local_lock_t *pcpu)
+	__returns_cap(base)
+{
+	return pcpu;
+}
+
 #define INIT_LOCAL_LOCK(lockname) __LOCAL_SPIN_LOCK_UNLOCKED((lockname))
 
 #define __local_lock_init(l)					\
@@ -136,7 +163,7 @@ typedef spinlock_t local_lock_t;
 #define __local_lock(__lock)					\
 	do {							\
 		migrate_disable();				\
-		spin_lock(this_cpu_ptr((__lock)));		\
+		spin_lock(__local_lock_alias(__lock, this_cpu_ptr((__lock)))); \
 	} while (0)
 
 #define __local_lock_irq(lock)			__local_lock(lock)
@@ -150,7 +177,7 @@ typedef spinlock_t local_lock_t;
 
 #define __local_unlock(__lock)					\
 	do {							\
-		spin_unlock(this_cpu_ptr((__lock)));		\
+		spin_unlock(__local_lock_alias(__lock, this_cpu_ptr((__lock)))); \
 		migrate_enable();				\
 	} while (0)
 
@@ -161,12 +188,12 @@ typedef spinlock_t local_lock_t;
 #define __local_lock_nested_bh(lock)				\
 do {								\
 	lockdep_assert_in_softirq_func();			\
-	spin_lock(this_cpu_ptr(lock));				\
+	spin_lock(__local_lock_alias(lock, this_cpu_ptr(lock))); \
 } while (0)
 
 #define __local_unlock_nested_bh(lock)				\
 do {								\
-	spin_unlock(this_cpu_ptr((lock)));			\
+	spin_unlock(__local_lock_alias(lock, this_cpu_ptr((lock)))); \
 } while (0)
 
 #endif /* CONFIG_PREEMPT_RT */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 4638d220f474..dd3fccff2352 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -6,7 +6,9 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
+#include <linux/local_lock.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rwsem.h>
 #include <linux/seqlock.h>
@@ -433,3 +435,47 @@ static void __used test_srcu_guard(struct test_srcu_data *d)
 	guard(srcu)(&d->srcu);
 	(void)srcu_dereference(d->data, &d->srcu);
 }
+
+struct test_local_lock_data {
+	local_lock_t lock;
+	int counter __var_guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_lock_data, test_local_lock_data) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static void __used test_local_lock_init(struct test_local_lock_data *d)
+{
+	local_lock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_lock(void)
+{
+	unsigned long flags;
+
+	local_lock(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock(&test_local_lock_data.lock);
+
+	local_lock_irq(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irq(&test_local_lock_data.lock);
+
+	local_lock_irqsave(&test_local_lock_data.lock, flags);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irqrestore(&test_local_lock_data.lock, flags);
+
+	local_lock_nested_bh(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_nested_bh(&test_local_lock_data.lock);
+}
+
+static void __used test_local_lock_guard(void)
+{
+	{ guard(local_lock)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irq)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irqsave)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_nested_bh)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+}
-- 
2.48.1.502.g6dc24dfdaf-goog

