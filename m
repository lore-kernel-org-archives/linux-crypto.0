From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.13
Date: Wed, 5 Jul 2017 21:01:24 +0800
Message-ID: <20170705130124.GA3755@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170223125141.GA17400@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

Here is the crypto update for 4.13:

Algorithms:

- Add private key generation to ecdh.

Drivers:

- Add generic gcm(aes) to aesni-intel.
- Add SafeXcel EIP197 crypto engine driver.
- Add ecb(aes), cfb(aes) and ecb(des3_ede) to cavium.
- Add support for CNN55XX adapters in cavium.
- Add ctr mode to chcr.
- Add support for gcm(aes) to omap.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Ténart (24):
      crypto: inside-secure - add SafeXcel EIP197 crypto engine driver
      MAINTAINERS: add a maintainer for the Inside Secure crypto driver
      crypto: sun4i-ss - group variable definitions in sun4i_hash()
      crypto: sun4i-ss - remove conditional checks against 0
      crypto: sun4i-ss - use lower/upper_32_bits helpers
      crypto: sun4i-ss - cannot use DMA is the request is 0 length
      crypto: sun4i-ss - do not dynamically set parts of the last buffer to 0
      crypto: sun4i-ss - simplify the pad length calculation
      crypto: sun4i-ss - simplify the appended bit assignment
      crypto: sun4i-ss - use GENMASK to generate masks
      crypto: sun4i-ss - move from ablkcipher to skcipher API
      crypto: sun4i-ss - add the CRYPTO_ALG_KERN_DRIVER_ONLY flag
      crypto: sun4i-ss - fix large block size support
      crypto: inside-secure - use hmac ipad/opad constants
      crypto: inside-secure - fix the ring wr_cache offset
      crypto: inside-secure - fix incorrect DSE data cache setting
      crypto: inside-secure - update the context and request later
      crypto: inside-secure - use one queue per hw ring
      crypto: inside-secure - stop requeueing failed requests
      crypto: inside-secure - get the backlog before dequeueing the request
      crypto: inside-secure - only dequeue when needed
      crypto: inside-secure - increase the batch size
      crypto: inside-secure - use the base_end pointer in ring rollback
      Documentation/bindings: Document the SafeXel cryptographic engine driver

Ard Biesheuvel (6):
      crypto: arm64/sha - avoid non-standard inline asm tricks
      crypto: arm/aes-ce - enable module autoloading based on CPU feature bits
      crypto: arm/ghash-ce - enable module autoloading based on CPU feature bits
      crypto: arm/sha1-ce - enable module autoloading based on CPU feature bits
      crypto: arm/sha2-ce - enable module autoloading based on CPU feature bits
      crypto: arm/crc32 - enable module autoloading based on CPU feature bits

Arvind Yadav (4):
      hwrng: omap3-rom - Handle return value of clk_prepare_enable
      crypto: img-hash - Handle return value of clk_prepare_enable
      crypto: n2 - make of_device_ids const
      crypto: caam - make of_device_ids const.

Benjamin Peterson (1):
      crypto: doc - fix typo in docs

Christoph Hellwig (1):
      crypto: qat - use pcie_flr instead of duplicating it

Christophe Jaillet (1):
      crypto: crypto4xx - fix an error code

Colin Ian King (3):
      crypto: brcm - fix spelling mistake: "fallbck" -> "fallback"
      crypto: omap-aes - fix spelling mistake "Encryptio" -> "Encryption"
      crypto: cavium - fix spelling mistake "Revsion" -> "Revision"

Corentin LABBE (10):
      crypto: hmac - add hmac IPAD/OPAD constant
      crypto: brcm - Use IPAD/OPAD constant
      crypto: ixp4xx - Use IPAD/OPAD constant
      crypto: marvell - Use IPAD/OPAD constant
      crypto: mv_cesa - Use IPAD/OPAD constant
      crypto: omap-sham - Use IPAD/OPAD constant
      crypto: qat - Use IPAD/OPAD constant
      crypto: mediatek - Use IPAD/OPAD constant
      crypto: ccp - Use IPAD/OPAD constant
      crypto: engine - replace pr_xxx by dev_xxx

Dan Carpenter (4):
      crypto: sha512-mb - add some missing unlock on error
      X.509: Fix error code in x509_cert_parse()
      crypto: glue_helper - Delete some dead code
      crypto: cavium/nitrox - dma_mapping_error() returns bool

