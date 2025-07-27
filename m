Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8A2264D2;
	Sun, 27 Jul 2025 23:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753659877; cv=none; b=NYRfdKfAO3LZ8TPiBPo1DysvfptWkBmTgZEQhPM+7jbNPZdR8QClsPGWte8Kv88oi+MmgvppgeJthpz053nkVC+rdkAV+AInYLATsJrSgflMhSNhF1jJB9cvZSwrYBGGG+FT6CL5j5zBUns/0ADdMWm5v8kMqKc6ckuolkPfZxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753659877; c=relaxed/simple;
	bh=RYzLDMZUfHaqZpLtoR7GQ9tdWzEy/IvdcGg+awEe8qg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fK92P3DM3IYY+FWI9hGaxmb2LeOxeLPmL5wPC6Il1K1kSaqn+CopDVof1W7kb4+g1brs9lpb8M0AXLnF7O1rIdGmITLhIj98s8Lz+lwoeuM41iO23k9DLNLEQOm4QN3zv7udOzN0YLL11n9HomS9g4l0Ol4Y8lO1i5p3gO1d3FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWFbL493; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWFbL493"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E61C4CEEB;
	Sun, 27 Jul 2025 23:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753659877;
	bh=RYzLDMZUfHaqZpLtoR7GQ9tdWzEy/IvdcGg+awEe8qg=;
	h=Date:From:To:Cc:Subject:From;
	b=VWFbL493FkC2wRYA31PLo0dteuDoJzKNAOWcbtBzTFWaUo9befVJM/34+v7BeiOic
	 kfdgWy45Pd6KNjTwL5lc618nnNNe4V8NAlYYarXwkS2v6/yh9iEuwWcaacc1Cb/YJw
	 w19hxIx6Y2LS7JT8jgGMb1ew8BVGEXnJ/+WTIV+wvkdneax1zsenBr+vQ0/uvEeLbr
	 BtdJlVwDeH+uZMePHe4AQ3JEBWkyfnlhqTwX8+dBGG+vHVAYyl8GP2HM6pmSTh6MzP
	 3aQUD8JBn2LbIg65yNc9uDWJo1ZkgLc36TLAwpbBmCTrqTNrSoqovWe9TUCAQlmfl0
	 NUmYbvZ5N11Iw==
Date: Sun, 27 Jul 2025 16:43:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [GIT PULL] Crypto library updates for 6.17
Message-ID: <20250727234345.GB1261@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Note: there are conflicts with some files in arch/s390/:
arch/s390/crypto/sha1_s390.c and arch/s390/crypto/sha512_s390.c from
mainline, and arch/s390/lib/crypto/sha256.c from the s390 tree.  Just
take the version from this pull request, i.e. delete those files.

