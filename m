Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72921B9C0;
	Mon,  9 Feb 2026 03:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770608619; cv=none; b=NZZkv3yuo0XbDJyr1qtb77s1/N0nqbsoGjg5C0iP/l3O+UQTkBL0sVH4hkdvgdErV+mDah6a9n1A3N2Lnat6ug541hK1erJP8G1tZlQOWuZ3Lxgdn1fou+nBkSvWcZo0fQb6axnJnedIBGEMgwugFvlPZeukW/0xcAjC+iiWzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770608619; c=relaxed/simple;
	bh=c+dzzuCRZMzTPUBpjcKNcZf9kXgt4Yct31n6QH+ir6U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M1rCuQT7dtn6FXI3outes4cZSXPm5ZxC5a2PO6UzR7502pCDgp5VfHSp+BHTLoMkpYcrOfZRMsaWN3JggUyJdSGb5wQdyirjebYdudl4yNnMwBlVOirHlVoYhGFY5u2hixRdGrKCAVcyo2VijU5CP/sgBlam2lfCe7cjaKLtxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoEMuRuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoEMuRuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97096C116C6;
	Mon,  9 Feb 2026 03:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770608618;
	bh=c+dzzuCRZMzTPUBpjcKNcZf9kXgt4Yct31n6QH+ir6U=;
	h=Date:From:To:Cc:Subject:From;
	b=YoEMuRuH+pXo9OOaHoDJ2iQiC7SlMRtQahWeoTWUeft83XXZGYxc6Lhh96xlO489m
	 IfuxmjRolHQBzbbnY/cz0r+vtiD0r4ZEGRt2WRsblnwBC8MOCUD4T61MWUbOim5Jwh
	 AeKoBQNr9sM8Hr3GHDvE8yrideGWPizpb4SIiFPxtLechv3WXJOcPoiuNZM04SzEiz
	 +IAKFr4Lq6CmjktZIOv3zZo3GVEsymxZxJbcM/EIUe+xJWIlbVw/acihqtFZ1xPP/H
	 6e0rgn7eRNXisZvkohipSVbXvEzXJ7aAwb5Ka51r5bwdsE6WyeO5KADE2MCGBTmV/j
	 b2QSTjb0MGP6w==
