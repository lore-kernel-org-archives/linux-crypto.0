Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6452215F43
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865922; cv=none; b=XwDVZ9iSPJz/Tsmchc3QYzyT7hveHTEghH1ulzRSvVQm6oX8h8+jhonUAdnbXKBDIf3QFzSZK4aLPdnQsEBk11iIvycaUYzu5c81pQ3vL7L2dCd5utxoNDLti1+FELHmwN16aHBlhvZO4A639EoRaC4QzKOI4WPyety+ZFRuVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865922; c=relaxed/simple;
	bh=YJDtuAQrt10Gj5yTP5oP/HfXJALSbUnpY7JrPkCy+uE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FY+DwceaAzgDvqtNlVaB8BtiOyG6CWWdl73HGhIBmFzBvkHrno0UFv5otzXszVBRLuBJOSmzw2nRgPe1mn918NKixqgE4z1mWDZ0BwWqS1/WV9VM0L5DmIj4muOff4He84v+1FrUz9qYicFWA/hMY+251Ekg0RVYYaKdA3RzP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qd0cRgEV; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qd0cRgEV"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d90b88322aso1437683a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865919; x=1739470719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Q/r6EDjEaKBVCObAXq5d4B0c7MeKIT3YrYe1pikBVY=;
        b=qd0cRgEVC6zuPxo6FpV/WeD4RxHIEp7+/BfhnjUJ2Mm2duAP6e8wU7uQxcVCzFw22E
         R1woPR1J/0KDF+NbWsut8ViICdx3HhJPtEoSnEOE6TUCZ4YjFNf1PmHwqVHt1a99mgqy
         BRe+5RVyFu+3hI+AanzV6rCLDi/cx4ubOJMN1DoJh+qPQS8ZSbQhl6Y41PCEnzqXmGnl
         WrG0iFjeyhPiCEVsdL07YSV6m9AC5BzzeXyTuJOGeXVVk9HZilcZfAm4cCBz+q8VZr84
         DYGLV4TVxd9U13sPGFveZLwA/o+R/5vkMQWZ3OQCgH1yVsaTnXeoon29UhKIyTZUboyX
         pJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865919; x=1739470719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Q/r6EDjEaKBVCObAXq5d4B0c7MeKIT3YrYe1pikBVY=;
        b=CFGnCBOTNG+THYwBevvvaO+GKZK+VjziCEaV9gGj8pblg+eDwFsShhl2R3Lpv3Kw5X
         o1AiTkFEui2t5889ZjIuofZS/efIrgd1DZZrDiya+w+BN900AeS3QrFzUSeF6M/qjMHy
         5sk10Y5a43pFvy5cQ16zQDcZPOLA9Bk/6sOfsEo3bgUFVX+JmtP+rljz1L1bsG+FY+7k
         5dQOd/HABr1v+MP8lzQzUcbQtPiVA91SmWlSb5L3Fxq+t4zedI+H5NOCFNRLf2S+AW6G
         gGNx5THb+RebzhZt2cUqCwVphoXODeSEABkHAt7nX5PPJnoNHnNMCHWnYo1Yrg23QWJr
         ND9w==
X-Forwarded-Encrypted: i=1; AJvYcCU5KefxyEO4N17CSpWbUR2s2an/6gmBe81M3YFdJMc32J/Q6IZTVWEyspSInrej3pjIttYCwxWtRHYiigs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww9oRs/F7FtFNH79nLt+ZUp04a/JA4dPhg+P7zlDaZHH6WwraA
	GcaHZh2SjAuEObp9gZ+ywaFSVLJRpPvusvri7F+9Zj/aSAlWA1+aICkJFCezdD8HtPvA6edo+w=
	=
X-Google-Smtp-Source: AGHT+IFMaBtqEK9sUYJXAvF7j4Xpi4+3px4oh9ewLScLsByAAKS4VeuOgIK+QXLT9+HMwjIVF5k6RoBd8Q==
X-Received: from edag6.prod.google.com ([2002:a05:6402:3206:b0:5de:3ce0:a49b])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3583:b0:5da:9d3:bc23
 with SMTP id 4fb4d7f45d1cf-5de4508a0b9mr436219a12.24.1738865919115; Thu, 06
 Feb 2025 10:18:39 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:15 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-22-elver@google.com>
