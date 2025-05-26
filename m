Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1B17E110;
	Mon, 26 May 2025 03:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748231841; cv=none; b=Pnem1enhv6Hc7jQeB1zKkN+l85Ia07R7jl5fQkNF97Hc2pDYDo/07CA/D2ZidbBptHBf64fOQiRYeSHjg4CnuPMX7RJVQh15CDFYNCF8jqlMwnKp6mfy/bsclSmn0C20/PR0jBRqyW3vWS9eGdUw4aSCoLJyeO/zw4DpJxQfEYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748231841; c=relaxed/simple;
	bh=nTMiqDyQmeSUDDggXrYnnZH6rswHKEdAQIT0rslfipE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mNSI2olTX0I2BnfCKEQ/EksoXswhQN+JKs00KtmCGI5nbTtcSXukX5HmVyKOA7uAOpnL2iqcrzzHybYeQMODFodjyb3nnMMOBPSa+GhPNjR/9wRNDtK8FVeJhAs1NXPHC2bN8Kh1DIZlKUSYGLREiEAg4NGe3xSVBfba1sMR2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=E4QNpsTs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="E4QNpsTs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0MIP6JfO6K4D83vnnzKBI6yzFEDL/v74vldD4k54xxU=; b=E4QNpsTsiwXs4OtlxRY28NTijS
	1PvHTg9h9Px3qhEPRfK4rgdSUujwfBPnu3VWXEfVq0c0qukdrBymfhSVFFvdB1myj6o+z62ECPnAJ
	ALTw1pZsOfoeKZYBGc2lb3x35wUTUVnz2EDT3HkZ6uS0K86AdAP9yyuP/6S7Qnc5qEoHsA3mbD0BH
	VfegUQq60KIaukOnIgsqFqoKP+yNeIlPmeooW9KAD4Il8XMDPX2g/zmUhfxe/kAfLnbcTWuBMkyex
	IkXexUMJJXfSH86ACU41ocj8M6IHQoJcP6OLb8PPSKzko7vpVndug3WE2hQcw6Y0QBWkhYaY1uea6
	ykSH111w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJOxV-008xL0-0v;
	Mon, 26 May 2025 11:57:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 May 2025 11:57:05 +0800
Date: Mon, 26 May 2025 11:57:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] Crypto Update for 6.16
Message-ID: <aDPmka4yENceDgPs@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

Conflicts detected in linux-next:

https://patchwork.kernel.org/project/linux-crypto/patch/20250408112830.4769244e@canb.auug.org.au/

tip tree:

  a72d55dc3bd6 ("x86/idle: Remove CONFIG_AS_TPAUSE")

crypto tree:

  984f835009d6 ("crypto: x86 - Remove CONFIG_AS_SHA1_NI")
  d032a27e8fe9 ("crypto: x86 - Remove CONFIG_AS_SHA256_NI")

https://patchwork.kernel.org/project/linux-crypto/patch/20250408112830.4769244e@canb.auug.org.au/

arm-soc-fixes tree:

  6c9ab811871b ("arm64: defconfig: Ensure CRYPTO_CHACHA20_NEON is selected")

crypto tree:

  3357b6c94569 ("crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK")

The resolutions should be trivial in both cases.

The last commit 2297554f01df in the pull request fixes a regression
caused by the addition of arch optimisations to lib/sha256.  The
lib/crypto version of sha256 was used by CPU bring-up on AMD where
the FPU was not yet ready to handle the SIMD instructions.

https://lore.kernel.org/linux-crypto/20250518193212.1822-1-ebiggers@kernel.org/

The patch was been around for a week and there didn't seem to be any
major concerns with it.  However, it didn't make it into the x86 pull
request for 6.16.  In order to prevent an AMD regression, I'm including
it here.

If there are objections, we could instead disable lib/sha256 x86
optimisations.

