Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD215359FB4
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651645; cv=none; b=iL8Py1JMt7q0NvPxZjs4e68cvASn5NSiqDmE896TxaM9xsM6WQBFkmxj7ObSirZIxdfJpuZJPwC1PUKzVk6X5qxQRYz+beQtsMFBVid8ugHZTNl1mAjmPMnFXXJe4wjTRt457i0ItVOm+i89zOebenKZHOpqs8PBDEuEenl9TCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651645; c=relaxed/simple;
	bh=vcgTIJAFLrmtkKi4iJO6FAjVEZE8asCuoEljUE7/+E0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ILsj/yq81ZouQNz9FiuPBxlYdGXfJ4D1ZXQOXcbkwoWia2dkM/CXkjmpO3U9OhPjpALc3Kv8pAraVHO6NTf8OmcDJMrrsyGrCFZ1jdrRqPkFU2MnnWz9cB5+rfe9KalEqwNpU1lTx6R0K3j0csKoh1kYWUKQktXaYnyv2eXxMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vUqdG4pc; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vUqdG4pc"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso860648f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 07:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651620; x=1764256420; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcD6uieBoqcsyDkA1zkurf5hLc/pXwP1OAaVy3DV1GQ=;
        b=vUqdG4pcuLJBbByLZXUcGZYtTzHnSZelityX4UBduOrj1B2zIMmqP7K80hgefZpZz0
         OeFPhzl/NgFDJLPj0AiWyN0ubn8oHSJDUC60TIK8hLVjf+H2bdJ7uuwnN0OU8Mg7Uprd
         KK2JQ90csZY3t+lbwUDVXUGcfhg6a3TsrDLZxuq00ERiXP469NuPO0WuFf8JEsHnZfit
         /ypZVErtt8T8+NCBuFQBwclr6VwEMSbOGH81+vhgn783Yc8/vpHRxWJ/aV4iMTHChx91
         76qHw1EvklctJbHoZOwNgwk9DBMgYz4AD20bU4qWGnPOhkIAZtvXk2mxpc42YAJUscSN
         gJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651620; x=1764256420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcD6uieBoqcsyDkA1zkurf5hLc/pXwP1OAaVy3DV1GQ=;
        b=kjf1FW4P1kWBRCPnLAX8nuChaWnCTYwAoLeznRqzhBHNLCoCJMAvDNlyOXzOaU3cSx
         E1bU7yGjbsilR4wBBZbCL3+SeHOXrwMJeK3K8GV2YA1rLWSW2hXgIy9ymverBfHPmpbx
         0WPekGvKYkNXhYm4IkwnWBb3IgU3Ml/rh6dRZXnWoGGZUd4eUqtXscQh2jtfu/8Mu3Bl
         V3y3THS252tsUUIY22ovMO4IOiYrIlBigCtrzsD4VYOqON9biXdhpW6ryDG8tSv/Sj3i
         UhyW+nrheo/dQFzdnSxdq8IOB86w7KLjsC62QhpKMRYKvnNL8HX+XrreUlfqnkJ2hLk1
         UzUg==
X-Forwarded-Encrypted: i=1; AJvYcCVSQu3d1md9NVt2cgs9pZXR22RsNPE4aN9oQB9+DK2/gzWMM6D2bpZNZBo1SR22n9hqcp9TPriZQs4llvY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/p4CzPvqhCuccKMiCWF5FLCH0NDSZb/Ay0OsBIz7FuBHrdye+
	0wQqJC4P58J6Crky/ks3/nTpltWuyZkNfdWthkKSM7bAk5obbN3m/5kEfVc/v38UkdkNqwEjsqt
	wmw==
