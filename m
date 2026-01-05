Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06FE32548A;
	Mon,  5 Jan 2026 05:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590091; cv=none; b=DLb5d+7n1v8NZNDKIklJP/l79ruTVakbydnYAb4iEyLiTsmpDWVBwjJqoh/645I8hUxWS/v76d4mXrp6JkdexSaPwWHk1OoWyb1AuaURz0L+/mqzXFpM9RyYnCHoFJJHm+zxBCGZPwFYCBoRBOYAct1xwQmBr+eLk4v2WHwWEyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590091; c=relaxed/simple;
	bh=StJt3xuecPAD8gCDDLpBDdo1qszetc4wL56Ja1aU7eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UkESYvXkQW3elO0xV2Mau4AAd1XBJ69HS20s/wp+JJajNX4HTwMWwpjfWavY3VRZrYELuVamQuxMX/NIGkpfgId9zsj0jrwfqoeiaS+FhlcYsyul2V2lyqGjukrr3BkLdxV84qYYWxsPQzBgGFA9JqfkOAN/LScik7drzg41CMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fu8qhM5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fu8qhM5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE0CC19425;
	Mon,  5 Jan 2026 05:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590090;
	bh=StJt3xuecPAD8gCDDLpBDdo1qszetc4wL56Ja1aU7eg=;
	h=From:To:Cc:Subject:Date:From;
	b=fu8qhM5Ft3pw7VaFT+fsZIZ+SQbI04ehZUXLNpcgAHhHoO7gJ5Wtbwx8S80oA/QKo
	 d+ym6al5YdnAf3FULvgkNKgQ0VGcBwObYhcROn6NF2DeXOfNDEJD7qWjLXOSM3oWO6
	 B7Ok+wrKDHl4+fbARcer/f63/TT+Cc83nZ0jAj33YQD6GlRBz7dK5gdlrcTM1xi82D
	 u4dxkqqClswwmukHj3O1jPjT/cjYSp1HpOuY6vswCNa1iFxmKL7cF3NVYbBPdb6JtS
	 1/s5w8FfPNa+PbyHxMOkCqfg5QXZvVni1O0hfR7pNK879AOioS9eG5DJoPBuhdr3S2
	 DO/dGy+/zKtDQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/36] AES library improvements
Date: Sun,  4 Jan 2026 21:12:33 -0800
Message-ID: <20260105051311.1607207-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-lib-v1

This series makes three main improvements to the kernel's AES library:

  1. Make it use the kernel's existing architecture-optimized AES code,
     including AES instructions, when available.  Previously, only the
     traditional crypto API gave access to the optimized AES code.
     (As a reminder, AES instructions typically make AES over 10 times
     as fast as the generic code.  They also make it constant-time.)

  2. Support preparing an AES key for only the forward direction of the
     block cipher, using about half as much memory.  This is a helpful
     optimization for many common AES modes of operation.  It also helps
     keep structs small enough to be allocated on the stack, especially
     considering potential future library APIs for AES modes.

  3. Replace the library's generic AES implementation with a much faster
     one that is almost as fast as "aes-generic", while still keeping
     the table size reasonably small and maintaining some constant-time
     hardening.  This allows removing "aes-generic", unifying the
     current two generic AES implementations in the kernel tree.

(1) and (2) end up being interrelated: the existing
'struct crypto_aes_ctx' does not work for either one (in general).
Thus, this series reworks the AES library to be based around new data
types 'struct aes_key' and 'struct aes_enckey'.

