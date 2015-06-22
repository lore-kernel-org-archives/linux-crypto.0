From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.2
Date: Mon, 22 Jun 2015 16:44:57 +0800
Message-ID: <20150622084457.GA7806@gondor.apana.org.au>
References: <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46607 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbbFVIpI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Jun 2015 04:45:08 -0400
Content-Disposition: inline
In-Reply-To: <20150415033951.GA1406@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.2:

API:

* Convert RNG interface to new style.
* New AEAD interface with one SG list for AD and plain/cipher text.
  All external AEAD users have been converted.
* New asymmetric key interface (akcipher).

Algorithms:
* Chacha20, Poly1305 and RFC7539 support.
* New RSA implementation.
* Jitter RNG.
* DRBG is now seeded with both /dev/random and Jitter RNG.  If
  kernel pool isn't ready then DRBG will be reseeded when it is.
* DRBG is now the default crypto API RNG, replacing krng.
* 842 compression (previously part of powerpc nx driver).

Drivers:

* Accelerated SHA-512 for arm64.
* New Marvell CESA driver that supports DMA and more algorithms.
* Updated powerpc nx 842 support.
* Added support for SEC1 hardware to talitos.

=20
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Allan, Bruce W (2):
      crypto: qat - do not duplicate string containing firmware name
      crypto: qat - add driver version

Ard Biesheuvel (3):
      crypto: testmgr - add test cases for CRC32
      crypto: arm/sha512 - accelerated SHA-512 using ARM generic ASM an=
d NEON
      crypto: arm/aes - streamline AES-192 code path

Arnaud Ebalard (4):
      crypto: marvell/cesa - add Triple-DES support
      crypto: marvell/cesa - add MD5 support
      crypto: marvell/cesa - add SHA256 support
      crypto: marvell/cesa - add support for Kirkwood and Dove SoCs

Boris BREZILLON (11):
      crypto: mv_cesa - request registers memory region
      crypto: mv_cesa - document the clocks property
      crypto: mv_cesa - use gen_pool to reserve the SRAM memory region
      crypto: mv_cesa - explicitly define kirkwood and dove compatible =
strings
      crypto: marvell/cesa - add a new driver for Marvell's CESA
      crypto: marvell/cesa - add TDMA support
      crypto: marvell/cesa - add DES support
      crypto: marvell/cesa - add support for all armada SoCs
      crypto: marvell/cesa - add allhwsupport module parameter
      crypto: marvell/cesa - add support for Orion SoCs
      crypto: marvell/cesa - add DT bindings documentation

Boris Brezillon (1):
      crypto: marvell/cesa - remove COMPILE_TEST dependency

Colin Ian King (1):
      crypto: mv_cesa - ensure backlog is initialised

Dan Carpenter (1):
      crypto: talitos - fix size calculation in talitos_edesc_alloc()

Dan Streetman (19):
      powerpc: export of_get_ibm_chip_id function
      powerpc: Add ICSWX instruction
      lib: add software 842 compression/decompression
      crypto: 842 - change 842 alg to use software
      crypto: nx - rename nx-842.c to nx-842-pseries.c
      crypto: nx - add NX-842 platform frontend driver
      crypto: nx - add nx842 constraints
      crypto: nx - add PowerNV platform NX-842 driver
      crypto: nx - simplify pSeries nx842 driver
      crypto: nx - add hardware 842 crypto comp alg
      lib: make lib/842 decompress functions static
      lib: correct 842 decompress for 32 bit
      crypto: nx - remove 842-nx null checks
      crypto: nx - prevent nx 842 load if no hw driver
      crypto: nx - fix nx-842 pSeries driver minimum buffer size
      crypto: nx - move include/linux/nx842.h into drivers/crypto/nx/nx=
-842.h
      crypto: nx - replace NX842_MEM_COMPRESS with function
      crypto: nx - add LE support to pSeries platform driver
      MAINTAINERS: clarify drivers/crypto/nx/ file ownership

David Howells (2):
      crypto: pcomp - Constify (de)compression parameters
      crypto: testmgr - Wrap the LHS in expressions of the form !x =3D=3D=
 y

=46abio Estevam (1):
      crypto: sahara - propagate the error on clk_disable_unprepare() f=
ailure

Harald Freudenberger (1):
      crypto: testmgr - Added one larger ghash testvector (400 bytes) t=
o the testmgr.

