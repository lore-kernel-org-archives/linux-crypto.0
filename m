Return-Path: <SRS0=VXLt=PD=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45490 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeLZNXJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Dec 2018 08:23:09 -0500
Date: Wed, 26 Dec 2018 21:22:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 4.21
Message-ID: <20181226132257.w43gf2fouprimwk2@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
 <20181023100958.GA11991@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181023100958.GA11991@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.21:

API:

- Add 1472-byte test to tcrypt for IPsec.
- Reintroduced crypto stats interface with numerous changes.
- Support incremental algorithm dumps.

Algorithms:

- Add xchacha12/20.
- Add nhpoly1305.
- Add adiantum.
- Add streebog hash.
- Mark cts(cbc(aes)) as FIPS allowed.

Drivers:

- Improve performance of arm64/chacha20.
- Improve performance of x86/chacha20.
- Add NEON-accelerated nhpoly1305.
- Add SSE2 accelerated nhpoly1305.
- Add AVX2 accelerated nhpoly1305.
- Add support for 192/256-bit keys in gcmaes AVX.
- Add SG support in gcmaes AVX.
- ESN for inline IPsec tx in chcr.
- Add support for CryptoCell 703 in ccree.
- Add support for CryptoCell 713 in ccree.
- Add SM4 support in ccree.
- Add SM3 support in ccree.
- Add support for chacha20 in caam/qi2.
- Add support for chacha20 + poly1305 in caam/jr.
- Add support for chacha20 + poly1305 in caam/qi2.
- Add AEAD cipher support in cavium/nitrox.

Please note that there is a conflict with the rcu tree as both
changed the same MAINTAINERS entries for IBM Power Crypto.  Please
use the version from the crypto tree when resolving this conflict.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (3):
      crypto: tcrypt - add block size of 1472 to skcipher template
      crypto: arm64/chacha - optimize for arbitrary length inputs
      crypto: arm64/chacha - use combined SIMD/ALU routine for more speed

Atul Gupta (2):
      crypto: chcr - small packet Tx stalls the queue
      crypto: chcr - ESN for Inline IPSec Tx

Brajeswar Ghosh (1):
      crypto: aes-ce - Remove duplicate header

Colin Ian King (3):
      pcrypt: use format specifier in kobject_add
      crypto: chelsio - clean up various indentation issues
      padata: clean an indentation issue, remove extraneous space

Corentin Labbe (13):
      crypto: user - made crypto_user_stat optional
      crypto: user - CRYPTO_STATS should depend on CRYPTO_USER
      crypto: user - convert all stats from u32 to u64
      crypto: user - split user space crypto stat structures
      crypto: tool: getstat: convert user space example to the new crypto_user_stat uapi
      crypto: user - fix use_after_free of struct xxx_request
      crypto: user - Fix invalid stat reporting
      crypto: user - remove intermediate variable
      crypto: user - Split stats in multiple structures
      crypto: user - rename err_cnt parameter
      crypto: user - Add crypto_stats_init
      crypto: user - remove unused dump functions
      crypto: api - document missing stats member

Cristian Stoica (1):
      crypto: chacha20poly1305 - export CHACHAPOLY_IV_SIZE

Dave Watson (12):
      crypto: aesni - Merge GCM_ENC_DEC
      crypto: aesni - Introduce gcm_context_data
      crypto: aesni - Macro-ify func save/restore
      crypto: aesni - support 256 byte keys in avx asm
      crypto: aesni - Add GCM_COMPLETE macro
      crypto: aesni - Split AAD hash calculation to separate macro
      crypto: aesni - Merge avx precompute functions
      crypto: aesni - Fill in new context data structures
      crypto: aesni - Move ghash_mul to GCM_COMPLETE
      crypto: aesni - Introduce READ_PARTIAL_BLOCK macro
      crypto: aesni - Introduce partial block macro
      crypto: aesni - Add scatter/gather avx stubs, and use them in C

Dmitry Eremin-Solenikov (2):
      crypto: cfb - fix decryption
      crypto: testmgr - add AES-CFB tests

