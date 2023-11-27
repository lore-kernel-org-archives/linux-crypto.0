Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ol8P6Oay"
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125B810F
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:13 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ccc8b7f578so66377137b3.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701087792; x=1701692592; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mTAbE6A7h/+GSMJqHsdCqMe6niueGin0KE9lvobW3U0=;
        b=Ol8P6OaysljH86nUuvxtnLY8QpQuHrFDbUlGKAt4mzHCNu4PO7MTLXDBWMSQSc+C/M
         5fmKys1Dc90VUtqsph98LOCMcOXBbsER+G6oaPMyreCQlEGqFOUJxvxVuITegoAvGg2K
         9TAVpcSt7nBZe++Eg70O5g09z+2ai+y8J2q3qxrzyvXn3OAqnaufSp9H6i4f2iRhMb//
         zME6A5g8tZT0lwk/FVoQmnPC/MdDG6fLMTBjirawrx2DGvbop8fetNe9ab8tq2izs9HY
         sm2ieogCTuZMGRI98ZLhMh23EGSVi5ao/ZRjwNH/hFyfmqzzbYheG0ZV51qFhRTYeFnh
         yUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701087792; x=1701692592;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mTAbE6A7h/+GSMJqHsdCqMe6niueGin0KE9lvobW3U0=;
        b=oNiSD8X/CcPIj9AgdTxwlj85fZKVrZcL3osU8xfELxDteVv+g7UWtSYCKUgVHQLyP+
         PmOUVwPcrgsaF1QjuW5or6xMM0UYZHqLm9b4HYOgot1+JV3duPg2nvZxM4gR5djPE5i/
         F0TGizi5tdwsJBlGl1CMBR595+szTFPdXC5UqM9ORS46GCLpiVJ2OarZu08+QdjBSSbk
         Fbo4qMMWMCqpK92w5ubjhDEz+7QQSvufYJ7DdoICF/AUzUYiu4Ax1xilpN40jYH+9ltk
         xQ7Ju0xhjQYRm4gU7dyegZpjGtdc67q5BFL8fGPgHVHj85/L4tCQ7q2JTEeTW+b9HtVu
         Defw==
X-Gm-Message-State: AOJu0Yzf66JxBvb7EzpCBdLcGY4aCgVIbhoKRIdW9V64MMm8xEEcDbkU
	8mrKg0Dp9pEGs9uavbOiFIZJmidz
X-Google-Smtp-Source: AGHT+IH5ulONuTTxC9bKKsnKzTzA3Qs/xq+rt4C2SrYe4kZFYnEjeY6RMoPR8fy1OPDslL9g38vcqXTA
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:690c:88f:b0:5be:9742:cc3a with SMTP id
 cd15-20020a05690c088f00b005be9742cc3amr410515ywb.4.1701087792362; Mon, 27 Nov
 2023 04:23:12 -0800 (PST)
Date: Mon, 27 Nov 2023 13:23:00 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4415; i=ardb@kernel.org;
 h=from:subject; bh=9wokBVtyyMHJ2nK6yySXmr5CwNmsgT1Rtbt/AXle+a4=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITWlS/l5i4Tg1ouWq/nY5zKc8PnMfdLQ5+9iTaY5Tw5Zb
 526pm1aRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIrSrD/7hbHK80OpeuudB0
 8oSq4aNlC87s3RiQbnWn6uEO6/7TDOUM/4s3ta7hXPlS3bsm4mnoDE39l3cXCdZN2Z222O6W8I/ 6Hk4A
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231127122259.2265164-7-ardb@google.com>
Subject: [PATCH v3 0/5] arm64: Run kernel mode NEON with preemption enabled
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, kernel mode NEON (SIMD) support is implemented in a way that
requires preemption to be disabled while the SIMD registers are live.
The reason for this is that those registers are not in the set that is
preserved/restored on exception entry/exit and context switch, as this
would impact performance generally, even for workloads where kernel mode
SIMD is not the bottleneck.