Herbert Xu (166):
      crypto: drbg - Initialise mutex in drbg_healthcheck_sanity
      crypto: drbg - Do not seed RNG in drbg_kcapi_init
      crypto: api - Add crypto_alg_extsize helper
      crypto: shash - Use crypto_alg_extsize helper
      crypto: pcomp - Use crypto_alg_extsize helper
      crypto: rng - Convert crypto_rng to new style crypto_type
      crypto: rng - Introduce crypto_rng_generate
      crypto: rng - Mark crypto_rng_reset seed as const
      crypto: rng - Convert low-level crypto_rng to new style
      crypto: rng - Add crypto_rng_set_entropy
      crypto: rng - Add multiple algorithm registration interface
      crypto: drbg - Convert to new rng interface
      crypto: ansi_cprng - Remove bogus inclusion of internal.h
      crypto: ansi_cprng - Convert to new rng interface
      crypto: krng - Convert to new rng interface
      crypto: rng - Remove old low-level rng interface
      crypto: algif_rng - Remove obsolete const-removal cast
      crypto: rng - Zero seed in crypto_rng_reset
      crypto: tcrypt - Handle async return from crypto_ahash_init
      crypto: api - Move module sig ifdef into accessor function
      crypto: drbg - Remove FIPS ifdef from drbg_healthcheck_sanity
      crypto: caam - Remove bogus references to crypto API internals
      crypto: api - Include linux/fips.h
      crypto: fips - Remove bogus inclusion of internal.h
      crypto: fips - Move fips_enabled sysctl into fips.c
      crypto: tcrypt - Include linux/fips.h for fips_enabled
      crypto: testmgr - Include linux/fips.h for fips_enabled
      crypto: api - Remove linux/fips.h from internal.h
      crypto: arm64/aes-ce-ccm - Include crypto/internal/aead.h
      crypto: algif_aead - Include crypto/aead.h
      crypto: tcrypt - Include crypto/aead.h
      crypto: testmgr - Include crypto/aead.h
      mac80211: Include crypto/aead.h
      mac802154: Include crypto/aead.h
      crypto: api - Fix build error when modules are disabled
      crypto: skcipher - Fix corner case in crypto_lookup_skcipher
      crypto: aead - Fix corner case in crypto_lookup_aead
      crypto: api - Add crypto_grab_spawn primitive
      crypto: authenc - Include internal/aead.h
      crypto: authencesn - Include internal/aead.h
      crypto: caam - Include internal/aead.h
      crypto: ixp4xx - Include internal/aead.h
      crypto: nx - Include internal/aead.h
      crypto: qat - Include internal/aead.h
      crypto: talitos - Include internal/aead.h
      crypto: blkcipher - Include crypto/aead.h
      crypto: caam - Remove unnecessary reference to crt_aead
      crypto: aead - Add crypto_aead_set_reqsize helper
      crypto: authenc - Use crypto_aead_set_reqsize helper
      crypto: authencesn - Use crypto_aead_set_reqsize helper
      crypto: ccm - Use crypto_aead_set_reqsize helper
      crypto: cryptd - Use crypto_aead_set_reqsize helper
      crypto: gcm - Use crypto_aead_set_reqsize helper
      crypto: pcrypt - Use crypto_aead_set_reqsize helper
      crypto: seqiv - Use crypto_aead_set_reqsize helper
      crypto: aesni - Use crypto_aead_set_reqsize helper
      crypto: ixp4xx - Use crypto_aead_set_reqsize helper
      crypto: picoxcell - Use crypto_aead_set_reqsize helper
      crypto: qat - Use crypto_aead_set_reqsize helper
      crypto: cryptd - Add missing aead.h inclusion
      crypto: aead - Convert top level interface to new style
      crypto: cryptd - Use crypto_grab_aead
      crypto: pcrypt - Use crypto_grab_aead
      crypto: scatterwalk - Add scatterwalk_ffwd helper
      crypto: aead - Add new interface with single SG list
      crypto: aead - Rename aead_alg to old_aead_alg
      crypto: caam - Use old_aead_alg
      crypto: aead - Add crypto_aead_maxauthsize
      crypto: ixp4xx - Use crypto_aead_maxauthsize
      crypto: nx - Remove unnecessary maxauthsize check
      crypto: aead - Add support for new AEAD implementations
      crypto: null - Add default null skcipher
      crypto: gcm - Use default null skcipher
      crypto: scatterwalk - Check for same address in map_and_copy
      crypto: seqiv - Add support for new AEAD interface
      crypto: seqiv - Add seqniv
      crypto: echainiv - Add encrypted chain IV generator
      crypto: aead - Add crypto_aead_alg_ivsize/maxauthsize
      crypto: pcrypt - Make tfm_count an atomic_t
      crypto: skcipher - Use tmpl->create
      crypto: aead - Use tmpl->create
      crypto: seqiv - Use aead_register_instance
      crypto: echainiv - Use aead_register_instance
      crypto: aead - Do not set cra_type for new style instances
      crypto: echainiv - Stop using cryptoff
      crypto: seqiv - Stop using cryptoff
      crypto: aead - Remove unused cryptoff parameter
      random: Wake up all getrandom(2) callers when pool is ready
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypt=
o-2.6
      crypto: aead - Document behaviour of AD in destination buffer
      crypto: scatterwalk - Add missing sg_init_table to scatterwalk_ff=
