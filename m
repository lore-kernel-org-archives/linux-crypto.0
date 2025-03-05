Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC574235BE4;
	Wed,  5 Mar 2025 11:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741173666; cv=none; b=JEd60rgS0ufe/gYDusz5zAAbYobqdzAeGouqKNTnMI1MGuqZjNQPZzAm8Mf8+Wk8dMLLZnMtQLCB1x2SIQInsPiZDJPMbT/VuPbecgDnRNon+V1eIV4RSaYWYydHversU6LOgI958c0mn2TjlvmGyR/kr84e9TuePsvIo040hiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741173666; c=relaxed/simple;
	bh=Sbkmn+Zrkri4H3urquoe/oprFfn4YsRk0cFetpBWkwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYsP5rnQtzBNbJIAqiklYsUpe1FheU5s1GYr4xFV8bzvbsVxbH2h7EiHBFicr2P2JAOzHacWmgUVeN3cDWhLvl86e2mpyBssKPXDd53JR717unSRXRIz6hhMUFWliqcpXIG8Xvw1/EzSrzTZGodgaTlI7Qqcu8Lwug+AV/hWkG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sya0l82c; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sya0l82c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pdCawEmuLWYqoZ6PyVVzOB+K0ySBdLGnJMGBT8c9lF4=; b=sya0l82cQQYxfAHsHrklV/81Ym
	CdZhkPtElCV1DWR7IKhNdErZhBRX8j17/j4VrjfgTpvR9A3sUaWu10zlJ46DZ7Wn9fp6feFyR/awE
	89pCW293MGrdMpq9ySKhzgwx8oI2YH78WUaZt0Sj8zYrYZguO//we+vRaNPQTOZD+zgyF5NHPsZ4D
	mXVZCtHl9/AJs2mxn2XVaHkxYeih59sKKEYdpZqzqXJkJMAXCl9uxONX2hHNOXdwtQ4oDHnluthRZ
	sfIFYqYuVRME6j7LmMAdsMtnGkxHiwBdaPvkNPY+z4MOxeCxquYNorkfwjs62iW5DUGKI9FiudDKh
	I4op8BZg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tpmnp-00000005Ncm-3lnK;
	Wed, 05 Mar 2025 11:20:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0DA7430049D; Wed,  5 Mar 2025 12:20:41 +0100 (CET)
Date: Wed, 5 Mar 2025 12:20:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
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
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 00/34] Compiler-Based Capability- and Locking-Analysis
Message-ID: <20250305112041.GA16878@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-1-elver@google.com>



Right, so since this is all awesome, I figured I should try and have it
compile kernel/sched/, see how far I get.

I know I can't use the __guarded_by() things, they're just too primitive
for that I need, but I figured I should try and have it track the
lock/unlock thingies at least.

I've had to rework how the GUARD bits work, since some guards are
defined on objects that contain locks, rather than the locks themselves.

We've also had discussions on IRQ on all the things I've ran across,
like needing to be able to reference the return object for things like:

  struct sighand_struct *
  lock_task_sighand(struct task_struct *task, unsigned long *flags)
  	__cond_acquires(nonnull, return->siglock);

The patch below tried working around that by doing:

	__cond_acquires(nonnull, task->sighand->siglock)

But I'm not quite sure it does the right thing, and definitely doesn't
always work for other such cases. Notably, I've managed to ICE clang
(send you the details).

This is on top of queue.git/locking/core, but I imagine that tree won't
live very long at those point.

It is basically tip/locking/core with your patches ran through:

  sed -e 's/__acquire/__assume/g'

before applying them.

---
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..d27607d9c2dc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -945,6 +945,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
  */
 static inline struct queue_limits
 queue_limits_start_update(struct request_queue *q)
