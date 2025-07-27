Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19722433A4;
	Sun, 27 Jul 2025 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753659456; cv=none; b=Vnix7S7HQE7M6/VghVHl37wD+bCmKSaLU7enwP8ZwsUEvnREKw6cvEJ3CqbDGjXQzs8R8HdDGfbt6lp1ABnbooSqXFtZ43WHwP54Ymz9KUvncYr2Roqfg0uoC5T7yBp1uxaxsNYx7c4BlQqPNAXgl5SIhBER2aaT7fuNp0axxTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753659456; c=relaxed/simple;
	bh=2ST0KHoiMIopSVcLf/8xUiVRfaPLHtvxZz3+ADztl8s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=umM36qNGn4jNSgRQtumb1JCDSEpnWe+DPVKm1iMrkTOSUDoG8FWPPh8AL3uwlF9ejt4/QWu9xC5MEWzkSW14OPRWVFuY6kRC5I/foOGIBUEPWwu/QcIoT7rGfGplap47AkmNrbWadiQS7zdGN1qeJ+Duu+yYspCp9vd3/nkDnA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvAa985M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvAa985M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF05C4CEEB;
	Sun, 27 Jul 2025 23:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753659455;
	bh=2ST0KHoiMIopSVcLf/8xUiVRfaPLHtvxZz3+ADztl8s=;
	h=Date:From:To:Cc:Subject:From;
	b=lvAa985M6Km79uXIjFDfSWBiSzNiHGpFp3ZgRnqdFGWlqBZ7b0qFAPMHjuuZhcoMS
	 1U2w0KI0bXzsJOkSffECh9c2iXgxWh7PaRexY/Nim0w2QA+6TRxTCR/abUpPMCp7w1
	 hK60wc7ZZJUT2wmdRf29KochrxiXkeIaA92IisYrwLx9mIAhX/T7pcGqh89nzVBtFk
	 bW452WunOaurOFPz4YM9YecZlrYJnPhJi9ilo11IhSzpNpYAtavbrlcK9a0zZCFEzE
	 76NjmdlMWJLWFm1OU5eg7DHNyLwRUYTn2lt2NVcM3A7C/4a0kafFgi9gu7PRI9wcUj
	 Uv1ntTy+vAOZg==
