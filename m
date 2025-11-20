Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6CB35CBA2
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651606; cv=none; b=fJlCiVvChSXX1EvvZNil7SdBrzY+8dlkz4nNvd609ZAo0mGYCnwGIQ2Bl5Pt4p72lXAoTE5+uKUWuaNmxgjt+AX0NjryuIUdNHQ4Yf4TG8bvZqVLpeVuBDAgN6caayAAln+QNM4KlUU6iwTOo17I0ULHDP94U7kFOEhDzowNC8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651606; c=relaxed/simple;
	bh=9bvhRKo+HJTxRUpZXzrc7S+mvWVgzulKx6ZKJrGxNck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cIbk7DnBvqd1hd1cKF24qm/aib1ng8lQbbSK4dBPRlRyjDltDZ02obYxcQDzq4bTT9T8IsI+t9cvP6lDTwbHm4y0N71cylr67IlAjKqLs45Jb3TJZeMFL7DgADOBsUkh96+aXi+NAlITOUgiNwkwyPDFnIO8fXzrgCP98p8S7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5+lR7zw; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5+lR7zw"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2f79759bso1101298f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 07:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651585; x=1764256385; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bGtcXg38DvnDW7LCtn8VPS4tEIyxPZjVcXoXmWDrgp8=;
        b=Z5+lR7zwUhUxyLh/qhkW///ESJgfjOXodMd7lGnPDVBMHyceZnPBDUdWFZ+yRUkUOw
         fOkTKnyrVFBbdZbPyN1QRblzKmEdVz/8BXSnUUrsVyxFcY7/fhJ+MoihxiRIzq9uUqld
         d1aQbhoOEo9xtVLNemm/liavKTzM2gH0PO9xYMJuC6JmtgIUWs3Ik7X4OB0TiaW4hSF9
         5gOBl/dz6j++Bsr8J5QZKQWa8BUeXlAqJ8pkN1xFRCMgPs++ixJSHLLokPmcSTCNsCG4
         LCmbMRrgGl/LZUmmrf1EKSPRem3OYmsln8NU6OtliIiJ8AZhvdYmjwbf79yheQKweGMt
         BAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651585; x=1764256385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bGtcXg38DvnDW7LCtn8VPS4tEIyxPZjVcXoXmWDrgp8=;
        b=SSbN2p6Df+j1wuX/ZU9ZJMHdxaOBLWuuhTCrjaVCCga1iJtISEiZMiMXEjZ9om3X8z
         Xsuu8qZJv+PHMRIKqWKs8d29ektxDAVaDQQGXeNWtVenpKKnOv06w7xVwRsAndf8xBKA
         RWsnaswT0Bm/bF66k7xZ/VjPrZNEDHj4QFSjFtVWkO86/Ajt7NFSmn5FYLf1zq9D63Hh
         UB/usDaX3cf3CGY8f8gpVzvW6qe0OVDny6gL/QFRqVl36s0JkxWC8AO5B9ZkN/K1CMFa
         5KENZZz+GP1HVm+pDcQtFFHMGJ7jdthr9i4fpPg9/HsLuEv6vbcy3De0+TF7NaZ2aDwF
         vP1g==
X-Forwarded-Encrypted: i=1; AJvYcCXmbbT0LQg3kDunlew+X4MuJhp6HVO8E75u8bsLJkgvmkh9V5gWB737t0iLTh80rHJqdqpMa3nrgg+hl/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEeuK1RPvkzQ6KNllf4ak59cL0YPPUOguQ2w0exfuSsygz6n/1
	rNIjcelYtDZIqHeH7iz1PGa7VzxC/mgxyIYkia3QS0kfwfy2cavL+UJom+6YjeYwadc3bGeTMq/
	new==
X-Google-Smtp-Source: AGHT+IGhcdS9pWCnclB0ZnSa2CT1VpV8SLzu+bKGMl3/AqvfyiDsJLESbsF+yAvo2bmuHOzFOvaMv3LckQ==
X-Received: from wraj7.prod.google.com ([2002:a5d:4527:0:b0:42b:2aa2:e459])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2406:b0:42b:4081:ccb8
 with SMTP id ffacd0b85a97d-42cb9a1d969mr3010427f8f.23.1763651584236; Thu, 20
 Nov 2025 07:13:04 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:44 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-20-elver@google.com>