wd
      crypto: aead - Preserve in-place processing in old_crypt
      crypto: aead - Add common IV generation code
      crypto: echainiv - Copy AD along with plain text
      crypto: echainiv - Use common IV generation code
      crypto: echainiv - Fix IV size in context size calculation
      crypto: seqiv - Copy AD along with plain/cipher text
      crypto: seqiv - Use common IV generation code
      crypto: seqiv - Fix IV size in context size calculation
      crypto: seqiv - Fix module unload/reload crash
      crypto: testmgr - Switch to new AEAD interface
      xfrm: Add IV generator information to xfrm_algo_desc
      ipsec: Add IV generator information to xfrm_state
      esp4: Switch to new AEAD interface
      esp6: Switch to new AEAD interface
      mac802154: Switch to new AEAD interface
      mac80211: Switch to new AEAD interface
      crypto: tcrypt - Switch to new AEAD interface
      crypto: algif_aead - Switch to new AEAD interface
      Revert "crypto: algif_aead - Disable AEAD user-space for now"
      crypto: aead - Add type-safe init/exit functions
      crypto: aead - Add aead_alg_instance
      crypto: api - Include alignment in crypto_alg_extsize
      crypto: aead - Ignore return value from crypto_unregister_alg
      crypto: aead - Add multiple algorithm registration interface
      crypto: pcrypt - Add support for new AEAD interface
      crypto: cryptd - Add setkey/setauthsize functions for AEAD
      crypto: aesni - Convert top-level rfc4106 algorithm to new interf=
ace
      crypto: cryptd - Convert to new AEAD interface
      crypto: aesni - Convert rfc4106 to new AEAD interface
      crypto: scatterwalk - Hide PageSlab call to optimise away flush_d=
cache_page
      crypto: chainiv - Move IV seeding into init function
      crypto: echainiv - Move IV seeding into init function
      crypto: eseqiv - Move IV seeding into init function
      crypto: seqiv - Move IV seeding into init function
      crypto: drbg - Add stdrng alias and increase priority
      crypto: echainiv - Set Kconfig default to m
      crypto: rng - Make DRBG the default RNG
      crypto: rng - Remove krng
      crypto: caam - Clamp AEAD SG list by input length
      nios2: Export get_cycles
      random: Add callback API for random pool readiness
      random: Remove kernel blocking API
      crypto: drbg - Add select on sha256
      crypto: picoxcell - Include linux/sizes.h
      crypto: picoxcell - Make use of sg_nents_for_len
      crypto: picoxcell - Clamp AEAD SG list by input length
      crypto: vmx - Remove duplicate PPC64 dependency
      crypto: vmx - Reindent to kernel style
      crypto: testmgr - Disable rfc4543 test
      crypto: gcm - Convert to new AEAD interface
      crypto: testmgr - Update rfc4543 test vectors
      crypto: nx - Convert GCM to new AEAD interface
      crypto: caam - Handle errors in dma_map_sg_chained
      crypto: caam - Convert GCM to new AEAD interface
      Revert "crypto: testmgr - Disable rfc4543 test"
      crypto: testmgr - Add mcgrew test vectors for rfc4106
      crypto: tcrypt - Add rfc4309(ccm(aes)) speed test
      crypto: tcrypt - Fixed AEAD speed test setup
      crypto: drivers - Fix Kconfig selects
      crypto: api - Add CRYPTO_MINALIGN_ATTR to struct crypto_alg
      crypto: aead - Fix aead_instance struct size
      crypto: caam - Reintroduce DESC_MAX_USED_BYTES
      crypto: caam - Set last bit on src SG list
      Merge branch 'mvebu/drivers' of git://git.kernel.org/pub/scm/linu=
