Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k3k6M6qo"
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5D910D8
	for <linux-crypto@vger.kernel.org>; Fri,  8 Dec 2023 03:32:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5caf61210e3so24066527b3.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Dec 2023 03:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702035158; x=1702639958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mr64fXyfJBh1+H7Dkv1coQ1BU9+t7kI3PKSBhLdfckk=;
        b=k3k6M6qoaDBQ0XIovQxtbGZa5AJTT1m7wSojz2pkrw1cxzzrQUlW1VI4NEtSs4bH4i
         6qdNgwqpU/FZacUrXLFmjdru5NRv4mm9GnOOlGChaJosJRCYRt0htrJRgGTXcsnMcxwH
         6L+h3/pzTn70mCN7NiHbYgB2qw1ZD/ZXrnW97tH7hPgcY984+3Uv+BAHwZceZck4DOEo
         Pzz6rp5/CURLVT6IJ8LOx3alu15RdDKIMRyu+EJpoX6jo+zfpl3rTaK4Jl2pmTp66/cy
         q4eTGDbQV6+oljNjJD0K+IYfilYgKm9I1w3Jz95M6lw3050rxWFofAVIZM8wxzCDNRZB
         dmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035158; x=1702639958;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mr64fXyfJBh1+H7Dkv1coQ1BU9+t7kI3PKSBhLdfckk=;
        b=M4jOVkTSe7OCc0H+WyqKLIWOdZR5ZtRndeLY2LPQrubMPxK7SbrfSlJiuN17ObO1Vb
         a+j4zMWNGCtNgouRFwiZyAQb6Fpbh83Yh6s/80fcXDv/oSthcz3eN1u2dQcxiu0Y15a9
         0tXuMBMThyfYOuYPJdTWR1WsEWLmCw8YSMz1AmY583bPNxqHRLpNjTj41ySDOhgucZPa
         1rjMz3IRXQhwWUIcAfifazoJQkDlLbMoF4GLNiQDAfOGK4Q3MY3SNK0R6kMz2DlSuU3r
         BoeUlVy0FtstM1pbPPZ+WvG6DVTWuUszxQCKnX6hafzKkIjbmIh+F4jMOLMuRKVOTQ0A
         yoPw==
X-Gm-Message-State: AOJu0YzxrbQz5U4kLA/N87LIG/jAp0KS0VJTWB/fpZ3UrRUXecsouT5b
	YkwyBpG7oQgX39pPDbmJx8QLHoBd
X-Google-Smtp-Source: AGHT+IF3cVVetWVP+NdlntGV0oOwrVXbNhVsp0Gq/kRxD4Fykz5kYEj6MixtKwUYwuDtKGWuOECfw5Pv
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:690c:3146:b0:5d6:daf7:b53b with SMTP id
 fc6-20020a05690c314600b005d6daf7b53bmr48959ywb.9.1702035158372; Fri, 08 Dec
 2023 03:32:38 -0800 (PST)
Date: Fri,  8 Dec 2023 12:32:19 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4181; i=ardb@kernel.org;
 h=from:subject; bh=54KVm9hGYOdWxgLqaFODNghTj4aCQnQ6MJvqo7H6ArY=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIbXo3+EyFR0d79tFt9htZ/7p/Fc+8QJn0asnfpKbt/Ocs
 rnWxfu5o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzEYwMjw/cnGmeCFM16smy6
 lkv6VfK0rL6qPT/1xkftr+WrfmpbP2NkaE9mCp54Y/3EGc4iwnzP7zkWbZF6rMwqdeb3idt5a+O +MwEA
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208113218.3001940-6-ardb@google.com>
Subject: [PATCH v4 0/4] arm64: Run kernel mode NEON with preemption enabled
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
thread_info flag TIF_KERNEL_FPSTATE, which indicates to the thread
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

v4:
- for the time being, make the existing yield logic depend on
  CONFIG_PREEMPT_VOLUNTARY, so it can be retired once the prerequisite
  core preempt changes (which remove CONFIG_PREEMPT_VOLUNTARY) have been
  merged [0]
- incorporate feedback from Mark Rutland and include his acks

v3:
- add patch to drop yield logic from crypto C glue code
- add R-b from Mark

v2:
- tweak some commit logs for clarity
- integrate with the existing lazy restore logic
- add Mark's R-b to patch #1

[0] https://lore.kernel.org/lkml/20231107215742.363031-1-ankur.a.arora@oracle.com/

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Ard Biesheuvel (4):
  arm64: fpsimd: Drop unneeded 'busy' flag
  arm64: fpsimd: Preserve/restore kernel mode NEON at context switch
  arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
  arm64: crypto: Disable yielding logic unless
    CONFIG_PREEMPT_VOLUNTARY=y

 arch/arm64/crypto/aes-ce-ccm-glue.c      |   8 +-
 arch/arm64/crypto/chacha-neon-glue.c     |   5 +-
 arch/arm64/crypto/crct10dif-ce-glue.c    |   6 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c |   5 +-
 arch/arm64/crypto/poly1305-glue.c        |   5 +-
 arch/arm64/crypto/polyval-ce-glue.c      |   9 +-
 arch/arm64/include/asm/assembler.h       |   4 +-
 arch/arm64/include/asm/processor.h       |   3 +
 arch/arm64/include/asm/simd.h            |  11 +-
 arch/arm64/include/asm/thread_info.h     |   1 +
 arch/arm64/kernel/fpsimd.c               | 163 +++++++++++++-------
 11 files changed, 140 insertions(+), 80 deletions(-)

-- 
2.43.0.472.g3155946c3a-goog

