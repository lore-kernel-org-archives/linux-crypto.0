From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.19
Date: Wed, 15 Aug 2018 20:05:46 +0800
Message-ID: <20180815120546.77xvvf7z3kpc2am6@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
 <20180129145012.GA12805@gondor.apana.org.au>
 <20180404152752.GA11822@gondor.apana.org.au>
 <20180604171552.lctgpei4y4xzogoo@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604171552.lctgpei4y4xzogoo@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

Here is the crypto update for 4.19:

API:

- Fix dcache flushing crash in skcipher.
- Add hash finup self-tests.
- Reschedule during speed tests.

Algorithms:

- Remove insecure vmac and replace it with vmac64.
- Add public key verification for DH/ECDH.

Drivers:

- Decrease priority of sha-mb on x86.
- Improve NEON latency/throughput on ARM64.
- Add md5/sha384/sha512/des/3des to inside-secure.
- Support eip197d in inside-secure.
- Only register algorithms supported by the host in virtio.
- Add cts and remove incompatible cts1 from ccree.
- Add hisilicon SEC security accelerator driver.
- Replace msm hwrng driver with qcom pseudo rng driver.

Misc:

- Centralise CRC polynomials.

Please note that there are conflicts between the crypto tree and
the staging tree due to the removal of skein, to resolve that
conflict simply remove skein as is done in the staging tree.

There is also a conflict with the net tree because of changes in
CRC code that was touched in both trees.  To resolve this conflict,
simply use the net tree version of the driver but remove the CRC
polynomial macros as is done in the crypto tree.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Tenart (19):
      crypto: inside-secure - use the error handler for invalidation requests
      crypto: inside-secure - improve the counter computation
      crypto: sha512_generic - add a sha512 0-length pre-computed hash
      crypto: inside-secure - sha512 support
      crypto: inside-secure - hmac(sha512) support
      crypto: inside-secure - authenc(hmac(sha512), cbc(aes)) support
      crypto: sha512_generic - add a sha384 0-length pre-computed hash
      crypto: inside-secure - sha384 support
      crypto: inside-secure - hmac(sha384) support
      crypto: inside-secure - authenc(hmac(sha384), cbc(aes)) support
      crypto: inside-secure - move the firmware to a better location
      crypto: inside-secure - use precise compatibles
      Documentation/bindings: crypto: inside-secure: update the compatibles
      crypto: inside-secure - filter out the algorithms by engine
      crypto: inside-secure - add an invalidation flag
      crypto: inside-secure - eip197d support
      Documentation/bindings: crypto: inside-secure: eip197d support
      crypto: inside-secure - switch to SPDX identifiers
      crypto: inside-secure - initialize first_rdesc to make GCC happy

Ard Biesheuvel (5):
      crypto: arm64/aes-ce-gcm - operate on two input blocks at a time
      crypto: arm64/aes-ce-gcm - implement 2-way aggregation
      crypto: arm64/aes-ce-gcm - don't reload key schedule if avoidable
      crypto: arm64/ghash-ce - replace NEON yield check with block limit
      crypto: arm64/ghash-ce - implement 4-way aggregation

Colin Ian King (3):
      lib/mpi: remove redundant variable esign
      crypto: aegis - fix indentation of a statement
      crypto: cavium - make structure algs static

Denis Efremov (1):
      crypto: skcipher - remove the exporting of skcipher_walk_next

