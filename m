Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8597C2046B8
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080372; cv=none; b=qwvNr3DFzpHqU8DWn6elF7nCzrKN5ofkWUJlhQZmcZE2UpZIadVM/9zZXCepRpLz5VfKlPB6cPPPcdv9ahZKobFUCQMdC+YyozbkZ1vnh+NV4SQCGQkstcNDqwVneyvdN7Yb/RntV3pbxqJzVVwYlz3GtuoM+LIUzHPtOwZdFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080372; c=relaxed/simple;
	bh=66LwKwEvJHI65yeM4c4uuHM5+PNXrLfUMMtHzKvNEjk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IEf6Kx29Q/RVqusEzyu8wUB61w/ExJcUZDD2Bj5YKnsmalOlWhQE/Wbs8YFYVpprjX1mAyKv8G7REcuMVhTrHBUie++0ruDC6zR0KZTdh18Qb3sih+FOsn0DtOldH+ssfMz7Vh66bBCiDPKURktK1420a0/CoOK/6P/3pTN6roo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jrff2QmO; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jrff2QmO"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e550e71d33so2000755a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080369; x=1741685169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1I/GQ+v/3j1AzYCm6S00P34ezPJ7HmSy44l1ZDIovo=;
        b=jrff2QmOX09Vy9y2pZk0o7LchsLxoJOP9E9rI6e5XzkUWMWKTzpXUuBYk2p2tvTlk9
         LUeJaIc3J2KbvZWbl9FVyAvUz8iyJQ3i/WJt0e1LBLe49cjrwGSJod33vW7GKlAK9kY7
         w4fpglkHCuFbuvAdc3by5IxmaTrmO9Q2UCPbDbOmfAHUa24PlNyyZD/QhYolzcs8VE+M
         GsLVhtbVDalUOCHMmlFBTukJfu4bX2SWg2CiddjZi335NlQ8Bc5vj/PqVkeBZkfu49bj
         ui+NUcid/uMs7f0TrmhroQNdc8cQf+xcmyNH0kbvqEEaVZXpX190bMzw0vwUAhAL+iXv
         4nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080369; x=1741685169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1I/GQ+v/3j1AzYCm6S00P34ezPJ7HmSy44l1ZDIovo=;
        b=F+Y+N5FoRuKd9cvQZqP3yf4CNZfN6jQXW1KuKhBDkt+kEjaXgKohgD7CaJpmit1rR0
         k+uumfP+2+dRYiMNGsQx6aF1wxUlefjry4N5A2xeZo2GkDG8jVPNN014Jc+f8E0N8A10
         nc0nxdoTkkJ0kvIwUyu7tjeLhrkweLfj6VOY03wTWKOk5Xf6ZoooQw5/Jwu/Q9YFDKrR
         KcDCK1URPGSOPH6Ht05OFyQfAGioYqnN/jkFaYv9z6+5B1bSzmPXsU2wVOrgDIzKXc5u
         IJdkUUwlH2Wj5YZzL5H+BFBV1I2HEuGK9cNK9ieTopCy8as1ec6dcq5jDxlXeqPuWIOa
         4GQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaw7dqe/YgSIfZIH6X092dJcsX1ctaxL8KWH87WDY15oG6piQL938ve1ZqzwMCMT7dy6ytPWp87533Olo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4mlsp/81Yfh/gAxXnWOVu6jm+NyRxSdLqkV0ZeLXElD902xE+
	fS5BPEpoGm5k41FYwilLuDeVcSdkOzWiBpNObadHLcZPDw83m6X5nAVEm1fQ1/FxxwZ/RcUHPw=
	=
X-Google-Smtp-Source: AGHT+IFLim8eecum5uVex3hryFlz3FCAz5xVOg59Qt47EZvr2+Y6KQcxBittVbQ9kTNcN1THrZHhGDAhXQ==
X-Received: from edbet14.prod.google.com ([2002:a05:6402:378e:b0:5e5:762:2c87])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4407:b0:5dc:a44d:36a9
 with SMTP id 4fb4d7f45d1cf-5e4d6af158dmr16857891a12.14.1741080368800; Tue, 04
 Mar 2025 01:26:08 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:21 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-23-elver@google.com>
Subject: [PATCH v2 22/34] compiler-capability-analysis: Remove Sparse support
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

