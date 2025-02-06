Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D037B1A5BB0
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865872; cv=none; b=rd5Dobgzul9QD/mv+WyDk3yGuJcBPlfj9pcWaE9PJWdE6Cejl+rzZmTBgdoU5us1Fh5hLFaMi17x2IM6fc/d1TpWCiIARHaO/CxThQ2WF2MyF07tpdEbS4CABgKxdaP65K9MNQHzbAul92hG81Du6+3XloQIs9xQs7P+A1LKlnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865872; c=relaxed/simple;
	bh=yFPTPmKgM1WyRS4/pLwj/qD4AEqMsgmnBOUoRJkxsqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EEkk4Lcm5oOMqt1fudLpoYwQH1ylo5OLfmJyc5Ip76JdBoLUHNDcx4pkll9OHfVQY53yvfw+SQjo2EjvqNTSi6O01yA6/4Z9QycNxJx4+6CjzfTTqUOQKJK1AIl7FF/Cmifd0bJ6glIeHHn+HsOEYygEA7kPiytyLYgHwSgRMx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h8Q5oXDB; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h8Q5oXDB"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5dce1b1a2b3so1385807a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865868; x=1739470668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qF82DJs8+giiKRyetuSOsU+JANR9VCfWNPadmkefX9I=;
        b=h8Q5oXDBlm8Do82HkcBRkumMnHB5P/Hw1WzIcIg1XuVgBAWhfqnu+NP8ZpS4/ZaT+O
         rNy5fc0uBT7EV78LB8BI3wY+PgP62QqLEFb9n4cB/PSfdZ0mLKelYPcdFhXdhlC6ZWTj
         p7DIK6a3KPxScbjtaPUY0VojhABy0qQgjGUXBFRNbicEx+m5lzpn1m5fQq9dPzcsfi/S
         aRqzCLfuX5PTx/wya/4c/rRY+0yhEpg9rTi/+QtEAO54nLG53zPNyc6ZsGMH4P4lTAyE
         ZT/Xug3WG8KOK7wuEzNTXzzb0kOVWVmGWeXdUIFL5PwnbLUOaYqn3rOJEUZj2K3t0h3e
         ocTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865868; x=1739470668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qF82DJs8+giiKRyetuSOsU+JANR9VCfWNPadmkefX9I=;
        b=SDOhF2oH/6a1aH575xc1OBiurie4XOxaS0nLk/8bt/U1MT09rYEKc2sS1Nh4EqHISk
         dX1bp/NdwVKcMb8jgMTUHRuGZpmLQCS9j38J0ZZqLpGTWRoFJ8ZV7lqF2FYA38D3d8hZ
         dMvVnoBR9FRgM+3MPYLWYABNvfAU0vQjjR0RQu++TmIKTqEbslT6NakfWbmgU7jbh9FL
         DrTd69v80muLOJGPfI9EarDXzEVPzqNG42Pqza1MZPgG/9BDAZQkOPDIDXlPUrwgutHz
         WlTfnpmjxX2yKVEWFNsvEYkeyKfhOvJWuy1TLLAR28BeNa2+RrqMG8SuTvrFWWMI/lKo
         /faQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXew1bcEscUD8ys+5IeB1eQsm3ABzzE9egQnl/Uv3Z6J4psXrd+XEGYqrHQj5tZpKZGO4PcE9WYGo05Gc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2OwfioepH2/bbPQN2RDaPrAUTtiw1D52SR6+h5VO1dEDqKoKe
	Uhe3yp6bJlenPyt2JCQ9iYGU/wkLGbNE98WuTOn9ABEjx8+FOixYtzXIyuJnpiwbI5k/dV2LTQ=
	=
X-Google-Smtp-Source: AGHT+IFhkhtKPOLjUVtcZrbrdXay8cNt9Gf56kNUcmjSPeBOeQQDqEs7f95+SgyQPwoEkhsZdOCvuOgK1w==
X-Received: from edbcs11.prod.google.com ([2002:a05:6402:c4b:b0:5dc:22e2:2325])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5290:b0:5dc:5a2f:a726
 with SMTP id 4fb4d7f45d1cf-5de45072314mr470242a12.22.1738865868148; Thu, 06
 Feb 2025 10:17:48 -0800 (PST)
Date: Thu,  6 Feb 2025 19:09:55 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-2-elver@google.com>
Subject: [PATCH RFC 01/24] compiler_types: Move lock checking attributes to compiler-capability-analysis.h
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

The conditional definition of lock checking macros and attributes is
about to become more complex. Factor them out into their own header for
better readability, and to make it obvious which features are supported
by which mode (currently only Sparse). This is the first step towards
generalizing towards "capability analysis".

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/compiler-capability-analysis.h | 32 ++++++++++++++++++++
 include/linux/compiler_types.h               | 18 ++---------
 2 files changed, 34 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/compiler-capability-analysis.h

diff --git a/include/linux/compiler-capability-analysis.h b/include/linux/compiler-capability-analysis.h
new file mode 100644
index 000000000000..7546ddb83f86
--- /dev/null
+++ b/include/linux/compiler-capability-analysis.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros and attributes for compiler-based static capability analysis.
+ */
+
+#ifndef _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
+#define _LINUX_COMPILER_CAPABILITY_ANALYSIS_H
+
+#ifdef __CHECKER__
+
+/* Sparse context/lock checking support. */
+# define __must_hold(x)		__attribute__((context(x,1,1)))
+# define __acquires(x)		__attribute__((context(x,0,1)))
+# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
+# define __releases(x)		__attribute__((context(x,1,0)))
+# define __acquire(x)		__context__(x,1)
+# define __release(x)		__context__(x,-1)
+# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
+
+#else /* !__CHECKER__ */
+
+# define __must_hold(x)
+# define __acquires(x)
+# define __cond_acquires(x)
+# define __releases(x)
+# define __acquire(x)		(void)0
+# define __release(x)		(void)0
+# define __cond_lock(x, c)	(c)
+
+#endif /* __CHECKER__ */
+
+#endif /* _LINUX_COMPILER_CAPABILITY_ANALYSIS_H */
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 981cc3d7e3aa..4a458e41293c 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -24,6 +24,8 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <linux/compiler-capability-analysis.h>
+
 /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 /* address spaces */
@@ -34,14 +36,6 @@
 # define __rcu		__attribute__((noderef, address_space(__rcu)))
 static inline void __chk_user_ptr(const volatile void __user *ptr) { }
 static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
-/* context/locking */
-# define __must_hold(x)	__attribute__((context(x,1,1)))
-# define __acquires(x)	__attribute__((context(x,0,1)))
-# define __cond_acquires(x) __attribute__((context(x,0,-1)))
-# define __releases(x)	__attribute__((context(x,1,0)))
-# define __acquire(x)	__context__(x,1)
-# define __release(x)	__context__(x,-1)
-# define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 /* other */
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
@@ -62,14 +56,6 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 
 # define __chk_user_ptr(x)	(void)0
 # define __chk_io_ptr(x)	(void)0
-/* context/locking */
-# define __must_hold(x)
-# define __acquires(x)
-# define __cond_acquires(x)
-# define __releases(x)
-# define __acquire(x)	(void)0
-# define __release(x)	(void)0
-# define __cond_lock(x,c) (c)
 /* other */
 # define __force
 # define __nocast
-- 
2.48.1.502.g6dc24dfdaf-goog