Eric Biggers (27):
      crypto: vmac - require a block cipher with 128-bit block size
      crypto: vmac - separate tfm and request context
      crypto: vmac - add nonced version with big endian digest
      crypto: vmac - remove insecure version with hardcoded nonce
      crypto: x86/sha256-mb - fix digest copy in sha256_mb_mgr_get_comp_job_avx2()
      crypto: MAINTAINERS - fix file path for SHA multibuffer code
      crypto: sha1_generic - add cra_priority
      crypto: sha256_generic - add cra_priority
      crypto: sha512_generic - add cra_priority
      crypto: x86/sha-mb - decrease priority of multibuffer algorithms
      crypto: shash - remove useless setting of type flags
      crypto: ahash - remove useless setting of type flags
      crypto: ahash - remove useless setting of cra_type
      crypto: aead - remove useless setting of type flags
      crypto: skcipher - remove useless setting of type flags
      crypto: remove redundant type flags from tfm allocation
      crypto: arm64/sha256 - increase cra_priority of scalar implementations
      crypto: skcipher - fix aligning block size in skcipher_copy_iv()
      crypto: scatterwalk - remove 'chain' argument from scatterwalk_crypto_chain()
      crypto: scatterwalk - remove scatterwalk_samebuf()
      crypto: skcipher - remove unnecessary setting of walk->nbytes
      crypto: skcipher - fix crash flushing dcache in error path
      crypto: blkcipher - fix crash flushing dcache in error path
      crypto: ablkcipher - fix crash flushing dcache in error path
      crypto: arm/chacha20 - always use vrev for 16-bit rotates
      crypto: dh - fix calculating encoded key size
      crypto: dh - make crypto_dh_encode_key() make robust

Farhan Ali (2):
      crypto: virtio - Read crypto services and algorithm masks
      crypto: virtio - Register an algo only if it's supported

Gilad Ben-Yossef (9):
      crypto: testmgr - add hash finup tests
      crypto: ccree - fix iv handling
      crypto: ccree - remove dead legacy code
      crypto: ccree - use CBC-CS3 CTS mode
      crypto: ccree - rate limit debug print
      crypto: ccree - drop useless type flag during reg
      crypto: ccree - remove cipher ivgen left overs
      crypto: ccree - zero all of request ctx before use
      crypto: ccree - allow bigger than sector XTS op

Gustavo A. R. Silva (4):
      crypto: chtls - use 64-bit arithmetic instead of 32-bit
      crypto: dh - fix memory leak
      crypto: rmd256 - use swap macro in rmd256_transform
      crypto: rmd320 - use swap macro in rmd320_transform

Hadar Gat (1):
      crypto: ccree - fix finup