The following changes since commit d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af:

  Linux 6.16-rc4 (2025-06-29 13:09:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

for you to fetch changes up to debc1e5a431779c027a5752f247a4de2e4f702b2:

  lib/crypto: arm64/sha512-ce: Drop compatibility macros for older binutils (2025-07-20 21:43:27 -0700)

----------------------------------------------------------------

This is the main crypto library pull request for 6.17. The main focus
this cycle is on reorganizing the SHA-1 and SHA-2 code, providing
high-quality library APIs for SHA-1 and SHA-2 including HMAC support,
and establishing conventions for lib/crypto/ going forward:

 - Migrate the SHA-1 and SHA-512 code (and also SHA-384 which shares
   most of the SHA-512 code) into lib/crypto/. This includes both the
   generic and architecture-optimized code. Greatly simplify how the
   architecture-optimized code is integrated. Add an easy-to-use
   library API for each SHA variant, including HMAC support. Finally,
   reimplement the crypto_shash support on top of the library API.

 - Apply the same reorganization to the SHA-256 code (and also SHA-224
   which shares most of the SHA-256 code). This is a somewhat smaller
   change, due to my earlier work on SHA-256. But this brings in all
   the same additional improvements that I made for SHA-1 and SHA-512.

There are also some smaller changes:

 - Move the architecture-optimized ChaCha, Poly1305, and BLAKE2s code
   from arch/$(SRCARCH)/lib/crypto/ to lib/crypto/$(SRCARCH)/. For
   these algorithms it's just a move, not a full reorganization yet.

 - Fix the MIPS chacha-core.S to build with the clang assembler.

 - Fix the Poly1305 functions to work in all contexts.

 - Fix a performance regression in the x86_64 Poly1305 code.

 - Clean up the x86_64 SHA-NI optimized SHA-1 assembly code.

Note that since the new organization of the SHA code is much simpler,
the diffstat of this pull request is negative, despite the addition of
new fully-documented library APIs for multiple SHA and HMAC-SHA
variants. These APIs will allow further simplifications across the
kernel as users start using them instead of the old-school crypto API.
(I've already written a lot of such conversion patches, removing over
1000 more lines of code. But most of those will target 6.18 or later.)

----------------------------------------------------------------
Eric Biggers (67):
      lib/crypto: Explicitly include <linux/export.h>
      crypto: sha512 - Rename conflicting symbols
      lib/crypto: sha512: Add support for SHA-384 and SHA-512
      lib/crypto: sha512: Add HMAC-SHA384 and HMAC-SHA512 support
      crypto: riscv/sha512 - Stop depending on sha512_generic_block_fn
      crypto: sha512 - Replace sha512_generic with wrapper around SHA-512 library
      crypto: sha512 - Use same state format as legacy drivers
      lib/crypto: arm/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: arm64/sha512: Migrate optimized SHA-512 code to library
      mips: cavium-octeon: Move octeon-crypto.h into asm directory
      lib/crypto: mips/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: riscv/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: s390/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: sparc/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: x86/sha512: Migrate optimized SHA-512 code to library
      lib/crypto: x86/sha512: Remove unnecessary checks for nblocks==0
      crypto: sha512 - Remove sha512_base.h
      lib/crypto: arm: Move arch/arm/lib/crypto/ into lib/crypto/
      lib/crypto: arm64: Move arch/arm64/lib/crypto/ into lib/crypto/
      lib/crypto: mips: Move arch/mips/lib/crypto/ into lib/crypto/
      lib/crypto: powerpc: Move arch/powerpc/lib/crypto/ into lib/crypto/
      lib/crypto: riscv: Move arch/riscv/lib/crypto/ into lib/crypto/
      lib/crypto: s390: Move arch/s390/lib/crypto/ into lib/crypto/
      lib/crypto: sparc: Move arch/sparc/lib/crypto/ into lib/crypto/
      lib/crypto: x86: Move arch/x86/lib/crypto/ into lib/crypto/
      MAINTAINERS: Drop arch/*/lib/crypto/ pattern
      lib/crypto: mips/chacha: Fix clang build and remove unneeded byteswap
      libceph: Rename hmac_sha256() to ceph_hmac_sha256()
      cxl/test: Simplify fw_buf_checksum_show()
      lib/crypto: sha256: Reorder some code
      lib/crypto: sha256: Remove sha256_blocks_simd()
      lib/crypto: sha256: Add sha224() and sha224_update()
      lib/crypto: sha256: Make library API use strongly-typed contexts
      lib/crypto: sha256: Propagate sha256_block_state type to implementations
      lib/crypto: sha256: Add HMAC-SHA224 and HMAC-SHA256 support
      crypto: sha256 - Wrap library and add HMAC support
      crypto: sha256 - Use same state format as legacy drivers
      lib/crypto: sha256: Remove sha256_is_arch_optimized()
      lib/crypto: sha256: Consolidate into single module
      lib/crypto: sha256: Sync sha256_update() with sha512_update()
      lib/crypto: sha256: Document the SHA-224 and SHA-256 API
      lib/crypto: x86/sha256: Move static_call above kernel-mode FPU section
      lib/crypto: x86/sha256: Remove unnecessary checks for nblocks==0
      lib/crypto: hash_info: Move hash_info.c into lib/crypto/
      lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
      lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD contexts
      lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
      lib/crypto: x86/poly1305: Fix performance regression on short messages
      lib/crypto: arm/poly1305: Remove unneeded empty weak function
      lib/crypto: sha2: Add hmac_sha*_init_usingrawkey()
      crypto: x86/sha1 - Rename conflicting symbol
      lib/crypto: sha1: Rename sha1_init() to sha1_init_raw()
      lib/crypto: sha1: Add SHA-1 library functions
      lib/crypto: sha1: Add HMAC support
      crypto: sha1 - Wrap library and add HMAC support
      crypto: sha1 - Use same state format as legacy drivers
      lib/crypto: arm/sha1: Migrate optimized code into library
      lib/crypto: arm64/sha1: Migrate optimized code into library
      lib/crypto: mips/sha1: Migrate optimized code into library
      lib/crypto: powerpc/sha1: Migrate optimized code into library
      lib/crypto: s390/sha1: Migrate optimized code into library
      lib/crypto: sparc/sha1: Migrate optimized code into library
      lib/crypto: x86/sha1: Migrate optimized code into library
      crypto: sha1 - Remove sha1_base.h
      lib/crypto: x86/sha1-ni: Minor optimizations and cleanup
      lib/crypto: x86/sha1-ni: Convert to use rounds macros
      lib/crypto: arm64/sha512-ce: Drop compatibility macros for older binutils

 MAINTAINERS                                        |   1 -
 arch/arm/configs/exynos_defconfig                  |   2 -
 arch/arm/configs/milbeaut_m10v_defconfig           |   3 -
 arch/arm/configs/multi_v7_defconfig                |   3 -
 arch/arm/configs/omap2plus_defconfig               |   2 -
 arch/arm/configs/pxa_defconfig                     |   2 -
 arch/arm/crypto/Kconfig                            |  41 --
 arch/arm/crypto/Makefile                           |  21 -
 arch/arm/crypto/sha1-ce-glue.c                     |  72 --
 arch/arm/crypto/sha1_glue.c                        |  75 --
 arch/arm/crypto/sha1_neon_glue.c                   |  83 ---
 arch/arm/crypto/sha512-glue.c                      | 110 ---
 arch/arm/crypto/sha512-neon-glue.c                 |  75 --
 arch/arm/crypto/sha512.h                           |   3 -
 arch/arm/lib/.gitignore                            |   4 +
 arch/arm/lib/Makefile                              |   2 -
 arch/arm/lib/crypto/sha256.c                       |  64 --
 arch/arm64/configs/defconfig                       |   2 -
 arch/arm64/crypto/Kconfig                          |  30 -
 arch/arm64/crypto/Makefile                         |  17 -
 arch/arm64/crypto/sha1-ce-glue.c                   | 118 ---
 arch/arm64/crypto/sha512-ce-glue.c                 |  96 ---
 arch/arm64/crypto/sha512-glue.c                    |  83 ---
 arch/arm64/lib/.gitignore                          |   4 +
 arch/arm64/lib/Makefile                            |   3 -
 arch/arm64/lib/crypto/sha256.c                     |  75 --
 arch/mips/cavium-octeon/Kconfig                    |   6 -
 arch/mips/cavium-octeon/crypto/Makefile            |   3 -
 arch/mips/cavium-octeon/crypto/octeon-crypto.c     |   3 +-
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |   3 +-
 arch/mips/cavium-octeon/crypto/octeon-sha1.c       | 147 ----
 arch/mips/cavium-octeon/crypto/octeon-sha512.c     | 167 -----
 arch/mips/configs/cavium_octeon_defconfig          |   2 -
 arch/mips/crypto/Kconfig                           |  20 -
 .../asm/octeon/crypto.h}                           |   0
 arch/mips/lib/.gitignore                           |   4 +
 arch/mips/lib/Makefile                             |   2 -
 arch/powerpc/configs/44x/akebono_defconfig         |   1 -
 arch/powerpc/configs/powernv_defconfig             |   1 -
 arch/powerpc/configs/ppc64_defconfig               |   1 -
 arch/powerpc/crypto/Kconfig                        |  16 -
 arch/powerpc/crypto/Makefile                       |   4 -
 arch/powerpc/crypto/sha1-spe-glue.c                | 107 ---
 arch/powerpc/crypto/sha1.c                         |  78 --
 arch/powerpc/lib/Makefile                          |   2 -
 arch/riscv/crypto/Kconfig                          |  11 -
 arch/riscv/crypto/Makefile                         |   3 -
 arch/riscv/crypto/sha512-riscv64-glue.c            | 124 ----
 arch/riscv/lib/Makefile                            |   1 -
 arch/riscv/lib/crypto/Kconfig                      |  16 -
 arch/riscv/lib/crypto/sha256.c                     |  67 --
 arch/riscv/purgatory/purgatory.c                   |   8 +-
 arch/s390/configs/debug_defconfig                  |   2 -
 arch/s390/configs/defconfig                        |   2 -
 arch/s390/crypto/Kconfig                           |  20 -
 arch/s390/crypto/Makefile                          |   2 -
 arch/s390/crypto/sha1_s390.c                       | 103 ---
 arch/s390/crypto/sha512_s390.c                     | 151 ----
 arch/s390/lib/Makefile                             |   1 -
 arch/s390/lib/crypto/sha256.c                      |  47 --
 arch/s390/purgatory/purgatory.c                    |   2 +-
 arch/sparc/crypto/Kconfig                          |  20 -
 arch/sparc/crypto/Makefile                         |   4 -
 arch/sparc/crypto/sha1_glue.c                      |  94 ---
 arch/sparc/crypto/sha512_glue.c                    | 122 ----
 arch/sparc/lib/Makefile                            |   1 -
 arch/sparc/lib/crypto/Kconfig                      |   8 -
 arch/sparc/lib/crypto/Makefile                     |   4 -
 arch/x86/crypto/Kconfig                            |  27 -
 arch/x86/crypto/Makefile                           |   6 -
 arch/x86/crypto/sha1_ni_asm.S                      | 304 --------
 arch/x86/crypto/sha1_ssse3_glue.c                  | 324 ---------
 arch/x86/crypto/sha512_ssse3_glue.c                | 322 ---------
 arch/x86/lib/.gitignore                            |   4 +
 arch/x86/lib/Makefile                              |   2 -
 arch/x86/lib/crypto/sha256.c                       |  80 ---
 arch/x86/purgatory/purgatory.c                     |   2 +-
 crypto/Kconfig                                     |  14 +-
 crypto/Makefile                                    |   6 +-
 crypto/sha1.c                                      | 201 ++++++
 crypto/sha1_generic.c                              |  87 ---
 crypto/sha256.c                                    | 371 ++++++----
 crypto/sha512.c                                    | 354 +++++++++
 crypto/sha512_generic.c                            | 217 ------
 crypto/testmgr.c                                   |  28 +
 drivers/char/tpm/tpm2-sessions.c                   |  12 +-
 drivers/crypto/img-hash.c                          |   6 +-
 drivers/crypto/starfive/jh7110-hash.c              |  16 +-
 include/crypto/internal/sha2.h                     |  66 --
 include/crypto/sha1.h                              | 180 ++++-
 include/crypto/sha1_base.h                         |  82 ---
 include/crypto/sha2.h                              | 800 ++++++++++++++++++++-
 include/crypto/sha512_base.h                       | 120 ----
 kernel/bpf/core.c                                  |   2 +-
 kernel/kexec_file.c                                |  10 +-
 lib/crypto/Kconfig                                 |  77 +-
 lib/crypto/Makefile                                | 107 ++-
 lib/crypto/aes.c                                   |   1 +
 lib/crypto/aescfb.c                                |   7 +-
 lib/crypto/aesgcm.c                                |   5 +-
 lib/crypto/arc4.c                                  |   1 +
 {arch/arm/lib/crypto => lib/crypto/arm}/.gitignore |   1 +
 {arch/arm/lib/crypto => lib/crypto/arm}/Kconfig    |   7 -
 {arch/arm/lib/crypto => lib/crypto/arm}/Makefile   |   8 +-
 .../lib/crypto => lib/crypto/arm}/blake2s-core.S   |   0
 .../lib/crypto => lib/crypto/arm}/blake2s-glue.c   |   0
 .../lib/crypto => lib/crypto/arm}/chacha-glue.c    |   0
 .../crypto => lib/crypto/arm}/chacha-neon-core.S   |   0
 .../crypto => lib/crypto/arm}/chacha-scalar-core.S |   0
 .../crypto => lib/crypto/arm}/poly1305-armv4.pl    |   2 +-
 .../lib/crypto => lib/crypto/arm}/poly1305-glue.c  |   8 +-
 .../crypto => lib/crypto/arm}/sha1-armv4-large.S   |   0
 .../crypto => lib/crypto/arm}/sha1-armv7-neon.S    |  13 +-
 {arch/arm/crypto => lib/crypto/arm}/sha1-ce-core.S |   4 +-
 lib/crypto/arm/sha1.h                              |  46 ++
 .../lib/crypto => lib/crypto/arm}/sha256-armv4.pl  |  20 +-
 .../arm/lib/crypto => lib/crypto/arm}/sha256-ce.S  |   2 +-
 lib/crypto/arm/sha256.h                            |  46 ++
 .../arm/crypto => lib/crypto/arm}/sha512-armv4.pl  |   0
 lib/crypto/arm/sha512.h                            |  38 +
 .../lib/crypto => lib/crypto/arm64}/.gitignore     |   1 +
 .../arm64/lib/crypto => lib/crypto/arm64}/Kconfig  |   6 -
 .../arm64/lib/crypto => lib/crypto/arm64}/Makefile |   9 +-
 .../crypto => lib/crypto/arm64}/chacha-neon-core.S |   0
 .../crypto => lib/crypto/arm64}/chacha-neon-glue.c |   0
 .../crypto => lib/crypto/arm64}/poly1305-armv8.pl  |   0
 .../crypto => lib/crypto/arm64}/poly1305-glue.c    |   3 +-
 .../crypto => lib/crypto/arm64}/sha1-ce-core.S     |  40 +-
 lib/crypto/arm64/sha1.h                            |  39 +
 .../lib/crypto => lib/crypto/arm64}/sha2-armv8.pl  |   2 +-
 .../lib/crypto => lib/crypto/arm64}/sha256-ce.S    |   2 +-
 lib/crypto/arm64/sha256.h                          |  57 ++
 .../crypto => lib/crypto/arm64}/sha512-ce-core.S   |  41 +-
 lib/crypto/arm64/sha512.h                          |  46 ++
 lib/crypto/blake2s-generic.c                       |   9 +-
 lib/crypto/blake2s.c                               |   9 +-
 lib/crypto/chacha.c                                |   6 +-
 lib/crypto/chacha20poly1305.c                      |   8 +-
 lib/crypto/curve25519-generic.c                    |   1 +
 lib/crypto/des.c                                   |   7 +-
 lib/crypto/gf128mul.c                              |   1 +
 {crypto => lib/crypto}/hash_info.c                 |   0
 lib/crypto/libchacha.c                             |   7 +-
 lib/crypto/memneq.c                                |   3 +-
 .../mips/lib/crypto => lib/crypto/mips}/.gitignore |   0
 {arch/mips/lib/crypto => lib/crypto/mips}/Kconfig  |   0
 {arch/mips/lib/crypto => lib/crypto/mips}/Makefile |   0
 .../lib/crypto => lib/crypto/mips}/chacha-core.S   |  20 +-
 .../lib/crypto => lib/crypto/mips}/chacha-glue.c   |   0
 .../lib/crypto => lib/crypto/mips}/poly1305-glue.c |   0
 .../crypto => lib/crypto/mips}/poly1305-mips.pl    |   0
 lib/crypto/mips/sha1.h                             |  81 +++
 .../octeon-sha256.c => lib/crypto/mips/sha256.h    |  23 +-
 lib/crypto/mips/sha512.h                           |  74 ++
 lib/crypto/mpi/mpi-add.c                           |   2 +
 lib/crypto/mpi/mpi-bit.c                           |   2 +
 lib/crypto/mpi/mpi-cmp.c                           |   2 +
 lib/crypto/mpi/mpi-mul.c                           |   2 +
 lib/crypto/mpi/mpi-pow.c                           |   2 +
 lib/crypto/mpi/mpi-sub-ui.c                        |   2 +
 lib/crypto/mpi/mpicoder.c                          |   3 +-
 lib/crypto/mpi/mpiutil.c                           |   2 +
 lib/crypto/poly1305-donna32.c                      |   3 +-
 lib/crypto/poly1305-donna64.c                      |   3 +-
 lib/crypto/poly1305-generic.c                      |   1 +
 lib/crypto/poly1305.c                              |   1 +
 .../lib/crypto => lib/crypto/powerpc}/Kconfig      |   6 -
 .../lib/crypto => lib/crypto/powerpc}/Makefile     |   3 -
 .../crypto/powerpc}/chacha-p10-glue.c              |   0
 .../crypto/powerpc}/chacha-p10le-8x.S              |   0
 .../crypto/powerpc}/poly1305-p10-glue.c            |   0
 .../crypto/powerpc}/poly1305-p10le_64.S            |   0
 .../crypto/powerpc}/sha1-powerpc-asm.S             |   0
 .../crypto => lib/crypto/powerpc}/sha1-spe-asm.S   |   0
 lib/crypto/powerpc/sha1.h                          |  67 ++
 .../crypto => lib/crypto/powerpc}/sha256-spe-asm.S |   0
 .../crypto/sha256.c => lib/crypto/powerpc/sha256.h |  22 +-
 lib/crypto/riscv/Kconfig                           |   8 +
 .../riscv/lib/crypto => lib/crypto/riscv}/Makefile |   3 -
 .../crypto/riscv}/chacha-riscv64-glue.c            |   0
 .../crypto/riscv}/chacha-riscv64-zvkb.S            |   0
 .../riscv}/sha256-riscv64-zvknha_or_zvknhb-zvkb.S  |   2 +-
 lib/crypto/riscv/sha256.h                          |  42 ++
 .../crypto/riscv}/sha512-riscv64-zvknhb-zvkb.S     |   4 +-
 lib/crypto/riscv/sha512.h                          |  41 ++
 {arch/s390/lib/crypto => lib/crypto/s390}/Kconfig  |   6 -
 {arch/s390/lib/crypto => lib/crypto/s390}/Makefile |   3 -
 .../lib/crypto => lib/crypto/s390}/chacha-glue.c   |   0
 .../lib/crypto => lib/crypto/s390}/chacha-s390.S   |   0
 .../lib/crypto => lib/crypto/s390}/chacha-s390.h   |   0
 lib/crypto/s390/sha1.h                             |  28 +
 lib/crypto/s390/sha256.h                           |  28 +
 lib/crypto/s390/sha512.h                           |  28 +
 lib/crypto/sha1.c                                  | 229 +++++-
 lib/crypto/sha256-generic.c                        | 137 ----
 lib/crypto/sha256.c                                | 433 +++++++++--
 lib/crypto/sha512.c                                | 423 +++++++++++
 lib/crypto/sm3.c                                   |   1 +
 lib/crypto/sparc/sha1.h                            |  43 ++
 {arch/sparc/crypto => lib/crypto/sparc}/sha1_asm.S |   0
 .../crypto/sha256.c => lib/crypto/sparc/sha256.h   |  37 +-
 .../lib/crypto => lib/crypto/sparc}/sha256_asm.S   |   0
 lib/crypto/sparc/sha512.h                          |  42 ++
 .../sparc/crypto => lib/crypto/sparc}/sha512_asm.S |   0
 lib/crypto/utils.c                                 |   3 +-
 {arch/x86/lib/crypto => lib/crypto/x86}/.gitignore |   0
 {arch/x86/lib/crypto => lib/crypto/x86}/Kconfig    |   8 -
 {arch/x86/lib/crypto => lib/crypto/x86}/Makefile   |   3 -
 .../lib/crypto => lib/crypto/x86}/blake2s-core.S   |   0
 .../lib/crypto => lib/crypto/x86}/blake2s-glue.c   |   0
 .../crypto => lib/crypto/x86}/chacha-avx2-x86_64.S |   0
 .../crypto/x86}/chacha-avx512vl-x86_64.S           |   0
 .../crypto/x86}/chacha-ssse3-x86_64.S              |   0
 .../lib/crypto => lib/crypto/x86}/chacha_glue.c    |   0
 .../crypto/x86}/poly1305-x86_64-cryptogams.pl      |   0
 .../lib/crypto => lib/crypto/x86}/poly1305_glue.c  |  48 +-
 .../crypto/x86/sha1-avx2-asm.S                     |   7 +-
 lib/crypto/x86/sha1-ni-asm.S                       | 152 ++++
 .../crypto/x86/sha1-ssse3-and-avx.S                |  13 +-
 lib/crypto/x86/sha1.h                              |  74 ++
 .../lib/crypto => lib/crypto/x86}/sha256-avx-asm.S |   8 +-
 .../crypto => lib/crypto/x86}/sha256-avx2-asm.S    |   6 +-
 .../lib/crypto => lib/crypto/x86}/sha256-ni-asm.S  |   7 +-
 .../crypto => lib/crypto/x86}/sha256-ssse3-asm.S   |   8 +-
 lib/crypto/x86/sha256.h                            |  57 ++
 .../x86/crypto => lib/crypto/x86}/sha512-avx-asm.S |  11 +-
 .../crypto => lib/crypto/x86}/sha512-avx2-asm.S    |  12 +-
 .../crypto => lib/crypto/x86}/sha512-ssse3-asm.S   |  14 +-
 lib/crypto/x86/sha512.h                            |  54 ++
 net/ceph/messenger_v2.c                            |  12 +-
 net/ipv6/addrconf.c                                |   2 +-
 tools/testing/cxl/test/mem.c                       |  21 +-
 232 files changed, 4305 insertions(+), 4778 deletions(-)
 delete mode 100644 arch/arm/crypto/sha1-ce-glue.c
 delete mode 100644 arch/arm/crypto/sha1_glue.c
 delete mode 100644 arch/arm/crypto/sha1_neon_glue.c
 delete mode 100644 arch/arm/crypto/sha512-glue.c
 delete mode 100644 arch/arm/crypto/sha512-neon-glue.c
 delete mode 100644 arch/arm/crypto/sha512.h
 create mode 100644 arch/arm/lib/.gitignore
 delete mode 100644 arch/arm/lib/crypto/sha256.c
 delete mode 100644 arch/arm64/crypto/sha1-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sha512-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sha512-glue.c
 create mode 100644 arch/arm64/lib/.gitignore
 delete mode 100644 arch/arm64/lib/crypto/sha256.c
 delete mode 100644 arch/mips/cavium-octeon/crypto/octeon-sha1.c
 delete mode 100644 arch/mips/cavium-octeon/crypto/octeon-sha512.c
 rename arch/mips/{cavium-octeon/crypto/octeon-crypto.h => include/asm/octeon/crypto.h} (100%)
 create mode 100644 arch/mips/lib/.gitignore
 delete mode 100644 arch/powerpc/crypto/sha1-spe-glue.c
 delete mode 100644 arch/powerpc/crypto/sha1.c
 delete mode 100644 arch/riscv/crypto/sha512-riscv64-glue.c
 delete mode 100644 arch/riscv/lib/crypto/Kconfig
 delete mode 100644 arch/riscv/lib/crypto/sha256.c
 delete mode 100644 arch/s390/crypto/sha1_s390.c
 delete mode 100644 arch/s390/crypto/sha512_s390.c
 delete mode 100644 arch/s390/lib/crypto/sha256.c
 delete mode 100644 arch/sparc/crypto/sha1_glue.c
 delete mode 100644 arch/sparc/crypto/sha512_glue.c
 delete mode 100644 arch/sparc/lib/crypto/Kconfig
 delete mode 100644 arch/sparc/lib/crypto/Makefile
 delete mode 100644 arch/x86/crypto/sha1_ni_asm.S
 delete mode 100644 arch/x86/crypto/sha1_ssse3_glue.c
 delete mode 100644 arch/x86/crypto/sha512_ssse3_glue.c
 delete mode 100644 arch/x86/lib/crypto/sha256.c
 create mode 100644 crypto/sha1.c
 delete mode 100644 crypto/sha1_generic.c
 create mode 100644 crypto/sha512.c
 delete mode 100644 crypto/sha512_generic.c
 delete mode 100644 include/crypto/internal/sha2.h
 delete mode 100644 include/crypto/sha1_base.h
 delete mode 100644 include/crypto/sha512_base.h
 rename {arch/arm/lib/crypto => lib/crypto/arm}/.gitignore (83%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/Kconfig (79%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/Makefile (80%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/blake2s-core.S (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/blake2s-glue.c (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/chacha-glue.c (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/chacha-neon-core.S (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/chacha-scalar-core.S (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/poly1305-armv4.pl (100%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/poly1305-glue.c (93%)
 rename {arch/arm/crypto => lib/crypto/arm}/sha1-armv4-large.S (100%)
 rename {arch/arm/crypto => lib/crypto/arm}/sha1-armv7-neon.S (98%)
 rename {arch/arm/crypto => lib/crypto/arm}/sha1-ce-core.S (96%)
 create mode 100644 lib/crypto/arm/sha1.h
 rename {arch/arm/lib/crypto => lib/crypto/arm}/sha256-armv4.pl (97%)
 rename {arch/arm/lib/crypto => lib/crypto/arm}/sha256-ce.S (97%)
 create mode 100644 lib/crypto/arm/sha256.h
 rename {arch/arm/crypto => lib/crypto/arm}/sha512-armv4.pl (100%)
 create mode 100644 lib/crypto/arm/sha512.h
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/.gitignore (83%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/Kconfig (70%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/Makefile (66%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/chacha-neon-core.S (100%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/chacha-neon-glue.c (100%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/poly1305-armv8.pl (100%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/poly1305-glue.c (95%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/sha1-ce-core.S (76%)
 create mode 100644 lib/crypto/arm64/sha1.h
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/sha2-armv8.pl (99%)
 rename {arch/arm64/lib/crypto => lib/crypto/arm64}/sha256-ce.S (98%)
 create mode 100644 lib/crypto/arm64/sha256.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/sha512-ce-core.S (88%)
 create mode 100644 lib/crypto/arm64/sha512.h
 rename {crypto => lib/crypto}/hash_info.c (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/.gitignore (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/Kconfig (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/Makefile (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/chacha-core.S (97%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/chacha-glue.c (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/poly1305-glue.c (100%)
 rename {arch/mips/lib/crypto => lib/crypto/mips}/poly1305-mips.pl (100%)
 create mode 100644 lib/crypto/mips/sha1.h
 rename arch/mips/cavium-octeon/crypto/octeon-sha256.c => lib/crypto/mips/sha256.h (74%)
 create mode 100644 lib/crypto/mips/sha512.h
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/Kconfig (79%)
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/Makefile (73%)
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/chacha-p10-glue.c (100%)
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/chacha-p10le-8x.S (100%)
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/poly1305-p10-glue.c (100%)
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/poly1305-p10le_64.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/sha1-powerpc-asm.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/sha1-spe-asm.S (100%)
 create mode 100644 lib/crypto/powerpc/sha1.h
 rename {arch/powerpc/lib/crypto => lib/crypto/powerpc}/sha256-spe-asm.S (100%)
 rename arch/powerpc/lib/crypto/sha256.c => lib/crypto/powerpc/sha256.h (72%)
 create mode 100644 lib/crypto/riscv/Kconfig
 rename {arch/riscv/lib/crypto => lib/crypto/riscv}/Makefile (56%)
 rename {arch/riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-glue.c (100%)
 rename {arch/riscv/lib/crypto => lib/crypto/riscv}/chacha-riscv64-zvkb.S (100%)
 rename {arch/riscv/lib/crypto => lib/crypto/riscv}/sha256-riscv64-zvknha_or_zvknhb-zvkb.S (98%)
 create mode 100644 lib/crypto/riscv/sha256.h
 rename {arch/riscv/crypto => lib/crypto/riscv}/sha512-riscv64-zvknhb-zvkb.S (98%)
 create mode 100644 lib/crypto/riscv/sha512.h
 rename {arch/s390/lib/crypto => lib/crypto/s390}/Kconfig (56%)
 rename {arch/s390/lib/crypto => lib/crypto/s390}/Makefile (63%)
 rename {arch/s390/lib/crypto => lib/crypto/s390}/chacha-glue.c (100%)
 rename {arch/s390/lib/crypto => lib/crypto/s390}/chacha-s390.S (100%)
 rename {arch/s390/lib/crypto => lib/crypto/s390}/chacha-s390.h (100%)
 create mode 100644 lib/crypto/s390/sha1.h
 create mode 100644 lib/crypto/s390/sha256.h
 create mode 100644 lib/crypto/s390/sha512.h
 delete mode 100644 lib/crypto/sha256-generic.c
 create mode 100644 lib/crypto/sha512.c
 create mode 100644 lib/crypto/sparc/sha1.h
 rename {arch/sparc/crypto => lib/crypto/sparc}/sha1_asm.S (100%)
 rename arch/sparc/lib/crypto/sha256.c => lib/crypto/sparc/sha256.h (53%)
 rename {arch/sparc/lib/crypto => lib/crypto/sparc}/sha256_asm.S (100%)
 create mode 100644 lib/crypto/sparc/sha512.h
 rename {arch/sparc/crypto => lib/crypto/sparc}/sha512_asm.S (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/.gitignore (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/Kconfig (76%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/Makefile (79%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/blake2s-core.S (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/blake2s-glue.c (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/chacha-avx2-x86_64.S (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/chacha-avx512vl-x86_64.S (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/chacha-ssse3-x86_64.S (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/chacha_glue.c (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/poly1305-x86_64-cryptogams.pl (100%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/poly1305_glue.c (65%)
 rename arch/x86/crypto/sha1_avx2_x86_64_asm.S => lib/crypto/x86/sha1-avx2-asm.S (98%)
 create mode 100644 lib/crypto/x86/sha1-ni-asm.S
 rename arch/x86/crypto/sha1_ssse3_asm.S => lib/crypto/x86/sha1-ssse3-and-avx.S (97%)
 create mode 100644 lib/crypto/x86/sha1.h
 rename {arch/x86/lib/crypto => lib/crypto/x86}/sha256-avx-asm.S (98%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/sha256-avx2-asm.S (99%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/sha256-ni-asm.S (97%)
 rename {arch/x86/lib/crypto => lib/crypto/x86}/sha256-ssse3-asm.S (98%)
 create mode 100644 lib/crypto/x86/sha256.h
 rename {arch/x86/crypto => lib/crypto/x86}/sha512-avx-asm.S (98%)
 rename {arch/x86/crypto => lib/crypto/x86}/sha512-avx2-asm.S (99%)
 rename {arch/x86/crypto => lib/crypto/x86}/sha512-ssse3-asm.S (97%)
 create mode 100644 lib/crypto/x86/sha512.h
