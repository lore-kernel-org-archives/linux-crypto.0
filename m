From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.8
Date: Mon, 25 Jul 2016 18:53:00 +0800
Message-ID: <20160725105300.GA5894@gondor.apana.org.au>
References: <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160315072040.GA18381@gondor.apana.org.au>
 <20160516071608.GA1594@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43874 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbcGYKxf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jul 2016 06:53:35 -0400
Content-Disposition: inline
In-Reply-To: <20160516071608.GA1594@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.8:

API:

* First part of skcipher low-level conversions.
* Add KPP (Key-agreement Protocol Primitives) interface.

Algorithms:

* Fix IPsec/cryptd reordering issues that affects aesni.
* RSA no longer does explicit leading zero removal.
* Add SHA3.
* Add DH.
* Add ECDH.
* Improve DRBG performance by not doing CTR by hand.

Drivers:

* Add x86 AVX2 multibuffer SHA256/512.
* Add POWER8 optimised crc32c.
* Add xts support to vmx.
* Add DH support to qat.
* Add RSA support to caam.
* Add Layerscape support to caam.
* Add SEC1 AEAD support to talitos.
* Improve performance by chaining requests in marvell/cesa.
* Add support for Araneus Alea I USB RNG.
* Add support for Broadcom BCM5301 RNG.
* Add support for Amlogic Meson RNG.
* Add support Broadcom NSP SoC RNG.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git li=
nus


Amitoj Kaur Chawla (1):
      crypto: bfin_crc - Simplify use of devm_ioremap_resource

Andrea Gelmini (2):
      crypto: doc - Fix typo
      crypto: powerpc - Fix typo

Anton Blanchard (2):
      powerpc: define FUNC_START/FUNC_END
      crypto: powerpc - Add POWER8 optimised crc32c

Arnd Bergmann (2):
      crypto: caam - fix misspelled upper_32_bits
      crypto: ux500 - do not build with -O0

Ben Dooks (1):
      hwrng: exynos - fixup IO accesors

Bhaktipriya Shridhar (1):
      crypto: qat - Remove deprecated create_workqueue

Bin Liu (2):
      crypto: omap-sham - set sw fallback to 240 bytes
      crypto: omap-sham - increase cra_proirity to 400

Bob Ham (2):
      hwrng: chaoskey - Add support for Araneus Alea I USB RNG
      hwrng: chaoskey - Fix URB warning due to timeout on Alea

Conor McLoughlin (1):
      crypto: qat - Use alternative reset methods depending on the spec=
ific device

Cristian Stoica (1):
      crypto: caam - fix offset field in hw sg entries

Dan Carpenter (2):
      crypto: drbg - fix an error code in drbg_init_sym_kernel()
      crypto: nx - off by one bug in nx_of_update_msc()

=46lorian Fainelli (2):
      hwrng: bcm2835 - Add support for Broadcom BCM5301x
      Documentation: devicetree: bindings: Add BCM5301x binding

Geert Uytterhoeven (2):
      MAINTAINERS: Add file patterns for crypto device tree bindings
      MAINTAINERS: Add file patterns for rng device tree bindings

Geliang Tang (1):
      crypto: skcipher - remove unused header cpumask.h

Giovanni Cabiddu (1):
      crypto: hash - shrink hash down to two types

Harsh Jain (1):
      crypto: authenc - Remove redundant sg_init_table call.

Herbert Xu (63):
      crypto: gcm - Filter out async ghash if necessary
      Revert "crypto: user - no parsing of CRYPTO_MSG_GETALG"
      crypto: chacha20-simd - Use generic code for small requests
      crypto: cryptd - Add helpers to check whether a tfm is queued
      crypto: aesni - Fix cryptd reordering problem on gcm
      crypto: ablk_helper - Fix cryptd reordering
      crypto: ghash-clmulni - Fix cryptd reordering
      crypto: ghash-ce - Fix cryptd reordering
      KEYS: Use skcipher for big keys
      crypto: tcrypt - Use unsigned long for mb ahash cycle counter
      crypto: tcrypt - Fix memory leaks/crashes in multibuffer hash spe=
