Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7D2191;
	Sun, 30 Nov 2025 03:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764471776; cv=none; b=TDdASquaRoFmuE/Qcy2/na67CwuB0U0KcS0LK2owAujFZOxZM50QRLAkiQqP4vNN/6mr9nkrxABYDT5mEDiSXRf01m2hAMugkYn4uSEsKvpVu4Z58k7krlFTfsva1dXDNmyGGwhoI9u0u8UnUz+pUyb3/y0w2ubOcKqOw0bf+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764471776; c=relaxed/simple;
	bh=isCPr0NiiiINXGXM7pxP4p9yORIK/EO5rqpXAC5ZRd0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GnO85e9fZDPVwBaMWM53FwLmm6C7DSairxr18y2wS0RiEr514teUtsdpYNh1DiAdJ+3HSnWqW5kFTXi4fIg/MYm369rtIml36NJ/4DbpdTjkW1cwF0UxIuKagve9rFM4o01UWWaaybwmaYgz74sANkv1ZWJvC0RSyGsqtxrxEhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siB8anuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siB8anuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAD9C113D0;
	Sun, 30 Nov 2025 03:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764471775;
	bh=isCPr0NiiiINXGXM7pxP4p9yORIK/EO5rqpXAC5ZRd0=;
	h=Date:From:To:Cc:Subject:From;
	b=siB8anujW+7tvvkEP+bPcdKSSEwsJsQ4RqRQHNkPep9YaRggWILNOQPVhEkoHgeZ6
	 rdW84NJje8Z0N0AqRWuyGSemmjqqORsx0c+6mkH3fkaTr7lIgjHgK0Kuf0RYzoFobg
	 0jSFFF1vmK6pICzCZ5Dr7dShiDGSnU74X+AW8KqZY1QchZRT45+SrPS7GpMKs1d2DM
	 TwUZh3CC1PEmne3Gssimi6cF8jarBZW8s4GXl8Zbw58xpBoBaOJhIuQeJSJjU/HTQu
	 mYxNP2LBRDM9fL9cIayeScptSgdLVNZ65/2WLl5Oeotv1a62+9ANhmThiWRC6eVeoF
	 mVlOPpunYv1NA==
Date: Sat, 29 Nov 2025 19:01:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>, Mark Brown <broonie@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [GIT PULL] arm64 FPSIMD buffer on-stack for 6.19
Message-ID: <20251130030105.GF12664@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Note: this is more of a core arm64 change.  However, I was asked to take
this because most uses of kernel-mode FPSIMD are in crypto or CRC code.
There were also conflicts with lib/crypto/ changes this cycle, which I
resolved.  But as a result, this depends on the pull request "Crypto
library updates for 6.19".  So that one needs to be merged first.

The following changes since commit 2dbb6f4a25d38fcf7d6c1c682e45a13e6bbe9562:

  fscrypt: Drop obsolete recommendation to enable optimized POLYVAL (2025-11-11 11:03:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/fpsimd-on-stack-for-linus

for you to fetch changes up to 5dc8d277520be6f0be11f36712e557167b3964c8:

  Merge tag 'arm64-fpsimd-on-stack-for-v6.19' into libcrypto-fpsimd-on-stack (2025-11-12 10:15:07 -0800)

----------------------------------------------------------------

In v6.8, the size of task_struct on arm64 increased by 528 bytes due
to the new 'kernel_fpsimd_state' field. This field was added to allow
kernel-mode FPSIMD code to be preempted.

Unfortunately, 528 bytes is kind of a lot for task_struct. This
regression in the task_struct size was noticed and reported.

Recover that space by making this state be allocated on the stack at
the beginning of each kernel-mode FPSIMD section.

To make it easier for all the users of kernel-mode FPSIMD to do that
correctly, introduce and use a 'scoped_ksimd' abstraction.

----------------------------------------------------------------
Ard Biesheuvel (23):
      arm64/simd: Add scoped guard API for kernel mode SIMD
      ARM/simd: Add scoped guard API for kernel mode SIMD
      lib/crypto: Switch ARM and arm64 to 'ksimd' scoped guard API
      lib/crc: Switch ARM and arm64 to 'ksimd' scoped guard API
      crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
      crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
      crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
      crypto: aegis128-neon - Move to more abstract 'ksimd' guard API
      raid6: Move to more abstract 'ksimd' guard API
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
      lib/crypto: arm/blake2b: Move to scoped ksimd API
      lib/crypto: arm64: Move remaining algorithms to scoped ksimd API

Eric Biggers (2):
      Merge tag 'scoped-ksimd-for-arm-arm64' into libcrypto-fpsimd-on-stack
      Merge tag 'arm64-fpsimd-on-stack-for-v6.19' into libcrypto-fpsimd-on-stack

 arch/arm/include/asm/simd.h                  |   7 +
 arch/arm64/crypto/aes-ce-ccm-glue.c          | 116 +++++++--------
 arch/arm64/crypto/aes-ce-glue.c              |  87 ++++++-----
 arch/arm64/crypto/aes-glue.c                 | 139 ++++++++---------
 arch/arm64/crypto/aes-neonbs-glue.c          | 150 +++++++++----------
 arch/arm64/crypto/ghash-ce-glue.c            |  27 ++--
 arch/arm64/crypto/nhpoly1305-neon-glue.c     |   5 +-
 arch/arm64/crypto/sm3-ce-glue.c              |  15 +-
 arch/arm64/crypto/sm3-neon-glue.c            |  16 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c          |  49 ++----
 arch/arm64/crypto/sm4-ce-cipher-glue.c       |  10 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c          |  62 +++-----
 arch/arm64/crypto/sm4-ce-glue.c              | 214 ++++++++++++---------------
 arch/arm64/crypto/sm4-neon-glue.c            |  25 +---
 arch/arm64/include/asm/fpu.h                 |  16 +-
 arch/arm64/include/asm/neon.h                |   4 +-
 arch/arm64/include/asm/processor.h           |   7 +-
 arch/arm64/include/asm/simd.h                |  10 ++
 arch/arm64/include/asm/xor.h                 |  22 ++-
 arch/arm64/kernel/fpsimd.c                   |  54 +++++--
 crypto/aegis128-neon.c                       |  33 ++---
 drivers/net/ethernet/mellanox/mlx5/core/wc.c |  19 +--
 lib/crc/arm/crc-t10dif.h                     |  19 +--
 lib/crc/arm/crc32.h                          |  11 +-
 lib/crc/arm64/crc-t10dif.h                   |  19 +--
 lib/crc/arm64/crc32.h                        |  16 +-
 lib/crypto/arm/blake2b.h                     |   5 +-
 lib/crypto/arm/chacha.h                      |  11 +-
 lib/crypto/arm/curve25519.h                  |   5 +-
 lib/crypto/arm/poly1305.h                    |   6 +-
 lib/crypto/arm/sha1.h                        |  13 +-
 lib/crypto/arm/sha256.h                      |  12 +-
 lib/crypto/arm/sha512.h                      |   5 +-
 lib/crypto/arm64/chacha.h                    |  11 +-
 lib/crypto/arm64/poly1305.h                  |   6 +-
 lib/crypto/arm64/polyval.h                   |  24 ++-
 lib/crypto/arm64/sha1.h                      |   7 +-
 lib/crypto/arm64/sha256.h                    |  19 +--
 lib/crypto/arm64/sha3.h                      |  13 +-
 lib/crypto/arm64/sha512.h                    |   8 +-
 lib/raid6/neon.c                             |  17 +--
 lib/raid6/recov_neon.c                       |  15 +-
 42 files changed, 617 insertions(+), 712 deletions(-)
