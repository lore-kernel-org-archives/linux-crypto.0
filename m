Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D66204C14
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080377; cv=none; b=sj2/WTzurDZkCelm80vSToWl7PM7YfOu7ncmU7kq8e6miaFgaxdME3ouR6Vi91TINBjUVKpGcqyOiT2hZOvZcr6Q+cLP321AUSGTHndl7VKIha96rpH1FuKTmfobMe1nzXnQwMJUTuc5Bwj6eYPvg1L+yXwtuaIJE/LM4JymEgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080377; c=relaxed/simple;
	bh=YKRMcCwlVW+JHReTDDNlNbjIiZXrhQG3R+4ieOvF0KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LiYshfQ8j9RW+XyYsowBHVlxmQ1A2bGTm729j41VyAPAc4aeIa8X15U4FAoFFLkfFAhGd+ZD8sEBGxWhoSTUGV4uSYeu9vUcbQ/OIPrjztZLYKgc/QHhtNHT7wcnX8kmRM3d0864y8S+nk8DUOaKrHlPIifCb6hlPIUh1YN5cPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e69+yJMT; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e69+yJMT"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-abf46dba035so324406566b.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080371; x=1741685171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=32n+Ex/JylKzHQ8GbWl/dZFCHmuz4KLt4uCNJiSuT2I=;
        b=e69+yJMTsBftNyxq5NTkwldT+MukjqNNdZYLD5p1sS6G2sLxxJucl8hXkqZ1BVaYBW
         UGHV9thnAlU+XstoW0ZPqL5eyQBh+w881qDD8xJ/w/GbZBrNUUllV5nsEwqw9xbpjhqT
         moeriPQpJACDcjXbEVZ7w3QcEnfg4esQCeEFA4moSBHfdzI5JN5Q/GxtwFI7eaRaL5pW
         tuWXYHp6Kz5VrkcRq2ZdPhASp9MyZG4zUUgTp7yEmnUmnhjiDbu3DVQ/DnxwFU+8Z+Tx
         P0EHbDNXcgRHM8gJbH4ecKSn2+yG/JUbR6O4sj8NzURk5ZaMjrAYdrnzxjjlAbirC3fU
         WvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080371; x=1741685171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=32n+Ex/JylKzHQ8GbWl/dZFCHmuz4KLt4uCNJiSuT2I=;
        b=U1aJmunYBWAafkuU6KuvpnLoKpsiTIcj3M/5A/WqrhstVFiPAGpdPhlfUBOFe6Pzsr
         V3dYew7yznjQ+Wh/7wn+j3fWcdhHpMd0GEV0FppfILzcuN991uaL8U3+dJBKgEQ/ylnK
         vpctqA4FpZNjF580LzKhkf5ZLK4wRnrtaG88s2/IITurEBbZfQKIoNQR8v1hNAY+IdmY
         FXpP06rxu5CvZ3P8xByCuIaTNUXxGIb9UfNxSijRgkJqQ4nwxUqavfgPxIvkJH91TLIs
         QswnB+MS2rXTVARCg/brR5zQXCAbJxA8vj2VwUwrt1cgvNpmDMCvlUrzOvSOnEkjK+N7
         FT5g==
X-Forwarded-Encrypted: i=1; AJvYcCWdzRM/s7+AhZoPqgKBqG/gKyqKBzIi6aGmqbeFiNo2GydpiYGkG9odiKFoRnKJzbNUhiKKVpMHoJ/h8iA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/zPF4+kPwBsucKWFoJcEIcondI938zzq3NX1RU4E7aUO5Z4xK
	hu/5LycGUCV9bVsaf731HdNGFowb5HbmCEwuSU3u68Qc35NJIiWHgyF3MLmlRvplR1bCShZStQ=
	=
X-Google-Smtp-Source: AGHT+IH7ajhBvj+N9zMLWn9yRIZ8xNtCdS5fHbofGVp+Rc2QgwPO+/i7HmH4t/LWU2ohwJ2AE+ttvPmAuA==
X-Received: from ejctp7.prod.google.com ([2002:a17:907:c487:b0:ac2:219:94c3])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:794e:b0:abf:742e:1fca
 with SMTP id a640c23a62f3a-abf742e23d7mr756224866b.18.1741080371564; Tue, 04
 Mar 2025 01:26:11 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:22 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-24-elver@google.com>
Subject: [PATCH v2 23/34] compiler-capability-analysis: Remove __cond_lock()
 function-like helper
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

As discussed in [1], removing __cond_lock() will improve the readability
of trylock code. Now that Sparse context tracking support has been
removed, we can also remove __cond_lock().

