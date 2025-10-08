Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71835221DB1
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938408; cv=none; b=odqUT/kel+ObZ1BAcoxoAXMx3zsRrwJ7MLReh++uxLoW+frTyuHy78bWYiGAxK8WJn2JYqkti34F2fgVGZ910xjDtug/LJv8d3HGuDjumpMfo1BF85HAwTBIWtMJPPGxb2WtDI9HmrpkBtgU+EYmqZM34j3F7DtsTxBAqu8H9Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938408; c=relaxed/simple;
	bh=eYljyxwuI+sEYQ4DBbDW0JEyR8r3lwsS/SwNly4bZAw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=I3iK41b3MxOManqdCQI9h9eJs89NeH8u1PyxkorCfTFy22ZjrszCiYt00ljZtZj1ZWwa9/uApOPtWnP/gPE3XX+C8C76geZMaJHzBEwb3KKfU3PT1B1ZOsBqlqYoZg1eDTQyupCbGG0c7L0yvE5+fi1wNF+J//3MYQ1XCtL7ruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TaJiHCY6; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TaJiHCY6"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso30576f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938405; x=1760543205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wmLD0z7TTnPR9XvYGkCWmhX+K+BenlBYSASZKFMhffQ=;
        b=TaJiHCY6pemf0LFD7VU0mJLyASz7yOO4nfgshw5x39q/xDqzFZ+20/Tp0n+EeiS1Ub
         u71/nivkG2sC4lIqfpQIFvh5WHwd0FlgF1iumnC15Y0VtathiEi44/Jrz6/uKal4LFuE
         3qxfleOB4QK9tbxxbCxvo5eJo7RV3i837srvjgu3sM0AkzG1T34cV7aCW3UB7+5xrvQT
         d4mWJRcvpOsITnPPn260p058u0C4fROBEfgyqLMn2DxlE2Qa6k4Ec3CNcf6e5VvC9rs9
         rY/XSkUh1hn9HPwEytUPnDUWi3eeMBwu7wbkEVHUQRW1T25RWsMvKG3E9/MfLZ3M2En4
         h6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938405; x=1760543205;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wmLD0z7TTnPR9XvYGkCWmhX+K+BenlBYSASZKFMhffQ=;
        b=S3JI9WyVDDBDWk6hLY7eWqiYwKl8Z+b87gKSvZlCR8bObDI7Ae8o7Hd6s+y3RPpsUB
         xFxnYcuREHDtUg5tfQirRTh0yWOs2HTqklaLvZoGfygDa1bgakXf+z1SAQQutGFa9rys
         7RdgIYxVTYjoUOmEQjGb7Xta+CpbzwdkqPEid/9Mu6HNLpqWU9MdRm30I7nD71WYQJLR
         KGXif8+X6YwistjL/arYVOz4ZZNI02iEGsDzmrWgkWEdA+d/xByV6ScFff1x0/Kz0l/S
         +/Nofp7vs4/BiVNWfJ28pEDzE7htARTm86z2lPeC5T1MrdrKWcxT92lBYxfOg55whOO1
         isrw==
X-Forwarded-Encrypted: i=1; AJvYcCVqLHJfH0uZ0ceK41FxbQ4TXqrrGpRdo88l+QX/ZzzpHlBHsynnJ5MBg7S/V72e4fxWpwwcQGBdXSwgp/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSLzWBEopjyN0MF9mBpx5HWK02N/bMqmyzJZH8L7IGZPzpyjD7
	SymSowFfYlJ/TFdyo6s/A2Xu4z+X1+dN57Oekp7Lmt3up4YOzSSn4JF2WvZXm76OtVnCWmSsiw=
	=
X-Google-Smtp-Source: AGHT+IEt8nUcjBjxcOiz44sFz9PXJ/AXhgR8lEUeC1XvfiF6QMnIgBcNlVH+mEjJkP1BeJHVT50cUdMM
X-Received: from wmvw6.prod.google.com ([2002:a05:600d:42c6:b0:46f:aa50:d703])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1a8b:b0:425:8bd1:fbb4
 with SMTP id ffacd0b85a97d-4266e7df95cmr2665651f8f.50.1759938404873; Wed, 08
 Oct 2025 08:46:44 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5474; i=ardb@kernel.org;
 h=from:subject; bh=LjOVrXxuH78jPv7wKv3YJ7SsGzEQCTxGhw6lFU8BtRY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu7zCPe21jfOED3k1nLNQCJywP8dNuDXL8HLf/FnGI
 spG+406SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwESktBkZLp6++6JM65F7daoV
 s/Sn1sm5D8VK260PhC88PEfm6ox38xn+8HRwbb3GsW5TfZm/sb5G+evvX+fF3DE/s7fjdpKtw04 9JgA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-23-ardb+git@google.com>
Subject: [PATCH v3 00/21] arm64: Move kernel mode FPSIMD buffer to the stack
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
 arch/arm64/include/asm/processor.h           |   2 +-
 arch/arm64/include/asm/simd.h                |  10 +
 arch/arm64/include/asm/xor.h                 |  22 +-
 arch/arm64/kernel/fpsimd.c                   |  44 ++--
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
 lib/crypto/arm/sha512.h                      |   6 +-
 lib/crypto/arm64/chacha.h                    |  11 +-
 lib/crypto/arm64/poly1305.h                  |   6 +-
 lib/crypto/arm64/sha1.h                      |   7 +-
 lib/crypto/arm64/sha256.h                    |  19 +-
 lib/crypto/arm64/sha512.h                    |   8 +-
 lib/raid6/neon.c                             |  17 +-
 lib/raid6/recov_neon.c                       |  15 +-
 40 files changed, 587 insertions(+), 692 deletions(-)


base-commit: 0d97f2067c166eb495771fede9f7b73999c67f66
-- 
2.51.0.710.ga91ca5db03-goog

