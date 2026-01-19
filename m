Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240D354ACC
	for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815648; cv=none; b=LA1ZEbz+HukjEsXd4cWGQ0K0aCiKeaAYG5o40D16B89G1Up9FXiic6LuzmspxnLHAciof4XlZu/VZy6P4N6O6NwKoNAl5UUepQ4C/v0sHx64TrPrg7eSdbYj/qOtOw18pPLOmZkQpARHkRyHBcFj5jt+cXftUsqFd8ZNNznyvFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815648; c=relaxed/simple;
	bh=LFRNb1gEQo9FV1jLi6+eyd+fRn/YHv3OptpdwWFbVxE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Co2zlrnF00kEMQevar6omF+xgZraCt7Qx+2/ODDfzC9bix8lC/gl41EhNXN1BIfXSHMTe/6zV/6PrtQy5RVV6ktfU256FtkCIBmIIXDkFWEoE3RxG64J5izec0eMUTTefn4HOetOnkTguaEWouyL0QHwsioWIVpvssZXNAVLdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=37uQbcQ1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="37uQbcQ1"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4801c1056c7so18620675e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 01:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768815646; x=1769420446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tir03/0eTjGqYap+VXkH/YQyday94uYso0Z0/c7DdeU=;
        b=37uQbcQ1CKqDDkAdb1lkP+I8pU0UDUltDhqfAVpP5SPDcQYJlViZ3k3dBVEq0WO12m
         cIQccXy65LtV3IQv6H2M1jM4r7qEmkHAgILU6jRxF63kky97kNdQvKiE44GmhP27jDpp
         mg5IPaWxJXg92hXihjlaEAo8Qw6TGqtc8JdJ7B9zk6nXT4dS9isbTmf2IzKi0P6Em1UJ
         cwuT6tb5G0EslSIjR9kl6/E8R3TvBamDcsup8v/Xbqlm6ntQhsM0hI7cJiG2zwppXp1x
         lPQaGz1ZK0Q1/17NzOKTPoJhh8MZSRzU+xrLLg2G8MGBcIboKCU67EwBDWVmM1cNsRUD
         m9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815646; x=1769420446;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tir03/0eTjGqYap+VXkH/YQyday94uYso0Z0/c7DdeU=;
        b=iruXkmRE8Wqal8feDp09WkY3OBW0GHqw1OodKJfoInYgziFGlC2/GIaXOf/iiCnMfL
         mtgcLA86EHCjsDFTOG3iVcmDkBW+UaNr1ZGturMQRW9EgNSa6gQ2LzlK1AWAehe0MhJW
         TfYdajRIsUwzyIpRL13KBt6VgNdwfc4PI19fsflwhyPCBej0zydHRk0e+wvMY9yBTR0U
         OVZWrrDjTBV5Hvwuba1EsNXtcQYZuSGLI0RNro/8E7XyZBnCn/DiYfUwg5LuD5bcx+qV
         /HxmLhIO2oTPMoaLr0xRp2PdMIsbhA3Yykr257O2rAq8sDz1dN+vNijbSxy1b4ISIn1z
         dgSw==
X-Forwarded-Encrypted: i=1; AJvYcCUSidUgI6QAPzVLbIwyIiZ1obvXYLj2pvbXHWX5OU4h6lDfJVNe8tjX9slLRyq0yTn+j01c5Y5C24bjUow=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvJw2HVZcsoKNa76sY2WZtGzx5+K9NEkvFZFtRj95vcP5VCD3c
	ucxGZw8caVFFf5CWmO4tMYX8vNGxEA7x1v8n157iafG3H4JuHxIIwceH5Ko+LZRTxVK1cLY2Q4D
	YFg==
X-Received: from wmbil25.prod.google.com ([2002:a05:600c:a599:b0:46e:1e57:dbd6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:358e:b0:470:fe3c:a3b7
 with SMTP id 5b1f17b1804b1-4801e2f3083mr136239335e9.5.1768815645684; Mon, 19
 Jan 2026 01:40:45 -0800 (PST)
Date: Mon, 19 Jan 2026 10:05:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119094029.1344361-1-elver@google.com>
Subject: [PATCH tip/locking/core 0/6] compiler-context-analysis: Scoped init guards
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, Bart Van Assche <bvanassche@acm.org>, 
	kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Current context analysis treats lock_init() as implicitly "holding" the
lock to allow initializing guarded members. This causes false-positive
"double lock" reports if the lock is acquired immediately after
initialization in the same scope; for example:

	mutex_init(&d->mtx);
	/* ... counter is guarded by mtx ... */
	d->counter = 0;  /* ok, but mtx is now "held" */
	...
	mutex_lock(&d->mtx); /* warning: acquiring mutex already held */

This series proposes a solution to this by introducing scoped init
guards which Peter suggested, using the guard(type_init)(&lock) or
scoped_guard(type_init, ..) interface. This explicitly marks init scope
where we can initialize guarded members. With that we can revert the
"implicitly hold" after init annotations, which allows use after
initialization scope as follows:

	scoped_guard(mutex_init, &d->mtx) {
		d->counter = 0;
	}
	...
	mutex_lock(&d->mtx); /* ok */

Note: Scoped guarded initialization remains optional, and normal
initialization can still be used if no guarded members are being
initialized. Another alternative is to just disable context analysis to
initialize guarded members with `context_unsafe(var = init)` or adding
the `__context_unsafe(init)` function attribute (the latter not being
recommended for non-trivial functions due to lack of any checking):

	mutex_init(&d->mtx);
	context_unsafe(d->counter = 0);  /* ok */
	...
	mutex_lock(&d->mtx);

This series is an alternative to the approach in [1]:

   * Scoped init guards (this series): Sound interface, requires use of
     guard(type_init)(&lock) or scoped_guard(type_init, ..) for guarded
     member initialization.

   * Reentrant init [1]: Less intrusive, type_init() just works, and
     also allows guarded member initialization with later lock use in
     the same function. But unsound, and e.g. misses double-lock bugs
     immediately after init, trading false positives for false negatives.

[1] https://lore.kernel.org/all/20260115005231.1211866-1-elver@google.com/

Marco Elver (6):
  cleanup: Make __DEFINE_LOCK_GUARD handle commas in initializers
  compiler-context-analysis: Introduce scoped init guards
  kcov: Use scoped init guard
  crypto: Use scoped init guard
  tomoyo: Use scoped init guard
  compiler-context-analysis: Remove __assume_ctx_lock from initializers

 Documentation/dev-tools/context-analysis.rst | 30 ++++++++++++++++++--
 crypto/crypto_engine.c                       |  2 +-
 crypto/drbg.c                                |  2 +-
 include/linux/cleanup.h                      |  8 +++---
 include/linux/compiler-context-analysis.h    |  9 ++----
 include/linux/local_lock.h                   |  8 ++++++
 include/linux/local_lock_internal.h          |  4 +--
 include/linux/mutex.h                        |  4 ++-
 include/linux/rwlock.h                       |  3 +-
 include/linux/rwlock_rt.h                    |  1 -
 include/linux/rwsem.h                        |  6 ++--
 include/linux/seqlock.h                      |  6 +++-
 include/linux/spinlock.h                     | 17 ++++++++---
 include/linux/spinlock_rt.h                  |  1 -
 include/linux/ww_mutex.h                     |  1 -
 kernel/kcov.c                                |  2 +-
 lib/test_context-analysis.c                  | 22 ++++++--------
 security/tomoyo/common.c                     |  2 +-
 18 files changed, 80 insertions(+), 48 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog

