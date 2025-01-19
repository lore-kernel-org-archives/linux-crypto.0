Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4A1DF757;
	Sun, 19 Jan 2025 22:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737327081; cv=none; b=lXKdfm5jdLTCvHOd9YI9Z3pSQWC9wZVv4IvRC5KEbSGXjf4udbEiB82HMpEbj29O0V1nicKCG9m2yR1D4XXvjcqtjGcwGcIyiRPkQzkaWBkKRLgP0Fbo+lDo+e3SVVgiH4lFhqxejVcZsNO8GnBpNqaOs1puLpLghHY0A9Yqh0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737327081; c=relaxed/simple;
	bh=2NaET63xr/bt/1JuCqLuBQ6lSVyMfqwG5qvSceEdbcs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gXRe5AjLD6VUZD8WCgV7WvP79HMEti1Alb85pk+Z9TAy64uC6tl0HLLaMIo//sj2XTh2rnzDmp6woqjB92pNY/Y8j77qkC0k3ul2DVs7bqUpTUbjSAjfrI5pn/lDsPRqWHKgBT2/oTe/fZmky1nMF1y50IQtafDGHFHftF9OO28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+laOYwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+laOYwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C1AC4CED6;
	Sun, 19 Jan 2025 22:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737327080;
	bh=2NaET63xr/bt/1JuCqLuBQ6lSVyMfqwG5qvSceEdbcs=;
	h=Date:From:To:Cc:Subject:From;
	b=D+laOYwGeZEuqV9Wd91uApdZuxjjla46v+tO7K+ffTmqRzNxyPM7h2dTPqI4dsip1
	 PCMcfnpXFSRco87e7LUT2TIFKnszEeFQnvFLMB/KCMlCA9oKqGVA1UFSYi6P9FCOv7
	 iKU/rUaL9q9xhzudoSIjWgGh4dCApZO0x3cq/EVKSKZAt0CUdzGufs5trBFWPv9ihN
	 IU+kD9lLPNqgu14Ep0LYt8r8tNX76ZAkdxHowwmqBb+CCWPQpmhBuV2R8/CLKAPFew
	 YKt2uccQ1v0MNHbYnR+TYPPMJm5rbwbCwsyBFLTOkuXkwRp3jk6aBSXJVc/2MpHGRc
	 hisWFJVWcvIUA==
Date: Sun, 19 Jan 2025 14:51:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: [GIT PULL] CRC updates for 6.14
Message-ID: <20250119225118.GA15398@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 72914faebaabd77d8a471af4662ca0b938011c49:

  MAINTAINERS: add entry for CRC library (2024-12-09 22:09:44 -0800)

----------------------------------------------------------------

- Reorganize the architecture-optimized CRC32 and CRC-T10DIF code to be
  directly accessible via the library API, instead of requiring the
  crypto API.  This is much simpler and more efficient.

- Convert some users such as ext4 to use the CRC32 library API instead
  of the crypto API.  More conversions like this will come later.

- Add a KUnit test that tests and benchmarks multiple CRC variants.
  Remove older, less-comprehensive tests that are made redundant by
  this.

- Add an entry to MAINTAINERS for the kernel's CRC library code.  I'm
  volunteering to maintain it.  I have additional cleanups and
  optimizations planned for future cycles.

These patches have been in linux-next since -rc1.