ed test
      crypto: authenc - Consider ahash ASYNC bit
      crypto: ahash - Add padding in crypto_ahash_extsize
      crypto: tcrypt - Use skcipher
      crypto: aesni - Use crypto_cipher to derive rfc4106 subkey
      crypto: ccp - Use skcipher for fallback
      crypto: mxs-dcp - Use skcipher for fallback
      crypto: picoxcell - Use skcipher for fallback
      crypto: qce - Use skcipher for fallback
      crypto: sahara - Use skcipher for fallback
      crypto: s390/aes - Use skcipher for fallback
      crypto: api - Add crypto_inst_setname
      crypto: tcrypt - Add speed test for cts
      crypto: testmgr - Allow leading zeros in RSA
      crypto: rsa - Generate fixed-length output
      lib/mpi: Do not do sg_virt
      crypto: rsa-pkcs1pad - Require hash to be present
      crypto: rsa-pkcs1pad - Remove bogus page splitting
      crypto: rsa-pkcs1pad - Always use GFP_KERNEL
      crypto: rsa-pkcs1pad - Move key size check to setkey
      crypto: rsa-pkcs1pad - Avoid copying output when possible
      crypto: tcrypt - Do not bail on EINPROGRESS in multibuffer hash t=
est
      crypto: rsa-pkcs1pad - Fix regression from leading zeros
      crypto: skcipher - Add low-level skcipher interface
      crypto: null - Add new default null skcipher
      crypto: aead - Add chunk size
      crypto: authenc - Use skcipher
      crypto: authencesn - Use skcipher
      crypto: ctr - Use skcipher in rfc3686
      crypto: ccm - Use skcipher
      crypto: gcm - Use skcipher
      crypto: chacha20poly1305 - Use skcipher
      crypto: aead - Add skcipher null for IV generators
      crypto: echainiv - Use skcipher
      crypto: seqiv - Use skcipher
      crypto: aead - Remove blkcipher null for IV generators
      crypto: null - Remove default null blkcipher
      crypto: cts - Convert to skcipher
      crypto: user - Remove crypto_lookup_skcipher call
      crypto: skcipher - Remove top-level givcipher interface
      crypto: omap - Stop using crypto scatterwalk_bytes_sglen
      crypto: scatterwalk - Remove scatterwalk_bytes_sglen
      crypto: scatterwalk - Add no-copy support to copychunks
      crypto: api - Optimise away crypto_yield when hard preemption is =
on
      crypto: scatterwalk - Fix test in scatterwalk_done
      crypto: scatterwalk - Remove unnecessary advance in scatterwalk_p=
agedone
      crypto: scatterwalk - Remove unnecessary BUG in scatterwalk_start
      crypto: scatterwalk - Inline start/map/done
      crypto: testmgr - Print akcipher algorithm name
      crypto: skcipher - Add comment for skcipher_alg->base
      crypto: vmx - Fix aes_p8_xts_decrypt build failure
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypt=
o-2.6
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypt=
o-2.6

Horia Geant=C4=83 (7):
      asm-generic/io.h: allow barriers in io{read,write}{16,32}be
      asm-generic/io.h: add io{read,write}64 accessors
      arm64: add io{read,write}64be accessors
      powerpc: add io{read,write}64 accessors
      crypto: caam - handle core endianness !=3D caam endianness
      crypto: caam - add ARCH_LAYERSCAPE to supported architectures
      arm64: dts: ls1043a: add crypto node

Jeff Garzik (1):
      crypto: sha3 - Add SHA-3 hash algorithm

Krzysztof Kozlowski (2):
      crypto: s5p-sss - Use consistent indentation for variables and me=
mbers
      crypto: tcrypt - Fix mixing printk/pr_err and obvious indentation=
 issues

LEROY Christophe (7):
      crypto: talitos - using helpers for all talitos_ptr operations
      crypto: talitos - move mapping helpers before IPSEC functions
      crypto: talitos - making mapping helpers more generic
      crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFE=