Change existing APIs to either drop __cond_lock() completely, or make
use of the __cond_acquires() function attribute instead.

In particular, spinlock and rwlock implementations required switching
over to inline helpers rather than statement-expressions for their
trylock_* variants.

Link: https://lore.kernel.org/all/20250207082832.GU7145@noisy.programming.kicks-ass.net/ [1]
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 .../dev-tools/capability-analysis.rst         |  2 -
 Documentation/mm/process_addrs.rst            |  6 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  6 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  5 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 +-
 include/linux/compiler-capability-analysis.h  | 41 -------------
 include/linux/mm.h                            | 33 ++--------
 include/linux/rwlock.h                        | 11 +---
 include/linux/rwlock_api_smp.h                | 14 ++++-
 include/linux/rwlock_rt.h                     | 21 ++++---
 include/linux/sched/signal.h                  | 14 +----
 include/linux/spinlock.h                      | 45 +++++---------
 include/linux/spinlock_api_smp.h              | 20 ++++++
 include/linux/spinlock_api_up.h               | 61 ++++++++++++++++---
 include/linux/spinlock_rt.h                   | 26 ++++----
 kernel/signal.c                               |  4 +-
 kernel/time/posix-timers.c                    | 10 +--
 lib/dec_and_lock.c                            |  8 +--
 mm/memory.c                                   |  4 +-
 mm/pgtable-generic.c                          | 19 +++---
 tools/include/linux/compiler_types.h          |  2 -
 22 files changed, 160 insertions(+), 200 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 51ea94b0f4cc..d11e88ab9882 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -113,10 +113,8 @@ Keywords
                  __releases_shared
                  __acquire
                  __release
-                 __cond_lock
                  __acquire_shared
                  __release_shared
-                 __cond_lock_shared
                  capability_unsafe
                  __capability_unsafe
                  disable_capability_analysis enable_capability_analysis
diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 81417fa2ed20..073480ba7585 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -540,7 +540,7 @@ To access PTE-level page tables, a helper like :c:func:`!pte_offset_map_lock` or
 :c:func:`!pte_offset_map` can be used depending on stability requirements.
 These map the page table into kernel memory if required, take the RCU lock, and
 depending on variant, may also look up or acquire the PTE lock.
-See the comment on :c:func:`!__pte_offset_map_lock`.
+See the comment on :c:func:`!pte_offset_map_lock`.
 
 Atomicity
 ^^^^^^^^^
@@ -624,7 +624,7 @@ must be released via :c:func:`!pte_unmap_unlock`.
 .. note:: There are some variants on this, such as
    :c:func:`!pte_offset_map_rw_nolock` when we know we hold the PTE stable but
    for brevity we do not explore this.  See the comment for
-   :c:func:`!__pte_offset_map_lock` for more details.
+   :c:func:`!pte_offset_map_lock` for more details.
 
 When modifying data in ranges we typically only wish to allocate higher page
 tables as necessary, using these locks to avoid races or overwriting anything,
@@ -643,7 +643,7 @@ At the leaf page table, that is the PTE, we can't entirely rely on this pattern
 as we have separate PMD and PTE locks and a THP collapse for instance might have
 eliminated the PMD entry as well as the PTE from under us.
 
-This is why :c:func:`!__pte_offset_map_lock` locklessly retrieves the PMD entry
+This is why :c:func:`!pte_offset_map_lock` locklessly retrieves the PMD entry
 for the PTE, carefully checking it is as expected, before acquiring the
 PTE-specific lock, and then *again* checking that the PMD entry is as expected.
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 49c8507d1a6b..64394f6dc156 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -528,11 +528,11 @@ int iwl_trans_read_config32(struct iwl_trans *trans, u32 ofs,
 }
 IWL_EXPORT_SYMBOL(iwl_trans_read_config32);
 
-bool _iwl_trans_grab_nic_access(struct iwl_trans *trans)
+bool iwl_trans_grab_nic_access(struct iwl_trans *trans)
 {
 	return iwl_trans_pcie_grab_nic_access(trans);
 }