Subject: [PATCH v4 19/35] locking/local_lock: Support Clang's context analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add support for Clang's context analysis for local_lock_t and
local_trylock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
* Rework __this_cpu_local_lock helper
* Support local_trylock_t
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/local_lock.h                   | 45 ++++++------
 include/linux/local_lock_internal.h          | 71 +++++++++++++++----
 lib/test_context-analysis.c                  | 73 ++++++++++++++++++++
 4 files changed, 156 insertions(+), 35 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index dc7ae4f641f2..8737de63a707 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 0d91d060e3e9..a83458bebe97 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -13,13 +13,13 @@
  * local_lock - Acquire a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_lock(lock)		__local_lock(this_cpu_ptr(lock))
+#define local_lock(lock)		__local_lock(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irq - Acquire a per CPU local lock and disable interrupts
  * @lock:	The lock variable
  */
-#define local_lock_irq(lock)		__local_lock_irq(this_cpu_ptr(lock))
+#define local_lock_irq(lock)		__local_lock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irqsave - Acquire a per CPU local lock, save and disable
@@ -28,19 +28,19 @@
  * @flags:	Storage for interrupt flags
  */
 #define local_lock_irqsave(lock, flags)				\
-	__local_lock_irqsave(this_cpu_ptr(lock), flags)
+	__local_lock_irqsave(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_unlock - Release a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_unlock(lock)		__local_unlock(this_cpu_ptr(lock))
+#define local_unlock(lock)		__local_unlock(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irq - Release a per CPU local lock and enable interrupts
  * @lock:	The lock variable
  */
-#define local_unlock_irq(lock)		__local_unlock_irq(this_cpu_ptr(lock))
+#define local_unlock_irq(lock)		__local_unlock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irqrestore - Release a per CPU local lock and restore
@@ -49,7 +49,7 @@
  * @flags:      Interrupt flags to restore
  */
 #define local_unlock_irqrestore(lock, flags)			\
-	__local_unlock_irqrestore(this_cpu_ptr(lock), flags)
+	__local_unlock_irqrestore(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_lock_init - Runtime initialize a lock instance
@@ -64,7 +64,7 @@
  * locking constrains it will _always_ fail to acquire the lock in NMI or
  * HARDIRQ context on PREEMPT_RT.
  */
-#define local_trylock(lock)		__local_trylock(this_cpu_ptr(lock))
+#define local_trylock(lock)		__local_trylock(__this_cpu_local_lock(lock))
 
 #define local_lock_is_locked(lock)	__local_lock_is_locked(lock)
 
@@ -79,27 +79,32 @@
  * HARDIRQ context on PREEMPT_RT.
  */
 #define local_trylock_irqsave(lock, flags)			\
-	__local_trylock_irqsave(this_cpu_ptr(lock), flags)
-
-DEFINE_GUARD(local_lock, local_lock_t __percpu*,
-	     local_lock(_T),
-	     local_unlock(_T))
-DEFINE_GUARD(local_lock_irq, local_lock_t __percpu*,
-	     local_lock_irq(_T),
-	     local_unlock_irq(_T))
+	__local_trylock_irqsave(__this_cpu_local_lock(lock), flags)
+
+DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
+		    local_lock(_T->lock),
+		    local_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu,
+		    local_lock_irq(_T->lock),
+		    local_unlock_irq(_T->lock))
 DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 		    local_lock_irqsave(_T->lock, _T->flags),
 		    local_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
 
 #define local_lock_nested_bh(_lock)				\
-	__local_lock_nested_bh(this_cpu_ptr(_lock))
+	__local_lock_nested_bh(__this_cpu_local_lock(_lock))
 
 #define local_unlock_nested_bh(_lock)				\
-	__local_unlock_nested_bh(this_cpu_ptr(_lock))
+	__local_unlock_nested_bh(__this_cpu_local_lock(_lock))
 
-DEFINE_GUARD(local_lock_nested_bh, local_lock_t __percpu*,
-	     local_lock_nested_bh(_T),
-	     local_unlock_nested_bh(_T))
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+		    local_lock_nested_bh(_T->lock),
+		    local_unlock_nested_bh(_T->lock))
+
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irq, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irqsave, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, __assumes_ctx_guard(_T), /* */)
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 9f6cb32f04b0..17b8135bd2c3 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -10,21 +10,23 @@
 
 #ifndef CONFIG_PREEMPT_RT
 
-typedef struct {
+context_guard_struct(local_lock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
-} local_lock_t;
+};
+typedef struct local_lock local_lock_t;
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
-typedef struct {
+context_guard_struct(local_trylock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
 	u8		acquired;
-} local_trylock_t;
+};
+typedef struct local_trylock local_trylock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define LOCAL_LOCK_DEBUG_INIT(lockname)		\
@@ -84,9 +86,14 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_guard(lock);				\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
+#define __local_trylock_init(lock)				\
+do {								\
+	__local_lock_init((local_lock_t *)lock);		\
+	__assume_ctx_guard(lock);				\
+} while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\
@@ -97,6 +104,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_guard(lock);				\
 } while (0)
 
 #define __local_lock_acquire(lock)					\
