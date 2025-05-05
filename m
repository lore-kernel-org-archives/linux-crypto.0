Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131521C861D;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=cesplLLIADCTE2pd1vD7TaM6ZapqJlnXWc00mQhJyHOI85ogHpKT6AJW/rZVz6c0yM/8RYXdjO/qymv9ENb1SndFbMWsPQN2Ncqvxa6kmAJNsDeG4nbKcjrIkqo5GO1H9qv4K/wPtl7m3OmTbxjNOdWOh/pxsWng7hJzumq5cvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=Z5BG+wD+9VTRJdR/77ZQahKysplAfS/VV14lSAxIa00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jsJyMVTIbX8SvH74uyZURiHQcvhL8hIcRqzj8n7cdqvP/NX0A53nNmppCKclQ3gUYwY0tsJ8CV8PhjFQfoDeKrgLWrVEVCm1I0tUK8JeZBqpI0RNFHo3wAAZUTeAqP1B+3vMLcc0Tne5Y9SwiR1GALfkw95urp6xCCUnuzqKOy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJFvafyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJFvafyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0EAC4CEE4;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477435;
	bh=Z5BG+wD+9VTRJdR/77ZQahKysplAfS/VV14lSAxIa00=;
	h=From:To:Cc:Subject:Date:From;
	b=XJFvafywt0dfiB050ZvXaC/+mtz/AMzyMs3wp0XVcFsxFUtEalaDm+4EqLrgQb73a
	 QrXQl7hWzMvgTCJ9oFYC00fdUS8zm4d9wuqXX7cPfFjDyy1jT8oSO7PcpHphBIemKn
	 TDpL1XprefVfr1G7wresosbiDCKnIvpCd0JRZ9B839cKxPUOJ8TX+qW5VR7BxBYVgF
	 DUVA/oXQKh3XOKXp7A1JBIRG8MPZ9HxPloF/D90nIQZNfUt8C0O2UwhtFH/1+WIKRk
	 wiSG/6Cs4aKLI0mq6OHj/P2mkIwBJiZVQzZ1cIE2Dzf3DuuMVx9uy+CHCElBArb58G
	 nWSgauvqOZJjg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] Clean up the crypto testing options
Date: Mon,  5 May 2025 13:33:38 -0700
Message-ID: <20250505203345.802740-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series reworks the crypto testing kconfig options to fix some
longstanding issues:

- Replace the inverted option CONFIG_CRYPTO_MANAGER_DISABLE_TESTS with a
  regular option CONFIG_CRYPTO_SELFTESTS.

- Make CONFIG_CRYPTO_SELFTESTS enable the full set of tests by default,
  removing CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

- Automatically enable CONFIG_CRYPTO_MANAGER when needed for the tests.

- Rename cryptomgr.noextratests to cryptomgr.noslowtests.

- Remove cryptomgr.panic_on_fail, as panic_on_warn can be used instead.

- Rename CONFIG_CRYPTO_TEST to CONFIG_CRYPTO_BENCHMARK.

Changed in v3:
  - Keep options in defconfigs.
  - Make CRYPTO_SELFTESTS depend on DEBUG_KERNEL.

Changed in v2:
  - Moved selftest lines in lib/crypto/Makefile to appropriate places.
  - Fixed a commit message.

Eric Biggers (7):
  crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
  crypto: testmgr - remove panic_on_fail
  crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with
    CRYPTO_SELFTESTS
  crypto: testmgr - make it easier to enable the full set of tests
  crypto: testmgr - rename noextratests to noslowtests
  crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
  crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS

 arch/arm/configs/exynos_defconfig           |   2 +-
 arch/arm/configs/milbeaut_m10v_defconfig    |   3 +-
 arch/arm/configs/pxa_defconfig              |   3 +-
 arch/arm/configs/spitz_defconfig            |   2 +-
 arch/arm64/configs/defconfig                |   2 +-
 arch/loongarch/configs/loongson3_defconfig  |   2 +-
 arch/m68k/configs/amiga_defconfig           |   2 +-
 arch/m68k/configs/apollo_defconfig          |   2 +-
 arch/m68k/configs/atari_defconfig           |   2 +-
 arch/m68k/configs/bvme6000_defconfig        |   2 +-
 arch/m68k/configs/hp300_defconfig           |   2 +-
 arch/m68k/configs/mac_defconfig             |   2 +-
 arch/m68k/configs/multi_defconfig           |   2 +-
 arch/m68k/configs/mvme147_defconfig         |   2 +-
 arch/m68k/configs/mvme16x_defconfig         |   2 +-
 arch/m68k/configs/q40_defconfig             |   2 +-
 arch/m68k/configs/sun3_defconfig            |   2 +-
 arch/m68k/configs/sun3x_defconfig           |   2 +-
 arch/mips/configs/decstation_64_defconfig   |   1 -
 arch/mips/configs/decstation_defconfig      |   1 -
 arch/mips/configs/decstation_r4k_defconfig  |   1 -
 arch/mips/configs/gpr_defconfig             |   2 +-
 arch/mips/configs/ip28_defconfig            |   1 -
 arch/mips/configs/lemote2f_defconfig        |   2 +-
 arch/mips/configs/mtx1_defconfig            |   2 +-
 arch/mips/configs/rb532_defconfig           |   2 +-
 arch/parisc/configs/generic-32bit_defconfig |   2 +-
 arch/parisc/configs/generic-64bit_defconfig |   1 -
 arch/powerpc/configs/g5_defconfig           |   2 +-
 arch/powerpc/configs/powernv_defconfig      |   2 +-
 arch/powerpc/configs/ppc64_defconfig        |   2 +-
 arch/powerpc/configs/ppc64e_defconfig       |   2 +-
 arch/powerpc/configs/ppc6xx_defconfig       |   2 +-
 arch/s390/configs/debug_defconfig           |   4 +-
 arch/s390/configs/defconfig                 |   4 +-
 arch/sh/configs/migor_defconfig             |   1 -
 arch/sparc/configs/sparc64_defconfig        |   2 +-
 crypto/Kconfig                              |  45 ++++----
 crypto/Makefile                             |   2 +-
 crypto/algapi.c                             |   5 +-
 crypto/algboss.c                            |   2 +-
 crypto/api.c                                |   3 +-
 crypto/hkdf.c                               |   2 +-
 crypto/internal.h                           |   5 +-
 crypto/kdf_sp800108.c                       |   2 +-
 crypto/tcrypt.c                             |   8 +-
 crypto/tcrypt.h                             |   4 +-
 crypto/testmgr.c                            | 115 +++++---------------
 include/crypto/internal/simd.h              |   6 +-
 lib/crypto/Makefile                         |  11 +-
 lib/crypto/aescfb.c                         |   2 +-
 lib/crypto/aesgcm.c                         |   2 +-
 lib/crypto/blake2s.c                        |   2 +-
 lib/crypto/chacha20poly1305.c               |   2 +-
 lib/crypto/curve25519.c                     |   2 +-
 55 files changed, 111 insertions(+), 183 deletions(-)


base-commit: 64745a9ca890ed60d78162ec511e1983e1946d73
-- 
2.49.0