-IWL_EXPORT_SYMBOL(_iwl_trans_grab_nic_access);
+IWL_EXPORT_SYMBOL(iwl_trans_grab_nic_access);
 
 void __releases(nic_access)
 iwl_trans_release_nic_access(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index f6234065dbdd..8b37fd6c5221 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1133,11 +1133,7 @@ int iwl_trans_sw_reset(struct iwl_trans *trans, bool retake_ownership);
 void iwl_trans_set_bits_mask(struct iwl_trans *trans, u32 reg,
 			     u32 mask, u32 value);
 
-bool _iwl_trans_grab_nic_access(struct iwl_trans *trans);
-
-#define iwl_trans_grab_nic_access(trans)		\
-	__cond_lock(nic_access,				\
-		    likely(_iwl_trans_grab_nic_access(trans)))
+bool iwl_trans_grab_nic_access(struct iwl_trans *trans);
 
 void __releases(nic_access)
 iwl_trans_release_nic_access(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 856b7e9f717d..84ce40b2ec5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -558,10 +558,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans);
 void iwl_trans_pcie_free_pnvm_dram_regions(struct iwl_dram_regions *dram_regions,
 					   struct device *dev);
 
-bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
-#define _iwl_trans_pcie_grab_nic_access(trans)			\
-	__cond_lock(nic_access_nobh,				\
-		    likely(__iwl_trans_pcie_grab_nic_access(trans)))
+bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans);
 
 void iwl_trans_pcie_check_product_reset_status(struct pci_dev *pdev);
 void iwl_trans_pcie_check_product_reset_mode(struct pci_dev *pdev);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c917ed4c19bc..caed7d7434f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2405,7 +2405,7 @@ EXPORT_SYMBOL(iwl_trans_pcie_reset);
  * This version doesn't disable BHs but rather assumes they're
  * already disabled.
  */
-bool __iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
+bool _iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
 {
 	int ret;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -2488,7 +2488,7 @@ bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans)
 	bool ret;
 
 	local_bh_disable();
-	ret = __iwl_trans_pcie_grab_nic_access(trans);
+	ret = _iwl_trans_pcie_grab_nic_access(trans);
 	if (ret) {
 		/* keep BHs disabled until iwl_trans_pcie_release_nic_access */
 		return ret;
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index 741f88e1177f..c10938d2f102 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -93,12 +93,6 @@
 		__attribute__((overloadable)) __no_capability_analysis __acquires_cap(var) { }		\
 	static __always_inline void __acquire_shared_cap(const struct name *var)			\
 		__attribute__((overloadable)) __no_capability_analysis __acquires_shared_cap(var) { }	\
-	static __always_inline bool __try_acquire_cap(const struct name *var, bool ret)			\
-		__attribute__((overloadable)) __no_capability_analysis __try_acquires_cap(1, var)	\
-	{ return ret; }											\
-	static __always_inline bool __try_acquire_shared_cap(const struct name *var, bool ret)		\
-		__attribute__((overloadable)) __no_capability_analysis __try_acquires_shared_cap(1, var) \
-	{ return ret; }											\
 	static __always_inline void __release_cap(const struct name *var)				\
 		__attribute__((overloadable)) __no_capability_analysis __releases_cap(var) { }		\
 	static __always_inline void __release_shared_cap(const struct name *var)			\
@@ -156,8 +150,6 @@
 # define __requires_shared_cap(var)
 # define __acquire_cap(var)			do { } while (0)
 # define __acquire_shared_cap(var)		do { } while (0)
-# define __try_acquire_cap(var, ret)		(ret)
-# define __try_acquire_shared_cap(var, ret)	(ret)
 # define __release_cap(var)			do { } while (0)
 # define __release_shared_cap(var)		do { } while (0)
 # define __assert_cap(var)			do { (void)(var); } while (0)
@@ -313,25 +305,6 @@
  */
 #define __release(x)		__release_cap(x)
 
-/**
- * __cond_lock() - function that conditionally acquires a capability
- *                 exclusively
- * @x: capability instance pinter
- * @c: boolean expression
- *
- * Return: result of @c
- *
- * No-op function that conditionally acquires capability instance @x
- * exclusively, if the boolean expression @c is true. The result of @c is the
- * return value, to be able to create a capability-enabled interface; for
- * example:
- *
- * .. code-block:: c
- *
- *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
- */
-#define __cond_lock(x, c)	__try_acquire_cap(x, c)
-
 /**
  * __must_hold_shared() - function attribute, caller must hold shared capability
  * @x: capability instance pointer
@@ -392,18 +365,4 @@
  */
 #define __release_shared(x)	__release_shared_cap(x)
 
-/**
- * __cond_lock_shared() - function that conditionally acquires a capability
- *                        shared
- * @x: capability instance pinter
- * @c: boolean expression
- *
- * Return: result of @c
- *
- * No-op function that conditionally acquires capability instance @x with shared
- * access, if the boolean expression @c is true. The result of @c is the return
- * value, to be able to create a capability-enabled interface.
- */
-#define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
-
 #endif /* _LINUX_COMPILER_CAPABILITY_ANALYSIS_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7b1068ddcbb7..dbf4eb414bd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2732,15 +2732,8 @@ static inline int pte_devmap(pte_t pte)
 }
 #endif
 
-extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
-			       spinlock_t **ptl);
-static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
-				    spinlock_t **ptl)
-{
-	pte_t *ptep;
-	__cond_lock(*ptl, ptep = __get_locked_pte(mm, addr, ptl));
-	return ptep;
-}
+extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			     spinlock_t **ptl);
 
 #ifdef __PAGETABLE_P4D_FOLDED
 static inline int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
@@ -3023,31 +3016,15 @@ static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 	return true;
 }
 
-pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
-static inline pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr,
-			pmd_t *pmdvalp)
-{
-	pte_t *pte;
+pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
 
-	__cond_lock(RCU, pte = ___pte_offset_map(pmd, addr, pmdvalp));
-	return pte;
-}
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
 	return __pte_offset_map(pmd, addr, NULL);
 }
 
-pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, spinlock_t **ptlp);
-static inline pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, spinlock_t **ptlp)
-{
-	pte_t *pte;
-
-	__cond_lock(RCU, __cond_lock(*ptlp,
-			pte = __pte_offset_map_lock(mm, pmd, addr, ptlp)));
-	return pte;
-}
+pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+			   unsigned long addr, spinlock_t **ptlp);
 
 pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, spinlock_t **ptlp);
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 3c8971201ec7..701de800c36e 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -50,8 +50,8 @@ do {								\
  * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
  * methods are defined as nops in the case they are not required.
  */
-#define read_trylock(lock)	__cond_lock_shared(lock, _raw_read_trylock(lock))
-#define write_trylock(lock)	__cond_lock(lock, _raw_write_trylock(lock))
+#define read_trylock(lock)	_raw_read_trylock(lock)
+#define write_trylock(lock)	_raw_write_trylock(lock)
 
 #define write_lock(lock)	_raw_write_lock(lock)
 #define read_lock(lock)		_raw_read_lock(lock)
@@ -113,12 +113,7 @@ do {								\
 	} while (0)
 #define write_unlock_bh(lock)		_raw_write_unlock_bh(lock)
 
-#define write_trylock_irqsave(lock, flags)		\
-	__cond_lock(lock, ({				\
-		local_irq_save(flags);			\
-		_raw_write_trylock(lock) ?		\
-		1 : ({ local_irq_restore(flags); 0; });	\
-	}))
+#define write_trylock_irqsave(lock, flags) _raw_write_trylock_irqsave(lock, &(flags))
 
 #ifdef arch_rwlock_is_contended
 #define rwlock_is_contended(lock) \
diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
index 3e975105a606..b289c3089ab7 100644
--- a/include/linux/rwlock_api_smp.h
+++ b/include/linux/rwlock_api_smp.h
@@ -26,8 +26,8 @@ unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
 unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
-int __lockfunc _raw_read_trylock(rwlock_t *lock);
-int __lockfunc _raw_write_trylock(rwlock_t *lock);
+int __lockfunc _raw_read_trylock(rwlock_t *lock)	__cond_acquires_shared(true, lock);
+int __lockfunc _raw_write_trylock(rwlock_t *lock)	__cond_acquires(true, lock);
 void __lockfunc _raw_read_unlock(rwlock_t *lock)	__releases_shared(lock);
 void __lockfunc _raw_write_unlock(rwlock_t *lock)	__releases(lock);
 void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)	__releases_shared(lock);
@@ -41,6 +41,16 @@ void __lockfunc
 _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+static inline bool _raw_write_trylock_irqsave(rwlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	local_irq_save(*flags);
+	if (_raw_write_trylock(lock))
+		return true;
+	local_irq_restore(*flags);
+	return false;
+}
+
 #ifdef CONFIG_INLINE_READ_LOCK
 #define _raw_read_lock(lock) __raw_read_lock(lock)
 #endif
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 742172a06702..dc34b48a6158 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -26,11 +26,11 @@ do {							\
 } while (0)
 
 extern void rt_read_lock(rwlock_t *rwlock)	__acquires_shared(rwlock);
-extern int rt_read_trylock(rwlock_t *rwlock);
+extern int rt_read_trylock(rwlock_t *rwlock)	__cond_acquires_shared(true, rwlock);
 extern void rt_read_unlock(rwlock_t *rwlock)	__releases_shared(rwlock);
 extern void rt_write_lock(rwlock_t *rwlock)	__acquires(rwlock);
 extern void rt_write_lock_nested(rwlock_t *rwlock, int subclass)	__acquires(rwlock);
