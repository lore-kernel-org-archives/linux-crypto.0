Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB9524B29;
	Sun, 23 Mar 2025 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742768657; cv=none; b=ahzgE5oAI80AaHi3eQgp2O9DvM8i1YeH35wgJvOWdNaBXaRz+yllKYmN5S1n6rZ5GBcI3XqBEgnmMaA0R+OZOs6CiWr4aMpE8IYMrqkMNwxEDqjTEqnsE0poGeK2mxsgriMdhF78tuwMrl2YPNvVN2Yecchf9Uxq85DZCknfoe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742768657; c=relaxed/simple;
	bh=pSuPLgb3YUS81mURBOzGRLLehj+iUHT29QAhz8DJIGc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mTtWcHpsXxUN01+d+fz+dTHKBQCJf0NzHRnA/m1VK3B0oGsjnS7hRSSl+N6EJsNM66auUFhBy2BZXdR/NYmW8ZZNEhNiJXGBwaS0+nnQzpM9mdSZo22Dm0MdT4r2MmsBGRwxy01Q1318wRnar5Bvz3FqiNT86zU7EBEx2UUmL0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qYrCNWGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYrCNWGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B934C4CEE2;
	Sun, 23 Mar 2025 22:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742768657;
	bh=pSuPLgb3YUS81mURBOzGRLLehj+iUHT29QAhz8DJIGc=;
	h=Date:From:To:Cc:Subject:From;
	b=qYrCNWGbkDBb/JDwwf394RfwE0N8Wv7N1D3ccFYVIZkXiCzZpRYrTywKtc87gonn2
	 yKkl1XTxMov6pgMjn6cdaKclE6unWWdrslUb8djX8wlsBJvTQIMpXAdCFCSk6yFh+o
	 MXyRHjC+5RJtaLd7fTj6GQw376vJnvD23Gw1DfSd0RvKZT8UfqiKtakuhKG3YqrgwS
	 FlVraDPyAHdJ+X78El44JtVbzMSLTlrEGXaLR41rih0y9suGV45wtalwkzthLZu+Ez
	 Jn+pZDxxE5+FssVmyWR+qx0lX4g5nd4K5GZwK0pzLhsOR6zD/dUvCLR+McpKV5AwNe
	 8i+i9ayDMVhWw==
Date: Sun, 23 Mar 2025 15:24:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	x86@kernel.org, linux-crypto@vger.kernel.org,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Uros Bizjak <ubizjak@gmail.com>
Subject: [GIT PULL] CRC updates for 6.15
Message-ID: <20250323222415.GC9584@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to acf9f8da5e19fc1cbf26f2ecb749369e13e7cd85:

  x86/crc: drop the avx10_256 functions and rename avx10_512 to avx512 (2025-03-19 12:22:00 -0700)

----------------------------------------------------------------

Another set of improvements to the kernel's CRC (cyclic redundancy
check) code:

- Rework the CRC64 library functions to be directly optimized, like what
  I did last cycle for the CRC32 and CRC-T10DIF library functions.

- Rewrite the x86 PCLMULQDQ-optimized CRC code, and add VPCLMULQDQ
  support and acceleration for crc64_be and crc64_nvme.

- Rewrite the riscv Zbc-optimized CRC code, and add acceleration for
  crc_t10dif, crc64_be, and crc64_nvme.

- Remove crc_t10dif and crc64_rocksoft from the crypto API, since they
  are no longer needed there.

- Rename crc64_rocksoft to crc64_nvme, as the old name was incorrect.

- Add kunit test cases for crc64_nvme and crc7.

- Eliminate redundant functions for calculating the Castagnoli CRC32,
  settling on just crc32c().

- Remove unnecessary prompts from some of the CRC kconfig options.

- Further optimize the x86 crc32c code.

