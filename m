Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27502DF68;
	Sat, 27 Sep 2025 20:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759003294; cv=none; b=aBszTNWRLORF648QSWwa7x2WcGSITJ0iSRA/0/J0+erP4E4ln8KMy8eg3wvH8qeb/KROvx6YwlFp1SZtIIHwQNAhrD6KwM0+04x61iftBLd7UN90SZHStl8AEt/EG7RjeCIHTmIXnMRyG3CiUI0T+42aWwbQhMKVFJpKb07d8mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759003294; c=relaxed/simple;
	bh=gVL60xKsCZ6RMqJqU1DCXvgWBojCWFpIg8dNJFgRNvM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bTUWK/nDgEQ1YHuaUFccEiMNE+UWU62G2j7RGcgE8hPxzVJ8pslMHSxeouQRn+D7liiLopEmoMr6mhcn0GmXjSzmYM7na71gxtF3cvar3KASNBzMpZktnIgjfNuypbVKVt3R9y4MsON0trm5UxFCABjdQfW3NREujZBASOQCL44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaXHqLd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaXHqLd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B25C4CEE7;
	Sat, 27 Sep 2025 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759003294;
	bh=gVL60xKsCZ6RMqJqU1DCXvgWBojCWFpIg8dNJFgRNvM=;
	h=Date:From:To:Cc:Subject:From;
	b=NaXHqLd3sc7yMFY2RvZ6rGQJPC07TIj8tiYLzIxHc2TglDiF+ERJGHy2oMKOPrcaM
	 vxqUJ/vcpw7eXT+AVwJZFSDpN24P/c2wEjSLEXrE7h/DtJnS9E9sEDdT7iUz1/gncz
	 UUBPfX5HsXpo+IKsHcPFI8S5eVBrbkDn1cuOQkvejEgK2drnJ3CvXnPQJlmWRVyMvg
	 b59tn47nZO6kUQtIFA1URDzAayEDp3fxpv7ZTaem1iYc/mgsjukQKk8w5T8wk2wS6m
	 ps3hdUAVX6xcShF1grBeASbbLRbSiX++AdNpxcoFdrUQscQ2A9/xtYRh1GcMYCyWrk
	 sowSqAEUa3Lug==
Date: Sat, 27 Sep 2025 13:01:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Zhiqi Song <songzhiqi1@huawei.com>
Subject: [GIT PULL] Crypto library updates for 6.18
Message-ID: <20250927200131.GB9798@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to b94bc4398beccd329a51052c5e7e84e4670dbcd9:

  crypto: md5 - Implement export_core() and import_core() (2025-09-08 09:47:38 -0700)

----------------------------------------------------------------

- Add a RISC-V optimized implementation of Poly1305. This code was
  written by Andy Polyakov and contributed by Zhihang Shao.

- Migrate the MD5 code into lib/crypto/, and add KUnit tests for MD5.
  Yes, it's still the 90s, and several kernel subsystems are still
  using MD5 for legacy use cases. As long as that remains the case,
  it's helpful to clean it up in the same way as I've been doing for
  other algorithms. Later, I plan to convert most users of MD5 to use
  the new MD5 library API instead of the generic crypto API.

- Simplify the organization of the ChaCha, Poly1305, BLAKE2s, and
  Curve25519 code. Consolidate these into one module per algorithm,
  and centralize the configuration and build process. This is the same
  reorganization that has already been successful for SHA-1 and SHA-2.

- Remove the unused crypto_kpp API for Curve25519.

- Migrate the BLAKE2s and Curve25519 self-tests to KUnit.

- Always enable the architecture-optimized BLAKE2s code.

Due to interdependencies between test and non-test code, both are
included in this pull request. The broken-down diffstat is as follows:

    Tests:            735 insertions(+), 1917 deletions(-)
    RISC-V Poly1305:  877 insertions(+), 1 deletion(-)
    Other:           1777 insertions(+), 3117 deletions(-)

Besides the new RISC-V code which is an addition, there are quite a
few simplifications due to the improved code organization for multiple
algorithms, the removal of the unused crypto_kpp API for Curve25519
and redundant tests, and the redesign of the BLAKE2s test.