-extern int rt_write_trylock(rwlock_t *rwlock);
+extern int rt_write_trylock(rwlock_t *rwlock)	__cond_acquires(true, rwlock);
 extern void rt_write_unlock(rwlock_t *rwlock)	__releases(rwlock);
 
 static __always_inline void read_lock(rwlock_t *rwlock)
@@ -59,7 +59,7 @@ static __always_inline void read_lock_irq(rwlock_t *rwlock)
 		flags = 0;				\
 	} while (0)
 
-#define read_trylock(lock)	__cond_lock_shared(lock, rt_read_trylock(lock))
+#define read_trylock(lock)	rt_read_trylock(lock)
 
 static __always_inline void read_unlock(rwlock_t *rwlock)
 	__releases_shared(rwlock)
@@ -123,14 +123,15 @@ static __always_inline void write_lock_irq(rwlock_t *rwlock)
 		flags = 0;				\
 	} while (0)
 
-#define write_trylock(lock)	__cond_lock(lock, rt_write_trylock(lock))
+#define write_trylock(lock)	rt_write_trylock(lock)
 
-#define write_trylock_irqsave(lock, flags)		\
-	__cond_lock(lock, ({				\
-		typecheck(unsigned long, flags);	\
-		flags = 0;				\
-		rt_write_trylock(lock);			\
-	}))
+static __always_inline bool _write_trylock_irqsave(rwlock_t *rwlock, unsigned long *flags)
+	__cond_acquires(true, rwlock)
+{
+	*flags = 0;
+	return rt_write_trylock(rwlock);
+}
+#define write_trylock_irqsave(lock, flags) _write_trylock_irqsave(lock, &(flags))
 
 static __always_inline void write_unlock(rwlock_t *rwlock)
 	__releases(rwlock)
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index d5d03d919df8..82c486b67e92 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -732,18 +732,8 @@ static inline int thread_group_empty(struct task_struct *p)
 #define delay_group_leader(p) \
 		(thread_group_leader(p) && !thread_group_empty(p))
 
-extern struct sighand_struct *__lock_task_sighand(struct task_struct *task,
-							unsigned long *flags);
-
-static inline struct sighand_struct *lock_task_sighand(struct task_struct *task,
-						       unsigned long *flags)
-{
-	struct sighand_struct *ret;
-
-	ret = __lock_task_sighand(task, flags);
-	(void)__cond_lock(&task->sighand->siglock, ret);
-	return ret;
-}
+extern struct sighand_struct *lock_task_sighand(struct task_struct *task,
+						unsigned long *flags);
 
 static inline void unlock_task_sighand(struct task_struct *task,
 						unsigned long *flags)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 12369fa9e3bb..3cfd85b25648 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -213,7 +213,7 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
  * various methods are defined as nops in the case they are not
  * required.
  */
-#define raw_spin_trylock(lock)	__cond_lock(lock, _raw_spin_trylock(lock))
+#define raw_spin_trylock(lock)	_raw_spin_trylock(lock)
 
 #define raw_spin_lock(lock)	_raw_spin_lock(lock)
 
@@ -284,22 +284,11 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 	} while (0)
 #define raw_spin_unlock_bh(lock)	_raw_spin_unlock_bh(lock)
 
-#define raw_spin_trylock_bh(lock) \
-	__cond_lock(lock, _raw_spin_trylock_bh(lock))
+#define raw_spin_trylock_bh(lock)	_raw_spin_trylock_bh(lock)
 
-#define raw_spin_trylock_irq(lock)			\
-	__cond_lock(lock, ({				\
-		local_irq_disable();			\
-		_raw_spin_trylock(lock) ?		\
-		1 : ({ local_irq_enable(); 0;  });	\
-	}))
+#define raw_spin_trylock_irq(lock)	_raw_spin_trylock_irq(lock)
 
-#define raw_spin_trylock_irqsave(lock, flags)		\
-	__cond_lock(lock, ({				\
-		local_irq_save(flags);			\
-		_raw_spin_trylock(lock) ?		\
-		1 : ({ local_irq_restore(flags); 0; }); \
-	}))
+#define raw_spin_trylock_irqsave(lock, flags) _raw_spin_trylock_irqsave(lock, &(flags))
 
 #ifndef CONFIG_PREEMPT_RT
 /* Include rwlock functions for !RT */
@@ -431,8 +420,12 @@ static __always_inline int spin_trylock_irq(spinlock_t *lock)
 	return raw_spin_trylock_irq(&lock->rlock);
 }
 
