Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568D1DFD9A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865886; cv=none; b=B23UsZN1Hf5feHg14pbFhUxI8EzulhCAMduLju13usMt1yAmxf9rLbQoa8a2qm096lytxMyfy2QocLvRSlRF3agy0xErmA0/w8pyut4yVq808O8dVQKwKj96hatBHHqFYFMb2oR/p/S33GEna29w7cSknrN0YVKqFOXLiv6tE1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865886; c=relaxed/simple;
	bh=nbrPwXyZS1EvTzB5y+SypJlT/s4PiDMg7VB+pOJqZ2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YL8t6DFDsGnPUOShvbaHaXC6Q3bVF5OE4QKSjFZ0+TfPmW4GZqtiIAfrzVGHjOoEv66WyaWHn5giSE+ciAlE1WevrluAk/ReA5ry+wzv3nXhF9LnaCZvVY1sFtWj+wI5z0prgw6uSnHRLQgj9KP/m38lV20u++a+wouIktjgVVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bk7WjvjF; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bk7WjvjF"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ab6e2b653a0so145151666b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865883; x=1739470683; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DbQd0Feo/QZz3Rhlb0Ii9wR2JgNHixpKT0msEk4JbI=;
        b=bk7WjvjFVYAf2KOpHRMqC2KHFewZGo+a1MN8tjt1FxDZYFYpx5faGTdcW/0ozFvpLt
         nWh/ckwZyxgHi8cw1yGj5ibTIlsW3oxTxARraym7hqDgr38W6Ch/TTRPOJg476A1nJ+d
         wvWAzc8yllD0aF0ji0II36tK18mLDrvDEFtbjtyaREAG8EWlhheLF7MHh9EIgjX2Ylpg
         prGwDeHVKOFP3oGV9DZngU709BNycm5Y7QYN9q4I97dO9cGvoQB+ZLlRoQ5+p1rxD9Zn
         pSt4HoLUxVaoGTHTO+wLCwYkd/1UeoUMsafPzEp9BgvU9PhqvfTpJ5BhpAn1g4mxy0Dp
         AotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865883; x=1739470683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DbQd0Feo/QZz3Rhlb0Ii9wR2JgNHixpKT0msEk4JbI=;
        b=AHRWatuRA5KbG/gT9vAr//sIxKZGZ67tiOHighdezWgCdpP9hApHJswtP0ip5uOl2I
         Y3+AH5Gwdu/+ms4KPxFpnAottXFSGJGt/QptRR3xaBJ07fSckPacYcIZb/B6ie9ZwxAn
         nb0gF0/2u56qY+iS0i0fzEU31Ety9I8qpnBchzO88AeQyGJvHupnfnKLJLtr5KOnNWts
         AYLVH6ZNdhL3aN+6WptYyMVPHR8F/xaDoLxPY31vVjAVXO9hYZPIJ8VhiYBn0CAOIVFB
         iGbRAHHJLVAdVnTofpKPorFuk4ag0EIKFxCmUN1NevTYPj35sZOEJL8wodyaIr3Dxl2V
         z+Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVTW219HXhQW9kh9yzPb05yjKfDP33Nv6eDj6qUfC7b8zbFaabq5KJnPJKHp3NdJZ6iOHr0I56bE2COeVU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2hZwVrQuIlEfFhQLayK+NRDGiR1X18kjz8RhUnteWpB0lRPiH
	o7UHCqyQLu4pV+96ij/HaReeW6Yprs1geMtzuO69a3anI804V53HCtB1+tqoHHT+JyDU7c8gkw=
	=
X-Google-Smtp-Source: AGHT+IEpKrf/iQkrY6KOXq/iYZBQV1l1pAnmjhSh7YEqml+QLzZmS4/pcVjkplICVk/aelHvFs7D7YrXFw==
X-Received: from edbes17.prod.google.com ([2002:a05:6402:3811:b0:5d8:7c8:cde8])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7251:b0:aa6:6885:e2f0
 with SMTP id a640c23a62f3a-ab75e35de7emr916219966b.46.1738865883628; Thu, 06
 Feb 2025 10:18:03 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:01 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-8-elver@google.com>
Subject: [PATCH RFC 07/24] cleanup: Basic compatibility with capability analysis
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