U
      crypto: talitos - sg_to_link_tbl() not used anymore, remove it
      crypto: talitos - implement cra_priority
      crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU

Leonidas S. Barbosa (1):
      crypto: vmx - Adding support for XTS

Lokesh Vutla (2):
      crypto: omap-aes - Fix registration of algorithms
      crypto: omap - do not call dmaengine_terminate_all

Masanari Iida (1):
      crypto: doc - Fix double words "the the" in crypto-API.tmpl

Maxime Coquelin (1):
      hwrng: stm32 - fix maybe uninitialized variable warning

Megha Dey (15):
      crypto: sha1-mb - stylistic cleanup
      crypto: sha1-mb - async implementation for sha1-mb
      crypto: sha256-mb - SHA256 multibuffer job manager and glue code
      crypto: sha256-mb - Enable multibuffer support
      crypto: sha256-mb - submit/flush routines for AVX2
      crypto: sha256-mb - Algorithm data structures
      crypto: sha256-mb - Crypto computation (x8 AVX2)
      crypto: tcrypt - Add speed tests for SHA multibuffer algorithms
      crypto: sha1-mb - rename sha-mb to sha1-mb
      crypto: sha512-mb - SHA512 multibuffer job manager and glue code
      crypto: sha512-mb - Enable SHA512 multibuffer support
      crypto: sha512-mb - submit/flush routines for AVX2
      crypto: sha512-mb - Algorithm data structures
      crypto: sha512-mb - Crypto computation (x4 AVX2)
      crypto: tcrypt - Add new mode for sha512_mb

Neil Armstrong (1):
      hwrng: meson - Add Amlogic Meson Hardware Random Generator

Nicolai Stange (8):
      lib/mpi: purge mpi_set_buffer()
      lib/mpi: mpi_read_raw_data(): purge redundant clearing of nbits
      lib/mpi: mpi_read_raw_data(): fix nbits calculation
      lib/mpi: mpi_read_from_buffer(): return error code
      lib/digsig: digsig_verify_rsa(): return -EINVAL if modulo length =
is zero
      lib/mpi: mpi_read_from_buffer(): return -EINVAL upon too short bu=
ffer
      lib/mpi: mpi_read_from_buffer(): sanitize short buffer printk
      lib/mpi: refactor mpi_read_from_buffer() in terms of mpi_read_raw=
_data()

Nishanth Menon (1):
      hwrng: omap - Fix assumption that runtime_get_sync will always su=
cceed

Paulo Flabiano Smorigo (2):
      crypto: vmx - Adding asm subroutines for XTS
      crypto: vmx - Ignore generated files

Romain Perier (11):
      crypto: marvell - Add a macro constant for the size of the crypto=
 queue
      crypto: marvell - Check engine is not already running when enabli=
ng a req
      crypto: marvell - Fix wrong type check in dma functions
      crypto: marvell - Copy IV vectors by DMA transfers for acipher re=
quests
      crypto: marvell - Move tdma chain out of mv_cesa_tdma_req and rem=
ove it
      crypto: marvell - Add a complete operation for async requests
      crypto: marvell - Move SRAM I/O operations to step functions
      crypto: marvell - Add load balancing between engines
      crypto: marvell - Add support for chaining crypto requests in TDM=
A mode
      crypto: marvell - Increase the size of the crypto queue
      crypto: marvell - Fix wrong flag used for GFP in mv_cesa_dma_add_=
iv_op

Salvatore Benedetto (10):
      crypto: kpp - Key-agreement Protocol Primitives API (KPP)
      crypto: dh - Add DH software implementation
      crypto: ecdh - Add ECDH software support
      crypto: qat - Switch to new rsa_helper functions
      crypto: testmgr - Set err before proceeding
      crypto: rsa - Store rest of the private key components
      crypto: testmgr - Add 4K private key to RSA testvector
      crypto: qat - Add RSA CRT mode
      crypto: qat - Add DH support
      crypto: qat - Stop dropping leading zeros from RSA output

