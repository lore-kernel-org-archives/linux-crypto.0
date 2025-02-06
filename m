Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4201EEA2F
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865899; cv=none; b=j7ozxaZaeZoyCiWMHlzeJwIxMys9fnQUNSDiAovBZDin0uwHlHCRpLUxiywT7iyTCaWAvwi2zKTvzSe4xwF/VPs53jCViM7HDktgmeWVNOGg8Cabs3qCjIU8R0FhmtZFo+dCP0xySloLUNtj24JuFjHWVODp8i7cGpukEBH/l4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865899; c=relaxed/simple;
	bh=95UjjvZYAJ9cKJ8gjbfWj4DkOEijxPrW0T7Wi8ukuEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LF3zAw2WtZ//jmJsU6DagjwTURhusDKOLKiR/fziZG/oqG8EIs1qcvk4hSBfiKC4Lpvojqr3FrmI33gLYCeY1kX9uMiu8i3q7O7Lf5SGCk04UMCn5Up8PCGGEnUyvNAQGMkR3amqgSk/YSB/1DGHpzvHsh/4lTiE3FCKgynzqk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ucGlPYLz; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ucGlPYLz"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5dcda2e3a36so1429085a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865896; x=1739470696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H4q+9WLE15qKddw85vlrIejrThq+pT1MCiLGjI1MaOU=;
        b=ucGlPYLzuYWB0CraFX2OjpjWpdB4bu9NDqabcfhP+UWfcLuMhr3qWcaJidrxOjYzga
         9bTSmF0Iqtp5U5wc4yuHQbKnB8phKqdCBMiPq9mzfnAXVQBV1AFO9PVRGdyf2s+6s/+a
         ny5YBXBOuyl45oC+VgRItCfVbAdie4EY2slL1QKlw4PzO23x829LwvMOHomwJGJUWNEl
         1HtX/S/+Ys/X6UBDGYxDu2xW28dO3BXOUDfgyfzhkkKpWuBZfyEXZUYgMjCG4UhRLLdv
         cJk1ZHP9bgDfeWEStflygtxndKUYpGZvxNQBlTLVH1WzbCVYyG5IgxYymUcXWkx/8sQF
         NoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865896; x=1739470696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4q+9WLE15qKddw85vlrIejrThq+pT1MCiLGjI1MaOU=;
        b=HqX6u3ee0uFg3az32NePouNx3nWEAmVe5x/s4JpTY818fGkGOJBfxFjIzCsOqCyjF+
         5/XNR8UX5h0eFR7n/rN2T1YPfD0M8t74qsrPggmV0rBJLGHCS1ULNAvDPyPHa0pG4Cuz
         qzoks2B1/K14xuZdUzw3Lh0Af7O+sK6DE1z9wZeesPUuawqhjcQcjOiUXWOmxWO+GAdW
         UhE9AZtetSZKgOM6BA8jViWuewDH3RtHJ8jo2wqDxyqbf1G2dVhh4/lIthB9dfzG8II3
         ZqSe24RDMl9QG21WcysCHwzpz5hBsAw9bTfQORhMeM2WYw6mmthRl2wVsNXCTY5nWMVW
         qLbA==
X-Forwarded-Encrypted: i=1; AJvYcCUJR+otk4xJlyNM6MlJyV7oZD/I+dB1g2Nez0Jv3D43EdjcH3AjGxy6nkeQRY2vzRIlVZN4QCw3ec15C74=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV++abbIX2px0x9XPVP2uOg7RDFyQ6emDPFL7VMskhhI1WfYme
	pt98DoB69vVRZrI9Kj3FgYk6M9BHEigBk+ozN5Oq35tmV0KUCVJ+dF3e3p6tm9ciPa/XtQge3w=
	=
X-Google-Smtp-Source: AGHT+IGPOkWYJqLoYHNLLbuzAos5k3kgWOVjs6Uc6epHSddM+3YDj7OblNI++rh3HnWy7IoUvZg6rTtpfQ==
X-Received: from edbin10.prod.google.com ([2002:a05:6402:208a:b0:5de:35d9:f60c])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:194b:b0:5db:f423:19c5
 with SMTP id 4fb4d7f45d1cf-5de44fea647mr545992a12.5.1738865896253; Thu, 06
 Feb 2025 10:18:16 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:06 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-13-elver@google.com>
Subject: [PATCH RFC 12/24] locking/seqlock: Support Clang's capability analysis
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

Add support for Clang's capability analysis for seqlock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/seqlock.h                       | 24 +++++++++++
 include/linux/seqlock_types.h                 |  5 ++-
 lib/test_capability-analysis.c                | 43 +++++++++++++++++++
 4 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 31f76e877be5..8d9336e91ce2 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -85,7 +85,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 5ce48eab7a2a..c914eb9714e9 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -816,6 +816,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
 	do {								\
 		spin_lock_init(&(sl)->lock);				\
 		seqcount_spinlock_init(&(sl)->seqcount, &(sl)->lock);	\
+		__assert_cap(sl);					\
 	} while (0)
 
 /**
@@ -832,6 +833,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
  * Return: count, to be passed to read_seqretry()
  */
 static inline unsigned read_seqbegin(const seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	return read_seqcount_begin(&sl->seqcount);
 }
@@ -848,6 +850,7 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
  * Return: true if a read section retry is required, else false
  */
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
+	__releases_shared(sl) __no_capability_analysis
 {
 	return read_seqcount_retry(&sl->seqcount, start);
 }
