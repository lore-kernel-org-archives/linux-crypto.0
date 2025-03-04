Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C281FDE2C
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080364; cv=none; b=FLOMqFROEABr2zivn2WvtstMIKV5lfPXbNkKtEzYPCobOhg/WjtVUVGQn7y816/roxtSGmI/vB3GBwL19HtRZwyRtNkg2L+tCyz12X7Hg9ym96niZvefU/Z+zWC2gBpf5xGqnFzWdL0ZOy/8X6Sapz2MTrJayX9o9YwIfeQhLzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080364; c=relaxed/simple;
	bh=5Pp0cWVWeR/iKG+6F+FtpYqvROINCcN+zxDEvkyjIk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+vHvv6MNhzfKNCg1NOIVDJS954dFAp1F/DxRQWeHd7KJCLbdol8OWbxLiefWEZAw0RSy4wG1hlhfPmtKfHfETQR+tW31W1X1jPH6TL3ROpErRQsHlGK9e7xOlMlilkSg0MpMvxRIGm1ri61XEfJft02xxmVaiihcIksNl8GLbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GarN8Gsq; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GarN8Gsq"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e4c2618332so2147145a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080360; x=1741685160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fevqVsEsX3/oCaV46XhekBmDNUcdyGVL5LKZ5XmlZNY=;
        b=GarN8GsqltPtkbPEKbezvzKXhgWxRjqr5fKz0wVsD7XdxGTdl1udQPlSiSwoQ8OTGy
         mjI2JokbrHDHdhXaPQXm9CJseJdaCioIeJwwO5FY7yeQNrNZgLS3evVf4MuwRnHIJ/lZ
         xNalbF+e1eutHezymEE1cqV8yJbmJ6U5ueVuCZVZhHzdydyYI0QZNiWxfADU7NTLxFbs
         gGWK9L8QLW5conEOhVhCUvVhBGKMmqR94LTlAymQsvX9fWxDO6/jERnzTIqtuPpCrE3t
         yZ8UIBhS7j9b97YZfNYk4g7mGlzJBEARUsZBOjCNcXe1OhyukBXXBowXRh2iDG/PreH6
         nIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080360; x=1741685160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fevqVsEsX3/oCaV46XhekBmDNUcdyGVL5LKZ5XmlZNY=;
        b=k42/CyuwlCVJh2M4HE7Qkq2rBWEZz5Iv5kx+Z1t1flP5s/FojJHiVJj4mgaVUdsLuQ
         jiq/aEQ2NmK2LemFWMtWH5EHnuJdlQBHsaltwiWFq7GwZOxfS3td5wuH49M1b4i6Vnlx
         6pYUjcTmLAfdBuQD/mC4eVD6tcJMPUMVGvsTpQYkXFk+lWXWegReMaEKTICEcUc+Kcpb
         B4eH8voHovQaujUfj2MBIskAGWtFoW73e9dEzOb+KWrNXQ+MrVAX+x3GQhYT2LuUMyXp
         2MD+4PBxY4b7gsLS7eoJ4I+QLdz+CRgFtJpVtdFrCHnqksoZOjdAspunhGlSvl8fmOxT
         belg==
X-Forwarded-Encrypted: i=1; AJvYcCWa/1kc660+HVm8AkHsmEb9pLBsli4vhIsi3HhZzcrFGJwOUzCyaMZ66s90PTG90Z01piRn+w96N4CbDvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzleeutTjKfeJtahmG9xxklfLJaLyOHgRa5oeusk/TWiEZNzxal
	fYH0cQqoWicxC3YrfeJwz2hwvhMkThzYE9eusuxSdHLdDFB96NGPdm3bxDHJ+bxBdObUv2SP5w=
	=
X-Google-Smtp-Source: AGHT+IFl5s6Iny66DH2m/TkuwyT+wpjNT0HF7LAin4sZpCAQX9J/MzXeXyXsNOCBtJkLhAkMTTKBYFaHlQ==
X-Received: from edbfe12.prod.google.com ([2002:a05:6402:390c:b0:5e0:963d:6041])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3904:b0:5e5:335:dad2
 with SMTP id 4fb4d7f45d1cf-5e50335de72mr16333101a12.26.1741080360656; Tue, 04
 Mar 2025 01:26:00 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:18 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-20-elver@google.com>
Subject: [PATCH v2 19/34] locking/local_lock: Support Clang's capability analysis
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

Add support for Clang's capability analysis for local_lock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/local_lock.h                    | 18 ++++----
 include/linux/local_lock_internal.h           | 41 ++++++++++++++---
 lib/test_capability-analysis.c                | 46 +++++++++++++++++++
 4 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 7e4d94d65043..e892a5292841 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
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
index 420866c1c70b..01830f75d9a3 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -10,12 +10,13 @@
 
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
@@ -62,6 +63,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assert_cap(lock);					\
 } while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
@@ -73,40 +75,47 @@ do {								\
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
@@ -115,19 +124,37 @@ do {								\
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
@@ -138,7 +165,7 @@ typedef spinlock_t local_lock_t;
 #define __local_lock(__lock)					\
 	do {							\
 		migrate_disable();				\
-		spin_lock(this_cpu_ptr((__lock)));		\
+		spin_lock(__local_lock_alias(__lock, this_cpu_ptr((__lock)))); \
 	} while (0)
 
 #define __local_lock_irq(lock)			__local_lock(lock)
@@ -152,7 +179,7 @@ typedef spinlock_t local_lock_t;
 
 #define __local_unlock(__lock)					\
 	do {							\
-		spin_unlock(this_cpu_ptr((__lock)));		\
+		spin_unlock(__local_lock_alias(__lock, this_cpu_ptr((__lock)))); \
 		migrate_enable();				\
 	} while (0)
 
@@ -163,12 +190,12 @@ typedef spinlock_t local_lock_t;
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
index 7ccb163ab5b1..81c8e74548a9 100644
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
-- 
2.48.1.711.g2feabab25a-goog