As has been the case for other algorithms, to achieve (1) without
duplicating the architecture-optimized code, it had to be moved into
lib/crypto/ rather than copied.  To allow actually removing the
arch-specific crypto_cipher "aes" algorithms, a consolidated "aes-lib"
crypto_cipher algorithm which simply wraps the library is also added.
That's most easily done with it replacing "aes-generic" too, so that is
done too.  (That's another reason for doing (3) at the same time.)

As usual, care is taken to support all the existing arch-optimized code.
This makes it possible for users of the traditional crypto API to switch
to the library API, which is generally much easier to use, without being
concerned about performance regressions.

That being said, this series only deals with the bare (single-block) AES
library.  Future patchsets are expected to build on this work to provide
architecture-optimized library APIs for specific AES modes of operation.

Eric Biggers (36):
  crypto: powerpc/aes - Rename struct aes_key
  lib/crypto: aes: Introduce improved AES library
  crypto: arm/aes-neonbs - Use AES library for single blocks
  crypto: arm/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
  crypto: arm64/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
  crypto: arm64/aes - Select CRYPTO_LIB_SHA256 from correct places
  crypto: aegis - Switch from crypto_ft_tab[] to aes_enc_tab[]
  crypto: aes - Remove aes-fixed-time / CONFIG_CRYPTO_AES_TI
  crypto: aes - Replace aes-generic with wrapper around lib
  lib/crypto: arm/aes: Migrate optimized code into library
  lib/crypto: arm64/aes: Migrate optimized code into library
  lib/crypto: powerpc/aes: Migrate SPE optimized code into library
  lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library
  lib/crypto: riscv/aes: Migrate optimized code into library
  lib/crypto: s390/aes: Migrate optimized code into library
  lib/crypto: sparc/aes: Migrate optimized code into library
  lib/crypto: x86/aes: Add AES-NI optimization
  crypto: x86/aes - Remove the superseded AES-NI crypto_cipher
  Bluetooth: SMP: Use new AES library API
  chelsio: Use new AES library API
  net: phy: mscc: macsec: Use new AES library API
  staging: rtl8723bs: core: Use new AES library API
  crypto: arm/ghash - Use new AES library API
  crypto: arm64/ghash - Use new AES library API
  crypto: x86/aes-gcm - Use new AES library API
  crypto: ccp - Use new AES library API
  crypto: chelsio - Use new AES library API
  crypto: crypto4xx - Use new AES library API
  crypto: drbg - Use new AES library API
  crypto: inside-secure - Use new AES library API
  crypto: omap - Use new AES library API
  lib/crypto: aescfb: Use new AES library API
  lib/crypto: aesgcm: Use new AES library API
  lib/crypto: aes: Remove old AES en/decryption functions
  lib/crypto: aes: Drop "_new" suffix from en/decryption functions
  lib/crypto: aes: Drop 'volatile' from aes_sbox and aes_inv_sbox

 arch/arm/configs/milbeaut_m10v_defconfig      |    1 -
 arch/arm/configs/multi_v7_defconfig           |    2 +-
 arch/arm/configs/omap2plus_defconfig          |    2 +-
 arch/arm/configs/pxa_defconfig                |    2 +-
 arch/arm/crypto/Kconfig                       |   19 -
 arch/arm/crypto/Makefile                      |    2 -
 arch/arm/crypto/aes-cipher-glue.c             |   69 -
 arch/arm/crypto/aes-cipher.h                  |   13 -
 arch/arm/crypto/aes-neonbs-glue.c             |   29 +-
 arch/arm/crypto/ghash-ce-glue.c               |   14 +-
 arch/arm64/crypto/Kconfig                     |   29 +-
 arch/arm64/crypto/Makefile                    |    6 -
 arch/arm64/crypto/aes-ce-ccm-glue.c           |    2 -
 arch/arm64/crypto/aes-ce-glue.c               |  178 ---
 arch/arm64/crypto/aes-ce-setkey.h             |    6 -
 arch/arm64/crypto/aes-cipher-glue.c           |   63 -
 arch/arm64/crypto/aes-glue.c                  |    2 -
 arch/arm64/crypto/ghash-ce-glue.c             |   27 +-
 arch/m68k/configs/amiga_defconfig             |    1 -
 arch/m68k/configs/apollo_defconfig            |    1 -
 arch/m68k/configs/atari_defconfig             |    1 -
 arch/m68k/configs/bvme6000_defconfig          |    1 -
 arch/m68k/configs/hp300_defconfig             |    1 -
 arch/m68k/configs/mac_defconfig               |    1 -
 arch/m68k/configs/multi_defconfig             |    1 -
 arch/m68k/configs/mvme147_defconfig           |    1 -
 arch/m68k/configs/mvme16x_defconfig           |    1 -
 arch/m68k/configs/q40_defconfig               |    1 -
 arch/m68k/configs/sun3_defconfig              |    1 -
 arch/m68k/configs/sun3x_defconfig             |    1 -
 arch/powerpc/crypto/Kconfig                   |    2 +-
 arch/powerpc/crypto/Makefile                  |    9 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c        |    4 +-
 arch/powerpc/crypto/aes-spe-glue.c            |   88 +-
 arch/powerpc/crypto/aes.c                     |  134 --
 arch/powerpc/crypto/aes_cbc.c                 |    4 +-
 arch/powerpc/crypto/aes_ctr.c                 |    2 +-
 arch/powerpc/crypto/aes_xts.c                 |    6 +-
 arch/powerpc/crypto/aesp8-ppc.h               |   22 -
 arch/powerpc/crypto/vmx.c                     |   10 +-
 arch/riscv/crypto/Kconfig                     |    2 -
 arch/riscv/crypto/aes-macros.S                |   12 +-
 arch/riscv/crypto/aes-riscv64-glue.c          |   78 +-
 arch/riscv/crypto/aes-riscv64-zvkned.S        |   27 -
 arch/s390/configs/debug_defconfig             |    2 +-
 arch/s390/configs/defconfig                   |    2 +-
 arch/s390/crypto/Kconfig                      |    2 -
 arch/s390/crypto/aes_s390.c                   |  113 --
 arch/sparc/crypto/Kconfig                     |    2 +-
 arch/sparc/crypto/Makefile                    |    2 +-
 arch/sparc/crypto/aes_glue.c                  |  140 +-
 arch/x86/crypto/Kconfig                       |    2 -
 arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   33 +-
 arch/x86/crypto/aes-gcm-vaes-avx2.S           |   21 +-
 arch/x86/crypto/aes-gcm-vaes-avx512.S         |   25 +-
 arch/x86/crypto/aesni-intel_asm.S             |   25 -
 arch/x86/crypto/aesni-intel_glue.c            |  119 +-
 crypto/Kconfig                                |   23 +-
 crypto/Makefile                               |    4 +-
 crypto/aegis.h                                |    2 +-
 crypto/aes.c                                  |   66 +
 crypto/aes_generic.c                          | 1320 -----------------
 crypto/aes_ti.c                               |   83 --
 crypto/crypto_user.c                          |    2 +-
 crypto/df_sp80090a.c                          |   30 +-
 crypto/drbg.c                                 |   12 +-
 crypto/testmgr.c                              |   43 +-
 drivers/char/tpm/tpm2-sessions.c              |   10 +-
 drivers/crypto/amcc/crypto4xx_alg.c           |   10 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |    4 +-
 drivers/crypto/chelsio/chcr_algo.c            |   10 +-
 .../crypto/inside-secure/safexcel_cipher.c    |   12 +-
 drivers/crypto/inside-secure/safexcel_hash.c  |   14 +-
 drivers/crypto/omap-aes-gcm.c                 |    6 +-
 drivers/crypto/omap-aes.h                     |    2 +-
 drivers/crypto/starfive/jh7110-aes.c          |   10 +-
 drivers/crypto/xilinx/xilinx-trng.c           |    8 +-
 .../inline_crypto/ch_ipsec/chcr_ipsec.c       |    4 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |    8 +-
 .../chelsio/inline_crypto/chtls/chtls_hw.c    |    4 +-
 drivers/net/phy/mscc/mscc_macsec.c            |    8 +-
 drivers/staging/rtl8723bs/core/rtw_security.c |   20 +-
 include/crypto/aes.h                          |  279 +++-
 include/crypto/df_sp80090a.h                  |    2 +-
 include/crypto/gcm.h                          |    2 +-
 lib/crypto/Kconfig                            |   12 +
 lib/crypto/Makefile                           |   43 +-
 lib/crypto/aes.c                              |  473 ++++--
 lib/crypto/aescfb.c                           |   30 +-
 lib/crypto/aesgcm.c                           |   12 +-
 .../crypto/arm}/aes-cipher-core.S             |    4 +-
 lib/crypto/arm/aes.h                          |   56 +
 .../crypto => lib/crypto/arm64}/aes-ce-core.S |    0
 .../crypto/arm64}/aes-cipher-core.S           |    4 +-
 lib/crypto/arm64/aes.h                        |  164 ++
 lib/crypto/powerpc/.gitignore                 |    2 +
 .../crypto/powerpc}/aes-spe-core.S            |    0
 .../crypto/powerpc}/aes-spe-keys.S            |    0
 .../crypto/powerpc}/aes-spe-modes.S           |    0
 .../crypto/powerpc}/aes-spe-regs.h            |    0
 .../crypto/powerpc}/aes-tab-4k.S              |    0
 lib/crypto/powerpc/aes.h                      |  238 +++
 .../crypto/powerpc}/aesp8-ppc.pl              |    1 +
 lib/crypto/riscv/aes-riscv64-zvkned.S         |   84 ++
 lib/crypto/riscv/aes.h                        |   63 +
 lib/crypto/s390/aes.h                         |  106 ++
 lib/crypto/sparc/aes.h                        |  149 ++
 .../crypto => lib/crypto/sparc}/aes_asm.S     |    0
 lib/crypto/x86/aes-aesni.S                    |  261 ++++
 lib/crypto/x86/aes.h                          |   85 ++
 net/bluetooth/smp.c                           |    8 +-
 111 files changed, 2202 insertions(+), 2957 deletions(-)
 delete mode 100644 arch/arm/crypto/aes-cipher-glue.c
 delete mode 100644 arch/arm/crypto/aes-cipher.h
 delete mode 100644 arch/arm64/crypto/aes-ce-glue.c
 delete mode 100644 arch/arm64/crypto/aes-ce-setkey.h
 delete mode 100644 arch/arm64/crypto/aes-cipher-glue.c
 delete mode 100644 arch/powerpc/crypto/aes.c
 create mode 100644 crypto/aes.c
 delete mode 100644 crypto/aes_generic.c
 delete mode 100644 crypto/aes_ti.c
 rename {arch/arm/crypto => lib/crypto/arm}/aes-cipher-core.S (97%)
 create mode 100644 lib/crypto/arm/aes.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-ce-core.S (100%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-cipher-core.S (96%)
 create mode 100644 lib/crypto/arm64/aes.h
 create mode 100644 lib/crypto/powerpc/.gitignore
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-core.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-keys.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-modes.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-regs.h (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-tab-4k.S (100%)
 create mode 100644 lib/crypto/powerpc/aes.h
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aesp8-ppc.pl (99%)
 create mode 100644 lib/crypto/riscv/aes-riscv64-zvkned.S
 create mode 100644 lib/crypto/riscv/aes.h
 create mode 100644 lib/crypto/s390/aes.h
 create mode 100644 lib/crypto/sparc/aes.h
 rename {arch/sparc/crypto => lib/crypto/sparc}/aes_asm.S (100%)
 create mode 100644 lib/crypto/x86/aes-aesni.S
 create mode 100644 lib/crypto/x86/aes.h


base-commit: e78a3142fa5875126e477fdfe329b0aeb1b0693f
-- 
2.52.0