Date: Sun, 27 Jul 2025 16:36:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [GIT PULL] CRC updates for 6.17
Message-ID: <20250727233644.GA1261@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af:

  Linux 6.16-rc4 (2025-06-29 13:09:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 118da22eb6fbd48f896d17411f942399283d600c:

  lib/crc: x86/crc32c: Enable VPCLMULQDQ optimization where beneficial (2025-07-20 20:52:34 -0700)

----------------------------------------------------------------

Updates for the kernel's CRC (cyclic redundancy check) code:

 - Reorganize the architecture-optimized CRC code. It now lives in
   lib/crc/$(SRCARCH)/ rather than arch/$(SRCARCH)/lib/, and it is no
   longer artificially split into separate generic and arch modules.
   This allows better inlining and dead code elimination. The generic
   CRC code is also no longer exported, simplifying the API. (This
   mirrors the similar changes to SHA-1 and SHA-2 in lib/crypto/,
   which can be found in the "Crypto library updates" pull request.)

 - Improve crc32c() performance on newer x86_64 CPUs on long messages
   by enabling the VPCLMULQDQ optimized code.

 - Simplify the crypto_shash wrappers for crc32_le() and crc32c().
   Register just one shash algorithm for each that uses the (fully
   optimized) library functions, instead of unnecessarily providing
   direct access to the generic CRC code.

 - Remove unused and obsolete drivers for hardware CRC engines.

 - Remove CRC-32 combination functions that are no longer used.

 - Add kerneldoc for crc32_le(), crc32_be(), and crc32c().

 - Convert the crc32() macro to an inline function.

----------------------------------------------------------------
Eric Biggers (26):
      x86/crc: drop checks of CONFIG_AS_VPCLMULQDQ
      crypto: testmgr - remove crc32c context format test
      crypto: inside-secure - remove crc32 support
      crypto: stm32 - remove crc32 and crc32c support
      btrfs: stop parsing crc32c driver name
      crypto/crc32[c]: register only "-lib" drivers
      lib/crc32: Remove unused combination support
      lib/crc: Move files into lib/crc/
      lib/crc: Prepare for arch-optimized code in subdirs of lib/crc/
      lib/crc: arm: Migrate optimized CRC code into lib/crc/
      lib/crc: arm64: Migrate optimized CRC code into lib/crc/
      lib/crc: loongarch: Migrate optimized CRC code into lib/crc/
      lib/crc: mips: Migrate optimized CRC code into lib/crc/
      lib/crc: powerpc: Migrate optimized CRC code into lib/crc/
      lib/crc: riscv: Migrate optimized CRC code into lib/crc/
      lib/crc: s390: Migrate optimized CRC code into lib/crc/
      lib/crc: sparc: Migrate optimized CRC code into lib/crc/
      lib/crc: x86: Migrate optimized CRC code into lib/crc/
      lib/crc: Remove ARCH_HAS_* kconfig symbols
      lib/crc: Explicitly include <linux/export.h>
      lib/crc: crc32: Document crc32_le(), crc32_be(), and crc32c()
      nvmem: layouts: Switch from crc32() to crc32_le()
      lib/crc: crc32: Change crc32() from macro to inline function and remove cast
      lib/crc: crc64: Add include/linux/crc64.h to kernel-api.rst
      lib/crc: x86: Reorganize crc-pclmul static_call initialization
      lib/crc: x86/crc32c: Enable VPCLMULQDQ optimization where beneficial

 Documentation/core-api/kernel-api.rst              |  18 +-
 MAINTAINERS                                        |   4 +-
 arch/arm/Kconfig                                   |   2 -
 arch/arm/configs/multi_v7_defconfig                |   1 -
 arch/arm/lib/Makefile                              |   6 -
 arch/arm64/Kconfig                                 |   2 -
 arch/arm64/lib/Makefile                            |   6 -
 arch/loongarch/Kconfig                             |   1 -
 arch/loongarch/lib/Makefile                        |   2 -
 arch/mips/Kconfig                                  |   1 -
 arch/mips/lib/Makefile                             |   2 -
 arch/powerpc/Kconfig                               |   2 -
 arch/powerpc/lib/Makefile                          |   6 -
 arch/riscv/Kconfig                                 |   3 -
 arch/riscv/lib/Makefile                            |   6 -
 arch/s390/Kconfig                                  |   1 -
 arch/s390/lib/Makefile                             |   3 -
 arch/sparc/Kconfig                                 |   1 -
 arch/sparc/lib/Makefile                            |   2 -
 arch/x86/Kconfig                                   |   3 -
 arch/x86/lib/Makefile                              |  10 -
 arch/x86/lib/crc32.c                               | 111 -----
 crypto/Makefile                                    |   2 -
 crypto/crc32.c                                     |  65 +--
 crypto/crc32c.c                                    |  66 +--
 crypto/testmgr.c                                   |  57 +--
 drivers/crypto/inside-secure/safexcel.c            |   1 -
 drivers/crypto/inside-secure/safexcel.h            |   1 -
 drivers/crypto/inside-secure/safexcel_hash.c       |  92 +---
 drivers/crypto/stm32/Kconfig                       |   9 -
 drivers/crypto/stm32/Makefile                      |   1 -
 drivers/crypto/stm32/stm32-crc32.c                 | 480 ---------------------
 drivers/nvmem/layouts/u-boot-env.c                 |   2 +-
 fs/btrfs/disk-io.c                                 |   8 +-
 include/linux/crc-t10dif.h                         |  10 +-
 include/linux/crc32.h                              | 119 ++---
 include/linux/crc32poly.h                          |  16 +-
 include/linux/crc64.h                              |  22 +-
 lib/Kconfig                                        |  88 +---
 lib/Kconfig.debug                                  |  21 -
 lib/Makefile                                       |  32 +-
 lib/crc/.gitignore                                 |   5 +
 lib/crc/Kconfig                                    | 119 +++++
 lib/crc/Makefile                                   |  63 +++
 {arch/arm/lib => lib/crc/arm}/crc-t10dif-core.S    |   0
 .../lib/crc-t10dif.c => lib/crc/arm/crc-t10dif.h   |  23 +-
 {arch/arm/lib => lib/crc/arm}/crc32-core.S         |   0
 arch/arm/lib/crc32.c => lib/crc/arm/crc32.h        |  38 +-
 .../arm64/lib => lib/crc/arm64}/crc-t10dif-core.S  |   0
 .../lib/crc-t10dif.c => lib/crc/arm64/crc-t10dif.h |  22 +-
 {arch/arm64/lib => lib/crc/arm64}/crc32-core.S     |   0
 arch/arm64/lib/crc32.c => lib/crc/arm64/crc32.h    |  19 +-
 lib/{ => crc}/crc-ccitt.c                          |   8 +-
 lib/{ => crc}/crc-itu-t.c                          |   5 +-
 lib/{crc-t10dif.c => crc/crc-t10dif-main.c}        |  42 +-
 lib/{ => crc}/crc16.c                              |   5 +-
 lib/crc/crc32-main.c                               | 105 +++++
 lib/{ => crc}/crc4.c                               |   1 +
 lib/{crc64.c => crc/crc64-main.c}                  |  51 ++-
 lib/{ => crc}/crc7.c                               |   5 +-
 lib/{ => crc}/crc8.c                               |   3 +-
 lib/{ => crc}/gen_crc32table.c                     |   4 +-
 lib/{ => crc}/gen_crc64table.c                     |  11 +-
 .../crc32-loongarch.c => lib/crc/loongarch/crc32.h |  33 +-
 arch/mips/lib/crc32-mips.c => lib/crc/mips/crc32.h |  33 +-
 .../crc-t10dif.c => lib/crc/powerpc/crc-t10dif.h   |  20 +-
 .../lib => lib/crc/powerpc}/crc-vpmsum-template.S  |   0
 .../powerpc/lib/crc32.c => lib/crc/powerpc/crc32.h |  38 +-
 .../lib => lib/crc/powerpc}/crc32c-vpmsum_asm.S    |   0
 .../lib => lib/crc/powerpc}/crct10dif-vpmsum_asm.S |   0
 .../riscv/lib => lib/crc/riscv}/crc-clmul-consts.h |   0
 .../lib => lib/crc/riscv}/crc-clmul-template.h     |   0
 {arch/riscv/lib => lib/crc/riscv}/crc-clmul.h      |   0
 .../lib/crc-t10dif.c => lib/crc/riscv/crc-t10dif.h |   8 +-
 {arch/riscv/lib => lib/crc/riscv}/crc16_msb.c      |   0
 arch/riscv/lib/crc32.c => lib/crc/riscv/crc32.h    |  17 +-
 {arch/riscv/lib => lib/crc/riscv}/crc32_lsb.c      |   0
 {arch/riscv/lib => lib/crc/riscv}/crc32_msb.c      |   0
 arch/riscv/lib/crc64.c => lib/crc/riscv/crc64.h    |  11 +-
 {arch/riscv/lib => lib/crc/riscv}/crc64_lsb.c      |   0
 {arch/riscv/lib => lib/crc/riscv}/crc64_msb.c      |   0
 {arch/s390/lib => lib/crc/s390}/crc32-vx.h         |   0
 arch/s390/lib/crc32.c => lib/crc/s390/crc32.h      |  16 +-
 {arch/s390/lib => lib/crc/s390}/crc32be-vx.c       |   0
 {arch/s390/lib => lib/crc/s390}/crc32le-vx.c       |   0
 arch/sparc/lib/crc32.c => lib/crc/sparc/crc32.h    |  42 +-
 {arch/sparc/lib => lib/crc/sparc}/crc32c_asm.S     |   0
 lib/crc/tests/Makefile                             |   2 +
 lib/{ => crc}/tests/crc_kunit.c                    |  39 +-
 {arch/x86/lib => lib/crc/x86}/crc-pclmul-consts.h  |  47 +-
 .../x86/lib => lib/crc/x86}/crc-pclmul-template.S  |   7 -
 .../x86/lib => lib/crc/x86}/crc-pclmul-template.h  |  32 +-
 .../lib/crc-t10dif.c => lib/crc/x86/crc-t10dif.h   |  27 +-
 {arch/x86/lib => lib/crc/x86}/crc16-msb-pclmul.S   |   0
 {arch/x86/lib => lib/crc/x86}/crc32-pclmul.S       |   0
 lib/crc/x86/crc32.h                                | 137 ++++++
 {arch/x86/lib => lib/crc/x86}/crc32c-3way.S        |   0
 {arch/x86/lib => lib/crc/x86}/crc64-pclmul.S       |   0
 arch/x86/lib/crc64.c => lib/crc/x86/crc64.h        |  36 +-
 lib/crc32.c                                        | 126 ------
 lib/tests/Makefile                                 |   1 -
 101 files changed, 783 insertions(+), 1703 deletions(-)
 delete mode 100644 arch/x86/lib/crc32.c
 delete mode 100644 drivers/crypto/stm32/stm32-crc32.c
 create mode 100644 lib/crc/.gitignore
 create mode 100644 lib/crc/Kconfig
 create mode 100644 lib/crc/Makefile
 rename {arch/arm/lib => lib/crc/arm}/crc-t10dif-core.S (100%)
 rename arch/arm/lib/crc-t10dif.c => lib/crc/arm/crc-t10dif.h (70%)
 rename {arch/arm/lib => lib/crc/arm}/crc32-core.S (100%)
 rename arch/arm/lib/crc32.c => lib/crc/arm/crc32.h (69%)
 rename {arch/arm64/lib => lib/crc/arm64}/crc-t10dif-core.S (100%)
 rename arch/arm64/lib/crc-t10dif.c => lib/crc/arm64/crc-t10dif.h (70%)
 rename {arch/arm64/lib => lib/crc/arm64}/crc32-core.S (100%)
 rename arch/arm64/lib/crc32.c => lib/crc/arm64/crc32.h (81%)
 rename lib/{ => crc}/crc-ccitt.c (98%)
 rename lib/{ => crc}/crc-itu-t.c (99%)
 rename lib/{crc-t10dif.c => crc/crc-t10dif-main.c} (77%)
 rename lib/{ => crc}/crc16.c (99%)
 create mode 100644 lib/crc/crc32-main.c
 rename lib/{ => crc}/crc4.c (97%)
 rename lib/{crc64.c => crc/crc64-main.c} (66%)
 rename lib/{ => crc}/crc7.c (98%)
 rename lib/{ => crc}/crc8.c (98%)
 rename lib/{ => crc}/gen_crc32table.c (95%)
 rename lib/{ => crc}/gen_crc64table.c (81%)
 rename arch/loongarch/lib/crc32-loongarch.c => lib/crc/loongarch/crc32.h (71%)
 rename arch/mips/lib/crc32-mips.c => lib/crc/mips/crc32.h (82%)
 rename arch/powerpc/lib/crc-t10dif.c => lib/crc/powerpc/crc-t10dif.h (75%)
 rename {arch/powerpc/lib => lib/crc/powerpc}/crc-vpmsum-template.S (100%)
 rename arch/powerpc/lib/crc32.c => lib/crc/powerpc/crc32.h (64%)
 rename {arch/powerpc/lib => lib/crc/powerpc}/crc32c-vpmsum_asm.S (100%)
 rename {arch/powerpc/lib => lib/crc/powerpc}/crct10dif-vpmsum_asm.S (100%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc-clmul-consts.h (100%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc-clmul-template.h (100%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc-clmul.h (100%)
 rename arch/riscv/lib/crc-t10dif.c => lib/crc/riscv/crc-t10dif.h (62%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc16_msb.c (100%)
 rename arch/riscv/lib/crc32.c => lib/crc/riscv/crc32.h (66%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc32_lsb.c (100%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc32_msb.c (100%)
 rename arch/riscv/lib/crc64.c => lib/crc/riscv/crc64.h (65%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc64_lsb.c (100%)
 rename {arch/riscv/lib => lib/crc/riscv}/crc64_msb.c (100%)
 rename {arch/s390/lib => lib/crc/s390}/crc32-vx.h (100%)
 rename arch/s390/lib/crc32.c => lib/crc/s390/crc32.h (81%)
 rename {arch/s390/lib => lib/crc/s390}/crc32be-vx.c (100%)
 rename {arch/s390/lib => lib/crc/s390}/crc32le-vx.c (100%)
 rename arch/sparc/lib/crc32.c => lib/crc/sparc/crc32.h (60%)
 rename {arch/sparc/lib => lib/crc/sparc}/crc32c_asm.S (100%)
 create mode 100644 lib/crc/tests/Makefile
 rename lib/{ => crc}/tests/crc_kunit.c (89%)
 rename {arch/x86/lib => lib/crc/x86}/crc-pclmul-consts.h (80%)
 rename {arch/x86/lib => lib/crc/x86}/crc-pclmul-template.S (98%)
 rename {arch/x86/lib => lib/crc/x86}/crc-pclmul-template.h (77%)
 rename arch/x86/lib/crc-t10dif.c => lib/crc/x86/crc-t10dif.h (52%)
 rename {arch/x86/lib => lib/crc/x86}/crc16-msb-pclmul.S (100%)
 rename {arch/x86/lib => lib/crc/x86}/crc32-pclmul.S (100%)
 create mode 100644 lib/crc/x86/crc32.h
 rename {arch/x86/lib => lib/crc/x86}/crc32c-3way.S (100%)
 rename {arch/x86/lib => lib/crc/x86}/crc64-pclmul.S (100%)
 rename arch/x86/lib/crc64.c => lib/crc/x86/crc64.h (53%)
 delete mode 100644 lib/crc32.c
