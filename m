Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74880204F88
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080383; cv=none; b=QrqZu9/GJAJTuOCnYdhZgJn6wAsqRsU9OsdhOKX7cnWSgUxUpXMwlXzqG3tQCjF3daZjBA6Q4DtB6sHz9luasD1MW5+cJTN7MTJid8DqLLasJGEk8oEePZ3vKSQAEFJtf3LWSGMR3XUuBC7gQeywP9AVjHZrrrCjQYAbaYLknNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080383; c=relaxed/simple;
	bh=RHFHyf594SW/59vIAAifexB1oy6CG72gKKADr/HTL+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J7BK0uy2kKWrNTPsgRvXF9qgw/nFVYvLYtzBcvoZzmn28kZoOBhL7HLIYt8ysX6rwpTSoJL2r1P2J8HIyVDw/sLyk8bL+QejAPc1g3/a46VJHiv5Q532sYjZA4b+cn/cHIeQyXPGhIG3+Kx9zf65eyx7UHnfaIpZCNwEyaxGwBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ui23uomT; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ui23uomT"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-abf497da6c4so386862466b.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080380; x=1741685180; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3v8nr6j5ymgBv8KDTOp6L+lQpjYSKF+JE+VajMZf96I=;
        b=ui23uomTQRH5Irn1upMTy28efjrWGu2blSVGPnYwbbAFgaKq37ur+vsb0CDXlRpIEX
         WmcpsCaN7OdfPttvp8BEErBMOskMVdXS5TC5EmyuDICf9Fpp7GtB+jQdQMu5q4T9PSjV
         N8zuZusY7PvKkhciQ9CppnCaO13R9ac6YMiuEPyi+9HZCVN1Vqcfa8HcKwBJ6nU/1zrG
         7WKxGHPHRAvESx7xFv/YKokGyIIVNxz9i0uz8J9YDQeUal78Y29a+M0heTWo6OSSbsHW
         FpRuKBND+P8Fm5KkkYazKgmPIUx8ETgEoGeZ8wqX84KNnOUXE4Gu6A4gD7C5migNtEXy
         eivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080380; x=1741685180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3v8nr6j5ymgBv8KDTOp6L+lQpjYSKF+JE+VajMZf96I=;
        b=CxAFA6sQGFKBUcI1ZgbGGYS2yCwPh9EpXfTFvk8GY9LtoCcmbSO+G8ohGyn7lzzbqc
         45DIqPbguKCe05N2+DYkowDULUlAxDMCqeOm2qoZg7u05tz70MdyAWponnEyBHGw8/F9
         SxgLFJa4rA5KztkB9wSbcaebWNZ/6vlwO4GJi7VoAsDqBlDjBdan2nVvCrlnYv0mpxFF
         fAQh4IeOmGhwIX73G3fPUc7ASCXPWo2gPoi+trvhwgfbNk6WUoGFeSUM3BjuRIcvAPQ1
         xc7gJcY9OIP1E170rPCSLUFM8+ZSlPU+l5q9JWZWDlNMGaUe7Ts5eSClEtUXwZz9o5a2
         s68Q==
X-Forwarded-Encrypted: i=1; AJvYcCVa8mMusQbE95wnDgCT9X9xsrRkH5x9KGXj6rK9/zz9AX0vByewzQyFhqhvk7P9fDBFJIvDI0ysdKnmLdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXakJ7iNnlfHVrptbc/LvoDzINZJIH3Vag/juV2yZPZzXoOlIx
	+Crl6+kUm1ipwFpvz99K1rLFWJ12zPSSQyCnJFWY7wgCrYsFmYGnFP33LNNG1jbbp2fuPtd4bQ=
	=
