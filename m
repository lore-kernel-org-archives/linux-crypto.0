Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0638927146B
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352634; cv=none; b=GnCqm0PDKCjqd8MVJUqnWVSl1aLoR9dUqWuU1uwD3INn9lM9LEFIGxURpyGkA9XMgy2vfZdk4ZasTTEC244m2ahFlpeX3AfHN86e4QykN2ko8bzJJL0k1BZHEVHJkr42RMjaso+B+rauPp9bkO1PIQLLV9IiUo46cGSJ3PeCWho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352634; c=relaxed/simple;
	bh=bnST/+pYfP/TMY4VR5FyiAIZhfYyRRy1HEjiErUkCu8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Y8yXc0UT7aMvlVXkxNOAnRN621hAVJOg40EkrgebmF5zjSNtSeL6yEP2wPAeVRN/fRrBnPbzyRQV1dL6VbZzk1YO90aqFqhuiT3y0DnBCiX9fxRVdtPvxKCejM0PLLYPj1zvx/T+VEJ2Pf+F6GPOWEijB39e6ORVaFmgqu7pLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vfDXZuXw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vfDXZuXw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e31191379so5436405e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352631; x=1759957431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mh7/i7zcB22S2CzefD890RUAPYawXfWFtiDRY7l6NUg=;
        b=vfDXZuXwFczDw2ed9ipfsby1SmLDUKPjs9Hr4SoUig87N3dhYSCohA3ucr2dhIjzDd
         ex/7N5fIm7mNLRWxqrVboztb1m8e/pwXN9eYhKi9MtvG8aypjWW11GNhcdCdN/lqJZtc
         X6a7ZjpjBOGxVLQofAXMBPtVnS0wxxyQDEyli4Evw2L9dfsv9RFCu/nyTrqNAsdu/1vb
         SbuJ39l3NIbgSguu6+gnRgKLRjS1yj4CPk1dahNYkGTQaA9/8dgx99cK5gP7LFc6zJWi
         5k3ahDKIZPs3GCq5Sv0k6E/tyTux/sKE5OVw4q8o3u5XWR2kc5ZU5F+Pp6DC7fQTeJJx
         hRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352631; x=1759957431;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mh7/i7zcB22S2CzefD890RUAPYawXfWFtiDRY7l6NUg=;
        b=jqWKy4xtArj9NeunhhfsVe2M/nq+Cj5zZO6mzhW7gK+JnCMmfqwMVX5svv6Vg9OHgG
         PohajiPXWqq5C/2rJqrCDLDkPiXtT1FwRGz4SHJ2SSYKR7AcdglB5X42y8xDSicpnx/T
         Z7WdMSqlujn0ZF09p8XKX/NMYXz5CVK+lLZciYY1BPuEs+Xh4A+f+PNIhvaKGxLnlYCr
         yxobdYd/duonFbbT6OkrwGw2sUN6VniuJQpI2zyMz4WijJ5eVeOZtj1NE6PMsfEzg4yD
         LtRrKEjfThGoUdJamFSq5yM3HuerBwg6kVB7bmAawCfYy+leJRPkoD2kqs+3cuR4grcG
         Q3ow==
X-Gm-Message-State: AOJu0YwIyNH4suFG1Wb2ukit65QiwNGijuafDgry2hLIwFdeYaBqfKLu
	eZvWdTbo7intlGpqAbOX4YAEk4HM4eJ1iC38Y/CcNXqNb2HMoltNCBZCCWgbsMbfFd5p1/zdHA=
	=
