Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A371FCD0F
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080313; cv=none; b=Ylt6QlZoezBUic0xjPJM/QfThlD2KHwvGtq2m0dPWyW00TqCIl7WFojfCKEhBEzlExF1xXCgnGCWfLCMEunFTLyFYChecGCT7Y5yZGmptiNt+gEAbl2nl9avev/aCpzofLFVGzIeECd+8w2pKuIPwvLfXS169dhP+AWIp5R9zyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080313; c=relaxed/simple;
	bh=25oLhZl/XqzsG6SBv3Vrv3lZiohvZC0pFlW/gf1YGM8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hhtUlDUVLGWNCaJZnezZyL0VE3rfm/34ZUaHA+WiQRluQGjliN7DkNxDOhv0Q896Xv6GHsfU0iEypL0C/8Y09slRgi/ESfeXj3KKHJ7BiL1hSCHz5sHedxZWN9JMB3JqkIBzLR5gxammG1eg97dVK2sOaOWIy8TiXcDiEauXRlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v81WnPyk; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v81WnPyk"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e5810f84cbso1236545a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080309; x=1741685109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QdCpZ4aObsNxM+hepokqGHyX6wVByWNLfhfuOJ8rUU0=;
        b=v81WnPykgsvRSsb5CFCDfO4H8yywISzaz3GtCevWAqoqKlIGorQw463/2OIiTCs9jt
         UP3LoRt2NBxxMXXWZ1R5XDoU5+2cDSZl4DNV+i+Cm6XB4vIjdaR37A1Zuj/8zUcvTUIR
         K79YpIc64IsFpAJB60saXWWTbFCgBHVsUeCgJyLJSR2i5TWmjJaNvIla4JWv1WQsTKF7
         PBzstCNFVaUQGTlfeZpgHVyh96B0Jodl+v09pCxPLxjLNx1m+VeAnSdG58yb3Q3fQ5cv
         W6EWBtoBDotfiBgkgXITv8rISsp+jCYLXaRKa5XELvcaDsnSpKH7RCLnu3sitW66+1nQ
         fPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080309; x=1741685109;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QdCpZ4aObsNxM+hepokqGHyX6wVByWNLfhfuOJ8rUU0=;
        b=TW7gT0pFcU+tUvsML4IAEDmDu/ENfZUpWPUg2xDmIVIRLFQkZPORQv2w39gEbWtgw2
         WW0Du7awe4rWtiZ6yPRQXMskXNtL1WjO/4+mNN6RJZng8MJDU1lX7pJ75z6wZha6daLX
         spGc9lWCkVJmeZBp7cPncasdzeOTH0Ptc5Gx8Dc0/fMaxC5CZRtIf/ZEAh11t8lsR1dk
         NxeZc2WslTErDBLYQTkbmSxjFqgZ6w2BV/9mDmSwGSaqjFL0JxAhJQgI102wklm7Ezti
         lDKAipREcmYr9R1RPA7blmnJ4J2ys8+yq7JHx9WoCcFzGrLieY9DofGd8tcUIqRmpTo4
         nzoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNJiXv4Yp7vjQwe0LqBRJgvXAVDl8tIKC+mHHToADqG8EsydUmus+8jcxpM8BM6JL9qY/10+9WIzdue9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvOwxrsKKlXEHzU8j5YsgLreDI9sHsUQ8DCJymC92tbLCgvcCh
	19eUKOSTYFkAeONg4kfJbadZKiXs03wtz5LY+39AfFbiFi8Lm8DmhI9YT+YQbmAJGEWW+L8TJw=
	=
X-Google-Smtp-Source: AGHT+IFE7L8kfRQHhgtRYeSfARUPt/tMk69GqEyS5r9/ERIiywTGdEfrhhzYlFh8Z+e5L+a4vm6MgPgMIQ==
X-Received: from edbij6.prod.google.com ([2002:a05:6402:1586:b0:5de:45f9:8813])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3faa:b0:abf:71b9:4e38
 with SMTP id a640c23a62f3a-abf71b9511emr887914766b.45.1741080308740; Tue, 04
 Mar 2025 01:25:08 -0800 (PST)
Date: Tue,  4 Mar 2025 10:20:59 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-1-elver@google.com>
Subject: [PATCH v2 00/34] Compiler-Based Capability- and Locking-Analysis
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
"capability systems" [2], used to specify the permissibility of
operations to depend on some capability being held (or not held).

