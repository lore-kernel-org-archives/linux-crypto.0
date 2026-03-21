Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596C178F4F;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066318; cv=none; b=qcwLSoQ0TPYAqOY0JFiLRttRYMsAA92lKzE9q/c0aQNohnEgbCroErM1GuENU5OVu2Xsdb9xn7kZQDXw5B/f6O9l4F2G/oKTB0nlm5Tfk8PfCNFiO80QxwWZgmOu8cBTA052AZS5HuQxgvMnw8iKx+sWfVnSLCwVBEwu/Rn9CRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066318; c=relaxed/simple;
	bh=fj6sggzE4JvFjjT3IM/Os569Uw8//wRCE/8lDXERHkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZQf3NVIYPz0qXY4A2nHE8fPX1nuMoLu5D5rVfW1YNOPcfVqWeHQmQNQ8QjJruQxf26ACDmlqBf++ejpiBt4cfdFRWF6nKpJWHui6vEprNhK9esK+PUFOEo/WF/yg3TtwHv7udROv/RasWx2ONr3LwnRlcWIUqlzfdE/E4yJXiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5oS/n8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5oS/n8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEF9C19421;
	Sat, 21 Mar 2026 04:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066317;
	bh=fj6sggzE4JvFjjT3IM/Os569Uw8//wRCE/8lDXERHkQ=;
	h=From:To:Cc:Subject:Date:From;
	b=i5oS/n8NHXCgi6awKyehSxxl2G4wUO/8Kxny/uxQ3h4no0B+pFCy3Tmrl1fcpy1Ag
	 gRbnxYWtJil1zgDHPrhbqfJCybShdgjm6UHfhCLO2Ht5FPEY3SYDkLr5JRHMWlkKcS
	 CNBFRsVKjHB45zaXiqnjxElogg9/bTzLVEQyLtkIuyG6+540iY6hIHPcVRnb3Ecazr
	 C+tesfVpwhCVpgGwnu9tHW+CLIGqFCHEvYdzTtHnnKfw/zEuZmhIQmbleXtpfx+jg9
	 yLxs8Le29ty9iydZv9JG6AiqNcKjCEXUNfdqwdScf5OJdKDRjEL4DZdLxQqVqOZ6DA
	 6bmc8OyRYhHMw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/12] SM3 library
Date: Fri, 20 Mar 2026 21:09:23 -0700
Message-ID: <20260321040935.410034-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sm3-lib-v1

This series cleans up the kernel's existing SM3 hashing code:

- First, it updates lib/crypto/sm3.c to implement the full SM3 instead
  of just SM3's compression function.

- Next, it adds a KUnit test suite for the new library API.

- Next, it replaces the "sm3-generic" crypto_shash with a wrapper around
  the new library API.

- Finally, it accelerates the API using the existing SM3 assembly code
  for arm64, riscv, and x86.  The architecture-specific crypto_shash
  glue code for SM3 is no longer needed and is removed.

This should look quite boring.  It's the same cleanup that I've already
done for the other hash functions.

Note: I don't recommend using SM3.  There also don't appear to be any
immediate candidate users of the SM3 library other than crypto_shash.

Still, this seems like the clear way to go.  It's simpler, and it gets
the hash algorithms integrated in a consistent way.  We won't have to
keep track of two quite different ways of doing things.  With KUnit the
code becomes much easier to test and benchmark, as well.