-#define spin_trylock_irqsave(lock, flags)			\
-	__cond_lock(lock, raw_spin_trylock_irqsave(spinlock_check(lock), flags))
+static __always_inline bool _spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock) __no_capability_analysis
+{
+	return raw_spin_trylock_irqsave(spinlock_check(lock), *flags);
+}
+#define spin_trylock_irqsave(lock, flags) _spin_trylock_irqsave(lock, &(flags))
 
 /**
  * spin_is_locked() - Check whether a spinlock is locked.
@@ -510,23 +503,17 @@ static inline int rwlock_needbreak(rwlock_t *lock)
  * Decrements @atomic by 1.  If the result is 0, returns true and locks
  * @lock.  Returns false for all other cases.
  */
-extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
-#define atomic_dec_and_lock(atomic, lock) \
-		__cond_lock(lock, _atomic_dec_and_lock(atomic, lock))
+extern int atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock) __cond_acquires(true, lock);
 
 extern int _atomic_dec_and_lock_irqsave(atomic_t *atomic, spinlock_t *lock,
-					unsigned long *flags);
-#define atomic_dec_and_lock_irqsave(atomic, lock, flags) \
-		__cond_lock(lock, _atomic_dec_and_lock_irqsave(atomic, lock, &(flags)))
+					unsigned long *flags) __cond_acquires(true, lock);
+#define atomic_dec_and_lock_irqsave(atomic, lock, flags) _atomic_dec_and_lock_irqsave(atomic, lock, &(flags))
 
-extern int _atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock);
-#define atomic_dec_and_raw_lock(atomic, lock) \
-		__cond_lock(lock, _atomic_dec_and_raw_lock(atomic, lock))
+extern int atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock) __cond_acquires(true, lock);
 
 extern int _atomic_dec_and_raw_lock_irqsave(atomic_t *atomic, raw_spinlock_t *lock,
-					unsigned long *flags);
-#define atomic_dec_and_raw_lock_irqsave(atomic, lock, flags) \
-		__cond_lock(lock, _atomic_dec_and_raw_lock_irqsave(atomic, lock, &(flags)))
+					    unsigned long *flags) __cond_acquires(true, lock);
+#define atomic_dec_and_raw_lock_irqsave(atomic, lock, flags) _atomic_dec_and_raw_lock_irqsave(atomic, lock, &(flags))
 
 int __alloc_bucket_spinlocks(spinlock_t **locks, unsigned int *lock_mask,
 			     size_t max_size, unsigned int cpu_mult,
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index a77b76003ebb..1b1896595cbc 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -95,6 +95,26 @@ static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 	return 0;
 }
 
+static __always_inline bool _raw_spin_trylock_irq(raw_spinlock_t *lock)
+	__cond_acquires(true, lock)
+{
+	local_irq_disable();
+	if (_raw_spin_trylock(lock))
+		return true;
+	local_irq_enable();
+	return false;
+}
+
+static __always_inline bool _raw_spin_trylock_irqsave(raw_spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	local_irq_save(*flags);
+	if (_raw_spin_trylock(lock))
+		return true;
+	local_irq_restore(*flags);
+	return false;
+}
+
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPTION, because lockdep assumes that interrupts are
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index 018f5aabc1be..a9d5c7c66e03 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -24,14 +24,11 @@
  * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
-#define ___LOCK_void(lock) \
-  do { (void)(lock); } while (0)
-
 #define ___LOCK_(lock) \
-  do { __acquire(lock); ___LOCK_void(lock); } while (0)
+  do { __acquire(lock); (void)(lock); } while (0)
 
 #define ___LOCK_shared(lock) \