Remove Sparse support as discussed at [1].

The kernel codebase is still scattered with numerous places that try to
appease Sparse's context tracking ("annotation for sparse", "fake out
sparse", "work around sparse", etc.). Eventually, as more subsystems
enable Clang's capability analysis, these places will show up and need
adjustment or removal of the workarounds altogether.

Link: https://lore.kernel.org/all/20250207083335.GW7145@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/all/Z6XTKTo_LMj9KmbY@elver.google.com/ [2]
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 Documentation/dev-tools/sparse.rst           | 19 -------
 include/linux/compiler-capability-analysis.h | 56 ++++++--------------
 include/linux/rcupdate.h                     | 15 +-----
 3 files changed, 17 insertions(+), 73 deletions(-)

diff --git a/Documentation/dev-tools/sparse.rst b/Documentation/dev-tools/sparse.rst
index dc791c8d84d1..37b20170835d 100644
--- a/Documentation/dev-tools/sparse.rst
+++ b/Documentation/dev-tools/sparse.rst
@@ -53,25 +53,6 @@ sure that bitwise types don't get mixed up (little-endian vs big-endian
 vs cpu-endian vs whatever), and there the constant "0" really _is_
 special.
 
-Using sparse for lock checking
-------------------------------
-
-The following macros are undefined for gcc and defined during a sparse
-run to use the "context" tracking feature of sparse, applied to
-locking.  These annotations tell sparse when a lock is held, with
-regard to the annotated function's entry and exit.
-
-__must_hold - The specified lock is held on function entry and exit.
-
-__acquires - The specified lock is held on function exit, but not entry.
-
-__releases - The specified lock is held on function entry, but not exit.
-
-If the function enters and exits without the lock held, acquiring and
-releasing the lock inside the function in a balanced way, no
-annotation is needed.  The three annotations above are for cases where
-sparse would otherwise report a context imbalance.
-
 Getting sparse
 --------------
 
diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
index 832727fea140..741f88e1177f 100644
--- a/include/linux/compiler-capability-analysis.h
+++ b/include/linux/compiler-capability-analysis.h
@@ -231,30 +231,8 @@
 	extern const struct __capability_##cap *name
 
 /*
- * Common keywords for static capability analysis. Both Clang's capability
- * analysis and Sparse's context tracking are currently supported.
+ * Common keywords for static capability analysis.
  */
-#ifdef __CHECKER__
-
-/* Sparse context/lock checking support. */
-# define __must_hold(x)		__attribute__((context(x,1,1)))
-# define __must_not_hold(x)
-# define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
-# define __releases(x)		__attribute__((context(x,1,0)))
-# define __acquire(x)		__context__(x,1)
-# define __release(x)		__context__(x,-1)
-# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
-/* For Sparse, there's no distinction between exclusive and shared locks. */
-# define __must_hold_shared	__must_hold
-# define __acquires_shared	__acquires
-# define __cond_acquires_shared __cond_acquires
-# define __releases_shared	__releases
-# define __acquire_shared	__acquire
-# define __release_shared	__release
-# define __cond_lock_shared	__cond_acquire
-
-#else /* !__CHECKER__ */
 
 /**
  * __must_hold() - function attribute, caller must hold exclusive capability
@@ -263,7 +241,7 @@
  * Function attribute declaring that the caller must hold the given capability
  * instance @x exclusively.
  */
-# define __must_hold(x)		__requires_cap(x)
+#define __must_hold(x)		__requires_cap(x)
 
 /**
  * __must_not_hold() - function attribute, caller must not hold capability
@@ -272,7 +250,7 @@
  * Function attribute declaring that the caller must not hold the given
  * capability instance @x.
  */
-# define __must_not_hold(x)	__excludes_cap(x)
+#define __must_not_hold(x)	__excludes_cap(x)
 
 /**
  * __acquires() - function attribute, function acquires capability exclusively
@@ -281,7 +259,7 @@
  * Function attribute declaring that the function acquires the given
  * capability instance @x exclusively, but does not release it.
  */
-# define __acquires(x)		__acquires_cap(x)
+#define __acquires(x)		__acquires_cap(x)
 
 /*
  * Clang's analysis does not care precisely about the value, only that it is
@@ -308,7 +286,7 @@
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
+#define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a capability exclusively
@@ -317,7 +295,7 @@
  * Function attribute declaring that the function releases the given capability
  * instance @x exclusively. The capability must be held on entry.
  */
