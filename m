Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB0B21E0A8
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865927; cv=none; b=emQ6pVkrqYEiS8BqFIhgEJJHNM2nOG6twewTIYrDX1PCX3Td6kFjlR9/pX20Bwqe8JN4+QLhhNf0WqjGWN1Q8jgEYEpjBO7kIVzvKHQg3aQzrEqjcPj7/B5MGLXhmFk3JDCbQ5AP0ybNN53/jSZ7dLbd8Kosj2us06sggjaz3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865927; c=relaxed/simple;
	bh=7Rgf3ZTg3VDeZEL33luK3Fx0Q0AHhneR5A6+XhHvm/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mDl+SBquz6IZnf6h9ZjQ2hKsYutqbVBnipNzWCxQC2+eSm9pWwVIeFFdKyuP9He0PKOjf2L99M3C+jsXiVew3juuy3DkDsqALHN8pYtMxMdnvncM2Y8CHd9tTjLgSSncsPoqo4MbqiUpjpbLT70dWXv9vW2LX3/nup3Zrn+SI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7Kl4Ott; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7Kl4Ott"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ab77dd2c243so101702066b.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865924; x=1739470724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cTAbjs+ZIolkWTfm9mQklQQ/rgalTGxg3MlfIrb1brs=;
        b=v7Kl4OttnAV55cMlvUkZ5aQGf2nd8oWcJQwWpsC00unC40AFFcI3J2zTH//YakNiiL
         AENEgrq8jgJcnLxCfYte4KvOUr/GRObakLzcY4xaj11ceADB86GlQEfKkEtlZBWTbLa0
         2rsyGsBjkgLn8FAjR13ulvSogNi+okL83F7AOACjx02Q/nPawkiPka0ziPJvSDuk1oIy
         27LLd1hL7YLI5RmxbdMpCTtS9OWVrlAOr2ONO42ICEWqnmT+tc8Rw1yLN5UbuIAG2Ssb
         7x8TbBqQXLVujaFYLURyNQOrwFVUQPNQMR7tCM9tWodZwQrXIClrx2an7pAtv7cUDaXk
         kk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865924; x=1739470724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTAbjs+ZIolkWTfm9mQklQQ/rgalTGxg3MlfIrb1brs=;
        b=IPZd3qF344ggky3UywVP+Tgkhls4mtTJbgSiqbhvQNOBU+9MfIf6rzRpP/y1NtUt/V
         +RmoiGuMO5UciXIG6CvpvBR9Qp0PVAGXYbCDrBrqR3SLTTTQA7qFtA7H4/cv22K9WrXP
         VfykxtMxOhojoqUSEnYTc7Un7op2oJ1Sghx4fnZ1e3cfjEDKZGKpzMVuPFKQCYobLgyN
         fIYSt0/Wmpy7eake6A/d/nT3PHJksZ7mKOnuwA14FzIjPCd7JbO0jDAsic342bzZeSOV
         GIt/H2rioMw6fax+szQHrEohxdzsp2aHb4ejjXiC2EciXbyHWmBxi9RnBbMK73tBlfpv
         gynA==
X-Forwarded-Encrypted: i=1; AJvYcCVZWgAu20wzbPLBtX+nSOA/8H1lWxZj3SMF2CyXzNVoHzpoKZJ3NP2AMuiZ/JFdakbkBA0ZqRcKzt0KQlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwukJREXnavpLaiAX3N5KJVBoecy4RBkbHoMuLba0veeoMiS+Ca
	F4g2MTYrcB2PFy/dLg4+RJyzip98fDXUW4r5MPUEpbCu14y3k/FL93cnBMy6K74yKwkAgJ8yeQ=
	=