+	__acquires(q->limits_lock)
 {
 	mutex_lock(&q->limits_lock);
 	return q->limits;
@@ -965,6 +966,7 @@ int blk_validate_limits(struct queue_limits *lim);
  * starting update.
  */
 static inline void queue_limits_cancel_update(struct request_queue *q)
+	__releases(q->limits_lock)
 {
 	mutex_unlock(&q->limits_lock);
 }
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f3f50e29d639..2b6d8cc1f144 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2196,6 +2196,7 @@ bpf_prog_run_array(const struct bpf_prog_array *array,
 static __always_inline u32
 bpf_prog_run_array_uprobe(const struct bpf_prog_array *array,
 			  const void *ctx, bpf_prog_run_fn run_prog)
+	__no_capability_analysis /* too stupid for cond rcu lock */
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8ef47f8a634..cbda68703858 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -364,11 +364,13 @@ static inline void cgroup_put(struct cgroup *cgrp)
 extern struct mutex cgroup_mutex;
 
 static inline void cgroup_lock(void)
+	__acquires(cgroup_mutex)
 {
 	mutex_lock(&cgroup_mutex);
 }
 
 static inline void cgroup_unlock(void)
+	__releases(cgroup_mutex)
 {
 	mutex_unlock(&cgroup_mutex);
 }
diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 2ce479b1873e..69da4f20ec57 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -249,12 +249,13 @@ static inline _type class_##_name##_constructor(_init_args)		\
 	__no_capability_analysis					\
 { _type t = _init; return t; }
 
-#define EXTEND_CLASS(_name, ext, ctor_attrs, _init, _init_args...)		\
+#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+typedef lock_##_name##_t lock_##_name##ext##_t;				\
 typedef class_##_name##_t class_##_name##ext##_t;			\
 static inline void class_##_name##ext##_destructor(class_##_name##_t *p)\
 { class_##_name##_destructor(p); }					\
 static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
-	__no_capability_analysis ctor_attrs					\
+	__no_capability_analysis \
 { class_##_name##_t t = _init; return t; }
 
 #define CLASS(_name, var)						\
@@ -302,7 +303,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
-	EXTEND_CLASS(_name, _ext,, \
+	EXTEND_CLASS(_name, _ext, \
 		     ({ void *_t = _T; if (_T && !(_condlock)) _t = NULL; _t; }), \
 		     class_##_name##_t _T) \
 	static inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
@@ -368,6 +369,7 @@ _label:									\
  */
 
 #define __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, ...)		\
+typedef _type lock_##_name##_t;						\
 typedef struct {							\
 	_type *lock;							\
 	__VA_ARGS__;							\
@@ -387,7 +389,7 @@ static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
 static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
-	__no_capability_analysis __assumes_cap(l)			\
+	__no_capability_analysis 					\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
 	_lock;								\
@@ -408,6 +410,10 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
 static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
 static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock
 
+#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock
+
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
@@ -420,7 +426,7 @@ __DEFINE_LOCK_GUARD_0(_name, _lock)
 
 #define DEFINE_LOCK_GUARD_1_COND(_name, _ext, _condlock)		\
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true);		\
-	EXTEND_CLASS(_name, _ext, __assumes_cap(l),			\
+	EXTEND_CLASS(_name, _ext, 					\
 		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
 		        if (_T->lock && !(_condlock)) _T->lock = NULL;	\
 			_t; }),						\
@@ -428,5 +434,4 @@ __DEFINE_LOCK_GUARD_0(_name, _lock)
 	static inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
 	{ return class_##_name##_lock_ptr(_T); }
 
-
 #endif /* _LINUX_CLEANUP_H */
diff --git a/include/linux/device.h b/include/linux/device.h
index 80a5b3268986..283fb85d96c8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1026,21 +1026,25 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
 }
 
 static inline void device_lock(struct device *dev)
+	__acquires(dev->mutex)
 {
 	mutex_lock(&dev->mutex);
 }
 
 static inline int device_lock_interruptible(struct device *dev)
+	__cond_acquires(0, dev->mutex)
 {
 	return mutex_lock_interruptible(&dev->mutex);
 }
 
 static inline int device_trylock(struct device *dev)
+	__cond_acquires(true, dev->mutex)
 {
 	return mutex_trylock(&dev->mutex);
 }
 
 static inline void device_unlock(struct device *dev)
+	__releases(dev->mutex)
 {
 	mutex_unlock(&dev->mutex);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2c3b2f8a621f..52b69fed3e65 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -540,31 +540,37 @@ static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
 }
 
 static inline void i_mmap_lock_write(struct address_space *mapping)
+	__acquires(mapping->i_mmap_rwsem)
 {
 	down_write(&mapping->i_mmap_rwsem);
 }
 
 static inline int i_mmap_trylock_write(struct address_space *mapping)
+	__cond_acquires(true, mapping->i_mmap_rwsem)
 {
 	return down_write_trylock(&mapping->i_mmap_rwsem);
 }
 
 static inline void i_mmap_unlock_write(struct address_space *mapping)
+	__releases(mapping->i_mmap_rwsem)
 {
 	up_write(&mapping->i_mmap_rwsem);
 }
 
 static inline int i_mmap_trylock_read(struct address_space *mapping)
+	__cond_acquires_shared(true, mapping->i_mmap_rwsem)
 {
 	return down_read_trylock(&mapping->i_mmap_rwsem);
 }
 
 static inline void i_mmap_lock_read(struct address_space *mapping)
+	__acquires_shared(mapping->i_mmap_rwsem)
 {
 	down_read(&mapping->i_mmap_rwsem);
 }
 
 static inline void i_mmap_unlock_read(struct address_space *mapping)
+	__releases_shared(mapping->i_mmap_rwsem)
 {
 	up_read(&mapping->i_mmap_rwsem);
 }
@@ -873,31 +879,37 @@ enum inode_i_mutex_lock_class
 };
 
 static inline void inode_lock(struct inode *inode)
+	__acquires(inode->i_rwsem)
 {
 	down_write(&inode->i_rwsem);
 }
 
 static inline void inode_unlock(struct inode *inode)
+	__releases(inode->i_rwsem)
 {
 	up_write(&inode->i_rwsem);
 }
 
 static inline void inode_lock_shared(struct inode *inode)
+	__acquires_shared(inode->i_rwsem)
 {
 	down_read(&inode->i_rwsem);
 }
 
 static inline void inode_unlock_shared(struct inode *inode)
+	__releases_shared(inode->i_rwsem)
 {
 	up_read(&inode->i_rwsem);
 }
 
 static inline int inode_trylock(struct inode *inode)
+	__cond_acquires(true, inode->i_rwsem)
 {
 	return down_write_trylock(&inode->i_rwsem);
 }
 
 static inline int inode_trylock_shared(struct inode *inode)
+	__cond_acquires_shared(true, inode->i_rwsem)
 {
 	return down_read_trylock(&inode->i_rwsem);
 }
@@ -908,38 +920,45 @@ static inline int inode_is_locked(struct inode *inode)
 }
 
 static inline void inode_lock_nested(struct inode *inode, unsigned subclass)
+	__acquires(inode->i_rwsem)
 {
 	down_write_nested(&inode->i_rwsem, subclass);
 }
 
 static inline void inode_lock_shared_nested(struct inode *inode, unsigned subclass)
+	__acquires_shared(inode->i_rwsem)
 {
 	down_read_nested(&inode->i_rwsem, subclass);
 }
 
 static inline void filemap_invalidate_lock(struct address_space *mapping)
+	__acquires(mapping->invalidate_lock)
 {
 	down_write(&mapping->invalidate_lock);
 }
 
 static inline void filemap_invalidate_unlock(struct address_space *mapping)
+	__releases(mapping->invalidate_lock)
 {
 	up_write(&mapping->invalidate_lock);
 }
 
 static inline void filemap_invalidate_lock_shared(struct address_space *mapping)
+	__acquires_shared(mapping->invalidate_lock)
 {
 	down_read(&mapping->invalidate_lock);
 }
 
 static inline int filemap_invalidate_trylock_shared(
 					struct address_space *mapping)
+	__cond_acquires_shared(true, mapping->invalidate_lock)
 {
 	return down_read_trylock(&mapping->invalidate_lock);
 }
 
 static inline void filemap_invalidate_unlock_shared(
 					struct address_space *mapping)
+	__releases_shared(mapping->invalidate_lock)
 {
 	up_read(&mapping->invalidate_lock);
 }
@@ -3873,6 +3892,7 @@ static inline bool dir_emit_dots(struct file *file, struct dir_context *ctx)
 	return true;
 }
 static inline bool dir_relax(struct inode *inode)
+	__releases(inode->i_rwsem) __acquires(inode->i_rwsem)
 {
 	inode_unlock(inode);
 	inode_lock(inode);
@@ -3880,6 +3900,7 @@ static inline bool dir_relax(struct inode *inode)
 }
 
 static inline bool dir_relax_shared(struct inode *inode)
+	__releases_shared(inode->i_rwsem) __acquires_shared(inode->i_rwsem)
 {
 	inode_unlock_shared(inode);
 	inode_lock_shared(inode);
diff --git a/include/linux/idr.h b/include/linux/idr.h
index da5f5fa4a3a6..c157f872240c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -170,6 +170,7 @@ static inline bool idr_is_empty(const struct idr *idr)
  * function.  See idr_preload() for details.
  */
 static inline void idr_preload_end(void)
+	__releases(radix_tree_preloads.lock)
 {
 	local_unlock(&radix_tree_preloads.lock);
 }
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8cd9327e4e78..74ef6df7549c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -236,8 +236,8 @@ extern void enable_percpu_irq(unsigned int irq, unsigned int type);
 extern bool irq_percpu_is_enabled(unsigned int irq);
 extern void irq_wake_thread(unsigned int irq, void *dev_id);
 
-DEFINE_LOCK_GUARD_1(disable_irq, int,
-		    disable_irq(*_T->lock), enable_irq(*_T->lock))
+DEFINE_GUARD(disable_irq, int,
+	     disable_irq(_T), enable_irq(_T));
 
 extern void disable_nmi_nosync(unsigned int irq);
 extern void disable_percpu_nmi(unsigned int irq);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6e74b8254d9b..9afbea99feea 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1512,17 +1512,20 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 }
 
 static inline void unlock_page_lruvec(struct lruvec *lruvec)
+	__releases(lruvec->lru_lock)
 {
 	spin_unlock(&lruvec->lru_lock);
 }
 
 static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+	__releases(lruvec->lru_lock)
 {
 	spin_unlock_irq(&lruvec->lru_lock);
 }
 
 static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
-		unsigned long flags)
+						 unsigned long flags)
+	__releases(lruvec->lru_lock)
 {
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
@@ -1537,7 +1540,8 @@ static inline bool folio_matches_lruvec(struct folio *folio,
 
 /* Don't lock again iff page's lruvec locked */
 static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
-		struct lruvec *locked_lruvec)
+						     struct lruvec *locked_lruvec)
+	__no_capability_analysis /* no __cond_releases */
 {
 	if (locked_lruvec) {
 		if (folio_matches_lruvec(folio, locked_lruvec))
@@ -1551,7 +1555,9 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 
 /* Don't lock again iff folio's lruvec locked */
 static inline void folio_lruvec_relock_irqsave(struct folio *folio,
-		struct lruvec **lruvecp, unsigned long *flags)
+					       struct lruvec **lruvecp, 
+					       unsigned long *flags)
+	__no_capability_analysis
 {
 	if (*lruvecp) {
 		if (folio_matches_lruvec(folio, *lruvecp))
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index eaac5ae8c05c..aebdcaa83b86 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -99,18 +99,22 @@ bool mhp_supports_memmap_on_memory(void);
  * can't be changed while pgdat_resize_lock() held.
  */
 static inline unsigned zone_span_seqbegin(struct zone *zone)
+	__acquires_shared(zone->span_seqlock)
 {
 	return read_seqbegin(&zone->span_seqlock);
 }
 static inline int zone_span_seqretry(struct zone *zone, unsigned iv)
+	__releases_shared(zone->span_seqlock)
 {
 	return read_seqretry(&zone->span_seqlock, iv);
 }
 static inline void zone_span_writelock(struct zone *zone)
+	__acquires(zone->span_seqlock)
 {
 	write_seqlock(&zone->span_seqlock);
 }
 static inline void zone_span_writeunlock(struct zone *zone)
+	__releases(zone->span_seqlock)
 {
 	write_sequnlock(&zone->span_seqlock);
 }
@@ -178,11 +182,13 @@ void mem_hotplug_done(void);
 
 /* See kswapd_is_running() */
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat)
+	__acquires(pgdat->kswapd_lock)
 {
 	mutex_lock(&pgdat->kswapd_lock);
 }
 
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat)
+	__releases(pgdat->kswapd_lock)
 {
 	mutex_unlock(&pgdat->kswapd_lock);
 }
@@ -252,11 +258,13 @@ struct range arch_get_mappable_range(void);
  */
 static inline
 void pgdat_resize_lock(struct pglist_data *pgdat, unsigned long *flags)
+	__acquires(pgdat->node_size_lock)
 {
 	spin_lock_irqsave(&pgdat->node_size_lock, *flags);
 }
 static inline
 void pgdat_resize_unlock(struct pglist_data *pgdat, unsigned long *flags)
+	__releases(pgdat->node_size_lock)
 {
 	spin_unlock_irqrestore(&pgdat->node_size_lock, *flags);
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dbf4eb414bd1..3979b6546082 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -703,6 +703,7 @@ static inline void vma_numab_state_free(struct vm_area_struct *vma) {}
  * using mmap_lock. The function should never yield false unlocked result.
  */
 static inline bool vma_start_read(struct vm_area_struct *vma)
+	__cond_acquires_shared(true, vma->vm_lock->lock)
 {
 	/*
 	 * Check before locking. A race might cause false locked result.
@@ -736,6 +737,7 @@ static inline bool vma_start_read(struct vm_area_struct *vma)
 }
 
 static inline void vma_end_read(struct vm_area_struct *vma)
+	__releases_shared(vma->vm_lock->lock)
 {
 	rcu_read_lock(); /* keeps vma alive till the end of up_read */
 	up_read(&vma->vm_lock->lock);
@@ -800,6 +802,7 @@ static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
 }
 
 static inline void release_fault_lock(struct vm_fault *vmf)
+	__no_capability_analysis
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
 		vma_end_read(vmf->vma);
@@ -3016,7 +3019,8 @@ static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 	return true;
 }
 
-pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
+pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
+	__cond_acquires_shared(nonnull, RCU);
 
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
@@ -3092,6 +3096,7 @@ static inline bool pmd_ptlock_init(struct ptdesc *ptdesc) { return true; }
 #endif
 
 static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
+	__no_capability_analysis
 {
 	spinlock_t *ptl = pmd_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3119,6 +3124,7 @@ static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
 }
 
 static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
+	__no_capability_analysis
 {
 	spinlock_t *ptl = pud_lockptr(mm, pud);
 
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 45a21faa3ff6..17aa837362ae 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -129,6 +129,7 @@ static inline void mmap_init_lock(struct mm_struct *mm)
 }
 
 static inline void mmap_write_lock(struct mm_struct *mm)
+	__acquires(mm->mmap_lock)
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write(&mm->mmap_lock);
@@ -137,6 +138,7 @@ static inline void mmap_write_lock(struct mm_struct *mm)
 }
 
 static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
+	__acquires(mm->mmap_lock)
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write_nested(&mm->mmap_lock, subclass);
@@ -145,6 +147,7 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 }
 
 static inline int mmap_write_lock_killable(struct mm_struct *mm)