X-Google-Smtp-Source: AGHT+IEfigeOF/k7z7vk9qyF+DXgOFknckOxzZ17yq3U/m1fakPgh4OhR4E4S4uofnC24B3oKSKzOpTECQ==
X-Received: from ejctb24.prod.google.com ([2002:a17:907:8b98:b0:ac1:4149:808d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:1ca2:b0:abf:5d9b:8076
 with SMTP id a640c23a62f3a-abf5d9b8a4fmr1339937166b.33.1741080379689; Tue, 04
 Mar 2025 01:26:19 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:25 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-27-elver@google.com>
Subject: [PATCH v2 26/34] kfence: Enable capability analysis
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

Enable capability analysis for the KFENCE subsystem.

Notable, kfence_handle_page_fault() required minor restructure, which
also fixed a subtle race; arguably that function is more readable now.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove disable/enable_capability_analysis() around headers.
* Use __capability_unsafe() instead of __no_capability_analysis.
---
 mm/kfence/Makefile |  2 ++
 mm/kfence/core.c   | 20 +++++++++++++-------
 mm/kfence/kfence.h | 14 ++++++++------
 mm/kfence/report.c |  4 ++--
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/mm/kfence/Makefile b/mm/kfence/Makefile
index 2de2a58d11a1..b3640bdc3c69 100644
--- a/mm/kfence/Makefile
+++ b/mm/kfence/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CAPABILITY_ANALYSIS := y
+
 obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 102048821c22..f75c3c11c0be 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -132,8 +132,8 @@ struct kfence_metadata *kfence_metadata __read_mostly;
 static struct kfence_metadata *kfence_metadata_init __read_mostly;
 
 /* Freelist with available objects. */
-static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
-static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+static struct list_head kfence_freelist __guarded_by(&kfence_freelist_lock) = LIST_HEAD_INIT(kfence_freelist);
 
 /*
  * The static key to set up a KFENCE allocation; or if static keys are not used
@@ -253,6 +253,7 @@ static bool kfence_unprotect(unsigned long addr)
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
+	__must_hold(&meta->lock)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
 	unsigned long pageaddr = (unsigned long)&__kfence_pool[offset];
@@ -288,6 +289,7 @@ static inline bool kfence_obj_allocated(const struct kfence_metadata *meta)
 static noinline void
 metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
 		      unsigned long *stack_entries, size_t num_stack_entries)
+	__must_hold(&meta->lock)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_ALLOCATED ? &meta->alloc_track : &meta->free_track;
@@ -485,7 +487,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	alloc_covered_add(alloc_stack_hash, 1);
 
 	/* Set required slab fields. */
-	slab = virt_to_slab((void *)meta->addr);
+	slab = virt_to_slab(addr);
 	slab->slab_cache = cache;
 	slab->objects = 1;
 
@@ -514,6 +516,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool zombie)
 {
 	struct kcsan_scoped_access assert_page_exclusive;
+	u32 alloc_stack_hash;
 	unsigned long flags;
 	bool init;
 
@@ -546,9 +549,10 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 	/* Mark the object as freed. */
 	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 	init = slab_want_init_on_free(meta->cache);
+	alloc_stack_hash = meta->alloc_stack_hash;
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
-	alloc_covered_add(meta->alloc_stack_hash, -1);
+	alloc_covered_add(alloc_stack_hash, -1);
 
 	/* Check canary bytes for memory corruption. */
 	check_canary(meta);
@@ -593,6 +597,7 @@ static void rcu_guarded_free(struct rcu_head *h)
  * which partial initialization succeeded.
  */
 static unsigned long kfence_init_pool(void)
+	__capability_unsafe(/* constructor */)
 {
 	unsigned long addr;
 	struct page *pages;
@@ -1192,6 +1197,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
+	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
 	unsigned long flags;
 
@@ -1225,9 +1231,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
-		to_report->unprotected_page = addr;
 		error_type = KFENCE_ERROR_OOB;
+		unprotected_page = addr;
 
 		/*
 		 * If the object was freed before we took the look we can still
@@ -1239,7 +1244,6 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
 		error_type = KFENCE_ERROR_UAF;
 		/*
 		 * We may race with __kfence_alloc(), and it is possible that a
@@ -1251,6 +1255,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
 out:
 	if (to_report) {
+		raw_spin_lock_irqsave(&to_report->lock, flags);
+		to_report->unprotected_page = unprotected_page;
 		kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index dfba5ea06b01..f9caea007246 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -34,6 +34,8 @@
 /* Maximum stack depth for reports. */
 #define KFENCE_STACK_DEPTH 64
 
+extern raw_spinlock_t kfence_freelist_lock;
+
 /* KFENCE object states. */
 enum kfence_object_state {
 	KFENCE_OBJECT_UNUSED,		/* Object is unused. */
@@ -53,7 +55,7 @@ struct kfence_track {
 
 /* KFENCE metadata per guarded allocation. */
 struct kfence_metadata {
-	struct list_head list;		/* Freelist node; access under kfence_freelist_lock. */
+	struct list_head list __guarded_by(&kfence_freelist_lock);	/* Freelist node. */
 	struct rcu_head rcu_head;	/* For delayed freeing. */
 
 	/*
@@ -91,13 +93,13 @@ struct kfence_metadata {
 	 * In case of an invalid access, the page that was unprotected; we
 	 * optimistically only store one address.
 	 */
-	unsigned long unprotected_page;
+	unsigned long unprotected_page __guarded_by(&lock);
 
 	/* Allocation and free stack information. */
-	struct kfence_track alloc_track;
-	struct kfence_track free_track;
+	struct kfence_track alloc_track __guarded_by(&lock);
+	struct kfence_track free_track __guarded_by(&lock);
 	/* For updating alloc_covered on frees. */
-	u32 alloc_stack_hash;
+	u32 alloc_stack_hash __guarded_by(&lock);
 #ifdef CONFIG_MEMCG
 	struct slabobj_ext obj_exts;
 #endif
@@ -141,6 +143,6 @@ enum kfence_error_type {
 void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
 			 const struct kfence_metadata *meta, enum kfence_error_type type);
 
-void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta);
+void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta) __must_hold(&meta->lock);
 
 #endif /* MM_KFENCE_KFENCE_H */
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index 10e6802a2edf..787e87c26926 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -106,6 +106,7 @@ static int get_stack_skipnr(const unsigned long stack_entries[], int num_entries
 
 static void kfence_print_stack(struct seq_file *seq, const struct kfence_metadata *meta,
 			       bool show_alloc)
+	__must_hold(&meta->lock)
 {
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
@@ -207,8 +208,6 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
 		return;
 
-	if (meta)
-		lockdep_assert_held(&meta->lock);
 	/*
 	 * Because we may generate reports in printk-unfriendly parts of the
 	 * kernel, such as scheduler code, the use of printk() could deadlock.
@@ -263,6 +262,7 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	stack_trace_print(stack_entries + skipnr, num_stack_entries - skipnr, 0);
 
 	if (meta) {
+		lockdep_assert_held(&meta->lock);
 		pr_err("\n");
 		kfence_print_object(NULL, meta);
 	}
-- 
2.48.1.711.g2feabab25a-goog