X-Google-Smtp-Source: AGHT+IFq6I8SlF529XaSIG0v2kxPMDuCk08v3rpn5V0Sdgy9vzchYWtKtzABIJUIV4QBXvz8ORyS0aC2Jg==
X-Received: from edbfj20.prod.google.com ([2002:a05:6402:2b94:b0:5dc:4848:561d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9724:b0:aae:869f:c4ad
 with SMTP id a640c23a62f3a-ab75e212f41mr882204166b.7.1738865924120; Thu, 06
 Feb 2025 10:18:44 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:17 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-24-elver@google.com>
Subject: [PATCH RFC 23/24] stackdepot: Enable capability analysis
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

Enable capability analysis for stackdepot.

Signed-off-by: Marco Elver <elver@google.com>
---
 lib/Makefile     |  1 +
 lib/stackdepot.c | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 1dbb59175eb0..f40ba93c9a94 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -270,6 +270,7 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 # Prevent the compiler from calling builtins like memcmp() or bcmp() from this
 # file.
 CFLAGS_stackdepot.o += -fno-builtin
+CAPABILITY_ANALYSIS_stackdepot.o := y
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 # In particular, instrumenting stackdepot.c with KMSAN will result in infinite
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 245d5b416699..6664146d1f31 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -14,6 +14,8 @@
 
 #define pr_fmt(fmt) "stackdepot: " fmt
 
+disable_capability_analysis();
+
 #include <linux/debugfs.h>
 #include <linux/gfp.h>
 #include <linux/jhash.h>
@@ -36,6 +38,8 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
+enable_capability_analysis();
+
 #define DEPOT_POOLS_CAP 8192
 /* The pool_index is offset by 1 so the first record does not have a 0 handle. */
 #define DEPOT_MAX_POOLS \
@@ -61,18 +65,18 @@ static unsigned int stack_bucket_number_order;
 /* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
+/* The lock must be held when performing pool or freelist modifications. */
+static DEFINE_RAW_SPINLOCK(pool_lock);
 /* Array of memory regions that store stack records. */
-static void *stack_pools[DEPOT_MAX_POOLS];
+static void *stack_pools[DEPOT_MAX_POOLS] __var_guarded_by(&pool_lock);
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
 static int pools_num;
 /* Offset to the unused space in the currently used pool. */
-static size_t pool_offset = DEPOT_POOL_SIZE;
+static size_t pool_offset __var_guarded_by(&pool_lock) = DEPOT_POOL_SIZE;
 /* Freelist of stack records within stack_pools. */
-static LIST_HEAD(free_stacks);
-/* The lock must be held when performing pool or freelist modifications. */
-static DEFINE_RAW_SPINLOCK(pool_lock);
+static __var_guarded_by(&pool_lock) LIST_HEAD(free_stacks);
 
 /* Statistics counters for debugfs. */
 enum depot_counter_id {
@@ -242,6 +246,7 @@ EXPORT_SYMBOL_GPL(stack_depot_init);
  * Initializes new stack pool, and updates the list of pools.
  */
 static bool depot_init_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -289,6 +294,7 @@ static bool depot_init_pool(void **prealloc)
 
 /* Keeps the preallocated memory to be used for a new stack depot pool. */
 static void depot_keep_new_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -308,6 +314,7 @@ static void depot_keep_new_pool(void **prealloc)
  * the current pre-allocation.
  */
 static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 	void *current_pool;
@@ -342,6 +349,7 @@ static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
 
 /* Try to find next free usable entry from the freelist. */
 static struct stack_record *depot_pop_free(void)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 
@@ -379,6 +387,7 @@ static inline size_t depot_stack_record_size(struct stack_record *s, unsigned in
 /* Allocates a new stack in a stack depot pool. */
 static struct stack_record *
 depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, depot_flags_t flags, void **prealloc)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack = NULL;
 	size_t record_size;
@@ -437,6 +446,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 }
 
 static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
+	__must_not_hold(&pool_lock)
 {
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
@@ -453,7 +463,8 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 		return NULL;
 	}
 
-	pool = stack_pools[pool_index];
+	/* @pool_index either valid, or user passed in corrupted value. */
+	pool = capability_unsafe(stack_pools[pool_index]);
 	if (WARN_ON(!pool))
 		return NULL;
 
@@ -466,6 +477,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 
 /* Links stack into the freelist. */
 static void depot_free_stack(struct stack_record *stack)
+	__must_not_hold(&pool_lock)
 {
 	unsigned long flags;
 
-- 
2.48.1.502.g6dc24dfdaf-goog