Stephan Mueller (8):
      crypto: sha-ssse3 - add MODULE_ALIAS
      crypto: user - no parsing of CRYPTO_MSG_GETALG
      crypto: drbg - reduce number of setkey calls
      crypto: drbg - use CTR AES instead of ECB AES
      crypto: drbg - use aligned buffers
      crypto: drbg - use full CTR AES for update
      crypto: drbg - avoid duplicate maintenance of key
      crypto: jitterentropy - use ktime_get_ns as fallback

Stephen Rothwell (1):
      crypto: ecdh - make ecdh_shared_secret unique

Tadeusz Struk (3):
      crypto: qat - fix typos sizeof for ctx
      MAINTAINERS: update maintainer for qat
      crypto: rsa-pkcs1pad - fix rsa-pkcs1pad request struct

Tero Kristo (2):
      crypto: omap-sham - use runtime_pm autosuspend for clock handling
      crypto: omap-sham - change queue size from 1 to 10

Tim Chen (1):
      crypto: sha-mb - Cleanup code to use || instead of |

Tudor Ambarus (3):
      crypto: rsa - return raw integers for the ASN.1 parser
      crypto: caam - replace deprecated EXTRA_CFLAGS
      crypto: caam - add support for RSA algorithm

Wu Fengguang (1):
      crypto: drbg - fix semicolon.cocci warnings

Yendapally Reddy Dhananjaya Reddy (4):
      dt-bindings: rng: Northstar Plus SoC rng bindings
      hwrng: bcm2835 - Support Broadcom NSP SoC rng
      ARM: dts: nsp: Add rng device tree entry
      hwrng: bcm2835 - Read as much data as available

raveendra padasalagi (2):
      crypto: sha3 - Add SHA-3 Test's in tcrypt
      crypto: sha3 - Add HMAC-SHA3 test modes and test vectors

 Documentation/DocBook/crypto-API.tmpl              |    4 +-
 Documentation/crypto/asymmetric-keys.txt           |    2 +-
 .../devicetree/bindings/rng/brcm,bcm2835.txt       |    8 +-
 MAINTAINERS                                        |    5 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |    5 +
 arch/arm/crypto/ghash-ce-glue.c                    |   40 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts  |    4 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi     |   43 +
 arch/arm64/include/asm/io.h                        |    4 +-
 arch/powerpc/crypto/Makefile                       |    2 +
 arch/powerpc/crypto/aes-spe-regs.h                 |    2 +-
 arch/powerpc/crypto/crc32c-vpmsum_asm.S            | 1553 ++++++++++++=