Eric Biggers (12):
  crypto: sm3 - Fold sm3_init() into its caller
  crypto: sm3 - Remove sm3_zero_message_hash and SM3_T[1-2]
  crypto: sm3 - Rename CRYPTO_SM3_GENERIC to CRYPTO_SM3
  lib/crypto: sm3: Add SM3 library API
  lib/crypto: tests: Add KUnit tests for SM3
  crypto: sm3 - Replace with wrapper around library
  lib/crypto: arm64/sm3: Migrate optimized code into library
  lib/crypto: riscv/sm3: Migrate optimized code into library
  lib/crypto: x86/sm3: Migrate optimized code into library
  crypto: sm3 - Remove sm3_base.h
  crypto: sm3 - Remove the original "sm3_block_generic()"
  crypto: sm3 - Remove 'struct sm3_state'

 arch/arm64/configs/defconfig                  |   2 +-
 arch/arm64/crypto/Kconfig                     |  22 --
 arch/arm64/crypto/Makefile                    |   6 -
 arch/arm64/crypto/sm3-ce-glue.c               |  70 ------
 arch/arm64/crypto/sm3-neon-glue.c             |  67 -----
 arch/loongarch/configs/loongson32_defconfig   |   2 +-
 arch/loongarch/configs/loongson64_defconfig   |   2 +-
 arch/m68k/configs/amiga_defconfig             |   2 +-
 arch/m68k/configs/apollo_defconfig            |   2 +-
 arch/m68k/configs/atari_defconfig             |   2 +-
 arch/m68k/configs/bvme6000_defconfig          |   2 +-
 arch/m68k/configs/hp300_defconfig             |   2 +-
 arch/m68k/configs/mac_defconfig               |   2 +-
 arch/m68k/configs/multi_defconfig             |   2 +-
 arch/m68k/configs/mvme147_defconfig           |   2 +-
 arch/m68k/configs/mvme16x_defconfig           |   2 +-
 arch/m68k/configs/q40_defconfig               |   2 +-
 arch/m68k/configs/sun3_defconfig              |   2 +-
 arch/m68k/configs/sun3x_defconfig             |   2 +-
 arch/riscv/crypto/Kconfig                     |  13 -
 arch/riscv/crypto/Makefile                    |   3 -
 arch/s390/configs/debug_defconfig             |   2 +-
 arch/s390/configs/defconfig                   |   2 +-
 arch/x86/crypto/Kconfig                       |  13 -
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/sm3_avx_glue.c                | 100 --------
 crypto/Kconfig                                |   2 +-
 crypto/Makefile                               |   2 +-
 crypto/{sm3_generic.c => sm3.c}               |  89 ++++---
 crypto/testmgr.c                              |   2 +
 drivers/crypto/Kconfig                        |   2 +-
 drivers/crypto/starfive/Kconfig               |   2 +-
 drivers/crypto/starfive/jh7110-hash.c         |   8 +-
 include/crypto/sm3.h                          |  85 ++++---
 include/crypto/sm3_base.h                     |  82 -------
 lib/crypto/.kunitconfig                       |   1 +
 lib/crypto/Kconfig                            |  11 +
 lib/crypto/Makefile                           |  15 +-
 .../crypto => lib/crypto/arm64}/sm3-ce-core.S |  11 +-
 .../crypto/arm64}/sm3-neon-core.S             |   9 +-
 lib/crypto/arm64/sm3.h                        |  41 ++++
 .../crypto/riscv}/sm3-riscv64-zvksh-zvkb.S    |   3 +-
 .../crypto/riscv/sm3.h                        |  84 +------
 lib/crypto/sm3.c                              | 148 +++++++++--
 lib/crypto/tests/Kconfig                      |   9 +
 lib/crypto/tests/Makefile                     |   1 +
 lib/crypto/tests/sm3-testvecs.h               | 231 ++++++++++++++++++
 lib/crypto/tests/sm3_kunit.c                  |  31 +++
 .../crypto/x86}/sm3-avx-asm_64.S              |  13 +-
 lib/crypto/x86/sm3.h                          |  39 +++
 scripts/crypto/gen-hash-testvecs.py           |   3 +
 security/integrity/ima/Kconfig                |   2 +-
 52 files changed, 670 insertions(+), 587 deletions(-)
 delete mode 100644 arch/arm64/crypto/sm3-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sm3-neon-glue.c
 delete mode 100644 arch/x86/crypto/sm3_avx_glue.c
 rename crypto/{sm3_generic.c => sm3.c} (30%)
 delete mode 100644 include/crypto/sm3_base.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/sm3-ce-core.S (93%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/sm3-neon-core.S (98%)
 create mode 100644 lib/crypto/arm64/sm3.h
 rename {arch/riscv/crypto => lib/crypto/riscv}/sm3-riscv64-zvksh-zvkb.S (97%)
 rename arch/riscv/crypto/sm3-riscv64-glue.c => lib/crypto/riscv/sm3.h (18%)
 create mode 100644 lib/crypto/tests/sm3-testvecs.h
 create mode 100644 lib/crypto/tests/sm3_kunit.c
 rename {arch/x86/crypto => lib/crypto/x86}/sm3-avx-asm_64.S (98%)
 create mode 100644 lib/crypto/x86/sm3.h


base-commit: 6bc9effb4cbf9b6eba0f51aba1c8893dfd4c8100
-- 
2.53.0