Eric Biggers (2):
      crypto: x86/aes - Don't use %rbp as temporary register
      crypto: aes_ti - fix comment for MixColumns step

Gary R Hook (3):
      crypto: ccp - Add a module author
      crypto: ccp - Add debugfs entries for CCP information
      crypto: ccp - Release locks before returning

Geliang Tang (1):
      crypto: mediatek - drop .owner field in mtk_crypto_driver

George Cherian (3):
      crypto: cavium - Downgrade the annoying misc interrupt print from dev_err to dev_dbg
      crypto: cavium - Remove the individual encrypt/decrypt function for each algorithm
      crypto: cavium - Add more algorithms

Gilad Ben-Yossef (2):
      crypto: tcrypt - don't disable irqs and wait
      crypto: testmgr - use consistent format for errors

Harsh Jain (9):
      crypto: chcr - Pass lcb bit setting to firmware
      crypto: chcr - Fix fallback key setting
      crypto: chcr - Return correct error code
      crypto: chcr - Avoid changing request structure
      crypto: chcr - Add ctr mode and process large sg entries for cipher
      chcr - Add debug counters
      MAINTAINERS: Add maintainer for chelsio crypto driver
      crypto: chcr - Ensure Destination sg entry size less than 2k
      crypto: chcr - Select device in Round Robin fashion

Herbert Xu (2):
      crypto: testmgr - Reenable sha1/aes in FIPS mode
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geantă (2):
      crypto: caam - fix gfp allocation flags (part I)
      crypto: caam - fix gfp allocation flags (part II)

Igal Liberman (2):
      crypto: inside-secure - enable single WR in DSE configuration
      crypto: inside-secure - optimize DSE bufferability control

Jason A. Donenfeld (1):
      crypto: rsa-pkcs1pad - use constant time memory comparison for MACs

Kamil Konieczny (1):
      crypto: doc - Fixed bugs, added example usage of calc_hash().

Karim Eshapa (1):
      crypto: algapi - Use pr_err common logging style.

Martin Hicks (1):
      crypto: talitos - Extend max key length for SHA384/512-HMAC and AEAD

Matthias Kaehlcke (1):
      crypto: rng - Remove unused function __crypto_rng_cast()

Ofer Heifetz (1):
      crypto: inside-secure - align the cipher and hash send functions

Radu Alexe (3):
      crypto: caam - incapsulate dropping leading zeros into function
      crypto: caam - add support for RSA key form 2
      crypto: caam - add support for RSA key form 3

Rick Altherr (2):
      dt-bindings: timeriomem_rng: Add entropy quality property
      hw_random: timeriomem_rng: Allow setting RNG quality from platform data

Ryder Lee (2):
      crypto: mediatek - remove redundant clock setting
      dt-bindings: crypto: remove mediatek ethif clock

Sabrina Dubroca (7):
      crypto: aesni - make non-AVX AES-GCM work with any aadlen
      crypto: aesni - make non-AVX AES-GCM work with all valid auth_tag_len
      crypto: aesni - make AVX AES-GCM work with any aadlen
      crypto: aesni - make AVX AES-GCM work with all valid auth_tag_len
      crypto: aesni - make AVX2 AES-GCM work with any aadlen
      crypto: aesni - make AVX2 AES-GCM work with all valid auth_tag_len
      crypto: aesni - add generic gcm(aes)

Sean Wang (3):
      dt-bindings: rng: add MediaTek MT7622 Hardware Random Generator bindings
      hwrng: mtk - add runtime PM support
      MAINTAINERS: add entry for MediaTek Random Number Generator

Srikanth Jampala (3):
      crypto: cavium - Add support for CNN55XX adapters.
      crypto: cavium - Add debugfs support in CNN55XX driver.
      crypto: cavium - Register the CNN55XX supported crypto algorithms.

Stephan Mueller (3):
      crypto: drbg - Fixes panic in wait_for_completion call
      crypto: testmgr - add testvector for pkcs1pad(rsa)
      crypto: drbg - Fixes panic in wait_for_completion call

Tero Kristo (13):
      crypto: omap-aes - drop unused flags attribute from omap_aes_ctx
      crypto: omap-aes - fix context handling for multiple cores
      crypto: omap-des - add check for weak keys
      crypto: omap-des - use runtime_pm autosuspend for clock handling
      crypto: omap - add base support library for common routines
      crypto: omap-des - use base omap crypto support library
      crypto: omap-aes - use base omap crypto support library
      crypto: omap-aes - move definitions over to a separate header file
      crypto: omap-aes - export some AES driver functionality locally
      crypto: omap-aes - Add support for GCM mode
      crypto: omap-sham - buffer handling fixes for hashing later
      crypto: omap-sham - fix closing of hash with separate finalize call
      crypto: omap-sham - force word alignment on the xmit-buf also