x/kernel/git/arm/arm-soc
      crypto: nx - Check for bogus firmware properties
      crypto: skcipher - Allow givencrypt to be NULL
      crypto: rng - Do not free default RNG when it becomes unused
      crypto: user - Move cryptouser.h to uapi
      crypto: user - Add CRYPTO_MSG_DELRNG
      crypto: chainiv - Offer normal cipher functionality without RNG
      crypto: eseqiv - Offer normal cipher functionality without RNG
      crypto: seqiv - Add compatibility support without RNG
      crypto: echainiv - Only hold RNG during initialisation
      crypto: af_alg - Forbid the use internal algorithms
      crypto: algif_aead - Temporarily disable all AEAD algorithms

Horia Geant? (4):
      crypto: talitos - avoid memleak in talitos_alg_alloc()
      Revert "crypto: talitos - convert to use be16_add_cpu()"
      crypto: talitos - avoid out of bound scatterlist iterator
      crypto: talitos - static code checker fixes

Jeremiah Mahler (1):
      crypto: aesni - fix crypto_fpu_exit() section mismatch

LABBE Corentin (7):
      crypto: md5 - add MD5 initial vectors
      crypto: md5 - use md5 IV MD5_HX instead of their raw value
      crypto: powerpc/md5 - use md5 IV MD5_HX instead of their raw valu=
e
      crypto: sparc/md5 - use md5 IV MD5_HX instead of their raw value
      crypto: n2 - use md5 IV MD5_HX instead of their raw value
      crypto: octeon - use md5 IV MD5_HX instead of their raw value
      crypto: testmgr - Document struct cipher_testvec

LEROY Christophe (17):
      crypto: talitos - Use zero entry to init descriptors ptrs to zero
      crypto: talitos - Refactor the sg in/out chain allocation
      crypto: talitos - talitos_ptr renamed ptr for more lisibility
      crypto: talitos - Add a helper function to clear j_extent field
      crypto: talitos - remove param 'extent' in map_single_talitos_ptr=
()
      crypto: talitos - helper function for ptr len
      crypto: talitos - enhanced talitos_desc struct for SEC1
      crypto: talitos - add sub-choice in talitos CONFIG for SEC1
      crypto: talitos - Add a feature to tag SEC1
      crypto: talitos - fill in talitos descriptor iaw SEC1 or SEC2+
      crypto: talitos - adaptation of talitos_submit() for SEC1
      crypto: talitos - base address for Execution Units
      crypto: talitos - adapt interrupts and reset functions to SEC1
      crypto: talitos - implement scatter/gather copy for SEC1
      crypto: talitos - SEC1 bugs on 0 data hash
      crypto: talitos - Add fsl,sec1.0 compatible
      crypto: talitos - Update DT bindings with SEC1

Leonidas Da Silva Barbosa (2):
      crypto: nx - Fixing NX data alignment with nx_sg list
      crypto: nx - Fixing SHA update bug

Martin Willi (10):
      crypto: chacha20 - Add a generic ChaCha20 stream cipher implement=
ation
      crypto: testmgr - Add ChaCha20 test vectors from RFC7539
      crypto: poly1305 - Add a generic Poly1305 authenticator implement=
ation
      crypto: testmgr - Add Poly1305 test vectors from RFC7539
      crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construct=
ion, RFC7539
      crypto: testmgr - Add ChaCha20-Poly1305 test vectors from RFC7539
      crypto: chacha20poly1305 - Add an IPsec variant for RFC7539 AEAD
      crypto: testmgr - Add draft-ietf-ipsecme-chacha20-poly1305 test v=
ector
      xfrm: Define ChaCha20-Poly1305 AEAD XFRM algo for IPsec users
      crypto: poly1305 - Pass key as first two message blocks to each d=
esc_ctx

Masanari Iida (2):
      crypto: doc - Fix typo in crypto-API.tmpl
      crypto: doc - Fix typo in crypto-API.xml

Michael van der Westhuizen (1):
      crypto: picoxcell - Update to the current clk API

Pali Roh=E1r (2):
      crypto: omap-sham - Check for return value from pm_runtime_get_sy=
nc
      crypto: omap-sham - Add support for omap3 devices

