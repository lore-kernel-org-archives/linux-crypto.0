Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63981FDA6D
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080318; cv=none; b=biE7VcikZ3oAOM2wu6Y5iPJN234vahR0sNylpFbY08NqE9wyaMFp0lJMrgItnlF+jBq+4CfKeyr4O+dFRNWCg+yln2iS0HiEBiM6ZgFaAUcKVNQSY3L15t92kc8ipV21dhhMhiEBqkBqi136Zmqs+5nbMFU1+hPh2AxmM69Didg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080318; c=relaxed/simple;
	bh=VkhGfiuUn9q3goIt57XdzrI3URDD6c72kbPHwbG20Kk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHziU9dFz6aeL2L8KwV8HP+u8qBfCVcf2F91/AIO/pRiD83pD1ulsKmDHArlIOgDxCFz0ypcOlHs2X4ZWtJg8ffzOkKpCKJazr8no8tgwTLOt9FWoFQ5Cn6xbJtatIpy2TduCI1dr52kM5PAJ60ogEjdsP07Di36aDO1xQ3Mhh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EpVXu9GH; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EpVXu9GH"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e4c2618332so2145951a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080314; x=1741685114; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kWljJ6Cp78z9nBpFGSGBuSflIksXCmyHBsRMDURZjlg=;
        b=EpVXu9GHTe+vx/EncDjznPM2GWDfHbqt9gHkGG7s19t9GBeywtJdwxQHoHjPN+sFFs
         QIq6AibOd0XH3U1+7PZKLmys1WSwL/iFxFV9ZIpYKqKqnAful0wGQPPTJfc2fQO/zWI9
         kTInNW5zMevM3WusoY5Ge1/XXkrhACqW8NA7VrobJceaEcRVJR2XMAmCaywAeeHAzEkF
         WLF7U75P6D9CwAuiNMoEEV46gaPvIQU2YG/DSSWCZlOWLs6w/ZIRBdo2DnUkyJDuIKQf
         MV4QwVgHbh0+mw9eJ0KOoITP9yZvgkI5Td2wBASLp2cbrVJObLW6VDHdw0dE6s9QHfWI
         uxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080314; x=1741685114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWljJ6Cp78z9nBpFGSGBuSflIksXCmyHBsRMDURZjlg=;
        b=aZw0RLqiKpnvAYb3q2odhltodd8j75dE/5EJXiaN/esEciTWnabyQKRsvAgunRfvMH
         FBWWy2pm1bO8BEJoR5WrbOoPHEW2v2XwYuEBlrfXwNiBmKTukwR4rLzZ1f7G6RWVad54
         0rhOWLpn0PRjvY/ywBmfFxSqDfa34Qza1jDS3UUifCOgso8D+5EW/0l7ewIoVAkrzdgE
         lHeU1TzYg/cMGRKuJLZtjmtRKTnuOKvI0VhrS7BpQww4vLNh7dDvtK+gxVuRJQjMcsoZ
         vpxk8rCjYlhVrb1xF3CIcV+8EB/9NBKPnjjOGtEEDXF0twrvqAOFH2PgDfJJHoCV0tgC
         dFFw==
X-Forwarded-Encrypted: i=1; AJvYcCU3KCdNn9GkaPfvN8k8FM9/SYfVNQntnzf9IjG99Go5lEqnXjSCIDWycEsKHsZMF8bpHj87sJABkemMUoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHztxjFuJKj6AoKVXdBb5yv1udaOtLYX4vijZc5QF0PMR6lBkJ
	nUxM64InJUTsrWb2GR+zzK62/kIeAcNv2rNn42pmgMxX238rRjxdFHJip4XHbXEjeDWS7hmLaw=
	=
X-Google-Smtp-Source: AGHT+IFx2ou/QuAFmIUAlqle5Ae6nVXYkQFWvjC1m14ueuW175sGb3meshCyQWIZnxw9rj/A84+OtDA02Q==
X-Received: from edxn3.prod.google.com ([2002:a05:6402:5c3:b0:5e4:cc5d:aa63])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:26c2:b0:5db:f423:19c5
 with SMTP id 4fb4d7f45d1cf-5e4d6ac4066mr16631161a12.5.1741080314075; Tue, 04
 Mar 2025 01:25:14 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:01 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-3-elver@google.com>