However, doing substantial work with preemption disabled is not great,
as it affects scheduling latency, which is especially problematic for
real-time use cases. So ideally, we should keep preemption enabled when
we can, and find another way to ensure that this does not corrupt the
NEON register state of in-kernel SIMD users.

This series implements a suggestion by Mark Rutland, and introduces a
thread_info flag TIF_USING_KMODE_FPSIMD, which indicates to the thread
switch machinery that the task in question has live kernel mode SIMD
state which needs to be preserved and restored. The space needed for
this is allocated in thread_struct. (*)

Given that currently, we run kernel mode NEON with softirqs disabled (to
avoid the need for preserving kernel mode NEON context belonging to task
context while the SIMD unit is being used by code running in softirq
context), just removing the preempt_disable/enable calls is not
sufficient, and we also need to leave softirqs enabled. This means that
we may need to preserve kernel mode NEON state not only on a context
switch, but also when code running in softirq context takes ownership of
the SIMD unit, but this is straight-forward once we add the scratch
space to thread_struct. (On PREEMPT_RT, softirqs execute with preemption
enabled, making kernel mode FPSIMD in softirq context preemptible as
well. We rely on the fact that the task that hosts the softirq dispatch
logic does not itself use kernel mode FPSIMD in task context to ensure
that there is only a single kernel mode FPSIMD state that may need to be
preserved and restored.)

(*) We might decide to allocate this space (~512 bytes) dynamically, if
the thread_struct memory footprint causes issues. However, we should
also explore doing the same for the user space FPSIMD state, as kernel
threads never return to user space and have no need for this allocation.

v3:
- add patch to drop yield logic from crypto C glue code
- add R-b from Mark

v2:
- tweak some commit logs for clarity
- integrate with the existing lazy restore logic
- add Mark's R-b to patch #1

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Ard Biesheuvel (5):
  arm64: fpsimd: Drop unneeded 'busy' flag
  arm64: fpsimd: Preserve/restore kernel mode NEON at context switch
  arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
  arm64: crypto: Remove conditional yield logic
  arm64: crypto: Remove FPSIMD yield logic from glue code

 arch/arm64/crypto/aes-ce-ccm-glue.c      |   5 -
 arch/arm64/crypto/aes-glue.c             |  21 +--
 arch/arm64/crypto/aes-modes.S            |   2 -
 arch/arm64/crypto/chacha-neon-glue.c     |  14 +-
 arch/arm64/crypto/crct10dif-ce-glue.c    |  30 +---
 arch/arm64/crypto/nhpoly1305-neon-glue.c |  12 +-
 arch/arm64/crypto/poly1305-glue.c        |  15 +-
 arch/arm64/crypto/polyval-ce-glue.c      |   5 +-
 arch/arm64/crypto/sha1-ce-core.S         |   6 +-
 arch/arm64/crypto/sha1-ce-glue.c         |  19 +--
 arch/arm64/crypto/sha2-ce-core.S         |   6 +-
 arch/arm64/crypto/sha2-ce-glue.c         |  19 +--
 arch/arm64/crypto/sha3-ce-core.S         |   6 +-
 arch/arm64/crypto/sha3-ce-glue.c         |  14 +-
 arch/arm64/crypto/sha512-ce-core.S       |   8 +-
 arch/arm64/crypto/sha512-ce-glue.c       |  16 +-
 arch/arm64/include/asm/assembler.h       |  29 ----
 arch/arm64/include/asm/processor.h       |   3 +
 arch/arm64/include/asm/simd.h            |  11 +-
 arch/arm64/include/asm/thread_info.h     |   1 +
 arch/arm64/kernel/asm-offsets.c          |   4 -
 arch/arm64/kernel/fpsimd.c               | 163 +++++++++++++-------
 22 files changed, 165 insertions(+), 244 deletions(-)

-- 
2.43.0.rc1.413.gea7ed67945-goog