Paulo Flabiano Smorigo (1):
      crypto: vmx - fix two mistyped texts

Sergey Senozhatsky (1):
      crypto: drbg - report backend_cra_name when allocation fails

Steffen Trumtrar (1):
      crypto: caam - fix non-64-bit write/read access

Stephan Mueller (15):
      cryoto: drbg - clear all temporary memory
      crypto: drbg - fix drbg_generate return val check
      crypto: drbg - replace spinlock with mutex
      crypto: drbg - leave cipher handles operational
      crypto: doc - change header file locations
      random: Blocking API for accessing nonblocking_pool
      crypto: drbg - prepare for async seeding
      crypto: drbg - add async seeding operation
      crypto: drbg - use Jitter RNG to obtain seed
      crypto: jitterentropy - add jitterentropy RNG
      crypto: jitterentropy - remove timekeeping_valid_for_hres
      crypto: doc - cover new AEAD interface
      crypto: drbg - use pragmas for disabling optimization
      crypto: drbg - Use callback API for random readiness
      crypto: drbg - reseed often if seedsource is degraded

Tadeusz Struk (9):
      crypto: qat - remove unused structure members
      crypto: qat - rm unneeded header include
      crypto: qat - Set max request size
      crypto: qat: fix issue when mapping assoc to internal AD struct
      MPILIB: add mpi_read_buf() and mpi_get_size() helpers
      crypto: akcipher - add PKE API
      crypto: rsa - add a new rsa generic implementation
      crypto: testmgr - add tests vectors for RSA
      crypto: rsa - fix invalid select for AKCIPHER

Tom Lendacky (4):
      crypto: ccp - Remove manual check and set of dma_mask pointer
      crypto: ccp - Remove unused structure field
      scatterlist: introduce sg_nents_for_len
      crypto: ccp - Protect against poorly marked end of sg list

Victoria Milhoan (2):
      crypto: caam - Fix incorrect size when DMA unmapping buffer
      crypto: caam - Provide correct value to iounmap() in controller d=
river

Wu Fengguang (1):
      crypto: echainiv - echainiv_read_iv() can be static

firo yang (1):
      crypto: sha1-mb - Remove pointless cast

 Documentation/DocBook/crypto-API.tmpl              |   67 +-
 .../devicetree/bindings/crypto/fsl-sec2.txt        |    6 +-
 .../devicetree/bindings/crypto/marvell-cesa.txt    |   45 +
 .../devicetree/bindings/crypto/mv_cesa.txt         |   31 +-
 MAINTAINERS                                        |   26 +-
 arch/arm/boot/dts/armada-375.dtsi                  |    2 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |    2 +-
 arch/arm/boot/dts/armada-39x.dtsi                  |    2 +-
 arch/arm/boot/dts/armada-xp-linksys-mamba.dts      |    5 +
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |    4 +
 arch/arm/boot/dts/dove-cubox.dts                   |    1 +
 arch/arm/crypto/Kconfig                            |   15 +-
 arch/arm/crypto/Makefile                           |   10 +-
 arch/arm/crypto/aes-ce-core.S                      |    7 +-
 arch/arm/crypto/sha512-armv4.pl                    |  649 ++++++
 arch/arm/crypto/sha512-armv7-neon.S                |  455 ----
 arch/arm/crypto/sha512-core.S_shipped              | 1861 ++++++++++++=
