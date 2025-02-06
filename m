Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE2D1A76BB
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865875; cv=none; b=lD7dyDCnIhlQtytJjqPg1ehQaLZPq9oFUcPrYTK8CWFCE68nIKvdogSdkD4m9T3mdmMFeJ5TQYWH/FG7HOBILJ4qDMrlPboZvYYtQ0GYSd4oan5DSylRASuW6leB7xIbI1XlH5dOaCjmWXTqZpjRUKmo2ckx5gAUN73PDcHYQJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865875; c=relaxed/simple;
	bh=iyz037rEQeSBSVTGhzJ4Z6M1D6aGZ+4JptXyFE10Z/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ciIT4u5IkPZ+kgu8iu4eUr2ln7QKWtJt+gP7ekknDH94caRXbhauXuU93cKXDlrVGjouLNRBIXdA4eEk7pQSG0xeD9FUV1pbjk0HHDN6vVcUof6kcLubAt8pp3GLVX4aot/JPrfOscdcvd3Rt0l2Hivgn5Qwub+2pT3Ec/vxUVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fANvAIb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fANvAIb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43582d49dacso10355095e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865870; x=1739470670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PGmsmIsXIBV39eIxfDyWh+XEHePbJneD0pcTBLdRlSI=;
        b=4fANvAIboUIOjoZ20hLhSQdoNtFzsnDLJ4m74AAnwSWwIJl3Dzi1U7iTKzd+mQQSrp
         J8JBBljauCH1x127RFb7ZAgXm1PZZRQ8pGgvtPpA8X8S1uT2/aip3heAEso6s9Xfr0Wa
         3WD4zPlcxlJ0/XYN/D0gZlatGBUvfz+wyZe+3XT1XlSvSdtzT7DQDJDjB0/dCv1BMTZz
         +uGDuq9RYMhzBxFw42w57Tyb8whvO3vKOHbd2P25bfcOAMFqjomutkvDXl3oeJUNPitg
         RhWVJHWi1usn6KzAvpfjCPcqWdSApGNmvoDWMUoPiDKE7qJUhhFISNxRxBlPiEZ0wxjO
         +Jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865870; x=1739470670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGmsmIsXIBV39eIxfDyWh+XEHePbJneD0pcTBLdRlSI=;
        b=tyGI+qtsBdH+LZBNY/E4LUb6TAsQSZ03/K5shPc9cxxdqAVf1w5TVWNslPs1sK4CRC
         JolNsJYpu3QwQzKOKtazK+pHILeeirf95xIcCxf3zlcU1DHmHfj1WWRIJ13Iwc+yIlFj
         fiFxig8ewb0xkGhC1XfUE0tcKWTN3x6zKtM3BcKSBUpVelAhr6gugAWfupR35EyGQ+wa
         qrNH0Nb+9IGcVl1pr08+t2PH7hasf5KilYxhVM15G8ICP2vVHL4ZrBo93p9pYQG9rh2I
         VMEm75D+3kH0wut9JWUa4rJFsAz5lvhkwb3h9Z+g11pLGqh0YLvKU+dhE0e33Trxu3tp
         Kucg==
X-Forwarded-Encrypted: i=1; AJvYcCXWNrYWS3IUzTinALnBUpxCTXX+8xBqW2CvDUKjY5P+8PHJtpIX7klAc8r6Sr+KHa5xE+3JPbBC0u47hNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEUNxndrIkRQvZDz99jWUyiaN8K6sS2VlgCYMBH6hg4IaNFhJS
	VcWwf3GngFOBYE+2C+T/YsYsnhwuW1281pFXp/f8szwhCNN/FGodEFlomsO8iZQ+kL5DXSIwNA=
	=
