From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.18
Date: Tue, 5 Jun 2018 01:15:52 +0800
Message-ID: <20180604171552.lctgpei4y4xzogoo@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
 <20180129145012.GA12805@gondor.apana.org.au>
 <20180404152752.GA11822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180404152752.GA11822@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

Here is the crypto update for 4.18:

API:

- Decryption test vectors are now automatically generated from
  encryption test vectors.

Algorithms:

- Fix unaligned access issues in crc32/crc32c.
- Add zstd compression algorithm.
- Add AEGIS.
- Add MORUS.

Drivers:

- Add accelerated AEGIS/MORUS on x86.
- Add accelerated SM4 on arm64.
- Removed x86 assembly salsa implementation as it is slower than C.
- Add authenc(hmac(sha*), cbc(aes)) support in inside-secure.
- Add ctr(aes) support in crypto4xx.
- Add hardware key support in ccree.
- Add support for new Centaur CPU in via-rng.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Adam Langley (1):
      crypto: clarify licensing of OpenSSL asm code

Antoine Tenart (10):
      crypto: inside-secure - remove VLAs
      crypto: inside-secure - rework cipher functions for future AEAD support
      crypto: inside-secure - rework the alg type settings in the context
      crypto: inside-secure - make the context control size dynamic
      crypto: inside-secure - make the key and context size computation dynamic
      crypto: inside-secure - fix the hash then encrypt/decrypt types
      crypto: inside-secure - improve error reporting
      crypto: inside-secure - authenc(hmac(sha256), cbc(aes)) support
      crypto: inside-secure - authenc(hmac(sha224), cbc(aes)) support
      crypto: inside-secure - authenc(hmac(sha1), cbc(aes)) support

Ard Biesheuvel (12):
      crypto: sm4 - export encrypt/decrypt routines to other drivers
      crypto: arm64 - add support for SM4 encryption using special instructions
      crypto: arm64/sha1-ce - yield NEON after every block of input
      crypto: arm64/sha2-ce - yield NEON after every block of input
      crypto: arm64/aes-ccm - yield NEON after every block of input
      crypto: arm64/aes-blk - yield NEON after every block of input
      crypto: arm64/aes-bs - yield NEON after every block of input
      crypto: arm64/aes-ghash - yield NEON after every block of input
      crypto: arm64/crc32-ce - yield NEON after every block of input
      crypto: arm64/crct10dif-ce - yield NEON after every block of input
      crypto: arm64/sha3-ce - yield NEON after every block of input
      crypto: arm64/sha512-ce - yield NEON after every block of input

Atul Gupta (7):
      crypto: chelsio - request to HW should wrap
      crypto: chtls - generic handling of data and hdr
      crypto: chtls - key len correction
      crypto: chtls - wait for memory sendmsg, sendpage
      crypto: chtls - dereference null variable
      crypto: chtls - kbuild warnings
      crypto: chtls - free beyond end rspq_skb_cache

Bin Liu (1):
      crypto: omap-sham - fix memleak

Christian Lamparter (7):
      crypto: crypto4xx - performance optimizations
      crypto: crypto4xx - convert to skcipher
      crypto: crypto4xx - avoid VLA use
      crypto: crypto4xx - add aes-ctr support
      crypto: crypto4xx - properly set IV after de- and encrypt
      crypto: crypto4xx - extend aead fallback checks
      crypto: crypto4xx - put temporary dst sg into request ctx

Colin Ian King (5):
      crypto: chelsio - don't leak information from the stack to userspace
      crypto: chelsio - remove redundant assignment to cdev->ports
      crypto: ghash-clmulni - fix spelling mistake: "acclerated" -> "accelerated"
      hwrng: n2 - fix spelling mistake: "restesting" -> "retesting"
      crypto: nx - fix spelling mistake: "seqeunce" -> "sequence"

Conor McLoughlin (1):
      crypto: qat - Add MODULE_FIRMWARE for all qat drivers

Eric Biggers (13):
      crypto: crc32-generic - use unaligned access macros when needed
      crypto: crc32c-generic - remove cra_alignmask
      crypto: crc32-generic - remove __crc32_le()
      crypto: testmgr - remove bfin_crc "hmac(crc32)" test vectors
      crypto: testmgr - fix testing OPTIONAL_KEY hash algorithms
      crypto: testmgr - add more unkeyed crc32 and crc32c test vectors
      crypto: testmgr - add extra ecb(des) encryption test vectors
      crypto: testmgr - make an cbc(des) encryption test vector chunked
      crypto: testmgr - add extra ecb(tnepres) encryption test vectors
      crypto: testmgr - add extra kw(aes) encryption test vector
      crypto: testmgr - eliminate redundant decryption test vectors
      crypto: x86/salsa20 - remove x86 salsa20 implementations
      crypto: salsa20 - Revert "crypto: salsa20 - export generic helpers"