+++
 arch/arm/crypto/sha512-glue.c                      |  121 +
 arch/arm/crypto/sha512-neon-glue.c                 |   98 +
 arch/arm/crypto/sha512.h                           |    8 +
 arch/arm/crypto/sha512_neon_glue.c                 |  305 ---
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    2 +-
 arch/arm64/crypto/crc32-arm64.c                    |   22 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |    3 +
 arch/arm64/crypto/sha2-ce-glue.c                   |    3 +
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |    8 +-
 arch/nios2/kernel/time.c                           |    2 +
 arch/powerpc/crypto/md5-glue.c                     |    8 +-
 arch/powerpc/include/asm/icswx.h                   |  184 ++
 arch/powerpc/include/asm/ppc-opcode.h              |   13 +
 arch/powerpc/kernel/prom.c                         |    1 +
 arch/s390/crypto/ghash_s390.c                      |   25 +-
 arch/sparc/crypto/md5_glue.c                       |    8 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  423 ++--
 arch/x86/crypto/fpu.c                              |    2 +-
 arch/x86/crypto/sha-mb/sha1_mb.c                   |    3 +-
 crypto/842.c                                       |  174 +-
 crypto/Kconfig                                     |   97 +-
 crypto/Makefile                                    |   15 +-
 crypto/ablkcipher.c                                |   12 +-
 crypto/aead.c                                      |  684 ++++--
 crypto/af_alg.c                                    |    5 +-
 crypto/akcipher.c                                  |  117 +
 crypto/algapi.c                                    |   31 +-
 crypto/algif_aead.c                                |   79 +-
 crypto/algif_rng.c                                 |    2 +-
 crypto/ansi_cprng.c                                |   88 +-
 crypto/authenc.c                                   |   17 +-
 crypto/authencesn.c                                |   17 +-
 crypto/blkcipher.c                                 |    1 +
 crypto/ccm.c                                       |   14 +-
 crypto/chacha20_generic.c                          |  216 ++
 crypto/chacha20poly1305.c                          |  695 ++++++
 crypto/chainiv.c                                   |  105 +-
 crypto/cryptd.c                                    |  135 +-
 crypto/crypto_null.c                               |   39 +
 crypto/crypto_user.c                               |   34 +-
 crypto/drbg.c                                      |  567 ++---
 crypto/echainiv.c                                  |  312 +++
 crypto/eseqiv.c                                    |   52 +-
 crypto/fips.c                                      |   53 +-
 crypto/gcm.c                                       |  940 +++-----
 crypto/internal.h                                  |    3 +-
 crypto/jitterentropy.c                             |  928 ++++++++
 crypto/krng.c                                      |   66 -
 crypto/md5.c                                       |    8 +-
 crypto/pcompress.c                                 |    7 +-
 crypto/pcrypt.c                                    |  199 +-
 crypto/poly1305_generic.c                          |  321 +++
 crypto/proc.c                                      |   41 -
 crypto/rng.c                                       |  132 +-
 crypto/rsa.c                                       |  315 +++
 crypto/rsa_helper.c                                |  121 +
 crypto/rsakey.asn1                                 |    5 +
 crypto/scatterwalk.c                               |   45 +-
 crypto/seqiv.c                                     |  587 ++++-
 crypto/shash.c                                     |    7 +-
 crypto/tcrypt.c                                    |   36 +-
 crypto/tcrypt.h                                    |    1 +
 crypto/testmgr.c                                   |  314 ++-
 crypto/testmgr.h                                   | 2443 ++++++++++++=
+++++++-
 crypto/zlib.c                                      |    4 +-
 drivers/bus/mvebu-mbus.c                           |  120 +-
 drivers/char/hw_random/bcm63xx-rng.c               |   18 +-
 drivers/char/random.c                              |   80 +-
 drivers/crypto/Kconfig                             |   87 +-
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/caam/Kconfig                        |    5 +-
 drivers/crypto/caam/caamalg.c                      | 1497 ++++++------
 drivers/crypto/caam/caamhash.c                     |    9 +-
 drivers/crypto/caam/compat.h                       |    2 +-
 drivers/crypto/caam/ctrl.c                         |    4 +-
 drivers/crypto/caam/regs.h                         |   38 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   50 +-
 drivers/crypto/ccp/Kconfig                         |    1 -
 drivers/crypto/ccp/ccp-ops.c                       |    9 +-
 drivers/crypto/ccp/ccp-platform.c                  |    2 -
 drivers/crypto/ixp4xx_crypto.c                     |    9 +-
 drivers/crypto/marvell/Makefile                    |    2 +
 drivers/crypto/marvell/cesa.c                      |  548 +++++
 drivers/crypto/marvell/cesa.h                      |  791 +++++++
 drivers/crypto/marvell/cipher.c                    |  797 +++++++
 drivers/crypto/marvell/hash.c                      | 1441 ++++++++++++
 drivers/crypto/marvell/tdma.c                      |  224 ++
 drivers/crypto/mv_cesa.c                           |   73 +-
 drivers/crypto/n2_core.c                           |    8 +-
 drivers/crypto/nx/Kconfig                          |   61 +-
 drivers/crypto/nx/Makefile                         |    9 +-
 drivers/crypto/nx/nx-842-crypto.c                  |  580 +++++
 drivers/crypto/nx/nx-842-platform.c                |   84 +
 drivers/crypto/nx/nx-842-powernv.c                 |  637 +++++
 drivers/crypto/nx/nx-842-pseries.c                 | 1140 +++++++++
 drivers/crypto/nx/nx-842.c                         | 1610 +-----------=