Herbert Xu (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geantă (1):
      crypto: tcrypt - reschedule during speed tests

Jia-Ju Bai (3):
      crypto: cavium/nitrox - Replace GFP_ATOMIC with GFP_KERNEL in crypto_alloc_context()
      crypto: qat/adf_aer - Replace GFP_ATOMIC with GFP_KERNEL in adf_dev_aer_schedule_reset()
      crypto: virtio - Replace GFP_ATOMIC with GFP_KERNEL in __virtio_crypto_ablkcipher_do_req()

Jonathan Cameron (3):
      dt-bindings: Add bindings for Hisilicon SEC crypto accelerators.
      crypto: hisilicon - SEC security accelerator driver
      arm64: dts: hisi: add SEC crypto accelerator nodes for hip07 SoC

Krzysztof Kozlowski (6):
      lib/crc: Move polynomial definition to separate header
      lib/crc: Use consistent naming for CRC-32 polynomials
      crypto: stm32_crc32 - Use existing define with polynomial
      net: ethernet: Use existing define with polynomial
      staging: rtl: Use existing define with polynomial
      lib: Use existing define with polynomial

Michael Müller (1):
      crypto: sharah - Unregister correct algorithms for SAHARA 3

Ofer Heifetz (11):
      crypto: inside-secure - increase minimum transfer size
      crypto: inside-secure - dynamic ring configuration allocation
      crypto: inside-secure - add multiple processing engine support
      crypto: inside-secure - adjust the TRC configuration for EIP197D
      crypto: inside-secure - reset CDR and RDR rings on module removal
      crypto: inside-secure - set tx_max_cmd_queue to 32
      crypto: inside-secure - md5 support
      crypto: inside-secure - hmac(md5) support
      crypto: inside-secure - ecb(des) and cbc(des) support
      crypto: inside-secure - ecb(des3_ede) and cbc(des3_ede) support
      crypto: inside-secure - remove request list to improve performance

Stafford Horne (1):
      crypto: skcipher - Fix -Wstringop-truncation warnings

Stephan Mueller (5):
      crypto: ecdh - add public key verification test
      crypto: dh - add public key verification test
      crypto: drbg - eliminate constant reinitialization of SGL
      crypto: dh - update test for public key verification
      crypto: ecdh - fix typo of P-192 b value

Stephan Müller (1):
      crypto: drbg - in-place cipher operation for CTR

Timur Tabi (1):
      crypto: qcom-rng - Add ACPI support

Tom Lendacky (6):
      crypto: ccp - Fix command completion detection race
      crypto: ccp - Add psp enabled message when initialization succeeds
      crypto: ccp - Remove unused #defines
      crypto: ccp - Support register differences between PSP devices
      crypto: ccp - Add support for new CCP/PSP device ID
      crypto: ccp - Check for NULL PSP pointer at module unload

Tudor-Dan Ambarus (2):
      crypto: atmel-ecc - fix to allow multi segment scatterlists
      crypto: atmel-ecc - remove overly verbose dev_info

Vinod Koul (5):
      hwrng: msm - remove msm hw_random driver
      dt-bindings: crypto: Move prng binding to crypto
      crypto: qcom-rng - Add Qcom prng driver
      dt-bindings: crypto: Add new compatible qcom, prng-ee
      crypto: qcom-rng - Add support for prng-ee

kbuild test robot (1):
      crypto: hisilicon - sec_send_request() can be static

lionel.debieve@st.com (3):
      crypto: stm32/cryp - Add power management support
      crypto: stm32/hash - Add power management support
      crypto: stm32/crc - Add power management support

 Documentation/crypto/api-samples.rst               |    2 +-
 .../bindings/crypto/hisilicon,hip07-sec.txt        |   67 +
 .../bindings/crypto/inside-secure-safexcel.txt     |   15 +-
 .../bindings/{rng => crypto}/qcom,prng.txt         |    4 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/crypto/chacha20-neon-core.S               |   10 +-
 arch/arm/crypto/ghash-ce-glue.c                    |    5 +-
 arch/arm/crypto/sha1-ce-glue.c                     |    1 -
 arch/arm/crypto/sha1_glue.c                        |    1 -
 arch/arm/crypto/sha1_neon_glue.c                   |    1 -
 arch/arm/crypto/sha2-ce-glue.c                     |    2 -
 arch/arm/crypto/sha256_glue.c                      |    2 -
 arch/arm/crypto/sha256_neon_glue.c                 |    2 -
 arch/arm/crypto/sha512-glue.c                      |    2 -
 arch/arm/crypto/sha512-neon-glue.c                 |    2 -
 arch/arm64/boot/dts/hisilicon/hip07.dtsi           |  284 +++++
 arch/arm64/crypto/aes-glue.c                       |    3 -
 arch/arm64/crypto/ghash-ce-core.S                  |  271 ++--
 arch/arm64/crypto/ghash-ce-glue.c                  |  204 +--
 arch/arm64/crypto/sha1-ce-glue.c                   |    1 -
 arch/arm64/crypto/sha2-ce-glue.c                   |    2 -
 arch/arm64/crypto/sha256-glue.c                    |    8 +-
 arch/arm64/crypto/sha3-ce-glue.c                   |    4 -
 arch/arm64/crypto/sha512-ce-glue.c                 |    2 -
 arch/arm64/crypto/sha512-glue.c                    |    2 -
 arch/arm64/crypto/sm3-ce-glue.c                    |    1 -
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |    1 -
 arch/mips/cavium-octeon/crypto/octeon-sha1.c       |    1 -
 arch/mips/cavium-octeon/crypto/octeon-sha256.c     |    2 -
 arch/mips/cavium-octeon/crypto/octeon-sha512.c     |    2 -
 arch/powerpc/crypto/md5-glue.c                     |    1 -
 arch/powerpc/crypto/sha1-spe-glue.c                |    1 -
 arch/powerpc/crypto/sha1.c                         |    1 -
 arch/powerpc/crypto/sha256-spe-glue.c              |    2 -
 arch/s390/crypto/aes_s390.c                        |    1 -
 arch/s390/crypto/ghash_s390.c                      |    1 -
 arch/s390/crypto/sha1_s390.c                       |    1 -
 arch/s390/crypto/sha256_s390.c                     |    2 -
 arch/s390/crypto/sha512_s390.c                     |    2 -
 arch/sparc/crypto/md5_glue.c                       |    1 -
 arch/sparc/crypto/sha1_glue.c                      |    1 -
 arch/sparc/crypto/sha256_glue.c                    |    2 -
 arch/sparc/crypto/sha512_glue.c                    |    2 -
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    6 +-
 arch/x86/crypto/poly1305_glue.c                    |    1 -
 arch/x86/crypto/sha1-mb/sha1_mb.c                  |   17 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |    4 -
 arch/x86/crypto/sha256-mb/sha256_mb.c              |   18 +-
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |    2 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |    8 -
 arch/x86/crypto/sha512-mb/sha512_mb.c              |   18 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |    6 -
 crypto/ablkcipher.c                                |   59 +-
 crypto/aegis128.c                                  |    1 -
 crypto/aegis128l.c                                 |    3 +-
 crypto/aegis256.c                                  |    1 -
 crypto/blkcipher.c                                 |   55 +-
 crypto/crypto_null.c                               |    1 -
 crypto/dh.c                                        |   66 +-
 crypto/dh_helper.c                                 |   43 +-
 crypto/drbg.c                                      |   39 +-
 crypto/ecc.c                                       |   42 +-
 crypto/ecc_curve_defs.h                            |   22 +-
 crypto/ghash-generic.c                             |    1 -
 crypto/lrw.c                                       |    4 +-
 crypto/md4.c                                       |    1 -
 crypto/md5.c                                       |    1 -
 crypto/morus1280.c                                 |    1 -
 crypto/morus640.c                                  |    1 -
 crypto/poly1305_generic.c                          |    1 -
 crypto/rmd128.c                                    |    1 -
 crypto/rmd160.c                                    |    1 -
 crypto/rmd256.c                                    |   11 +-
 crypto/rmd320.c                                    |   13 +-
 crypto/scatterwalk.c                               |    2 +-
 crypto/sha1_generic.c                              |    2 +-
 crypto/sha256_generic.c                            |    4 +-
 crypto/sha3_generic.c                              |    4 -
 crypto/sha512_generic.c                            |   26 +-
 crypto/skcipher.c                                  |   57 +-
 crypto/sm3_generic.c                               |    1 -
 crypto/tcrypt.c                                    |   38 +-
 crypto/testmgr.c                                   |   59 +-
 crypto/testmgr.h                                   |  233 ++--
 crypto/tgr192.c                                    |    3 -
 crypto/vmac.c                                      |  444 ++++---
 crypto/wp512.c                                     |    3 -
 crypto/xts.c                                       |    4 +-
 drivers/char/hw_random/Kconfig                     |   13 -
 drivers/char/hw_random/Makefile                    |    1 -
 drivers/char/hw_random/msm-rng.c                   |  183 ---
 drivers/crypto/Kconfig                             |   15 +
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/amcc/crypto4xx_core.c               |   18 +-
 drivers/crypto/atmel-ecc.c                         |   35 +-
 drivers/crypto/atmel-sha.c                         |    4 +-
 drivers/crypto/axis/artpec6_crypto.c               |   28 +-
 drivers/crypto/bcm/cipher.c                        |    8 +-
 drivers/crypto/caam/caamhash.c                     |    3 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |    2 +-
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |    3 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    3 +-
 drivers/crypto/ccp/psp-dev.c                       |   35 +-
 drivers/crypto/ccp/psp-dev.h                       |   19 +-
 drivers/crypto/ccp/sp-dev.h                        |    7 +-
 drivers/crypto/ccp/sp-pci.c                        |   36 +-
 drivers/crypto/ccree/cc_aead.c                     |   16 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |    8 +-
 drivers/crypto/ccree/cc_cipher.c                   |  170 +--
 drivers/crypto/ccree/cc_cipher.h                   |    1 -
 drivers/crypto/ccree/cc_driver.c                   |    4 +-
 drivers/crypto/ccree/cc_driver.h                   |    1 -
 drivers/crypto/ccree/cc_hash.c                     |   85 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    7 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c            |    2 +-
 drivers/crypto/hisilicon/Kconfig                   |   14 +
 drivers/crypto/hisilicon/Makefile                  |    2 +
 drivers/crypto/hisilicon/sec/Makefile              |    3 +
 drivers/crypto/hisilicon/sec/sec_algs.c            | 1122 +++++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.c             | 1323 ++++++++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.h             |  428 +++++++
 drivers/crypto/inside-secure/safexcel.c            |  474 ++++---
 drivers/crypto/inside-secure/safexcel.h            |  201 +--
 drivers/crypto/inside-secure/safexcel_cipher.c     |  492 ++++++--
 drivers/crypto/inside-secure/safexcel_hash.c       |  560 +++++++--
 drivers/crypto/inside-secure/safexcel_ring.c       |   63 +-
 drivers/crypto/marvell/hash.c                      |    3 +-
 drivers/crypto/n2_core.c                           |    3 +-
 drivers/crypto/nx/nx-aes-xcbc.c                    |    1 -
 drivers/crypto/nx/nx-sha256.c                      |    1 -
 drivers/crypto/nx/nx-sha512.c                      |    1 -
 drivers/crypto/omap-sham.c                         |   36 +-
 drivers/crypto/padlock-sha.c                       |    8 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |    2 +-
 drivers/crypto/qce/sha.c                           |    3 +-
 drivers/crypto/qcom-rng.c                          |  229 ++++
 drivers/crypto/s5p-sss.c                           |    9 +-
 drivers/crypto/sahara.c                            |   10 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   62 +
 drivers/crypto/stm32/stm32-hash.c                  |   95 +-
 drivers/crypto/stm32/stm32_crc32.c                 |   71 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |   20 +-
 drivers/crypto/talitos.c                           |   37 +-
 drivers/crypto/ux500/hash/hash_core.c              |   15 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |  116 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |   25 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   29 +
 drivers/crypto/virtio/virtio_crypto_mgr.c          |   81 +-
 drivers/crypto/vmx/ghash.c                         |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |    4 +-
 drivers/net/ethernet/apple/bmac.c                  |    8 +-
 drivers/net/ethernet/broadcom/tg3.c                |    3 +-
 drivers/net/ethernet/freescale/fec_main.c          |    4 +-
 drivers/net/ethernet/freescale/fs_enet/fec.h       |    3 -
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |    3 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |    3 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c      |    4 +-
 drivers/staging/rtl8712/rtl871x_security.c         |    5 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |    5 +-
 drivers/staging/skein/skein_generic.c              |    3 -
 include/crypto/dh.h                                |    4 +
 include/crypto/drbg.h                              |    3 +-
 include/crypto/scatterwalk.h                       |   15 +-
 include/crypto/sha.h                               |    4 +
 include/crypto/vmac.h                              |   63 -
 include/linux/crc32poly.h                          |   20 +
 lib/crc32.c                                        |   11 +-
 lib/crc32defs.h                                    |   14 -
 lib/decompress_bunzip2.c                           |    3 +-
 lib/gen_crc32table.c                               |    5 +-
 lib/mpi/mpi-pow.c                                  |    3 +-
 lib/xz/xz_crc32.c                                  |    3 +-
 net/tls/tls_device_fallback.c                      |    2 +-
 security/keys/dh.c                                 |    2 +-
 175 files changed, 6690 insertions(+), 2011 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
