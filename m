Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7C8213E9C;
	Thu, 20 Feb 2025 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088804; cv=none; b=d1t3J89fKZ7rwYIVax7sP+/vZWqr2chO+c/tTMuVm0IBk0eTxpCIp7/jivFDaLXW2P1mAYILTlcFiJvAstN6flxlbylDZXf09egyI0v5Xi/rGu0lbNjBbFaknZy/v9+yaNC2bvm5adq2WO5CWF4IrKmuHOJJ3P1SKtO2JG7N+So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088804; c=relaxed/simple;
	bh=OYzLj9EHch2CTQ/DKliHrag8HOS0zGoodSrIaN44YQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+Sllqve7kZXIB2py66hxx37hBQ5UaZLJ0R65YZp88M4SjSVKP/lsgGSkXFtYdaXXTugqEJlLS92flBWLynEzV8RCnjFtP3SLWj6gZrx1A5ST/zpLyfLrdyt4NHLPW3FHkR9qewOhYpagViYHUAZZgvMyzKPHOTyRn7T3v3AUak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBxxi8Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBxxi8Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41DCC4CED1;
	Thu, 20 Feb 2025 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740088803;
	bh=OYzLj9EHch2CTQ/DKliHrag8HOS0zGoodSrIaN44YQs=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=OBxxi8BdN5xMBb2mCglwz+EUVfhrKKk9J5LvvRyqmstaviz9xnQlJTtSTJxqrGSWV
	 +j97i87LTTtHY7s2gYyS6RIueIOhtUFZuv0VEjeVAnLqDiRDR9aZ8vJdor6z8UhqKU
	 cmO/PIecBwkl/JzhCi2qOtgJsbO9JB1ntwiH65W1EznGa1mkLEF9s5FIVixTyd4L4G
	 b9t8yDJFSBVY6aNmFTG/o5pU79z2Ngtyjt6F0rXJYr0ixaXKVM/LmYGgCzq/WChV/v
	 NWwFsviElywBLfHuC4n9o4uCdTJAVVTTMpo1wfPFS/A9GvYK1SXhceuw0St0LXtIYB
	 2YZIiKxzNWMUg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6FE07CE0B34; Thu, 20 Feb 2025 14:00:03 -0800 (PST)
Date: Thu, 20 Feb 2025 14:00:03 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
Message-ID: <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-16-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206181711.1902989-16-elver@google.com>

On Thu, Feb 06, 2025 at 07:10:09PM +0100, Marco Elver wrote:
> Improve the existing annotations to properly support Clang's capability
> analysis.
> 
> The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED.
> However, it does not make sense to acquire rcu_read_lock_bh() after
> rcu_read_lock() - annotate the _bh() and _sched() variants to also
> acquire 'RCU', so that Clang (and also Sparse) can warn about it.

You lost me on this one.  What breaks if rcu_read_lock_bh() is invoked
while rcu_read_lock() is in effect?

							Thanx, Paul