@@ -119,22 +127,25 @@ do {								\
 	do {							\
 		preempt_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irq(lock)					\
 	do {							\
 		local_irq_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irqsave(lock, flags)			\
 	do {							\
 		local_irq_save(flags);				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_ctx_guard(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		preempt_disable();				\
@@ -148,10 +159,10 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_guard(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		local_irq_save(flags);				\
@@ -165,7 +176,7 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 /* preemption or migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(lock) READ_ONCE(this_cpu_ptr(lock)->acquired)
@@ -188,18 +199,21 @@ do {								\
 
 #define __local_unlock(lock)					\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		preempt_enable();				\
 	} while (0)
 
 #define __local_unlock_irq(lock)				\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_enable();				\
 	} while (0)
 
 #define __local_unlock_irqrestore(lock, flags)			\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_restore(flags);			\
 	} while (0)
@@ -208,13 +222,19 @@ do {								\
 	do {							\
 		lockdep_assert_in_softirq();			\
 		local_lock_acquire((lock));			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_unlock_nested_bh(lock)				\
-	local_lock_release((lock))
+	do {							\
+		__release(lock);				\
+		local_lock_release((lock));			\
+	} while (0)
 
 #else /* !CONFIG_PREEMPT_RT */
 
+#include <linux/spinlock.h>
+
 /*
  * On PREEMPT_RT local_lock maps to a per CPU spinlock, which protects the
  * critical section while staying preemptible.
@@ -269,7 +289,7 @@ do {								\
 } while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_ctx_guard(lock, context_unsafe(({		\
 		int __locked;					\
 								\
 		if (in_nmi() | in_hardirq()) {			\
@@ -281,17 +301,40 @@ do {								\
 				migrate_enable();		\
 		}						\
 		__locked;					\
-	})
+	})))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_guard(lock, ({			\
 		typecheck(unsigned long, flags);		\
 		flags = 0;					\
 		__local_trylock(lock);				\
-	})
+	}))
 
 /* migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(__lock)					\
 	(rt_mutex_owner(&this_cpu_ptr(__lock)->lock) == current)
 
 #endif /* CONFIG_PREEMPT_RT */
+
+#if defined(WARN_CONTEXT_ANALYSIS)
+/*
+ * Because the compiler only knows about the base per-CPU variable, use this
+ * helper function to make the compiler think we lock/unlock the @base variable,
+ * and hide the fact we actually pass the per-CPU instance to lock/unlock
+ * functions.
+ */
+static __always_inline local_lock_t *__this_cpu_local_lock(local_lock_t __percpu *base)
+	__returns_ctx_guard(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#ifndef CONFIG_PREEMPT_RT
+static __always_inline local_trylock_t *__this_cpu_local_lock(local_trylock_t __percpu *base)
+	__returns_ctx_guard(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#endif /* CONFIG_PREEMPT_RT */
+#else  /* WARN_CONTEXT_ANALYSIS */
+#define __this_cpu_local_lock(base) this_cpu_ptr(base)
+#endif /* WARN_CONTEXT_ANALYSIS */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 2203a57cd40d..74eca21f7aaa 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -6,7 +6,9 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
+#include <linux/local_lock.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rwsem.h>
 #include <linux/seqlock.h>
@@ -450,3 +452,74 @@ static void __used test_srcu_guard(struct test_srcu_data *d)
 	guard(srcu)(&d->srcu);
 	(void)srcu_dereference(d->data, &d->srcu);
 }
+
+struct test_local_lock_data {
+	local_lock_t lock;
+	int counter __guarded_by(&lock);
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
+
+struct test_local_trylock_data {
+	local_trylock_t lock;
+	int counter __guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_trylock_data, test_local_trylock_data) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+};
+
+static void __used test_local_trylock_init(struct test_local_trylock_data *d)
+{
+	local_trylock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_trylock(void)
+{
+	local_lock(&test_local_trylock_data.lock);
+	this_cpu_add(test_local_trylock_data.counter, 1);
+	local_unlock(&test_local_trylock_data.lock);
+
+	if (local_trylock(&test_local_trylock_data.lock)) {
+		this_cpu_add(test_local_trylock_data.counter, 1);
+		local_unlock(&test_local_trylock_data.lock);
+	}
+}
-- 
2.52.0.rc1.455.g30608eb744-goog

