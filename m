Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEA723957D
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865894; cv=none; b=UsOjK+UeULbNIWeYbkjCkbNiDG1d+v504LaP+8s82Ml5dbMBz8uHR12181iBoBCGSQulEx7H9v7x76m8+4bXYBhKhlFZSlydcZdpdF5BAxugxP89f7eMzLQY3S8oUqT6eR81Oix0roO5QIyzfLf0cBIC2h+gr82kjBSkcsh5o9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865894; c=relaxed/simple;
	bh=gVcJwP7DaHofrIRS7DtPO8XOt5Qq6uoCKcfH8A5mJms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hbwmJ6wixIl9nfBG9tLxwpGHa/LOTzfHqOSlBE7uwbRFpl8AfTgf13Ng4Auh64Rotx8CeZm4xdoCpukMDLbKH6xtz50GTDZMeKvTgeIvNPPfGCA+fCBz1cF2DKrBL51c1E1lTYYRzMNgc4ofhDzlrbQI2E+lLRGKA2+g9Wz8tnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TM5qe8JC; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TM5qe8JC"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d90b88322aso1437206a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865888; x=1739470688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ooxnk/JQzY6kVJXM0+XJ/prw2lUk2BfGet6u4s4YFKY=;
        b=TM5qe8JCxvngk/Xf9n2ocZ9VmuWIHAglxQU+gttFoEd9CeNy7FoJ7y/1DtAEUOVp5C
         PenvK8mGhFY5wN4uWryfeEUNCAkInQjPynmLIigiRsXqO308JqQHw3qKKm5HyBr/emDS
         S7LL4Q1XolUEhQwPdF85IxiVWjabXhKLeGY34O2JRvFLjUVqDMrzd4gXQcQx4/Puafba
         905i5iPEzGlyZ5o5181EImyR667cRJk2BfZ4RR6a0GLZJ4nghnZHNJGx4YTIiLS75p24
         RhK1ehsDHGvV0Dvx3qgNLQSY7Ws1VWsp4Iq0UqkfdjRPa8LodTWkTMxfVAdCcHcepP36
         ptnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865888; x=1739470688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooxnk/JQzY6kVJXM0+XJ/prw2lUk2BfGet6u4s4YFKY=;
        b=LDMOHhdVagWZRk2NYWDLxpkDWKOL7ac3uCppQu/CG6SsDiqYqFKFxsGh4cMsUFa9Y7
         4DnzA9wLla+Se+JdeQcA2ayeqNEhKqt1ZRe6DQXqd7UC+E3lMLDsNRJd1KQB1hR7SYhQ
         uMmEY2LkaL3oT8Lx/ZAD/2o9/foo6qEkz6mk/HskylaSPgNYtnsZh+GDAA0LF+CxuzUA
         NLOU9yBxIC46cOgPvpmC8RGDNk9qpVVOr3YbiheL3rUpYimLEYGQSgApMiqziQwshKSH
         HCY2sOp0XxJS35Fkbm2jpI0hommazshPlbwauLwN89T9zhQyzw2VSPCWMrWghSaQRuzt
         VOqw==
X-Forwarded-Encrypted: i=1; AJvYcCUgDb+Urarmw+MvtmbEYMHW5SnwUa8NFRqYWBjfeHldOx6cGlC0vXkpVcmCVklrgvx3Cd/4d7ACSySXYGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHbXUB/FRRSYMxzHOqLqDX/A0pRX6/g69hLI5IGBZAXbMkv9u
	XFPKzM85g/f73SXhpQVtAobm4xz+nZYV+8JZstbdNtK6uQ98qz/qncwVDUW0Nqhq5a7v3gYJUQ=
	=
X-Google-Smtp-Source: AGHT+IFm7el1MNhepx8reHTJ4p1sUzV5FhX1LdLPWyerUR85KR1MkFSqrbz9hShMncx2dK3vsIt3v94VSw==
X-Received: from edben19.prod.google.com ([2002:a05:6402:5293:b0:5dc:1039:c937])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a50:d582:0:b0:5dc:c9ce:b029
 with SMTP id 4fb4d7f45d1cf-5de44fe9d66mr457639a12.5.1738865888539; Thu, 06
 Feb 2025 10:18:08 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:03 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-10-elver@google.com>
Subject: [PATCH RFC 09/24] locking/rwlock, spinlock: Support Clang's
 capability analysis
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

Add support for Clang's capability analysis for raw_spinlock_t,
spinlock_t, and rwlock. This wholesale conversion is required because
all three of them are interdependent.

To avoid warnings in constructors, the initialization functions mark a
capability as acquired when initialized before guarded variables.