----------------------------------------------------------------
Eric Biggers (37):
      lib/crypto: sha256: Use underlying functions instead of crypto_simd_usable()
      lib/crypto: sha512: Use underlying functions instead of crypto_simd_usable()
      lib/crypto: md5: Add MD5 and HMAC-MD5 library functions
      lib/crypto: mips/md5: Migrate optimized code into library
      mips: cavium-octeon: Move octeon-crypto.c into parent dir
      lib/crypto: powerpc/md5: Migrate optimized code into library
      lib/crypto: sparc/md5: Migrate optimized code into library
      crypto: md5 - Wrap library and add HMAC support
      lib/crypto: tests: Add KUnit tests for MD5 and HMAC-MD5
      lib/crypto: Drop inline from all *_mod_init_arch() functions
      lib/crypto: poly1305: Remove unused function poly1305_is_arch_optimized()
      lib/crypto: poly1305: Consolidate into single module
      arm: configs: Remove obsolete assignments to CRYPTO_CHACHA20_NEON
      crypto: chacha - register only "-lib" drivers
      lib/crypto: chacha: Remove unused function chacha_is_arch_optimized()
      lib/crypto: chacha: Rename chacha.c to chacha-block-generic.c
      lib/crypto: chacha: Rename libchacha.c to chacha.c
      lib/crypto: chacha: Consolidate into single module
      lib/crypto: x86/blake2s: Reduce size of BLAKE2S_SIGMA2
      lib/crypto: blake2s: Remove obsolete self-test
      lib/crypto: blake2s: Always enable arch-optimized BLAKE2s code
      lib/crypto: blake2s: Move generic code into blake2s.c
      lib/crypto: blake2s: Consolidate into single C translation unit
      lib/crypto: tests: Add KUnit tests for BLAKE2s
      crypto: hisilicon/hpre - Remove unused curve25519 kpp support
      crypto: arm/curve25519 - Remove unused kpp support
      crypto: powerpc/curve25519 - Remove unused kpp support
      crypto: x86/curve25519 - Remove unused kpp support
      crypto: testmgr - Remove curve25519 kpp tests
      crypto: curve25519 - Remove unused kpp support
      lib/crypto: tests: Migrate Curve25519 self-test to KUnit
      lib/crypto: tests: Add Curve25519 benchmark
      lib/crypto: curve25519: Move a couple functions out-of-line
      lib/crypto: curve25519: Consolidate into single module
      lib/crypto: tests: Enable Curve25519 test when CRYPTO_SELFTESTS
      wireguard: kconfig: simplify crypto kconfig selections
      crypto: md5 - Implement export_core() and import_core()

