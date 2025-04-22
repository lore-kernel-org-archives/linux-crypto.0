Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A4F28FFC8;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335336; cv=none; b=P+ntz8ErpGW5LTyKPzazWbVB3lowQKHlelJQvzsMIn4O+/UsfgTgARIUyz7U44K8fUy5RrDmBOJ9W4JLk0P4dzMU0G3nro3ysT0GINfhusyZy4wyJ64qVUsWSMmkk8+2+OWwdcIVkNu7H2KPPlerHcJL2LZIbEPGcqp33v7ykDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335336; c=relaxed/simple;
	bh=zUtpOZDFxmrHW1MXGPjDdrx0vQICEc+s+0Jje5GRyXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tx2QRfvP05lsdsr+yicZAPAaRC0Y13gcMOT3GDlgp8T2o5mWaeDHdfUqArCxSz1QiC6Nbr8zs+3hQ4GfeWitsym8bTzxFOVYHbIl1XaSMrol3xAmnZpGbIevY81VQhVxcRtseyL01/6X71IC23cKXTVMjzgA2hJdd4Zyfkx3YN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfVWQoeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfVWQoeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A1C4CEE9;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335335;
	bh=zUtpOZDFxmrHW1MXGPjDdrx0vQICEc+s+0Jje5GRyXQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WfVWQoehc386JtqAJhFPLmCvJLqfrp7w9HGh1Nfb9QjxTiDCPwoTJbPKOKZF+yS9U
	 nTJao6xjerKJG2H4uBBQ+IVzI+IBqXhLwElXmdZnHttlJpKGuwSeOX+AYwaZwiwU7k
	 R7ZgdkSDZhiOVYDqdMCj+/P0nJSnUS5WFGyyOSCkYUAoMS8OhVHSImojj6Gecealml
	 HPBQmE7MGErHNXKCQK2YcZWvubozmO0deqgN7NQrVRLqICCajZ3ks3DCT+7q0QFqE5
	 /wvX2w/+dYba3nOjHM67MxB8MGUgsMLzgibZh4JdzgmBs0T45cFuxLLxtQ876FTaBN
	 qSB/8FIyWAQsg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] Clean up the crypto testing options
Date: Tue, 22 Apr 2025 08:21:42 -0700
Message-ID: <20250422152151.3691-1-ebiggers@kernel.org>
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

Changed in v2:
  - Moved selftest lines in lib/crypto/Makefile to appropriate places.
  - Fixed a commit message.

Eric Biggers (9):
  crypto: tcrypt - remove CRYPTO_TEST from defconfigs
  crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
  crypto: testmgr - remove CRYPTO_MANAGER_DISABLE_TESTS from defconfigs
  crypto: testmgr - remove panic_on_fail
  crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with
    CRYPTO_SELFTESTS
  crypto: testmgr - make it easier to enable the full set of tests
  crypto: testmgr - rename noextratests to noslowtests
  crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
  crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS

 arch/arm/configs/exynos_defconfig           |   1 -
 arch/arm/configs/milbeaut_m10v_defconfig    |   2 -
 arch/arm/configs/pxa_defconfig              |   2 -
 arch/arm/configs/spitz_defconfig            |   1 -
 arch/arm64/configs/defconfig                |   1 -
 arch/loongarch/configs/loongson3_defconfig  |   1 -
 arch/m68k/configs/amiga_defconfig           |   1 -
 arch/m68k/configs/apollo_defconfig          |   1 -
 arch/m68k/configs/atari_defconfig           |   1 -
 arch/m68k/configs/bvme6000_defconfig        |   1 -
 arch/m68k/configs/hp300_defconfig           |   1 -
 arch/m68k/configs/mac_defconfig             |   1 -
 arch/m68k/configs/multi_defconfig           |   1 -
 arch/m68k/configs/mvme147_defconfig         |   1 -
 arch/m68k/configs/mvme16x_defconfig         |   1 -
 arch/m68k/configs/q40_defconfig             |   1 -
 arch/m68k/configs/sun3_defconfig            |   1 -
 arch/m68k/configs/sun3x_defconfig           |   1 -
 arch/mips/configs/decstation_64_defconfig   |   1 -
 arch/mips/configs/decstation_defconfig      |   1 -
 arch/mips/configs/decstation_r4k_defconfig  |   1 -
 arch/mips/configs/gpr_defconfig             |   1 -
 arch/mips/configs/ip28_defconfig            |   1 -
 arch/mips/configs/lemote2f_defconfig        |   1 -
 arch/mips/configs/mtx1_defconfig            |   1 -
 arch/mips/configs/rb532_defconfig           |   1 -
 arch/parisc/configs/generic-32bit_defconfig |   1 -
 arch/parisc/configs/generic-64bit_defconfig |   1 -
 arch/powerpc/configs/g5_defconfig           |   1 -
 arch/powerpc/configs/powernv_defconfig      |   1 -
 arch/powerpc/configs/ppc64_defconfig        |   1 -
 arch/powerpc/configs/ppc64e_defconfig       |   1 -
 arch/powerpc/configs/ppc6xx_defconfig       |   1 -
 arch/s390/configs/debug_defconfig           |   2 -
 arch/s390/configs/defconfig                 |   2 -
 arch/sh/configs/migor_defconfig             |   1 -
 arch/sparc/configs/sparc64_defconfig        |   1 -
 crypto/Kconfig                              |  44 ++++----
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
 55 files changed, 77 insertions(+), 183 deletions(-)


base-commit: bb9c648b334be581a791c7669abaa594e4b5ebb7
-- 
2.49.0