+	__cond_acquires(0, mm->mmap_lock)
 {
 	int ret;
 
@@ -171,6 +174,7 @@ static inline void vma_end_write_all(struct mm_struct *mm)
 }
 
 static inline void mmap_write_unlock(struct mm_struct *mm)
+	__releases(mm->mmap_lock)
 {
 	__mmap_lock_trace_released(mm, true);
 	vma_end_write_all(mm);
@@ -178,6 +182,7 @@ static inline void mmap_write_unlock(struct mm_struct *mm)
 }
 
 static inline void mmap_write_downgrade(struct mm_struct *mm)
+	__releases(mm->mmap_lock) __acquires_shared(mm->mmap_lock)
 {
 	__mmap_lock_trace_acquire_returned(mm, false, true);
 	vma_end_write_all(mm);
@@ -185,6 +190,7 @@ static inline void mmap_write_downgrade(struct mm_struct *mm)
 }
 
 static inline void mmap_read_lock(struct mm_struct *mm)
+	__acquires_shared(mm->mmap_lock)
 {
 	__mmap_lock_trace_start_locking(mm, false);
 	down_read(&mm->mmap_lock);
@@ -192,6 +198,7 @@ static inline void mmap_read_lock(struct mm_struct *mm)
 }
 
 static inline int mmap_read_lock_killable(struct mm_struct *mm)
