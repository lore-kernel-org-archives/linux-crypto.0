Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5B28489E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159121; cv=none; b=Z1uFCw5yfQkift159zI/vUR3/NkiA0pCSFhweuCOg8udTPEKa+rr/qs+rrRiQVHwT9UbMLf6NhZc0Ffy2R76JhaAi13C3hqVNXyBIJyhe/DysZd5WQ3yqiwAIRbUyyZUNHO+PI9Et6WaWryuYJi4yRzOUjlFwZqeE8cSxEuwuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159121; c=relaxed/simple;
	bh=Ik7Q1QK3m7JRRAoBflguqfhBl8xUfuhNClbCvfPvAiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AnUWVCgwCR9ijiMkQMwAvhxFWE4JoYGIf7YtVBgA6FrPm4y+9M47xFdrp0TiYqleliLk67GWfUdv6AdJAk4CZDYGSHYoD9sJztEYNS9FFLhrf+bBdkGq9xZ4kXHqkDgVu70Ok9C9NE+My74XyGsvxJK1PGQ4R86pg1fi2LQn084=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0puxOCuL; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0puxOCuL"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64d01707c32so9137a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 07:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159117; x=1766763917; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTTrpDgY6boLD/2fqquzR5fZiR/OECGrXMTsYaAZTdg=;
        b=0puxOCuLAdItHs2dSqsI5YSjIIJjQ04YiWr4bsc/CwHcivs+opsVSr06fy4UM1cnR4
         +d6IVwbFL1y1skTRll+gRZ6XQBsPKUvHtbtPqSi6FZIcdS+uwr7J1VHrkgYliRfIW0J6
         Q0EZzl0kRizhgDZussnbq4HAv86uTM/rZl2MLWwKHuzBC5h+SR57nCiePF25DNakmLUR
         r/bEd4smFWaPVeJyzl8+4COoPCEI/1dwrOPvkL9CZFcAty1stecrwnUAFXm7S/ZfkIS2
         YjJsiwrKeLTzvPhcBZ6fuPoRqgQg6EY0Yalj+eN92uXVuRqaoVgyS0WaJ8CQcf9/GFj9
         qJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159117; x=1766763917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTTrpDgY6boLD/2fqquzR5fZiR/OECGrXMTsYaAZTdg=;
        b=cIUVNkB9fl5g2bJmtLtNWDCd//6pKJ78h/X2Z9RpWbxIx6av832Oe4GNIYTMNaGbHt
         C6zTIFAfty5zFyaRlHF+yQUUCnizCNp/WN6ywZRr4J2I3lftOg0n+Xx97HxBNTX53ZMA
         WUfv6oHEMXuOTA8osyIa8oc5TTpK4Uy1nCeHGDUfhSBsHlrLzOFZcAR3UZKKRv1lf2zD
         kU8akQsHSyo+MSv6Ut8Yp4TrYlX8ojFsuWWhau5rqFpuVJBGkpTLbqjU+o0/CC5wx3Er
         0VIeXJb0s7oiurL6/OG4eOlDFShwrcBcJSJ0QiErOCZJNP7MjYjgxGzFOQKzGl9TtNan
         e4Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUZan0um92Ru9oR4f6Jfw4V2/sHst4zgPWnUqC8FCMqzGi+n7/lmULuo+S1Wm/4aTwX38LzZRnmfCT0BjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJsBCxIb+cBqpm0E3u9OqEBD3qrCvGasYBu8n3FaLPyzBUeJq8
	Bx83u3/2hBXeX75/NsRoLG+7QwBVCbB8FzAkS7Qxi3rv9LzqmPi2cWO9C2Bwr80d287TBAsNUg8
	FRw==
X-Google-Smtp-Source: AGHT+IFIQlGi8phgPKpWRTwxqlF14Y73hlUw2TFGVrXDbo950uyglJ5sCcodZJR2/zFCPCPTqrJC0MUdYQ==
X-Received: from edvd12.prod.google.com ([2002:aa7:ce0c:0:b0:64b:5a31:444e])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3582:b0:64c:584c:556c
 with SMTP id 4fb4d7f45d1cf-64c584c586dmr960916a12.30.1766159116689; Fri, 19
 Dec 2025 07:45:16 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:50 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-2-elver@google.com>
Subject: [PATCH v5 01/36] compiler_types: Move lock checking attributes to compiler-context-analysis.h
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The conditional definition of lock checking macros and attributes is
about to become more complex. Factor them out into their own header for
better readability, and to make it obvious which features are supported
by which mode (currently only Sparse). This is the first step towards
generalizing towards "context analysis".

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
v4:
* Rename capability -> context analysis.
---
 include/linux/compiler-context-analysis.h | 32 +++++++++++++++++++++++
 include/linux/compiler_types.h            | 18 ++-----------
 2 files changed, 34 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/compiler-context-analysis.h

diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
new file mode 100644
index 000000000000..f8af63045281
--- /dev/null
+++ b/include/linux/compiler-context-analysis.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros and attributes for compiler-based static context analysis.
+ */
+
+#ifndef _LINUX_COMPILER_CONTEXT_ANALYSIS_H
+#define _LINUX_COMPILER_CONTEXT_ANALYSIS_H
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
+#endif /* _LINUX_COMPILER_CONTEXT_ANALYSIS_H */
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 1280693766b9..ddada1ed88ea 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -41,6 +41,8 @@
 # define BTF_TYPE_TAG(value) /* nothing */
 #endif
 
+#include <linux/compiler-context-analysis.h>
+
 /* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
 #ifdef __CHECKER__
 /* address spaces */
@@ -51,14 +53,6 @@
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
@@ -79,14 +73,6 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 
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
2.52.0.322.g1dd061c0dc-goog