The following changes since commit 92a09c47464d040866cf2b4cd052bc60555185fb:

  Linux 6.15-rc5 (2025-05-04 13:55:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p1

for you to fetch changes up to 2297554f01df6d3d4e98a3915c183ce3e491740a:

  x86/fpu: Fix irq_fpu_usable() to return false during CPU onlining (2025-05-26 10:58:50 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Fix memcpy_sglist to handle partially overlapping SG lists.
- Use memcpy_sglist to replace null skcipher.
- Rename CRYPTO_TESTS to CRYPTO_BENCHMARK.
- Flip CRYPTO_MANAGER_DISABLE_TEST into CRYPTO_SELFTESTS.
- Hide CRYPTO_MANAGER.
- Add delayed freeing of driver crypto_alg structures.

Compression:

- Allocate large buffers on first use instead of initialisation in scomp.
- Drop destination linearisation buffer in scomp.
- Move scomp stream allocation into acomp.
- Add acomp scatter-gather walker.
- Remove request chaining.
- Add optional async request allocation.

Hashing:

- Remove request chaining.
- Add optional async request allocation.
- Move partial block handling into API.
- Add ahash support to hmac.
- Fix shash documentation to disallow usage in hard IRQs.

Algorithms:

- Remove unnecessary SIMD fallback code on x86 and arm/arm64.
- Drop avx10_256 xts(aes)/ctr(aes) on x86.
- Improve avx-512 optimisations for xts(aes).
- Move chacha arch implementations into lib/crypto.
- Move poly1305 into lib/crypto and drop unused Crypto API algorithm.
- Disable powerpc/poly1305 as it has no SIMD fallback.
- Move sha256 arch implementations into lib/crypto.
- Convert deflate to acomp.
- Set block size correctly in cbcmac.

Drivers:

- Do not use sg_dma_len before mapping in sun8i-ss.
- Fix warm-reboot failure by making shutdown do more work in qat.
- Add locking in zynqmp-sha.
- Remove cavium/zip.
- Add support for PCI device 0x17D8 to ccp.
- Add qat_6xxx support in qat.
- Add support for RK3576 in rockchip-rng.
- Add support for i.MX8QM in caam.

Others:

- Fix irq_fpu_usable/kernel_fpu_begin inconsistency during CPU bring-up.
- Add new SEV/SNP platform shutdown API in ccp.
----------------------------------------------------------------

Abhinaba Rakshit (1):
      dt-bindings: crypto: qcom-qce: document QCS615 crypto engine

Ard Biesheuvel (3):
      crypto: arm/aes-ce - stop using the SIMD helper
      crypto: arm/aes-neonbs - stop using the SIMD helper
      crypto: ctr - remove unused crypto_ctr_encrypt_walk()

Arnd Bergmann (1):
      crypto: qat - add missing header inclusion

Ashish Kalra (9):
      crypto: ccp - Abort doing SEV INIT if SNP INIT fails
      crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown
      crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls
      crypto: ccp - Reset TMR size at SNP Shutdown
      crypto: ccp - Register SNP panic notifier only if SNP is enabled
      crypto: ccp - Add new SEV/SNP platform shutdown API
      KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
      crypto: ccp - Move SEV/SNP Platform initialization to KVM
      crypto: ccp - Fix __sev_snp_shutdown_locked

Bharat Bhushan (2):
      crypto: octeontx2 - Initialize cptlfs device info once
      crypto: octeontx2 - Use dynamic allocated memory region for lmtst

Colin Ian King (1):
      crypto: eip93 - Make read-only arrays static const

Corentin Labbe (1):
      crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions

Dan Carpenter (1):
      crypto: qat/qat_6xxx - Fix NULL vs IS_ERR() check in adf_probe()

Dr. David Alan Gilbert (1):
      crypto: deadcode structs from 'comp' removal

Eric Biggers (78):
      crypto: x86/aes - drop the avx10_256 AES-XTS and AES-CTR code
      crypto: x86/aegis - stop using the SIMD helper
      crypto: x86/aes - stop using the SIMD helper
      crypto: x86/aria - stop using the SIMD helper
      crypto: x86/camellia - stop using the SIMD helper
      crypto: x86/cast - stop using the SIMD helper
      crypto: x86/serpent - stop using the SIMD helper
      crypto: x86/sm4 - stop using the SIMD helper
      crypto: x86/twofish - stop using the SIMD helper
      crypto: x86/aes-xts - optimize _compute_first_set_of_tweaks for AVX-512
      crypto: riscv/chacha - implement library instead of skcipher
      crypto: chacha - centralize the skcipher wrappers for arch code
      crypto: arm/chacha - remove the redundant skcipher algorithms
      crypto: arm64/chacha - remove the skcipher algorithms
      crypto: mips/chacha - remove the skcipher algorithms
      crypto: powerpc/chacha - remove the skcipher algorithms
      crypto: s390/chacha - remove the skcipher algorithms
      crypto: x86/chacha - remove the skcipher algorithms
      crypto: chacha - remove <crypto/internal/chacha.h>
      crypto: powerpc/poly1305 - implement library instead of shash
      crypto: poly1305 - centralize the shash wrappers for arch code
      crypto: arm/poly1305 - remove redundant shash algorithm
      crypto: arm64/poly1305 - remove redundant shash algorithm
      crypto: mips/poly1305 - drop redundant dependency on CONFIG_MIPS
      crypto: mips/poly1305 - remove redundant shash algorithm
      crypto: x86/poly1305 - remove redundant shash algorithm
      crypto: x86/poly1305 - don't select CRYPTO_LIB_POLY1305_GENERIC
      crypto: poly1305 - remove rset and sset fields of poly1305_desc_ctx
      crypto: lib/chacha - restore ability to remove modules
      crypto: lib/poly1305 - restore ability to remove modules
      crypto: arm64 - drop redundant dependencies on ARM64
      crypto: powerpc - drop redundant dependencies on PPC
      crypto: s390 - drop redundant dependencies on S390
      crypto: x86 - drop redundant dependencies on X86
      crypto: arm - move library functions to arch/arm/lib/crypto/
      crypto: arm64 - move library functions to arch/arm64/lib/crypto/
      crypto: mips - move library functions to arch/mips/lib/crypto/
      crypto: powerpc - move library functions to arch/powerpc/lib/crypto/
      crypto: riscv - move library functions to arch/riscv/lib/crypto/
      crypto: s390 - move library functions to arch/s390/lib/crypto/
      crypto: x86 - move library functions to arch/x86/lib/crypto/
      crypto: lib/chacha - remove INTERNAL symbol and selection of CRYPTO
      crypto: lib/poly1305 - remove INTERNAL symbol and selection of CRYPTO
      crypto: sha256 - support arch-optimized lib and expose through shash
      crypto: arm/sha256 - implement library instead of shash
      crypto: arm64/sha256 - remove obsolete chunking logic
      crypto: arm64/sha256 - implement library instead of shash
      crypto: mips/sha256 - implement library instead of shash
      crypto: powerpc/sha256 - implement library instead of shash
      crypto: riscv/sha256 - implement library instead of shash
      crypto: s390/sha256 - implement library instead of shash
      crypto: sparc - move opcodes.h into asm directory
      crypto: sparc/sha256 - implement library instead of shash
      crypto: x86/sha256 - implement library instead of shash
      crypto: sha256 - remove sha256_base.h
      crypto: lib/sha256 - improve function prototypes
      crypto: arm64/sha256 - fix build when CONFIG_PREEMPT_VOLUNTARY=y
      crypto: lib/chacha - strongly type the ChaCha state
      crypto: lib/chacha - use struct assignment to copy state
      crypto: lib/chacha - add strongly-typed state zeroization
      crypto: lib/chacha - add array bounds to function prototypes
      crypto: algif_aead - use memcpy_sglist() instead of null skcipher
      crypto: authenc - use memcpy_sglist() instead of null skcipher
      crypto: gcm - use memcpy_sglist() instead of null skcipher
      crypto: geniv - use memcpy_sglist() instead of null skcipher
      crypto: krb5enc - do not select CRYPTO_NULL
      crypto: null - remove the default null skcipher
      crypto: null - merge CRYPTO_NULL2 into CRYPTO_NULL
      crypto: null - use memcpy_sglist()
      crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
      crypto: testmgr - remove panic_on_fail
      crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
      crypto: testmgr - make it easier to enable the full set of tests
      crypto: testmgr - rename noextratests to noslowtests
      crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
      crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS
      crypto: powerpc/poly1305 - add depends on BROKEN for now
      x86/fpu: Fix irq_fpu_usable() to return false during CPU onlining

Ethan Carter Edwards (2):
      crypto: hisilicon/qm - remove sizeof(char)
      crypto: hisilicon/qm - replace devm_kzalloc with devm_kcalloc

George Abraham P (1):
      crypto: qat - rename and relocate timer logic

Giovanni Cabiddu (11):
      crypto: qat - add shutdown handler to qat_4xxx
      crypto: qat - add shutdown handler to qat_420xx
      crypto: qat - remove redundant prototypes in qat_dh895xcc
      crypto: qat - add shutdown handler to qat_dh895xcc
      crypto: qat - remove redundant prototypes in qat_c62x
      crypto: qat - add shutdown handler to qat_c62x
      crypto: qat - remove redundant prototypes in qat_c3xxx
      crypto: qat - add shutdown handler to qat_c3xxx
      crypto: qat - remove initialization in device class
      crypto: qat - switch to standard pattern for PCI IDs
      crypto: qat - export adf_get_service_mask()

Herbert Xu (211):
      crypto: api - Move alg destroy work from instance to template
      crypto: api - Ensure cra_type->destroy is done in process context
      crypto: scomp - Allocate per-cpu buffer on first use of each CPU
      crypto: acomp - Move scomp stream allocation code into acomp
      crypto: acomp - Add acomp_walk
      crypto: deflate - Convert to acomp
      crypto: crypto4xx - Fix gcc12 uninitialized warning in crypto4xx_crypt
      crypto: cavium - Move cpt and nitrox rules into cavium Makefile
      crypto: cavium/zip - Remove driver
      crypto: scomp - Drop the dst scratch buffer
      crypto: iaa - Move compression CRC into request object
      crypto: iaa - Do not clobber req->base.data
      crypto: iaa - Remove unused disable_async argument from iaa_decompress
      crypto: sa2ul - Use proper helpers to setup request
      MAINTAINERS: Update maintainers for crypto/marvell
      crypto: hash - Do not use shash in hard IRQs
      crypto: x86/chacha - Remove SIMD fallback path
      crypto: ccp - Silence may-be-uninitialized warning in sev_ioctl_do_pdh_export
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: x86/chacha - Restore SSSE3 fallback path
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      Revert "crypto: testmgr - Add multibuffer acomp testing"
      crypto: deflate - Remove request chaining
      crypto: acomp - Remove request chaining
      Revert "crypto: tcrypt - Restore multibuffer ahash tests"
      crypto: ahash - Remove request chaining
      crypto: api - Add helpers to manage request flags
      crypto: acomp - Use request flag helpers and add acomp_request_flags
      crypto: acomp - Add ACOMP_FBREQ_ON_STACK
      crypto: iaa - Switch to ACOMP_FBREQ_ON_STACK
      crypto: acomp - Add ACOMP_REQUEST_CLONE
      ubifs: Use ACOMP_REQUEST_CLONE
      crypto: acomp - Remove ACOMP_REQUEST_ALLOC
      crypto: acomp - Simplify folio handling
      crypto: nx - Add missing header inclusions
      crypto: ccp - Add missing header inclusions
      crypto: s5p-sss - Add missing header inclusions
      crypto: ctr - Remove unnecessary header inclusions
      crypto: api - Mark cra_init/cra_exit as deprecated
      crypto: api - Add reqsize to crypto_alg
      crypto: acomp - Use cra_reqsize
      crypto: qat - Use cra_reqsize for acomp
      crypto: iaa - Use cra_reqsize for acomp
      crypto: acomp - Remove reqsize field
      crypto: ahash - Use cra_reqsize
      crypto: api - Allow delayed algorithm destruction
      crypto: powerpc - Include uaccess.h and others
      asm-generic: Make simd.h more resilient
      arm: Make simd.h more resilient
      x86: Make simd.h more resilient
      crypto: simd - Include asm/simd.h in internal/simd.h
      crypto: api - Add support for duplicating algorithms before registration
      crypto: padlock-sha - Make descsize an algorithm attribute
      crypto: zynqmp-sha - Make descsize an algorithm attribute
      crypto: hmac - Make descsize an algorithm attribute
      crypto: shash - Remove dynamic descsize
      crypto: hash - Add HASH_REQUEST_ON_STACK
      crypto: zynqmp-sha - Add locking
      crypto: arm64/sha512 - Fix header inclusions
      crypto: hash - Update HASH_MAX_DESCSIZE comment
      crypto: lib/sm3 - Move sm3 library into lib/crypto
      crypto: lib/sm3 - Export generic block function
      crypto: sm3-base - Use sm3_init
      crypto: cbcmac - Set block size properly
      crypto: deflate - Make the acomp walk atomic
      crypto: public_key - Make sig/tfm local to if clause in software_key_query
      powerpc/crc: Include uaccess.h and others
      crypto: acomp - Add missing return statements in compress/decompress
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: shash - Handle partial blocks in API
      crypto: blake2b-generic - Use API partial block handling
      crypto: arm/blake2b - Use API partial block handling
      crypto: ghash-generic - Use API partial block handling
      crypto: powerpc/ghash - Use API partial block handling
      crypto: arm/ghash - Use API partial block handling
      crypto: arm64/ghash - Use API partial block handling
      crypto: riscv/ghash - Use API partial block handling
      crypto: s390/ghash - Use API partial block handling
      crypto: x86/ghash - Use API partial block handling
      crypto: md5-generic - Use API partial block handling
      crypto: mips/octeon-md5 - Use API partial block handling
      crypto: powerpc/md5 - Use API partial block handling
      crypto: sparc/md5 - Use API partial block handling
      crypto: x86/sha1 - Use API partial block handling
      crypto: arm64/sha1 - Use API partial block handling
      crypto: mips/octeon-sha1 - Use API partial block handling
      crypto: sha1-generic - Use API partial block handling
      crypto: arm/sha1-ce - Use API partial block handling
      crypto: arm/sha1-neon - Use API partial block handling
      crypto: arm/sha1-asm - Use API partial block handling
      crypto: powerpc/sha1 - Use API partial block handling
      crypto: powerpc/sha1-spe - Use API partial block handling
      crypto: s390/sha1 - Use API partial block handling
      crypto: sparc/sha1 - Use API partial block handling
      crypto: sha1_base - Remove partial block helpers
      crypto: x86/sha256 - Use API partial block handling
      crypto: mips/octeon-sha256 - Use API partial block handling
      crypto: riscv/sha256 - Use API partial block handling
      crypto: sha256-generic - Use API partial block handling
      crypto: arm/sha256-ce - Use API partial block handling
      crypto: arm/sha256-neon - Use API partial block handling
      crypto: arm/sha256-asm - Use API partial block handling
      crypto: arm64/sha256-ce - Use API partial block handling
      crypto: arm64/sha256 - Use API partial block handling
      crypto: powerpc/sha256-spe - Use API partial block handling
      crypto: s390/sha256 - Use API partial block handling
      crypto: sparc/sha256 - Use API partial block handling
      crypto: sha256_base - Remove partial block helpers
      crypto: arm64/sha3-ce - Use API partial block handling
      crypto: s390/sha3 - Use API partial block handling
      crypto: sha3-generic - Use API partial block handling
      crypto: zynqmp-sha - Use API partial block handling
      crypto: x86/sha512 - Use API partial block handling
      crypto: mips/octeon-sha512 - Use API partial block handling
      crypto: riscv/sha512 - Use API partial block handling
      crypto: sha512-generic - Use API partial block handling
      crypto: arm/sha512-neon - Use API partial block handling
      crypto: arm/sha512-asm - Use API partial block handling
      crypto: arm64/sha512-ce - Use API partial block handling
      crypto: arm/sha512 - Use API partial block handling
      crypto: s390/sha512 - Use API partial block handling
      crypto: sparc/sha512 - Use API partial block handling
      crypto: sha512_base - Remove partial block helpers
      crypto: sm3-generic - Use API partial block handling
      crypto: arm64/sm3-ce - Use API partial block handling
      crypto: arm64/sm3-neon - Use API partial block handling
      crypto: riscv/sm3 - Use API partial block handling
      crypto: x86/sm3 - Use API partial block handling
      crypto: lib/sm3 - Remove partial block helpers
      crypto: cbcmac - Use API partial block handling
      crypto: cmac - Use API partial block handling
      crypto: xcbc - Use API partial block handling
      crypto: arm64/aes - Use API partial block handling
      crypto: arm64/sm4 - Use API partial block handling
      crypto: nx - Use API partial block handling
      crypto: padlock-sha - Use API partial block handling
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: engine - Remove CRYPTO_ALG_ENGINE bit
      crypto: arm/blake2b - Set FINAL_NONZERO
      crypto: arm64/sha1 - Set finalize for short finup
      crypto: api - Add crypto_request_clone and fb
      crypto: hash - Fix clone error handling
      crypto: arm64/polyval - Use API partial block handling
      crypto: x86/polyval - Use API partial block handling
      crypto: polyval-generic - Use API partial block handling
      crypto: api - Add crypto_stack_request_init and initialise flags fully
      crypto: ccp - Include crypto/utils.h for crypto_memneq
      crypto: scatterwalk - Move skcipher walk and use it for memcpy_sglist
      crypto: s390/sha512 - Fix sha512 state size
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux v6.15-rc5
      crypto: lib/sha256 - Move partial block handling out
      crypto: lib/poly1305 - Add block-only interface
      crypto: arm/poly1305 - Add block-only interface
      crypto: arm64/poly1305 - Add block-only interface
      crypto: mips/poly1305 - Add block-only interface
      crypto: powerpc/poly1305 - Add block-only interface
      crypto: x86/poly1305 - Add block-only interface
      crypto: chacha20poly1305 - Use lib/crypto poly1305
      crypto: testmgr - Remove poly1305
      crypto: poly1305 - Remove algorithm
      crypto: lib/poly1305 - Use block-only interface
      crypto: rmd160 - Use API partial block handling
      crypto: streebog - Use API partial block handling
      crypto: s390/hmac - Extend hash length counters to 128 bits
      Revert "crypto: run initcalls for generic implementations earlier"
      crypto: x86/blake2s - Include linux/init.h
      crypto: acomp - Clone folios properly
      crypto: api - Rename CRYPTO_ALG_REQ_CHAIN to CRYPTO_ALG_REQ_VIRT
      crypto: lib/sha256 - Add helpers for block-based shash
      crypto: sha256 - Use the partial block API for generic
      crypto: arch/sha256 - Export block functions as GPL only
      crypto: arm/sha256 - Add simd block function
      crypto: arm64/sha256 - Add simd block function
      crypto: riscv/sha256 - Add simd block function
      crypto: x86/sha256 - Add simd block function
      crypto: lib/sha256 - Use generic block helper
      crypto: sha256 - Use the partial block API
      crypto: s390/hmac - Use API partial block handling
      crypto: zynqmp-sha - Fix partial block implementation
      crypto: shash - Cap state size to HASH_MAX_STATESIZE
      crypto: shash - Mark shash algorithms as REQ_VIRT
      crypto: ahash - Enforce MAX_SYNC_HASH_REQSIZE for sync ahash
      crypto: ahash - Add core export and import
      crypto: ahash - Add HASH_REQUEST_ZERO
      crypto: padlock-sha - Use core import and export for fallback
      crypto: s390/sha512 - Initialise upper counter to zero for sha384
      crypto: lib/poly1305 - Build main library on LIB_POLY1305 and split generic code out
      um: Include linux/types.h in asm/fpu/api.h
      crypto: powerpc/poly1305 - Add missing poly1305_emit_arch
      crypto: powerpc/poly1305 - Add poly1305_emit_arch wrapper
      crypto: crypto4xx - Remove ahash-related code
      crypto: powerpc/poly1305 - Add SIMD fallback
      crypto: marvell/cesa - Handle zero-length skcipher requests
      crypto: marvell/cesa - Avoid empty transfer descriptor
      crypto: hash - Move core export and import into internel/hash.h
      crypto: hash - Add export_core and import_core hooks
      crypto: ahash - Handle partial blocks in API
      crypto: hmac - Zero shash desc in setkey
      crypto: hmac - Add export_core and import_core
      crypto: shash - Set reqsize in shash_alg
      crypto: algapi - Add driver template support to crypto_inst_setname
      crypto: testmgr - Ignore EEXIST on shash allocation
      crypto: hmac - Add ahash support
      crypto: testmgr - Use ahash for generic tfm
      crypto: testmgr - Add hash export format testing
      crypto: lrw - Only add ecb if it is not already there
      crypto: xts - Only add ecb if it is not already there
      Revert "crypto: powerpc/poly1305 - Add SIMD fallback"
      crypto: marvell/cesa - Do not chain submitted requests
      Revert "crypto: testmgr - Add hash export format testing"
      crypto: api - Redo lookup on EEXIST

Jack Xu (2):
      crypto: qat - refactor FW signing algorithm
      crypto: qat - add GEN6 firmware loader

John Allen (1):
      crypto: ccp - Add support for PCI device 0x17D8

Kees Cook (1):
      crypto: iaa - Adjust workqueue allocation type

Laurent M Coquerel (1):
      crypto: qat - add qat_6xxx driver

Lukas Wunner (2):
      crypto: ecdsa - Fix enc/dec size reported by KEYCTL_PKEY_QUERY
      crypto: ecdsa - Fix NIST P521 key size reported by KEYCTL_PKEY_QUERY

Mario Limonciello (2):
      crypto: ccp - Add missing bootloader info reg for pspv5
      crypto: ccp - Add missing tee info reg for teev2

Nathan Chancellor (1):
      crypto: riscv - Use SYM_FUNC_START for functions only called directly

Nicolas Frattaroli (2):
      dt-bindings: rng: rockchip,rk3588-rng: add rk3576-rng compatible
      hwrng: rockchip - add support for RK3576's RNG

Ovidiu Panait (20):
      crypto: omap-aes - use dev_groups to register attribute groups
      crypto: omap-sham - use dev_groups to register attribute groups
      crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()
      crypto: sun8i-ce-hash - remove duplicated fallback checks
      crypto: sun8i-ce-hash - factor out debugfs fallback statistics
      crypto: sun8i-ce-hash - drop CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG ifdefs
      crypto: sun8i-ce-hash - add IS_ENABLED() checks to debugfs stats
      crypto: sun8i-ce-hash - use API helpers to setup fallback request
      crypto: img-hash - use API helpers to setup fallback request
      crypto: rk3288 - use API helpers to setup fallback request
      crypto: tegra - use API helpers to setup fallback request
      crypto: sun8i-ss - use API helpers to setup fallback request
      crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()
      crypto: sun8i-ce-cipher - use crypto_skcipher_driver_name()
      crypto: sun8i-ce-cipher - use IS_ENABLED() checks for debugfs stats
      crypto: sun8i-ce-cipher - use pm_runtime_resume_and_get()
      crypto: rng - fix documentation for crypto_rng_alg()
      crypto: sun8i-ce - undo runtime PM changes during driver removal
      crypto: sun8i-ce-hash - use pm_runtime_resume_and_get()
      crypto: sun8i-ce - move fallback ahash_request to the end of the struct

Rob Herring (Arm) (8):
      dt-bindings: crypto: fsl,sec-v4.0: Add fsl,sec-v6.0
      dt-bindings: crypto: Drop obsolete mediatek,eip97-crypto
      dt-bindings: crypto: Convert amd,ccp-seattle-v1a to DT schema
      dt-bindings: crypto: Convert axis,artpec6-crypto to DT schema
      dt-bindings: crypto: Convert brcm,spum-crypto to DT schema
      dt-bindings: crypto: Convert hisilicon,hip0{6,7}-sec to DT schema
      dt-bindings: crypto: Convert img,hash-accelerator to DT schema
      dt-bindings: crypto: Convert Marvell CESA to DT schema

Sakari Ailus (3):
      hwrng: atmel - Add struct device pointer to device context struct
      hwrng: mtk - Add struct device pointer to device context struct
      hwrng: npcm - Add struct device pointer to device context struct

Suman Kumar Chakraborty (10):
      crypto: qat - remove BITS_IN_DWORD()
      crypto: qat - include qat_common in top Makefile
      crypto: qat - refactor compression template logic
      crypto: qat - use pr_fmt() in qat uclo.c
      crypto: qat - expose configuration functions
      crypto: qat - export adf_init_admin_pm()
      crypto: qat - update firmware api
      crypto: qat - add firmware headers for GEN6 devices
      crypto: qat - enable RAS support for GEN6 devices
      crypto: qat - enable reporting of error counters for GEN6 devices

Thomas Richard (1):
      crypto: caam - Add support for i.MX8QM

Thorsten Blum (5):
      crypto: x509 - Replace kmalloc() + NUL-termination with kzalloc()
      crypto: essiv - Remove unnecessary strscpy() size argument
      crypto: skcipher - Realign struct skcipher_walk to save 8 bytes
      crypto: engine - Realign struct crypto_engine to save 8 bytes
      crypto: octeontx2 - Simplify multiple return statements

Uros Bizjak (3):
      crypto: x86 - Remove CONFIG_AS_SHA1_NI
      crypto: x86 - Remove CONFIG_AS_SHA256_NI
      crypto: x86 - Remove CONFIG_AS_AVX512 handling

Yury Norov (1):
      crypto: iaa - Optimize rebalance_wq_table()

Zixun LI (1):
      crypto: atmel - add CRYPTO_ALG_KERN_DRIVER_ONLY flag

 Documentation/ABI/testing/sysfs-driver-qat_ras     |    8 +-
 .../bindings/crypto/amd,ccp-seattle-v1a.yaml       |   38 +
 .../devicetree/bindings/crypto/amd-ccp.txt         |   17 -
 .../devicetree/bindings/crypto/artpec6-crypto.txt  |   16 -
 .../bindings/crypto/axis,artpec6-crypto.yaml       |   39 +
 .../devicetree/bindings/crypto/brcm,spu-crypto.txt |   22 -
 .../bindings/crypto/brcm,spum-crypto.yaml          |   44 +
 .../devicetree/bindings/crypto/fsl,sec-v4.0.yaml   |   10 +-
 .../devicetree/bindings/crypto/fsl-sec6.txt        |  157 ---
 .../bindings/crypto/hisilicon,hip06-sec.yaml       |  134 ++
 .../bindings/crypto/hisilicon,hip07-sec.txt        |   67 -
 .../bindings/crypto/img,hash-accelerator.yaml      |   69 +
 .../devicetree/bindings/crypto/img-hash.txt        |   27 -
 .../bindings/crypto/marvell,orion-crypto.yaml      |  133 ++
 .../devicetree/bindings/crypto/marvell-cesa.txt    |   44 -
 .../devicetree/bindings/crypto/mediatek-crypto.txt |   25 -
 .../devicetree/bindings/crypto/mv_cesa.txt         |   32 -
 .../devicetree/bindings/crypto/qcom-qce.yaml       |    1 +
 .../bindings/rng/rockchip,rk3588-rng.yaml          |    5 +-
 MAINTAINERS                                        |    4 +-
 arch/arm/configs/exynos_defconfig                  |    3 +-
 arch/arm/configs/milbeaut_m10v_defconfig           |    4 +-
 arch/arm/configs/multi_v7_defconfig                |    1 -
 arch/arm/configs/omap2plus_defconfig               |    1 -
 arch/arm/configs/pxa_defconfig                     |    4 +-
 arch/arm/configs/spitz_defconfig                   |    2 +-
 arch/arm/crypto/Kconfig                            |   59 -
 arch/arm/crypto/Makefile                           |   20 +-
 arch/arm/crypto/aes-ce-glue.c                      |  104 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |  118 +-
 arch/arm/crypto/blake2b-neon-glue.c                |   21 +-
 arch/arm/crypto/chacha-glue.c                      |  352 -----
 arch/arm/crypto/ghash-ce-glue.c                    |  110 +-
 arch/arm/crypto/poly1305-glue.c                    |  274 ----
 arch/arm/crypto/sha1-ce-glue.c                     |   36 +-
 arch/arm/crypto/sha1.h                             |   14 -
 arch/arm/crypto/sha1_glue.c                        |   33 +-
 arch/arm/crypto/sha1_neon_glue.c                   |   39 +-
 arch/arm/crypto/sha2-ce-glue.c                     |  109 --
 arch/arm/crypto/sha256_glue.c                      |  117 --
 arch/arm/crypto/sha256_glue.h                      |   15 -
 arch/arm/crypto/sha256_neon_glue.c                 |   92 --
 arch/arm/crypto/sha512-glue.c                      |   36 +-
 arch/arm/crypto/sha512-neon-glue.c                 |   43 +-
 arch/arm/crypto/sha512.h                           |    6 -
 arch/arm/include/asm/simd.h                        |    8 +-
 arch/arm/lib/Makefile                              |    2 +
 arch/arm/lib/crypto/.gitignore                     |    3 +
 arch/arm/lib/crypto/Kconfig                        |   31 +
 arch/arm/lib/crypto/Makefile                       |   32 +
 arch/arm/{ => lib}/crypto/blake2s-core.S           |    0
 arch/arm/{ => lib}/crypto/blake2s-glue.c           |    0
 arch/arm/lib/crypto/chacha-glue.c                  |  138 ++
 arch/arm/{ => lib}/crypto/chacha-neon-core.S       |    2 +-
 arch/arm/{ => lib}/crypto/chacha-scalar-core.S     |    5 +-
 arch/arm/{ => lib}/crypto/poly1305-armv4.pl        |    4 +-
 arch/arm/lib/crypto/poly1305-glue.c                |   80 ++
 arch/arm/{ => lib}/crypto/sha256-armv4.pl          |   20 +-
 .../sha2-ce-core.S => lib/crypto/sha256-ce.S}      |   10 +-
 arch/arm/lib/crypto/sha256.c                       |   64 +
 arch/arm64/configs/defconfig                       |    3 +-
 arch/arm64/crypto/Kconfig                          |   53 +-
 arch/arm64/crypto/Makefile                         |   20 +-
 arch/arm64/crypto/aes-glue.c                       |  124 +-
 arch/arm64/crypto/chacha-neon-glue.c               |  237 ----
 arch/arm64/crypto/ghash-ce-glue.c                  |  151 +--
 arch/arm64/crypto/poly1305-glue.c                  |  232 ----
 arch/arm64/crypto/polyval-ce-glue.c                |   73 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   68 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |  192 ---
 arch/arm64/crypto/sha256-glue.c                    |  194 ---
 arch/arm64/crypto/sha3-ce-glue.c                   |  107 +-
 arch/arm64/crypto/sha512-ce-glue.c                 |   49 +-
 arch/arm64/crypto/sha512-glue.c                    |   35 +-
 arch/arm64/crypto/sm3-ce-glue.c                    |   48 +-
 arch/arm64/crypto/sm3-neon-glue.c                  |   48 +-
 arch/arm64/crypto/sm4-ce-glue.c                    |  100 +-
 arch/arm64/lib/Makefile                            |    3 +
 arch/arm64/lib/crypto/.gitignore                   |    3 +
 arch/arm64/lib/crypto/Kconfig                      |   20 +
 arch/arm64/lib/crypto/Makefile                     |   24 +
 arch/arm64/{ => lib}/crypto/chacha-neon-core.S     |    2 +-
 arch/arm64/lib/crypto/chacha-neon-glue.c           |  119 ++
 arch/arm64/{ => lib}/crypto/poly1305-armv8.pl      |    0
 arch/arm64/lib/crypto/poly1305-glue.c              |   73 ++
 .../sha512-armv8.pl => lib/crypto/sha2-armv8.pl}   |    2 +-
 .../sha2-ce-core.S => lib/crypto/sha256-ce.S}      |   41 +-
 arch/arm64/lib/crypto/sha256.c                     |   75 ++
 arch/loongarch/configs/loongson3_defconfig         |    2 +-
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
 arch/mips/cavium-octeon/Kconfig                    |    6 +
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |  119 +-
 arch/mips/cavium-octeon/crypto/octeon-sha1.c       |  136 +-
 arch/mips/cavium-octeon/crypto/octeon-sha256.c     |  252 +---
 arch/mips/cavium-octeon/crypto/octeon-sha512.c     |  155 +--
 arch/mips/configs/cavium_octeon_defconfig          |    1 -
 arch/mips/configs/decstation_64_defconfig          |    1 -
 arch/mips/configs/decstation_defconfig             |    1 -
 arch/mips/configs/decstation_r4k_defconfig         |    1 -
 arch/mips/configs/gpr_defconfig                    |    2 +-
 arch/mips/configs/ip28_defconfig                   |    1 -
 arch/mips/configs/lemote2f_defconfig               |    2 +-
 arch/mips/configs/mtx1_defconfig                   |    2 +-
 arch/mips/configs/rb532_defconfig                  |    2 +-
 arch/mips/crypto/Kconfig                           |   33 -
 arch/mips/crypto/Makefile                          |   17 -
 arch/mips/crypto/chacha-glue.c                     |  146 ---
 arch/mips/crypto/poly1305-glue.c                   |  192 ---
 arch/mips/lib/Makefile                             |    2 +
 arch/mips/lib/crypto/.gitignore                    |    2 +
 arch/mips/lib/crypto/Kconfig                       |   12 +
 arch/mips/lib/crypto/Makefile                      |   19 +
 arch/mips/{ => lib}/crypto/chacha-core.S           |    0
 arch/mips/lib/crypto/chacha-glue.c                 |   29 +
 arch/mips/lib/crypto/poly1305-glue.c               |   33 +
 arch/mips/{ => lib}/crypto/poly1305-mips.pl        |   12 +-
 arch/parisc/configs/generic-32bit_defconfig        |    2 +-
 arch/parisc/configs/generic-64bit_defconfig        |    1 -
 arch/powerpc/configs/g5_defconfig                  |    2 +-
 arch/powerpc/configs/powernv_defconfig             |    2 +-
 arch/powerpc/configs/ppc64_defconfig               |    2 +-
 arch/powerpc/configs/ppc64e_defconfig              |    2 +-
 arch/powerpc/configs/ppc6xx_defconfig              |    2 +-
 arch/powerpc/crypto/Kconfig                        |   44 +-
 arch/powerpc/crypto/Makefile                       |    6 -
 arch/powerpc/crypto/aes.c                          |    8 +-
 arch/powerpc/crypto/aes_cbc.c                      |    4 +
 arch/powerpc/crypto/aes_ctr.c                      |    4 +
 arch/powerpc/crypto/aes_xts.c                      |    4 +
 arch/powerpc/crypto/chacha-p10-glue.c              |  221 ----
 arch/powerpc/crypto/ghash.c                        |   91 +-
 arch/powerpc/crypto/md5-glue.c                     |   99 +-
 arch/powerpc/crypto/poly1305-p10-glue.c            |  186 ---
 arch/powerpc/crypto/sha1-spe-glue.c                |  132 +-
 arch/powerpc/crypto/sha1.c                         |  101 +-
 arch/powerpc/crypto/sha256-spe-glue.c              |  235 ----
 arch/powerpc/lib/Makefile                          |    2 +
 arch/powerpc/lib/crc-t10dif-glue.c                 |   16 +-
 arch/powerpc/lib/crc32-glue.c                      |   15 +-
 arch/powerpc/lib/crypto/Kconfig                    |   22 +
 arch/powerpc/lib/crypto/Makefile                   |   10 +
 arch/powerpc/lib/crypto/chacha-p10-glue.c          |  100 ++
 arch/powerpc/{ => lib}/crypto/chacha-p10le-8x.S    |    6 +-
 arch/powerpc/lib/crypto/poly1305-p10-glue.c        |   96 ++
 arch/powerpc/{ => lib}/crypto/poly1305-p10le_64.S  |    0
 arch/powerpc/{ => lib}/crypto/sha256-spe-asm.S     |    0
 arch/powerpc/lib/crypto/sha256.c                   |   70 +
 arch/riscv/crypto/Kconfig                          |   23 +-
 arch/riscv/crypto/Makefile                         |    6 -
 arch/riscv/crypto/chacha-riscv64-glue.c            |  101 --
 arch/riscv/crypto/ghash-riscv64-glue.c             |   58 +-
 arch/riscv/crypto/sha256-riscv64-glue.c            |  137 --
 arch/riscv/crypto/sha512-riscv64-glue.c            |   47 +-
 arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S     |    4 +-
 arch/riscv/crypto/sm3-riscv64-glue.c               |   49 +-
 arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S         |    4 +-
 arch/riscv/lib/Makefile                            |    1 +
 arch/riscv/lib/crypto/Kconfig                      |   16 +
 arch/riscv/lib/crypto/Makefile                     |    7 +
 arch/riscv/lib/crypto/chacha-riscv64-glue.c        |   75 ++
 arch/riscv/{ => lib}/crypto/chacha-riscv64-zvkb.S  |   71 +-
 .../crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S  |    8 +-
 arch/riscv/lib/crypto/sha256.c                     |   67 +
 arch/s390/configs/debug_defconfig                  |    5 +-
 arch/s390/configs/defconfig                        |    5 +-
 arch/s390/crypto/Kconfig                           |   33 -
 arch/s390/crypto/Makefile                          |    4 -
 arch/s390/crypto/chacha-glue.c                     |  124 --
 arch/s390/crypto/ghash_s390.c                      |  110 +-
 arch/s390/crypto/hmac_s390.c                       |  170 ++-
 arch/s390/crypto/sha.h                             |   22 +-
 arch/s390/crypto/sha1_s390.c                       |   22 +-
 arch/s390/crypto/sha256_s390.c                     |  143 ---
 arch/s390/crypto/sha3_256_s390.c                   |   60 +-
 arch/s390/crypto/sha3_512_s390.c                   |   67 +-
 arch/s390/crypto/sha512_s390.c                     |   62 +-
 arch/s390/crypto/sha_common.c                      |   84 +-
 arch/s390/lib/Makefile                             |    1 +
 arch/s390/lib/crypto/Kconfig                       |   13 +
 arch/s390/lib/crypto/Makefile                      |    6 +
 arch/s390/lib/crypto/chacha-glue.c                 |   56 +
 arch/s390/{ => lib}/crypto/chacha-s390.S           |    0
 arch/s390/{ => lib}/crypto/chacha-s390.h           |    0
 arch/s390/lib/crypto/sha256.c                      |   47 +
 arch/sh/configs/migor_defconfig                    |    1 -
 arch/sparc/configs/sparc64_defconfig               |    2 +-
 arch/sparc/crypto/Kconfig                          |   10 -
 arch/sparc/crypto/Makefile                         |    2 -
 arch/sparc/crypto/aes_asm.S                        |    3 +-
 arch/sparc/crypto/aes_glue.c                       |    3 +-
 arch/sparc/crypto/camellia_asm.S                   |    3 +-
 arch/sparc/crypto/camellia_glue.c                  |    3 +-
 arch/sparc/crypto/des_asm.S                        |    3 +-
 arch/sparc/crypto/des_glue.c                       |    3 +-
 arch/sparc/crypto/md5_asm.S                        |    3 +-
 arch/sparc/crypto/md5_glue.c                       |  142 +--
 arch/sparc/crypto/sha1_asm.S                       |    3 +-
 arch/sparc/crypto/sha1_glue.c                      |  112 +-
 arch/sparc/crypto/sha256_glue.c                    |  210 ---
 arch/sparc/crypto/sha512_asm.S                     |    3 +-
 arch/sparc/crypto/sha512_glue.c                    |  105 +-
 arch/sparc/{crypto => include/asm}/opcodes.h       |    6 +-
 arch/sparc/lib/Makefile                            |    1 +
 arch/sparc/lib/crc32c_asm.S                        |    3 +-
 arch/sparc/lib/crypto/Kconfig                      |    8 +
 arch/sparc/lib/crypto/Makefile                     |    4 +
 arch/sparc/lib/crypto/sha256.c                     |   64 +
 arch/sparc/{ => lib}/crypto/sha256_asm.S           |    5 +-
 arch/um/include/asm/fpu/api.h                      |    2 +
 arch/x86/Kconfig.assembler                         |    9 -
 arch/x86/crypto/Kconfig                            |  131 +-
 arch/x86/crypto/Makefile                           |   23 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |   13 +-
 arch/x86/crypto/aes-ctr-avx-x86_64.S               |   47 +-
 arch/x86/crypto/aes-xts-avx-x86_64.S               |  206 +--
 arch/x86/crypto/aesni-intel_glue.c                 |  174 +--
 arch/x86/crypto/aria_aesni_avx2_glue.c             |   22 +-
 arch/x86/crypto/aria_aesni_avx_glue.c              |   20 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c            |   22 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |   21 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |   21 +-
 arch/x86/crypto/cast5_avx_glue.c                   |   21 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   20 +-
 arch/x86/crypto/chacha_glue.c                      |  311 -----
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    5 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |  301 +----
 arch/x86/crypto/poly1305_glue.c                    |  290 -----
 arch/x86/crypto/polyval-clmulni_glue.c             |   72 +-
 arch/x86/crypto/serpent_avx2_glue.c                |   21 +-
 arch/x86/crypto/serpent_avx_glue.c                 |   21 +-
 arch/x86/crypto/serpent_sse2_glue.c                |   21 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |   91 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |  467 -------
 arch/x86/crypto/sha512_ssse3_glue.c                |   79 +-
 arch/x86/crypto/sm3_avx_glue.c                     |   54 +-
 arch/x86/crypto/sm4_aesni_avx2_glue.c              |   31 +-
 arch/x86/crypto/sm4_aesni_avx_glue.c               |   31 +-
 arch/x86/crypto/twofish_avx_glue.c                 |   21 +-
 arch/x86/include/asm/fpu/api.h                     |    1 +
 arch/x86/include/asm/simd.h                        |    6 +
 arch/x86/kernel/fpu/core.c                         |   34 +-
 arch/x86/kernel/fpu/init.c                         |    3 +
 arch/x86/kernel/smpboot.c                          |    6 +
 arch/x86/kvm/svm/sev.c                             |   12 +
 arch/x86/lib/Makefile                              |    2 +
 arch/x86/lib/crypto/.gitignore                     |    2 +
 arch/x86/lib/crypto/Kconfig                        |   34 +
 arch/x86/lib/crypto/Makefile                       |   20 +
 arch/x86/{ => lib}/crypto/blake2s-core.S           |    4 -
 arch/x86/{ => lib}/crypto/blake2s-glue.c           |   18 +-
 arch/x86/{ => lib}/crypto/chacha-avx2-x86_64.S     |    0
 arch/x86/{ => lib}/crypto/chacha-avx512vl-x86_64.S |    0
 arch/x86/{ => lib}/crypto/chacha-ssse3-x86_64.S    |    0
 arch/x86/lib/crypto/chacha_glue.c                  |  196 +++
 .../{ => lib}/crypto/poly1305-x86_64-cryptogams.pl |   41 +-
 arch/x86/lib/crypto/poly1305_glue.c                |  129 ++
 arch/x86/{ => lib}/crypto/sha256-avx-asm.S         |   12 +-
 arch/x86/{ => lib}/crypto/sha256-avx2-asm.S        |   12 +-
 .../sha256_ni_asm.S => lib/crypto/sha256-ni-asm.S} |   36 +-
 arch/x86/{ => lib}/crypto/sha256-ssse3-asm.S       |   14 +-
 arch/x86/lib/crypto/sha256.c                       |   80 ++
 crypto/842.c                                       |    6 +-
 crypto/Kconfig                                     |   82 +-
 crypto/Makefile                                    |   12 +-
 crypto/acompress.c                                 |  410 ++++--
 crypto/adiantum.c                                  |    2 +-
 crypto/aead.c                                      |    1 +
 crypto/aegis128-core.c                             |    2 +-
 crypto/aes_generic.c                               |    2 +-
 crypto/ahash.c                                     |  809 ++++++------
 crypto/akcipher.c                                  |    1 +
 crypto/algapi.c                                    |   82 +-
 crypto/algboss.c                                   |   10 +-
 crypto/algif_aead.c                                |  101 +-
 crypto/ansi_cprng.c                                |    2 +-
 crypto/anubis.c                                    |    2 +-
 crypto/api.c                                       |   37 +-
 crypto/arc4.c                                      |    2 +-
 crypto/aria_generic.c                              |    2 +-
 crypto/asymmetric_keys/public_key.c                |   36 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |    3 +-
 crypto/authenc.c                                   |   34 +-
 crypto/authencesn.c                                |   40 +-
 crypto/blake2b_generic.c                           |   33 +-
 crypto/blowfish_generic.c                          |    2 +-
 crypto/camellia_generic.c                          |    2 +-
 crypto/cast5_generic.c                             |    2 +-
 crypto/cast6_generic.c                             |    2 +-
 crypto/cbc.c                                       |    2 +-
 crypto/ccm.c                                       |   63 +-
 crypto/chacha.c                                    |  260 ++++
 crypto/chacha20poly1305.c                          |  325 +----
 crypto/chacha_generic.c                            |  139 --
 crypto/cmac.c                                      |   94 +-
 crypto/crc32_generic.c                             |    2 +-
 crypto/crc32c_generic.c                            |    2 +-
 crypto/cryptd.c                                    |    2 +-
 crypto/crypto_engine.c                             |   31 +-
 crypto/crypto_null.c                               |   72 +-
 crypto/ctr.c                                       |    2 +-
 crypto/cts.c                                       |    2 +-
 crypto/curve25519-generic.c                        |    2 +-
 crypto/deflate.c                                   |  395 +++---
 crypto/des_generic.c                               |    2 +-
 crypto/dh.c                                        |    2 +-
 crypto/drbg.c                                      |    2 +-
 crypto/ecb.c                                       |    2 +-
 crypto/ecdh.c                                      |    2 +-
 crypto/ecdsa-p1363.c                               |    6 +-
 crypto/ecdsa-x962.c                                |    5 +-
 crypto/ecdsa.c                                     |    4 +-
 crypto/echainiv.c                                  |   20 +-
 crypto/ecrdsa.c                                    |    2 +-
 crypto/essiv.c                                     |    5 +-
 crypto/fcrypt.c                                    |    2 +-
 crypto/fips.c                                      |    2 +-
 crypto/gcm.c                                       |   43 +-
 crypto/geniv.c                                     |   13 +-
 crypto/ghash-generic.c                             |   58 +-
 crypto/hctr2.c                                     |    2 +-
 crypto/hkdf.c                                      |    2 +-
 crypto/hmac.c                                      |  398 +++++-
 crypto/internal.h                                  |    9 +-
 crypto/kdf_sp800108.c                              |    2 +-
 crypto/khazad.c                                    |    2 +-
 crypto/kpp.c                                       |    1 +
 crypto/krb5enc.c                                   |    2 +-
 crypto/lrw.c                                       |    6 +-
 crypto/lskcipher.c                                 |    1 +
 crypto/lz4.c                                       |    6 +-
 crypto/lz4hc.c                                     |    6 +-
 crypto/lzo-rle.c                                   |    6 +-
 crypto/lzo.c                                       |    6 +-
 crypto/md4.c                                       |    2 +-
 crypto/md5.c                                       |  104 +-
 crypto/michael_mic.c                               |    2 +-
 crypto/nhpoly1305.c                                |    2 +-
 crypto/pcbc.c                                      |    2 +-
 crypto/pcrypt.c                                    |    2 +-
 crypto/poly1305_generic.c                          |  149 ---
 crypto/polyval-generic.c                           |  122 +-
 crypto/rmd160.c                                    |   88 +-
 crypto/rng.c                                       |    1 +
 crypto/rsa.c                                       |    2 +-
 crypto/rsassa-pkcs1.c                              |    2 +-
 crypto/scatterwalk.c                               |  274 +++-
 crypto/scompress.c                                 |  265 ++--
 crypto/seed.c                                      |    2 +-
 crypto/seqiv.c                                     |   19 +-
 crypto/serpent_generic.c                           |    2 +-
 crypto/sha1_generic.c                              |   35 +-
 crypto/sha256.c                                    |  283 ++++
 crypto/sha256_generic.c                            |  110 --
 crypto/sha3_generic.c                              |  101 +-
 crypto/sha512_generic.c                            |   58 +-
 crypto/shash.c                                     |  284 ++++-
 crypto/sig.c                                       |   10 +-
 crypto/skcipher.c                                  |  262 +---
 crypto/sm3_generic.c                               |   33 +-
 crypto/sm4_generic.c                               |    2 +-
 crypto/streebog_generic.c                          |   73 +-
 crypto/tcrypt.c                                    |  239 +---
 crypto/tcrypt.h                                    |    4 +-
 crypto/tea.c                                       |    2 +-
 crypto/testmgr.c                                   |  160 +--
 crypto/testmgr.h                                   |  288 -----
 crypto/twofish_generic.c                           |    2 +-
 crypto/wp512.c                                     |    2 +-
 crypto/xcbc.c                                      |   94 +-
 crypto/xctr.c                                      |    2 +-
 crypto/xts.c                                       |    6 +-
 crypto/xxhash_generic.c                            |    2 +-
 crypto/zstd.c                                      |    2 +-
 drivers/char/hw_random/atmel-rng.c                 |   11 +-
 drivers/char/hw_random/mtk-rng.c                   |    9 +-
 drivers/char/hw_random/npcm-rng.c                  |    9 +-
 drivers/char/hw_random/rockchip-rng.c              |   73 ++
 drivers/char/random.c                              |   41 +-
 drivers/crypto/Kconfig                             |    7 -
 drivers/crypto/Makefile                            |    4 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   56 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   17 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |  177 ++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |    2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |   49 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  110 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   45 +-
 drivers/crypto/amcc/crypto4xx_core.h               |   17 +-
 drivers/crypto/atmel-aes.c                         |    5 +-
 drivers/crypto/atmel-sha.c                         |    6 +-
 drivers/crypto/atmel-tdes.c                        |    2 +-
 drivers/crypto/caam/ctrl.c                         |    1 +
 drivers/crypto/cavium/Makefile                     |    3 +-
 drivers/crypto/cavium/zip/Makefile                 |   12 -
 drivers/crypto/cavium/zip/common.h                 |  222 ----
 drivers/crypto/cavium/zip/zip_crypto.c             |  261 ----
 drivers/crypto/cavium/zip/zip_crypto.h             |   68 -
 drivers/crypto/cavium/zip/zip_deflate.c            |  200 ---
 drivers/crypto/cavium/zip/zip_deflate.h            |   62 -
 drivers/crypto/cavium/zip/zip_device.c             |  202 ---
 drivers/crypto/cavium/zip/zip_device.h             |  108 --
 drivers/crypto/cavium/zip/zip_inflate.c            |  223 ----
 drivers/crypto/cavium/zip/zip_inflate.h            |   62 -
 drivers/crypto/cavium/zip/zip_main.c               |  603 ---------
 drivers/crypto/cavium/zip/zip_main.h               |  120 --
 drivers/crypto/cavium/zip/zip_mem.c                |  114 --
 drivers/crypto/cavium/zip/zip_mem.h                |   78 --
 drivers/crypto/cavium/zip/zip_regs.h               | 1347 --------------------
 drivers/crypto/ccp/ccp-crypto-aes.c                |   15 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |   15 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |   13 +-
 drivers/crypto/ccp/ccp-ops.c                       |   11 +-
 drivers/crypto/ccp/sev-dev.c                       |  251 +++-
 drivers/crypto/ccp/sp-pci.c                        |    3 +
 drivers/crypto/hisilicon/qm.c                      |    4 +-
 drivers/crypto/img-hash.c                          |   41 +-
 drivers/crypto/inside-secure/eip93/eip93-hash.c    |   20 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   87 +-
 drivers/crypto/intel/qat/Kconfig                   |   12 +
 drivers/crypto/intel/qat/Makefile                  |    2 +
 drivers/crypto/intel/qat/qat_420xx/Makefile        |    1 -
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |    8 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |   10 +-
 drivers/crypto/intel/qat/qat_4xxx/Makefile         |    1 -
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   12 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   14 +-
 drivers/crypto/intel/qat/qat_6xxx/Makefile         |    3 +
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |  845 ++++++++++++
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h   |  148 +++
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c        |  226 ++++
 drivers/crypto/intel/qat/qat_c3xxx/Makefile        |    1 -
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c |    2 -
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |   41 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/Makefile      |    1 -
 .../intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c    |    2 -
 drivers/crypto/intel/qat/qat_c62x/Makefile         |    1 -
 .../crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c   |    2 -
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |   41 +-
 drivers/crypto/intel/qat/qat_c62xvf/Makefile       |    1 -
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c      |    2 -
 drivers/crypto/intel/qat/qat_common/Makefile       |    7 +-
 .../intel/qat/qat_common/adf_accel_devices.h       |   24 +-
 drivers/crypto/intel/qat/qat_common/adf_admin.c    |    1 +
 .../crypto/intel/qat/qat_common/adf_cfg_common.h   |    1 +
 .../crypto/intel/qat/qat_common/adf_cfg_services.c |    3 +-
 .../crypto/intel/qat/qat_common/adf_cfg_services.h |    1 +
 .../qat/qat_common/{adf_gen2_dc.c => adf_dc.c}     |   50 +-
 drivers/crypto/intel/qat/qat_common/adf_dc.h       |   17 +
 .../crypto/intel/qat/qat_common/adf_fw_config.h    |    1 +
 drivers/crypto/intel/qat/qat_common/adf_gen2_dc.h  |   10 -
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c |   57 +
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.h |    1 +
 .../crypto/intel/qat/qat_common/adf_gen2_pfvf.h    |    1 +
 .../crypto/intel/qat/qat_common/adf_gen4_config.c  |    6 +-
 .../crypto/intel/qat/qat_common/adf_gen4_config.h  |    3 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.c  |   83 --
 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.h  |   10 -
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |   70 +
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |    2 +
 .../crypto/intel/qat/qat_common/adf_gen4_pfvf.h    |    1 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h  |   28 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c |  818 ++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h |  504 ++++++++
 .../crypto/intel/qat/qat_common/adf_gen6_shared.c  |   49 +
 .../crypto/intel/qat/qat_common/adf_gen6_shared.h  |   15 +
 .../qat_common/{adf_gen4_timer.c => adf_timer.c}   |   18 +-
 .../qat_common/{adf_gen4_timer.h => adf_timer.h}   |   10 +-
 .../crypto/intel/qat/qat_common/icp_qat_fw_comp.h  |   23 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |    1 +
 .../intel/qat/qat_common/icp_qat_hw_51_comp.h      |   99 ++
 .../intel/qat/qat_common/icp_qat_hw_51_comp_defs.h |  318 +++++
 drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h |   23 +
 .../crypto/intel/qat/qat_common/qat_comp_algs.c    |    7 +-
 .../crypto/intel/qat/qat_common/qat_compression.c  |    1 -
 .../crypto/intel/qat/qat_common/qat_compression.h  |    1 -
 drivers/crypto/intel/qat/qat_common/qat_hal.c      |   13 +-
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |  449 ++++---
 drivers/crypto/intel/qat/qat_dh895xcc/Makefile     |    1 -
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |    2 -
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |   41 +-
 drivers/crypto/intel/qat/qat_dh895xccvf/Makefile   |    1 -
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    2 -
 drivers/crypto/marvell/cesa/cesa.c                 |    2 +-
 drivers/crypto/marvell/cesa/cesa.h                 |    9 +-
 drivers/crypto/marvell/cesa/cipher.c               |    3 +
 drivers/crypto/marvell/cesa/hash.c                 |    2 +-
 drivers/crypto/marvell/cesa/tdma.c                 |   53 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |   89 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h       |    1 +
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |   35 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |   25 +
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |    5 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |   12 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |   18 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c |    6 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |    2 -
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |   21 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |    1 +
 drivers/crypto/nx/nx-aes-cbc.c                     |    8 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |    8 +-
 drivers/crypto/nx/nx-aes-ecb.c                     |    8 +-
 drivers/crypto/nx/nx-aes-xcbc.c                    |  128 +-
 drivers/crypto/nx/nx-sha256.c                      |  130 +-
 drivers/crypto/nx/nx-sha512.c                      |  143 +--
 drivers/crypto/nx/nx.c                             |   19 +-
 drivers/crypto/nx/nx.h                             |   11 +-
 drivers/crypto/omap-aes.c                          |   14 +-
 drivers/crypto/omap-sham.c                         |   14 +-
 drivers/crypto/padlock-sha.c                       |  470 +++----
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   52 +-
 drivers/crypto/s5p-sss.c                           |   24 +-
 drivers/crypto/sa2ul.c                             |   63 +-
 drivers/crypto/tegra/tegra-se-hash.c               |   52 +-
 drivers/crypto/xilinx/zynqmp-sha.c                 |   98 +-
 fs/bcachefs/checksum.c                             |   18 +-
 fs/ubifs/compress.c                                |  251 ++--
 include/asm-generic/simd.h                         |    8 +-
 include/crypto/acompress.h                         |  109 +-
 include/crypto/algapi.h                            |   37 +-
 include/crypto/blake2b.h                           |   31 +-
 include/crypto/chacha.h                            |   89 +-
 include/crypto/ctr.h                               |   50 -
 include/crypto/ghash.h                             |    4 +-
 include/crypto/hash.h                              |  198 +--
 include/crypto/internal/acompress.h                |  128 +-
 include/crypto/internal/blake2b.h                  |   94 +-
 include/crypto/internal/blockhash.h                |   52 +
 include/crypto/internal/chacha.h                   |   43 -
 include/crypto/internal/engine.h                   |    5 +-
 include/crypto/internal/geniv.h                    |    1 -
 include/crypto/internal/hash.h                     |  119 +-
 include/crypto/internal/poly1305.h                 |   28 +-
 include/crypto/internal/scompress.h                |   17 +-
 include/crypto/internal/sha2.h                     |   66 +
 include/crypto/internal/simd.h                     |   10 +-
 include/crypto/internal/skcipher.h                 |   49 +-
 include/crypto/md5.h                               |    3 +-
 include/crypto/null.h                              |    3 -
 include/crypto/poly1305.h                          |   69 +-
 include/crypto/polyval.h                           |    8 -
 include/crypto/rng.h                               |    8 +-
 include/crypto/scatterwalk.h                       |   65 +-
 include/crypto/sha1.h                              |    9 +-
 include/crypto/sha1_base.h                         |   79 +-
 include/crypto/sha2.h                              |   62 +-
 include/crypto/sha256_base.h                       |  135 --
 include/crypto/sha3.h                              |   20 +-
 include/crypto/sha512_base.h                       |   88 +-
 include/crypto/sig.h                               |    2 +-
 include/crypto/sm3.h                               |    4 +-
 include/crypto/sm3_base.h                          |  106 +-
 include/crypto/streebog.h                          |    5 -
 include/linux/crypto.h                             |   93 +-
 include/linux/psp-sev.h                            |    3 +
 lib/crypto/Kconfig                                 |   89 +-
 lib/crypto/Makefile                                |   24 +-
 lib/crypto/aescfb.c                                |    2 +-
 lib/crypto/aesgcm.c                                |    2 +-
 lib/crypto/blake2s.c                               |    2 +-
 lib/crypto/chacha.c                                |   40 +-
 lib/crypto/chacha20poly1305-selftest.c             |    8 +-
 lib/crypto/chacha20poly1305.c                      |   55 +-
 lib/crypto/curve25519.c                            |    2 +-
 lib/crypto/libchacha.c                             |    2 +-
 lib/crypto/poly1305-generic.c                      |   24 +
 lib/crypto/poly1305.c                              |   77 +-
 lib/crypto/sha256-generic.c                        |  137 ++
 lib/crypto/sha256.c                                |  150 +--
 {crypto => lib/crypto}/sm3.c                       |   81 +-
 tools/testing/crypto/chacha20-s390/test-cipher.c   |   10 +-
 583 files changed, 13829 insertions(+), 19664 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/amd-ccp.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spum-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec6.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/img,hash-accelerator.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/mv_cesa.txt
 delete mode 100644 arch/arm/crypto/chacha-glue.c
 delete mode 100644 arch/arm/crypto/poly1305-glue.c
 delete mode 100644 arch/arm/crypto/sha1.h
 delete mode 100644 arch/arm/crypto/sha2-ce-glue.c
 delete mode 100644 arch/arm/crypto/sha256_glue.c
 delete mode 100644 arch/arm/crypto/sha256_glue.h
 delete mode 100644 arch/arm/crypto/sha256_neon_glue.c
 create mode 100644 arch/arm/lib/crypto/.gitignore
 create mode 100644 arch/arm/lib/crypto/Kconfig
 create mode 100644 arch/arm/lib/crypto/Makefile
 rename arch/arm/{ => lib}/crypto/blake2s-core.S (100%)
 rename arch/arm/{ => lib}/crypto/blake2s-glue.c (100%)
 create mode 100644 arch/arm/lib/crypto/chacha-glue.c
 rename arch/arm/{ => lib}/crypto/chacha-neon-core.S (99%)
 rename arch/arm/{ => lib}/crypto/chacha-scalar-core.S (98%)
 rename arch/arm/{ => lib}/crypto/poly1305-armv4.pl (99%)
 create mode 100644 arch/arm/lib/crypto/poly1305-glue.c
 rename arch/arm/{ => lib}/crypto/sha256-armv4.pl (97%)
 rename arch/arm/{crypto/sha2-ce-core.S => lib/crypto/sha256-ce.S} (91%)
 create mode 100644 arch/arm/lib/crypto/sha256.c
 delete mode 100644 arch/arm64/crypto/chacha-neon-glue.c
 delete mode 100644 arch/arm64/crypto/poly1305-glue.c
 delete mode 100644 arch/arm64/crypto/sha2-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sha256-glue.c
 create mode 100644 arch/arm64/lib/crypto/.gitignore
 create mode 100644 arch/arm64/lib/crypto/Kconfig
 create mode 100644 arch/arm64/lib/crypto/Makefile
 rename arch/arm64/{ => lib}/crypto/chacha-neon-core.S (99%)
 create mode 100644 arch/arm64/lib/crypto/chacha-neon-glue.c
 rename arch/arm64/{ => lib}/crypto/poly1305-armv8.pl (100%)
 create mode 100644 arch/arm64/lib/crypto/poly1305-glue.c
 rename arch/arm64/{crypto/sha512-armv8.pl => lib/crypto/sha2-armv8.pl} (99%)
 rename arch/arm64/{crypto/sha2-ce-core.S => lib/crypto/sha256-ce.S} (80%)
 create mode 100644 arch/arm64/lib/crypto/sha256.c
 delete mode 100644 arch/mips/crypto/chacha-glue.c
 delete mode 100644 arch/mips/crypto/poly1305-glue.c
 create mode 100644 arch/mips/lib/crypto/.gitignore
 create mode 100644 arch/mips/lib/crypto/Kconfig
 create mode 100644 arch/mips/lib/crypto/Makefile
 rename arch/mips/{ => lib}/crypto/chacha-core.S (100%)
 create mode 100644 arch/mips/lib/crypto/chacha-glue.c
 create mode 100644 arch/mips/lib/crypto/poly1305-glue.c
 rename arch/mips/{ => lib}/crypto/poly1305-mips.pl (98%)
 delete mode 100644 arch/powerpc/crypto/chacha-p10-glue.c
 delete mode 100644 arch/powerpc/crypto/poly1305-p10-glue.c
 delete mode 100644 arch/powerpc/crypto/sha256-spe-glue.c
 create mode 100644 arch/powerpc/lib/crypto/Kconfig
 create mode 100644 arch/powerpc/lib/crypto/Makefile
 create mode 100644 arch/powerpc/lib/crypto/chacha-p10-glue.c
 rename arch/powerpc/{ => lib}/crypto/chacha-p10le-8x.S (98%)
 create mode 100644 arch/powerpc/lib/crypto/poly1305-p10-glue.c
 rename arch/powerpc/{ => lib}/crypto/poly1305-p10le_64.S (100%)
 rename arch/powerpc/{ => lib}/crypto/sha256-spe-asm.S (100%)
 create mode 100644 arch/powerpc/lib/crypto/sha256.c
 delete mode 100644 arch/riscv/crypto/chacha-riscv64-glue.c
 delete mode 100644 arch/riscv/crypto/sha256-riscv64-glue.c
 create mode 100644 arch/riscv/lib/crypto/Kconfig
 create mode 100644 arch/riscv/lib/crypto/Makefile
 create mode 100644 arch/riscv/lib/crypto/chacha-riscv64-glue.c
 rename arch/riscv/{ => lib}/crypto/chacha-riscv64-zvkb.S (85%)
 rename arch/riscv/{ => lib}/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S (97%)
 create mode 100644 arch/riscv/lib/crypto/sha256.c
 delete mode 100644 arch/s390/crypto/chacha-glue.c
 delete mode 100644 arch/s390/crypto/sha256_s390.c
 create mode 100644 arch/s390/lib/crypto/Kconfig
 create mode 100644 arch/s390/lib/crypto/Makefile
 create mode 100644 arch/s390/lib/crypto/chacha-glue.c
 rename arch/s390/{ => lib}/crypto/chacha-s390.S (100%)
 rename arch/s390/{ => lib}/crypto/chacha-s390.h (100%)
 create mode 100644 arch/s390/lib/crypto/sha256.c
 delete mode 100644 arch/sparc/crypto/sha256_glue.c
 rename arch/sparc/{crypto => include/asm}/opcodes.h (96%)
 create mode 100644 arch/sparc/lib/crypto/Kconfig
 create mode 100644 arch/sparc/lib/crypto/Makefile
 create mode 100644 arch/sparc/lib/crypto/sha256.c
 rename arch/sparc/{ => lib}/crypto/sha256_asm.S (95%)
 delete mode 100644 arch/x86/crypto/chacha_glue.c
 delete mode 100644 arch/x86/crypto/poly1305_glue.c
 delete mode 100644 arch/x86/crypto/sha256_ssse3_glue.c
 create mode 100644 arch/x86/lib/crypto/.gitignore
 create mode 100644 arch/x86/lib/crypto/Kconfig
 create mode 100644 arch/x86/lib/crypto/Makefile
 rename arch/x86/{ => lib}/crypto/blake2s-core.S (98%)
 rename arch/x86/{ => lib}/crypto/blake2s-glue.c (91%)
 rename arch/x86/{ => lib}/crypto/chacha-avx2-x86_64.S (100%)
 rename arch/x86/{ => lib}/crypto/chacha-avx512vl-x86_64.S (100%)
 rename arch/x86/{ => lib}/crypto/chacha-ssse3-x86_64.S (100%)
 create mode 100644 arch/x86/lib/crypto/chacha_glue.c
 rename arch/x86/{ => lib}/crypto/poly1305-x86_64-cryptogams.pl (99%)
 create mode 100644 arch/x86/lib/crypto/poly1305_glue.c
 rename arch/x86/{ => lib}/crypto/sha256-avx-asm.S (98%)
 rename arch/x86/{ => lib}/crypto/sha256-avx2-asm.S (98%)
 rename arch/x86/{crypto/sha256_ni_asm.S => lib/crypto/sha256-ni-asm.S} (85%)
 rename arch/x86/{ => lib}/crypto/sha256-ssse3-asm.S (98%)
 create mode 100644 arch/x86/lib/crypto/sha256.c
 create mode 100644 crypto/chacha.c
 delete mode 100644 crypto/chacha_generic.c
 delete mode 100644 crypto/poly1305_generic.c
 create mode 100644 crypto/sha256.c
 delete mode 100644 crypto/sha256_generic.c
 delete mode 100644 drivers/crypto/cavium/zip/Makefile
 delete mode 100644 drivers/crypto/cavium/zip/common.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_crypto.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_crypto.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_deflate.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_deflate.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_device.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_device.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_inflate.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_inflate.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_main.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_main.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_mem.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_mem.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_regs.h
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/Makefile
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
 rename drivers/crypto/intel/qat/qat_common/{adf_gen2_dc.c => adf_dc.c} (59%)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dc.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_dc.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.c
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.c => adf_timer.c} (78%)
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.h => adf_timer.h} (58%)
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h
 create mode 100644 include/crypto/internal/blockhash.h
 delete mode 100644 include/crypto/internal/chacha.h
 create mode 100644 include/crypto/internal/sha2.h
 delete mode 100644 include/crypto/sha256_base.h
 create mode 100644 lib/crypto/poly1305-generic.c
 create mode 100644 lib/crypto/sha256-generic.c
 rename {crypto => lib/crypto}/sm3.c (80%)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