Fabio Estevam (4):
      crypto: caam - staticize caam_get_era()
      crypto: caam - allow retrieving 'era' from register
      crypto: rsa - Remove unneeded error assignment
      crypto: caam: - Use kmemdup() function

Geert Uytterhoeven (1):
      crypto: drivers - Remove depends on HAS_DMA in case of platform dependency

Gilad Ben-Yossef (6):
      crypto: ccree - enable support for hardware keys
      crypto: ccree - use proper printk format
      crypto: testmgr - reorder paes test lexicographically
      crypto: ccree - correct host regs offset
      crypto: ccree - better clock handling
      crypto: ccree - silence debug prints

Gustavo A. R. Silva (1):
      crypto: chelsio - Fix potential NULL pointer dereferences

Harsh Jain (3):
      crypto: chelsio - Return -ENOSPC for transient busy indication.
      crypt: chelsio - Send IV as Immediate for cipher algo
      crypto: chelsio - Remove separate buffer used for DMA map B0 block in CCM

Horia Geantă (8):
      crypto: caam - fix DMA mapping dir for generated IV
      crypto: caam - fix IV DMA mapping and updating
      crypto: caam/qi - fix IV DMA mapping and updating
      crypto: caam - strip input zeros from RSA input buffer
      crypto: caam - fix size of RSA prime factor q
      crypto: caam - fix MC firmware detection
      crypto: caam - fix rfc4543 descriptors
      crypto: caam/qi - fix warning in init_cgr()

Jan Glauber (5):
      crypto: cavium - Fix fallout from CONFIG_VMAP_STACK
      crypto: cavium - Limit result reading attempts
      crypto: cavium - Prevent division by zero
      crypto: cavium - Fix statistics pending request value
      crypto: cavium - Fix smp_processor_id() warnings

Janakarajan Natarajan (2):
      crypto: ccp - Add DOWNLOAD_FIRMWARE SEV command
      crypto: ccp - Add GET_ID SEV command

Kees Cook (2):
      crypto: ecc - Actually remove stack VLA usage
      crypto: tcrypt - Remove VLA usage

Mahipal Challa (1):
      crypto: testmgr - Allow different compression results

Michael Ellerman (2):
      crypto: vmx - Remove overly verbose printk from AES init routines
      crypto: vmx - Remove overly verbose printk from AES XTS init

Nick Terrell (1):
      crypto: zstd - Add zstd support

Ondrej Mosnacek (9):
      crypto: aegis - Add generic AEGIS AEAD implementations
      crypto: testmgr - Add test vectors for AEGIS
      crypto: x86 - Add optimized AEGIS implementations
      crypto: morus - Add generic MORUS AEAD implementations
      crypto: testmgr - Add test vectors for MORUS
      crypto: morus - Add common SIMD glue code for MORUS
      crypto: x86 - Add optimized MORUS implementations
      crypto: x86/aegis256 - Fix wrong key buffer size
      crypto: morus - Mark MORUS SIMD glue as x86-specific

Salvatore Mesoraca (2):
      crypto: api - laying defines and checks for statically allocated buffers
      crypto: remove several VLAs

Tudor-Dan Ambarus (2):
      crypto: authenc - don't leak pointers to authenc keys
      crypto: authencesn - don't leak pointers to authenc keys

Varsha Rao (1):
      crypto: cavium - Remove unnecessary parentheses

Wenwen Wang (1):
      crypto: chtls - fix a missing-check bug

Wolfram Sang (1):
      crypto: drivers - simplify getting .drvdata

davidwang (1):
      hwrng: via - support new Centaur CPU