> The above change also simplified introducing annotations, where it would
> not matter if RCU, RCU_BH, or RCU_SCHED is acquired: through the
> introduction of __rcu_guarded, we can use Clang's capability analysis to
> warn if a pointer is dereferenced without any of the RCU locks held, or
> updated without the appropriate helpers.
> 
> The primitives rcu_assign_pointer() and friends are wrapped with
> capability_unsafe(), which enforces using them to update RCU-protected
> pointers marked with __rcu_guarded.
> 
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  .../dev-tools/capability-analysis.rst         |  2 +-
>  include/linux/cleanup.h                       |  4 +
>  include/linux/rcupdate.h                      | 73 +++++++++++++------
>  lib/test_capability-analysis.c                | 68 +++++++++++++++++
>  4 files changed, 123 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
> index a34dfe7b0b09..73dd28a23b11 100644
> --- a/Documentation/dev-tools/capability-analysis.rst
> +++ b/Documentation/dev-tools/capability-analysis.rst
> @@ -86,7 +86,7 @@ Supported Kernel Primitives
>  
>  Currently the following synchronization primitives are supported:
>  `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
> -`bit_spinlock`.
> +`bit_spinlock`, RCU.
>  
>  For capabilities with an initialization function (e.g., `spin_lock_init()`),
>  calling this function on the capability instance before initializing any
> diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
> index 93a166549add..7d70d308357a 100644
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
> @@ -404,6 +404,10 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
>  	return _t;							\
>  }
>  
> +#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
> +static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
> +static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock
> +
>  #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
>  __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
>  __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 48e5c03df1dd..ee68095ba9f0 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -31,6 +31,16 @@
>  #include <asm/processor.h>
>  #include <linux/context_tracking_irq.h>
>  
> +token_capability(RCU);
> +token_capability_instance(RCU, RCU_SCHED);
> +token_capability_instance(RCU, RCU_BH);
> +
> +/*
> + * A convenience macro that can be used for RCU-protected globals or struct
> + * members; adds type qualifier __rcu, and also enforces __var_guarded_by(RCU).
> + */
> +#define __rcu_guarded __rcu __var_guarded_by(RCU)
> +
>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
>  
> @@ -431,7 +441,8 @@ static inline void rcu_preempt_sleep_check(void) { }
>  
>  // See RCU_LOCKDEP_WARN() for an explanation of the double call to
>  // debug_lockdep_rcu_enabled().
> -static inline bool lockdep_assert_rcu_helper(bool c)
> +static inline bool lockdep_assert_rcu_helper(bool c, const struct __capability_RCU *cap)
> +	__asserts_shared_cap(RCU) __asserts_shared_cap(cap)
>  {
>  	return debug_lockdep_rcu_enabled() &&
>  	       (c || !rcu_is_watching() || !rcu_lockdep_current_cpu_online()) &&
> @@ -444,7 +455,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * Splats if lockdep is enabled and there is no rcu_read_lock() in effect.
>   */
>  #define lockdep_assert_in_rcu_read_lock() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map), RCU))
>  
>  /**
>   * lockdep_assert_in_rcu_read_lock_bh - WARN if not protected by rcu_read_lock_bh()
> @@ -454,7 +465,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * actual rcu_read_lock_bh() is required.
>   */
>  #define lockdep_assert_in_rcu_read_lock_bh() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_bh_lock_map), RCU_BH))
>  
>  /**
>   * lockdep_assert_in_rcu_read_lock_sched - WARN if not protected by rcu_read_lock_sched()
> @@ -464,7 +475,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * instead an actual rcu_read_lock_sched() is required.
>   */
>  #define lockdep_assert_in_rcu_read_lock_sched() \
> -	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map)))
> +	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_sched_lock_map), RCU_SCHED))
>  
>  /**
>   * lockdep_assert_in_rcu_reader - WARN if not within some type of RCU reader
> @@ -482,17 +493,17 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>  	WARN_ON_ONCE(lockdep_assert_rcu_helper(!lock_is_held(&rcu_lock_map) &&			\
>  					       !lock_is_held(&rcu_bh_lock_map) &&		\
>  					       !lock_is_held(&rcu_sched_lock_map) &&		\
> -					       preemptible()))
> +					       preemptible(), RCU))
>  
>  #else /* #ifdef CONFIG_PROVE_RCU */
>  
>  #define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
>  #define rcu_sleep_check() do { } while (0)
>  
> -#define lockdep_assert_in_rcu_read_lock() do { } while (0)
> -#define lockdep_assert_in_rcu_read_lock_bh() do { } while (0)
> -#define lockdep_assert_in_rcu_read_lock_sched() do { } while (0)
> -#define lockdep_assert_in_rcu_reader() do { } while (0)
> +#define lockdep_assert_in_rcu_read_lock() __assert_shared_cap(RCU)
> +#define lockdep_assert_in_rcu_read_lock_bh() __assert_shared_cap(RCU_BH)
> +#define lockdep_assert_in_rcu_read_lock_sched() __assert_shared_cap(RCU_SCHED)
> +#define lockdep_assert_in_rcu_reader() __assert_shared_cap(RCU)
>  
>  #endif /* #else #ifdef CONFIG_PROVE_RCU */
>  
> @@ -512,11 +523,11 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>  #endif /* #else #ifdef __CHECKER__ */
>  
>  #define __unrcu_pointer(p, local)					\
> -({									\
> +capability_unsafe(							\
>  	typeof(*p) *local = (typeof(*p) *__force)(p);			\
>  	rcu_check_sparse(p, __rcu);					\
>  	((typeof(*p) __force __kernel *)(local)); 			\
> -})
> +)
>  /**
>   * unrcu_pointer - mark a pointer as not being RCU protected
>   * @p: pointer needing to lose its __rcu property
> @@ -592,7 +603,7 @@ static inline bool lockdep_assert_rcu_helper(bool c)
>   * other macros that it invokes.
>   */
>  #define rcu_assign_pointer(p, v)					      \
> -do {									      \
> +capability_unsafe(							      \
>  	uintptr_t _r_a_p__v = (uintptr_t)(v);				      \
>  	rcu_check_sparse(p, __rcu);					      \
>  									      \
> @@ -600,7 +611,7 @@ do {									      \
>  		WRITE_ONCE((p), (typeof(p))(_r_a_p__v));		      \
>  	else								      \
>  		smp_store_release(&p, RCU_INITIALIZER((typeof(p))_r_a_p__v)); \
> -} while (0)
> +)
>  
>  /**
>   * rcu_replace_pointer() - replace an RCU pointer, returning its old value
> @@ -843,9 +854,10 @@ do {									      \
>   * only when acquiring spinlocks that are subject to priority inheritance.
>   */
>  static __always_inline void rcu_read_lock(void)
> +	__acquires_shared(RCU)
>  {
>  	__rcu_read_lock();
> -	__acquire(RCU);
> +	__acquire_shared(RCU);
>  	rcu_lock_acquire(&rcu_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock() used illegally while idle");
> @@ -874,11 +886,12 @@ static __always_inline void rcu_read_lock(void)
>   * See rcu_read_lock() for more information.
>   */
>  static inline void rcu_read_unlock(void)
> +	__releases_shared(RCU)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock() used illegally while idle");
>  	rcu_lock_release(&rcu_lock_map); /* Keep acq info for rls diags. */
> -	__release(RCU);
> +	__release_shared(RCU);
>  	__rcu_read_unlock();
>  }
>  
> @@ -897,9 +910,11 @@ static inline void rcu_read_unlock(void)
>   * was invoked from some other task.
>   */
>  static inline void rcu_read_lock_bh(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_BH)
>  {
>  	local_bh_disable();
> -	__acquire(RCU_BH);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_BH);
>  	rcu_lock_acquire(&rcu_bh_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock_bh() used illegally while idle");
> @@ -911,11 +926,13 @@ static inline void rcu_read_lock_bh(void)
>   * See rcu_read_lock_bh() for more information.
>   */
>  static inline void rcu_read_unlock_bh(void)
> +	__releases_shared(RCU) __releases_shared(RCU_BH)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock_bh() used illegally while idle");
>  	rcu_lock_release(&rcu_bh_lock_map);
> -	__release(RCU_BH);
> +	__release_shared(RCU_BH);
> +	__release_shared(RCU);
>  	local_bh_enable();
>  }
>  
> @@ -935,9 +952,11 @@ static inline void rcu_read_unlock_bh(void)
>   * rcu_read_lock_sched() was invoked from an NMI handler.
>   */
>  static inline void rcu_read_lock_sched(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
>  {
>  	preempt_disable();
> -	__acquire(RCU_SCHED);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_SCHED);
>  	rcu_lock_acquire(&rcu_sched_lock_map);
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_lock_sched() used illegally while idle");
> @@ -945,9 +964,11 @@ static inline void rcu_read_lock_sched(void)
>  
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_lock_sched_notrace(void)
> +	__acquires_shared(RCU) __acquires_shared(RCU_SCHED)
>  {
>  	preempt_disable_notrace();
> -	__acquire(RCU_SCHED);
> +	__acquire_shared(RCU);
> +	__acquire_shared(RCU_SCHED);
>  }
>  
>  /**
> @@ -956,18 +977,22 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
>   * See rcu_read_lock_sched() for more information.
>   */
>  static inline void rcu_read_unlock_sched(void)
> +	__releases_shared(RCU) __releases_shared(RCU_SCHED)
>  {
>  	RCU_LOCKDEP_WARN(!rcu_is_watching(),
>  			 "rcu_read_unlock_sched() used illegally while idle");
>  	rcu_lock_release(&rcu_sched_lock_map);
> -	__release(RCU_SCHED);
> +	__release_shared(RCU_SCHED);
> +	__release_shared(RCU);
>  	preempt_enable();
>  }
>  
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
>  static inline notrace void rcu_read_unlock_sched_notrace(void)
> +	__releases_shared(RCU) __releases_shared(RCU_SCHED)
>  {
> -	__release(RCU_SCHED);
> +	__release_shared(RCU_SCHED);
> +	__release_shared(RCU);
>  	preempt_enable_notrace();
>  }
>  
> @@ -1010,10 +1035,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   * ordering guarantees for either the CPU or the compiler.
>   */
>  #define RCU_INIT_POINTER(p, v) \
> -	do { \
> +	capability_unsafe( \
>  		rcu_check_sparse(p, __rcu); \
>  		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
> -	} while (0)
> +	)
>  
>  /**
>   * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
> @@ -1172,4 +1197,6 @@ DEFINE_LOCK_GUARD_0(rcu,
>  	} while (0),
>  	rcu_read_unlock())
>  
> +DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU));
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
> index fc8dcad2a994..f5a1dda6ca38 100644
> --- a/lib/test_capability-analysis.c
> +++ b/lib/test_capability-analysis.c
> @@ -7,6 +7,7 @@
>  #include <linux/bit_spinlock.h>
>  #include <linux/build_bug.h>
>  #include <linux/mutex.h>
> +#include <linux/rcupdate.h>
>  #include <linux/seqlock.h>
>  #include <linux/spinlock.h>
>  
> @@ -277,3 +278,70 @@ static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
>  		bit_spin_unlock(3, &d->bits);
>  	}
>  }
> +
> +/*
> + * Test that we can mark a variable guarded by RCU, and we can dereference and
> + * write to the pointer with RCU's primitives.
> + */
> +struct test_rcu_data {
> +	long __rcu_guarded *data;
> +};
> +
> +static void __used test_rcu_guarded_reader(struct test_rcu_data *d)
> +{
> +	rcu_read_lock();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock();
> +
> +	rcu_read_lock_bh();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock_bh();
> +
> +	rcu_read_lock_sched();
> +	(void)rcu_dereference(d->data);
> +	rcu_read_unlock_sched();
> +}
> +
> +static void __used test_rcu_guard(struct test_rcu_data *d)
> +{
> +	guard(rcu)();
> +	(void)rcu_dereference(d->data);
> +}
> +
> +static void __used test_rcu_guarded_updater(struct test_rcu_data *d)
> +{
> +	rcu_assign_pointer(d->data, NULL);
> +	RCU_INIT_POINTER(d->data, NULL);
> +	(void)unrcu_pointer(d->data);
> +}
> +
> +static void wants_rcu_held(void)	__must_hold_shared(RCU)       { }
> +static void wants_rcu_held_bh(void)	__must_hold_shared(RCU_BH)    { }
> +static void wants_rcu_held_sched(void)	__must_hold_shared(RCU_SCHED) { }
> +
> +static void __used test_rcu_lock_variants(void)
> +{
> +	rcu_read_lock();
> +	wants_rcu_held();
> +	rcu_read_unlock();
> +
> +	rcu_read_lock_bh();
> +	wants_rcu_held_bh();
> +	rcu_read_unlock_bh();
> +
> +	rcu_read_lock_sched();
> +	wants_rcu_held_sched();
> +	rcu_read_unlock_sched();
> +}
> +
> +static void __used test_rcu_assert_variants(void)
> +{
> +	lockdep_assert_in_rcu_read_lock();
> +	wants_rcu_held();
> +
> +	lockdep_assert_in_rcu_read_lock_bh();
> +	wants_rcu_held_bh();
> +
> +	lockdep_assert_in_rcu_read_lock_sched();
> +	wants_rcu_held_sched();
> +}
> -- 
> 2.48.1.502.g6dc24dfdaf-goog
> 
