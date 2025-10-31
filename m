Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D401122B8B6
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907189; cv=none; b=cwkadNn7f7x+q9sYgS3WEI3+DgLlHlE9DJAJeRYt5q87BR0pFndZCO4BXU1bYdFpSdtiIehtksaGcFjbxsGsVK7CI7auCGJR+rFE6yZFxJikCfSiRssbpN3r++QdlWZN6CX2XAHl82l8nsu5epJ/8hl5PgaNws7WdqFZfuyHmoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907189; c=relaxed/simple;
	bh=AmlBx6oVKp0Ogs/5jdVegALF/az5vShPFr2wvOxCyQo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SshyyXbsYCQHQQ3mccZARxAUDb6hMuKeH7bPq3TBEVKUaP+/Iz0SVr1QZk/shFDOz5IluxSw0hGXiQv+ysbdRgri1O2wUCsjRutpQrEjWCPK7K2v4aRF8fx+ZZc/bmd/TOnk8hiYZUho25BHC220JaQZ5fPHOOTL9/v7aTzlnn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zfbAaolq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zfbAaolq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso20372585e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907186; x=1762511986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yzBOLuJn6BQxaulymyldStp9yC5OaaLNLjYTbunY6ik=;
        b=zfbAaolqSkQc+UiTWN4ztL+xGqOe2BUxKCs6g1O/Q/5JpcngPEu3jKZDgE4jEVt89b
         utf2TkBhLaY5SYdOsQYmraSE+rZkz1dDCtV0U5Zpymvw+0Mx4r5sxjqsuRhi6v2rydqr
         Ooa2/5L4avFIIDpDluvrNYVXaThTPa5V5FMxLTU5JEtSPSF6UJSUO6deFCEECDE5ZXf1
         J2RIMoiBaY4naKyc/H6k3C1rovJz01opR7JKTgTPLOP/W7SL5i7z3Ck+rSnTcJy9/rQ+
         HTxBaogCgAJcP1XzUctEOjAmyngp9gllzzzk6QVPDBzChMGpWnEm9rgGzE/LMXnStLtg
         NdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907186; x=1762511986;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzBOLuJn6BQxaulymyldStp9yC5OaaLNLjYTbunY6ik=;
        b=pFwdl7ueKNW3C2wR6YFql9jpmHQnA5AvYn/Au24BA0DhdvJrbYZ+F+3S8OV1++KtM8
         G0l9wgCug4wEPr4sVF3kngwXx+6o4ByDFFlhKiiU8rOM+XgfvUOpUvcutVTrS5be9HVS
         rUj7C14m8LpoR+gdyORGfvcoWlXKVi798hjHC+ko6HZAuKnTWjJkUN109krKlFSy1j5T
         +bzHNt3+BiYklR/hPVZ6sqo+SGonomfQd1mRTAUlLBzTOwcfj6YW9+c+6iUSqDhYGJF1
         3lS1Uq7wTtZU4NgGdKKDcVzIb5WAHGMyhJ+uzxAMCsqdBenIX6xgsN5GOIcCN0HeFU3x
         hl5g==
X-Forwarded-Encrypted: i=1; AJvYcCWBsLWjq4RNyNd7j96uzSnbHNfKqX7mR7lZgghdi/6dzv+NmP6temJN3u6gz1c0ZEqSeWVN9B5HmE+FnQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCCeMmi2L4i1Ksa0ojuirPiGTbdfMkuFXUvKkOFqHWevY8gIOe
	RAN918tqULIFmdNLGli8o/tHYiwk+c+4ixqTs/jeS3jnqC3v8tgY+pEKOBlaK/dBs02eTbTEgg=
	=