Subject: [PATCH v2 02/34] compiler-capability-analysis: Add infrastructure for
 Clang's capability analysis
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

Capability analysis is a C language extension, which enables statically
checking that user-definable "capabilities" are acquired and released where
required. An obvious application is lock-safety checking for the kernel's
various synchronization primitives (each of which represents a "capability"),
and checking that locking rules are not violated.

Clang originally called the feature "Thread Safety Analysis" [1], with
some terminology still using the thread-safety-analysis-only names. This
was later changed and the feature became more flexible, gaining the
ability to define custom "capabilities". Its foundations can be found in
"capability systems", used to specify the permissibility of operations
to depend on some capability being held (or not held).

[1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
[2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf

Because the feature is not just able to express capabilities related to
synchronization primitives, the naming chosen for the kernel departs
from Clang's initial "Thread Safety" nomenclature and refers to the
feature as "Capability Analysis" to avoid confusion. The implementation
still makes references to the older terminology in some places, such as
`-Wthread-safety` being the warning enabled option that also still
appears in diagnostic messages.

See more details in the kernel-doc documentation added in this and the
subsequent changes.

A Clang version that supports -Wthread-safety-pointer is recommended,
but not required: https://github.com/llvm/llvm-project/commit/de10e44b6fe7

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New -Wthread-safety feature rename to -Wthread-safety-pointer (was
  -Wthread-safety-addressof).
* Introduce __capability_unsafe() function attribute.
* Rename __var_guarded_by to simply __guarded_by. The initial idea was
  to be explicit if the variable or pointed-to data is guarded by, but
  having a shorter attribute name is likely better long-term.
* Rename __ref_guarded_by to __pt_guarded_by (pointed-to guarded by).
---
 Makefile                                     |   1 +
 include/linux/compiler-capability-analysis.h | 394 ++++++++++++++++++-
 lib/Kconfig.debug                            |  29 ++
 scripts/Makefile.capability-analysis         |   7 +
 scripts/Makefile.lib                         |  10 +
 5 files changed, 434 insertions(+), 7 deletions(-)
 create mode 100644 scripts/Makefile.capability-analysis

diff --git a/Makefile b/Makefile
index 70bdbf2218fc..3a945098515e 100644
--- a/Makefile
+++ b/Makefile
@@ -1082,6 +1082,7 @@ include-$(CONFIG_KCOV)		+= scripts/Makefile.kcov
 include-$(CONFIG_RANDSTRUCT)	+= scripts/Makefile.randstruct
 include-$(CONFIG_AUTOFDO_CLANG)	+= scripts/Makefile.autofdo
 include-$(CONFIG_PROPELLER_CLANG)	+= scripts/Makefile.propeller
+include-$(CONFIG_WARN_CAPABILITY_ANALYSIS) += scripts/Makefile.capability-analysis
 include-$(CONFIG_GCC_PLUGINS)	+= scripts/Makefile.gcc-plugins
 
 include $(addprefix $(srctree)/, $(include-y))
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index 7546ddb83f86..c47d9ed18303 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -6,26 +6,406 @@
 #ifndef _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
 #define _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
 
+#if defined(WARN_CAPABILITY_ANALYSIS)
+
+/*
+ * The below attributes are used to define new capability types. Internal only.
+ */
+# define __cap_type(name)			__attribute__((capability(#name)))
+# define __acquires_cap(var)			__attribute__((acquire_capability(var)))
+# define __acquires_shared_cap(var)		__attribute__((acquire_shared_capability(var)))
+# define __try_acquires_cap(ret, var)		__attribute__((try_acquire_capability(ret, var)))
+# define __try_acquires_shared_cap(ret, var)	__attribute__((try_acquire_shared_capability(ret, var)))
+# define __releases_cap(var)			__attribute__((release_capability(var)))
+# define __releases_shared_cap(var)		__attribute__((release_shared_capability(var)))
+# define __asserts_cap(var)			__attribute__((assert_capability(var)))
+# define __asserts_shared_cap(var)		__attribute__((assert_shared_capability(var)))
+# define __returns_cap(var)			__attribute__((lock_returned(var)))
+
+/*
+ * The below are used to annotate code being checked. Internal only.
+ */
+# define __excludes_cap(var)		__attribute__((locks_excluded(var)))
+# define __requires_cap(var)		__attribute__((requires_capability(var)))
+# define __requires_shared_cap(var)	__attribute__((requires_shared_capability(var)))
+
+/**
+ * __guarded_by - struct member and globals attribute, declares variable
+ *                protected by capability
+ * @var: the capability instance that guards the member or global
+ *
+ * Declares that the struct member or global variable must be guarded by the
+ * given capability @var. Read operations on the data require shared access,
+ * while write operations require exclusive access.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_state {
+ *		spinlock_t lock;
+ *		long counter __guarded_by(&lock);
+ *	};
+ */
+# define __guarded_by(var)		__attribute__((guarded_by(var)))
+
+/**
+ * __pt_guarded_by - struct member and globals attribute, declares pointed-to
+ *                   data is protected by capability
+ * @var: the capability instance that guards the member or global
+ *
+ * Declares that the data pointed to by the struct member pointer or global
+ * pointer must be guarded by the given capability @var. Read operations on the
+ * data require shared access, while write operations require exclusive access.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_state {
+ *		spinlock_t lock;
+ *		long *counter __pt_guarded_by(&lock);
+ *	};
+ */
+# define __pt_guarded_by(var)		__attribute__((pt_guarded_by(var)))
+
+/**
+ * struct_with_capability() - declare or define a capability struct
+ * @name: struct name
+ *
+ * Helper to declare or define a struct type with capability of the same name.
+ *
+ * .. code-block:: c
+ *
+ *	struct_with_capability(my_handle) {
+ *		int foo;
+ *		long bar;
+ *	};
+ *
+ *	struct some_state {
+ *		...
+ *	};
+ *	// ... declared elsewhere ...
+ *	struct_with_capability(some_state);
+ *
+ * Note: The implementation defines several helper functions that can acquire,
+ * release, and assert the capability.
+ */
+# define struct_with_capability(name)									\
+	struct __cap_type(name) name;									\
+	static __always_inline void __acquire_cap(const struct name *var)				\
+		__attribute__((overloadable)) __no_capability_analysis __acquires_cap(var) { }		\
+	static __always_inline void __acquire_shared_cap(const struct name *var)			\
+		__attribute__((overloadable)) __no_capability_analysis __acquires_shared_cap(var) { }	\
+	static __always_inline bool __try_acquire_cap(const struct name *var, bool ret)			\
+		__attribute__((overloadable)) __no_capability_analysis __try_acquires_cap(1, var)	\
+	{ return ret; }											\
+	static __always_inline bool __try_acquire_shared_cap(const struct name *var, bool ret)		\
+		__attribute__((overloadable)) __no_capability_analysis __try_acquires_shared_cap(1, var) \
+	{ return ret; }											\
+	static __always_inline void __release_cap(const struct name *var)				\
+		__attribute__((overloadable)) __no_capability_analysis __releases_cap(var) { }		\
+	static __always_inline void __release_shared_cap(const struct name *var)			\
+		__attribute__((overloadable)) __no_capability_analysis __releases_shared_cap(var) { }	\
+	static __always_inline void __assert_cap(const struct name *var)				\
+		__attribute__((overloadable)) __asserts_cap(var) { }					\
+	static __always_inline void __assert_shared_cap(const struct name *var)				\
+		__attribute__((overloadable)) __asserts_shared_cap(var) { }				\
+	struct name
+
+/**
+ * disable_capability_analysis() - disables capability analysis
+ *
+ * Disables capability analysis. Must be paired with a later
+ * enable_capability_analysis().
+ */
+# define disable_capability_analysis()				\
+	__diag_push();						\
+	__diag_ignore_all("-Wunknown-warning-option", "")	\
+	__diag_ignore_all("-Wthread-safety", "")		\
+	__diag_ignore_all("-Wthread-safety-pointer", "")
+
+/**
+ * enable_capability_analysis() - re-enables capability analysis
+ *
+ * Re-enables capability analysis. Must be paired with a prior
+ * disable_capability_analysis().
+ */
+# define enable_capability_analysis() __diag_pop()
+
+/**
+ * __no_capability_analysis - function attribute, disables capability analysis
+ *
+ * Function attribute denoting that capability analysis is disabled for the
+ * whole function. Prefer use of `capability_unsafe()` where possible.
+ */
+# define __no_capability_analysis	__attribute__((no_thread_safety_analysis))
+
+#else /* !WARN_CAPABILITY_ANALYSIS */
+
+# define __cap_type(name)
+# define __acquires_cap(var)
+# define __acquires_shared_cap(var)
+# define __try_acquires_cap(ret, var)
+# define __try_acquires_shared_cap(ret, var)
+# define __releases_cap(var)
+# define __releases_shared_cap(var)
+# define __asserts_cap(var)
+# define __asserts_shared_cap(var)
+# define __returns_cap(var)
+# define __guarded_by(var)
+# define __pt_guarded_by(var)
+# define __excludes_cap(var)
+# define __requires_cap(var)
+# define __requires_shared_cap(var)
+# define __acquire_cap(var)			do { } while (0)
+# define __acquire_shared_cap(var)		do { } while (0)
+# define __try_acquire_cap(var, ret)		(ret)
+# define __try_acquire_shared_cap(var, ret)	(ret)
+# define __release_cap(var)			do { } while (0)
+# define __release_shared_cap(var)		do { } while (0)
+# define __assert_cap(var)			do { (void)(var); } while (0)
+# define __assert_shared_cap(var)		do { (void)(var); } while (0)
+# define struct_with_capability(name)		struct name
+# define disable_capability_analysis()
+# define enable_capability_analysis()
+# define __no_capability_analysis
+
+#endif /* WARN_CAPABILITY_ANALYSIS */
+
+/**
+ * capability_unsafe() - disable capability checking for contained code
+ *
+ * Disables capability checking for contained statements or expression.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_data {
+ *		spinlock_t lock;
+ *		int counter __guarded_by(&lock);
+ *	};
+ *
+ *	int foo(struct some_data *d)
+ *	{
+ *		// ...
+ *		// other code that is still checked ...
+ *		// ...
+ *		return capability_unsafe(d->counter);
+ *	}
+ */
+#define capability_unsafe(...)		\
+({					\
+	disable_capability_analysis();	\
+	__VA_ARGS__;			\
+	enable_capability_analysis()	\
+})
+
+/**
+ * __capability_unsafe() - function attribute, disable capability checking
+ * @comment: comment explaining why opt-out is safe
+ *
+ * Function attribute denoting that capability analysis is disabled for the
+ * whole function. Forces adding an inline comment as argument.
+ */
+#define __capability_unsafe(comment) __no_capability_analysis
+
+/**
+ * token_capability() - declare an abstract global capability instance
+ * @name: token capability name
+ *
+ * Helper that declares an abstract global capability instance @name that can be
+ * used as a token capability, but not backed by a real data structure (linker
+ * error if accidentally referenced). The type name is `__capability_@name`.
+ */
+#define token_capability(name)				\
+	struct_with_capability(__capability_##name) {};	\
+	extern const struct __capability_##name *name
+
+/**
+ * token_capability_instance() - declare another instance of a global capability
+ * @cap: token capability previously declared with token_capability()
+ * @name: name of additional global capability instance
+ *
+ * Helper that declares an additional instance @name of the same token
+ * capability class @name. This is helpful where multiple related token
+ * capabilities are declared, as it also allows using the same underlying type
+ * (`__capability_@cap`) as function arguments.
+ */
+#define token_capability_instance(cap, name)		\
+	extern const struct __capability_##cap *name
+
+/*
+ * Common keywords for static capability analysis. Both Clang's capability
+ * analysis and Sparse's context tracking are currently supported.
+ */
 #ifdef __CHECKER__
 
 /* Sparse context/lock checking support. */
 # define __must_hold(x)		__attribute__((context(x,1,1)))
+# define __must_not_hold(x)
 # define __acquires(x)		__attribute__((context(x,0,1)))
 # define __cond_acquires(x)	__attribute__((context(x,0,-1)))
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
 # define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
+/* For Sparse, there's no distinction between exclusive and shared locks. */
+# define __must_hold_shared	__must_hold
+# define __acquires_shared	__acquires
+# define __cond_acquires_shared __cond_acquires
+# define __releases_shared	__releases
+# define __acquire_shared	__acquire
+# define __release_shared	__release
+# define __cond_lock_shared	__cond_acquire
 
 #else /* !__CHECKER__ */
 
-# define __must_hold(x)
-# define __acquires(x)
-# define __cond_acquires(x)
-# define __releases(x)
-# define __acquire(x)		(void)0
-# define __release(x)		(void)0
-# define __cond_lock(x, c)	(c)
+/**
+ * __must_hold() - function attribute, caller must hold exclusive capability
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the caller must hold the given capability
+ * instance @x exclusively.
+ */
+# define __must_hold(x)		__requires_cap(x)
+
+/**
+ * __must_not_hold() - function attribute, caller must not hold capability
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the caller must not hold the given
+ * capability instance @x.
+ */
+# define __must_not_hold(x)	__excludes_cap(x)
+
+/**
+ * __acquires() - function attribute, function acquires capability exclusively
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function acquires the given
+ * capability instance @x exclusively, but does not release it.
+ */
+# define __acquires(x)		__acquires_cap(x)
+
+/**
+ * __cond_acquires() - function attribute, function conditionally
+ *                     acquires a capability exclusively
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function conditionally acquires the
+ * given capability instance @x exclusively, but does not release it.
+ */
+# define __cond_acquires(x)	__try_acquires_cap(1, x)
+
+/**
+ * __releases() - function attribute, function releases a capability exclusively
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function releases the given capability
+ * instance @x exclusively. The capability must be held on entry.
+ */
+# define __releases(x)		__releases_cap(x)
+
+/**
+ * __acquire() - function to acquire capability exclusively
+ * @x: capability instance pinter
+ *
+ * No-op function that acquires the given capability instance @x exclusively.
+ */
+# define __acquire(x)		__acquire_cap(x)
+
+/**
+ * __release() - function to release capability exclusively
+ * @x: capability instance pinter
+ *
+ * No-op function that releases the given capability instance @x.
+ */
+# define __release(x)		__release_cap(x)
+
+/**
+ * __cond_lock() - function that conditionally acquires a capability
+ *                 exclusively
+ * @x: capability instance pinter
+ * @c: boolean expression
+ *
+ * Return: result of @c
+ *
+ * No-op function that conditionally acquires capability instance @x
+ * exclusively, if the boolean expression @c is true. The result of @c is the
+ * return value, to be able to create a capability-enabled interface; for
+ * example:
+ *
+ * .. code-block:: c
+ *
+ *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
+ */
+# define __cond_lock(x, c)	__try_acquire_cap(x, c)
+
+/**
+ * __must_hold_shared() - function attribute, caller must hold shared capability
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the caller must hold the given capability
+ * instance @x with shared access.
+ */
+# define __must_hold_shared(x)	__requires_shared_cap(x)
+
+/**
+ * __acquires_shared() - function attribute, function acquires capability shared
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function acquires the given
+ * capability instance @x with shared access, but does not release it.
+ */
+# define __acquires_shared(x)	__acquires_shared_cap(x)
+
+/**
+ * __cond_acquires_shared() - function attribute, function conditionally
+ *                            acquires a capability shared
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function conditionally acquires the
+ * given capability instance @x with shared access, but does not release it.
+ */
+# define __cond_acquires_shared(x) __try_acquires_shared_cap(1, x)
+
+/**
+ * __releases_shared() - function attribute, function releases a
+ *                       capability shared
+ * @x: capability instance pointer
+ *
+ * Function attribute declaring that the function releases the given capability
+ * instance @x with shared access. The capability must be held on entry.
+ */
+# define __releases_shared(x)	__releases_shared_cap(x)
+
+/**
+ * __acquire_shared() - function to acquire capability shared
+ * @x: capability instance pinter
+ *
+ * No-op function that acquires the given capability instance @x with shared
+ * access.
+ */
+# define __acquire_shared(x)	__acquire_shared_cap(x)
+
+/**
+ * __release_shared() - function to release capability shared
+ * @x: capability instance pinter
+ *
+ * No-op function that releases the given capability instance @x with shared
+ * access.
+ */
+# define __release_shared(x)	__release_shared_cap(x)
+
+/**
+ * __cond_lock_shared() - function that conditionally acquires a capability
+ *                        shared
+ * @x: capability instance pinter
+ * @c: boolean expression
+ *
+ * Return: result of @c
+ *
+ * No-op function that conditionally acquires capability instance @x with shared
+ * access, if the boolean expression @c is true. The result of @c is the return
+ * value, to be able to create a capability-enabled interface.
+ */
+# define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
 
 #endif /* __CHECKER__ */
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1af972a92d06..f30099051294 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -603,6 +603,35 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
+config WARN_CAPABILITY_ANALYSIS
+	bool "Compiler capability-analysis warnings"
+	depends on CC_IS_CLANG && $(cc-option,-Wthread-safety -fexperimental-late-parse-attributes)
+	# Branch profiling re-defines "if", which messes with the compiler's
+	# ability to analyze __cond_acquires(..), resulting in false positives.
+	depends on !TRACE_BRANCH_PROFILING
+	default y
+	help
+	  Capability analysis is a C language extension, which enables
+	  statically checking that user-definable "capabilities" are acquired
+	  and released where required.
+
+	  Clang's name of the feature ("Thread Safety Analysis") refers to
+	  the original name of the feature; it was later expanded to be a
+	  generic "Capability Analysis" framework.
+
+	  Produces warnings by default. Select CONFIG_WERROR if you wish to
+	  turn these warnings into errors.
+
+config WARN_CAPABILITY_ANALYSIS_ALL
+	bool "Enable capability analysis for all source files"
+	depends on WARN_CAPABILITY_ANALYSIS
+	depends on EXPERT && !COMPILE_TEST
+	help
+	  Enable tree-wide capability analysis. This is likely to produce a
+	  large number of false positives - enable at your own risk.
+
+	  If unsure, say N.
+
 endmenu # "Compiler options"
 
 menu "Generic Kernel Debugging Instruments"
diff --git a/scripts/Makefile.capability-analysis b/scripts/Makefile.capability-analysis
new file mode 100644
index 000000000000..b7b36cca47f4
--- /dev/null
+++ b/scripts/Makefile.capability-analysis
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+capability-analysis-cflags := -DWARN_CAPABILITY_ANALYSIS	\
+	-fexperimental-late-parse-attributes -Wthread-safety	\
+	$(call cc-option,-Wthread-safety-pointer)
+
+export CFLAGS_CAPABILITY_ANALYSIS := $(capability-analysis-cflags)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cad20f0e66ee..08910001ee64 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -191,6 +191,16 @@ _c_flags += $(if $(patsubst n%,, \
 	-D__KCSAN_INSTRUMENT_BARRIERS__)
 endif
 
+#
+# Enable capability analysis flags only where explicitly opted in.
+# (depends on variables CAPABILITY_ANALYSIS_obj.o, CAPABILITY_ANALYSIS)
+#
+ifeq ($(CONFIG_WARN_CAPABILITY_ANALYSIS),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(CAPABILITY_ANALYSIS_$(target-stem).o)$(CAPABILITY_ANALYSIS)$(if $(is-kernel-object),$(CONFIG_WARN_CAPABILITY_ANALYSIS_ALL))), \
+		$(CFLAGS_CAPABILITY_ANALYSIS))
+endif
+
 #
 # Enable AutoFDO build flags except some files or directories we don't want to
 # enable (depends on variables AUTOFDO_PROFILE_obj.o and AUTOFDO_PROFILE).
-- 
2.48.1.711.g2feabab25a-goog

