Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B902C202F65
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080358; cv=none; b=fZ6zMoAt2Y6xhxnSYKzx4Hixdw8VOo3rmZZjn7yTKxPafA1pOvHHl/Zz1gW0rvMNTs0VJ+yv4X7hmgXfTjPRZfDx4PM0YPGgvNXSnpvTewZ7VeQz0t/t5XCicoJ46IHl7IrLJqSnME7dBGtuc5yeozbhptfsyfsQ4QspumZzhnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080358; c=relaxed/simple;
	bh=1SmN40z6kKbC+O8dvQdGpD27kvcZTiGHvP/DQN+09H4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rQFWV7+g6zId2lCdkWGY9ckMvSOnDieiZ4xkPd5u3fx5k2dE+YK0c15PPTSrvSToJXmsFzEuOFA0bKJlsQ1UArVaenVUqbESNBzZ8xjqXUXRUYzlLkNH/DGADRYg9GJvIEtR0OTLCmscTRhleq8MgZkxv3k1m1Fyq4oRXkCidyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3SFaGK9L; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3SFaGK9L"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e4b3da6b49so5228031a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080355; x=1741685155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ezb4DcU7J/tAnP2VeDlPIfb7+eFzdx1whQ0121O6/zI=;
        b=3SFaGK9LRLwlNLFT/c5cma8UqSuYLMvKhYHr9F4JA14UKIr7ukbOg6thlv9DroPV4b
         kCFR42USngDGrBKefSB0doNHTpcZWpJwIxKbYyLpxGFTPzL0bq4EnjSO8HgWN70auswC
         Y6r1RgBIvY11RlkSqnX5eSjm/YvpOqdoAHoQiZvZFZyd4au9f92HN/rWUARgrc7+juO5
         sPaVUapc9oqrLBkxLQzXjOpEHrAx5pdCwxxuZJkZg/9OaNR7McT4/YBQn7o7yvNdfB6G
         G4cputwhg2yHS2h9ybV+6Z31TNlyVwtGCKTFaoO1FLuH2yiFN6bkojarOzzGU/HysUp+
         yRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080355; x=1741685155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezb4DcU7J/tAnP2VeDlPIfb7+eFzdx1whQ0121O6/zI=;
        b=KIKdZks3iGk41Nj8/yKXkMK+yjZyrtXOitO2vp44oV2svNkgW/DQWwQt4Mguxn0F4P
         5KFzt8J+QTeEELuClJUNNf6D2gBXEdtDrnbU6u1fN97oUHSkRpRBwkfTNW5avtowVyxq
         tpOGE2QCZTlrC9Iyg5W9lWFKOUe24XM7q/hgnhqPXX6hi1CcLPbSW3Ruzn5JJxS8TU+9
         asihW6MFN1JSU56r5wAA+GzF1lzIB7LA/7TaWA9jzQRyrzIOMF93ZH8kuqxtsnut512e
         RUSQ9w6yHSbEodKDCEk7A/+nmsUwSdfZF7Ka8DsI7v3hbvz69FYtRUxueKgM1VTuJ9KB
         mvqg==
X-Forwarded-Encrypted: i=1; AJvYcCWfPfCK+QjaRhyVGVf5se7aAIVnXnxS9aDiflV2fJYq1DwBeyq5NN+hIxGo2sS2Yck1rfMQtj+TNgORa9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqAThLAGv/AunQtq0eFsrvQdhAk7ZdA2A99eX0pOcaxVYximMP
	ts32KeZilaln+5L+edXHabP75cDqNZgHEI53LvvHC7pwFpmRHY3VXQB9HJ2JWshPuS+h9jvTvw=
	=
X-Google-Smtp-Source: AGHT+IEQwbZjdZjN5RppHp55Zz74kJe74FUqiEdr52hms6eJRF3kZ/G4XeCunAHNo+i6Y4TgK/rotcyvNA==
X-Received: from edbfd14.prod.google.com ([2002:a05:6402:388e:b0:5e4:c2fd:b4ac])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2711:b0:5e0:49e4:2180
 with SMTP id 4fb4d7f45d1cf-5e4d6b4bc0dmr43845190a12.25.1741080355166; Tue, 04
 Mar 2025 01:25:55 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:16 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-18-elver@google.com>