----------------------------------------------------------------
Eric Biggers (36):
      lib/crc64-rocksoft: stop wrapping the crypto API
      crypto: crc64-rocksoft - remove from crypto API
      lib/crc64: rename CRC64-Rocksoft to CRC64-NVME
      lib/crc_kunit.c: add test and benchmark for CRC64-NVME
      lib/crc64: add support for arch-optimized implementations
      lib/crc32: remove obsolete CRC32 options from defconfig files
      mips/crc32: remove unused enums
      lib/crc32: use void pointer for data
      lib/crc32: don't bother with pure and const function attributes
      lib/crc32: standardize on crc32c() name for Castagnoli CRC32
      lib/crc32: rename __crc32c_le_combine() to crc32c_combine()
      lib/crc32: remove "_le" from crc32c base and arch functions
      crypto: crct10dif - remove from crypto API
      lib/crc-t10dif: remove crc_t10dif_is_optimized()
      x86: move ZMM exclusion list into CPU feature flag
      scripts/gen-crc-consts: add gen-crc-consts.py
      x86/crc: add "template" for [V]PCLMULQDQ based CRC functions
      x86/crc32: implement crc32_le using new template
      x86/crc-t10dif: implement crc_t10dif using new template
      x86/crc64: implement crc64_be and crc64_nvme using new template
      x86/crc32: improve crc32c_arch() code generation with clang
      x86/crc: add ANNOTATE_NOENDBR to suppress objtool warnings
      riscv/crc: add "template" for Zbc optimized CRC functions
      riscv/crc32: reimplement the CRC32 functions using new template
      riscv/crc-t10dif: add Zbc optimized CRC-T10DIF function
      riscv/crc64: add Zbc optimized CRC64 functions
      x86/crc32: optimize tail handling for crc32c short inputs
      lib/crc_kunit.c: add test and benchmark for crc7_be()
      lib/crc_kunit.c: update comment in crc_benchmark()
      lib/crc7: unexport crc7_be_syndrome_table
      lib/crc: remove unnecessary prompt for CONFIG_CRC4
      lib/crc: remove unnecessary prompt for CONFIG_CRC7
      lib/crc: remove unnecessary prompt for CONFIG_CRC8
      lib/crc: remove unnecessary prompt for CONFIG_LIBCRC32C
      lib/crc: remove unnecessary prompt for CONFIG_CRC64
      x86/crc: drop the avx10_256 functions and rename avx10_512 to avx512

 MAINTAINERS                                    |   1 +
 arch/arm/configs/dove_defconfig                |   1 -
 arch/arm/configs/ep93xx_defconfig              |   1 -
 arch/arm/configs/imx_v6_v7_defconfig           |   2 -
 arch/arm/configs/lpc18xx_defconfig             |   1 -
 arch/arm/configs/moxart_defconfig              |   1 -
 arch/arm/configs/multi_v5_defconfig            |   1 -
 arch/arm/configs/mvebu_v5_defconfig            |   1 -
 arch/arm/configs/mxs_defconfig                 |   1 -
 arch/arm/configs/omap1_defconfig               |   1 -
 arch/arm/configs/omap2plus_defconfig           |   2 -
 arch/arm/configs/spitz_defconfig               |   1 -
 arch/arm/configs/stm32_defconfig               |   1 -
 arch/arm/configs/wpcm450_defconfig             |   1 -
 arch/arm/lib/crc-t10dif-glue.c                 |   6 -
 arch/arm/lib/crc32-glue.c                      |  12 +-
 arch/arm64/lib/crc-t10dif-glue.c               |   6 -
 arch/arm64/lib/crc32-glue.c                    |  10 +-
 arch/hexagon/configs/comet_defconfig           |   1 -
 arch/loongarch/lib/crc32-loongarch.c           |   6 +-
 arch/mips/configs/bcm47xx_defconfig            |   1 -
 arch/mips/configs/bigsur_defconfig             |   1 -
 arch/mips/configs/cobalt_defconfig             |   1 -
 arch/mips/configs/db1xxx_defconfig             |   1 -
 arch/mips/configs/decstation_64_defconfig      |   1 -
 arch/mips/configs/decstation_defconfig         |   1 -
 arch/mips/configs/decstation_r4k_defconfig     |   1 -
 arch/mips/configs/fuloong2e_defconfig          |   1 -
 arch/mips/configs/ip32_defconfig               |   1 -
 arch/mips/configs/rt305x_defconfig             |   1 -
 arch/mips/configs/xway_defconfig               |   1 -
 arch/mips/lib/crc32-mips.c                     |  15 +-
 arch/parisc/configs/generic-64bit_defconfig    |   1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig   |   1 -
 arch/powerpc/configs/adder875_defconfig        |   1 -
 arch/powerpc/configs/ep88xc_defconfig          |   1 -
 arch/powerpc/configs/mpc866_ads_defconfig      |   1 -
 arch/powerpc/configs/mpc885_ads_defconfig      |   1 -
 arch/powerpc/configs/skiroot_defconfig         |   1 -
 arch/powerpc/configs/tqm8xx_defconfig          |   1 -
 arch/powerpc/lib/crc-t10dif-glue.c             |   6 -
 arch/powerpc/lib/crc32-glue.c                  |  10 +-
 arch/riscv/Kconfig                             |   2 +
 arch/riscv/lib/Makefile                        |   5 +
 arch/riscv/lib/crc-clmul-consts.h              | 122 ++++++
 arch/riscv/lib/crc-clmul-template.h            | 265 +++++++++++
 arch/riscv/lib/crc-clmul.h                     |  23 +
 arch/riscv/lib/crc-t10dif.c                    |  24 +
 arch/riscv/lib/crc16_msb.c                     |  18 +
 arch/riscv/lib/crc32-riscv.c                   | 311 -------------
 arch/riscv/lib/crc32.c                         |  53 +++
 arch/riscv/lib/crc32_lsb.c                     |  18 +
 arch/riscv/lib/crc32_msb.c                     |  18 +
 arch/riscv/lib/crc64.c                         |  34 ++
 arch/riscv/lib/crc64_lsb.c                     |  18 +
 arch/riscv/lib/crc64_msb.c                     |  18 +
 arch/s390/configs/debug_defconfig              |   3 -
 arch/s390/configs/defconfig                    |   3 -
 arch/s390/lib/crc32-glue.c                     |   2 +-
 arch/sh/configs/se7206_defconfig               |   2 -
 arch/sh/configs/sh2007_defconfig               |   1 -
 arch/sh/configs/titan_defconfig                |   1 -
 arch/sparc/configs/sparc32_defconfig           |   1 -
 arch/sparc/configs/sparc64_defconfig           |   1 -
 arch/sparc/lib/crc32_glue.c                    |  10 +-
 arch/x86/Kconfig                               |   3 +-
 arch/x86/crypto/aesni-intel_glue.c             |  22 +-
 arch/x86/include/asm/cpufeatures.h             |   1 +
 arch/x86/kernel/cpu/intel.c                    |  22 +
 arch/x86/lib/Makefile                          |   5 +-
 arch/x86/lib/crc-pclmul-consts.h               | 195 +++++++++
 arch/x86/lib/crc-pclmul-template.S             | 582 +++++++++++++++++++++++++
 arch/x86/lib/crc-pclmul-template.h             |  76 ++++
 arch/x86/lib/crc-t10dif-glue.c                 |  29 +-
 arch/x86/lib/crc16-msb-pclmul.S                |   6 +
 arch/x86/lib/crc32-glue.c                      |  57 +--
 arch/x86/lib/crc32-pclmul.S                    | 219 +---------
 arch/x86/lib/crc64-glue.c                      |  50 +++
 arch/x86/lib/crc64-pclmul.S                    |   7 +
 arch/x86/lib/crct10dif-pcl-asm_64.S            | 332 --------------
 block/Kconfig                                  |   2 +-
 block/t10-pi.c                                 |   2 +-
 crypto/Kconfig                                 |  20 -
 crypto/Makefile                                |   3 -
 crypto/crc32c_generic.c                        |   8 +-
 crypto/crc64_rocksoft_generic.c                |  89 ----
 crypto/crct10dif_generic.c                     | 168 -------
 crypto/tcrypt.c                                |   8 -
 crypto/testmgr.c                               |  14 -
 crypto/testmgr.h                               | 303 -------------
 drivers/crypto/stm32/stm32-crc32.c             |   2 +-
 drivers/infiniband/sw/siw/siw.h                |   4 +-
 drivers/md/raid5-cache.c                       |  31 +-
 drivers/md/raid5-ppl.c                         |  16 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |   2 +-
 drivers/thunderbolt/ctl.c                      |   2 +-
 drivers/thunderbolt/eeprom.c                   |   2 +-
 include/linux/crc-t10dif.h                     |  12 -
 include/linux/crc32.h                          |  55 ++-
 include/linux/crc32c.h                         |   8 -
 include/linux/crc64.h                          |  38 +-
 include/linux/crc7.h                           |   7 -
 include/net/sctp/checksum.h                    |   7 +-
 lib/Kconfig                                    |  45 +-
 lib/Kconfig.debug                              |   1 +
 lib/Makefile                                   |   1 -
 lib/crc32.c                                    |  21 +-
 lib/crc64-rocksoft.c                           | 126 ------
 lib/crc64.c                                    |  49 +--
 lib/crc7.c                                     |   6 +-
 lib/crc_kunit.c                                |  68 ++-
 lib/gen_crc64table.c                           |  10 +-
 scripts/gen-crc-consts.py                      | 291 +++++++++++++
 sound/soc/codecs/aw88395/aw88395_device.c      |   2 +-
 tools/testing/selftests/arm64/fp/kernel-test.c |   1 -
 115 files changed, 2121 insertions(+), 1969 deletions(-)
 create mode 100644 arch/riscv/lib/crc-clmul-consts.h
 create mode 100644 arch/riscv/lib/crc-clmul-template.h
 create mode 100644 arch/riscv/lib/crc-clmul.h
 create mode 100644 arch/riscv/lib/crc-t10dif.c
 create mode 100644 arch/riscv/lib/crc16_msb.c
 delete mode 100644 arch/riscv/lib/crc32-riscv.c
 create mode 100644 arch/riscv/lib/crc32.c
 create mode 100644 arch/riscv/lib/crc32_lsb.c
 create mode 100644 arch/riscv/lib/crc32_msb.c
 create mode 100644 arch/riscv/lib/crc64.c
 create mode 100644 arch/riscv/lib/crc64_lsb.c
 create mode 100644 arch/riscv/lib/crc64_msb.c
 create mode 100644 arch/x86/lib/crc-pclmul-consts.h
 create mode 100644 arch/x86/lib/crc-pclmul-template.S
 create mode 100644 arch/x86/lib/crc-pclmul-template.h
 create mode 100644 arch/x86/lib/crc16-msb-pclmul.S
 create mode 100644 arch/x86/lib/crc64-glue.c
 create mode 100644 arch/x86/lib/crc64-pclmul.S
 delete mode 100644 arch/x86/lib/crct10dif-pcl-asm_64.S
 delete mode 100644 crypto/crc64_rocksoft_generic.c
 delete mode 100644 crypto/crct10dif_generic.c
 delete mode 100644 lib/crc64-rocksoft.c
 create mode 100755 scripts/gen-crc-consts.py
