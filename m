Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A525328B7F9
	for <linux-crypto@vger.kernel.org>; Wed,  6 Aug 2025 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754487392; cv=none; b=AuoRcTbnXFMElcxMUv2wHnFNCcJTH6mTgPLBqWx8noQXoOS+frHRaHCcXcIsW5xv01S5cS85vm2Wu75M/v2UX2aia10TgVAZBLdD/1g7uTUl3IF3Fc3lLo8Z0KfweKMyIwsCyPz9HSmVlBu+2heiEn6yt+FC6Ez+3s21TxQ6UU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754487392; c=relaxed/simple;
	bh=qdViulcUrCjAFXu0wmoAFlHGAbZ30lqdtc4DJy/T6sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=un4QuJ3pF39vGDknsrLn2TDFbC2TTL6i8BBDk3U0Wg/UKOoqq2dxGvWF7VFkfV5GbJi+BIDzedVXgLAzpxtUTxrTZmuJ+6WJnuyA4QtoF57dh9hkXUzVuM5DdvV0Tsr5NHH6wJCw/mrpwCKMGzen2wUviLKXsQjtd//CRDlu298=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jyd7840V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jyd7840V"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b8de6f7556so2072517f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 Aug 2025 06:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754487388; x=1755092188; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fLfQNanTpPrwYTh/p3ORoJw+sTRzGdPh+Aqm5jOtPI=;
        b=jyd7840VvvYiQwzHbmxagn9V2BMoixypbh0T3v9jw0rorI6OfE419JwYecpBFlm/XM
         GgOd+EfJErTIFmxQpFOOI/eu05G6cGkiVlhXwD2kNJjudbHe3ZuBqhlGEnkewsqr9XjW
         Wk6D5ab+HaJPeGKWrhpxPixdz9Y8KxaANqNDhFxkuOoRR+YjjyMS/MADSVO1OKA2jQkB
         YOuS9l+6d+qK7z5EDSCQq7i1i/T2CBSaBnyVYliQS54G/HhYDlStt7G4UyivOqVC6Lyq
         7fFOOSP1D+aDg3ppzCe9LAYQGL/1QGCCrD8wBo0ECR43J2y2oBsYrvYy3abXB/2UOI0O
         +SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754487388; x=1755092188;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fLfQNanTpPrwYTh/p3ORoJw+sTRzGdPh+Aqm5jOtPI=;
        b=B0I1wLfb2xTk4rcso/MsyM4v+YSwiJdpLffBwKjm48VABjDwW9+0i5mi3Quj9k43AV
         fprZbdMilatb6SwTjJoUOwPtH3zc379kL2YiVrVX5TbmgWaOq2rZ7qZHND3rJYthpkZW
         Qh6oHA7etphAePQY0I3KmYE7QoOZBTsxBwPnk0MKiZ/cbC33FKINwy6XlNkQy9PDO/aA
         zZFs03D9jJQCr/pAFl9q86C62ix8PJ/dbmEUGbQld2uqwD5xUN6w9oxLHpSfgkfBlOY+
         8/Qjgg/7AQw/bI/X7BtVDKgYTyF43Sm14BZC3g7zx58eXfYP6LG/vyerTwZczPCzI4LW
         qnYA==
X-Forwarded-Encrypted: i=1; AJvYcCXbXXQ71L3tUm5NGoozrUw8ywKqTDC05ZX0IUW96yoo1unOGUfGoCL5CBmzyHoCCW/NEsTJz7/0jKSIuUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjMwBcaGcSlWt057lqbGcQ8SmdeDqvj6InbO6fPcIfrZO4eklN
	LCG/1wQcBz2b5Yl1dRi2/kmK8Yl0ld1RZX33BOud0cvuUMZYIgn9pMzZ+NTSxG2Dbw==