-# define __releases(x)		__releases_cap(x)
+#define __releases(x)		__releases_cap(x)
 
 /**
  * __acquire() - function to acquire capability exclusively
@@ -325,7 +303,7 @@
  *
  * No-op function that acquires the given capability instance @x exclusively.
  */
-# define __acquire(x)		__acquire_cap(x)
+#define __acquire(x)		__acquire_cap(x)
 
 /**
  * __release() - function to release capability exclusively
@@ -333,7 +311,7 @@
  *
  * No-op function that releases the given capability instance @x.
  */
-# define __release(x)		__release_cap(x)
+#define __release(x)		__release_cap(x)
 
 /**
  * __cond_lock() - function that conditionally acquires a capability
@@ -352,7 +330,7 @@
  *
  *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
  */
-# define __cond_lock(x, c)	__try_acquire_cap(x, c)
+#define __cond_lock(x, c)	__try_acquire_cap(x, c)
 
 /**
  * __must_hold_shared() - function attribute, caller must hold shared capability
@@ -361,7 +339,7 @@
  * Function attribute declaring that the caller must hold the given capability
  * instance @x with shared access.
  */
-# define __must_hold_shared(x)	__requires_shared_cap(x)
+#define __must_hold_shared(x)	__requires_shared_cap(x)
 
 /**
  * __acquires_shared() - function attribute, function acquires capability shared
@@ -370,7 +348,7 @@
  * Function attribute declaring that the function acquires the given
  * capability instance @x with shared access, but does not release it.
  */
-# define __acquires_shared(x)	__acquires_shared_cap(x)
+#define __acquires_shared(x)	__acquires_shared_cap(x)
 
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
@@ -384,7 +362,7 @@
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
+#define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
 
 /**
  * __releases_shared() - function attribute, function releases a
@@ -394,7 +372,7 @@
  * Function attribute declaring that the function releases the given capability
  * instance @x with shared access. The capability must be held on entry.
  */
-# define __releases_shared(x)	__releases_shared_cap(x)
+#define __releases_shared(x)	__releases_shared_cap(x)
 
 /**
  * __acquire_shared() - function to acquire capability shared
@@ -403,7 +381,7 @@
  * No-op function that acquires the given capability instance @x with shared
  * access.
  */
-# define __acquire_shared(x)	__acquire_shared_cap(x)
+#define __acquire_shared(x)	__acquire_shared_cap(x)
 
 /**
  * __release_shared() - function to release capability shared
@@ -412,7 +390,7 @@
  * No-op function that releases the given capability instance @x with shared
  * access.
  */
-# define __release_shared(x)	__release_shared_cap(x)
+#define __release_shared(x)	__release_shared_cap(x)
 
 /**
  * __cond_lock_shared() - function that conditionally acquires a capability
@@ -426,8 +404,6 @@
  * access, if the boolean expression @c is true. The result of @c is the return
  * value, to be able to create a capability-enabled interface.
  */
-# define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
-
-#endif /* __CHECKER__ */
+#define __cond_lock_shared(x, c) __try_acquire_shared_cap(x, c)
 
 #endif /* _LINUX_COMPILER_CAPABILITY_ANALYSIS_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ef8875c4e621..75a2e8c30a3f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1183,20 +1183,7 @@ rcu_head_after_call_rcu(struct rcu_head *rhp, rcu_callback_t f)
 extern int rcu_expedited;
 extern int rcu_normal;
 
-DEFINE_LOCK_GUARD_0(rcu,
-	do {
-		rcu_read_lock();
-		/*
-		 * sparse doesn't call the cleanup function,
-		 * so just release immediately and don't track
-		 * the context. We don't need to anyway, since
-		 * the whole point of the guard is to not need
-		 * the explicit unlock.
-		 */
-		__release(RCU);
-	} while (0),
-	rcu_read_unlock())
-
+DEFINE_LOCK_GUARD_0(rcu, rcu_read_lock(), rcu_read_unlock())
 DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU));
 
 #endif /* __LINUX_RCUPDATE_H */
-- 
2.48.1.711.g2feabab25a-goog