The test verifies that common patterns do not generate false positives.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |   3 +-
 include/linux/rwlock.h                        |  25 ++--
 include/linux/rwlock_api_smp.h                |  29 +++-
 include/linux/rwlock_rt.h                     |  35 +++--
 include/linux/rwlock_types.h                  |  10 +-
 include/linux/spinlock.h                      |  45 +++---
 include/linux/spinlock_api_smp.h              |  14 +-
 include/linux/spinlock_api_up.h               |  71 +++++-----
 include/linux/spinlock_rt.h                   |  21 +--
 include/linux/spinlock_types.h                |  10 +-
 include/linux/spinlock_types_raw.h            |   5 +-
 lib/test_capability-analysis.c                | 128 ++++++++++++++++++
 12 files changed, 299 insertions(+), 97 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 2211af90e01b..904448605a77 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -84,7 +84,8 @@ More details are also documented `here
 Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-.. Currently the following synchronization primitives are supported:
+Currently the following synchronization primitives are supported:
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 58c346947aa2..44755fd96c27 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -22,23 +22,24 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__rwlock_init((lock), #lock, &__key);			\
+	__assert_cap(lock);					\
 } while (0)
 #else
 # define rwlock_init(lock)					\
-	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
+	do { *(lock) = __RW_LOCK_UNLOCKED(lock); __assert_cap(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
+ extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
  extern int do_raw_read_trylock(rwlock_t *lock);
- extern void do_raw_read_unlock(rwlock_t *lock) __releases(lock);
+ extern void do_raw_read_unlock(rwlock_t *lock) __releases_shared(lock);
  extern void do_raw_write_lock(rwlock_t *lock) __acquires(lock);
  extern int do_raw_write_trylock(rwlock_t *lock);
  extern void do_raw_write_unlock(rwlock_t *lock) __releases(lock);
 #else
-# define do_raw_read_lock(rwlock)	do {__acquire(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
+# define do_raw_read_lock(rwlock)	do {__acquire_shared(lock); arch_read_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
-# define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
+# define do_raw_read_unlock(rwlock)	do {arch_read_unlock(&(rwlock)->raw_lock); __release_shared(lock); } while (0)
 # define do_raw_write_lock(rwlock)	do {__acquire(lock); arch_write_lock(&(rwlock)->raw_lock); } while (0)
 # define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
 # define do_raw_write_unlock(rwlock)	do {arch_write_unlock(&(rwlock)->raw_lock); __release(lock); } while (0)
@@ -49,7 +50,7 @@ do {								\
  * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
  * methods are defined as nops in the case they are not required.
  */
-#define read_trylock(lock)	__cond_acquire(lock, _raw_read_trylock(lock))
+#define read_trylock(lock)	__cond_acquire_shared(lock, _raw_read_trylock(lock))
 #define write_trylock(lock)	__cond_acquire(lock, _raw_write_trylock(lock))
 
 #define write_lock(lock)	_raw_write_lock(lock)
@@ -112,12 +113,12 @@ do {								\
 	} while (0)
 #define write_unlock_bh(lock)		_raw_write_unlock_bh(lock)
 
-#define write_trylock_irqsave(lock, flags) \
-({ \
-	local_irq_save(flags); \
-	write_trylock(lock) ? \
-	1 : ({ local_irq_restore(flags); 0; }); \
-})
+#define write_trylock_irqsave(lock, flags)		\
+	__cond_acquire(lock, ({				\
+		local_irq_save(flags);			\
+		_raw_write_trylock(lock) ?		\
+		1 : ({ local_irq_restore(flags); 0; });	\
+	}))
 
 #ifdef arch_rwlock_is_contended
 #define rwlock_is_contended(lock) \
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 31d3d1116323..3e975105a606 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -15,12 +15,12 @@
  * Released under the General Public License (GPL).
  */
 
-void __lockfunc _raw_read_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_read_lock(rwlock_t *lock)		__acquires_shared(lock);
 void __lockfunc _raw_write_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_write_lock_nested(rwlock_t *lock, int subclass)	__acquires(lock);
-void __lockfunc _raw_read_lock_bh(rwlock_t *lock)	__acquires(lock);
+void __lockfunc _raw_read_lock_bh(rwlock_t *lock)	__acquires_shared(lock);
 void __lockfunc _raw_write_lock_bh(rwlock_t *lock)	__acquires(lock);
-void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires(lock);
+void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires_shared(lock);
 void __lockfunc _raw_write_lock_irq(rwlock_t *lock)	__acquires(lock);
 unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
@@ -28,11 +28,11 @@ unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
 int __lockfunc _raw_read_trylock(rwlock_t *lock);
 int __lockfunc _raw_write_trylock(rwlock_t *lock);
-void __lockfunc _raw_read_unlock(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_read_unlock(rwlock_t *lock)	__releases_shared(lock);
 void __lockfunc _raw_write_unlock(rwlock_t *lock)	__releases(lock);
-void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)	__releases_shared(lock);
 void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)	__releases(lock);
-void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)	__releases_shared(lock);
 void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)	__releases(lock);
 void __lockfunc
 _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
@@ -145,6 +145,7 @@ static inline int __raw_write_trylock(rwlock_t *lock)
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
 static inline void __raw_read_lock(rwlock_t *lock)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
@@ -152,6 +153,7 @@ static inline void __raw_read_lock(rwlock_t *lock)
 }
 
 static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -163,6 +165,7 @@ static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
 }
 
 static inline void __raw_read_lock_irq(rwlock_t *lock)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	local_irq_disable();
 	preempt_disable();
@@ -171,6 +174,7 @@ static inline void __raw_read_lock_irq(rwlock_t *lock)
 }
 
 static inline void __raw_read_lock_bh(rwlock_t *lock)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
@@ -178,6 +182,7 @@ static inline void __raw_read_lock_bh(rwlock_t *lock)
 }
 
 static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -189,6 +194,7 @@ static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
 }
 
 static inline void __raw_write_lock_irq(rwlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	local_irq_disable();
 	preempt_disable();
@@ -197,6 +203,7 @@ static inline void __raw_write_lock_irq(rwlock_t *lock)
 }
 
 static inline void __raw_write_lock_bh(rwlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -204,6 +211,7 @@ static inline void __raw_write_lock_bh(rwlock_t *lock)
 }
 
 static inline void __raw_write_lock(rwlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -211,6 +219,7 @@ static inline void __raw_write_lock(rwlock_t *lock)
 }
 
 static inline void __raw_write_lock_nested(rwlock_t *lock, int subclass)
+	__acquires(lock) __no_capability_analysis
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
@@ -220,6 +229,7 @@ static inline void __raw_write_lock_nested(rwlock_t *lock, int subclass)
 #endif /* !CONFIG_GENERIC_LOCKBREAK || CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline void __raw_write_unlock(rwlock_t *lock)
+	__releases(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_write_unlock(lock);
@@ -227,6 +237,7 @@ static inline void __raw_write_unlock(rwlock_t *lock)
 }
 
 static inline void __raw_read_unlock(rwlock_t *lock)
+	__releases_shared(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -235,6 +246,7 @@ static inline void __raw_read_unlock(rwlock_t *lock)
 
 static inline void
 __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+	__releases_shared(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -243,6 +255,7 @@ __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 }
 
 static inline void __raw_read_unlock_irq(rwlock_t *lock)
+	__releases_shared(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -251,6 +264,7 @@ static inline void __raw_read_unlock_irq(rwlock_t *lock)
 }
 
 static inline void __raw_read_unlock_bh(rwlock_t *lock)
+	__releases_shared(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -259,6 +273,7 @@ static inline void __raw_read_unlock_bh(rwlock_t *lock)
 
 static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 					     unsigned long flags)
+	__releases(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_write_unlock(lock);
@@ -267,6 +282,7 @@ static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 }
 
 static inline void __raw_write_unlock_irq(rwlock_t *lock)
+	__releases(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_write_unlock(lock);
@@ -275,6 +291,7 @@ static inline void __raw_write_unlock_irq(rwlock_t *lock)
 }
 
 static inline void __raw_write_unlock_bh(rwlock_t *lock)
+	__releases(lock)
 {
 	rwlock_release(&lock->dep_map, _RET_IP_);
 	do_raw_write_unlock(lock);
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 5320b4b66405..c6280b0e4503 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -22,28 +22,32 @@ do {							\
 							\
 	init_rwbase_rt(&(rwl)->rwbase);			\
 	__rt_rwlock_init(rwl, #rwl, &__key);		\
+	__assert_cap(rwl);				\
 } while (0)
 
-extern void rt_read_lock(rwlock_t *rwlock)	__acquires(rwlock);
+extern void rt_read_lock(rwlock_t *rwlock)	__acquires_shared(rwlock);
 extern int rt_read_trylock(rwlock_t *rwlock);
-extern void rt_read_unlock(rwlock_t *rwlock)	__releases(rwlock);
+extern void rt_read_unlock(rwlock_t *rwlock)	__releases_shared(rwlock);
 extern void rt_write_lock(rwlock_t *rwlock)	__acquires(rwlock);
 extern void rt_write_lock_nested(rwlock_t *rwlock, int subclass)	__acquires(rwlock);
 extern int rt_write_trylock(rwlock_t *rwlock);
 extern void rt_write_unlock(rwlock_t *rwlock)	__releases(rwlock);
 
 static __always_inline void read_lock(rwlock_t *rwlock)
+	__acquires_shared(rwlock)
 {
 	rt_read_lock(rwlock);
 }
 
 static __always_inline void read_lock_bh(rwlock_t *rwlock)
+	__acquires_shared(rwlock)
 {
 	local_bh_disable();
 	rt_read_lock(rwlock);
 }
 
 static __always_inline void read_lock_irq(rwlock_t *rwlock)
+	__acquires_shared(rwlock)
 {
 	rt_read_lock(rwlock);
 }
@@ -55,37 +59,43 @@ static __always_inline void read_lock_irq(rwlock_t *rwlock)
 		flags = 0;				\
 	} while (0)
 
-#define read_trylock(lock)	__cond_acquire(lock, rt_read_trylock(lock))
+#define read_trylock(lock)	__cond_acquire_shared(lock, rt_read_trylock(lock))
 
 static __always_inline void read_unlock(rwlock_t *rwlock)
+	__releases_shared(rwlock)
 {
 	rt_read_unlock(rwlock);
 }
 
 static __always_inline void read_unlock_bh(rwlock_t *rwlock)
+	__releases_shared(rwlock)
 {
 	rt_read_unlock(rwlock);
 	local_bh_enable();
 }
 
 static __always_inline void read_unlock_irq(rwlock_t *rwlock)
+	__releases_shared(rwlock)
 {
 	rt_read_unlock(rwlock);
 }
 
 static __always_inline void read_unlock_irqrestore(rwlock_t *rwlock,
 						   unsigned long flags)
+	__releases_shared(rwlock)
 {
 	rt_read_unlock(rwlock);
 }
 
 static __always_inline void write_lock(rwlock_t *rwlock)
+	__acquires(rwlock)
 {
 	rt_write_lock(rwlock);
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static __always_inline void write_lock_nested(rwlock_t *rwlock, int subclass)
+	__acquires(rwlock)
 {
 	rt_write_lock_nested(rwlock, subclass);
 }
@@ -94,12 +104,14 @@ static __always_inline void write_lock_nested(rwlock_t *rwlock, int subclass)
 #endif
 
 static __always_inline void write_lock_bh(rwlock_t *rwlock)
+	__acquires(rwlock)
 {
 	local_bh_disable();
 	rt_write_lock(rwlock);
 }
 
 static __always_inline void write_lock_irq(rwlock_t *rwlock)
+	__acquires(rwlock)
 {
 	rt_write_lock(rwlock);
 }
@@ -114,33 +126,34 @@ static __always_inline void write_lock_irq(rwlock_t *rwlock)
 #define write_trylock(lock)	__cond_acquire(lock, rt_write_trylock(lock))
 
 #define write_trylock_irqsave(lock, flags)		\
-({							\
-	int __locked;					\
-							\
-	typecheck(unsigned long, flags);		\
-	flags = 0;					\
-	__locked = write_trylock(lock);			\
-	__locked;					\
-})
+	__cond_acquire(lock, ({				\
+		typecheck(unsigned long, flags);	\
+		flags = 0;				\
+		rt_write_trylock(lock);			\
+	}))
 
 static __always_inline void write_unlock(rwlock_t *rwlock)
+	__releases(rwlock)
 {
 	rt_write_unlock(rwlock);
 }
 
 static __always_inline void write_unlock_bh(rwlock_t *rwlock)
+	__releases(rwlock)
 {
 	rt_write_unlock(rwlock);
 	local_bh_enable();
 }
 
 static __always_inline void write_unlock_irq(rwlock_t *rwlock)
+	__releases(rwlock)
 {
 	rt_write_unlock(rwlock);
 }
 
 static __always_inline void write_unlock_irqrestore(rwlock_t *rwlock,
 						    unsigned long flags)
+	__releases(rwlock)
 {
 	rt_write_unlock(rwlock);
 }
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index 1948442e7750..231489cc30f2 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -22,7 +22,7 @@
  * portions Copyright 2005, Red Hat, Inc., Ingo Molnar
  * Released under the General Public License (GPL).
  */
-typedef struct {
+struct_with_capability(rwlock) {
 	arch_rwlock_t raw_lock;
 #ifdef CONFIG_DEBUG_SPINLOCK
 	unsigned int magic, owner_cpu;
@@ -31,7 +31,8 @@ typedef struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
-} rwlock_t;
+};
+typedef struct rwlock rwlock_t;
 
 #define RWLOCK_MAGIC		0xdeaf1eed
 
@@ -54,13 +55,14 @@ typedef struct {
 
 #include <linux/rwbase_rt.h>
 
-typedef struct {
+struct_with_capability(rwlock) {
 	struct rwbase_rt	rwbase;
 	atomic_t		readers;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-} rwlock_t;
+};
+typedef struct rwlock rwlock_t;
 
 #define __RWLOCK_RT_INITIALIZER(name)					\
 {									\
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 678e6f0679a1..1646a9920fd7 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -106,11 +106,12 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__raw_spin_lock_init((lock), #lock, &__key, LD_WAIT_SPIN);	\
+	__assert_cap(lock);						\
 } while (0)
 
 #else
 # define raw_spin_lock_init(lock)				\
-	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); } while (0)
+	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); __assert_cap(lock); } while (0)
 #endif
 
 #define raw_spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
@@ -286,19 +287,19 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 #define raw_spin_trylock_bh(lock) \
 	__cond_acquire(lock, _raw_spin_trylock_bh(lock))
 
-#define raw_spin_trylock_irq(lock) \
-({ \
-	local_irq_disable(); \
-	raw_spin_trylock(lock) ? \
-	1 : ({ local_irq_enable(); 0;  }); \
-})
+#define raw_spin_trylock_irq(lock)			\
+	__cond_acquire(lock, ({				\
+		local_irq_disable();			\
+		_raw_spin_trylock(lock) ?		\
+		1 : ({ local_irq_enable(); 0;  });	\
+	}))
 
-#define raw_spin_trylock_irqsave(lock, flags) \
-({ \
-	local_irq_save(flags); \
-	raw_spin_trylock(lock) ? \
-	1 : ({ local_irq_restore(flags); 0; }); \
-})
+#define raw_spin_trylock_irqsave(lock, flags)		\
+	__cond_acquire(lock, ({				\
+		local_irq_save(flags);			\
+		_raw_spin_trylock(lock) ?		\
+		1 : ({ local_irq_restore(flags); 0; }); \
+	}))
 
 #ifndef CONFIG_PREEMPT_RT
 /* Include rwlock functions for !RT */
@@ -334,6 +335,7 @@ do {								\
 								\
 	__raw_spin_lock_init(spinlock_check(lock),		\
 			     #lock, &__key, LD_WAIT_CONFIG);	\
+	__assert_cap(lock);					\
 } while (0)
 
 #else
@@ -342,21 +344,25 @@ do {								\
 do {						\
 	spinlock_check(_lock);			\
 	*(_lock) = __SPIN_LOCK_UNLOCKED(_lock);	\
+	__assert_cap(_lock);			\
 } while (0)
 
 #endif
 
 static __always_inline void spin_lock(spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	raw_spin_lock(&lock->rlock);
 }
 
 static __always_inline void spin_lock_bh(spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	raw_spin_lock_bh(&lock->rlock);
 }
 
 static __always_inline int spin_trylock(spinlock_t *lock)
+	__cond_acquires(lock) __no_capability_analysis
 {
 	return raw_spin_trylock(&lock->rlock);
 }
@@ -372,6 +378,7 @@ do {									\
 } while (0)
 
 static __always_inline void spin_lock_irq(spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	raw_spin_lock_irq(&lock->rlock);
 }
@@ -379,47 +386,53 @@ static __always_inline void spin_lock_irq(spinlock_t *lock)
 #define spin_lock_irqsave(lock, flags)				\
 do {								\
 	raw_spin_lock_irqsave(spinlock_check(lock), flags);	\
+	__release(spinlock_check(lock)); __acquire(lock);	\
 } while (0)
 
 #define spin_lock_irqsave_nested(lock, flags, subclass)			\
 do {									\
 	raw_spin_lock_irqsave_nested(spinlock_check(lock), flags, subclass); \
+	__release(spinlock_check(lock)); __acquire(lock);		\
 } while (0)
 
 static __always_inline void spin_unlock(spinlock_t *lock)
+	__releases(lock) __no_capability_analysis
 {
 	raw_spin_unlock(&lock->rlock);
 }
 
 static __always_inline void spin_unlock_bh(spinlock_t *lock)
+	__releases(lock) __no_capability_analysis
 {
 	raw_spin_unlock_bh(&lock->rlock);
 }
 
 static __always_inline void spin_unlock_irq(spinlock_t *lock)
+	__releases(lock) __no_capability_analysis
 {
 	raw_spin_unlock_irq(&lock->rlock);
 }
 
 static __always_inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+	__releases(lock) __no_capability_analysis
 {
 	raw_spin_unlock_irqrestore(&lock->rlock, flags);
 }
 
 static __always_inline int spin_trylock_bh(spinlock_t *lock)
+	__cond_acquires(lock) __no_capability_analysis
 {
 	return raw_spin_trylock_bh(&lock->rlock);
 }
 
 static __always_inline int spin_trylock_irq(spinlock_t *lock)
+	__cond_acquires(lock) __no_capability_analysis
 {
 	return raw_spin_trylock_irq(&lock->rlock);
 }
 
 #define spin_trylock_irqsave(lock, flags)			\
-({								\
-	raw_spin_trylock_irqsave(spinlock_check(lock), flags); \
-})
+	__cond_acquire(lock, raw_spin_trylock_irqsave(spinlock_check(lock), flags))
 
 /**
  * spin_is_locked() - Check whether a spinlock is locked.
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 9ecb0ab504e3..fab02d8bf0c9 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -34,8 +34,8 @@ unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
 unsigned long __lockfunc
 _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
 								__acquires(lock);
-int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock);
-int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock);
+int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)		__cond_acquires(lock);
+int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)	__cond_acquires(lock);
 void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)		__releases(lock);
 void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
@@ -84,6 +84,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+	__cond_acquires(lock)
 {
 	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
@@ -102,6 +103,7 @@ static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
 static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -113,6 +115,7 @@ static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
 }
 
 static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	local_irq_disable();
 	preempt_disable();
@@ -121,6 +124,7 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 }
 
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -128,6 +132,7 @@ static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
+	__acquires(lock) __no_capability_analysis
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -137,6 +142,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 #endif /* !CONFIG_GENERIC_LOCKBREAK || CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+	__releases(lock)
 {
 	spin_release(&lock->dep_map, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -145,6 +151,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 
 static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
+	__releases(lock)
 {
 	spin_release(&lock->dep_map, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -153,6 +160,7 @@ static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 }
 
 static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
+	__releases(lock)
 {
 	spin_release(&lock->dep_map, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -161,6 +169,7 @@ static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 }
 
 static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
+	__releases(lock)
 {
 	spin_release(&lock->dep_map, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -168,6 +177,7 @@ static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 }
 
 static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
+	__cond_acquires(lock)
 {
 	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
 	if (do_raw_spin_trylock(lock)) {
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index 819aeba1c87e..018f5aabc1be 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -24,68 +24,77 @@
  * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
-#define ___LOCK(lock) \
-  do { __acquire(lock); (void)(lock); } while (0)
+#define ___LOCK_void(lock) \
+  do { (void)(lock); } while (0)
 
-#define __LOCK(lock) \
-  do { preempt_disable(); ___LOCK(lock); } while (0)
+#define ___LOCK_(lock) \
+  do { __acquire(lock); ___LOCK_void(lock); } while (0)
 
-#define __LOCK_BH(lock) \
-  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK(lock); } while (0)
+#define ___LOCK_shared(lock) \
+  do { __acquire_shared(lock); ___LOCK_void(lock); } while (0)
 
-#define __LOCK_IRQ(lock) \
-  do { local_irq_disable(); __LOCK(lock); } while (0)
+#define __LOCK(lock, ...) \
+  do { preempt_disable(); ___LOCK_##__VA_ARGS__(lock); } while (0)
 
-#define __LOCK_IRQSAVE(lock, flags) \
-  do { local_irq_save(flags); __LOCK(lock); } while (0)
+#define __LOCK_BH(lock, ...) \
+  do { __local_bh_disable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); ___LOCK_##__VA_ARGS__(lock); } while (0)
 
-#define ___UNLOCK(lock) \
+#define __LOCK_IRQ(lock, ...) \
+  do { local_irq_disable(); __LOCK(lock, ##__VA_ARGS__); } while (0)
+
+#define __LOCK_IRQSAVE(lock, flags, ...) \
+  do { local_irq_save(flags); __LOCK(lock, ##__VA_ARGS__); } while (0)
+
+#define ___UNLOCK_(lock) \
   do { __release(lock); (void)(lock); } while (0)
 
-#define __UNLOCK(lock) \
-  do { preempt_enable(); ___UNLOCK(lock); } while (0)
+#define ___UNLOCK_shared(lock) \
+  do { __release_shared(lock); (void)(lock); } while (0)
 
-#define __UNLOCK_BH(lock) \
+#define __UNLOCK(lock, ...) \
+  do { preempt_enable(); ___UNLOCK_##__VA_ARGS__(lock); } while (0)
+
+#define __UNLOCK_BH(lock, ...) \
   do { __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_LOCK_OFFSET); \
-       ___UNLOCK(lock); } while (0)
+       ___UNLOCK_##__VA_ARGS__(lock); } while (0)
 
-#define __UNLOCK_IRQ(lock) \
-  do { local_irq_enable(); __UNLOCK(lock); } while (0)
+#define __UNLOCK_IRQ(lock, ...) \
+  do { local_irq_enable(); __UNLOCK(lock, ##__VA_ARGS__); } while (0)
 
-#define __UNLOCK_IRQRESTORE(lock, flags) \
-  do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
+#define __UNLOCK_IRQRESTORE(lock, flags, ...) \
+  do { local_irq_restore(flags); __UNLOCK(lock, ##__VA_ARGS__); } while (0)
 
 #define _raw_spin_lock(lock)			__LOCK(lock)
 #define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
-#define _raw_read_lock(lock)			__LOCK(lock)
+#define _raw_read_lock(lock)			__LOCK(lock, shared)
 #define _raw_write_lock(lock)			__LOCK(lock)
 #define _raw_write_lock_nested(lock, subclass)	__LOCK(lock)
 #define _raw_spin_lock_bh(lock)			__LOCK_BH(lock)
-#define _raw_read_lock_bh(lock)			__LOCK_BH(lock)
+#define _raw_read_lock_bh(lock)			__LOCK_BH(lock, shared)
 #define _raw_write_lock_bh(lock)		__LOCK_BH(lock)
 #define _raw_spin_lock_irq(lock)		__LOCK_IRQ(lock)
-#define _raw_read_lock_irq(lock)		__LOCK_IRQ(lock)
+#define _raw_read_lock_irq(lock)		__LOCK_IRQ(lock, shared)
 #define _raw_write_lock_irq(lock)		__LOCK_IRQ(lock)
 #define _raw_spin_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _raw_read_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
+#define _raw_read_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags, shared)
 #define _raw_write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _raw_spin_trylock(lock)			({ __LOCK(lock); 1; })
-#define _raw_read_trylock(lock)			({ __LOCK(lock); 1; })
-#define _raw_write_trylock(lock)			({ __LOCK(lock); 1; })
-#define _raw_spin_trylock_bh(lock)		({ __LOCK_BH(lock); 1; })
+#define _raw_spin_trylock(lock)			({ __LOCK(lock, void); 1; })
+#define _raw_read_trylock(lock)			({ __LOCK(lock, void); 1; })
+#define _raw_write_trylock(lock)			({ __LOCK(lock, void); 1; })
+#define _raw_spin_trylock_bh(lock)		({ __LOCK_BH(lock, void); 1; })
 #define _raw_spin_unlock(lock)			__UNLOCK(lock)
-#define _raw_read_unlock(lock)			__UNLOCK(lock)
+#define _raw_read_unlock(lock)			__UNLOCK(lock, shared)
 #define _raw_write_unlock(lock)			__UNLOCK(lock)
 #define _raw_spin_unlock_bh(lock)		__UNLOCK_BH(lock)
 #define _raw_write_unlock_bh(lock)		__UNLOCK_BH(lock)
-#define _raw_read_unlock_bh(lock)		__UNLOCK_BH(lock)
+#define _raw_read_unlock_bh(lock)		__UNLOCK_BH(lock, shared)
 #define _raw_spin_unlock_irq(lock)		__UNLOCK_IRQ(lock)
-#define _raw_read_unlock_irq(lock)		__UNLOCK_IRQ(lock)
+#define _raw_read_unlock_irq(lock)		__UNLOCK_IRQ(lock, shared)
 #define _raw_write_unlock_irq(lock)		__UNLOCK_IRQ(lock)
 #define _raw_spin_unlock_irqrestore(lock, flags) \
 					__UNLOCK_IRQRESTORE(lock, flags)
 #define _raw_read_unlock_irqrestore(lock, flags) \
-					__UNLOCK_IRQRESTORE(lock, flags)
+					__UNLOCK_IRQRESTORE(lock, flags, shared)
 #define _raw_write_unlock_irqrestore(lock, flags) \
 					__UNLOCK_IRQRESTORE(lock, flags)
 
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index eaad4dd2baac..5d9ebc3ec521 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -20,6 +20,7 @@ static inline void __rt_spin_lock_init(spinlock_t *lock, const char *name,
 do {								\
 	rt_mutex_base_init(&(slock)->lock);			\
 	__rt_spin_lock_init(slock, name, key, percpu);		\
+	__assert_cap(slock);					\
 } while (0)
 
 #define _spin_lock_init(slock, percpu)				\
@@ -40,6 +41,7 @@ extern int rt_spin_trylock_bh(spinlock_t *lock);
 extern int rt_spin_trylock(spinlock_t *lock);
 
 static __always_inline void spin_lock(spinlock_t *lock)
+	__acquires(lock)
 {
 	rt_spin_lock(lock);
 }
@@ -82,6 +84,7 @@ static __always_inline void spin_lock(spinlock_t *lock)
 	__spin_lock_irqsave_nested(lock, flags, subclass)
 
 static __always_inline void spin_lock_bh(spinlock_t *lock)
+	__acquires(lock)
 {
 	/* Investigate: Drop bh when blocking ? */
 	local_bh_disable();
@@ -89,6 +92,7 @@ static __always_inline void spin_lock_bh(spinlock_t *lock)
 }
 
 static __always_inline void spin_lock_irq(spinlock_t *lock)
+	__acquires(lock)
 {
 	rt_spin_lock(lock);
 }
@@ -101,23 +105,27 @@ static __always_inline void spin_lock_irq(spinlock_t *lock)
 	} while (0)
 
 static __always_inline void spin_unlock(spinlock_t *lock)
+	__releases(lock)
 {
 	rt_spin_unlock(lock);
 }
 
 static __always_inline void spin_unlock_bh(spinlock_t *lock)
+	__releases(lock)
 {
 	rt_spin_unlock(lock);
 	local_bh_enable();
 }
 
 static __always_inline void spin_unlock_irq(spinlock_t *lock)
+	__releases(lock)
 {
 	rt_spin_unlock(lock);
 }
 
 static __always_inline void spin_unlock_irqrestore(spinlock_t *lock,
 						   unsigned long flags)
+	__releases(lock)
 {
 	rt_spin_unlock(lock);
 }
@@ -132,14 +140,11 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock,
 	__cond_acquire(lock, rt_spin_trylock(lock))
 
 #define spin_trylock_irqsave(lock, flags)		\
-({							\
-	int __locked;					\
-							\
-	typecheck(unsigned long, flags);		\
-	flags = 0;					\
-	__locked = spin_trylock(lock);			\
-	__locked;					\
-})
+	__cond_acquire(lock, ({				\
+		typecheck(unsigned long, flags);	\
+		flags = 0;				\
+		rt_spin_trylock(lock);			\
+	}))
 
 #define spin_is_contended(lock)		(((void)(lock), 0))
 
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 2dfa35ffec76..2c5db5b5b990 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -14,7 +14,7 @@
 #ifndef CONFIG_PREEMPT_RT
 
 /* Non PREEMPT_RT kernels map spinlock to raw_spinlock */
-typedef struct spinlock {
+struct_with_capability(spinlock) {
 	union {
 		struct raw_spinlock rlock;
 
@@ -26,7 +26,8 @@ typedef struct spinlock {
 		};
 #endif
 	};
-} spinlock_t;
+};
+typedef struct spinlock spinlock_t;
 
 #define ___SPIN_LOCK_INITIALIZER(lockname)	\
 	{					\
@@ -47,12 +48,13 @@ typedef struct spinlock {
 /* PREEMPT_RT kernels map spinlock to rt_mutex */
 #include <linux/rtmutex.h>
 
-typedef struct spinlock {
+struct_with_capability(spinlock) {
 	struct rt_mutex_base	lock;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-} spinlock_t;
+};
+typedef struct spinlock spinlock_t;
 
 #define __SPIN_LOCK_UNLOCKED(name)				\
 	{							\
diff --git a/include/linux/spinlock_types_raw.h b/include/linux/spinlock_types_raw.h
index 91cb36b65a17..07792ff2c2b5 100644
--- a/include/linux/spinlock_types_raw.h
+++ b/include/linux/spinlock_types_raw.h
@@ -11,7 +11,7 @@
 
 #include <linux/lockdep_types.h>
 
-typedef struct raw_spinlock {
+struct_with_capability(raw_spinlock) {
 	arch_spinlock_t raw_lock;
 #ifdef CONFIG_DEBUG_SPINLOCK
 	unsigned int magic, owner_cpu;
@@ -20,7 +20,8 @@ typedef struct raw_spinlock {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
-} raw_spinlock_t;
+};
+typedef struct raw_spinlock raw_spinlock_t;
 
 #define SPINLOCK_MAGIC		0xdead4ead
 
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index a0adacce30ff..f63980e134cf 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/build_bug.h>
+#include <linux/spinlock.h>
 
 /*
  * Test that helper macros work as expected.
@@ -16,3 +17,130 @@ static void __used test_common_helpers(void)
 	BUILD_BUG_ON(capability_unsafe((void)2, 3) != 3); /* does not swallow commas */
 	capability_unsafe(do { } while (0)); /* works with void statements */
 }
+
+#define TEST_SPINLOCK_COMMON(class, type, type_init, type_lock, type_unlock, type_trylock, op)	\
+	struct test_##class##_data {								\
+		type lock;									\
+		int counter __var_guarded_by(&lock);						\
+		int *pointer __ref_guarded_by(&lock);						\
+	};											\
+	static void __used test_##class##_init(struct test_##class##_data *d)			\
+	{											\
+		type_init(&d->lock);								\
+		d->counter = 0;									\
+	}											\
+	static void __used test_##class(struct test_##class##_data *d)				\
+	{											\
+		unsigned long flags;								\
+		d->pointer++;									\
+		type_lock(&d->lock);								\
+		op(d->counter);									\
+		op(*d->pointer);								\
+		type_unlock(&d->lock);								\
+		type_lock##_irq(&d->lock);							\
+		op(d->counter);									\
+		op(*d->pointer);								\
+		type_unlock##_irq(&d->lock);							\
+		type_lock##_bh(&d->lock);							\
+		op(d->counter);									\
+		op(*d->pointer);								\
+		type_unlock##_bh(&d->lock);							\
+		type_lock##_irqsave(&d->lock, flags);						\
+		op(d->counter);									\
+		op(*d->pointer);								\
+		type_unlock##_irqrestore(&d->lock, flags);					\
+	}											\
+	static void __used test_##class##_trylock(struct test_##class##_data *d)		\
+	{											\
+		if (type_trylock(&d->lock)) {							\
+			op(d->counter);								\
+			type_unlock(&d->lock);							\
+		}										\
+	}											\
+	static void __used test_##class##_assert(struct test_##class##_data *d)			\
+	{											\
+		lockdep_assert_held(&d->lock);							\
+		op(d->counter);									\
+	}											\
+	static void __used test_##class##_guard(struct test_##class##_data *d)			\
+	{											\
+		{ guard(class)(&d->lock);		op(d->counter); }			\
+		{ guard(class##_irq)(&d->lock);		op(d->counter); }			\
+		{ guard(class##_irqsave)(&d->lock);	op(d->counter); }			\
+	}
+
+#define TEST_OP_RW(x) (x)++
+#define TEST_OP_RO(x) ((void)(x))
+
+TEST_SPINLOCK_COMMON(raw_spinlock,
+		     raw_spinlock_t,
+		     raw_spin_lock_init,
+		     raw_spin_lock,
+		     raw_spin_unlock,
+		     raw_spin_trylock,
+		     TEST_OP_RW);
+static void __used test_raw_spinlock_trylock_extra(struct test_raw_spinlock_data *d)
+{
+	unsigned long flags;
+
+	if (raw_spin_trylock_irq(&d->lock)) {
+		d->counter++;
+		raw_spin_unlock_irq(&d->lock);
+	}
+	if (raw_spin_trylock_irqsave(&d->lock, flags)) {
+		d->counter++;
+		raw_spin_unlock_irqrestore(&d->lock, flags);
+	}
+	scoped_cond_guard(raw_spinlock_try, return, &d->lock) {
+		d->counter++;
+	}
+}
+
+TEST_SPINLOCK_COMMON(spinlock,
+		     spinlock_t,
+		     spin_lock_init,
+		     spin_lock,
+		     spin_unlock,
+		     spin_trylock,
+		     TEST_OP_RW);
+static void __used test_spinlock_trylock_extra(struct test_spinlock_data *d)
+{
+	unsigned long flags;
+
+	if (spin_trylock_irq(&d->lock)) {
+		d->counter++;
+		spin_unlock_irq(&d->lock);
+	}
+	if (spin_trylock_irqsave(&d->lock, flags)) {
+		d->counter++;
+		spin_unlock_irqrestore(&d->lock, flags);
+	}
+	scoped_cond_guard(spinlock_try, return, &d->lock) {
+		d->counter++;
+	}
+}
+
+TEST_SPINLOCK_COMMON(write_lock,
+		     rwlock_t,
+		     rwlock_init,
+		     write_lock,
+		     write_unlock,
+		     write_trylock,
+		     TEST_OP_RW);
+static void __used test_write_trylock_extra(struct test_write_lock_data *d)
+{
+	unsigned long flags;
+
+	if (write_trylock_irqsave(&d->lock, flags)) {
+		d->counter++;
+		write_unlock_irqrestore(&d->lock, flags);
+	}
+}
+
+TEST_SPINLOCK_COMMON(read_lock,
+		     rwlock_t,
+		     rwlock_init,
+		     read_lock,
+		     read_unlock,
+		     read_trylock,
+		     TEST_OP_RO);
-- 
2.48.1.502.g6dc24dfdaf-goog