-
 drivers/crypto/nx/nx-842.h                         |  144 ++
 drivers/crypto/nx/nx-aes-gcm.c                     |  110 +-
 drivers/crypto/nx/nx-sha256.c                      |   84 +-
 drivers/crypto/nx/nx-sha512.c                      |   85 +-
 drivers/crypto/nx/nx.c                             |  233 +-
 drivers/crypto/nx/nx.h                             |    9 +-
 drivers/crypto/omap-sham.c                         |   27 +-
 drivers/crypto/picoxcell_crypto.c                  |   41 +-
 drivers/crypto/qat/Kconfig                         |    6 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 -
 drivers/crypto/qat/qat_common/adf_cfg_user.h       |   12 -
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    7 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    1 +
 drivers/crypto/qat/qat_common/qat_algs.c           |   39 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    5 +-
 drivers/crypto/sahara.c                            |   13 +-
 drivers/crypto/talitos.c                           |  743 ++++--
 drivers/crypto/talitos.h                           |  153 +-
 drivers/crypto/ux500/Kconfig                       |    4 +-
 drivers/crypto/vmx/Kconfig                         |    2 +-
 drivers/crypto/vmx/Makefile                        |    2 +-
 drivers/crypto/vmx/aes.c                           |  166 +-
 drivers/crypto/vmx/aes_cbc.c                       |  236 +-
 drivers/crypto/vmx/aes_ctr.c                       |  225 +-
 drivers/crypto/vmx/aesp8-ppc.h                     |   15 +-
 drivers/crypto/vmx/ghash.c                         |  278 +--
 drivers/crypto/vmx/vmx.c                           |   68 +-
 include/crypto/aead.h                              |  533 ++++-
 include/crypto/akcipher.h                          |  340 +++
 include/crypto/algapi.h                            |   35 +-
 include/crypto/compress.h                          |    8 +-
 include/crypto/cryptd.h                            |    1 +
 include/crypto/drbg.h                              |   59 +-
 include/crypto/hash.h                              |    2 +-
 include/crypto/internal/aead.h                     |  102 +-
 include/crypto/internal/akcipher.h                 |   60 +
 include/crypto/internal/geniv.h                    |   24 +
 include/crypto/internal/rng.h                      |   21 +-
 include/crypto/internal/rsa.h                      |   27 +
 include/crypto/md5.h                               |    5 +
 include/crypto/null.h                              |    3 +
 include/crypto/rng.h                               |  100 +-
 include/crypto/scatterwalk.h                       |    4 +
 include/linux/compiler-gcc.h                       |   16 +-
 include/linux/compiler-intel.h                     |    3 +
 include/linux/compiler.h                           |    4 +
 include/linux/crypto.h                             |  501 +---
 include/linux/mbus.h                               |    5 +
 include/linux/module.h                             |   12 +
 include/linux/mpi.h                                |   15 +
 include/linux/nx842.h                              |   11 -
 include/linux/random.h                             |    9 +
 include/linux/scatterlist.h                        |    1 +
 include/linux/sw842.h                              |   12 +
 include/net/xfrm.h                                 |    3 +
 include/{ =3D> uapi}/linux/cryptouser.h              |    6 +
 lib/842/842.h                                      |  127 +
 lib/842/842_compress.c                             |  626 +++++
 lib/842/842_debugfs.h                              |   52 +
 lib/842/842_decompress.c                           |  405 ++++
 lib/842/Makefile                                   |    2 +
 lib/Kconfig                                        |    6 +
 lib/Makefile                                       |    2 +
 lib/mpi/mpicoder.c                                 |   87 +-
 lib/mpi/mpiutil.c                                  |    6 +-
 lib/scatterlist.c                                  |   32 +
 lib/string.c                                       |    2 +-
 net/ipv4/esp4.c                                    |  200 +-
 net/ipv6/esp6.c                                    |  200 +-
 net/key/af_key.c                                   |    1 +
 net/mac80211/aes_ccm.c                             |   33 +-
 net/mac80211/aes_gcm.c                             |   33 +-
 net/mac80211/aes_gmac.c                            |   14 +-
 net/mac802154/llsec.c                              |   44 +-
 net/xfrm/xfrm_algo.c                               |   28 +
 net/xfrm/xfrm_user.c                               |   40 +-
 189 files changed, 23661 insertions(+), 7358 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
