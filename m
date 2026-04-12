Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A0E2BB17;
	Sun, 12 Apr 2026 00:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775954023; cv=none; b=nYsHFTYj3gw4JVUHs4wILy5qwtnipSHekxwxOqIELCHNxsYo9QtjCHSRHSoR3/+r61oGnyac5mWdsI1n5OtZM+9mVnUd6RjeIdR9O7FVxouKc3NCr6Rb/xtKEwnj/ONKRWZ2TzrwKArd5wxWpy0QJvW9MHhd7qFYB/FNzQb58bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775954023; c=relaxed/simple;
	bh=wnSRugAvwv/tBnBjlrBltN04IClIcjnryKl4t+fb+aw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IdbCu9n/zJ/Ze6yNTDn9HpllcexlxztxxjR4HlldeI4UwetcJiHHDcSIxDjrem6zAe0CgaxX40if77/xOASXTk+N1iXM7q8uYSZJUENFx4QrlvmtRaAJTu2odPnZ44VCf3P1wUWrpw9H2oJYuUpWL9/clg8yZpRQmpDxsKigv1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lj4mJ0JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lj4mJ0JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CA9C116C6;
	Sun, 12 Apr 2026 00:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775954022;
	bh=wnSRugAvwv/tBnBjlrBltN04IClIcjnryKl4t+fb+aw=;
	h=Date:From:To:Cc:Subject:From;
	b=Lj4mJ0JRTZ0Qx1RFYnjVeYsPVRlk+9C5QLzGYZ7tsNoQyJcqJIWe1LVksHOQOmb7Z
	 Ji+gxza52GT6MKrIB7L5qlk8StdyQ1Y+JPzGZEqfRH24SgS455a5pcK9rEubQHJR4q
	 0XtiU80848tv+/OWoovJLqlJU8yzbRkIPr6Q+Ejkn0acfiiOy2qjWdKGL08svV8ahb
	 vLNrNpjwHLs8FCp8LyREuUqw9bwQwwbXamo+tq2t1TRGd9/4kqyJ07m3LhL77wIJ7x
	 GLoY//566ULgd3J1x2NjHtIPNOqjK/Pkw/0AUM9HqvLxpvWnYNdvTXg1wlb0S/JlO+
	 5UGsjqmLhq4Mw==
Date: Sat, 11 Apr 2026 17:32:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dan.j.williams@intel.com>,
	David Howells <dhowells@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [GIT PULL] Crypto library updates for 7.1
Message-ID: <20260412003225.GC6632@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 12b11e47f126d097839fd2f077636e2139b0151b:

  lib/crypto: arm64: Assume a little-endian kernel (2026-04-01 13:02:15 -0700)

----------------------------------------------------------------

- Migrate more hash algorithms from the traditional crypto subsystem
  to lib/crypto/.

  Like the algorithms migrated earlier (e.g. SHA-*), this simplifies
  the implementations, improves performance, enables further
  simplifications in calling code, and solves various other issues:

    - AES CBC-based MACs (AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC)

        - Support these algorithms in lib/crypto/ using the AES
          library and the existing arm64 assembly code

        - Reimplement the traditional crypto API's "cmac(aes)",
          "xcbc(aes)", and "cbcmac(aes)" on top of the library

        - Convert mac80211 to use the AES-CMAC library. Note: several
          other subsystems can use it too and will be converted later

        - Drop the broken, nonstandard, and likely unused support for
          "xcbc(aes)" with key lengths other than 128 bits

        - Enable optimizations by default

    - GHASH

        - Migrate the standalone GHASH code into lib/crypto/

        - Integrate the GHASH code more closely with the very similar
          POLYVAL code, and improve the generic GHASH implementation
          to resist cache-timing attacks and use much less memory

        - Reimplement the AES-GCM library and the "gcm" crypto_aead
          template on top of the GHASH library. Remove "ghash" from
          the crypto_shash API, as it's no longer needed

        - Enable optimizations by default

    - SM3

        - Migrate the kernel's existing SM3 code into lib/crypto/, and
          reimplement the traditional crypto API's "sm3" on top of it

        - I don't recommend using SM3, but this cleanup is worthwhile
          to organize the code the same way as other algorithms

- Testing improvements

    - Add a KUnit test suite for each of the new library APIs

    - Migrate the existing ChaCha20Poly1305 test to KUnit

    - Make the KUnit all_tests.config enable all crypto library tests

    - Move the test kconfig options to the Runtime Testing menu