++++
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           |  167 ++
 arch/powerpc/include/asm/ppc-opcode.h              |   12 +
 arch/powerpc/include/asm/ppc_asm.h                 |    3 +
 arch/powerpc/kernel/iomap.c                        |   24 +
 arch/s390/crypto/aes_s390.c                        |  113 +-
 arch/x86/crypto/Makefile                           |    4 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   94 +-
 arch/x86/crypto/chacha20_glue.c                    |    2 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   40 +-
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/Makefile       |    0
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb.c      |  288 +--
 .../{sha-mb/sha_mb_ctx.h =3D> sha1-mb/sha1_mb_ctx.h} |    2 +-
 .../{sha-mb/sha_mb_mgr.h =3D> sha1-mb/sha1_mb_mgr.h} |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_datastruct.S   |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_flush_avx2.S   |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_init_avx2.c    |    2 +-
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_submit_avx2.S  |    0
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_x8_avx2.S |    0
 arch/x86/crypto/sha1_ssse3_glue.c                  |    6 +
 arch/x86/crypto/sha256-mb/Makefile                 |   11 +
 arch/x86/crypto/sha256-mb/sha256_mb.c              | 1030 +++++++++++
 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h          |  136 ++
 arch/x86/crypto/sha256-mb/sha256_mb_mgr.h          |  108 ++
 .../crypto/sha256-mb/sha256_mb_mgr_datastruct.S    |  304 ++++
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  304 ++++
 .../x86/crypto/sha256-mb/sha256_mb_mgr_init_avx2.c |   65 +
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  215 +++
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  593 +++++++
 arch/x86/crypto/sha256_ssse3_glue.c                |   10 +
 arch/x86/crypto/sha512-mb/Makefile                 |   11 +
 arch/x86/crypto/sha512-mb/sha512_mb.c              | 1046 +++++++++++
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          |  130 ++
 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h          |  104 ++
 .../crypto/sha512-mb/sha512_mb_mgr_datastruct.S    |  281 +++
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |  291 +++
 .../x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c |   67 +
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  222 +++
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  529 ++++++
 arch/x86/crypto/sha512_ssse3_glue.c                |    6 +
 crypto/Kconfig                                     |   77 +
 crypto/Makefile                                    |   12 +-
 crypto/ablk_helper.c                               |    6 +-
 crypto/ablkcipher.c                                |  223 ---
 crypto/aead.c                                      |   16 +-
 crypto/ahash.c                                     |    6 +-
 crypto/algapi.c                                    |   24 +-
 crypto/authenc.c                                   |  116 +-
 crypto/authencesn.c                                |  106 +-
 crypto/blkcipher.c                                 |  185 --
 crypto/ccm.c                                       |   72 +-
 crypto/chacha20poly1305.c                          |   89 +-
 crypto/chainiv.c                                   |  317 ----
 crypto/cryptd.c                                    |  132 +-
 crypto/crypto_null.c                               |   11 +-
 crypto/crypto_user.c                               |   57 +-
 crypto/ctr.c                                       |  183 +-
 crypto/cts.c                                       |  495 +++---
 crypto/dh.c                                        |  189 ++
 crypto/dh_helper.c                                 |   95 +
 crypto/drbg.c                                      |  269 ++-
 crypto/ecc.c                                       | 1018 +++++++++++
 crypto/ecc.h                                       |   83 +
 crypto/ecc_curve_defs.h                            |   57 +
 crypto/ecdh.c                                      |  151 ++
 crypto/ecdh_helper.c                               |   86 +
 crypto/echainiv.c                                  |   16 +-
 crypto/eseqiv.c                                    |  242 ---
 crypto/gcm.c                                       |  115 +-
 crypto/jitterentropy-kcapi.c                       |   22 +-
 crypto/kpp.c                                       |  123 ++
 crypto/mcryptd.c                                   |  132 +-
 crypto/rsa-pkcs1pad.c                              |  325 ++--
 crypto/rsa.c                                       |  113 +-
 crypto/rsa_helper.c                                |  172 +-
 crypto/rsaprivkey.asn1                             |   10 +-
 crypto/scatterwalk.c                               |   81 +-
 crypto/seqiv.c                                     |  176 +-
 crypto/sha3_generic.c                              |  300 ++++
 crypto/skcipher.c                                  |  196 +-
 crypto/tcrypt.c                                    |  442 +++--
 crypto/testmgr.c                                   |  288 ++-
 crypto/testmgr.h                                   | 1036 ++++++++++-
 drivers/char/hw_random/Kconfig                     |   16 +-
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm2835-rng.c               |   47 +-
 drivers/char/hw_random/exynos-rng.c                |    4 +-
 drivers/char/hw_random/meson-rng.c                 |  131 ++
 drivers/char/hw_random/omap-rng.c                  |   16 +-
 drivers/char/hw_random/stm32-rng.c                 |   10 +-
 drivers/crypto/bfin_crc.c                          |    5 -
 drivers/crypto/caam/Kconfig                        |   18 +-
 drivers/crypto/caam/Makefile                       |    4 +-
 drivers/crypto/caam/caamhash.c                     |    5 +-
 drivers/crypto/caam/caampkc.c                      |  607 +++++++
 drivers/crypto/caam/caampkc.h                      |   70 +
 drivers/crypto/caam/compat.h                       |    3 +
 drivers/crypto/caam/ctrl.c                         |  125 +-
 drivers/crypto/caam/desc.h                         |   11 +-
 drivers/crypto/caam/desc_constr.h                  |   51 +-
 drivers/crypto/caam/jr.c                           |   22 +-
 drivers/crypto/caam/pdb.h                          |  188 +-
 drivers/crypto/caam/pkc_desc.c                     |   36 +
 drivers/crypto/caam/regs.h                         |  151 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   17 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |   43 +-
 drivers/crypto/ccp/ccp-crypto.h                    |    3 +-
 drivers/crypto/marvell/cesa.c                      |  142 +-
 drivers/crypto/marvell/cesa.h                      |  120 +-
 drivers/crypto/marvell/cipher.c                    |  157 +-
 drivers/crypto/marvell/hash.c                      |  150 +-
 drivers/crypto/marvell/tdma.c                      |  130 +-
 drivers/crypto/mxs-dcp.c                           |   47 +-
 drivers/crypto/nx/nx.c                             |    2 +-
 drivers/crypto/omap-aes.c                          |   36 +-
 drivers/crypto/omap-des.c                          |   14 +-
 drivers/crypto/omap-sham.c                         |   47 +-
 drivers/crypto/picoxcell_crypto.c                  |   60 +-
 drivers/crypto/qat/Kconfig                         |    3 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
 drivers/crypto/qat/qat_common/Makefile             |   11 -
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 +
 drivers/crypto/qat/qat_common/adf_aer.c            |   49 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +
 drivers/crypto/qat/qat_common/adf_sriov.c          |    2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    8 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |  872 +++++++--
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1  |   11 -
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1   |    4 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    1 +
 drivers/crypto/qce/ablkcipher.c                    |   27 +-
 drivers/crypto/qce/cipher.h                        |    2 +-
 drivers/crypto/s5p-sss.c                           |   80 +-
 drivers/crypto/sahara.c                            |  112 +-
 drivers/crypto/talitos.c                           |  672 ++++---
 drivers/crypto/ux500/cryp/Makefile                 |    6 +-
 drivers/crypto/ux500/hash/Makefile                 |    2 +-
 drivers/crypto/vmx/.gitignore                      |    2 +
 drivers/crypto/vmx/Makefile                        |    2 +-
 drivers/crypto/vmx/aes_xts.c                       |  190 ++
 drivers/crypto/vmx/aesp8-ppc.h                     |    4 +
 drivers/crypto/vmx/aesp8-ppc.pl                    | 1863 ++++++++++++=
