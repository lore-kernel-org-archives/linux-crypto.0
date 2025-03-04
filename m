Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB9201021
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080348; cv=none; b=BS9x/nnI5pGkj8H+O6QewHxGbwzP3MvC1gwSl5x6FzbfCYPAGVXTLi/edNr92VIYyL4VAzvdWkgThMc+4S8yQUoNd/NoUeHyJAAuK2bavgEcEBnEzFU/Iy+Xp/Var9e8R/ESCyaMNUPZK3OjNq7qQ0q+NgLJiiRbaVbIGtGQgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080348; c=relaxed/simple;
	bh=akMiNQ+gN0RmTpAtCrvDOtnUbNbNNTRmSfn6a9iTJQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aKNbhhWA2XlUfHcXNojLuzanLIbxYhtVboOsxS/IaaFHYhXUq6eUuX0Wm5fVUAk9HbOFJjOfvO79hr/XpP+4hgFbv9LGsqj6FlhL01tBQ2+UIZeN22Y1Q+2f9x4KsQCg1X4chT1AesG6wGtgzhCN8lC7rMqVk06WNu3Ntw/6NPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQmQGMJ7; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQmQGMJ7"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e4c2618332so2146798a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080344; x=1741685144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7aDkMzmRnQvghHkOpkqZKF4mFOekC+EgfFoIEWs+/yg=;
        b=CQmQGMJ7xxU/gG597V/dmkvtMl9PBp2toUgb5bzZiNu6X0lSAGQLOCPllHUVug6FBx
         /cV7FvPxSzB3SO+T5PxZNyLxWmMeYIDZUu0+mTi9VatMUeZXEGUh2dESidJH4bGTZuF+
         EXhnUMjYJDg5Yn3cAqw2JklVxvdh1bT4mt18KE35YcPz1uDodCeZ+K2eveOXEj0FEmoh
         iBbvojWtXwnZ+nZJ7yaWrQLL864iDRqO29up2tjlaJRv+VOtitN4gnOi1naRbUaqPrwE
         FhC8miShpLF0utQg+ClQlyYXJEd+B4uzBUZPdgK8muFAof0Ow52NT69Avigb/dJVGh6/
         7Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080344; x=1741685144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7aDkMzmRnQvghHkOpkqZKF4mFOekC+EgfFoIEWs+/yg=;
        b=EnfTftlf06HYIiI8nxNbfDCzLlnnF7r4ZjRHGHxNF8oYj9tQycaTgQPx9Cp/1dlWRM
         0CgdHFw/nPmOhpuGBd0Ri7UtKPaXG8/TplZNVRN3PAXIDjFcqBmmk/S2VGyh1/riWCbM
         GYqHvmaB9XbY200fa70kpcrJTR9kKm2bq4QQSERMWxBHIUBVfe4i0YvTEdA3pOGZ3drG
         RMfS4Yy8C221ySav7r+sXTbgCNFnlUP6zGq5te9tbHnCJ2RiCC01ihwZJ2IvjzNLwNMp
         Rvy+R1mSzjJ7puezlVPRrHEHGk2v0zGjp/azOH3/Ml4KntreMDrjreMI4qp14TLfvnTW
         MCnw==
X-Forwarded-Encrypted: i=1; AJvYcCVhwQTKNbC6jT2WgvXWuQoy7yXopJ20nVljdLk68Yuo8Lc8hdbQVTXaqfeyHK9rDsxpaYoU8w3WbsbBFM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwZyJt/TRNez/XWybcGGOA7tJGozmLbFC4aG+2gcF5DfxsVo9V
	b9TGrSyGEgPYV6U/AO4GVgG/EmoMg6rB8k3nEy0/YeVzBd6fCgUIS7ZkDa89lGdTRIlAhgLeyg=
	=