X-Google-Smtp-Source: AGHT+IFBMS8hi1wkfsj481SIim8P9Op+nN93AzKtiaxeNmzJcEHjTwqfw2LjqxqLf09sJn85QILeZVIL
X-Received: from wmbgz3.prod.google.com ([2002:a05:600c:8883:b0:45f:29fc:83d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45d0:b0:45b:88d6:8ddb
 with SMTP id 5b1f17b1804b1-46e612e6d66mr40444975e9.37.1759352631471; Wed, 01
 Oct 2025 14:03:51 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4715; i=ardb@kernel.org;
 h=from:subject; bh=WkWvbQEHwdkhBMEajkwjYNbG84VXFWD0ftiu/zUgP00=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutNN86w1dFLNusO+d3vjJZto6tcz77XHJSgbZi7vPF
 9T4XfXqKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOp0mRkuMP+8OxjWU19Oxsj
 vlz9lsr2f77lR+3Ed37avIt90eHHbAz/Ey7OWZT5rnHJwYgbyiznuZcEtsyRjqm/9H1DkvG0wHt ruQE=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-22-ardb+git@google.com>
Subject: [PATCH v2 00/20] arm64: Move kernel mode FPSIMD buffer to the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
context switch out of struct thread_struct, and onto the stack, so that
the memory cost is not imposed needlessly on all tasks in the system.

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

Ard Biesheuvel (20):
  arm64: Revert support for generic kernel mode FPU
  arm64/simd: Add scoped guard API for kernel mode SIMD
  ARM/simd: Add scoped guard API for kernel mode SIMD
  crypto: aegis128-neon - Move to more abstract 'ksimd' guard API
  raid6: Move to more abstract 'ksimd' guard API
  crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
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
  arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack

 arch/arm/include/asm/simd.h              |   7 +
 arch/arm64/Kconfig                       |   1 -
 arch/arm64/Makefile                      |   9 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c      | 116 +++++------
 arch/arm64/crypto/aes-ce-glue.c          |  87 ++++----
 arch/arm64/crypto/aes-glue.c             | 139 ++++++-------
 arch/arm64/crypto/aes-neonbs-glue.c      | 150 +++++++-------
 arch/arm64/crypto/ghash-ce-glue.c        |  27 ++-
 arch/arm64/crypto/nhpoly1305-neon-glue.c |   5 +-
 arch/arm64/crypto/polyval-ce-glue.c      |  12 +-
 arch/arm64/crypto/sha3-ce-glue.c         |  10 +-
 arch/arm64/crypto/sm3-ce-glue.c          |  15 +-
 arch/arm64/crypto/sm3-neon-glue.c        |  16 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c      |  55 +++--
 arch/arm64/crypto/sm4-ce-cipher-glue.c   |  10 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c      |  65 +++---
 arch/arm64/crypto/sm4-ce-glue.c          | 214 +++++++++-----------
 arch/arm64/crypto/sm4-neon-glue.c        |  25 +--
 arch/arm64/include/asm/fpu.h             |  15 --
 arch/arm64/include/asm/neon.h            |   4 +-
 arch/arm64/include/asm/processor.h       |   2 +-
 arch/arm64/include/asm/simd.h            |  10 +
 arch/arm64/include/asm/xor.h             |  22 +-
 arch/arm64/kernel/fpsimd.c               |  34 +++-
 arch/arm64/lib/Makefile                  |   6 +-
 crypto/aegis128-neon.c                   |  33 ++-
 lib/crc/arm/crc-t10dif.h                 |  16 +-
 lib/crc/arm/crc32.h                      |  11 +-
 lib/crc/arm64/crc-t10dif.h               |  16 +-
 lib/crc/arm64/crc32.h                    |  16 +-
 lib/crypto/arm/chacha-glue.c             |   6 +-
 lib/crypto/arm/poly1305-glue.c           |   6 +-
 lib/crypto/arm/sha1.h                    |  13 +-
 lib/crypto/arm/sha256.h                  |  14 +-
 lib/crypto/arm/sha512.h                  |   6 +-
 lib/crypto/arm64/chacha-neon-glue.c      |  11 +-
 lib/crypto/arm64/poly1305-glue.c         |   6 +-
 lib/crypto/arm64/sha1.h                  |   7 +-
 lib/crypto/arm64/sha256.h                |  15 +-
 lib/crypto/arm64/sha512.h                |   8 +-
 lib/raid6/Makefile                       |  33 ++-
 lib/raid6/neon.c                         |  17 +-
 lib/raid6/recov_neon.c                   |  15 +-
 43 files changed, 597 insertions(+), 708 deletions(-)
 delete mode 100644 arch/arm64/include/asm/fpu.h

-- 
2.51.0.618.g983fd99d29-goog