Tudor Ambarus (1):
      crypto: caam - avoid kzalloc(0) in caam_read_raw_data

Tudor-Dan Ambarus (17):
      crypto: kpp, (ec)dh - fix typos
      crypto: ecc - remove unused function arguments
      crypto: ecc - remove unnecessary casts
      crypto: ecc - rename ecdh_make_pub_key()
      crypto: dh - fix memleak in setkey
      crypto: kpp - assume key is already set in maxsize
      crypto: dh - comply with crypto_kpp_maxsize()
      crypto: ecdh - comply with crypto_kpp_maxsize()
      crypto: qat - comply with crypto_kpp_maxsize()
      crypto: akcipher - assume key is already set in maxsize
      crypto: rsa - comply with crypto_akcipher_maxsize()
      crypto: caampkc - comply with crypto_akcipher_maxsize()
      crypto: qat - comply with crypto_akcipher_maxsize()
      crypto: pkcs1pad - comply with crypto_akcipher_maxsize()
      crypto: ecdh - add privkey generation support
      crypto: testmgr - add genkey kpp test
      crypto: vmx - remove unnecessary check

pjambhlekar (1):
      crypto: ccp - return NULL instead of 0

 Documentation/crypto/api-samples.rst               |   38 +-
 Documentation/crypto/userspace-if.rst              |    2 +-
 .../bindings/crypto/inside-secure-safexcel.txt     |   29 +
 .../devicetree/bindings/crypto/mediatek-crypto.txt |    8 +-
 Documentation/devicetree/bindings/rng/mtk-rng.txt  |    4 +-
 .../devicetree/bindings/rng/timeriomem_rng.txt     |    7 +
 MAINTAINERS                                        |   18 +
 arch/arm/crypto/aes-ce-glue.c                      |    6 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    6 +
 arch/arm/crypto/ghash-ce-glue.c                    |    6 +-
 arch/arm/crypto/sha1-ce-glue.c                     |    5 +-
 arch/arm/crypto/sha2-ce-glue.c                     |    5 +-
 arch/arm64/crypto/sha1-ce-core.S                   |    6 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   11 +-
 arch/arm64/crypto/sha2-ce-core.S                   |    6 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   13 +-
 arch/x86/crypto/aes-x86_64-asm_64.S                |   47 +-
 arch/x86/crypto/aesni-intel_asm.S                  |  231 ++++-
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |  283 +++--
 arch/x86/crypto/aesni-intel_glue.c                 |  208 +++-
 arch/x86/crypto/glue_helper.c                      |    3 -
 arch/x86/crypto/sha512-mb/sha512_mb.c              |    7 +-
 crypto/Kconfig                                     |    1 +
 crypto/Makefile                                    |    9 +-
 crypto/aes_ti.c                                    |    2 +-
 crypto/algapi.c                                    |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |    1 +
 crypto/crypto_engine.c                             |   23 +-
 crypto/dh.c                                        |    9 +-
 crypto/dh_helper.c                                 |    4 +-
 crypto/drbg.c                                      |    1 +
 crypto/ecc.c                                       |   88 +-
 crypto/ecc.h                                       |   41 +-
 crypto/ecdh.c                                      |   29 +-
 crypto/ecdh_helper.c                               |    4 +-
 crypto/hmac.c                                      |    5 +-
 crypto/rng.c                                       |    5 -
 crypto/rsa-pkcs1pad.c                              |   12 +-
 crypto/rsa.c                                       |    4 +-
 crypto/tcrypt.c                                    |    4 -
 crypto/testmgr.c                                   |  128 ++-
 crypto/testmgr.h                                   |  143 +++
 drivers/char/hw_random/mtk-rng.c                   |   42 +
 drivers/char/hw_random/omap3-rom-rng.c             |   11 +-
 drivers/char/hw_random/timeriomem-rng.c            |    7 +
 drivers/crypto/Kconfig                             |   30 +
 drivers/crypto/Makefile                            |    6 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    1 +
 drivers/crypto/bcm/cipher.c                        |    7 +-
 drivers/crypto/caam/caamalg.c                      |   10 +-
 drivers/crypto/caam/caamalg_qi.c                   |   10 +-
 drivers/crypto/caam/caamhash.c                     |   32 +-
 drivers/crypto/caam/caampkc.c                      |  472 ++++++++-
 drivers/crypto/caam/caampkc.h                      |   58 ++
 drivers/crypto/caam/jr.c                           |    2 +-
 drivers/crypto/caam/pdb.h                          |   62 ++
 drivers/crypto/caam/pkc_desc.c                     |   36 +
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  234 +++--
 drivers/crypto/cavium/cpt/cptvf_algs.h             |    7 +
 drivers/crypto/cavium/cpt/cptvf_main.c             |    2 +-
 drivers/crypto/cavium/nitrox/Kconfig               |   21 +
 drivers/crypto/cavium/nitrox/Makefile              |    8 +
 drivers/crypto/cavium/nitrox/nitrox_algs.c         |  457 ++++++++
 drivers/crypto/cavium/nitrox/nitrox_common.h       |   42 +
 drivers/crypto/cavium/nitrox/nitrox_csr.h          | 1084 +++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h          |  179 ++++
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |  401 +++++++
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |  467 +++++++++
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |  210 ++++
 drivers/crypto/cavium/nitrox/nitrox_main.c         |  640 ++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_req.h          |  445 ++++++++
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |  735 +++++++++++++
 drivers/crypto/ccp/Makefile                        |    3 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    5 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |  344 ++++++
 drivers/crypto/ccp/ccp-dev-v5.c                    |   28 +-
 drivers/crypto/ccp/ccp-dev.c                       |    3 +-
 drivers/crypto/ccp/ccp-dev.h                       |   20 +
 drivers/crypto/ccp/ccp-platform.c                  |    4 +-
 drivers/crypto/chelsio/chcr_algo.c                 | 1096 ++++++++++++++++----
 drivers/crypto/chelsio/chcr_algo.h                 |   30 +-
 drivers/crypto/chelsio/chcr_core.c                 |   56 +-
 drivers/crypto/chelsio/chcr_core.h                 |    5 +-
 drivers/crypto/chelsio/chcr_crypto.h               |   25 +-
 drivers/crypto/img-hash.c                          |   12 +-
 drivers/crypto/inside-secure/Makefile              |    2 +
 drivers/crypto/inside-secure/safexcel.c            |  926 +++++++++++++++++
 drivers/crypto/inside-secure/safexcel.h            |  574 ++++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c     |  561 ++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c       | 1052 +++++++++++++++++++
 drivers/crypto/inside-secure/safexcel_ring.c       |  157 +++
 drivers/crypto/ixp4xx_crypto.c                     |    3 +-
 drivers/crypto/marvell/hash.c                      |    5 +-
 drivers/crypto/mediatek/mtk-platform.c             |   11 +-
 drivers/crypto/mediatek/mtk-platform.h             |    2 -
 drivers/crypto/mediatek/mtk-sha.c                  |    5 +-
 drivers/crypto/mv_cesa.c                           |    5 +-
 drivers/crypto/n2_core.c                           |    4 +-
 drivers/crypto/omap-aes-gcm.c                      |  408 ++++++++
 drivers/crypto/omap-aes.c                          |  461 ++++----
 drivers/crypto/omap-aes.h                          |  214 ++++
 drivers/crypto/omap-crypto.c                       |  184 ++++
 drivers/crypto/omap-crypto.h                       |   37 +
 drivers/crypto/omap-des.c                          |  138 +--
 drivers/crypto/omap-sham.c                         |   38 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |   15 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    5 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |    8 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  213 ++--
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |  237 +++--
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  138 +--
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |   34 +-
 drivers/crypto/talitos.c                           |    7 +-
 drivers/crypto/vmx/aes.c                           |    7 +-
 drivers/crypto/vmx/aes_cbc.c                       |    7 +-
 drivers/crypto/vmx/aes_ctr.c                       |    7 +-
 drivers/crypto/vmx/aes_xts.c                       |    7 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   35 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   10 +
 include/crypto/akcipher.h                          |   11 +-
 include/crypto/dh.h                                |    4 +-
 include/crypto/ecdh.h                              |    4 +-
 include/crypto/engine.h                            |    1 +
 include/crypto/hmac.h                              |    7 +
 include/crypto/kpp.h                               |   15 +-
 include/linux/timeriomem-rng.h                     |    3 +
 128 files changed, 12842 insertions(+), 1535 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