-  do { __acquire_shared(lock); ___LOCK_void(lock); } while (0)
+  do { __acquire_shared(lock); (void)(lock); } while (0)
 
 #define __LOCK(lock, ...) \
   do { preempt_disable(); ___LOCK_##__VA_ARGS__(lock); } while (0)
@@ -78,10 +75,56 @@
 #define _raw_spin_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
 #define _raw_read_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags, shared)
 #define _raw_write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _raw_spin_trylock(lock)			({ __LOCK(lock, void); 1; })
-#define _raw_read_trylock(lock)			({ __LOCK(lock, void); 1; })
-#define _raw_write_trylock(lock)			({ __LOCK(lock, void); 1; })
-#define _raw_spin_trylock_bh(lock)		({ __LOCK_BH(lock, void); 1; })
+
+static __always_inline int _raw_spin_trylock(raw_spinlock_t *lock)
+	__cond_acquires(true, lock)
+{
+	__LOCK(lock);
+	return 1;
+}
+
+static __always_inline int _raw_spin_trylock_bh(raw_spinlock_t *lock)
+	__cond_acquires(true, lock)
+{
+	__LOCK_BH(lock);
+	return 1;
+}
+
+static __always_inline int _raw_spin_trylock_irq(raw_spinlock_t *lock)
+	__cond_acquires(true, lock)
+{
+	__LOCK_IRQ(lock);
+	return 1;
+}
+
+static __always_inline int _raw_spin_trylock_irqsave(raw_spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	__LOCK_IRQSAVE(lock, *(flags));
+	return 1;
+}
+
+static __always_inline int _raw_read_trylock(rwlock_t *lock)
+	__cond_acquires_shared(true, lock)
+{
+	__LOCK(lock, shared);
+	return 1;
+}
+
+static __always_inline int _raw_write_trylock(rwlock_t *lock)
+	__cond_acquires(true, lock)
+{
+	__LOCK(lock);
+	return 1;
+}
+
+static __always_inline int _raw_write_trylock_irqsave(rwlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	__LOCK_IRQSAVE(lock, *(flags));
+	return 1;
+}
+
 #define _raw_spin_unlock(lock)			__UNLOCK(lock)
 #define _raw_read_unlock(lock)			__UNLOCK(lock, shared)
 #define _raw_write_unlock(lock)			__UNLOCK(lock)
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 1f55601e1321..d11ecb0ed571 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -37,8 +37,8 @@ extern void rt_spin_lock_nested(spinlock_t *lock, int subclass)	__acquires(lock)
 extern void rt_spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *nest_lock) __acquires(lock);
 extern void rt_spin_unlock(spinlock_t *lock)	__releases(lock);
 extern void rt_spin_lock_unlock(spinlock_t *lock);
-extern int rt_spin_trylock_bh(spinlock_t *lock);
-extern int rt_spin_trylock(spinlock_t *lock);
+extern int rt_spin_trylock_bh(spinlock_t *lock) __cond_acquires(true, lock);
+extern int rt_spin_trylock(spinlock_t *lock) __cond_acquires(true, lock);
 
 static __always_inline void spin_lock(spinlock_t *lock)
 	__acquires(lock)
@@ -130,21 +130,19 @@ static __always_inline void spin_unlock_irqrestore(spinlock_t *lock,
 	rt_spin_unlock(lock);
 }
 
-#define spin_trylock(lock)				\
-	__cond_lock(lock, rt_spin_trylock(lock))
+#define spin_trylock(lock)	rt_spin_trylock(lock)
 
-#define spin_trylock_bh(lock)				\
-	__cond_lock(lock, rt_spin_trylock_bh(lock))
+#define spin_trylock_bh(lock)	rt_spin_trylock_bh(lock)
 
-#define spin_trylock_irq(lock)				\
-	__cond_lock(lock, rt_spin_trylock(lock))
+#define spin_trylock_irq(lock)	rt_spin_trylock(lock)
 
-#define spin_trylock_irqsave(lock, flags)		\
-	__cond_lock(lock, ({				\
-		typecheck(unsigned long, flags);	\
-		flags = 0;				\
-		rt_spin_trylock(lock);			\
-	}))
+static __always_inline bool _spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags)
+	__cond_acquires(true, lock)
+{
+	*flags = 0;
+	return rt_spin_trylock(lock);
+}
+#define spin_trylock_irqsave(lock, flags) _spin_trylock_irqsave(lock, &(flags))
 
 #define spin_is_contended(lock)		(((void)(lock), 0))
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 875e97f6205a..8ae095eb1b78 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1354,8 +1354,8 @@ int zap_other_threads(struct task_struct *p)
 	return count;
 }
 
-struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
-					   unsigned long *flags)
+struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
+					 unsigned long *flags)
 {
 	struct sighand_struct *sighand;
 
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1b675aee99a9..8d84409fb3e6 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -59,14 +59,6 @@ static const struct k_clock clock_realtime, clock_monotonic;
 #error "SIGEV_THREAD_ID must not share bit with other SIGEV values!"
 #endif
 
-static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
-
-#define lock_timer(tid, flags)						   \
-({	struct k_itimer *__timr;					   \
-	__cond_lock(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
-	__timr;								   \
-})
-
 static int hash(struct signal_struct *sig, unsigned int nr)
 {
 	return hash_32(hash32_ptr(sig) ^ nr, HASH_BITS(posix_timers_hashtable));
@@ -507,7 +499,7 @@ COMPAT_SYSCALL_DEFINE3(timer_create, clockid_t, which_clock,
 }
 #endif
 
-static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 
diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
index 1dcca8f2e194..8c7c398fd770 100644
--- a/lib/dec_and_lock.c
+++ b/lib/dec_and_lock.c
@@ -18,7 +18,7 @@
  * because the spin-lock and the decrement must be
  * "atomic".
  */
-int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
+int atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
 {
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
@@ -32,7 +32,7 @@ int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
 	return 0;
 }
 
-EXPORT_SYMBOL(_atomic_dec_and_lock);
+EXPORT_SYMBOL(atomic_dec_and_lock);
 
 int _atomic_dec_and_lock_irqsave(atomic_t *atomic, spinlock_t *lock,
 				 unsigned long *flags)
@@ -50,7 +50,7 @@ int _atomic_dec_and_lock_irqsave(atomic_t *atomic, spinlock_t *lock,
 }
 EXPORT_SYMBOL(_atomic_dec_and_lock_irqsave);
 
-int _atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock)
+int atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock)
 {
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
@@ -63,7 +63,7 @@ int _atomic_dec_and_raw_lock(atomic_t *atomic, raw_spinlock_t *lock)
 	raw_spin_unlock(lock);
 	return 0;
 }
-EXPORT_SYMBOL(_atomic_dec_and_raw_lock);
+EXPORT_SYMBOL(atomic_dec_and_raw_lock);
 
 int _atomic_dec_and_raw_lock_irqsave(atomic_t *atomic, raw_spinlock_t *lock,
 				     unsigned long *flags)
diff --git a/mm/memory.c b/mm/memory.c
index b4d3d4893267..3bbcdb2f3f34 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2076,8 +2076,8 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	return pmd;
 }
 
-pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
-			spinlock_t **ptl)
+pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+		      spinlock_t **ptl)
 {
 	pmd_t *pmd = walk_to_pmd(mm, addr);
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 5a882f2b10f9..cc202648c8d8 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -279,7 +279,7 @@ static unsigned long pmdp_get_lockless_start(void) { return 0; }
 static void pmdp_get_lockless_end(unsigned long irqflags) { }
 #endif
 
-pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
+pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 {
 	unsigned long irqflags;
 	pmd_t pmdval;
@@ -331,13 +331,12 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 }
 
 /*
- * pte_offset_map_lock(mm, pmd, addr, ptlp), and its internal implementation
- * __pte_offset_map_lock() below, is usually called with the pmd pointer for
- * addr, reached by walking down the mm's pgd, p4d, pud for addr: either while
- * holding mmap_lock or vma lock for read or for write; or in truncate or rmap
- * context, while holding file's i_mmap_lock or anon_vma lock for read (or for
- * write). In a few cases, it may be used with pmd pointing to a pmd_t already
- * copied to or constructed on the stack.
+ * pte_offset_map_lock(mm, pmd, addr, ptlp) is usually called with the pmd
+ * pointer for addr, reached by walking down the mm's pgd, p4d, pud for addr:
+ * either while holding mmap_lock or vma lock for read or for write; or in
+ * truncate or rmap context, while holding file's i_mmap_lock or anon_vma lock
+ * for read (or for write). In a few cases, it may be used with pmd pointing to
+ * a pmd_t already copied to or constructed on the stack.
  *
  * When successful, it returns the pte pointer for addr, with its page table
  * kmapped if necessary (when CONFIG_HIGHPTE), and locked against concurrent
@@ -388,8 +387,8 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
  * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
  */
-pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
-			     unsigned long addr, spinlock_t **ptlp)
+pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+			   unsigned long addr, spinlock_t **ptlp)
 {
 	spinlock_t *ptl;
 	pmd_t pmdval;
diff --git a/tools/include/linux/compiler_types.h b/tools/include/linux/compiler_types.h
index d09f9dc172a4..067a5b4e0f7b 100644
--- a/tools/include/linux/compiler_types.h
+++ b/tools/include/linux/compiler_types.h
@@ -20,7 +20,6 @@
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
-# define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 #else /* __CHECKER__ */
 /* context/locking */
 # define __must_hold(x)
@@ -28,7 +27,6 @@
 # define __releases(x)
 # define __acquire(x)	(void)0
 # define __release(x)	(void)0
-# define __cond_lock(x,c) (c)
 #endif /* __CHECKER__ */
 
 /* Compiler specific macros. */
-- 
2.48.1.711.g2feabab25a-goog