- Other updates to arch-optimized crypto code

    - Optimize SHA-256 for Zhaoxin CPUs using the Padlock Hash Engine

    - Remove some MD5 implementations that are no longer worth keeping

    - Drop big endian and voluntary preemption support from the arm64
      code, as those configurations are no longer supported on arm64

- Make jitterentropy and samples/tsm-mr use the crypto library APIs

Note: the overall diffstat is neutral, but when the test code is
excluded it is significantly negative:

    Tests:     13 files changed, 1982 insertions(+),  888 deletions(-)
    Non-test: 141 files changed, 2897 insertions(+), 3987 deletions(-)
    All:      154 files changed, 4879 insertions(+), 4875 deletions(-)

----------------------------------------------------------------
AlanSong-oc (1):
      lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function

David Howells (1):
      crypto: jitterentropy - Use SHA-3 library

Eric Biggers (64):
      lib/crypto: aes: Add support for CBC-based MACs
      crypto: aes - Add cmac, xcbc, and cbcmac algorithms using library
      crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
      lib/crypto: arm64/aes: Move assembly code for AES modes into libaes
      lib/crypto: arm64/aes: Migrate optimized CBC-based MACs into library
      lib/crypto: tests: Add KUnit tests for CBC-based MACs
      lib/crypto: aes: Add FIPS self-test for CMAC
      wifi: mac80211: Use AES-CMAC library in ieee80211_aes_cmac()
      wifi: mac80211: Use AES-CMAC library in aes_s2v()
      lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
      kunit: configs: Enable all crypto library tests in all_tests.config
      lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS
      lib/crypto: Remove unused file blockhash.h
      lib/crypto: arm64: Drop checks for CONFIG_KERNEL_MODE_NEON
      sample/tsm-mr: Use SHA-2 library APIs
      coco/guest: Remove unneeded selection of CRYPTO
      lib/crypto: gf128hash: Rename polyval module to gf128hash
      lib/crypto: gf128hash: Support GF128HASH_ARCH without all POLYVAL functions
      lib/crypto: gf128hash: Add GHASH support
      lib/crypto: tests: Add KUnit tests for GHASH
      crypto: arm/ghash - Make the "ghash" crypto_shash NEON-only
      crypto: arm/ghash - Move NEON GHASH assembly into its own file
      lib/crypto: arm/ghash: Migrate optimized code into library
      crypto: arm64/ghash - Move NEON GHASH assembly into its own file
      lib/crypto: arm64/ghash: Migrate optimized code into library
      crypto: arm64/aes-gcm - Rename struct ghash_key and make fixed-sized
      lib/crypto: powerpc/ghash: Migrate optimized code into library
      lib/crypto: riscv/ghash: Migrate optimized code into library
      lib/crypto: s390/ghash: Migrate optimized code into library
      lib/crypto: x86/ghash: Migrate optimized code into library
      crypto: gcm - Use GHASH library instead of crypto_ahash
      crypto: ghash - Remove ghash from crypto_shash API
      lib/crypto: gf128mul: Remove unused 4k_lle functions
      lib/crypto: gf128hash: Remove unused content from ghash.h
      lib/crypto: aesgcm: Use GHASH library API
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
      lib: Move crypto library tests to Runtime Testing menu
      lib/crypto: mips: Drop optimized MD5 code
      lib/crypto: sparc: Drop optimized MD5 code
      lib/crypto: tests: Migrate ChaCha20Poly1305 self-test to KUnit
      lib/crypto: aescfb: Don't disable IRQs during AES block encryption
      lib/crypto: aesgcm: Don't disable IRQs during AES block encryption
      lib/crypto: Include <crypto/utils.h> instead of <crypto/algapi.h>
      lib/crypto: arm64/aes: Remove obsolete chunking logic
      lib/crypto: arm64/chacha: Remove obsolete chunking logic
      lib/crypto: arm64/gf128hash: Remove obsolete chunking logic
      lib/crypto: arm64/poly1305: Remove obsolete chunking logic
      lib/crypto: arm64/sha1: Remove obsolete chunking logic
      lib/crypto: arm64/sha256: Remove obsolete chunking logic
      lib/crypto: arm64/sha512: Remove obsolete chunking logic
      lib/crypto: arm64/sha3: Remove obsolete chunking logic
      arm64: fpsimd: Remove obsolete cond_yield macro
      lib/crypto: arm64: Assume a little-endian kernel

 MAINTAINERS                                        |    4 +-
 arch/arm/crypto/Kconfig                            |   13 +-
 arch/arm/crypto/ghash-ce-core.S                    |  171 +--
 arch/arm/crypto/ghash-ce-glue.c                    |  166 +--
 arch/arm64/configs/defconfig                       |    2 +-
 arch/arm64/crypto/Kconfig                          |   29 +-
 arch/arm64/crypto/Makefile                         |   10 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |   17 +-
 arch/arm64/crypto/aes-glue.c                       |  261 +---
 arch/arm64/crypto/aes-neonbs-glue.c                |   15 +-
 arch/arm64/crypto/ghash-ce-core.S                  |  221 +--
 arch/arm64/crypto/ghash-ce-glue.c                  |  168 +--
 arch/arm64/crypto/sm3-ce-glue.c                    |   70 -
 arch/arm64/crypto/sm3-neon-glue.c                  |   67 -
 arch/arm64/include/asm/assembler.h                 |   22 -
 arch/loongarch/configs/loongson32_defconfig        |    2 +-
 arch/loongarch/configs/loongson64_defconfig        |    2 +-
 arch/m68k/configs/amiga_defconfig                  |    2 +-
 arch/m68k/configs/apollo_defconfig                 |    2 +-
 arch/m68k/configs/atari_defconfig                  |    2 +-
 arch/m68k/configs/bvme6000_defconfig               |    2 +-
 arch/m68k/configs/hp300_defconfig                  |    2 +-
 arch/m68k/configs/mac_defconfig                    |    2 +-
 arch/m68k/configs/multi_defconfig                  |    2 +-
 arch/m68k/configs/mvme147_defconfig                |    2 +-
 arch/m68k/configs/mvme16x_defconfig                |    2 +-
 arch/m68k/configs/q40_defconfig                    |    2 +-
 arch/m68k/configs/sun3_defconfig                   |    2 +-
 arch/m68k/configs/sun3x_defconfig                  |    2 +-
 arch/powerpc/crypto/Kconfig                        |    5 +-
 arch/powerpc/crypto/Makefile                       |    8 +-
 arch/powerpc/crypto/aesp8-ppc.h                    |    1 -
 arch/powerpc/crypto/ghash.c                        |  160 ---
 arch/powerpc/crypto/vmx.c                          |   10 +-
 arch/riscv/crypto/Kconfig                          |   24 -
 arch/riscv/crypto/Makefile                         |    6 -
 arch/riscv/crypto/ghash-riscv64-glue.c             |  146 --
 arch/riscv/crypto/sm3-riscv64-glue.c               |   97 --
 arch/s390/configs/debug_defconfig                  |    3 +-
 arch/s390/configs/defconfig                        |    3 +-
 arch/s390/crypto/Kconfig                           |   10 -
 arch/s390/crypto/Makefile                          |    1 -
 arch/s390/crypto/ghash_s390.c                      |  144 --
 arch/x86/crypto/Kconfig                            |   23 -
 arch/x86/crypto/Makefile                           |    6 -
 arch/x86/crypto/aesni-intel_glue.c                 |    1 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |  163 ---
 arch/x86/crypto/sm3_avx_glue.c                     |  100 --
 crypto/Kconfig                                     |   17 +-
 crypto/Makefile                                    |    3 +-
 crypto/aes.c                                       |  183 ++-
 crypto/gcm.c                                       |  413 +-----
 crypto/ghash-generic.c                             |  162 ---
 crypto/hctr2.c                                     |    2 +-
 crypto/jitterentropy-kcapi.c                       |  114 +-
 crypto/jitterentropy.c                             |   25 +-
 crypto/jitterentropy.h                             |   19 +-
 crypto/sm3.c                                       |   89 ++
 crypto/sm3_generic.c                               |   72 -
 crypto/tcrypt.c                                    |    9 -
 crypto/testmgr.c                                   |   28 +-
 crypto/testmgr.h                                   |  109 --
 drivers/crypto/Kconfig                             |    2 +-
 drivers/crypto/starfive/Kconfig                    |    2 +-
 drivers/crypto/starfive/jh7110-aes.c               |    4 +-
 drivers/crypto/starfive/jh7110-hash.c              |    8 +-
 drivers/virt/coco/guest/Kconfig                    |    1 -
 include/crypto/aes-cbc-macs.h                      |  154 ++
 include/crypto/aes.h                               |   66 +
 include/crypto/chacha20poly1305.h                  |    2 -
 include/crypto/gcm.h                               |    4 +-
 include/crypto/{polyval.h => gf128hash.h}          |  126 +-
 include/crypto/gf128mul.h                          |   17 +-
 include/crypto/ghash.h                             |   12 -
 include/crypto/internal/blockhash.h                |   52 -
 include/crypto/sm3.h                               |   85 +-
 include/crypto/sm3_base.h                          |   82 --
 lib/Kconfig.debug                                  |    2 +
 lib/crypto/.kunitconfig                            |   24 +-
 lib/crypto/Kconfig                                 |   68 +-
 lib/crypto/Makefile                                |   79 +-
 lib/crypto/aes.c                                   |  231 ++-
 lib/crypto/aescfb.c                                |   27 +-
 lib/crypto/aesgcm.c                                |   76 +-
 lib/crypto/arm/gf128hash.h                         |   43 +
 lib/crypto/arm/ghash-neon-core.S                   |  209 +++
 {arch/arm64/crypto => lib/crypto/arm64}/aes-ce.S   |    3 +-
 lib/crypto/arm64/aes-cipher-core.S                 |   10 -
 .../arm64/crypto => lib/crypto/arm64}/aes-modes.S  |   25 +-
 {arch/arm64/crypto => lib/crypto/arm64}/aes-neon.S |    2 +-
 lib/crypto/arm64/aes.h                             |   75 +-
 lib/crypto/arm64/chacha-neon-core.S                |   16 -
 lib/crypto/arm64/chacha.h                          |   16 +-
 lib/crypto/arm64/gf128hash.h                       |  121 ++
 lib/crypto/arm64/ghash-neon-core.S                 |  220 +++
 lib/crypto/arm64/poly1305.h                        |   14 +-
 lib/crypto/arm64/polyval.h                         |   80 --
 lib/crypto/arm64/sha1-ce-core.S                    |   22 +-
 lib/crypto/arm64/sha1.h                            |   15 +-
 lib/crypto/arm64/sha256-ce.S                       |   55 +-
 lib/crypto/arm64/sha256.h                          |   37 +-
 lib/crypto/arm64/sha3-ce-core.S                    |    8 +-
 lib/crypto/arm64/sha3.h                            |   15 +-
 lib/crypto/arm64/sha512-ce-core.S                  |   28 +-
 lib/crypto/arm64/sha512.h                          |   20 +-
 .../crypto => lib/crypto/arm64}/sm3-ce-core.S      |   19 +-
 .../crypto => lib/crypto/arm64}/sm3-neon-core.S    |    9 +-
 lib/crypto/arm64/sm3.h                             |   41 +
 lib/crypto/chacha.c                                |    2 +-
 lib/crypto/chacha20poly1305.c                      |   14 -
 lib/crypto/fips.h                                  |    5 +
 lib/crypto/{polyval.c => gf128hash.c}              |  183 ++-
 lib/crypto/gf128mul.c                              |   73 +-
 lib/crypto/memneq.c                                |    4 +-
 lib/crypto/mips/md5.h                              |   65 -
 lib/crypto/powerpc/.gitignore                      |    1 +
 lib/crypto/powerpc/gf128hash.h                     |  109 ++
 .../crypto => lib/crypto/powerpc}/ghashp8-ppc.pl   |    1 +
 lib/crypto/riscv/gf128hash.h                       |   57 +
 .../crypto/riscv}/ghash-riscv64-zvkg.S             |   13 +-
 .../crypto/riscv}/sm3-riscv64-zvksh-zvkb.S         |    3 +-
 lib/crypto/riscv/sm3.h                             |   39 +
 lib/crypto/s390/gf128hash.h                        |   54 +
 lib/crypto/sm3.c                                   |  148 +-
 lib/crypto/sparc/md5.h                             |   48 -
 lib/crypto/sparc/md5_asm.S                         |   70 -
 lib/crypto/tests/Kconfig                           |   86 +-
 lib/crypto/tests/Makefile                          |    4 +
 lib/crypto/tests/aes-cmac-testvecs.h               |  181 +++
 lib/crypto/tests/aes_cbc_macs_kunit.c              |  228 +++
 .../chacha20poly1305_kunit.c}                      | 1493 ++++++++++----------
 lib/crypto/tests/ghash-testvecs.h                  |  186 +++
 lib/crypto/tests/ghash_kunit.c                     |  194 +++
 lib/crypto/tests/polyval_kunit.c                   |    2 +-
 lib/crypto/tests/sm3-testvecs.h                    |  231 +++
 lib/crypto/tests/sm3_kunit.c                       |   31 +
 lib/crypto/x86/{polyval.h => gf128hash.h}          |   72 +-
 .../crypto/x86/ghash-pclmul.S                      |   98 +-
 lib/crypto/x86/sha256.h                            |   25 +
 .../x86/crypto => lib/crypto/x86}/sm3-avx-asm_64.S |   13 +-
 lib/crypto/x86/sm3.h                               |   39 +
 net/mac80211/Kconfig                               |    2 +-
 net/mac80211/aes_cmac.c                            |   65 +-
 net/mac80211/aes_cmac.h                            |   12 +-
 net/mac80211/fils_aead.c                           |   48 +-
 net/mac80211/key.c                                 |   11 +-
 net/mac80211/key.h                                 |    3 +-
 net/mac80211/wpa.c                                 |   13 +-
 samples/Kconfig                                    |    2 +
 samples/tsm-mr/tsm_mr_sample.c                     |   68 +-
 scripts/crypto/gen-fips-testvecs.py                |   10 +
 scripts/crypto/gen-hash-testvecs.py                |   97 +-
 security/integrity/ima/Kconfig                     |    2 +-
 tools/testing/kunit/configs/all_tests.config       |    2 +
 154 files changed, 4879 insertions(+), 4875 deletions(-)
 delete mode 100644 arch/arm64/crypto/sm3-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sm3-neon-glue.c
 delete mode 100644 arch/powerpc/crypto/ghash.c
 delete mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 delete mode 100644 arch/riscv/crypto/sm3-riscv64-glue.c
 delete mode 100644 arch/s390/crypto/ghash_s390.c
 delete mode 100644 arch/x86/crypto/ghash-clmulni-intel_glue.c
 delete mode 100644 arch/x86/crypto/sm3_avx_glue.c
 delete mode 100644 crypto/ghash-generic.c
 create mode 100644 crypto/sm3.c
 delete mode 100644 crypto/sm3_generic.c
 create mode 100644 include/crypto/aes-cbc-macs.h
 rename include/crypto/{polyval.h => gf128hash.h} (60%)
 delete mode 100644 include/crypto/internal/blockhash.h
 delete mode 100644 include/crypto/sm3_base.h
 create mode 100644 lib/crypto/arm/gf128hash.h
 create mode 100644 lib/crypto/arm/ghash-neon-core.S
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-ce.S (96%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-modes.S (98%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-neon.S (99%)
 create mode 100644 lib/crypto/arm64/gf128hash.h
 create mode 100644 lib/crypto/arm64/ghash-neon-core.S
 delete mode 100644 lib/crypto/arm64/polyval.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/sm3-ce-core.S (89%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/sm3-neon-core.S (98%)
 create mode 100644 lib/crypto/arm64/sm3.h
 rename lib/crypto/{polyval.c => gf128hash.c} (61%)
 delete mode 100644 lib/crypto/mips/md5.h
 create mode 100644 lib/crypto/powerpc/gf128hash.h
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/ghashp8-ppc.pl (98%)
 create mode 100644 lib/crypto/riscv/gf128hash.h
 rename {arch/riscv/crypto => lib/crypto/riscv}/ghash-riscv64-zvkg.S (91%)
 rename {arch/riscv/crypto => lib/crypto/riscv}/sm3-riscv64-zvksh-zvkb.S (97%)
 create mode 100644 lib/crypto/riscv/sm3.h
 create mode 100644 lib/crypto/s390/gf128hash.h
 delete mode 100644 lib/crypto/sparc/md5.h
 delete mode 100644 lib/crypto/sparc/md5_asm.S
 create mode 100644 lib/crypto/tests/aes-cmac-testvecs.h
 create mode 100644 lib/crypto/tests/aes_cbc_macs_kunit.c
 rename lib/crypto/{chacha20poly1305-selftest.c => tests/chacha20poly1305_kunit.c} (91%)
 create mode 100644 lib/crypto/tests/ghash-testvecs.h
 create mode 100644 lib/crypto/tests/ghash_kunit.c
 create mode 100644 lib/crypto/tests/sm3-testvecs.h
 create mode 100644 lib/crypto/tests/sm3_kunit.c
 rename lib/crypto/x86/{polyval.h => gf128hash.h} (51%)
 rename arch/x86/crypto/ghash-clmulni-intel_asm.S => lib/crypto/x86/ghash-pclmul.S (54%)
 rename {arch/x86/crypto => lib/crypto/x86}/sm3-avx-asm_64.S (98%)
 create mode 100644 lib/crypto/x86/sm3.h