+	__cond_acquires_shared(0, mm->mmap_lock)
 {
 	int ret;
 
@@ -202,6 +209,7 @@ static inline int mmap_read_lock_killable(struct mm_struct *mm)
 }
 
 static inline bool mmap_read_trylock(struct mm_struct *mm)
+	__cond_acquires_shared(true, mm->mmap_lock)
 {
 	bool ret;
 
@@ -212,12 +220,14 @@ static inline bool mmap_read_trylock(struct mm_struct *mm)
 }
 
 static inline void mmap_read_unlock(struct mm_struct *mm)
+	__releases_shared(mm->mmap_lock)
 {
 	__mmap_lock_trace_released(mm, false);
 	up_read(&mm->mmap_lock);
 }
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
+	__releases_shared(mm->mmap_lock)
 {
 	__mmap_lock_trace_released(mm, false);
 	up_read_non_owner(&mm->mmap_lock);
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index d653692078ad..4b1f794f58a6 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -203,4 +203,8 @@ DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->
 DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
 DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock) == 0)
 
+DECLARE_LOCK_GUARD_1_ATTRS(mutex, __assumes_cap(_T), /* */);
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try, __assumes_cap(_T), /* */);
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr, __assumes_cap(_T), /* */);
+
 #endif /* __LINUX_MUTEX_H */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 94d267d02372..9f5841f1e0bd 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -132,6 +132,7 @@ static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
 	return pte_offset_kernel(pmd, address);
 }
 static inline void pte_unmap(pte_t *pte)