----------------------------------------------------------------
Eric Biggers (31):
      lib/crc32: drop leading underscores from __crc32c_le_base
      lib/crc32: improve support for arch-specific overrides
      lib/crc32: expose whether the lib is really optimized at runtime
      crypto: crc32 - don't unnecessarily register arch algorithms
      arm/crc32: expose CRC32 functions through lib
      loongarch/crc32: expose CRC32 functions through lib
      mips/crc32: expose CRC32 functions through lib
      powerpc/crc32: expose CRC32 functions through lib
      s390/crc32: expose CRC32 functions through lib
      sparc/crc32: expose CRC32 functions through lib
      x86/crc32: update prototype for crc_pcl()
      x86/crc32: update prototype for crc32_pclmul_le_16()
      x86/crc32: expose CRC32 functions through lib
      bcachefs: Explicitly select CRYPTO from BCACHEFS_FS
      lib/crc32: make crc32c() go directly to lib
      ext4: switch to using the crc32c library
      jbd2: switch to using the crc32c library
      f2fs: switch to using the crc32 library
      scsi: target: iscsi: switch to using the crc32c library
      lib/crc-t10dif: stop wrapping the crypto API
      lib/crc-t10dif: add support for arch overrides
      crypto: crct10dif - expose arch-optimized lib function
      x86/crc-t10dif: expose CRC-T10DIF function through lib
      arm/crc-t10dif: expose CRC-T10DIF function through lib
      arm64/crc-t10dif: expose CRC-T10DIF function through lib
      powerpc/crc-t10dif: expose CRC-T10DIF function through lib
      lib/crc_kunit.c: add KUnit test suite for CRC library functions
      lib/crc16_kunit: delete obsolete crc16_kunit.c
      lib/crc32test: delete obsolete crc32test.c
      powerpc/crc: delete obsolete crc-vpmsum_test.c
      MAINTAINERS: add entry for CRC library

 MAINTAINERS                                        |  11 +
 arch/arm/Kconfig                                   |   2 +
 arch/arm/configs/milbeaut_m10v_defconfig           |   1 -
 arch/arm/configs/multi_v7_defconfig                |   1 -
 arch/arm/crypto/Kconfig                            |  25 -
 arch/arm/crypto/Makefile                           |   4 -
 arch/arm/crypto/crc32-ce-glue.c                    | 247 ------
 arch/arm/crypto/crct10dif-ce-glue.c                | 124 ---
 arch/arm/lib/Makefile                              |   6 +
 .../crct10dif-ce-core.S => lib/crc-t10dif-core.S}  |   0
 arch/arm/lib/crc-t10dif-glue.c                     |  80 ++
 .../{crypto/crc32-ce-core.S => lib/crc32-core.S}   |   5 +-
 arch/arm/lib/crc32-glue.c                          | 123 +++
 arch/arm64/Kconfig                                 |   2 +
 arch/arm64/configs/defconfig                       |   1 -
 arch/arm64/crypto/Kconfig                          |  10 -
 arch/arm64/crypto/Makefile                         |   3 -
 arch/arm64/crypto/crct10dif-ce-glue.c              | 132 ----
 arch/arm64/lib/Makefile                            |   6 +-
 .../crct10dif-ce-core.S => lib/crc-t10dif-core.S}  |   0
 arch/arm64/lib/crc-t10dif-glue.c                   |  81 ++
 arch/arm64/lib/crc32-glue.c                        |  25 +-
 arch/loongarch/Kconfig                             |   1 +
 arch/loongarch/configs/loongson3_defconfig         |   1 -
 arch/loongarch/crypto/Kconfig                      |   9 -
 arch/loongarch/crypto/Makefile                     |   2 -
 arch/loongarch/crypto/crc32-loongarch.c            | 300 --------
 arch/loongarch/lib/Makefile                        |   2 +
 arch/loongarch/lib/crc32-loongarch.c               | 135 ++++
 arch/m68k/configs/amiga_defconfig                  |   1 -
 arch/m68k/configs/apollo_defconfig                 |   1 -
 arch/m68k/configs/atari_defconfig                  |   1 -
 arch/m68k/configs/bvme6000_defconfig               |   1 -
 arch/m68k/configs/hp300_defconfig                  |   1 -
 arch/m68k/configs/mac_defconfig                    |   1 -
 arch/m68k/configs/multi_defconfig                  |   1 -
 arch/m68k/configs/mvme147_defconfig                |   1 -
 arch/m68k/configs/mvme16x_defconfig                |   1 -
 arch/m68k/configs/q40_defconfig                    |   1 -
 arch/m68k/configs/sun3_defconfig                   |   1 -
 arch/m68k/configs/sun3x_defconfig                  |   1 -
 arch/mips/Kconfig                                  |   5 +-
 arch/mips/configs/eyeq5_defconfig                  |   1 -
 arch/mips/configs/eyeq6_defconfig                  |   1 -
 arch/mips/configs/generic/32r6.config              |   2 -
 arch/mips/configs/generic/64r6.config              |   1 -
 arch/mips/crypto/Kconfig                           |   9 -
 arch/mips/crypto/Makefile                          |   2 -
 arch/mips/crypto/crc32-mips.c                      | 354 ---------
 arch/mips/lib/Makefile                             |   2 +
 arch/mips/lib/crc32-mips.c                         | 192 +++++
 arch/powerpc/Kconfig                               |   2 +
 arch/powerpc/configs/powernv_defconfig             |   2 -
 arch/powerpc/configs/ppc64_defconfig               |   3 -
 arch/powerpc/crypto/Kconfig                        |  33 -
 arch/powerpc/crypto/Makefile                       |   5 -
 arch/powerpc/crypto/crc-vpmsum_test.c              | 133 ----
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           | 173 -----
 arch/powerpc/lib/Makefile                          |   6 +
 .../crc-t10dif-glue.c}                             |  69 +-
 arch/powerpc/lib/crc32-glue.c                      |  92 +++
 arch/powerpc/{crypto => lib}/crc32-vpmsum_core.S   |   0
 arch/powerpc/{crypto => lib}/crc32c-vpmsum_asm.S   |   0
 .../powerpc/{crypto => lib}/crct10dif-vpmsum_asm.S |   0
 arch/riscv/Kconfig                                 |   1 +
 arch/riscv/lib/Makefile                            |   3 +-
 arch/riscv/lib/{crc32.c => crc32-riscv.c}          |  25 +-
 arch/s390/Kconfig                                  |   1 +
 arch/s390/configs/debug_defconfig                  |   2 -
 arch/s390/configs/defconfig                        |   1 -
 arch/s390/crypto/Kconfig                           |  12 -
 arch/s390/crypto/Makefile                          |   2 -
 arch/s390/crypto/crc32-vx.c                        | 306 --------
 arch/s390/lib/Makefile                             |   3 +
 arch/s390/lib/crc32-glue.c                         |  92 +++
 arch/s390/{crypto => lib}/crc32-vx.h               |   0
 arch/s390/{crypto => lib}/crc32be-vx.c             |   0
 arch/s390/{crypto => lib}/crc32le-vx.c             |   0
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/crypto/Kconfig                          |  10 -
 arch/sparc/crypto/Makefile                         |   4 -
 arch/sparc/crypto/crc32c_glue.c                    | 184 -----
 arch/sparc/lib/Makefile                            |   2 +
 arch/sparc/lib/crc32_glue.c                        |  93 +++
 arch/sparc/{crypto => lib}/crc32c_asm.S            |   2 +-
 arch/x86/Kconfig                                   |   2 +
 arch/x86/crypto/Kconfig                            |  32 -
 arch/x86/crypto/Makefile                           |  10 -
 arch/x86/crypto/crc32-pclmul_glue.c                | 202 -----
 arch/x86/crypto/crc32c-intel_glue.c                | 250 ------
 arch/x86/crypto/crct10dif-pclmul_glue.c            | 143 ----
 arch/x86/lib/Makefile                              |   7 +
 arch/x86/lib/crc-t10dif-glue.c                     |  51 ++
 arch/x86/lib/crc32-glue.c                          | 124 +++
 .../crc32-pclmul_asm.S => lib/crc32-pclmul.S}      |  19 +-
 .../crc32c-3way.S}                                 |  63 +-
 arch/x86/{crypto => lib}/crct10dif-pcl-asm_64.S    |   0
 crypto/Kconfig                                     |   1 +
 crypto/Makefile                                    |   3 +-
 crypto/crc32_generic.c                             |   8 +-
 crypto/crc32c_generic.c                            |  12 +-
 crypto/crct10dif_common.c                          |  82 --
 crypto/crct10dif_generic.c                         |  82 +-
 drivers/target/iscsi/Kconfig                       |   4 +-
 drivers/target/iscsi/iscsi_target.c                | 153 ++--
 drivers/target/iscsi/iscsi_target_login.c          |  50 --
 drivers/target/iscsi/iscsi_target_login.h          |   1 -
 drivers/target/iscsi/iscsi_target_nego.c           |  21 +-
 fs/bcachefs/Kconfig                                |   1 +
 fs/ext4/Kconfig                                    |   3 +-
 fs/ext4/ext4.h                                     |  25 +-
 fs/ext4/super.c                                    |  15 -
 fs/f2fs/Kconfig                                    |   3 +-
 fs/f2fs/f2fs.h                                     |  20 +-
 fs/f2fs/super.c                                    |  15 -
 fs/jbd2/Kconfig                                    |   2 -
 fs/jbd2/journal.c                                  |  30 +-
 include/linux/crc-t10dif.h                         |  28 +-
 include/linux/crc32.h                              |  50 +-
 include/linux/crc32c.h                             |   7 +-
 include/linux/jbd2.h                               |  33 +-
 include/target/iscsi/iscsi_target_core.h           |   3 -
 lib/Kconfig                                        | 121 ++-
 lib/Kconfig.debug                                  |  29 +-
 lib/Makefile                                       |   4 +-
 lib/crc-t10dif.c                                   | 156 ++--
 lib/crc16_kunit.c                                  | 155 ----
 lib/crc32.c                                        |  24 +-
 lib/crc32test.c                                    | 852 ---------------------
 lib/crc_kunit.c                                    | 435 +++++++++++
 lib/libcrc32c.c                                    |  74 --
 tools/testing/selftests/arm64/fp/kernel-test.c     |   3 +-
 132 files changed, 2035 insertions(+), 4555 deletions(-)
 delete mode 100644 arch/arm/crypto/crc32-ce-glue.c
 delete mode 100644 arch/arm/crypto/crct10dif-ce-glue.c
 rename arch/arm/{crypto/crct10dif-ce-core.S => lib/crc-t10dif-core.S} (100%)
 create mode 100644 arch/arm/lib/crc-t10dif-glue.c
 rename arch/arm/{crypto/crc32-ce-core.S => lib/crc32-core.S} (98%)
 create mode 100644 arch/arm/lib/crc32-glue.c
 delete mode 100644 arch/arm64/crypto/crct10dif-ce-glue.c
 rename arch/arm64/{crypto/crct10dif-ce-core.S => lib/crc-t10dif-core.S} (100%)
 create mode 100644 arch/arm64/lib/crc-t10dif-glue.c
 delete mode 100644 arch/loongarch/crypto/crc32-loongarch.c
 create mode 100644 arch/loongarch/lib/crc32-loongarch.c
 delete mode 100644 arch/mips/crypto/crc32-mips.c
 create mode 100644 arch/mips/lib/crc32-mips.c
 delete mode 100644 arch/powerpc/crypto/crc-vpmsum_test.c
 delete mode 100644 arch/powerpc/crypto/crc32c-vpmsum_glue.c
 rename arch/powerpc/{crypto/crct10dif-vpmsum_glue.c => lib/crc-t10dif-glue.c} (50%)
 create mode 100644 arch/powerpc/lib/crc32-glue.c
 rename arch/powerpc/{crypto => lib}/crc32-vpmsum_core.S (100%)
 rename arch/powerpc/{crypto => lib}/crc32c-vpmsum_asm.S (100%)
 rename arch/powerpc/{crypto => lib}/crct10dif-vpmsum_asm.S (100%)
 rename arch/riscv/lib/{crc32.c => crc32-riscv.c} (91%)
 delete mode 100644 arch/s390/crypto/crc32-vx.c
 create mode 100644 arch/s390/lib/crc32-glue.c
 rename arch/s390/{crypto => lib}/crc32-vx.h (100%)
 rename arch/s390/{crypto => lib}/crc32be-vx.c (100%)
 rename arch/s390/{crypto => lib}/crc32le-vx.c (100%)
 delete mode 100644 arch/sparc/crypto/crc32c_glue.c
 create mode 100644 arch/sparc/lib/crc32_glue.c
 rename arch/sparc/{crypto => lib}/crc32c_asm.S (92%)
 delete mode 100644 arch/x86/crypto/crc32-pclmul_glue.c
 delete mode 100644 arch/x86/crypto/crc32c-intel_glue.c
 delete mode 100644 arch/x86/crypto/crct10dif-pclmul_glue.c
 create mode 100644 arch/x86/lib/crc-t10dif-glue.c
 create mode 100644 arch/x86/lib/crc32-glue.c
 rename arch/x86/{crypto/crc32-pclmul_asm.S => lib/crc32-pclmul.S} (95%)
 rename arch/x86/{crypto/crc32c-pcl-intel-asm_64.S => lib/crc32c-3way.S} (92%)
 rename arch/x86/{crypto => lib}/crct10dif-pcl-asm_64.S (100%)
 delete mode 100644 crypto/crct10dif_common.c
 delete mode 100644 lib/crc16_kunit.c
 delete mode 100644 lib/crc32test.c
 create mode 100644 lib/crc_kunit.c
 delete mode 100644 lib/libcrc32c.c
