Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564AF4502B;
	Sat, 19 Apr 2025 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079453; cv=none; b=l+8W1SysK0XhNNI7tYKwhJOMO0YUokquMptHmULV2N4kMc8kdrUDlLC9yMFJ7anN+gVCiJgnQTjmDj/ojj2zVLVNj6O4641Zg0GS6H8xHAZ1nQA7NlXImdZryfZZgjbL6OfuYnSru6xZFUSTY/rk5LAUMLJT1LJwKeF0p4Hfyx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079453; c=relaxed/simple;
	bh=E8AMmmsrna3jIHbV+6Evsco7BtpppoUwnrfSPTyMeQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mHC84AGqNHLzPeek2GIEt9bXxj0A6/4IdKv3YlqC9SZPzU+Mt8jhVN4JV5ilDWPVq7owXu8pg4EeOzKpumimkOVBNUKtMxvAsjmWGbKeXbfrZGhj21oCIB4f7wku0FpH3N0QR6V3pscOJAw6Lxc0qaDdb2DZaiJ+7TcBuA3g59c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMeaXGD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMeaXGD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D8AC4CEE7;
	Sat, 19 Apr 2025 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079452;
	bh=E8AMmmsrna3jIHbV+6Evsco7BtpppoUwnrfSPTyMeQg=;
	h=From:To:Cc:Subject:Date:From;
	b=WMeaXGD+1sXv/yVymB5ZSTOxZwdr6kvdewcv45PM0fbmtPRgDwCplPoSglURMIlpm
	 XkG4rFYMWBrUamITivmlwnqVwcbaIS53uXWPnmAj7snIHmYLGWJ3rNY1nQZa8Tr+D1
	 1w1efRkGBFxe4iWRgKixO+RuHhejGVOJh73PFbhv8JDU7D9g1KVGe02wYsh73GdWyy
	 1PARVJYhJItiJn+Opo/fZzDvPsi0QTd4PrD+oApAo7jsp8Hcg6DFPaVhM9JuzC9jmH
	 azZXTdeytgBFUu+/WfRX7bBo3R9HeCO6ANQKRCw8dNW5JsWYU6EgZP2vgIK8/3S37t
	 EHUQGp/usCs2w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Clean up the crypto testing options
Date: Sat, 19 Apr 2025 09:15:34 -0700
Message-ID: <20250419161543.139344-1-ebiggers@kernel.org>
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
 lib/crypto/Makefile                         |  10 +-
 lib/crypto/aescfb.c                         |   2 +-
 lib/crypto/aesgcm.c                         |   2 +-
 lib/crypto/blake2s.c                        |   2 +-
 lib/crypto/chacha20poly1305.c               |   2 +-
 lib/crypto/curve25519.c                     |   2 +-
 55 files changed, 77 insertions(+), 182 deletions(-)


base-commit: bb9c648b334be581a791c7669abaa594e4b5ebb7
-- 
2.49.0