X-Google-Smtp-Source: AGHT+IFrsVxvAlUP16luel5mw8ahTZegvdR1b3AXtwaYU+pzk0iRfg2g0KplRjxoVDdXqAY6iJf5PuATRQ==
X-Received: from edbin4.prod.google.com ([2002:a05:6402:2084:b0:5e5:2b03:2ee1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:348f:b0:5dc:94ce:42a6
 with SMTP id 4fb4d7f45d1cf-5e4d6b4b980mr18647852a12.22.1741080344386; Tue, 04
 Mar 2025 01:25:44 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:12 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-14-elver@google.com>
Subject: [PATCH v2 13/34] bit_spinlock: Support Clang's capability analysis
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

The annotations for bit_spinlock.h have simply been using "bitlock" as
the token. For Sparse, that was likely sufficient in most cases. But
Clang's capability analysis is more precise, and we need to ensure we
can distinguish different bitlocks.

To do so, add a token capability, and a macro __bitlock(bitnum, addr)
that is used to construct unique per-bitlock tokens.

Add the appropriate test.

<linux/list_bl.h> is implicitly included through other includes, and
requires 2 annotations to indicate that acquisition (without release)
and release (without prior acquisition) of its bitlock is intended.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  3 ++-
 include/linux/bit_spinlock.h                  | 22 +++++++++++++---
 include/linux/list_bl.h                       |  2 ++
 lib/test_capability-analysis.c                | 26 +++++++++++++++++++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index e4b333fffb4d..65972d1e9570 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -79,7 +79,8 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
+`bit_spinlock`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index f1174a2fcc4d..22ab3c143407 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -9,6 +9,16 @@
 
 #include <asm/processor.h>  /* for cpu_relax() */
 
+/*
+ * For static capability analysis, we need a unique token for each possible bit
+ * that can be used as a bit_spinlock. The easiest way to do that is to create a
+ * fake capability that we can cast to with the __bitlock(bitnum, addr) macro
+ * below, which will give us unique instances for each (bit, addr) pair that the
+ * static analysis can use.
+ */
+struct_with_capability(__capability_bitlock) { };
+#define __bitlock(bitnum, addr) (struct __capability_bitlock *)(bitnum + (addr))
+
 /*
  *  bit-based spin_lock()
  *
@@ -16,6 +26,7 @@
  * are significantly faster.
  */
 static inline void bit_spin_lock(int bitnum, unsigned long *addr)
+	__acquires(__bitlock(bitnum, addr))
 {
 	/*
 	 * Assuming the lock is uncontended, this never enters
@@ -34,13 +45,14 @@ static inline void bit_spin_lock(int bitnum, unsigned long *addr)
 		preempt_disable();
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 }
 
 /*
  * Return true if it was acquired
  */
 static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
+	__cond_acquires(true, __bitlock(bitnum, addr))
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -49,7 +61,7 @@ static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
 		return 0;
 	}
 #endif
-	__acquire(bitlock);
+	__acquire(__bitlock(bitnum, addr));
 	return 1;
 }
 
@@ -57,6 +69,7 @@ static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
  *  bit-based spin_unlock()
  */
 static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -65,7 +78,7 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 	clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
@@ -74,6 +87,7 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
  *  protecting the rest of the flags in the word.
  */
 static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
+	__releases(__bitlock(bitnum, addr))
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -82,7 +96,7 @@ static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
 	__clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(bitnum, addr));
 }
 
 /*
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446c9..df9eebe6afca 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -144,11 +144,13 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 }
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
+	__acquires(__bitlock(0, b))
 {
 	bit_spin_lock(0, (unsigned long *)b);
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
+	__releases(__bitlock(0, b))
 {
 	__bit_spin_unlock(0, (unsigned long *)b);
 }
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 74d287740bb8..ad362d5a7916 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -4,6 +4,7 @@
  * positive errors when compiled with Clang's capability analysis.
  */
 
+#include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
 #include <linux/seqlock.h>
@@ -251,3 +252,28 @@ static void __used test_seqlock_writer(struct test_seqlock_data *d)
 	d->counter++;
 	write_sequnlock_irqrestore(&d->sl, flags);
 }
+
+struct test_bit_spinlock_data {
+	unsigned long bits;
+	int counter __guarded_by(__bitlock(3, &bits));
+};
+
+static void __used test_bit_spin_lock(struct test_bit_spinlock_data *d)
+{
+	/*
+	 * Note, the analysis seems to have false negatives, because it won't
+	 * precisely recognize the bit of the fake __bitlock() token.
+	 */
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	bit_spin_unlock(3, &d->bits);
+
+	bit_spin_lock(3, &d->bits);
+	d->counter++;
+	__bit_spin_unlock(3, &d->bits);
+
+	if (bit_spin_trylock(3, &d->bits)) {
+		d->counter++;
+		bit_spin_unlock(3, &d->bits);
+	}
+}
-- 
2.48.1.711.g2feabab25a-goog