X-Gm-Gg: ASbGncvsdZG8JmGBihVh+Pfpmr3uFK8r8te2k9laQhb5R/yeJxtEKYXpdFoSNx8JbEF
	ioFiilrG/STrhpUIebyd699tL0mvMSdc3Dnf+5TYlAgsFfmP2CkKU9LGJD1bqQQ5UuNTI3zLQX7
	2sYyWzxW9umFhipPiZtWgoDWJCCtLru1likRUqQTFFmM/dw6lvmlBHrA4tradXH4HZtyAKu4+OX
	cNvwR8WnxtQ4LZT3RVrJ1Y+l6FoP7BvdIeKggv04Z15Ev1HwMu4hWzUbOTfB3cW6BoWXLVsBNzr
	d0aWvZOH5zBQpmoiJf4Z2OH2ji6VkNscAmq+XX+5nvlT6io8bOg3FLQSVqBe2fFfDwI4yrVy+hG
	Q9pbXzcgEbS2t78H9VNen/FwRUrBder39AEVlP/A20GbjyUQYT5fDTcTTfUk=
X-Google-Smtp-Source: AGHT+IHpz4Jo3q3gIFnfMhrV5PG26cNULpfcmUzd0WkLzfhGnJMYID4QsqKt5ufBb5BnIHQurwAj4w==
X-Received: by 2002:a05:6000:1a8f:b0:3b7:dd87:d730 with SMTP id ffacd0b85a97d-3b8f420f051mr2451935f8f.52.1754487387380;
        Wed, 06 Aug 2025 06:36:27 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:5667:3708:660c:31f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfd10sm313688645e9.21.2025.08.06.06.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 06:36:26 -0700 (PDT)
Date: Wed, 6 Aug 2025 15:36:19 +0200
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 00/34] Compiler-Based Capability- and Locking-Analysis
Message-ID: <aJNaUwoDjuGfplLm@elver.google.com>
References: <20250304092417.2873893-1-elver@google.com>
 <20250305112041.GA16878@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305112041.GA16878@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Wed, Mar 05, 2025 at 12:20PM +0100, Peter Zijlstra wrote:
> 
> Right, so since this is all awesome, I figured I should try and have it
> compile kernel/sched/, see how far I get.
> 
[...]

It's been a while, but teaching Clang new tricks for this analysis has
been taking its time (and I've only been looking into this on and off).

Anyway, Clang has already gained __attribute__((reentrant_capability).
Of course, that alone doesn't quite help that much.
But what we really wanted, I think, per this Clang discussion thread
[1], was some "simple" form of intra-procedural alias analysis.

[1] https://lore.kernel.org/all/CANpmjNPquO=W1JAh1FNQb8pMQjgeZAKCPQUAd7qUg=5pjJ6x=Q@mail.gmail.com/

Anyway, this evolving Clang PR probably gets us pretty close:
 https://github.com/llvm/llvm-project/pull/142955

With Clang from that PR, I can compile kernel/sched/{core.c, fair.c}
with modest changes (see below - work in progress) without warnings.
Notably, this can also deal with "capability acquired in returned
object" with some macro magic.

The full v3 series preview is here:
https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=cap-analysis/dev

The whole tree compiles cleanly, although I might have missed testing
some kernel configs.

If/when that Clang PR lands (~ETA another month probably), I would think
about sending the next version of this series.

Thanks,
-- Marco

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Sun, 3 Aug 2025 20:21:39 +0200
Subject: [PATCH] sched: Enable capability analysis for core.c and fair.c

This demonstrates a larger conversion to use Clang's capability
analysis. The benefit is additional static checking of locking rules,
along with better documentation.

Arguably, kernel/sched is the "final boss" of Clang's capability
analysis, and application to core.c & fair.c demonstrates that the
latest Clang version has become powerful enough to start applying this
to more complex subsystems (with some modest annotations and changes).

Signed-off-by: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
v3:
* New patch.
---
 include/linux/sched.h                       |   6 +-
 include/linux/sched/signal.h                |   4 +-
 include/linux/sched/task.h                  |   5 +-
 include/linux/sched/wake_q.h                |   3 +
 kernel/sched/Makefile                       |   3 +
 kernel/sched/core.c                         |  82 ++++++++++-----
 kernel/sched/fair.c                         |   6 +-
 kernel/sched/sched.h                        | 108 +++++++++++++-------
 scripts/capability-analysis-suppression.txt |   1 +
 9 files changed, 148 insertions(+), 70 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index aa9c5be7a632..3ac9d2407773 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2125,9 +2125,9 @@ static inline int _cond_resched(void)
 	_cond_resched();			\
 })
 