@@ -872,6 +875,7 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
  * _irqsave or _bh variants of this function instead.
  */
 static inline void write_seqlock(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -885,6 +889,7 @@ static inline void write_seqlock(seqlock_t *sl)
  * critical section of given seqlock_t.
  */
 static inline void write_sequnlock(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock(&sl->lock);
@@ -898,6 +903,7 @@ static inline void write_sequnlock(seqlock_t *sl)
  * other write side sections, can be invoked from softirq contexts.
  */
 static inline void write_seqlock_bh(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock_bh(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -912,6 +918,7 @@ static inline void write_seqlock_bh(seqlock_t *sl)
  * write_seqlock_bh().
  */
 static inline void write_sequnlock_bh(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_bh(&sl->lock);
@@ -925,6 +932,7 @@ static inline void write_sequnlock_bh(seqlock_t *sl)
  * other write sections, can be invoked from hardirq contexts.
  */
 static inline void write_seqlock_irq(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock_irq(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -938,12 +946,14 @@ static inline void write_seqlock_irq(seqlock_t *sl)
  * seqlock_t write side section opened with write_seqlock_irq().
  */
 static inline void write_sequnlock_irq(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -976,6 +986,7 @@ static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
  */
 static inline void
 write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irqrestore(&sl->lock, flags);
@@ -998,6 +1009,7 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
  * The opened read section must be closed with read_sequnlock_excl().
  */
 static inline void read_seqlock_excl(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock(&sl->lock);
 }
@@ -1007,6 +1019,7 @@ static inline void read_seqlock_excl(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock(&sl->lock);
 }
@@ -1021,6 +1034,7 @@ static inline void read_sequnlock_excl(seqlock_t *sl)
  * from softirq contexts.
  */
 static inline void read_seqlock_excl_bh(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock_bh(&sl->lock);
 }
@@ -1031,6 +1045,7 @@ static inline void read_seqlock_excl_bh(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_bh(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_bh(&sl->lock);
 }
@@ -1045,6 +1060,7 @@ static inline void read_sequnlock_excl_bh(seqlock_t *sl)
  * hardirq context.
  */
 static inline void read_seqlock_excl_irq(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock_irq(&sl->lock);
 }
@@ -1055,11 +1071,13 @@ static inline void read_seqlock_excl_irq(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_irq(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -1089,6 +1107,7 @@ static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
  */
 static inline void
 read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
@@ -1125,6 +1144,7 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
  * parameter of the next read_seqbegin_or_lock() iteration.
  */
 static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	if (!(*seq & 1))	/* Even */
 		*seq = read_seqbegin(lock);
@@ -1140,6 +1160,7 @@ static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
  * Return: true if a read section retry is required, false otherwise
  */
 static inline int need_seqretry(seqlock_t *lock, int seq)
+	__releases_shared(lock) __no_capability_analysis
 {
 	return !(seq & 1) && read_seqretry(lock, seq);
 }
@@ -1153,6 +1174,7 @@ static inline int need_seqretry(seqlock_t *lock, int seq)
  * with read_seqbegin_or_lock() and validated by need_seqretry().
  */
 static inline void done_seqretry(seqlock_t *lock, int seq)
+	__no_capability_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl(lock);
@@ -1180,6 +1202,7 @@ static inline void done_seqretry(seqlock_t *lock, int seq)
  */
 static inline unsigned long
 read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	unsigned long flags = 0;
 
@@ -1205,6 +1228,7 @@ read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
  */
 static inline void
 done_seqretry_irqrestore(seqlock_t *lock, int seq, unsigned long flags)
+	__no_capability_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl_irqrestore(lock, flags);
diff --git a/include/linux/seqlock_types.h b/include/linux/seqlock_types.h
index dfdf43e3fa3d..9775d6f1a234 100644
--- a/include/linux/seqlock_types.h
+++ b/include/linux/seqlock_types.h
@@ -81,13 +81,14 @@ SEQCOUNT_LOCKNAME(mutex,        struct mutex,    true,     mutex)
  *    - Comments on top of seqcount_t
  *    - Documentation/locking/seqlock.rst
  */
-typedef struct {
+struct_with_capability(seqlock) {
 	/*
 	 * Make sure that readers don't starve writers on PREEMPT_RT: use
 	 * seqcount_spinlock_t instead of seqcount_t. Check __SEQ_LOCK().
 	 */
 	seqcount_spinlock_t seqcount;
 	spinlock_t lock;
-} seqlock_t;
+};
+typedef struct seqlock seqlock_t;
 
 #endif /* __LINUX_SEQLOCK_TYPES_H */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 3410c04c2b76..1e4b90f76420 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -6,6 +6,7 @@
 
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
 /*
@@ -208,3 +209,45 @@ static void __used test_mutex_cond_guard(struct test_mutex_data *d)
 		d->counter++;
 	}
 }
+
+struct test_seqlock_data {
+	seqlock_t sl;
+	int counter __var_guarded_by(&sl);
+};
+
+static void __used test_seqlock_init(struct test_seqlock_data *d)
+{
+	seqlock_init(&d->sl);
+	d->counter = 0;
+}
+
+static void __used test_seqlock_reader(struct test_seqlock_data *d)
+{
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&d->sl);
+		(void)d->counter;
+	} while (read_seqretry(&d->sl, seq));
+}
+
+static void __used test_seqlock_writer(struct test_seqlock_data *d)
+{
+	unsigned long flags;
+
+	write_seqlock(&d->sl);
+	d->counter++;
+	write_sequnlock(&d->sl);
+
+	write_seqlock_irq(&d->sl);
+	d->counter++;
+	write_sequnlock_irq(&d->sl);
+
+	write_seqlock_bh(&d->sl);
+	d->counter++;
+	write_sequnlock_bh(&d->sl);
+
+	write_seqlock_irqsave(&d->sl, flags);
+	d->counter++;
+	write_sequnlock_irqrestore(&d->sl, flags);
+}
-- 
2.48.1.502.g6dc24dfdaf-goog