lionel.debieve@st.com (2):
      hwrng: stm32 - define default state for rng driver
      hwrng: stm32 - fix pm_suspend issue

 arch/arm/crypto/sha1-armv4-large.S             |   10 +
 arch/arm/crypto/sha256-armv4.pl                |   11 +-
 arch/arm/crypto/sha256-core.S_shipped          |   11 +-
 arch/arm/crypto/sha512-armv4.pl                |   11 +-
 arch/arm/crypto/sha512-core.S_shipped          |   11 +-
 arch/arm64/crypto/Kconfig                      |    6 +
 arch/arm64/crypto/Makefile                     |    3 +
 arch/arm64/crypto/aes-ce-ccm-core.S            |  150 +-
 arch/arm64/crypto/aes-ce.S                     |   15 +-
 arch/arm64/crypto/aes-modes.S                  |  331 +-
 arch/arm64/crypto/aes-neonbs-core.S            |  305 +-
 arch/arm64/crypto/crc32-ce-core.S              |   40 +-
 arch/arm64/crypto/crct10dif-ce-core.S          |   32 +-
 arch/arm64/crypto/ghash-ce-core.S              |  113 +-
 arch/arm64/crypto/ghash-ce-glue.c              |   28 +-
 arch/arm64/crypto/sha1-ce-core.S               |   42 +-
 arch/arm64/crypto/sha2-ce-core.S               |   37 +-
 arch/arm64/crypto/sha256-core.S_shipped        |   12 +-
 arch/arm64/crypto/sha3-ce-core.S               |   77 +-
 arch/arm64/crypto/sha512-armv8.pl              |   12 +-
 arch/arm64/crypto/sha512-ce-core.S             |   27 +-
 arch/arm64/crypto/sha512-core.S_shipped        |   12 +-
 arch/arm64/crypto/sm4-ce-core.S                |   36 +
 arch/arm64/crypto/sm4-ce-glue.c                |   73 +
 arch/x86/crypto/Makefile                       |   25 +-
 arch/x86/crypto/aegis128-aesni-asm.S           |  749 +
 arch/x86/crypto/aegis128-aesni-glue.c          |  407 +
 arch/x86/crypto/aegis128l-aesni-asm.S          |  825 +
 arch/x86/crypto/aegis128l-aesni-glue.c         |  407 +
 arch/x86/crypto/aegis256-aesni-asm.S           |  702 +
 arch/x86/crypto/aegis256-aesni-glue.c          |  407 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c     |    2 +-
 arch/x86/crypto/morus1280-avx2-asm.S           |  621 +
 arch/x86/crypto/morus1280-avx2-glue.c          |   68 +
 arch/x86/crypto/morus1280-sse2-asm.S           |  895 +
 arch/x86/crypto/morus1280-sse2-glue.c          |   68 +
 arch/x86/crypto/morus1280_glue.c               |  302 +
 arch/x86/crypto/morus640-sse2-asm.S            |  614 +
 arch/x86/crypto/morus640-sse2-glue.c           |   68 +
 arch/x86/crypto/morus640_glue.c                |  298 +
 arch/x86/crypto/salsa20-i586-asm_32.S          |  938 -
 arch/x86/crypto/salsa20-x86_64-asm_64.S        |  805 -
 arch/x86/crypto/salsa20_glue.c                 |   91 -
 crypto/Kconfig                                 |  138 +-
 crypto/Makefile                                |    6 +
 crypto/aegis.h                                 |   80 +
 crypto/aegis128.c                              |  463 +
 crypto/aegis128l.c                             |  527 +
 crypto/aegis256.c                              |  478 +
 crypto/algapi.c                                |   10 +
 crypto/authenc.c                               |    1 +
 crypto/authencesn.c                            |    1 +
 crypto/cfb.c                                   |    7 +-
 crypto/cipher.c                                |    3 +-
 crypto/crc32_generic.c                         |   15 +-
 crypto/crc32c_generic.c                        |    8 +-
 crypto/ctr.c                                   |    4 +-
 crypto/cts.c                                   |    5 +-
 crypto/ecc.c                                   |   66 +-
 crypto/ecc.h                                   |    4 +-
 crypto/ecdh.c                                  |    4 +-
 crypto/morus1280.c                             |  549 +
 crypto/morus640.c                              |  544 +
 crypto/pcbc.c                                  |    5 +-
 crypto/rsa.c                                   |    1 -
 crypto/salsa20_generic.c                       |   20 +-
 crypto/sm4_generic.c                           |   10 +-
 crypto/tcrypt.c                                |  122 +-
 crypto/testmgr.c                               |  613 +-
 crypto/testmgr.h                               |47127 +++++++++++-------------
 crypto/zstd.c                                  |  265 +
 drivers/char/hw_random/Kconfig                 |    1 +
 drivers/char/hw_random/n2-drv.c                |    2 +-
 drivers/char/hw_random/stm32-rng.c             |    9 +-
 drivers/char/hw_random/via-rng.c               |    2 +-
 drivers/crypto/Kconfig                         |   16 +-
 drivers/crypto/amcc/crypto4xx_alg.c            |  231 +-
 drivers/crypto/amcc/crypto4xx_core.c           |  317 +-
 drivers/crypto/amcc/crypto4xx_core.h           |   35 +-
 drivers/crypto/caam/caamalg.c                  |  231 +-
 drivers/crypto/caam/caamalg_desc.c             |    4 +-
 drivers/crypto/caam/caamalg_qi.c               |  227 +-
 drivers/crypto/caam/caampkc.c                  |   71 +-
 drivers/crypto/caam/caampkc.h                  |    8 +
 drivers/crypto/caam/ctrl.c                     |   78 +-
 drivers/crypto/caam/ctrl.h                     |    2 -
 drivers/crypto/caam/intern.h                   |    1 +
 drivers/crypto/caam/qi.c                       |    5 +-
 drivers/crypto/caam/regs.h                     |    6 +
 drivers/crypto/cavium/zip/common.h             |   21 +
 drivers/crypto/cavium/zip/zip_crypto.c         |   22 +-
 drivers/crypto/cavium/zip/zip_deflate.c        |    4 +-
 drivers/crypto/cavium/zip/zip_device.c         |    4 +-
 drivers/crypto/cavium/zip/zip_inflate.c        |    4 +-
 drivers/crypto/cavium/zip/zip_main.c           |   24 +-
 drivers/crypto/cavium/zip/zip_main.h           |    1 -
 drivers/crypto/cavium/zip/zip_regs.h           |   42 +-
 drivers/crypto/ccp/psp-dev.c                   |  143 +-
 drivers/crypto/ccp/psp-dev.h                   |    4 +
 drivers/crypto/ccree/cc_cipher.c               |  350 +-
 drivers/crypto/ccree/cc_cipher.h               |   30 +-
 drivers/crypto/ccree/cc_debugfs.c              |    7 +-
 drivers/crypto/ccree/cc_driver.c               |   36 +-
 drivers/crypto/ccree/cc_driver.h               |    2 +
 drivers/crypto/ccree/cc_host_regs.h            |    6 +-
 drivers/crypto/chelsio/chcr_algo.c             |  303 +-
 drivers/crypto/chelsio/chcr_algo.h             |    3 +-
 drivers/crypto/chelsio/chcr_core.h             |    2 +-
 drivers/crypto/chelsio/chcr_crypto.h           |   15 +-
 drivers/crypto/chelsio/chcr_ipsec.c            |   35 +-
 drivers/crypto/chelsio/chtls/chtls.h           |   11 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c        |   28 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c        |    6 +-
 drivers/crypto/chelsio/chtls/chtls_io.c        |  158 +-
 drivers/crypto/chelsio/chtls/chtls_main.c      |   16 +-
 drivers/crypto/exynos-rng.c                    |    6 +-
 drivers/crypto/inside-secure/safexcel.c        |   32 +
 drivers/crypto/inside-secure/safexcel.h        |   44 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |  642 +-
 drivers/crypto/inside-secure/safexcel_hash.c   |   23 +-
 drivers/crypto/nx/nx-842-powernv.c             |    2 +-
 drivers/crypto/omap-sham.c                     |    2 +-
 drivers/crypto/picoxcell_crypto.c              |    6 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c         |    2 +
 drivers/crypto/qat/qat_c62x/adf_drv.c          |    2 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c      |    1 +
 drivers/crypto/vmx/aes.c                       |    2 -
 drivers/crypto/vmx/aes_cbc.c                   |    3 -
 drivers/crypto/vmx/aes_ctr.c                   |    2 -
 drivers/crypto/vmx/aes_xts.c                   |    2 -
 drivers/crypto/vmx/aesp8-ppc.pl                |   49 +-
 drivers/crypto/vmx/ghash.c                     |    2 -
 drivers/crypto/vmx/ghashp8-ppc.pl              |    9 +
 include/crypto/algapi.h                        |    8 +
 include/crypto/morus1280_glue.h                |  137 +
 include/crypto/morus640_glue.h                 |  137 +
 include/crypto/morus_common.h                  |   23 +
 include/crypto/salsa20.h                       |   27 -
 include/crypto/sm4.h                           |    3 +
 include/linux/psp-sev.h                        |   23 +
 include/uapi/linux/psp-sev.h                   |   12 +
 141 files changed, 34902 insertions(+), 29595 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
