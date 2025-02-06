Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C71DF73B
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865882; cv=none; b=hudh08/EhpqIzzUGgKpfqcKAQNeMbqFCdi3vPW7rHAlYU2G2Wdbjgysb81p8x8E/kOHzN0YLpWrlA2gQIIblQ0CV2kbZKlpQGfEV7h75qop3b21lIps20umMriUE5DbS0dL+X1f58juEytfy14U9dx39Zq+OpZyN3NQZu1PYK14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865882; c=relaxed/simple;
	bh=XCrStM0aHgrhET61z+k7oYXwhS7WvQ1g7ufeBP2YzBY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZR3w903r9vYOgSsYfJG34hxxBle/e82EcCKQbYR93sEAr0jkHtz/7bDc91mGEcJjZoDpbqkH2orwip5ifPblZnJk5FlziiSwZ9jUp5KVjgjg9/FPXozHS5uGjauVbLneqfGXRdSTvFXg26NfS3D1HtqFiMTE9bVT8vV+WS9pSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kLTbSLfF; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kLTbSLfF"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d821f9730aso2567082a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865879; x=1739470679; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zCXzYYWNA/v8qcQtOcKIh5TmuX7E6oXR0H5ZAQV+vQ=;
        b=kLTbSLfFD8hXSeYRCsWr99/TbfXUnOf0PeyHTNmtT69ImMflQ9mMroaITX+XVPU6hh
         Uo52sYB5nQHSu1JndZm5unLW9gjMmqaDa3vkPI1hjHLwUVt5pLAiTtxpvehPZWNUVwVf
         +efioDf4d/pTiMX2kEP9Pqhjcak8vv2gEYwJKFhBcNkDB15VJb2nB/9fJBSl/jqwFLMF
         2SrxCfauqeIrh6RUW7uXrunDLszUqDHyp39boA8kPofjSNCBv6YoshA9+0JzTVLCWPRZ
         Um2vnQygRkqmlcHVe6dsBOMZdTrk93bWr9X6iFrjwGzoW3V53ucw9VYzwSO8VaXqrVp0
         XBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865879; x=1739470679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3zCXzYYWNA/v8qcQtOcKIh5TmuX7E6oXR0H5ZAQV+vQ=;
        b=KtYBBQ1cUAHaVElJGR2trD5kEMwxqeUmwJOXMpPDMHEUM4qnHfOSgvFVtYRdoERF3Z
         lq+HecP5IrpMocmAwFcgODfKXf3n4A6p4puPcDdN1K0LAtJwbXdFSMwlVjkQUntvEbOV
         lO1J3CZQIXGarO/AOvsed0w5C6TVywSazV0ZY5mfZM4QY2zs0K7z5aO+r+FAxohy1Qmk
         In7/5Lnte78xkf8jHA4e8O6mW0qX2YDQr2AXBMhjhwvpkjOxoHXTTx7zOY/xZJeI60L9
         mjx1jWA202o73GblXW5gUlsXvYEH57QMs5zF7kTpylilI7Bfpf9g3mKLbSpQOJ80ZgQb
         0aGA==
X-Forwarded-Encrypted: i=1; AJvYcCV9iNZ01Boe4oHA9GSqtC+BUUdjcSSNJsfnRkNpJlrWTh7jLGFbfQ/qJWtFwSN6zCZXYcOw2/v3UM6qnTk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+dTDSqSopzld+gKzz4y9MjJjKK/ZruQZIXqEtsQc5gTA4trQw
	gyniWCVwnOngq0peiwjy6zOVOqtBB9Ha0iBIBru9wEAwO9QEhSNAYyuf8r/EqYkUapCdpt15TQ=
	=
X-Google-Smtp-Source: AGHT+IE3fLvFaStZCPDAHMprTwdHS2CDtyLSA/FOO9gR6TbzSQgYNeNMtTUtaGDdnKoUqzREyKkIXGTCnw==
X-Received: from edap10.prod.google.com ([2002:a05:6402:500a:b0:5d8:ab23:4682])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4404:b0:5dc:abe4:9d8d
 with SMTP id 4fb4d7f45d1cf-5dcecca9427mr4164056a12.9.1738865878495; Thu, 06
 Feb 2025 10:17:58 -0800 (PST)
Date: Thu,  6 Feb 2025 19:09:59 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-6-elver@google.com>
Subject: [PATCH RFC 05/24] Documentation: Add documentation for Compiler-Based
 Capability Analysis
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