X-Google-Smtp-Source: AGHT+IGDAkcn1bQ3IkfDNe8IDZP0C9GaYxa8QLVu0+68ezGhl3fk9usp9e5g9je1OprcIzBUfUjOK5kXzw==
X-Received: from wmbhg20.prod.google.com ([2002:a05:600c:5394:b0:436:a247:a0e6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e15:b0:435:192:63fb
 with SMTP id 5b1f17b1804b1-4392497d02amr4329395e9.3.1738865870730; Thu, 06
 Feb 2025 10:17:50 -0800 (PST)
Date: Thu,  6 Feb 2025 19:09:56 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-3-elver@google.com>
Subject: [PATCH RFC 02/24] compiler-capability-analysis: Rename __cond_lock()
 to __cond_acquire()
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

Just like the pairing of attribute __acquires() with a matching
function-like macro __acquire(), the attribute __cond_acquires() should
have a matching function-like macro __cond_acquire().

To be consistent, rename __cond_lock() to __cond_acquire().

Signed-off-by: Marco Elver <elver@google.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 include/linux/compiler-capability-analysis.h       |  4 ++--
 include/linux/mm.h                                 |  6 +++---
 include/linux/rwlock.h                             |  4 ++--
 include/linux/rwlock_rt.h                          |  4 ++--
 include/linux/sched/signal.h                       |  2 +-
 include/linux/spinlock.h                           | 12 ++++++------
 include/linux/spinlock_rt.h                        |  6 +++---
 kernel/time/posix-timers.c                         |  2 +-
 tools/include/linux/compiler_types.h               |  4 ++--
 11 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index f6234065dbdd..560a5a899d1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1136,7 +1136,7 @@ void iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg,
 bool _iwl_trans_grab_nic_access(struct iwl_trans *trans);
 
 #define iwl_trans_grab_nic_access(trans)		\
-	__cond_lock(nic_access,				\
+	__cond_acquire(nic_access,				\
 		    likely(_iwl_trans_grab_nic_access(trans)))
 
 void __releases(nic_access)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 856b7e9f717d..a1becf833dc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -560,7 +560,7 @@ void iwl_trans_pcie_free_pnvm_dram_regions(struct iwl_dram_regions *dram_regions
 
 bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
 #define _iwl_trans_pcie_grab_nic_access(trans)			\
-	__cond_lock(nic_access_nobh,				\
+	__cond_acquire(nic_access_nobh,				\
 		    likely(__iwl_trans_pcie_grab_nic_access(trans)))
 
 void iwl_trans_pcie_check_product_reset_status(struct pci_dev *pdev);
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index 7546ddb83f86..dfed4e7e6ab8 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -15,7 +15,7 @@
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
-# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
+# define __cond_acquire(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
 
 #else /* !__CHECKER__ */
 
@@ -25,7 +25,7 @@
 # define __releases(x)
 # define __acquire(x)		(void)0
 # define __release(x)		(void)0
-# define __cond_lock(x, c)	(c)
+# define __cond_acquire(x, c)	(c)
 
 #endif /* __CHECKER__ */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7b1068ddcbb7..a2365f4d6826 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2738,7 +2738,7 @@ static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 				    spinlock_t **ptl)
 {
 	pte_t *ptep;
-	__cond_lock(*ptl, ptep = __get_locked_pte(mm, addr, ptl));
+	__cond_acquire(*ptl, ptep = __get_locked_pte(mm, addr, ptl));
 	return ptep;
 }
 
@@ -3029,7 +3029,7 @@ static inline pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr,
 {
 	pte_t *pte;
 
-	__cond_lock(RCU, pte = ___pte_offset_map(pmd, addr, pmdvalp));
+	__cond_acquire(RCU, pte = ___pte_offset_map(pmd, addr, pmdvalp));
 	return pte;
 }
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
@@ -3044,7 +3044,7 @@ static inline pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 {
 	pte_t *pte;
 
-	__cond_lock(RCU, __cond_lock(*ptlp,
+	__cond_acquire(RCU, __cond_acquire(*ptlp,
 			pte = __pte_offset_map_lock(mm, pmd, addr, ptlp)));
 	return pte;
 }
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 5b87c6f4a243..58c346947aa2 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -49,8 +49,8 @@ do {								\
  * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
  * methods are defined as nops in the case they are not required.
  */
-#define read_trylock(lock)	__cond_lock(lock, _raw_read_trylock(lock))
-#define write_trylock(lock)	__cond_lock(lock, _raw_write_trylock(lock))
+#define read_trylock(lock)	__cond_acquire(lock, _raw_read_trylock(lock))
+#define write_trylock(lock)	__cond_acquire(lock, _raw_write_trylock(lock))
 
 #define write_lock(lock)	_raw_write_lock(lock)
 #define read_lock(lock)		_raw_read_lock(lock)
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 7d81fc6918ee..5320b4b66405 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -55,7 +55,7 @@ static __always_inline void read_lock_irq(rwlock_t *rwlock)
 		flags = 0;				\
 	} while (0)
 
-#define read_trylock(lock)	__cond_lock(lock, rt_read_trylock(lock))
+#define read_trylock(lock)	__cond_acquire(lock, rt_read_trylock(lock))
 
 static __always_inline void read_unlock(rwlock_t *rwlock)
 {
@@ -111,7 +111,7 @@ static __always_inline void write_lock_irq(rwlock_t *rwlock)
 		flags = 0;				\
 	} while (0)
 
-#define write_trylock(lock)	__cond_lock(lock, rt_write_trylock(lock))
+#define write_trylock(lock)	__cond_acquire(lock, rt_write_trylock(lock))
 
 #define write_trylock_irqsave(lock, flags)		\
 ({							\
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index d5d03d919df8..3304cce4b1bf 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -741,7 +741,7 @@ static inline struct sighand_struct *lock_task_sighand(struct task_struct *task,
 	struct sighand_struct *ret;
 
 	ret = __lock_task_sighand(task, flags);
-	(void)__cond_lock(&task->sighand->siglock, ret);
+	(void)__cond_acquire(&task->sighand->siglock, ret);
 	return ret;
 }
 
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 63dd8cf3c3c2..678e6f0679a1 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -212,7 +212,7 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
  * various methods are defined as nops in the case they are not
  * required.
  */
-#define raw_spin_trylock(lock)	__cond_lock(lock, _raw_spin_trylock(lock))
+#define raw_spin_trylock(lock)	__cond_acquire(lock, _raw_spin_trylock(lock))
 
 #define raw_spin_lock(lock)	_raw_spin_lock(lock)
 
@@ -284,7 +284,7 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 #define raw_spin_unlock_bh(lock)	_raw_spin_unlock_bh(lock)
 
 #define raw_spin_trylock_bh(lock) \
-	__cond_lock(lock, _raw_spin_trylock_bh(lock))
+	__cond_acquire(lock, _raw_spin_trylock_bh(lock))
 
 #define raw_spin_trylock_irq(lock) \
 ({ \
@@ -499,21 +499,21 @@ static inline int rwlock_needbreak(rwlock_t *lock)
  */
 extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
 #define atomic_dec_and_lock(atomic, lock) \
-		__cond_lock(lock, _atomic_dec_and_lock(atomic, lock))
+		__cond_acquire(lock, _atomic_dec_and_lock(atomic, lock))
 
 extern int _atomic_dec_and_lock_irqsave(atomic_t *atomic, spinlock_t *lock,
 					unsigned long *flags);
 #define atomic_dec_and_lock_irqsave(atomic, lock, flags) \
-		__cond_lock(lock, _atomic_dec_and_lock_irqsave(atomic, lock, &(flags)))
+		__cond_acquire(lock, _atomic_dec_and_lock_irqsave(atomic, lock, &(flags)))
 
 extern int _atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock);
 #define atomic_dec_and_raw_lock(atomic, lock) \
-		__cond_lock(lock, _atomic_dec_and_raw_lock(atomic, lock))
+		__cond_acquire(lock, _atomic_dec_and_raw_lock(atomic, lock))
 
 extern int _atomic_dec_and_raw_lock_irqsave(atomic_t *atomic, raw_spinlock_t *lock,
 					unsigned long *flags);
 #define atomic_dec_and_raw_lock_irqsave(atomic, lock, flags) \
-		__cond_lock(lock, _atomic_dec_and_raw_lock_irqsave(atomic, lock, &(flags)))
+		__cond_acquire(lock, _atomic_dec_and_raw_lock_irqsave(atomic, lock, &(flags)))
 
 int __alloc_bucket_spinlocks(spinlock_t **locks, unsigned int *lock_mask,
 			     size_t max_size, unsigned int cpu_mult,
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index f6499c37157d..eaad4dd2baac 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -123,13 +123,13 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock,
 }
 
 #define spin_trylock(lock)				\
-	__cond_lock(lock, rt_spin_trylock(lock))
+	__cond_acquire(lock, rt_spin_trylock(lock))
 
 #define spin_trylock_bh(lock)				\
-	__cond_lock(lock, rt_spin_trylock_bh(lock))
+	__cond_acquire(lock, rt_spin_trylock_bh(lock))
 
 #define spin_trylock_irq(lock)				\
-	__cond_lock(lock, rt_spin_trylock(lock))
+	__cond_acquire(lock, rt_spin_trylock(lock))
 
 #define spin_trylock_irqsave(lock, flags)		\
 ({							\
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1b675aee99a9..dbada41c10ad 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -63,7 +63,7 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
 
 #define lock_timer(tid, flags)						   \
 ({	struct k_itimer *__timr;					   \
-	__cond_lock(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
+	__cond_acquire(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
 	__timr;								   \
 })
 
diff --git a/tools/include/linux/compiler_types.h b/tools/include/linux/compiler_types.h
index d09f9dc172a4..b1db30e510d0 100644
--- a/tools/include/linux/compiler_types.h
+++ b/tools/include/linux/compiler_types.h
@@ -20,7 +20,7 @@
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
-# define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
+# define __cond_acquire(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 #else /* __CHECKER__ */
 /* context/locking */
 # define __must_hold(x)
@@ -28,7 +28,7 @@
 # define __releases(x)
 # define __acquire(x)	(void)0
 # define __release(x)	(void)0
-# define __cond_lock(x,c) (c)
+# define __cond_acquire(x,c) (c)
 #endif /* __CHECKER__ */
 
 /* Compiler specific macros. */
-- 
2.48.1.502.g6dc24dfdaf-goog