+++++++-
 drivers/crypto/vmx/vmx.c                           |    2 +
 drivers/usb/misc/Kconfig                           |   11 +-
 drivers/usb/misc/chaoskey.c                        |   21 +-
 include/asm-generic/io.h                           |   71 +-
 include/asm-generic/iomap.h                        |    8 +
 include/crypto/aead.h                              |   12 +-
 include/crypto/algapi.h                            |    4 +
 include/crypto/cryptd.h                            |    5 +
 include/crypto/dh.h                                |   29 +
 include/crypto/drbg.h                              |   12 +
 include/crypto/ecdh.h                              |   30 +
 include/crypto/internal/aead.h                     |   21 +
 include/crypto/internal/geniv.h                    |    2 +-
 include/crypto/internal/hash.h                     |   12 +-
 include/crypto/internal/kpp.h                      |   64 +
 include/crypto/internal/rsa.h                      |   42 +-
 include/crypto/internal/skcipher.h                 |  122 +-
 include/crypto/kpp.h                               |  330 ++++
 include/crypto/mcryptd.h                           |    8 +-
 include/crypto/null.h                              |   12 +-
 include/crypto/scatterwalk.h                       |   48 +-
 include/crypto/sha3.h                              |   29 +
 include/crypto/skcipher.h                          |  207 ++-
 include/linux/crypto.h                             |   31 +-
 include/linux/mpi.h                                |    3 +-
 include/uapi/linux/cryptouser.h                    |    5 +
 lib/digsig.c                                       |   16 +-
 lib/mpi/mpicoder.c                                 |  249 +--
 security/keys/big_key.c                            |   30 +-
 184 files changed, 19350 insertions(+), 4261 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