Adds documentation in Documentation/dev-tools/capability-analysis.rst,
and adds it to the index and cross-references from Sparse's document.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         | 147 ++++++++++++++++++
 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/sparse.rst            |   4 +
 3 files changed, 152 insertions(+)
 create mode 100644 Documentation/dev-tools/capability-analysis.rst

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
new file mode 100644
index 000000000000..2211af90e01b
--- /dev/null
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -0,0 +1,147 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2025, Google LLC.
+
+.. _capability-analysis:
+
+Compiler-Based Capability Analysis
+==================================
+
+Capability analysis is a C language extension, which enables statically
+checking that user-definable "capabilities" are acquired and released where
+required. An obvious application is lock-safety checking for the kernel's
+various synchronization primitives (each of which represents a "capability"),
+and checking that locking rules are not violated.
+
+The Clang compiler currently supports the full set of capability analysis
+features. To enable for Clang, configure the kernel with::
+
+    CONFIG_WARN_CAPABILITY_ANALYSIS=y
+
+The analysis is *opt-in by default*, and requires declaring which modules and
+subsystems should be analyzed in the respective `Makefile`::
+
+    CAPABILITY_ANALYSIS_mymodule.o := y
+
+Or for all translation units in the directory::
+
+    CAPABILITY_ANALYSIS := y
+
+It is possible to enable the analysis tree-wide, however, which will result in
+numerous false positive warnings currently and is *not* generally recommended::
+
+    CONFIG_WARN_CAPABILITY_ANALYSIS_ALL=y
+
+Independent of the above Clang support, a subset of the analysis is supported
+by :ref:`Sparse <sparse>`, with weaker guarantees (fewer false positives with
+tree-wide analysis, more more false negatives). Compared to Sparse, Clang's
+analysis is more complete.
+
+Programming Model
+-----------------
+
+The below describes the programming model around using capability-enabled
+types.
+
+.. note::
+   Enabling capability analysis can be seen as enabling a dialect of Linux C with
+   a Capability System. Some valid patterns involving complex control-flow are
+   constrained (such as conditional acquisition and later conditional release
+   in the same function, or returning pointers to capabilities from functions.
+
+Capability analysis is a way to specify permissibility of operations to depend
+on capabilities being held (or not held). Typically we are interested in
+protecting data and code by requiring some capability to be held, for example a
+specific lock. The analysis ensures that the caller cannot perform the
+operation without holding the appropriate capability.
+
+Capabilities are associated with named structs, along with functions that
+operate on capability-enabled struct instances to acquire and release the
+associated capability.
+
+Capabilities can be held either exclusively or shared. This mechanism allows
+assign more precise privileges when holding a capability, typically to
+distinguish where a thread may only read (shared) or also write (exclusive) to
+guarded data.
+
+The set of capabilities that are actually held by a given thread at a given
+point in program execution is a run-time concept. The static analysis works by
+calculating an approximation of that set, called the capability environment.
+The capability environment is calculated for every program point, and describes
+the set of capabilities that are statically known to be held, or not held, at
+that particular point. This environment is a conservative approximation of the
+full set of capabilities that will actually held by a thread at run-time.
+
+More details are also documented `here
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_.
+
+.. note::
+   Unlike Sparse's context tracking analysis, Clang's analysis explicitly does
+   not infer capabilities acquired or released by inline functions. It requires
+   explicit annotations to (a) assert that it's not a bug if a capability is
+   released or acquired, and (b) to retain consistency between inline and
+   non-inline function declarations.
+
+Supported Kernel Primitives
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. Currently the following synchronization primitives are supported:
+
+For capabilities with an initialization function (e.g., `spin_lock_init()`),
+calling this function on the capability instance before initializing any
+guarded members or globals prevents the compiler from issuing warnings about
+unguarded initialization.
+
+Lockdep assertions, such as `lockdep_assert_held()`, inform the compiler's
+capability analysis that the associated synchronization primitive is held after
+the assertion. This avoids false positives in complex control-flow scenarios
+and encourages the use of Lockdep where static analysis is limited. For
+example, this is useful when a function doesn't *always* require a lock, making
+`__must_hold()` inappropriate.
+
+Keywords
+~~~~~~~~
+
+.. kernel-doc:: include/linux/compiler-capability-analysis.h
+   :identifiers: struct_with_capability
+                 token_capability token_capability_instance
+                 __var_guarded_by __ref_guarded_by
+                 __must_hold
+                 __must_not_hold
+                 __acquires
+                 __cond_acquires
+                 __releases
+                 __must_hold_shared
+                 __acquires_shared
+                 __cond_acquires_shared
+                 __releases_shared
+                 __acquire
+                 __release
+                 __cond_acquire
+                 __acquire_shared
+                 __release_shared
+                 __cond_acquire_shared
+                 capability_unsafe
+                 __no_capability_analysis
+                 disable_capability_analysis enable_capability_analysis
+
+Background
+----------
+
+Clang originally called the feature `Thread Safety Analysis
+<https://clang.llvm.org/docs/ThreadSafetyAnalysis.html>`_, with some
+terminology still using the thread-safety-analysis-only names. This was later
+changed and the feature become more flexible, gaining the ability to define
+custom "capabilities".
+
+Indeed, its foundations can be found in `capability systems
+<https://www.cs.cornell.edu/talc/papers/capabilities.pdf>`_, used to specify
+the permissibility of operations to depend on some capability being held (or
+not held).
+
+Because the feature is not just able to express capabilities related to
+synchronization primitives, the naming chosen for the kernel departs from
+Clang's initial "Thread Safety" nomenclature and refers to the feature as
+"Capability Analysis" to avoid confusion. The implementation still makes
+references to the older terminology in some places, such as `-Wthread-safety`
+being the warning enabled option that also still appears in diagnostic
+messages.
diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..62ac23f797cd 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -18,6 +18,7 @@ Documentation/process/debugging/index.rst
    :maxdepth: 2
 
    testing-overview
+   capability-analysis
    checkpatch
    clang-format
    coccinelle
diff --git a/Documentation/dev-tools/sparse.rst b/Documentation/dev-tools/sparse.rst
index dc791c8d84d1..8c2077834b6f 100644
--- a/Documentation/dev-tools/sparse.rst
+++ b/Documentation/dev-tools/sparse.rst
@@ -2,6 +2,8 @@
 .. Copyright 2004 Pavel Machek <pavel@ucw.cz>
 .. Copyright 2006 Bob Copeland <me@bobcopeland.com>
 
+.. _sparse:
+
 Sparse
 ======
 
@@ -72,6 +74,8 @@ releasing the lock inside the function in a balanced way, no
 annotation is needed.  The three annotations above are for cases where
 sparse would otherwise report a context imbalance.
 
+Also see :ref:`Compiler-Based Capability Analysis <capability-analysis>`.
+
 Getting sparse
 --------------
 
-- 
2.48.1.502.g6dc24dfdaf-goog