Subject: [PATCH RFC 21/24] kfence: Enable capability analysis
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

Enable capability analysis for the KFENCE subsystem.

Notable, kfence_handle_page_fault() required minor restructure, which
also fixed a subtle race; arguably that function is more readable now.

Signed-off-by: Marco Elver <elver@google.com>
---
 mm/kfence/Makefile      |  2 ++
 mm/kfence/core.c        | 24 +++++++++++++++++-------
 mm/kfence/kfence.h      | 18 ++++++++++++------
 mm/kfence/kfence_test.c |  4 ++++
 mm/kfence/report.c      |  8 ++++++--
 5 files changed, 41 insertions(+), 15 deletions(-)

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
index 102048821c22..c2d1ffd20a1f 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -7,6 +7,8 @@
 
 #define pr_fmt(fmt) "kfence: " fmt
 
+disable_capability_analysis();
+
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
@@ -34,6 +36,8 @@
 
 #include <asm/kfence.h>
 
+enable_capability_analysis();
+
 #include "kfence.h"
 
 /* Disables KFENCE on the first warning assuming an irrecoverable error. */
@@ -132,8 +136,8 @@ struct kfence_metadata *kfence_metadata __read_mostly;
 static struct kfence_metadata *kfence_metadata_init __read_mostly;
 
 /* Freelist with available objects. */
-static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
-static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
+static struct list_head kfence_freelist __var_guarded_by(&kfence_freelist_lock) = LIST_HEAD_INIT(kfence_freelist);
 
 /*
  * The static key to set up a KFENCE allocation; or if static keys are not used
@@ -253,6 +257,7 @@ static bool kfence_unprotect(unsigned long addr)
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
+	__must_hold(&meta->lock)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
 	unsigned long pageaddr = (unsigned long)&__kfence_pool[offset];
@@ -288,6 +293,7 @@ static inline bool kfence_obj_allocated(const struct kfence_metadata *meta)
 static noinline void
 metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
 		      unsigned long *stack_entries, size_t num_stack_entries)
+	__must_hold(&meta->lock)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_ALLOCATED ? &meta->alloc_track : &meta->free_track;
@@ -485,7 +491,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	alloc_covered_add(alloc_stack_hash, 1);
 
 	/* Set required slab fields. */
-	slab = virt_to_slab((void *)meta->addr);
+	slab = virt_to_slab(addr);
 	slab->slab_cache = cache;
 	slab->objects = 1;
 