Zhihang Shao (1):
      lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation

 arch/arm/configs/exynos_defconfig                  |    1 -
 arch/arm/configs/milbeaut_m10v_defconfig           |    1 -
 arch/arm/configs/multi_v7_defconfig                |    1 -
 arch/arm/configs/omap2plus_defconfig               |    1 -
 arch/arm/crypto/Kconfig                            |   13 -
 arch/arm/crypto/Makefile                           |    2 -
 arch/arm/crypto/curve25519-glue.c                  |  137 ---
 arch/m68k/configs/amiga_defconfig                  |    1 -
 arch/m68k/configs/apollo_defconfig                 |    1 -
 arch/m68k/configs/atari_defconfig                  |    1 -
 arch/m68k/configs/bvme6000_defconfig               |    1 -
 arch/m68k/configs/hp300_defconfig                  |    1 -
 arch/m68k/configs/mac_defconfig                    |    1 -
 arch/m68k/configs/multi_defconfig                  |    1 -
 arch/m68k/configs/mvme147_defconfig                |    1 -
 arch/m68k/configs/mvme16x_defconfig                |    1 -
 arch/m68k/configs/q40_defconfig                    |    1 -
 arch/m68k/configs/sun3_defconfig                   |    1 -
 arch/m68k/configs/sun3x_defconfig                  |    1 -
 arch/mips/cavium-octeon/Makefile                   |    2 +-
 arch/mips/cavium-octeon/crypto/Makefile            |    8 -
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |  214 ----
 .../cavium-octeon/{crypto => }/octeon-crypto.c     |    0
 arch/mips/configs/cavium_octeon_defconfig          |    1 -
 arch/mips/crypto/Kconfig                           |   10 -
 arch/powerpc/configs/powernv_defconfig             |    1 -
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/crypto/Kconfig                        |   21 -
 arch/powerpc/crypto/Makefile                       |    4 -
 arch/powerpc/crypto/md5-glue.c                     |   99 --
 arch/s390/configs/debug_defconfig                  |    1 -
 arch/s390/configs/defconfig                        |    1 -
 arch/sparc/crypto/Kconfig                          |   10 -
 arch/sparc/crypto/Makefile                         |    4 -
 arch/sparc/crypto/md5_glue.c                       |  174 ---
 arch/x86/crypto/Kconfig                            |   13 -
 arch/x86/crypto/Makefile                           |    5 -
 crypto/Kconfig                                     |   14 +-
 crypto/Makefile                                    |    1 -
 crypto/chacha.c                                    |  129 +--
 crypto/curve25519-generic.c                        |   91 --
 crypto/md5.c                                       |  398 ++++---
 crypto/testmgr.c                                   |   18 +-
 crypto/testmgr.h                                   | 1225 --------------------
 drivers/crypto/hisilicon/Kconfig                   |    1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  403 +------
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/net/Kconfig                                |   15 +-
 include/crypto/chacha.h                            |   37 +-
 include/crypto/curve25519.h                        |   40 +-
 include/crypto/internal/blake2s.h                  |   21 -
 include/crypto/internal/poly1305.h                 |   16 +-
 include/crypto/md5.h                               |  181 ++-
 include/crypto/poly1305.h                          |    9 -
 lib/crypto/Kconfig                                 |  169 ++-
 lib/crypto/Makefile                                |  169 ++-
 lib/crypto/arm/Kconfig                             |   24 -
 lib/crypto/arm/Makefile                            |   26 -
 lib/crypto/arm/blake2s-core.S                      |    5 +-
 lib/crypto/arm/blake2s-glue.c                      |    7 -
 lib/crypto/arm/blake2s.h                           |    5 +
 lib/crypto/arm/{chacha-glue.c => chacha.h}         |   35 +-
 .../crypto => lib/crypto/arm}/curve25519-core.S    |    0
 lib/crypto/arm/curve25519.h                        |   47 +
 lib/crypto/arm/poly1305-armv4.pl                   |    3 +-
 lib/crypto/arm/poly1305-glue.c                     |   76 --
 lib/crypto/arm/poly1305.h                          |   53 +
 lib/crypto/arm/sha1.h                              |    2 +-
 lib/crypto/arm/sha256.h                            |   12 +-
 lib/crypto/arm/sha512.h                            |    7 +-
 lib/crypto/arm64/Kconfig                           |   14 -
 lib/crypto/arm64/Makefile                          |   17 -
 lib/crypto/arm64/{chacha-neon-glue.c => chacha.h}  |   32 +-
 lib/crypto/arm64/poly1305-armv8.pl                 |    3 +
 lib/crypto/arm64/poly1305-glue.c                   |   74 --
 lib/crypto/arm64/poly1305.h                        |   50 +
 lib/crypto/arm64/sha1.h                            |    2 +-
 lib/crypto/arm64/sha256.h                          |   12 +-
 lib/crypto/arm64/sha512.h                          |    7 +-
 lib/crypto/blake2s-generic.c                       |  111 --
 lib/crypto/blake2s-selftest.c                      |  651 -----------
 lib/crypto/blake2s.c                               |  105 +-
 lib/crypto/chacha-block-generic.c                  |  114 ++
 lib/crypto/chacha.c                                |  142 +--
 lib/crypto/curve25519-generic.c                    |   25 -
 lib/crypto/curve25519.c                            |   69 +-
 lib/crypto/libchacha.c                             |   35 -
 lib/crypto/md5.c                                   |  322 +++++
 lib/crypto/mips/Kconfig                            |   12 -
 lib/crypto/mips/Makefile                           |   19 -
 lib/crypto/mips/chacha-glue.c                      |   29 -
 lib/crypto/mips/chacha.h                           |   14 +
 lib/crypto/mips/md5.h                              |   65 ++
 lib/crypto/mips/poly1305-glue.c                    |   33 -
 lib/crypto/mips/poly1305-mips.pl                   |    8 +-
 lib/crypto/mips/poly1305.h                         |   14 +
 lib/crypto/poly1305-generic.c                      |   25 -
 lib/crypto/poly1305.c                              |   81 +-
 lib/crypto/powerpc/Kconfig                         |   16 -
 lib/crypto/powerpc/Makefile                        |    7 -
 lib/crypto/powerpc/{chacha-p10-glue.c => chacha.h} |   36 +-
 .../crypto/powerpc}/curve25519-ppc64le_asm.S       |    0
 .../crypto/powerpc/curve25519.h                    |  124 +-
 .../crypto => lib/crypto/powerpc}/md5-asm.S        |    0
 lib/crypto/powerpc/md5.h                           |   12 +
 .../powerpc/{poly1305-p10-glue.c => poly1305.h}    |   40 +-
 lib/crypto/riscv/Kconfig                           |    8 -
 lib/crypto/riscv/Makefile                          |    4 -
 .../riscv/{chacha-riscv64-glue.c => chacha.h}      |   36 +-
 lib/crypto/riscv/poly1305-riscv.pl                 |  847 ++++++++++++++
 lib/crypto/riscv/poly1305.h                        |   14 +
 lib/crypto/riscv/sha256.h                          |   10 +-
 lib/crypto/riscv/sha512.h                          |    6 +-
 lib/crypto/s390/Kconfig                            |    7 -
 lib/crypto/s390/Makefile                           |    4 -
 lib/crypto/s390/{chacha-glue.c => chacha.h}        |   29 +-
 lib/crypto/s390/sha1.h                             |    2 +-
 lib/crypto/s390/sha256.h                           |    2 +-
 lib/crypto/s390/sha512.h                           |    2 +-
 lib/crypto/sparc/md5.h                             |   48 +
 {arch/sparc/crypto => lib/crypto/sparc}/md5_asm.S  |    0
 lib/crypto/sparc/sha1.h                            |    2 +-
 lib/crypto/sparc/sha256.h                          |    2 +-
 lib/crypto/sparc/sha512.h                          |    2 +-
 lib/crypto/tests/Kconfig                           |   29 +
 lib/crypto/tests/Makefile                          |    3 +
 lib/crypto/tests/blake2s-testvecs.h                |  238 ++++
 lib/crypto/tests/blake2s_kunit.c                   |  134 +++
 .../curve25519_kunit.c}                            |  102 +-
 lib/crypto/tests/md5-testvecs.h                    |  186 +++
 lib/crypto/tests/md5_kunit.c                       |   39 +
 lib/crypto/x86/Kconfig                             |   26 -
 lib/crypto/x86/Makefile                            |   17 -
 lib/crypto/x86/blake2s-core.S                      |   28 +-
 lib/crypto/x86/{blake2s-glue.c => blake2s.h}       |   16 +-
 lib/crypto/x86/{chacha_glue.c => chacha.h}         |   36 +-
 .../crypto/x86/curve25519.h                        |  127 +-
 lib/crypto/x86/poly1305-x86_64-cryptogams.pl       |   33 +-
 lib/crypto/x86/{poly1305_glue.c => poly1305.h}     |   47 +-
 lib/crypto/x86/sha1.h                              |    2 +-
 lib/crypto/x86/sha256.h                            |    5 +-
 lib/crypto/x86/sha512.h                            |    6 +-
 scripts/crypto/gen-hash-testvecs.py                |   27 +-
 143 files changed, 3389 insertions(+), 5035 deletions(-)
 delete mode 100644 arch/arm/crypto/curve25519-glue.c
 delete mode 100644 arch/mips/cavium-octeon/crypto/Makefile
 delete mode 100644 arch/mips/cavium-octeon/crypto/octeon-md5.c
 rename arch/mips/cavium-octeon/{crypto => }/octeon-crypto.c (100%)
 delete mode 100644 arch/powerpc/crypto/md5-glue.c
 delete mode 100644 arch/sparc/crypto/md5_glue.c
 delete mode 100644 crypto/curve25519-generic.c
 delete mode 100644 include/crypto/internal/blake2s.h
 delete mode 100644 lib/crypto/arm/Kconfig
 delete mode 100644 lib/crypto/arm/Makefile
 delete mode 100644 lib/crypto/arm/blake2s-glue.c
 create mode 100644 lib/crypto/arm/blake2s.h
 rename lib/crypto/arm/{chacha-glue.c => chacha.h} (76%)
 rename {arch/arm/crypto => lib/crypto/arm}/curve25519-core.S (100%)
 create mode 100644 lib/crypto/arm/curve25519.h
 delete mode 100644 lib/crypto/arm/poly1305-glue.c
 create mode 100644 lib/crypto/arm/poly1305.h
 delete mode 100644 lib/crypto/arm64/Kconfig
 delete mode 100644 lib/crypto/arm64/Makefile
 rename lib/crypto/arm64/{chacha-neon-glue.c => chacha.h} (75%)
 delete mode 100644 lib/crypto/arm64/poly1305-glue.c
 create mode 100644 lib/crypto/arm64/poly1305.h
 delete mode 100644 lib/crypto/blake2s-generic.c
 delete mode 100644 lib/crypto/blake2s-selftest.c
 create mode 100644 lib/crypto/chacha-block-generic.c
 delete mode 100644 lib/crypto/curve25519-generic.c
 delete mode 100644 lib/crypto/libchacha.c
 create mode 100644 lib/crypto/md5.c
 delete mode 100644 lib/crypto/mips/Kconfig
 delete mode 100644 lib/crypto/mips/Makefile
 delete mode 100644 lib/crypto/mips/chacha-glue.c
 create mode 100644 lib/crypto/mips/chacha.h
 create mode 100644 lib/crypto/mips/md5.h
 delete mode 100644 lib/crypto/mips/poly1305-glue.c
 create mode 100644 lib/crypto/mips/poly1305.h
 delete mode 100644 lib/crypto/poly1305-generic.c
 delete mode 100644 lib/crypto/powerpc/Kconfig
 delete mode 100644 lib/crypto/powerpc/Makefile
 rename lib/crypto/powerpc/{chacha-p10-glue.c => chacha.h} (62%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/curve25519-ppc64le_asm.S (100%)
 rename arch/powerpc/crypto/curve25519-ppc64le-core.c => lib/crypto/powerpc/curve25519.h (56%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/md5-asm.S (100%)
 create mode 100644 lib/crypto/powerpc/md5.h
 rename lib/crypto/powerpc/{poly1305-p10-glue.c => poly1305.h} (63%)
 delete mode 100644 lib/crypto/riscv/Kconfig
 delete mode 100644 lib/crypto/riscv/Makefile
 rename lib/crypto/riscv/{chacha-riscv64-glue.c => chacha.h} (57%)
 create mode 100644 lib/crypto/riscv/poly1305-riscv.pl
 create mode 100644 lib/crypto/riscv/poly1305.h
 delete mode 100644 lib/crypto/s390/Kconfig
 delete mode 100644 lib/crypto/s390/Makefile
 rename lib/crypto/s390/{chacha-glue.c => chacha.h} (51%)
 create mode 100644 lib/crypto/sparc/md5.h
 rename {arch/sparc/crypto => lib/crypto/sparc}/md5_asm.S (100%)
 create mode 100644 lib/crypto/tests/blake2s-testvecs.h
 create mode 100644 lib/crypto/tests/blake2s_kunit.c
 rename lib/crypto/{curve25519-selftest.c => tests/curve25519_kunit.c} (96%)
 create mode 100644 lib/crypto/tests/md5-testvecs.h
 create mode 100644 lib/crypto/tests/md5_kunit.c
 delete mode 100644 lib/crypto/x86/Kconfig
 delete mode 100644 lib/crypto/x86/Makefile
 rename lib/crypto/x86/{blake2s-glue.c => blake2s.h} (83%)
 rename lib/crypto/x86/{chacha_glue.c => chacha.h} (85%)
 rename arch/x86/crypto/curve25519-x86_64.c => lib/crypto/x86/curve25519.h (94%)
 rename lib/crypto/x86/{poly1305_glue.c => poly1305.h} (83%)