Eric Biggers (43):
      crypto: aes_ti - disable interrupts while accessing S-box
      crypto: arm/aes - add some hardening against cache-timing attacks
      crypto: user - remove redundant reporting functions
      crypto: user - clean up report structure copying
      crypto: inside-secure - remove useless setting of type flags
      crypto: remove useless initializations of cra_list
      crypto: drop mask=CRYPTO_ALG_ASYNC from 'cipher' tfm allocations
      crypto: drop mask=CRYPTO_ALG_ASYNC from 'shash' tfm allocations
      crypto: chacha20-generic - add HChaCha20 library function
      crypto: chacha20-generic - don't unnecessarily use atomic walk
      crypto: chacha20-generic - add XChaCha20 support
      crypto: chacha20-generic - refactor to allow varying number of rounds
      crypto: chacha - add XChaCha12 support
      crypto: arm/chacha20 - limit the preemption-disabled section
      crypto: arm/chacha20 - add XChaCha20 support
      crypto: arm/chacha20 - refactor to allow varying number of rounds
      crypto: arm/chacha - add XChaCha12 support
      crypto: poly1305 - use structures for key and accumulator
      crypto: poly1305 - add Poly1305 core API
      crypto: nhpoly1305 - add NHPoly1305 support
      crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305
      crypto: adiantum - add Adiantum support
      crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305
      crypto: arm64/chacha20 - add XChaCha20 support
      crypto: arm64/chacha20 - refactor to allow varying number of rounds
      crypto: arm64/chacha - add XChaCha12 support
      crypto: adiantum - propagate CRYPTO_ALG_ASYNC flag to instance
      crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305
      crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305
      crypto: x86/chacha20 - add XChaCha20 support
      crypto: x86/chacha20 - refactor to allow varying number of rounds
      crypto: x86/chacha - add XChaCha12 support
      crypto: x86/chacha - yield the FPU occasionally
      crypto: xchacha - add test vector from XChaCha20 draft RFC
      crypto: xchacha20 - fix comments for test vectors
      crypto: adiantum - adjust some comments to match latest paper
      crypto: user - support incremental algorithm dumps
      crypto: adiantum - fix leaking reference to hash algorithm
      crypto: x86/chacha - avoid sleeping under kernel_fpu_begin()
      crypto: skcipher - add might_sleep() to skcipher_walk_virt()
      crypto: salsa20-generic - don't unnecessarily use atomic walk
      crypto: cavium/nitrox - Fix build with !CONFIG_DEBUG_FS
      crypto: skcipher - remove remnants of internal IV generators

Fabio Estevam (1):
      crypto: mxc-scc - fix build warnings on ARM64

Gilad Ben-Yossef (8):
      crypto: ccree - add support for CryptoCell 713
      dt-bindings: crypto: ccree: add ccree 713
      crypto: ccree - add SM4 support
      crypto: testmgr - mark cts(cbc(aes)) as FIPS allowed
      crypto: cts - document NIST standard status
      crypto: ccree - add support for CryptoCell 703
      dt-bindings: crypto: ccree: add dt bindings for ccree 703
      MAINTAINERS: ccree: add co-maintainer

Harsh Jain (6):
      crypto: chelsio - Swap location of AAD and IV sent in WR
      crypto: chelsio - Use same value for both channel in single WR
      crypto: chelsio - cleanup:send addr as value in function argument
      crypto: chelsio - Handle PCI shutdown event
      crypto: chelsio - Reset counters on cxgb4 Detach
      crypto: chelsio - Fix wrong error counter increments