@@ -514,6 +520,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool zombie)
 {
 	struct kcsan_scoped_access assert_page_exclusive;
+	u32 alloc_stack_hash;
 	unsigned long flags;
 	bool init;
 
@@ -546,9 +553,10 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 	/* Mark the object as freed. */
 	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 	init = slab_want_init_on_free(meta->cache);
+	alloc_stack_hash = meta->alloc_stack_hash;
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
-	alloc_covered_add(meta->alloc_stack_hash, -1);
+	alloc_covered_add(alloc_stack_hash, -1);
 
 	/* Check canary bytes for memory corruption. */
 	check_canary(meta);
@@ -593,6 +601,7 @@ static void rcu_guarded_free(struct rcu_head *h)
  * which partial initialization succeeded.
  */
 static unsigned long kfence_init_pool(void)
+	__no_capability_analysis
 {
 	unsigned long addr;
 	struct page *pages;
@@ -1192,6 +1201,7 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
+	unsigned long unprotected_page = 0;
 	enum kfence_error_type error_type;
 	unsigned long flags;
 
@@ -1225,9 +1235,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
-		to_report->unprotected_page = addr;
 		error_type = KFENCE_ERROR_OOB;
+		unprotected_page = addr;
 
 		/*
 		 * If the object was freed before we took the look we can still
@@ -1239,7 +1248,6 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 		if (!to_report)
 			goto out;
 
-		raw_spin_lock_irqsave(&to_report->lock, flags);
 		error_type = KFENCE_ERROR_UAF;
 		/*
 		 * We may race with __kfence_alloc(), and it is possible that a
@@ -1251,6 +1259,8 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
 out:
 	if (to_report) {
+		raw_spin_lock_irqsave(&to_report->lock, flags);
+		to_report->unprotected_page = unprotected_page;
 		kfence_report_error(addr, is_write, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index dfba5ea06b01..27829d70baf6 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -9,6 +9,8 @@
 #ifndef MM_KFENCE_KFENCE_H
 #define MM_KFENCE_KFENCE_H
 
+disable_capability_analysis();
+
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -16,6 +18,8 @@
 
 #include "../slab.h" /* for struct kmem_cache */
 
+enable_capability_analysis();
+
 /*
  * Get the canary byte pattern for @addr. Use a pattern that varies based on the
  * lower 3 bits of the address, to detect memory corruptions with higher
@@ -34,6 +38,8 @@
 /* Maximum stack depth for reports. */
 #define KFENCE_STACK_DEPTH 64
 
+extern raw_spinlock_t kfence_freelist_lock;
+
 /* KFENCE object states. */
 enum kfence_object_state {
 	KFENCE_OBJECT_UNUSED,		/* Object is unused. */
@@ -53,7 +59,7 @@ struct kfence_track {
 
 /* KFENCE metadata per guarded allocation. */
 struct kfence_metadata {
-	struct list_head list;		/* Freelist node; access under kfence_freelist_lock. */
+	struct list_head list __var_guarded_by(&kfence_freelist_lock);	/* Freelist node. */
 	struct rcu_head rcu_head;	/* For delayed freeing. */
 
 	/*
@@ -91,13 +97,13 @@ struct kfence_metadata {
 	 * In case of an invalid access, the page that was unprotected; we
 	 * optimistically only store one address.
 	 */
-	unsigned long unprotected_page;
+	unsigned long unprotected_page __var_guarded_by(&lock);
 
 	/* Allocation and free stack information. */
-	struct kfence_track alloc_track;
-	struct kfence_track free_track;
+	struct kfence_track alloc_track __var_guarded_by(&lock);
+	struct kfence_track free_track __var_guarded_by(&lock);
 	/* For updating alloc_covered on frees. */
-	u32 alloc_stack_hash;
+	u32 alloc_stack_hash __var_guarded_by(&lock);
 #ifdef CONFIG_MEMCG
 	struct slabobj_ext obj_exts;
 #endif
@@ -141,6 +147,6 @@ enum kfence_error_type {
 void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *regs,
 			 const struct kfence_metadata *meta, enum kfence_error_type type);
 
-void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta);
+void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta) __must_hold(&meta->lock);
 
 #endif /* MM_KFENCE_KFENCE_H */
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..67eca6e9a8de 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -11,6 +11,8 @@
  *         Marco Elver <elver@google.com>
  */
 
+disable_capability_analysis();
+
 #include <kunit/test.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
@@ -26,6 +28,8 @@
 
 #include <asm/kfence.h>
 
+enable_capability_analysis();
+
 #include "kfence.h"
 
 /* May be overridden by <asm/kfence.h>. */
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index 10e6802a2edf..bbee90d0034d 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2020, Google LLC.
  */
 
+disable_capability_analysis();
+
 #include <linux/stdarg.h>
 
 #include <linux/kernel.h>
@@ -22,6 +24,8 @@
 
 #include <asm/kfence.h>
 
+enable_capability_analysis();
+
 #include "kfence.h"
 
 /* May be overridden by <asm/kfence.h>. */
@@ -106,6 +110,7 @@ static int get_stack_skipnr(const unsigned long stack_entries[], int num_entries
 
 static void kfence_print_stack(struct seq_file *seq, const struct kfence_metadata *meta,
 			       bool show_alloc)
+	__must_hold(&meta->lock)
 {
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
@@ -207,8 +212,6 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
 		return;
 
-	if (meta)
-		lockdep_assert_held(&meta->lock);
 	/*
 	 * Because we may generate reports in printk-unfriendly parts of the
 	 * kernel, such as scheduler code, the use of printk() could deadlock.
@@ -263,6 +266,7 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 	stack_trace_print(stack_entries + skipnr, num_stack_entries - skipnr, 0);
 
 	if (meta) {
+		lockdep_assert_held(&meta->lock);
 		pr_err("\n");
 		kfence_print_object(NULL, meta);
 	}
-- 
2.48.1.502.g6dc24dfdaf-goog

