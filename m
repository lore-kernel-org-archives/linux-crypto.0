Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890108;
	b=BPfpqSsBB/ez+VHGF9T/7DT3/9OgEGUhS8XWra1VY8BIr1s+nyIs7CxSqfTXzkzraHZW
	 /29BgGCgj0HQuiD8lnH/Yd/9ZEgKBZ7WzKvyebKnjhZ+2mZdp25l44xV25dTCds2pNoQA
	 6pMYaG2Fyu4XvYgEJbWiMGA6MeaG7Po9KAYEUiaN4KPhqTSvQsQi+k+g96dclX0RR2hhp
	 vGC/xIQHNrjPrlx1y/9aT7X/2g3ih78LegpdMPeZn/Zomg8xsbv4yBe3jK5nen6g7SjuN
	 QHUb6oJxxDGtxNZruZ5no3YtUCq/RQ0Gs1nySYCwXKJgk2v4s9BECqamt8ySU/PyNYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890108;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=9ljMd+8qHZtmdzxzGXfXq4+janfrVyX1V/6KLR49owU=;
	b=HyRjfoCcBsNMVTRNrxPtoY0ZYYfWIEIZZ8PLBQMJwq0Ux0oidc5UDoXV67d7RTV+a+DV
	 yfYydVzZgSXbeB9wI2RKNLmcxF/Gnqq1V0GI0hMySXBJu8nTmdsEO9CKB0+21yw8AR5ew
	 lKuLpFm+0gyeeun5aT+SsaAv62X+YddKXYnthnlgpmzLtSaOpaCahcxZXatbFaqzrxwoK
	 lVvQHCi425liL4lZIBigEm13NSgYED4AsUfMoQUaviMqmhzV55chz5ym7uLnhfBTvQ4YW
	 TpI2b7dePiC1u+81OQwImDG4wGe7mSh6X/WGzX7hNxDU2dLVwJWQsRN7KIesDK72Idg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hRy90PAP;
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA4606A331
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0BA4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hRy90PAP
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so3218199a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890107; x=1795494907; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ljMd+8qHZtmdzxzGXfXq4+janfrVyX1V/6KLR49owU=;
        b=hRy90PAPuzLiC1Ugzow1TqtYICVR0C/3m9NpC/vL5oLQYPg+GMvdStu0VTqU9YJ/uo
         sQjCyubE25syH9V+O3bwTt/MPCTRKW0T+tQCrlr27bSmfATVS4elvLUGAbA9Z6cqb29M
         981NMSmqQjtvX1LhpBKfSQMDX8uhG5MgO8vEFip3vUKirgx4qehkhvJij7szW6WlEQiy
         reOcS+Nt3FeJ+euRqQ9xLAkLACMmx9rGQK+rcOOa1kcCxmuh5/ubqEQXrxACoxAoxaWW
         6/m/ZGHwHyL8zRCcKnbdvnUfABykJg1v9q6GvlkbsLflwACioNF3PgGLLnyYfl9kxGxo
         Ihkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890107; x=1795494907;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ljMd+8qHZtmdzxzGXfXq4+janfrVyX1V/6KLR49owU=;
        b=SIkB5/SH0GBUGvp2lEWg0TQIf2NZDsb12Gu9iSGFPoBRmoXx627cYynJLs06PaGxc5
         ws5IdPWEukbRGAoahSxQm9bME+JbOrDBKIaRA2OkoYOTR23rhmPAvS+8E8j3BnQ2cghO
         m9nzrZjRkyy9WONT4+ECp4rtyoJb6ThYXqv4GCzBIF9ByDrYkZIMZovlRZLPjIA0rTFk
         fFqHIWj9A03iLwNYZ+J1q59+vbUIndrD8c+Foyj6s2tKlK+zGX3J4pYyTV9iXlIruwsq
         Rjrf0QaI2noXSfoH26+fWPuAyK6BCmSGG9B2mo7vZxFLLVEMYpVo8LRxudPLAG4IIj1L
         hP0w==
X-Forwarded-Encrypted: i=1; AL+hErGAYPjh4o7yy3Cm9qXkn9N/lsUqRSEKt1pogig9ghHDAJHayIa5eGOSeQmEOOU9lWq+W7vN3ZELTs2Sd5U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+gEqG3JRpYENAz+RjMaWUYHXuNZX8XT+7EnT/wGxPkFdI4Yntz
	3j7FRLR3mi04pH6x78JpXkcgX6jzKhCK3FyWXpC4KLmRx2Is5SNlYpTFq4wCsHdCKeZ8zN2TQUA
	LpMI29GVyVqV1EQo9wWwid4aw7A==
X-Received: from pgfd23-n2.prod.google.com ([2002:a05:6a02:6557:20b0:cd6:1195:61cb])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3841:b0:3a6:e99b:bbdb with SMTP id 98e67ed59e1d1-3b1b0cfe3d9mr12853706a91.50.1794890106931;
 Mon, 16 Nov 2026 20:35:06 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:52 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261117043504.1021063-1-dylanbhatch@google.com>