-extern int __cond_resched_lock(spinlock_t *lock);
-extern int __cond_resched_rwlock_read(rwlock_t *lock);
-extern int __cond_resched_rwlock_write(rwlock_t *lock);
+extern int __cond_resched_lock(spinlock_t *lock) __must_hold(lock);
+extern int __cond_resched_rwlock_read(rwlock_t *lock) __must_hold_shared(lock);
+extern int __cond_resched_rwlock_write(rwlock_t *lock) __must_hold(lock);
 
 #define MIGHT_RESCHED_RCU_SHIFT		8
 #define MIGHT_RESCHED_PREEMPT_MASK	((1U << MIGHT_RESCHED_RCU_SHIFT) - 1)
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index bc7f83b012fb..6f581a750e84 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -734,10 +734,12 @@ static inline int thread_group_empty(struct task_struct *p)
 		(thread_group_leader(p) && !thread_group_empty(p))
 
 extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
-						unsigned long *flags);
+						unsigned long *flags)
+	__acquires(&task->sighand->siglock);
 
 static inline void unlock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
+	__releases(&task->sighand->siglock)
 {
 	spin_unlock_irqrestore(&task->sighand->siglock, *flags);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ca1db4b92c32..a4373fc687bd 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -226,15 +226,18 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * neither inside nor outside.
  */
 static inline void task_lock(struct task_struct *p)
+	__acquires(&p->alloc_lock)
 {
 	spin_lock(&p->alloc_lock);
 }
 
 static inline void task_unlock(struct task_struct *p)
+	__releases(&p->alloc_lock)
 {
 	spin_unlock(&p->alloc_lock);
 }
 
-DEFINE_GUARD(task_lock, struct task_struct *, task_lock(_T), task_unlock(_T))
+DEFINE_LOCK_GUARD_1(task_lock, struct task_struct, task_lock(_T->lock), task_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(task_lock, __assumes_cap(_T->alloc_lock), /* */)
 
 #endif /* _LINUX_SCHED_TASK_H */
diff --git a/include/linux/sched/wake_q.h b/include/linux/sched/wake_q.h
index 0f28b4623ad4..765bbc3d54be 100644
--- a/include/linux/sched/wake_q.h
+++ b/include/linux/sched/wake_q.h
@@ -66,6 +66,7 @@ extern void wake_up_q(struct wake_q_head *head);
 /* Spin unlock helpers to unlock and call wake_up_q with preempt disabled */
 static inline
 void raw_spin_unlock_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock(lock);
@@ -77,6 +78,7 @@ void raw_spin_unlock_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
 
 static inline
 void raw_spin_unlock_irq_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock_irq(lock);
@@ -89,6 +91,7 @@ void raw_spin_unlock_irq_wake(raw_spinlock_t *lock, struct wake_q_head *wake_q)
 static inline
 void raw_spin_unlock_irqrestore_wake(raw_spinlock_t *lock, unsigned long flags,
 				     struct wake_q_head *wake_q)
+	__releases(lock)
 {
 	guard(preempt)();
 	raw_spin_unlock_irqrestore(lock, flags);
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 8ae86371ddcd..8603987ce4c1 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CAPABILITY_ANALYSIS_core.o := y
+CAPABILITY_ANALYSIS_fair.o := y
+
 # The compilers are complaining about unused variables inside an if(0) scope
 # block. This is daft, shut them up.
 ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 81c6df746df1..0182d0246f44 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -664,16 +664,17 @@ void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	raw_spin_rq_lock(rq1);
 	if (__rq_lockp(rq1) != __rq_lockp(rq2))
 		raw_spin_rq_lock_nested(rq2, SINGLE_DEPTH_NESTING);
+	else
+		__acquire_cap(__rq_lockp(rq2)); /* fake acquire */
 
 	double_rq_clock_clear_update(rq1, rq2);
 }
 #endif
 
 /*
- * __task_rq_lock - lock the rq @p resides on.
+ * ___task_rq_lock - lock the rq @p resides on.
  */
-struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock)
+struct rq *___task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 {
 	struct rq *rq;
 
@@ -696,9 +697,7 @@ struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 /*
  * task_rq_lock - lock p->pi_lock and lock the rq @p resides on.
  */
-struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock)
+struct rq *_task_rq_lock(struct task_struct *p, struct rq_flags *rf)
 {
 	struct rq *rq;
 
@@ -2494,6 +2493,7 @@ static inline bool is_cpu_allowed(struct task_struct *p, int cpu)
  */
 static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 				   struct task_struct *p, int new_cpu)
+	__must_hold(&rq->__lock)
 {
 	lockdep_assert_rq_held(rq);
 
@@ -2540,6 +2540,7 @@ struct set_affinity_pending {
  */
 static struct rq *__migrate_task(struct rq *rq, struct rq_flags *rf,
 				 struct task_struct *p, int dest_cpu)
+	__must_hold(&rq->__lock)
 {
 	/* Affinity changed (again). */
 	if (!is_cpu_allowed(p, dest_cpu))
@@ -2576,6 +2577,12 @@ static int migration_cpu_stop(void *data)
 	 */
 	flush_smp_call_function_queue();
 
+	/*
+	 * We may change the underlying rq, but the locks held will
+	 * appropriately be "transferred" when switching.
+	 */
+	capability_unsafe_alias(rq);
+
 	raw_spin_lock(&p->pi_lock);
 	rq_lock(rq, &rf);
 
@@ -2685,6 +2692,8 @@ int push_cpu_stop(void *arg)
 	if (!lowest_rq)
 		goto out_unlock;
 
+	lockdep_assert_rq_held(lowest_rq);
+
 	// XXX validate p is still the highest prio task
 	if (task_rq(p) == rq) {
 		move_queued_task_locked(rq, lowest_rq, p);
@@ -2930,8 +2939,7 @@ void release_user_cpus_ptr(struct task_struct *p)
  */
 static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flags *rf,
 			    int dest_cpu, unsigned int flags)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(&rq->__lock, &p->pi_lock)
 {
 	struct set_affinity_pending my_pending = { }, *pending = NULL;
 	bool stop_pending, complete = false;
@@ -3079,8 +3087,7 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 					 struct affinity_context *ctx,
 					 struct rq *rq,
 					 struct rq_flags *rf)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(&rq->__lock, &p->pi_lock)
 {
 	const struct cpumask *cpu_allowed_mask = task_cpu_possible_mask(p);
 	const struct cpumask *cpu_valid_mask = cpu_active_mask;
@@ -4400,29 +4407,30 @@ static bool __task_needs_rq_lock(struct task_struct *p)
  */
 int task_call_func(struct task_struct *p, task_call_f func, void *arg)
 {
-	struct rq *rq = NULL;
 	struct rq_flags rf;
 	int ret;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 
-	if (__task_needs_rq_lock(p))
-		rq = __task_rq_lock(p, &rf);
+	if (__task_needs_rq_lock(p)) {
+		struct rq *rq = __task_rq_lock(p, &rf);
 
-	/*
-	 * At this point the task is pinned; either:
-	 *  - blocked and we're holding off wakeups	 (pi->lock)
-	 *  - woken, and we're holding off enqueue	 (rq->lock)
-	 *  - queued, and we're holding off schedule	 (rq->lock)
-	 *  - running, and we're holding off de-schedule (rq->lock)
-	 *
-	 * The called function (@func) can use: task_curr(), p->on_rq and
-	 * p->__state to differentiate between these states.
-	 */
-	ret = func(p, arg);
+		/*
+		 * At this point the task is pinned; either:
+		 *  - blocked and we're holding off wakeups	 (pi->lock)
+		 *  - woken, and we're holding off enqueue	 (rq->lock)
+		 *  - queued, and we're holding off schedule	 (rq->lock)
+		 *  - running, and we're holding off de-schedule (rq->lock)
+		 *
+		 * The called function (@func) can use: task_curr(), p->on_rq and
+		 * p->__state to differentiate between these states.
+		 */
+		ret = func(p, arg);
 
-	if (rq)
 		rq_unlock(rq, &rf);
+	} else {
+		ret = func(p, arg);
+	}
 
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
@@ -5118,6 +5126,8 @@ static inline void __balance_callbacks(struct rq *rq)
 
 static inline void
 prepare_lock_switch(struct rq *rq, struct task_struct *next, struct rq_flags *rf)
+	__releases(__rq_lockp(rq))
+	__acquires(__rq_lockp(this_rq()))
 {
 	/*
 	 * Since the runqueue lock will be released by the next
@@ -5131,9 +5141,15 @@ prepare_lock_switch(struct rq *rq, struct task_struct *next, struct rq_flags *rf
 	/* this is a valid case when another task releases the spinlock */
 	rq_lockp(rq)->owner = next;
 #endif
+	/*
+	 * Model the rq reference switcheroo.
+	 */
+	__release(__rq_lockp(rq));
+	__acquire(__rq_lockp(this_rq()));
 }
 
 static inline void finish_lock_switch(struct rq *rq)
+	__releases(&rq->__lock)
 {
 	/*
 	 * If we are tracking spinlock dependencies then we have to
@@ -5189,6 +5205,7 @@ static inline void kmap_local_sched_in(void)
 static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
+	__must_hold(&rq->__lock)
 {
 	kcov_prepare_switch(prev);
 	sched_info_switch(rq, prev, next);
@@ -5220,7 +5237,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * because prev may have moved to another CPU.
  */
 static struct rq *finish_task_switch(struct task_struct *prev)
-	__releases(rq->lock)
+	__releases(__rq_lockp(this_rq()))
 {
 	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
@@ -5308,7 +5325,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
  * @prev: the thread we just switched away from.
  */
 asmlinkage __visible void schedule_tail(struct task_struct *prev)
-	__releases(rq->lock)
+	__releases(&this_rq()->__lock)
 {
 	/*
 	 * New tasks start with FORK_PREEMPT_COUNT, see there and
@@ -5340,6 +5357,7 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 static __always_inline struct rq *
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next, struct rq_flags *rf)
+	__releases(&rq->__lock)
 {
 	prepare_task_switch(rq, prev, next);
 
@@ -6026,6 +6044,7 @@ static void prev_balance(struct rq *rq, struct task_struct *prev,
  */
 static inline struct task_struct *
 __pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -6118,6 +6137,7 @@ static void queue_core_balance(struct rq *rq);
 
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	struct task_struct *next, *p, *max = NULL;
 	const struct cpumask *smt_mask;
@@ -6562,6 +6582,7 @@ static inline void sched_core_cpu_dying(unsigned int cpu) {}
 
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	return __pick_next_task(rq, prev, rf);
 }
@@ -8004,6 +8025,12 @@ static int __balance_push_cpu_stop(void *arg)
 	struct rq_flags rf;
 	int cpu;
 
+	/*
+	 * We may change the underlying rq, but the locks held will
+	 * appropriately be "transferred" when switching.
+	 */
+	capability_unsafe_alias(rq);
+
 	raw_spin_lock_irq(&p->pi_lock);
 	rq_lock(rq, &rf);
 
@@ -8031,6 +8058,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, push_work);
  * effective when the hotplug motion is down.
  */
 static void balance_push(struct rq *rq)
+	__must_hold(&rq->__lock)
 {
 	struct task_struct *push_task = rq->curr;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a14da5396fb..260158287ddb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4842,7 +4842,8 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
-static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf);
+static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
+	__must_hold(__rq_lockp(this_rq));
 
 static inline unsigned long task_util(struct task_struct *p)
 {
@@ -8737,6 +8738,7 @@ static void set_cpus_allowed_fair(struct task_struct *p, struct affinity_context
 
 static int
 balance_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	if (sched_fair_runnable(rq))
 		return 1;
@@ -8884,6 +8886,7 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
 
 struct task_struct *
 pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
+	__must_hold(__rq_lockp(rq))
 {
 	struct sched_entity *se;
 	struct task_struct *p;
@@ -8970,6 +8973,7 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
 }
 
 static struct task_struct *__pick_next_task_fair(struct rq *rq, struct task_struct *prev)
+	__must_hold(__rq_lockp(rq))
 {
 	return pick_next_task_fair(rq, prev, NULL);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 83e3aa917142..0da7c8b89030 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1343,8 +1343,13 @@ static inline bool is_migration_disabled(struct task_struct *p)
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
+static __always_inline struct rq *__this_rq(void)
+{
+	return this_cpu_ptr(&runqueues);
+}
+
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		this_cpu_ptr(&runqueues)
+#define this_rq()		__this_rq()
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
@@ -1473,11 +1478,13 @@ static inline bool sched_core_disabled(void)
 }
 
 static inline raw_spinlock_t *rq_lockp(struct rq *rq)
+	__returns_cap(&rq->__lock)
 {
 	return &rq->__lock;
 }
 
 static inline raw_spinlock_t *__rq_lockp(struct rq *rq)
+	__returns_cap(&rq->__lock)
 {
 	return &rq->__lock;
 }
@@ -1519,32 +1526,42 @@ static inline bool rt_group_sched_enabled(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static inline void lockdep_assert_rq_held(struct rq *rq)
+	__assumes_cap(__rq_lockp(rq))
 {
 	lockdep_assert_held(__rq_lockp(rq));
 }
 
-extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass);
-extern bool raw_spin_rq_trylock(struct rq *rq);
-extern void raw_spin_rq_unlock(struct rq *rq);
+extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass)
+	__acquires(&rq->__lock);
+
+extern bool raw_spin_rq_trylock(struct rq *rq)
+	__cond_acquires(true, &rq->__lock);
+
+extern void raw_spin_rq_unlock(struct rq *rq)
+	__releases(&rq->__lock);
 
 static inline void raw_spin_rq_lock(struct rq *rq)
+	__acquires(&rq->__lock)
 {
 	raw_spin_rq_lock_nested(rq, 0);
 }
 
 static inline void raw_spin_rq_lock_irq(struct rq *rq)
+	__acquires(&rq->__lock)
 {
 	local_irq_disable();
 	raw_spin_rq_lock(rq);
 }
 
 static inline void raw_spin_rq_unlock_irq(struct rq *rq)
+	__releases(&rq->__lock)
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_enable();
 }
 
 static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
+	__acquires(&rq->__lock)
 {
 	unsigned long flags;
 
@@ -1555,6 +1572,7 @@ static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
 }
 
 static inline void raw_spin_rq_unlock_irqrestore(struct rq *rq, unsigned long flags)
+	__releases(&rq->__lock)
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_restore(flags);
@@ -1805,17 +1823,15 @@ static inline void rq_repin_lock(struct rq *rq, struct rq_flags *rf)
 	rq->clock_update_flags |= rf->clock_update_flags;
 }
 
-extern
-struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock);
+#define __task_rq_lock(...) __acquire_ret(___task_rq_lock(__VA_ARGS__), &__ret->__lock)
+extern struct rq *___task_rq_lock(struct task_struct *p, struct rq_flags *rf) __acquires_ret;
 
-extern
-struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock);
+#define task_rq_lock(...) __acquire_ret(_task_rq_lock(__VA_ARGS__), &__ret->__lock)
+extern struct rq *_task_rq_lock(struct task_struct *p, struct rq_flags *rf)
+	__acquires(&p->pi_lock) __acquires_ret;
 
 static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(&rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1823,8 +1839,7 @@ static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
 
 static inline void
 task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
-	__releases(rq->lock)
-	__releases(p->pi_lock)
+	__releases(&rq->__lock, &p->pi_lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1835,44 +1850,45 @@ DEFINE_LOCK_GUARD_1(task_rq_lock, struct task_struct,
 		    _T->rq = task_rq_lock(_T->lock, &_T->rf),
 		    task_rq_unlock(_T->rq, _T->lock, &_T->rf),
 		    struct rq *rq; struct rq_flags rf)
+DECLARE_LOCK_GUARD_1_ATTRS(task_rq_lock, __assumes_cap(_T->pi_lock), /* */)
 
 static inline void rq_lock_irqsave(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(&rq->__lock)
 {
 	raw_spin_rq_lock_irqsave(rq, rf->flags);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock_irq(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(&rq->__lock)
 {
 	raw_spin_rq_lock_irq(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(&rq->__lock)
 {
 	raw_spin_rq_lock(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_unlock_irqrestore(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(&rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irqrestore(rq, rf->flags);
 }
 
 static inline void rq_unlock_irq(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(&rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irq(rq);
 }
 
 static inline void rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(&rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1883,18 +1899,24 @@ DEFINE_LOCK_GUARD_1(rq_lock, struct rq,
 		    rq_unlock(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock, __assumes_cap(_T->__lock), /* */);
+
 DEFINE_LOCK_GUARD_1(rq_lock_irq, struct rq,
 		    rq_lock_irq(_T->lock, &_T->rf),
 		    rq_unlock_irq(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock_irq, __assumes_cap(_T->__lock), /* */);
+
 DEFINE_LOCK_GUARD_1(rq_lock_irqsave, struct rq,
 		    rq_lock_irqsave(_T->lock, &_T->rf),
 		    rq_unlock_irqrestore(_T->lock, &_T->rf),
 		    struct rq_flags rf)
 
-static inline struct rq *this_rq_lock_irq(struct rq_flags *rf)
-	__acquires(rq->lock)
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock_irqsave, __assumes_cap(_T->__lock), /* */);
+
+#define this_rq_lock_irq(...) __acquire_ret(_this_rq_lock_irq(__VA_ARGS__), &__ret->__lock)
+static inline struct rq *_this_rq_lock_irq(struct rq_flags *rf) __acquires_ret
 {
 	struct rq *rq;
 
@@ -2927,9 +2949,15 @@ static inline void double_rq_clock_clear_update(struct rq *rq1, struct rq *rq2)
 #define DEFINE_LOCK_GUARD_2(name, type, _lock, _unlock, ...)				\
 __DEFINE_UNLOCK_GUARD(name, type, _unlock, type *lock2; __VA_ARGS__)			\
 static inline class_##name##_t class_##name##_constructor(type *lock, type *lock2)	\
+	__no_capability_analysis							\
 { class_##name##_t _t = { .lock = lock, .lock2 = lock2 }, *_T = &_t;			\
   _lock; return _t; }
 
+#define DECLARE_LOCK_GUARD_2_ATTRS(_name, _lock, _unlock) \
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T1, \
+							    lock_##_name##_t *_T2) _lock; \
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock
+
 #ifdef CONFIG_SMP
 
 static inline bool rq_order_less(struct rq *rq1, struct rq *rq2)
@@ -2958,7 +2986,8 @@ static inline bool rq_order_less(struct rq *rq1, struct rq *rq2)
 	return rq1->cpu < rq2->cpu;
 }
 
-extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
+extern void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(&rq1->__lock, &rq2->__lock);
 
 #ifdef CONFIG_PREEMPTION
 
@@ -2971,9 +3000,8 @@ extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
  * also adds more overhead and therefore may reduce throughput.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__must_hold(&this_rq->__lock)
+	__acquires(&busiest->__lock)
 {
 	raw_spin_rq_unlock(this_rq);
 	double_rq_lock(this_rq, busiest);
@@ -2990,9 +3018,8 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * regardless of entry order into the function.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__must_hold(&this_rq->__lock)
+	__acquires(&busiest->__lock)
 {
 	if (__rq_lockp(this_rq) == __rq_lockp(busiest) ||
 	    likely(raw_spin_rq_trylock(busiest))) {
@@ -3018,6 +3045,8 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
  */
 static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__must_hold(&this_rq->__lock)
+	__acquires(&busiest->__lock)
 {
 	lockdep_assert_irqs_disabled();
 
@@ -3025,14 +3054,17 @@ static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 }
 
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
+	__releases(&busiest->__lock)
 {
 	if (__rq_lockp(this_rq) != __rq_lockp(busiest))
 		raw_spin_rq_unlock(busiest);
+	else
+		__release(__rq_lockp(busiest)); /* fake release */
 	lock_set_subclass(&__rq_lockp(this_rq)->dep_map, 0, _RET_IP_);
 }
 
 static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3042,6 +3074,7 @@ static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3051,6 +3084,7 @@ static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__acquires(l1, l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3060,6 +3094,7 @@ static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
 }
 
 static inline void double_raw_unlock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__releases(l1, l2)
 {
 	raw_spin_unlock(l1);
 	raw_spin_unlock(l2);
@@ -3069,6 +3104,8 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
 		    double_raw_lock(_T->lock, _T->lock2),
 		    double_raw_unlock(_T->lock, _T->lock2))
 
+DECLARE_LOCK_GUARD_2_ATTRS(double_raw_spinlock, __assumes_cap(_T1) __assumes_cap(_T2), /* */);
+
 /*
  * double_rq_unlock - safely unlock two runqueues
  *
@@ -3076,13 +3113,12 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
  * you need to do so manually after calling.
  */
 static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
+	__releases(&rq1->__lock, &rq2->__lock)
 {
 	if (__rq_lockp(rq1) != __rq_lockp(rq2))
 		raw_spin_rq_unlock(rq2);
 	else
-		__release(rq2->lock);
+		__release(&rq2->__lock); /* fake release */
 	raw_spin_rq_unlock(rq1);
 }
 
@@ -3100,8 +3136,7 @@ extern bool sched_smp_initialized;
  * you need to do so manually before calling.
  */
 static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
+	__acquires(&rq1->__lock, &rq2->__lock)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 	WARN_ON_ONCE(rq1 != rq2);
@@ -3117,8 +3152,7 @@ static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
  * you need to do so manually after calling.
  */
 static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
+	__releases(&rq1->__lock, &rq2->__lock)
 {
 	WARN_ON_ONCE(rq1 != rq2);
 	raw_spin_rq_unlock(rq1);
diff --git a/scripts/capability-analysis-suppression.txt b/scripts/capability-analysis-suppression.txt
index 95fb0b65a8e6..7ecd888ac522 100644
--- a/scripts/capability-analysis-suppression.txt
+++ b/scripts/capability-analysis-suppression.txt
@@ -26,6 +26,7 @@ src:*include/linux/refcount.h=emit
 src:*include/linux/rhashtable.h=emit
 src:*include/linux/rwlock*.h=emit
 src:*include/linux/rwsem.h=emit
+src:*include/linux/sched*=emit
 src:*include/linux/seqlock*.h=emit
 src:*include/linux/spinlock*.h=emit
 src:*include/linux/srcu*.h=emit
-- 
2.50.1.565.gc32cd1483b-goog