+	__releases_shared(RCU)
 {
 	rcu_read_unlock();
 }
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index eae67015ce51..46771d36af34 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -236,7 +236,7 @@ void *radix_tree_delete(struct radix_tree_root *, unsigned long);
 unsigned int radix_tree_gang_lookup(const struct radix_tree_root *,
 			void **results, unsigned long first_index,
 			unsigned int max_items);
-int radix_tree_preload(gfp_t gfp_mask);
+int radix_tree_preload(gfp_t gfp_mask) __acquires(radix_tree_preloads.lock);
 int radix_tree_maybe_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *,
@@ -256,6 +256,7 @@ unsigned int radix_tree_gang_lookup_tag_slot(const struct radix_tree_root *,
 int radix_tree_tagged(const struct radix_tree_root *, unsigned int tag);
 
 static inline void radix_tree_preload_end(void)
+	__releases(radix_tree_preloads.lock)
 {
 	local_unlock(&radix_tree_preloads.lock);
 }
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 82c486b67e92..ecb7b2fd8381 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -733,10 +733,12 @@ static inline int thread_group_empty(struct task_struct *p)
 		(thread_group_leader(p) && !thread_group_empty(p))
 
 extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
-						unsigned long *flags);
+						unsigned long *flags)
+	__cond_acquires(nonnull, task->sighand->siglock);
 
 static inline void unlock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