Because the feature is not just able to express capabilities related to
synchronization primitives, the naming chosen for the kernel departs
from Clang's initial "Thread Safety" nomenclature and refers to the
feature as "Capability Analysis" to avoid confusion. The implementation
still makes references to the older terminology in some places, such as
`-Wthread-safety` being the warning enabled option that also still
appears in diagnostic messages.

Enabling capability analysis can be seen as enabling a dialect of Linux
C with a Capability System.

Additional details can be found in the added kernel-doc documentation.

 [1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
 [2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf

=== Development Approach ===

Prior art exists in the form of Sparse's context tracking. Locking
annotations on functions exist, so the concept of analyzing locking rules
is not foreign to the kernel's codebase.

However, Clang's analysis is more complete vs. Sparse's, with the
typical trade-offs in static analysis: improved completeness is
sacrificed for more possible false positives or additional annotations
required by the programmer. Numerous options exist to disable or opt out
certain code from analysis.

This series initially aimed to retain compatibility with Sparse, which
can provide tree-wide analysis of a subset of the capability analysis
introduced, but it was later decided to drop Sparse compatibility. For
the most part, the new (and old) keywords used for annotations remain
the same, and many of the pre-existing annotations remain valid.

One big question is how to enable this feature, given we end up with a
new dialect of C -- 2 approaches have been considered:

  A. Tree-wide all-or-nothing approach. This approach requires tree-wide
     changes, adding annotations or selective opt-outs. Making additional
     primitives capability-enabled increases churn, esp. where maintainers
     are unaware of the feature's existence and how to use it.

Because we can't change the programming language (even if from one C
dialect to another) of the kernel overnight, a different approach might
cause less friction.

  B. A selective, incremental, and much less intrusive approach.
     Maintainers of subsystems opt in their modules or directories into
     "capability analysis" (via Makefile):
  
       CAPABILITY_ANALYSIS_foo.o := y	# foo.o only
       CAPABILITY_ANALYSIS := y  	# all TUs
  
     Most (eventually all) synchronization primitives and more
     capabilities (including ones that could track "irq disabled",
     "preemption" disabled, etc.) could be supported.

The approach taken by this series is B. This ensures that only
subsystems where maintainers are willing to deal with any warnings are
opted-in. Introducing the feature can be done incrementally, without
large tree-wide changes and adding numerous opt-outs and annotations to
the majority of code.

  Note: Bart Van Assche concurrently worked on enabling -Wthread-safety:
  https://lore.kernel.org/all/20250206175114.1974171-1-bvanassche@acm.org/
  Bart's work has shown what it might take to go with approach A
  (tree-wide, restricted to 'mutex' usage). This has shown that the
  analysis finds real issues when applied to enough subsystems!  We hope
  this serves as motivation to eventually enable the analysis in as many
  subsystems as possible, particularly subsystems that are not as easily
  tested by CI systems and test robots.

=== Initial Uses ===

With this initial series, the following synchronization primitives are
supported: `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`,
`seqlock_t`, `bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`,
`local_lock_t`, `ww_mutex`.

To demonstrate use of the feature on real kernel code, the series also
enables capability analysis for the following subsystems:

	* mm/kfence
	* kernel/kcov
	* lib/stackdepot
	* lib/rhashtable
    	* drivers/tty
	* security/tomoyo
    	* crypto/

The initial benefits are static detection of violations of locking
rules. As more capabilities are added, we would see more static checking
beyond what regular C can provide, all while remaining easy (read quick)
to use via the Clang compiler.

  Note: The kernel already provides dynamic analysis tools Lockdep and
  KCSAN for lock-safety checking and data-race detection respectively.
  Unlike those, Clang's capability analysis is a compile-time static
  analysis with no runtime impact. The static analysis complements
  existing dynamic analysis tools, as it may catch some issues before
  even getting into a running kernel, but is *not* a replacement for
  whole-kernel testing with the dynamic analysis tools enabled!

=== Appendix ===

A Clang version that supports `-Wthread-safety-pointer` is recommended,
but not a strong dependency:

	https://github.com/llvm/llvm-project/commit/de10e44b6fe7f3d3cfde3afd8e1222d251172ade

This series is also available at this Git tree:

	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=cap-analysis/dev

=== Changelog ===

v2:

  - Remove Sparse context tracking support - after the introduction of
    Clang support, so that backports can skip removal of Sparse support.

  - Remove __cond_lock() function-like helper.

  - ww_mutex support.

  - -Wthread-safety-addressof was reworked and committed in upstream
    Clang as -Wthread-safety-pointer.

  - Make __cond_acquires() and __cond_acquires_shared() take abstract
    value, since compiler only cares about zero and non-zero.

  - Rename __var_guarded_by to simply __guarded_by. Initially the idea
    was to be explicit about if the variable itself or the pointed-to
    data is guarded, but in the long-term, making this shorter might be
    better.

  - Likewise rename __ref_guarded_by to __pt_guarded_by.

  - Introduce common header warning suppressions - this is a better
    solution than guarding header inclusions with disable_ +
    enable_capability_analysis(). Header suppressions are disabled when
    selecting CONFIG_WARN_CAPABILITY_ANALYSIS_ALL=y. This bumps the
    minimum Clang version required to 20+.

  - Make the data_race() macro imply disabled capability analysis.
    Writing capability_unsafe(data_race(..)) is unnecessarily verbose
    and data_race() on its own already indicates something subtly unsafe
    is happening.  This change was made after analysis of a finding in
    security/tomoyo.

  - Enable analysis in the following subsystems as additional examples
    of larger subsystem. Where it was obvious, the __guarded_by
    attribute was added to lock-guarded variables to improve coverage.

    	* drivers/tty
	* security/tomoyo
    	* crypto/

RFC v1: https://lore.kernel.org/lkml/20250206181711.1902989-1-elver@google.com

Marco Elver (34):
  compiler_types: Move lock checking attributes to
    compiler-capability-analysis.h
  compiler-capability-analysis: Add infrastructure for Clang's
    capability analysis
  compiler-capability-analysis: Add test stub
  Documentation: Add documentation for Compiler-Based Capability
    Analysis
  checkpatch: Warn about capability_unsafe() without comment
  cleanup: Basic compatibility with capability analysis
  lockdep: Annotate lockdep assertions for capability analysis
  locking/rwlock, spinlock: Support Clang's capability analysis
  compiler-capability-analysis: Change __cond_acquires to take return
    value
  locking/mutex: Support Clang's capability analysis
  locking/seqlock: Support Clang's capability analysis
  bit_spinlock: Include missing <asm/processor.h>
  bit_spinlock: Support Clang's capability analysis
  rcu: Support Clang's capability analysis
  srcu: Support Clang's capability analysis
  kref: Add capability-analysis annotations
  locking/rwsem: Support Clang's capability analysis
  locking/local_lock: Include missing headers
  locking/local_lock: Support Clang's capability analysis
  locking/ww_mutex: Support Clang's capability analysis
  debugfs: Make debugfs_cancellation a capability struct
  compiler-capability-analysis: Remove Sparse support
  compiler-capability-analysis: Remove __cond_lock() function-like
    helper
  compiler-capability-analysis: Introduce header suppressions
  compiler: Let data_race() imply disabled capability analysis
  kfence: Enable capability analysis
  kcov: Enable capability analysis
  stackdepot: Enable capability analysis
  rhashtable: Enable capability analysis
  printk: Move locking annotation to printk.c
  drivers/tty: Enable capability analysis for core files
  security/tomoyo: Enable capability analysis
  crypto: Enable capability analysis
  MAINTAINERS: Add entry for Capability Analysis

 .../dev-tools/capability-analysis.rst         | 148 +++++
 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/sparse.rst            |  19 -
 Documentation/mm/process_addrs.rst            |   6 +-
 MAINTAINERS                                   |  11 +
 Makefile                                      |   1 +
 crypto/Makefile                               |   2 +
 crypto/algapi.c                               |   2 +
 crypto/api.c                                  |   1 +
 crypto/crypto_engine.c                        |   2 +-
 crypto/drbg.c                                 |   5 +
 crypto/internal.h                             |   2 +-
 crypto/proc.c                                 |   3 +
 crypto/scompress.c                            |   8 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |   4 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   6 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   5 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   4 +-
 drivers/tty/Makefile                          |   3 +
 drivers/tty/n_tty.c                           |  16 +
 drivers/tty/pty.c                             |   1 +
 drivers/tty/sysrq.c                           |   1 +
 drivers/tty/tty.h                             |   8 +-
 drivers/tty/tty_buffer.c                      |   8 +-
 drivers/tty/tty_io.c                          |  12 +-
 drivers/tty/tty_ioctl.c                       |   2 +-
 drivers/tty/tty_ldisc.c                       |  35 +-
 drivers/tty/tty_ldsem.c                       |   2 +
 drivers/tty/tty_mutex.c                       |   4 +
 drivers/tty/tty_port.c                        |   2 +
 fs/dlm/lock.c                                 |   2 +-
 include/crypto/internal/engine.h              |   2 +-
 include/linux/bit_spinlock.h                  |  24 +-
 include/linux/cleanup.h                       |  18 +-
 include/linux/compiler-capability-analysis.h  | 368 ++++++++++++
 include/linux/compiler.h                      |   2 +
 include/linux/compiler_types.h                |  18 +-
 include/linux/console.h                       |   4 +-
 include/linux/debugfs.h                       |  12 +-
 include/linux/kref.h                          |   2 +
 include/linux/list_bl.h                       |   2 +
 include/linux/local_lock.h                    |  18 +-
 include/linux/local_lock_internal.h           |  43 +-
 include/linux/lockdep.h                       |  12 +-
 include/linux/mm.h                            |  33 +-
 include/linux/mutex.h                         |  29 +-
 include/linux/mutex_types.h                   |   4 +-
 include/linux/rcupdate.h                      |  86 +--
 include/linux/refcount.h                      |   6 +-
 include/linux/rhashtable.h                    |  14 +-
 include/linux/rwlock.h                        |  22 +-
 include/linux/rwlock_api_smp.h                |  43 +-
 include/linux/rwlock_rt.h                     |  44 +-
 include/linux/rwlock_types.h                  |  10 +-
 include/linux/rwsem.h                         |  56 +-
 include/linux/sched/signal.h                  |  14 +-
 include/linux/seqlock.h                       |  24 +
 include/linux/seqlock_types.h                 |   5 +-
 include/linux/spinlock.h                      |  64 +-
 include/linux/spinlock_api_smp.h              |  34 +-
 include/linux/spinlock_api_up.h               | 112 +++-
 include/linux/spinlock_rt.h                   |  37 +-
 include/linux/spinlock_types.h                |  10 +-
 include/linux/spinlock_types_raw.h            |   5 +-
 include/linux/srcu.h                          |  61 +-
 include/linux/tty.h                           |  14 +-
 include/linux/tty_flip.h                      |   4 +-
 include/linux/tty_ldisc.h                     |  19 +-
 include/linux/ww_mutex.h                      |  21 +-
 kernel/Makefile                               |   2 +
 kernel/kcov.c                                 |  36 +-
 kernel/printk/printk.c                        |   2 +
 kernel/signal.c                               |   4 +-
 kernel/time/posix-timers.c                    |  10 +-
 lib/Kconfig.debug                             |  45 ++
 lib/Makefile                                  |   6 +
 lib/dec_and_lock.c                            |   8 +-
 lib/rhashtable.c                              |   5 +-
 lib/stackdepot.c                              |  20 +-
 lib/test_capability-analysis.c                | 548 ++++++++++++++++++
 mm/kfence/Makefile                            |   2 +
 mm/kfence/core.c                              |  20 +-
 mm/kfence/kfence.h                            |  14 +-
 mm/kfence/report.c                            |   4 +-
 mm/memory.c                                   |   4 +-
 mm/pgtable-generic.c                          |  19 +-
 net/ipv4/tcp_sigpool.c                        |   2 +-
 scripts/Makefile.capability-analysis          |  11 +
 scripts/Makefile.lib                          |  10 +
 scripts/capability-analysis-suppression.txt   |  32 +
 scripts/checkpatch.pl                         |   8 +
 security/tomoyo/Makefile                      |   2 +
 security/tomoyo/common.c                      |  52 +-
 security/tomoyo/common.h                      |  77 +--
 security/tomoyo/domain.c                      |   1 +
 security/tomoyo/environ.c                     |   1 +
 security/tomoyo/file.c                        |   5 +
 security/tomoyo/gc.c                          |  28 +-
 security/tomoyo/mount.c                       |   2 +
 security/tomoyo/network.c                     |   3 +
 tools/include/linux/compiler_types.h          |   2 -
 101 files changed, 2086 insertions(+), 521 deletions(-)
 create mode 100644 Documentation/dev-tools/capability-analysis.rst
 create mode 100644 include/linux/compiler-capability-analysis.h
 create mode 100644 lib/test_capability-analysis.c
 create mode 100644 scripts/Makefile.capability-analysis
 create mode 100644 scripts/capability-analysis-suppression.txt

-- 
2.48.1.711.g2feabab25a-goog