Herbert Xu (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geantă (4):
      crypto: caam - add register map changes cf. Era 10
      crypto: caam/qi2 - add support for ChaCha20
      crypto: caam/jr - add support for Chacha20 + Poly1305
      crypto: caam/qi2 - add support for Chacha20 + Poly1305

Leonard Crestez (2):
      dt-bindings: crypto: Mention clocks for mxs-dcp
      crypto: mxs-dcp - Add support for dcp clk

Martin Willi (9):
      crypto: x86/chacha20 - Support partial lengths in 1-block SSSE3 variant
      crypto: x86/chacha20 - Support partial lengths in 4-block SSSE3 variant
      crypto: x86/chacha20 - Support partial lengths in 8-block AVX2 variant
      crypto: x86/chacha20 - Use larger block functions more aggressively
      crypto: x86/chacha20 - Add a 2-block AVX2 variant
      crypto: x86/chacha20 - Add a 4-block AVX2 variant
      crypto: x86/chacha20 - Add a 8-block AVX-512VL variant
      crypto: x86/chacha20 - Add a 2-block AVX-512VL variant
      crypto: x86/chacha20 - Add a 4-block AVX-512VL variant

Nagadheeraj Rottela (1):
      crypto: cavium/nitrox - Added AEAD cipher support

Nagadheeraj, Rottela (1):
      crypto: cavium/nitrox - crypto request format changes

Nathan Chancellor (2):
      crypto: ux500 - Use proper enum in cryp_set_dma_transfer
      crypto: ux500 - Use proper enum in hash_set_dma_transfer

Paulo Flabiano Smorigo (1):
      MAINTAINERS: change NX/VMX maintainers

Raveendra Padasalagi (1):
      crypto: bcm - fix normal/non key hash algorithm failure

Srikanth, Jampala (2):
      crypto: cavium/nitrox - Enable interrups for PF in SR-IOV mode.
      crypto: cavium/nitrox - Enabled Mailbox support

Stefan Wahren (1):
      hwrng: bcm2835 - Switch to SPDX identifier

Vitaly Chikunov (5):
      crypto: ecc - check for invalid values in the key verification test
      crypto: streebog - add Streebog hash function
      crypto: streebog - register Streebog in hash info for IMA
      crypto: streebog - add Streebog test vectors
      crypto: ecc - regularize scalar for scalar multiplication

Wenwen Wang (1):
      crypto: cavium/nitrox - fix a DMA pool free failure

Yael Chemla (3):
      crypto: ccree - adjust hash length to suit certain context specifics
      crypto: ccree - modify set_cipher_mode usage from cc_hash
      crypto: ccree - add SM3 support

Yangtao Li (1):
      crypto: cavium/nitrox - convert to DEFINE_SHOW_ATTRIBUTE

YueHaibing (1):
      crypto: chelsio - remove set but not used variable 'kctx_len'

 Documentation/crypto/api.rst                       |    9 -
 Documentation/crypto/architecture.rst              |   31 +-
 .../devicetree/bindings/crypto/arm-cryptocell.txt  |    8 +-
 .../devicetree/bindings/crypto/fsl-dcp.txt         |    2 +
 MAINTAINERS                                        |   11 +-
 arch/arm/crypto/Kconfig                            |   16 +-
 arch/arm/crypto/Makefile                           |    6 +-
 arch/arm/crypto/aes-ce-glue.c                      |    1 -
 arch/arm/crypto/aes-cipher-core.S                  |   62 +-
 .../{chacha20-neon-core.S => chacha-neon-core.S}   |   98 +-
 arch/arm/crypto/chacha-neon-glue.c                 |  201 ++
 arch/arm/crypto/chacha20-neon-glue.c               |  127 -
 arch/arm/crypto/nh-neon-core.S                     |  116 +
 arch/arm/crypto/nhpoly1305-neon-glue.c             |   77 +
 arch/arm64/crypto/Kconfig                          |    7 +-
 arch/arm64/crypto/Makefile                         |    7 +-
 .../{chacha20-neon-core.S => chacha-neon-core.S}   |  484 ++-
 arch/arm64/crypto/chacha-neon-glue.c               |  198 ++
 arch/arm64/crypto/chacha20-neon-glue.c             |  133 -
 arch/arm64/crypto/nh-neon-core.S                   |  103 +
 arch/arm64/crypto/nhpoly1305-neon-glue.c           |   77 +
 arch/s390/crypto/aes_s390.c                        |    2 +-
 arch/sparc/crypto/aes_glue.c                       |    5 -
 arch/sparc/crypto/camellia_glue.c                  |    5 -
 arch/sparc/crypto/des_glue.c                       |    5 -
 arch/x86/crypto/Makefile                           |   18 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S           | 3665 ++++++++++----------
 arch/x86/crypto/aesni-intel_glue.c                 |  353 +-
 arch/x86/crypto/chacha-avx2-x86_64.S               | 1025 ++++++
 arch/x86/crypto/chacha-avx512vl-x86_64.S           |  836 +++++
 ...acha20-ssse3-x86_64.S => chacha-ssse3-x86_64.S} |  327 +-
 arch/x86/crypto/chacha20-avx2-x86_64.S             |  448 ---
 arch/x86/crypto/chacha20_glue.c                    |  146 -
 arch/x86/crypto/chacha_glue.c                      |  304 ++
 arch/x86/crypto/nh-avx2-x86_64.S                   |  157 +
 arch/x86/crypto/nh-sse2-x86_64.S                   |  123 +
 arch/x86/crypto/nhpoly1305-avx2-glue.c             |   77 +
 arch/x86/crypto/nhpoly1305-sse2-glue.c             |   76 +
 arch/x86/crypto/poly1305_glue.c                    |   20 +-
 crypto/Kconfig                                     |   99 +-
 crypto/Makefile                                    |    8 +-
 crypto/ablkcipher.c                                |   94 +-
 crypto/acompress.c                                 |   10 +-
 crypto/adiantum.c                                  |  664 ++++
 crypto/aead.c                                      |   14 +-
 crypto/aes_generic.c                               |    9 +-
 crypto/aes_ti.c                                    |   18 +
 crypto/ahash.c                                     |   29 +-
 crypto/akcipher.c                                  |   11 +-
 crypto/algapi.c                                    |  247 +-
 crypto/blkcipher.c                                 |   20 +-
 crypto/cfb.c                                       |    2 +-
 crypto/chacha20_generic.c                          |  137 -
 crypto/chacha20poly1305.c                          |   12 +-
 crypto/chacha_generic.c                            |  217 ++
 crypto/cryptd.c                                    |    4 +-
 crypto/crypto_user_base.c                          |  136 +-
 crypto/crypto_user_stat.c                          |  301 +-
 crypto/ctr.c                                       |    2 -
 crypto/ecc.c                                       |   58 +-
 crypto/hash_info.c                                 |    4 +
 crypto/kpp.c                                       |   10 +-
 crypto/lz4.c                                       |    1 -
 crypto/lz4hc.c                                     |    1 -
 crypto/nhpoly1305.c                                |  254 ++
 crypto/pcrypt.c                                    |    2 +-
 crypto/poly1305_generic.c                          |  174 +-
 crypto/rng.c                                       |   16 +-
 crypto/salsa20_generic.c                           |    2 +-
 crypto/scompress.c                                 |   11 +-
 crypto/shash.c                                     |   12 +-
 crypto/skcipher.c                                  |   23 +-
 crypto/streebog_generic.c                          | 1140 ++++++
 crypto/tcrypt.c                                    |   59 +-
 crypto/testmgr.c                                   |   62 +
 crypto/testmgr.h                                   | 3220 ++++++++++++++++-
 drivers/block/drbd/drbd_receiver.c                 |    2 +-
 drivers/char/hw_random/bcm2835-rng.c               |    7 +-
 drivers/char/random.c                              |   51 +-
 drivers/crypto/Kconfig                             |    4 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |    3 +-
 drivers/crypto/bcm/cipher.c                        |    9 +-
 drivers/crypto/caam/caamalg.c                      |  266 +-
 drivers/crypto/caam/caamalg_desc.c                 |  139 +-
 drivers/crypto/caam/caamalg_desc.h                 |    5 +
 drivers/crypto/caam/caamalg_qi.c                   |   37 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  156 +-
 drivers/crypto/caam/caamhash.c                     |   20 +-
 drivers/crypto/caam/caampkc.c                      |   10 +-
 drivers/crypto/caam/caamrng.c                      |   10 +-
 drivers/crypto/caam/compat.h                       |    2 +
 drivers/crypto/caam/ctrl.c                         |   28 +-
 drivers/crypto/caam/desc.h                         |   28 +
 drivers/crypto/caam/desc_constr.h                  |    7 +-
 drivers/crypto/caam/regs.h                         |   74 +-
 drivers/crypto/cavium/nitrox/Makefile              |    5 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |  364 ++
 drivers/crypto/cavium/nitrox/nitrox_algs.c         |  456 +--
 drivers/crypto/cavium/nitrox/nitrox_common.h       |    6 +-
 drivers/crypto/cavium/nitrox/nitrox_csr.h          |   12 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c      |   48 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h      |   21 +
 drivers/crypto/cavium/nitrox/nitrox_dev.h          |   74 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |  114 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.h          |    2 +
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |   92 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.h          |    2 +
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |   22 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |  204 ++
 drivers/crypto/cavium/nitrox/nitrox_mbx.h          |    9 +
 drivers/crypto/cavium/nitrox/nitrox_req.h          |  326 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |  302 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |  498 +++
 drivers/crypto/cavium/nitrox/nitrox_sriov.c        |   94 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |    4 +-
 drivers/crypto/ccree/cc_aead.c                     |   35 +-
 drivers/crypto/ccree/cc_cipher.c                   |  104 +-
 drivers/crypto/ccree/cc_crypto_ctx.h               |    4 +-
 drivers/crypto/ccree/cc_driver.c                   |   50 +-
 drivers/crypto/ccree/cc_driver.h                   |   15 +-
 drivers/crypto/ccree/cc_hash.c                     |  189 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h            |   30 +
 drivers/crypto/chelsio/chcr_algo.c                 |  418 ++-
 drivers/crypto/chelsio/chcr_algo.h                 |    2 +-
 drivers/crypto/chelsio/chcr_core.c                 |  195 +-
 drivers/crypto/chelsio/chcr_core.h                 |   44 +-
 drivers/crypto/chelsio/chcr_crypto.h               |   10 +-
 drivers/crypto/chelsio/chcr_ipsec.c                |  183 +-
 drivers/crypto/geode-aes.c                         |    2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |    8 +-
 drivers/crypto/ixp4xx_crypto.c                     |    5 -
 drivers/crypto/mxc-scc.c                           |   12 +-
 drivers/crypto/mxs-dcp.c                           |   28 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |    1 -
 drivers/crypto/omap-aes.c                          |    3 -
 drivers/crypto/omap-des.c                          |    1 -
 drivers/crypto/picoxcell_crypto.c                  |    3 +-
 drivers/crypto/qce/ablkcipher.c                    |    1 -
 drivers/crypto/qce/sha.c                           |    1 -
 drivers/crypto/sahara.c                            |    1 -
 drivers/crypto/talitos.c                           |    1 -
 drivers/crypto/ux500/cryp/cryp_core.c              |    4 +-
 drivers/crypto/ux500/hash/hash_core.c              |    2 +-
 drivers/md/dm-crypt.c                              |    2 +-
 drivers/md/dm-integrity.c                          |    2 +-
 drivers/net/wireless/cisco/airo.c                  |    2 +-
 drivers/net/wireless/intersil/orinoco/mic.c        |    6 +-
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c       |    2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    2 +-
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 fs/ubifs/auth.c                                    |    5 +-
 include/crypto/acompress.h                         |   38 +-
 include/crypto/aead.h                              |   41 +-
 include/crypto/akcipher.h                          |   74 +-
 include/crypto/chacha.h                            |   54 +
 include/crypto/chacha20.h                          |   27 -
 include/crypto/hash.h                              |   32 +-
 include/crypto/hash_info.h                         |    1 +
 include/crypto/internal/cryptouser.h               |    9 +-
 include/crypto/internal/skcipher.h                 |    2 -
 include/crypto/kpp.h                               |   48 +-
 include/crypto/nhpoly1305.h                        |   74 +
 include/crypto/poly1305.h                          |   28 +-
 include/crypto/rng.h                               |   27 +-
 include/crypto/skcipher.h                          |   49 +-
 include/crypto/streebog.h                          |   34 +
 include/linux/crypto.h                             |  331 +-
 include/uapi/linux/cryptouser.h                    |  102 +-
 include/uapi/linux/hash_info.h                     |    2 +
 kernel/padata.c                                    |    2 +-
 lib/Makefile                                       |    2 +-
 lib/{chacha20.c => chacha.c}                       |   59 +-
 net/bluetooth/smp.c                                |    8 +-
 net/mac80211/wep.c                                 |    4 +-
 net/wireless/lib80211_crypt_ccmp.c                 |    2 +-
 net/wireless/lib80211_crypt_tkip.c                 |    4 +-
 net/wireless/lib80211_crypt_wep.c                  |    4 +-
 security/apparmor/crypto.c                         |    2 +-
 security/integrity/evm/evm_crypto.c                |    3 +-
 security/keys/encrypted-keys/encrypted.c           |    4 +-
 security/keys/trusted.c                            |    4 +-
 tools/crypto/getstat.c                             |   72 +-
 183 files changed, 16615 insertions(+), 5868 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