X-Google-Smtp-Source: AGHT+IH2phiGswjRxahv1kYcFFnsn5EpFBG5GTvKLIn0Gw3adW5QmNBoQt0gQRrs7c/SRmL4IrpsGmOf6A==
X-Received: from wrwn2.prod.google.com ([2002:a5d:67c2:0:b0:42b:349a:10f6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2002:b0:42b:3746:3b84
 with SMTP id ffacd0b85a97d-42cb9a6acd7mr3408354f8f.55.1763651619825; Thu, 20
 Nov 2025 07:13:39 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:53 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-29-elver@google.com>
Subject: [PATCH v4 28/35] kcov: Enable context analysis
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

Enable context analysis for the KCOV subsystem.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Fix new temporary variable type.
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 kernel/Makefile |  2 ++
 kernel/kcov.c   | 36 +++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 9fe722305c9b..82d49723904d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,6 +43,8 @@ KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
 KMSAN_SANITIZE_kcov.o := n
+
+CONTEXT_ANALYSIS_kcov.o := y
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 obj-y += sched/
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 6563141f5de9..6cbc6e2d8aee 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -55,13 +55,13 @@ struct kcov {
 	refcount_t		refcount;
 	/* The lock protects mode, size, area and t. */
 	spinlock_t		lock;
-	enum kcov_mode		mode;
+	enum kcov_mode		mode __guarded_by(&lock);
 	/* Size of arena (in long's). */
-	unsigned int		size;
+	unsigned int		size __guarded_by(&lock);
 	/* Coverage buffer shared with user space. */
-	void			*area;
+	void			*area __guarded_by(&lock);
 	/* Task for which we collect coverage, or NULL. */
-	struct task_struct	*t;
+	struct task_struct	*t __guarded_by(&lock);
 	/* Collecting coverage from remote (background) threads. */
 	bool			remote;
 	/* Size of remote area (in long's). */
@@ -391,6 +391,7 @@ void kcov_task_init(struct task_struct *t)
 }
 
 static void kcov_reset(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	kcov->t = NULL;
 	kcov->mode = KCOV_MODE_INIT;
@@ -400,6 +401,7 @@ static void kcov_reset(struct kcov *kcov)
 }
 
 static void kcov_remote_reset(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	int bkt;
 	struct kcov_remote *remote;
@@ -419,6 +421,7 @@ static void kcov_remote_reset(struct kcov *kcov)
 }
 
 static void kcov_disable(struct task_struct *t, struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	kcov_task_reset(t);
 	if (kcov->remote)
@@ -435,8 +438,11 @@ static void kcov_get(struct kcov *kcov)
 static void kcov_put(struct kcov *kcov)
 {
 	if (refcount_dec_and_test(&kcov->refcount)) {
-		kcov_remote_reset(kcov);
-		vfree(kcov->area);
+		/* Context-safety: no references left, object being destroyed. */
+		context_unsafe(
+			kcov_remote_reset(kcov);
+			vfree(kcov->area);
+		);
 		kfree(kcov);
 	}
 }
@@ -491,6 +497,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 	unsigned long size, off;
 	struct page *page;
 	unsigned long flags;
+	void *area;
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
@@ -499,10 +506,11 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 		res = -EINVAL;
 		goto exit;
 	}
+	area = kcov->area;
 	spin_unlock_irqrestore(&kcov->lock, flags);
 	vm_flags_set(vma, VM_DONTEXPAND);
 	for (off = 0; off < size; off += PAGE_SIZE) {
-		page = vmalloc_to_page(kcov->area + off);
+		page = vmalloc_to_page(area + off);
 		res = vm_insert_page(vma, vma->vm_start + off, page);
 		if (res) {
 			pr_warn_once("kcov: vm_insert_page() failed\n");
@@ -522,10 +530,10 @@ static int kcov_open(struct inode *inode, struct file *filep)
 	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
 	if (!kcov)
 		return -ENOMEM;
+	spin_lock_init(&kcov->lock);
 	kcov->mode = KCOV_MODE_DISABLED;
 	kcov->sequence = 1;
 	refcount_set(&kcov->refcount, 1);
-	spin_lock_init(&kcov->lock);
 	filep->private_data = kcov;
 	return nonseekable_open(inode, filep);
 }
@@ -556,6 +564,7 @@ static int kcov_get_mode(unsigned long arg)
  * vmalloc fault handling path is instrumented.
  */
 static void kcov_fault_in_area(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	unsigned long stride = PAGE_SIZE / sizeof(unsigned long);
 	unsigned long *area = kcov->area;
@@ -584,6 +593,7 @@ static inline bool kcov_check_handle(u64 handle, bool common_valid,
 
 static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 			     unsigned long arg)
+	__must_hold(&kcov->lock)
 {
 	struct task_struct *t;
 	unsigned long flags, unused;
@@ -814,6 +824,7 @@ static inline bool kcov_mode_enabled(unsigned int mode)
 }
 
 static void kcov_remote_softirq_start(struct task_struct *t)
+	__must_hold(&kcov_percpu_data.lock)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
@@ -831,6 +842,7 @@ static void kcov_remote_softirq_start(struct task_struct *t)
 }
 
 static void kcov_remote_softirq_stop(struct task_struct *t)
+	__must_hold(&kcov_percpu_data.lock)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 
@@ -896,10 +908,12 @@ void kcov_remote_start(u64 handle)
 	/* Put in kcov_remote_stop(). */
 	kcov_get(kcov);
 	/*
-	 * Read kcov fields before unlock to prevent races with
-	 * KCOV_DISABLE / kcov_remote_reset().
+	 * Read kcov fields before unlocking kcov_remote_lock to prevent races
+	 * with KCOV_DISABLE and kcov_remote_reset(); cannot acquire kcov->lock
+	 * here, because it might lead to deadlock given kcov_remote_lock is
+	 * acquired _after_ kcov->lock elsewhere.
 	 */
-	mode = kcov->mode;
+	mode = context_unsafe(kcov->mode);
 	sequence = kcov->sequence;
 	if (in_task()) {
 		size = kcov->remote_size;
-- 
2.52.0.rc1.455.g30608eb744-goog