+	__releases(task->sighand->siglock)
 {
 	spin_unlock_irqrestore(&task->sighand->siglock, *flags);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ca1db4b92c32..d215d42449b2 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -226,11 +226,13 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * neither inside nor outside.
  */
 static inline void task_lock(struct task_struct *p)
+	__acquires(p->alloc_lock)
 {
 	spin_lock(&p->alloc_lock);
 }
 
 static inline void task_unlock(struct task_struct *p)
+	__releases(p->alloc_lock)
 {
 	spin_unlock(&p->alloc_lock);
 }
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
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index d05ed91de15f..ec7abf93fad9 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -359,11 +359,13 @@ static __always_inline int spin_trylock(spinlock_t *lock)
 #define spin_lock_nested(lock, subclass)			\
 do {								\
 	raw_spin_lock_nested(spinlock_check(lock), subclass);	\
+	__release(spinlock_check(lock)); __acquire(lock);	\
 } while (0)
 
 #define spin_lock_nest_lock(lock, nest_lock)				\
 do {									\
 	raw_spin_lock_nest_lock(spinlock_check(lock), nest_lock);	\
+	__release(spinlock_check(lock)); __acquire(lock);	\
 } while (0)
 
 static __always_inline void spin_lock_irq(spinlock_t *lock)
@@ -535,73 +537,92 @@ void free_bucket_spinlocks(spinlock_t *locks);
 DEFINE_LOCK_GUARD_1(raw_spinlock, raw_spinlock_t,
 		    raw_spin_lock(_T->lock),
 		    raw_spin_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(raw_spinlock, _try, raw_spin_trylock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(raw_spinlock_nested, raw_spinlock_t,
 		    raw_spin_lock_nested(_T->lock, SINGLE_DEPTH_NESTING),
 		    raw_spin_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_nested, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(raw_spinlock_irq, raw_spinlock_t,
 		    raw_spin_lock_irq(_T->lock),
 		    raw_spin_unlock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_irq, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irq, _try, raw_spin_trylock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_irq_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(raw_spinlock_irqsave, raw_spinlock_t,
 		    raw_spin_lock_irqsave(_T->lock, _T->flags),
 		    raw_spin_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_irqsave, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irqsave, _try,
 			 raw_spin_trylock_irqsave(_T->lock, _T->flags))
+DECLARE_LOCK_GUARD_1_ATTRS(raw_spinlock_irqsave_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(spinlock, spinlock_t,
 		    spin_lock(_T->lock),
 		    spin_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(spinlock, _try, spin_trylock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(spinlock_irq, spinlock_t,
 		    spin_lock_irq(_T->lock),
 		    spin_unlock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_irq, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(spinlock_irq, _try,
 			 spin_trylock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_irq_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(spinlock_irqsave, spinlock_t,
 		    spin_lock_irqsave(_T->lock, _T->flags),
 		    spin_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_irqsave, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1_COND(spinlock_irqsave, _try,
 			 spin_trylock_irqsave(_T->lock, _T->flags))
+DECLARE_LOCK_GUARD_1_ATTRS(spinlock_irqsave_try, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(read_lock, rwlock_t,
 		    read_lock(_T->lock),
 		    read_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(read_lock, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(read_lock_irq, rwlock_t,
 		    read_lock_irq(_T->lock),
 		    read_unlock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(read_lock_irq, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(read_lock_irqsave, rwlock_t,
 		    read_lock_irqsave(_T->lock, _T->flags),
 		    read_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
+DECLARE_LOCK_GUARD_1_ATTRS(read_lock_irqsave, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(write_lock, rwlock_t,
 		    write_lock(_T->lock),
 		    write_unlock(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(write_lock, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(write_lock_irq, rwlock_t,
 		    write_lock_irq(_T->lock),
 		    write_unlock_irq(_T->lock))
+DECLARE_LOCK_GUARD_1_ATTRS(write_lock_irq, __assumes_cap(_T), /* */);
 
 DEFINE_LOCK_GUARD_1(write_lock_irqsave, rwlock_t,
 		    write_lock_irqsave(_T->lock, _T->flags),
 		    write_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
+DECLARE_LOCK_GUARD_1_ATTRS(write_lock_irqsave, __assumes_cap(_T), /* */);
 
 #undef __LINUX_INSIDE_SPINLOCK_H
 #endif /* __LINUX_SPINLOCK_H */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b93c8c3dc05a..c3a1beaafdb6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1512,28 +1512,37 @@ static inline void lockdep_assert_rq_held(struct rq *rq)
 	lockdep_assert_held(__rq_lockp(rq));
 }
 
-extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass);
-extern bool raw_spin_rq_trylock(struct rq *rq);
-extern void raw_spin_rq_unlock(struct rq *rq);
+extern void raw_spin_rq_lock_nested(struct rq *rq, int subclass)
+	__acquires(rq->__lock);
+	
+extern bool raw_spin_rq_trylock(struct rq *rq)
+	__cond_acquires(true, rq->__lock);
+
+extern void raw_spin_rq_unlock(struct rq *rq)
+	__releases(rq->__lock);
 
 static inline void raw_spin_rq_lock(struct rq *rq)
+	__acquires(rq->__lock)
 {
 	raw_spin_rq_lock_nested(rq, 0);
 }
 
 static inline void raw_spin_rq_lock_irq(struct rq *rq)
+	__acquires(rq->__lock)
 {
 	local_irq_disable();
 	raw_spin_rq_lock(rq);
 }
 
 static inline void raw_spin_rq_unlock_irq(struct rq *rq)
+	__releases(rq->__lock)
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_enable();
 }
 
 static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
+	__acquires(rq->__lock)
 {
 	unsigned long flags;
 
@@ -1544,6 +1553,7 @@ static inline unsigned long _raw_spin_rq_lock_irqsave(struct rq *rq)
 }
 
 static inline void raw_spin_rq_unlock_irqrestore(struct rq *rq, unsigned long flags)
+	__releases(rq->__lock)
 {
 	raw_spin_rq_unlock(rq);
 	local_irq_restore(flags);
@@ -1803,15 +1813,14 @@ static inline void rq_repin_lock(struct rq *rq, struct rq_flags *rf)
 
 extern
 struct rq *__task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(rq->lock);
+	__acquires(task_rq(p)->__lock) /* ICEs clang!!, wants to be: return->__lock */
 
 extern
 struct rq *task_rq_lock(struct task_struct *p, struct rq_flags *rf)
-	__acquires(p->pi_lock)
-	__acquires(rq->lock);
+	__acquires(p->pi_lock);
 
 static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1819,7 +1828,7 @@ static inline void __task_rq_unlock(struct rq *rq, struct rq_flags *rf)
 
 static inline void
 task_rq_unlock(struct rq *rq, struct task_struct *p, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(rq->__lock)
 	__releases(p->pi_lock)
 {
 	rq_unpin_lock(rq, rf);
@@ -1832,43 +1841,45 @@ DEFINE_LOCK_GUARD_1(task_rq_lock, struct task_struct,
 		    task_rq_unlock(_T->rq, _T->lock, &_T->rf),
 		    struct rq *rq; struct rq_flags rf)
 
+DECLARE_LOCK_GUARD_1_ATTRS(task_rq_lock, __assumes_cap(_T->pi_lock), /* nothing */);
+
 static inline void rq_lock_irqsave(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(rq->__lock)
 {
 	raw_spin_rq_lock_irqsave(rq, rf->flags);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock_irq(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(rq->__lock)
 {
 	raw_spin_rq_lock_irq(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_lock(struct rq *rq, struct rq_flags *rf)
-	__acquires(rq->lock)
+	__acquires(rq->__lock)
 {
 	raw_spin_rq_lock(rq);
 	rq_pin_lock(rq, rf);
 }
 
 static inline void rq_unlock_irqrestore(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irqrestore(rq, rf->flags);
 }
 
 static inline void rq_unlock_irq(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock_irq(rq);
 }
 
 static inline void rq_unlock(struct rq *rq, struct rq_flags *rf)
-	__releases(rq->lock)
+	__releases(rq->__lock)
 {
 	rq_unpin_lock(rq, rf);
 	raw_spin_rq_unlock(rq);
@@ -1879,18 +1890,24 @@ DEFINE_LOCK_GUARD_1(rq_lock, struct rq,
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
 
+DECLARE_LOCK_GUARD_1_ATTRS(rq_lock_irqsave, __assumes_cap(_T->__lock), /* */);
+
 static inline struct rq *this_rq_lock_irq(struct rq_flags *rf)
-	__acquires(rq->lock)
+	__no_capability_analysis /* need return value */
 {
 	struct rq *rq;
 
@@ -2954,9 +2971,15 @@ static inline void double_rq_clock_clear_update(struct rq *rq1, struct rq *rq2)
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
@@ -2985,7 +3008,8 @@ static inline bool rq_order_less(struct rq *rq1, struct rq *rq2)
 	return rq1->cpu < rq2->cpu;
 }
 
-extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
+extern void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->__lock) __acquires(rq2->__lock);
 
 #ifdef CONFIG_PREEMPTION
 
@@ -2998,9 +3022,9 @@ extern void double_rq_lock(struct rq *rq1, struct rq *rq2);
  * also adds more overhead and therefore may reduce throughput.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__releases(this_rq->__lock)
+	__acquires(busiest->__lock)
+	__acquires(this_rq->__lock)
 {
 	raw_spin_rq_unlock(this_rq);
 	double_rq_lock(this_rq, busiest);
@@ -3017,9 +3041,9 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * regardless of entry order into the function.
  */
 static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
+	__releases(this_rq->__lock)
+	__acquires(busiest->__lock)
+	__acquires(this_rq->__lock)
 {
 	if (__rq_lockp(this_rq) == __rq_lockp(busiest) ||
 	    likely(raw_spin_rq_trylock(busiest))) {
@@ -3045,6 +3069,9 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
  */
 static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->__lock)
+	__acquires(this_rq->__lock)
+	__acquires(busiest->__lock)
 {
 	lockdep_assert_irqs_disabled();
 
@@ -3052,7 +3079,8 @@ static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 }
 
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
+	__releases(busiest->__lock)
+	__no_capability_analysis /* conditional code */
 {
 	if (__rq_lockp(this_rq) != __rq_lockp(busiest))
 		raw_spin_rq_unlock(busiest);
@@ -3060,6 +3088,8 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 }
 
 static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1)
+	__acquires(l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3069,6 +3099,8 @@ static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
+	__acquires(l1)
+	__acquires(l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3078,6 +3110,8 @@ static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
 }
 
 static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__acquires(l1)
+	__acquires(l2)
 {
 	if (l1 > l2)
 		swap(l1, l2);
@@ -3087,6 +3121,8 @@ static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
 }
 
 static inline void double_raw_unlock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+	__releases(l1)
+	__releases(l2)
 {
 	raw_spin_unlock(l1);
 	raw_spin_unlock(l2);
@@ -3096,6 +3132,8 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
 		    double_raw_lock(_T->lock, _T->lock2),
 		    double_raw_unlock(_T->lock, _T->lock2))
 
+DECLARE_LOCK_GUARD_2_ATTRS(double_raw_spinlock, __assumes_cap(_T1) __assumes_cap(_T2), /* */);
+
 /*
  * double_rq_unlock - safely unlock two runqueues
  *
@@ -3103,13 +3141,13 @@ DEFINE_LOCK_GUARD_2(double_raw_spinlock, raw_spinlock_t,
  * you need to do so manually after calling.
  */
 static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
+	__releases(rq1->__lock)
+	__releases(rq2->__lock)
 {
 	if (__rq_lockp(rq1) != __rq_lockp(rq2))
 		raw_spin_rq_unlock(rq2);
 	else
-		__release(rq2->lock);
+		__release_cap(&rq2->__lock);
 	raw_spin_rq_unlock(rq1);
 }
 
@@ -3127,8 +3165,8 @@ extern bool sched_smp_initialized;
  * you need to do so manually before calling.
  */
 static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
+	__acquires(rq1->__lock)
+	__acquires(rq2->__lock)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 	WARN_ON_ONCE(rq1 != rq2);
@@ -3144,8 +3182,8 @@ static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
  * you need to do so manually after calling.
  */
 static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
+	__releases(rq1->__lock)
+	__releases(rq2->__lock)
 {
 	WARN_ON_ONCE(rq1 != rq2);
 	raw_spin_rq_unlock(rq1);