Subject: [PATCH v2 17/34] locking/rwsem: Support Clang's capability analysis
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

Add support for Clang's capability analysis for rw_semaphore.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/rwsem.h                         | 56 +++++++++-------
 lib/test_capability-analysis.c                | 64 +++++++++++++++++++
 3 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 918e35d110df..7e4d94d65043 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`).
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index c8b543d428b0..98aa623ad9bf 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -45,7 +45,7 @@
  * reduce the chance that they will share the same cacheline causing
  * cacheline bouncing problem.
  */
-struct rw_semaphore {
+struct_with_capability(rw_semaphore) {
 	atomic_long_t count;
 	/*
 	 * Write owner or one of the read owners as well flags regarding
@@ -76,11 +76,13 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
 }
 
 static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
 }
@@ -119,6 +121,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assert_cap(sem);					\
 } while (0)
 
 /*
@@ -136,7 +139,7 @@ static inline int rwsem_is_contended(struct rw_semaphore *sem)
 
 #include <linux/rwbase_rt.h>
 
-struct rw_semaphore {
+struct_with_capability(rw_semaphore) {
 	struct rwbase_rt	rwbase;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -160,6 +163,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
+	__assert_cap(sem);					\
 } while (0)
 
 static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
@@ -168,11 +172,13 @@ static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
 }
 
 static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	WARN_ON(!rwsem_is_locked(sem));
 }
 
 static __always_inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
 }
@@ -190,6 +196,7 @@ static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
  */
 
 static inline void rwsem_assert_held(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held(sem);
@@ -198,6 +205,7 @@ static inline void rwsem_assert_held(const struct rw_semaphore *sem)
 }
 
 static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
+	__asserts_cap(sem)
 {
 	if (IS_ENABLED(CONFIG_LOCKDEP))
 		lockdep_assert_held_write(sem);
@@ -208,47 +216,47 @@ static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-extern void down_read(struct rw_semaphore *sem);
-extern int __must_check down_read_interruptible(struct rw_semaphore *sem);
-extern int __must_check down_read_killable(struct rw_semaphore *sem);
+extern void down_read(struct rw_semaphore *sem) __acquires_shared(sem);
+extern int __must_check down_read_interruptible(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
+extern int __must_check down_read_killable(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
 
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
-extern int down_read_trylock(struct rw_semaphore *sem);
+extern int down_read_trylock(struct rw_semaphore *sem) __cond_acquires_shared(true, sem);
 
 /*
  * lock for writing
  */
-extern void down_write(struct rw_semaphore *sem);
-extern int __must_check down_write_killable(struct rw_semaphore *sem);
+extern void down_write(struct rw_semaphore *sem) __acquires(sem);
+extern int __must_check down_write_killable(struct rw_semaphore *sem) __cond_acquires(0, sem);
 
 /*
  * trylock for writing -- returns 1 if successful, 0 if contention
  */
-extern int down_write_trylock(struct rw_semaphore *sem);
+extern int down_write_trylock(struct rw_semaphore *sem) __cond_acquires(true, sem);
 
 /*
  * release a read lock
  */
-extern void up_read(struct rw_semaphore *sem);
+extern void up_read(struct rw_semaphore *sem) __releases_shared(sem);
 
 /*
  * release a write lock
  */
-extern void up_write(struct rw_semaphore *sem);
+extern void up_write(struct rw_semaphore *sem) __releases(sem);
 
-DEFINE_GUARD(rwsem_read, struct rw_semaphore *, down_read(_T), up_read(_T))
-DEFINE_GUARD_COND(rwsem_read, _try, down_read_trylock(_T))
-DEFINE_GUARD_COND(rwsem_read, _intr, down_read_interruptible(_T) == 0)
+DEFINE_LOCK_GUARD_1(rwsem_read, struct rw_semaphore, down_read(_T->lock), up_read(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _try, down_read_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_read, _intr, down_read_interruptible(_T->lock) == 0)
 
-DEFINE_GUARD(rwsem_write, struct rw_semaphore *, down_write(_T), up_write(_T))
-DEFINE_GUARD_COND(rwsem_write, _try, down_write_trylock(_T))
+DEFINE_LOCK_GUARD_1(rwsem_write, struct rw_semaphore, down_write(_T->lock), up_write(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(rwsem_write, _try, down_write_trylock(_T->lock))
 
 /*
  * downgrade write lock to read lock
  */
-extern void downgrade_write(struct rw_semaphore *sem);
+extern void downgrade_write(struct rw_semaphore *sem) __releases(sem) __acquires_shared(sem);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
@@ -264,11 +272,11 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * lockdep_set_class() at lock initialization time.
  * See Documentation/locking/lockdep-design.rst for more details.)
  */
-extern void down_read_nested(struct rw_semaphore *sem, int subclass);
-extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass);
-extern void down_write_nested(struct rw_semaphore *sem, int subclass);
-extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass);
-extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
+extern void down_read_nested(struct rw_semaphore *sem, int subclass) __acquires_shared(sem);
+extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass) __cond_acquires_shared(0, sem);
+extern void down_write_nested(struct rw_semaphore *sem, int subclass) __acquires(sem);
+extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass) __cond_acquires(0, sem);
+extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock) __acquires(sem);
 
 # define down_write_nest_lock(sem, nest_lock)			\
 do {								\
@@ -282,8 +290,8 @@ do {								\
  * [ This API should be avoided as much as possible - the
  *   proper abstraction for this case is completions. ]
  */
-extern void down_read_non_owner(struct rw_semaphore *sem);
-extern void up_read_non_owner(struct rw_semaphore *sem);
+extern void down_read_non_owner(struct rw_semaphore *sem) __acquires_shared(sem);
+extern void up_read_non_owner(struct rw_semaphore *sem) __releases_shared(sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_read_killable_nested(sem, subclass)	down_read_killable(sem)
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 63d81ad1562f..7ccb163ab5b1 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -8,6 +8,7 @@
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/rwsem.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -255,6 +256,69 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	write_sequnlock_irqrestore(&d->sl, flags);
 }
 
+struct test_rwsem_data {
+	struct rw_semaphore sem;
+	int counter __guarded_by(&sem);
+};
+
+static void __used test_rwsem_init(struct test_rwsem_data *d)
+{
+	init_rwsem(&d->sem);
+	d->counter = 0;
+}
+
+static void __used test_rwsem_reader(struct test_rwsem_data *d)
+{
+	down_read(&d->sem);
+	(void)d->counter;
+	up_read(&d->sem);
+
+	if (down_read_trylock(&d->sem)) {
+		(void)d->counter;
+		up_read(&d->sem);
+	}
+}
+
+static void __used test_rwsem_writer(struct test_rwsem_data *d)
+{
+	down_write(&d->sem);
+	d->counter++;
+	up_write(&d->sem);
+
+	down_write(&d->sem);
+	d->counter++;
+	downgrade_write(&d->sem);
+	(void)d->counter;
+	up_read(&d->sem);
+
+	if (down_write_trylock(&d->sem)) {
+		d->counter++;
+		up_write(&d->sem);
+	}
+}
+
+static void __used test_rwsem_assert(struct test_rwsem_data *d)
+{
+	rwsem_assert_held_nolockdep(&d->sem);
+	d->counter++;
+}
+
+static void __used test_rwsem_guard(struct test_rwsem_data *d)
+{
+	{ guard(rwsem_read)(&d->sem); (void)d->counter; }
+	{ guard(rwsem_write)(&d->sem); d->counter++; }
+}
+
+static void __used test_rwsem_cond_guard(struct test_rwsem_data *d)
+{
+	scoped_cond_guard(rwsem_read_try, return, &d->sem) {
+		(void)d->counter;
+	}
+	scoped_cond_guard(rwsem_write_try, return, &d->sem) {
+		d->counter++;
+	}
+}
+
 struct test_bit_spinlock_data {
 	unsigned long bits;
 	int counter __guarded_by(__bitlock(3, &bits));
-- 
2.48.1.711.g2feabab25a-goog