X-Google-Smtp-Source: AGHT+IEPzdVQqUUHRRWzP9kzCZyXrVG4IDJoADHNKyCPnLrN1PGH+kuRK8mJROWWYdSTrzbg98eHOvxJ
X-Received: from wmcn12.prod.google.com ([2002:a05:600c:c0cc:b0:46e:1e57:dbd6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:4393:b0:46e:32a5:bd8d
 with SMTP id 5b1f17b1804b1-477331db3ccmr11927495e9.3.1761907186270; Fri, 31
 Oct 2025 03:39:46 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:38:59 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5730; i=ardb@kernel.org;
 h=from:subject; bh=Dd7Wm4yRuQHGoh0lyZXaxS2rHbwexlml5vUqKlsLUbM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4uGfJ9grF/D/T1imIL7BYP+HMxMdt+v7aAoe+XpSR
 FrUbb5zRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhInwkjw8yd7Ks0r+y8eMeo
 OUTl9ew8g5/NUuELxY9p/fvIM/1SWj/DP22+hbv/6neaz99ksFyjx87xYZHHfGPzP5le+9feMND 4zQYA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-23-ardb+git@google.com>
Subject: [PATCH v4 00/21] arm64: Move kernel mode FPSIMD buffer to the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
context switch out of struct thread_struct, and onto the stack, so that
the memory cost is not imposed needlessly on all tasks in the system.

Changes since v3:
- Fix sloppy editing errors in ARM CRC code.

- Add more comments about the state argument to kernel_neon_begin/end
  and the associated field in thread_struct

- Fix bug in generic kernel mode FPU change

- Add Rbs from Eric

Changes since v2:
- Fix generic kernel mode FPU api instead of removing it.

- Rebase onto v6.18-rc0 and fix the fallout

- Prefer WARN() over BUG() in kernel_neon_begin/end

- Avoid unnecessary cmpxchg() calls

- When invoked in softirq context, use the caller provided buffer rather
  than the one stored in the task struct - this permits callers from
  task context (including users of the generic kernel mode FPU api) to
  pass NULL as the buffer when running with preemption disabled.

- Add acks from Kees and Eric; Mark's was dropped along with the patch
  in question.

- Fix new occurrence of kernel_neon_begin/end in Mellanox driver.

Changes since v1:
- Add a patch reverting the arm64 support for the generic
  kernel_fpu_begin()/end() API, which is problematic on arm64.

- Introduce a new 'ksimd' scoped guard that encapsulates the calls the
  kernel_neon_begin() and kernel_neon_end() at a higher level of
  abstraction. This makes it straight-forward to plumb in the stack
  buffer without complicating the callers.

- Move all kernel mode NEON users on arm64 (and some on ARM) over to the
  new API.

- Add Mark's ack to patches #6 - #8

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>

Ard Biesheuvel (21):
  crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
  arm64/simd: Add scoped guard API for kernel mode SIMD
  ARM/simd: Add scoped guard API for kernel mode SIMD
  crypto: aegis128-neon - Move to more abstract 'ksimd' guard API
  raid6: Move to more abstract 'ksimd' guard API
  lib/crc: Switch ARM and arm64 to 'ksimd' scoped guard API
  lib/crypto: Switch ARM and arm64 to 'ksimd' scoped guard API
  crypto/arm64: aes-ccm - Switch to 'ksimd' scoped guard API
  crypto/arm64: aes-blk - Switch to 'ksimd' scoped guard API
  crypto/arm64: aes-gcm - Switch to 'ksimd' scoped guard API
  crypto/arm64: nhpoly1305 - Switch to 'ksimd' scoped guard API
  crypto/arm64: polyval - Switch to 'ksimd' scoped guard API
  crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
  crypto/arm64: sm3 - Switch to 'ksimd' scoped guard API
  crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
  arm64/xorblocks:  Switch to 'ksimd' scoped guard API
  net/mlx5: Switch to more abstract scoped ksimd guard API on arm64
  arm64/fpu: Enforce task-context only for generic kernel mode FPU
  arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack

 arch/arm/include/asm/simd.h                  |   7 +
 arch/arm64/crypto/aes-ce-ccm-glue.c          | 116 +++++------
 arch/arm64/crypto/aes-ce-glue.c              |  87 ++++----
 arch/arm64/crypto/aes-glue.c                 | 139 ++++++-------
 arch/arm64/crypto/aes-neonbs-glue.c          | 150 +++++++-------
 arch/arm64/crypto/ghash-ce-glue.c            |  27 ++-
 arch/arm64/crypto/nhpoly1305-neon-glue.c     |   5 +-
 arch/arm64/crypto/polyval-ce-glue.c          |  12 +-
 arch/arm64/crypto/sha3-ce-glue.c             |  10 +-
 arch/arm64/crypto/sm3-ce-glue.c              |  15 +-
 arch/arm64/crypto/sm3-neon-glue.c            |  16 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c          |  49 ++---
 arch/arm64/crypto/sm4-ce-cipher-glue.c       |  10 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c          |  62 ++----
 arch/arm64/crypto/sm4-ce-glue.c              | 214 +++++++++-----------
 arch/arm64/crypto/sm4-neon-glue.c            |  25 +--
 arch/arm64/include/asm/fpu.h                 |  16 +-
 arch/arm64/include/asm/neon.h                |   4 +-
 arch/arm64/include/asm/processor.h           |   7 +-
 arch/arm64/include/asm/simd.h                |  10 +
 arch/arm64/include/asm/xor.h                 |  22 +-
 arch/arm64/kernel/fpsimd.c                   |  53 +++--
 crypto/aegis128-neon.c                       |  33 ++-
 drivers/net/ethernet/mellanox/mlx5/core/wc.c |  19 +-
 lib/crc/arm/crc-t10dif.h                     |  16 +-
 lib/crc/arm/crc32.h                          |  11 +-
 lib/crc/arm64/crc-t10dif.h                   |  16 +-
 lib/crc/arm64/crc32.h                        |  16 +-
 lib/crypto/arm/chacha.h                      |   6 +-
 lib/crypto/arm/poly1305.h                    |   6 +-
 lib/crypto/arm/sha1.h                        |  13 +-
 lib/crypto/arm/sha256.h                      |  12 +-
 lib/crypto/arm/sha512.h                      |   5 +-
 lib/crypto/arm64/chacha.h                    |  11 +-
 lib/crypto/arm64/poly1305.h                  |   6 +-
 lib/crypto/arm64/sha1.h                      |   7 +-
 lib/crypto/arm64/sha256.h                    |  19 +-
 lib/crypto/arm64/sha512.h                    |   8 +-
 lib/raid6/neon.c                             |  17 +-
 lib/raid6/recov_neon.c                       |  15 +-
 40 files changed, 601 insertions(+), 691 deletions(-)


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.1.930.gacf6e81ea2-goog