Subject: [RFC PATCH 00/12] arm64, unwind: add .lr_unwind unwinder for reliable stacktrace
From: Dylan Hatch <dylanbhatch@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Weinan Liu <wnliu@google.com>, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Indu Bhagat <ibhagatgnu@gmail.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org, 
	Dylan Hatch <dylanbhatch@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement a build-time .eh_frame-to-.lr_unwind table generator and
in-kernel unwinder for arm64. The primary goal is to support reliable
stacktrace (arch_stack_walk_reliable()) across in-kernel exception
boundaries (pt_regs).

On arm64, normal stack unwinding follows frame pointer (x29) chains.
However, when an asynchronous exception or interrupt occurs inside the
kernel, the frame pointer chain alone is insufficient to unwind reliably
from the interrupted context (pt_regs):

  1. Before the prologue updates x29 (mov x29, sp), after the epilogue
     restores x29/x30, or throughout a leaf function, the interrupted
     function's return address is live in x30 (pt_regs->regs[30]) while
     x29 still points to the caller's frame record.
  2. Between saving the frame record on the stack (e.g.
     stp x29, x30, [sp, #-N]!) and updating x29 (mov x29, sp), or in
     functions where the compiler restores x29/x30 before adjusting sp,
     the interrupted function's frame record resides at [sp + sp_off]
     while x29 still points to the caller's frame record.
  3. Inside the function body after mov x29, sp, [x29] points to the
     interrupted function's own frame record and x30 may have been
     clobbered by nested calls.

Without knowing which state holds at the interrupted PC, the unwinder
cannot determine whether pt_regs->regs[30] is a valid frame or a
duplicate of [x29 + 8], nor can it recover a frame record at
[sp + sp_off] before x29 is updated, forcing arch_stack_walk_reliable()
to reject stack traces that cross an in-kernel exception boundary.

This RFC is proposed as an alternative to an SFrame [1] based solution:
[2]. While SFrame works well with recent GNU binutils (2.46+), it is not
yet supported by LLVM/Clang toolchains. Conversely, compiler-generated
.eh_frame tables (-fasynchronous-unwind-tables, enabled by
CONFIG_UNWIND_TABLES) are supported today by both GCC and Clang/LLVM,
and arm64 already includes a DWARF .eh_frame parser in
arch/arm64/kernel/pi/patch-scs.c for dynamic Shadow Call Stack patching.

Rather than retaining bulky raw .eh_frame sections in kernel memory and
interpreting variable-length DWARF CFI opcodes during stack unwinding,
this series introduces a build-time host tool (scripts/gen_lr_unwind)
that reuses and extends arm64's .eh_frame parser (<asm/eh_frame.h>) to
distill .eh_frame into compact, fixed-width .lr_unwind_fde and
.lr_unwind_ranges sections, and strips .eh_frame from the final vmlinux
and module binaries.

Each annotated function is described by an 8-byte struct lr_fde entry
(32-bit PC-relative start_offset + 32-bit range_desc), sorted at build
time by scripts/sorttable (and at module load time) for O(log N) lookup.
Each instruction range within a function is classified into one of three
exception-boundary unwind modes:
  - LR_UNWIND_LIVE: x30 holds the return address, x29 is the caller's FP
  - LR_UNWIND_FP:   [x29] holds the saved {x29, x30} frame record
  - LR_UNWIND_SP:   [sp + sp_off] holds the saved {x29, x30} frame record

Functions with non-standard x30 spills (such as frameless leaf functions
spilling x30 without x29) are omitted from .lr_unwind_fde so the
unwinder treats them as unreliable.

For functions following the canonical 4-phase LIVE -> FP/SP -> SP -> LIVE
layout (prologue <= 31 insns, body <= 4095 insns, epilogue/return <= 15
insns each, and sp_off <= 496 bytes), the ranges and sp_off are packed
directly into the 32-bit range_desc word of struct lr_fde; functions
with more ranges or larger lengths reference 2-byte lr_range_t entries
in .lr_unwind_ranges. Across vmlinux, .lr_unwind_fde and
.lr_unwind_ranges total ~800-935 KiB (~4x smaller than raw .eh_frame).

This series is available on github: [3].

Structure of the series:
  - Patches 1-6: Enable .eh_frame generation for CONFIG_ARM64_LR_UNWIND,
    factor the .eh_frame parser out of patch-scs.c into <asm/eh_frame.h>,
    extend it to track CFA and x29/x30 state, and implement
    scripts/gen_lr_unwind (including --dump) to emit .lr_unwind sections.
  - Patch 7: Teach scripts/sorttable to sort .lr_unwind_fde at build time.
  - Patches 8-9: Add in-kernel .lr_unwind lookup, optional boot/module
    validation (CONFIG_ARM64_LR_UNWIND_VALIDATION), and module support.
  - Patches 10-11: Annotate call_on_irq_stack() and arm64 leaf assembly
    functions (SYM_LEAF_FUNC_START / SYM_LEAF_FUNC_END) with CFI
    directives so they are covered by .lr_unwind.
  - Patch 12: Use .lr_unwind in arch/arm64/kernel/stacktrace.c to
    reliably unwind across in-kernel exception boundaries.

Ref:
[1]: https://sourceware.org/binutils/docs/sframe-spec.html
[2]: https://lore.kernel.org/all/20261117020648.323464-1-dylanbhatch@google.com/
[3]: https://github.com/dylanbhatch/linux/tree/eh_frame

Dylan Hatch (11):
  arm64, unwind: build with .eh_frame and add gen_lr_unwind skeleton
  arm64: factor .eh_frame parser out of patch-scs.c into
    <asm/eh_frame.h>
  arm64: eh_frame: track CFA and x29/x30 register state in CFI parser
  arm64, unwind: parse .eh_frame into .lr_unwind entries in
    gen_lr_unwind
  scripts/gen_lr_unwind: emit .lr_unwind_fde and .lr_unwind_ranges
  scripts/gen_lr_unwind: add --dump option to inspect .lr_unwind tables
  scripts/sorttable: sort .lr_unwind_fde by start_offset
  arm64, unwind: add in-kernel .lr_unwind lookup and validation
  arm64/module, unwind: add .lr_unwind support for modules
  arm64, crypto/lib: annotate leaf functions with CFI info
  unwind: arm64: use .lr_unwind to unwind interrupt frames

Weinan Liu (1):
  arm64: entry: add unwind info for call_on_irq_stack()

 MAINTAINERS                            |   1 +
 arch/arm64/Kconfig                     |  20 +
 arch/arm64/crypto/aes-ce-ccm-core.S    |  12 +-
 arch/arm64/crypto/aes-neonbs-core.S    |  16 +-
 arch/arm64/crypto/ghash-ce-core.S      |  20 +-
 arch/arm64/crypto/sm4-ce-ccm-core.S    |  16 +-
 arch/arm64/crypto/sm4-ce-cipher-core.S |   4 +-
 arch/arm64/crypto/sm4-ce-core.S        |  44 +-
 arch/arm64/crypto/sm4-ce-gcm-core.S    |  16 +-
 arch/arm64/crypto/sm4-neon-core.S      |  12 +-
 arch/arm64/include/asm/eh_frame.h      | 552 +++++++++++++++++
 arch/arm64/include/asm/linkage.h       |  33 +
 arch/arm64/include/asm/lr_unwind.h     | 149 +++++
 arch/arm64/include/asm/module.h        |   6 +
 arch/arm64/include/asm/module.lds.h    |   2 +-
 arch/arm64/include/asm/scs.h           |   7 -
 arch/arm64/include/asm/sections.h      |   3 +
 arch/arm64/kernel/Makefile             |   5 +
 arch/arm64/kernel/entry.S              |  12 +-
 arch/arm64/kernel/lr_unwind.c          | 395 ++++++++++++
 arch/arm64/kernel/module.c             |  11 +
 arch/arm64/kernel/pi/patch-scs.c       | 259 +-------
 arch/arm64/kernel/setup.c              |   3 +
 arch/arm64/kernel/stacktrace.c         |  85 ++-
 arch/arm64/kernel/vmlinux.lds.S        |  27 +-
 arch/arm64/lib/clear_user.S            |   4 +-
 arch/arm64/lib/copy_from_user.S        |   4 +-
 arch/arm64/lib/copy_page.S             |   4 +-
 arch/arm64/lib/copy_to_user.S          |   4 +-
 arch/arm64/lib/memchr.S                |   4 +-
 arch/arm64/lib/memcmp.S                |   4 +-
 arch/arm64/lib/memcpy.S                |   8 +-
 arch/arm64/lib/memset.S                |   8 +-
 arch/arm64/lib/mte.S                   |  28 +-
 arch/arm64/lib/strchr.S                |   4 +-
 arch/arm64/lib/strcmp.S                |   4 +-
 arch/arm64/lib/strlen.S                |   4 +-
 arch/arm64/lib/strncmp.S               |   4 +-
 arch/arm64/lib/strnlen.S               |   4 +-
 arch/arm64/lib/strrchr.S               |   4 +-
 arch/arm64/lib/tishift.S               |  12 +-
 scripts/.gitignore                     |   1 +
 scripts/Makefile                       |   2 +
 scripts/Makefile.modfinal              |  10 +-
 scripts/Makefile.vmlinux_o             |   8 +-
 scripts/gen_lr_unwind.c                | 821 +++++++++++++++++++++++++
 scripts/link-vmlinux.sh                |   2 +-
 scripts/sorttable.c                    |  50 +-
 48 files changed, 2325 insertions(+), 383 deletions(-)
 create mode 100644 arch/arm64/include/asm/eh_frame.h
 create mode 100644 arch/arm64/include/asm/lr_unwind.h
 create mode 100644 arch/arm64/kernel/lr_unwind.c
 create mode 100644 scripts/gen_lr_unwind.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.679.gc527c65306-goog