Date: Sun, 8 Feb 2026 19:42:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	"Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: [GIT PULL] Crypto library updates for 7.0
Message-ID: <20260209034257.GA2604@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 0f61b1860cc3f52aef9036d7235ed1f017632193:

  Linux 6.19-rc5 (2026-01-11 17:03:14 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to ffd42b6d0420c4be97cc28fd1bb5f4c29e286e98:

  lib/crypto: mldsa: Clarify the documentation for mldsa_verify() slightly (2026-02-03 19:28:51 -0800)

----------------------------------------------------------------

- Add support for verifying ML-DSA signatures.

  ML-DSA (Module-Lattice-Based Digital Signature Algorithm) is a
  recently-standardized post-quantum (quantum-resistant) signature
  algorithm. It was known as Dilithium pre-standardization.

  The first use case in the kernel will be module signing. But there
  are also other users of RSA and ECDSA signatures in the kernel that
  might want to upgrade to ML-DSA eventually.

- Improve the AES library:

    - Make the AES key expansion and single block encryption and
      decryption functions use the architecture-optimized AES code.
      Enable these optimizations by default.

    - Support preparing an AES key for encryption-only, using about
      half as much memory as a bidirectional key.

    - Replace the existing two generic implementations of AES with a
      single one.

- Simplify how Adiantum message hashing is implemented. Remove the
  "nhpoly1305" crypto_shash in favor of direct lib/crypto/ support for
  NH hashing, and enable optimizations by default.

----------------------------------------------------------------
Eric Biggers (52):
      lib/crypto: Add ML-DSA verification support
      lib/crypto: tests: Add KUnit tests for ML-DSA verification
      lib/crypto: nh: Add NH library
      lib/crypto: tests: Add KUnit tests for NH
      lib/crypto: arm/nh: Migrate optimized code into library
      lib/crypto: arm64/nh: Migrate optimized code into library
      lib/crypto: x86/nh: Migrate optimized code into library
      crypto: adiantum - Convert to use NH library
      crypto: adiantum - Use scatter_walk API instead of sg_miter
      crypto: adiantum - Use memcpy_{to,from}_sglist()
      crypto: adiantum - Drop support for asynchronous xchacha ciphers
      crypto: nhpoly1305 - Remove crypto_shash support
      crypto: testmgr - Remove nhpoly1305 tests
      fscrypt: Drop obsolete recommendation to enable optimized NHPoly1305
      lib/crypto: nh: Restore dependency of arch code on !KMSAN
      lib/crypto: mldsa: Add FIPS cryptographic algorithm self-test
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
      lib/crypto: aes: Drop 'volatile' from aes_sbox and aes_inv_sbox
      lib/crypto: mldsa: Clarify the documentation for mldsa_verify() slightly

Rusydi H. Makarim (1):
      lib/crypto: md5: Use rol32() instead of open-coding it

 Documentation/filesystems/fscrypt.rst              |    5 -
 arch/arm/configs/milbeaut_m10v_defconfig           |    1 -
 arch/arm/configs/multi_v7_defconfig                |    2 +-
 arch/arm/configs/omap2plus_defconfig               |    2 +-
 arch/arm/configs/pxa_defconfig                     |    2 +-
 arch/arm/crypto/Kconfig                            |   29 -
 arch/arm/crypto/Makefile                           |    4 -
 arch/arm/crypto/aes-cipher-glue.c                  |   69 -
 arch/arm/crypto/aes-cipher.h                       |   13 -
 arch/arm/crypto/aes-neonbs-glue.c                  |   29 +-
 arch/arm/crypto/ghash-ce-glue.c                    |   14 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c             |   80 -
 arch/arm64/crypto/Kconfig                          |   39 +-
 arch/arm64/crypto/Makefile                         |    9 -
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    2 -
 arch/arm64/crypto/aes-ce-glue.c                    |  178 --
 arch/arm64/crypto/aes-ce-setkey.h                  |    6 -
 arch/arm64/crypto/aes-cipher-glue.c                |   63 -
 arch/arm64/crypto/aes-glue.c                       |    2 -
 arch/arm64/crypto/ghash-ce-glue.c                  |   27 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c           |   79 -
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
 arch/powerpc/crypto/Kconfig                        |    2 +-
 arch/powerpc/crypto/Makefile                       |    9 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c             |    4 +-
 arch/powerpc/crypto/aes-spe-glue.c                 |   88 +-
 arch/powerpc/crypto/aes.c                          |  134 --
 arch/powerpc/crypto/aes_cbc.c                      |    4 +-
 arch/powerpc/crypto/aes_ctr.c                      |    2 +-
 arch/powerpc/crypto/aes_xts.c                      |    6 +-
 arch/powerpc/crypto/aesp8-ppc.h                    |   22 -
 arch/powerpc/crypto/vmx.c                          |   10 +-
 arch/riscv/crypto/Kconfig                          |    2 -
 arch/riscv/crypto/aes-macros.S                     |   12 +-
 arch/riscv/crypto/aes-riscv64-glue.c               |   81 +-
 arch/riscv/crypto/aes-riscv64-zvkned.S             |   27 -
 arch/s390/configs/debug_defconfig                  |    2 +-
 arch/s390/configs/defconfig                        |    2 +-
 arch/s390/crypto/Kconfig                           |    2 -
 arch/s390/crypto/aes_s390.c                        |  113 --
 arch/sparc/crypto/Kconfig                          |    2 +-
 arch/sparc/crypto/Makefile                         |    2 +-
 arch/sparc/crypto/aes_glue.c                       |  140 +-
 arch/x86/crypto/Kconfig                            |   22 -
 arch/x86/crypto/Makefile                           |    5 -
 arch/x86/crypto/aes-gcm-aesni-x86_64.S             |   33 +-
 arch/x86/crypto/aes-gcm-vaes-avx2.S                |   21 +-
 arch/x86/crypto/aes-gcm-vaes-avx512.S              |   25 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   25 -
 arch/x86/crypto/aesni-intel_glue.c                 |  119 +-
 arch/x86/crypto/nhpoly1305-avx2-glue.c             |   81 -
 arch/x86/crypto/nhpoly1305-sse2-glue.c             |   80 -
 crypto/Kconfig                                     |   31 +-
 crypto/Makefile                                    |    5 +-
 crypto/adiantum.c                                  |  442 ++---
 crypto/aegis.h                                     |    2 +-
 crypto/aes.c                                       |   66 +
 crypto/aes_generic.c                               | 1320 --------------
 crypto/aes_ti.c                                    |   83 -
 crypto/crypto_user.c                               |    2 +-
 crypto/df_sp80090a.c                               |   30 +-
 crypto/drbg.c                                      |   12 +-
 crypto/nhpoly1305.c                                |  255 ---
 crypto/testmgr.c                                   |   49 +-
 crypto/testmgr.h                                   | 1372 --------------
 drivers/char/tpm/tpm2-sessions.c                   |   10 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |   10 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |    4 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   10 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |   12 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   14 +-
 drivers/crypto/omap-aes-gcm.c                      |    6 +-
 drivers/crypto/omap-aes.h                          |    2 +-
 drivers/crypto/starfive/jh7110-aes.c               |   10 +-
 drivers/crypto/xilinx/xilinx-trng.c                |    8 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |    4 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |    8 +-
 .../chelsio/inline_crypto/chtls/chtls_hw.c         |    4 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |    8 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |   20 +-
 include/crypto/aes.h                               |  278 ++-
 include/crypto/df_sp80090a.h                       |    2 +-
 include/crypto/gcm.h                               |    2 +-
 include/crypto/mldsa.h                             |   62 +
 include/crypto/nh.h                                |   52 +
 include/crypto/nhpoly1305.h                        |   74 -
 lib/crypto/Kconfig                                 |   32 +
 lib/crypto/Makefile                                |   59 +-
 lib/crypto/aes.c                                   |  473 +++--
 lib/crypto/aescfb.c                                |   30 +-
 lib/crypto/aesgcm.c                                |   12 +-
 .../crypto => lib/crypto/arm}/aes-cipher-core.S    |    4 +-
 lib/crypto/arm/aes.h                               |   56 +
 {arch/arm/crypto => lib/crypto/arm}/nh-neon-core.S |    0
 lib/crypto/arm/nh.h                                |   33 +
 .../crypto => lib/crypto/arm64}/aes-ce-core.S      |    0
 .../crypto => lib/crypto/arm64}/aes-cipher-core.S  |    4 +-
 lib/crypto/arm64/aes.h                             |  164 ++
 .../crypto => lib/crypto/arm64}/nh-neon-core.S     |    3 +-
 lib/crypto/arm64/nh.h                              |   34 +
 lib/crypto/fips-mldsa.h                            |  458 +++++
 lib/crypto/md5.c                                   |    2 +-
 lib/crypto/mldsa.c                                 |  682 +++++++
 lib/crypto/nh.c                                    |   82 +
 lib/crypto/powerpc/.gitignore                      |    2 +
 .../crypto => lib/crypto/powerpc}/aes-spe-core.S   |    0
 .../crypto => lib/crypto/powerpc}/aes-spe-keys.S   |    0
 .../crypto => lib/crypto/powerpc}/aes-spe-modes.S  |    0
 .../crypto => lib/crypto/powerpc}/aes-spe-regs.h   |    0
 .../crypto => lib/crypto/powerpc}/aes-tab-4k.S     |    0
 lib/crypto/powerpc/aes.h                           |  238 +++
 .../crypto => lib/crypto/powerpc}/aesp8-ppc.pl     |    1 +
 lib/crypto/riscv/aes-riscv64-zvkned.S              |   84 +
 lib/crypto/riscv/aes.h                             |   63 +
 lib/crypto/s390/aes.h                              |  106 ++
 lib/crypto/sparc/aes.h                             |  149 ++
 {arch/sparc/crypto => lib/crypto/sparc}/aes_asm.S  |    0
 lib/crypto/tests/Kconfig                           |   17 +
 lib/crypto/tests/Makefile                          |    2 +
 lib/crypto/tests/mldsa-testvecs.h                  | 1887 ++++++++++++++++++++
 lib/crypto/tests/mldsa_kunit.c                     |  438 +++++
 lib/crypto/tests/nh-testvecs.h                     |  298 ++++
 lib/crypto/tests/nh_kunit.c                        |   43 +
 lib/crypto/x86/aes-aesni.S                         |  261 +++
 lib/crypto/x86/aes.h                               |   85 +
 .../nh-avx2-x86_64.S => lib/crypto/x86/nh-avx2.S   |    3 +-
 .../nh-sse2-x86_64.S => lib/crypto/x86/nh-sse2.S   |    3 +-
 lib/crypto/x86/nh.h                                |   45 +
 net/bluetooth/smp.c                                |    8 +-
 scripts/crypto/gen-hash-testvecs.py                |   40 +
 141 files changed, 6659 insertions(+), 5255 deletions(-)
 delete mode 100644 arch/arm/crypto/aes-cipher-glue.c
 delete mode 100644 arch/arm/crypto/aes-cipher.h
 delete mode 100644 arch/arm/crypto/nhpoly1305-neon-glue.c
 delete mode 100644 arch/arm64/crypto/aes-ce-glue.c
 delete mode 100644 arch/arm64/crypto/aes-ce-setkey.h
 delete mode 100644 arch/arm64/crypto/aes-cipher-glue.c
 delete mode 100644 arch/arm64/crypto/nhpoly1305-neon-glue.c
 delete mode 100644 arch/powerpc/crypto/aes.c
 delete mode 100644 arch/x86/crypto/nhpoly1305-avx2-glue.c
 delete mode 100644 arch/x86/crypto/nhpoly1305-sse2-glue.c
 create mode 100644 crypto/aes.c
 delete mode 100644 crypto/aes_generic.c
 delete mode 100644 crypto/aes_ti.c
 delete mode 100644 crypto/nhpoly1305.c
 create mode 100644 include/crypto/mldsa.h
 create mode 100644 include/crypto/nh.h
 delete mode 100644 include/crypto/nhpoly1305.h
 rename {arch/arm/crypto => lib/crypto/arm}/aes-cipher-core.S (97%)
 create mode 100644 lib/crypto/arm/aes.h
 rename {arch/arm/crypto => lib/crypto/arm}/nh-neon-core.S (100%)
 create mode 100644 lib/crypto/arm/nh.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-ce-core.S (100%)
 rename {arch/arm64/crypto => lib/crypto/arm64}/aes-cipher-core.S (96%)
 create mode 100644 lib/crypto/arm64/aes.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/nh-neon-core.S (97%)
 create mode 100644 lib/crypto/arm64/nh.h
 create mode 100644 lib/crypto/fips-mldsa.h
 create mode 100644 lib/crypto/mldsa.c
 create mode 100644 lib/crypto/nh.c
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
 create mode 100644 lib/crypto/tests/mldsa-testvecs.h
 create mode 100644 lib/crypto/tests/mldsa_kunit.c
 create mode 100644 lib/crypto/tests/nh-testvecs.h
 create mode 100644 lib/crypto/tests/nh_kunit.c
 create mode 100644 lib/crypto/x86/aes-aesni.S
 create mode 100644 lib/crypto/x86/aes.h
 rename arch/x86/crypto/nh-avx2-x86_64.S => lib/crypto/x86/nh-avx2.S (98%)
 rename arch/x86/crypto/nh-sse2-x86_64.S => lib/crypto/x86/nh-sse2.S (97%)
 create mode 100644 lib/crypto/x86/nh.h