Due to the scoped cleanup helpers used for lock guards wrapping
acquire/release around their own constructors/destructors that store
pointers to the passed locks in a separate struct, we currently cannot
accurately annotate *destructors* which lock was released. While it's
possible to annotate the constructor to say which lock was acquired,
that alone would result in false positives claiming the lock was not
released on function return.

Instead, to avoid false positives, we can claim that the constructor
"asserts" that the taken lock is held. This will ensure we can still
benefit from the analysis where scoped guards are used to protect access
to guarded variables, while avoiding false positives. The only downside
are false negatives where we might accidentally lock the same lock
again:

	raw_spin_lock(&my_lock);
	...
	guard(raw_spinlock)(&my_lock);  // no warning

Arguably, lockdep will immediately catch issues like this.

While Clang's analysis supports scoped guards in C++ [1], there's no way
to apply this to C right now. Better support for Linux's scoped guard
design could be added in future if deemed critical.

[1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#scoped-capability

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/cleanup.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ec00e3f7af2b..93a166549add 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -223,7 +223,7 @@ const volatile void * __must_check_fn(const volatile void *val)
  *	@exit is an expression using '_T' -- similar to FREE above.
  *	@init is an expression in @init_args resulting in @type
  *
- * EXTEND_CLASS(name, ext, init, init_args...):
+ * EXTEND_CLASS(name, ext, ctor_attrs, init, init_args...):
  *	extends class @name to @name@ext with the new constructor
  *
  * CLASS(name, var)(args...):
@@ -243,15 +243,18 @@ const volatile void * __must_check_fn(const volatile void *val)
 #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)		\
 typedef _type class_##_name##_t;					\
 static inline void class_##_name##_destructor(_type *p)			\
+	__no_capability_analysis					\
 { _type _T = *p; _exit; }						\
 static inline _type class_##_name##_constructor(_init_args)		\
+	__no_capability_analysis					\
 { _type t = _init; return t; }
 
-#define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+#define EXTEND_CLASS(_name, ext, ctor_attrs, _init, _init_args...)		\
 typedef class_##_name##_t class_##_name##ext##_t;			\
 static inline void class_##_name##ext##_destructor(class_##_name##_t *p)\
 { class_##_name##_destructor(p); }					\
 static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
+	__no_capability_analysis ctor_attrs					\
 { class_##_name##_t t = _init; return t; }
 
 #define CLASS(_name, var)						\
@@ -299,7 +302,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true); \
-	EXTEND_CLASS(_name, _ext, \
+	EXTEND_CLASS(_name, _ext,, \
 		     ({ void *_t = _T; if (_T && !(_condlock)) _t = NULL; _t; }), \
 		     class_##_name##_t _T) \
 	static inline void * class_##_name##_ext##_lock_ptr(class_##_name##_t *_T) \
@@ -371,6 +374,7 @@ typedef struct {							\
 } class_##_name##_t;							\
 									\
 static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
+	__no_capability_analysis					\
 {									\
 	if (_T->lock) { _unlock; }					\
 }									\
@@ -383,6 +387,7 @@ static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
 static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
+	__no_capability_analysis __asserts_cap(l)			\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
 	_lock;								\
@@ -391,6 +396,7 @@ static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
 
 #define __DEFINE_LOCK_GUARD_0(_name, _lock)				\
 static inline class_##_name##_t class_##_name##_constructor(void)	\
+	__no_capability_analysis					\
 {									\
 	class_##_name##_t _t = { .lock = (void*)1 },			\
 			 *_T __maybe_unused = &_t;			\
@@ -410,7 +416,7 @@ __DEFINE_LOCK_GUARD_0(_name, _lock)
 
 #define DEFINE_LOCK_GUARD_1_COND(_name, _ext, _condlock)		\
 	__DEFINE_CLASS_IS_CONDITIONAL(_name##_ext, true);		\
-	EXTEND_CLASS(_name, _ext,					\
+	EXTEND_CLASS(_name, _ext, __asserts_cap(l),			\
 		     ({ class_##_name##_t _t = { .lock = l }, *_T = &_t;\
 		        if (_T->lock && !(_condlock)) _T->lock = NULL;	\
 			_t; }),						\
-- 
2.48.1.502.g6dc24dfdaf-goog

