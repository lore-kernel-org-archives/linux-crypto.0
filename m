From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.6
Date: Tue, 15 Mar 2016 15:20:40 +0800
Message-ID: <20160315072040.GA18381@gondor.apana.org.au>
References: <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59258 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbcCOHUu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2016 03:20:50 -0400
Content-Disposition: inline
In-Reply-To: <20160111101450.GA24044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.6:

API:

* Convert remaining crypto_hash users to shash or ahash,
  also convert blkcipher/ablkcipher users to skcipher.
  Please note taht this conflicts with the net, staging
  and f2fs trees but the resolution should be fairly simple.
* Remove crypto_hash interface.
* Remove crypto_pcomp interface.
* Add crypto engine for async cipher drivers.
* Add akcipher documentation.
* Add skcipher documentation.

Algorithms:

* Rename crypto/crc32 to avoid name clash with lib/crc32.
* Fix bug in keywrap where we zero the wrong pointer.

Drivers:

* Support T5/M5, T7/M7 SPARC CPUs in n2 hwrng driver.
* Add PIC32 hwrng driver.
* Support BCM6368 in bcm63xx hwrng driver.
* Pack structs for 32-bit compat users in qat.
* Use crypto engine in omap-aes.
* Add support for sama5d2x SoCs in atmel-sha.
* Make atmel-sha available again.
* Make sahara hashing available again.
* Make ccp hashing available again.
* Make sha1-mb available again.
* Add support for multiple devices in ccp.
* Improve DMA performance in caam.
* Add hashing support to rockchip.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git li=
nus


Anatoly Pugachev (2):
      hwrng: n2 - documentation, add DT bindings, vendor prefixes
      hwrng: n2 - Attach on T5/M5, T7/M7 SPARC CPUs

Andre Przywara (1):
      crypto: sunxi-ss - prevent compilation on 64-bit

Arnd Bergmann (5):
      crypto: sunxi - don't print confusing data
      crypto: jitterentropy - always select CRYPTO_RNG
      lib/mpi: avoid assembler warning
      lib/mpi: use "static inline" instead of "extern inline"
      hwrng: exynos - use __maybe_unused to hide pm functions

Atta, Ahsan (1):
      crypto: qat - Pack cfg ctl structs

Baolin Wang (3):
      crypto: api - Introduce crypto_queue_len() helper function
      crypto: engine - Introduce the block request crypto engine framew=
ork
      crypto: omap-aes - Support crypto engine framework

Cabiddu, Giovanni (1):
      crypto: qat - Reduced reqsize in qat_algs

Cyrille Pitchen (7):
      crypto: atmel-sha - fix crash when computing digest on empty mess=
age
      crypto: atmel-sha - fix a race between the 'done' tasklet and the=
 crypto client
      crypto: atmel-sha - add support of sama5d2x SoCs
      crypto: atmel-sha - fix context switches
      crypto: atmel-sha - fix algorihtm registration
      crypto: atmel-sha - fix .import()/.export() implementation
      crypto: atmel-sha - fix race in atmel_sha_final()

Dan Carpenter (1):
      crypto: keywrap - memzero the correct memory

=46abio Estevam (4):
      crypto: sahara - remove unneeded mutex in the exported state
      crypto: sahara - avoid needlessly saving and restoring sahara_ctx
      crypto: sahara - fill the statesize field
      crypto: caam - Staticize caam_jr_shutdown()

Gary R Hook (4):
      crypto: ccp - Remove check for x86 family and model
      crypto: ccp - Support for multiple CCPs
      crypto: ccp - CCP versioning support
      crypto: ccp - Add abstraction for device-specific calls

Herbert Xu (41):
      crypto: ixp4xx - Fix false lastlen uninitialised warning
      crypto: skcipher - Add default key size helper
      crypto: hash - Add helpers to zero stack request/descriptor
      crypto: skcipher - Add helper to zero stack request
      crypto: api - Add crypto_type_has_alg helper
      crypto: hash - Add crypto_has_ahash helper
      crypto: skcipher - Add helper to retrieve driver name
      block: cryptoloop - Use new skcipher interface
      ppp_mppe: Use skcipher and ahash
      staging: rtl8192e: Replace uses of obsolete blkcipher and hash
      dm crypt: Use skcipher and ahash
      orinoco: Use ahash
      staging: rtl8192u: Use skcipher and ahash
      wusb: Use skcipher
      cifs: Use skcipher
      ext4: Use skcipher
      f2fs: Use skcipher
      sunrpc: Use skcipher and ahash/shash
      lib80211: Use skcipher and ahash
      KEYS: Use skcipher
      Bluetooth: Use skcipher and hash
      libceph: Use skcipher
      mac802154: Use skcipher
      rxrpc: Use skcipher
      ipsec: Use skcipher and ahash when probing algorithms
      drbd: Use shash and ahash
      nfc: s3fwrn5: Use shash
      iscsi_tcp: Use ahash
      iscsi-target: Use shash and ahash
      nfsd: Use shash
      sctp: Use shash
      tcp: Use ahash
      eCryptfs: Use skcipher and shash
      crypto: crc32 - Rename generic implementation
      crypto: tcrypt - Use ahash
      crypto: doc - Use ahash
      crypto: skcipher - Fix driver name helper
      crypto: hash - Add helpers to return alg and driver names
      staging: lustre: Use ahash
      crypto: hash - Remove crypto_hash interface
      crypto: keys - Revert "convert public key to akcipher api"

Horia Geant? (1):
      crypto: caam - enable LARGE_BURST for enhancing DMA transactions =
size

Ilya Dryomov (1):
      libceph: Remove unnecessary ivsize variables

Jerome Marchand (1):
      crypto: testmgr - fix out of bound read in __test_aead()

Joonsoo Kim (1):
      crypto: compress - remove unused pcomp interface

Joshua Henderson (2):
      dt/bindings: Add bindings for the PIC32 random number generator
      hwrng: pic32 - Add PIC32 RNG hardware driver

Krzysztof Koz?owski (2):
      crypto: s5p-sss - Fix minor coding style violations
      crypto: s5p-sss - Use memcpy_toio for iomem annotated memory

Marcus Meissner (3):
      crypto: testmgr - mark more algorithms as FIPS compliant
      crypto: testmgr - mark authenticated ctr(aes) also as FIPS able
      crypto: testmgr - allow rfc3686 aes-ctr variants in fips mode.

Megha Dey (1):
      crypto: sha1-mb - Add missing args_digest offset

Michal Marek (1):
      lib/mpi: Endianness fix

Pingchao Yang (3):
      crypto: qat - remove redundant function call
      crypto: qat - The AE id should be less than the maximal AE number
      crypto: qat - Change the definition of icp_qat_uof_regtype

Stephan Mueller (8):
      crypto: ansi_cprng - ANSI X9.31 DRNG is not allowed in FIPS 140-2
      crypto: drbg - remove FIPS 140-2 continuous test
      crypto: xts - consolidate sanity check for keys
      crypto: doc - add akcipher API
      crypto: doc - add crypto_rng_generate
      crypto: doc - update AEAD AD handling
      crypto: doc - add skcipher API documentation
      crypto: xts - fix compile errors

Tadeusz Struk (7):
      crypto: qat - change name for c6xx dev type
      crypto: aead - move aead_request_cast helper to aead.h
      crypto: asymmetric_keys - convert public key and digsig asym to t=
he akcipher api
      integrity: convert digsig to akcipher api
      crypto: public_key - remove MPIs from public_key_signature struct
      crypto: qat - fix leak on error path
      crypto: qat - remove redundant arbiter configuration

Tom Lendacky (4):
      crypto: ccp - Add hash state import and export support
      crypto: ccp - Limit the amount of information exported
      crypto: ccp - Don't assume export/import areas are aligned
      crypto: ccp - memset request context to zero during import

Vladimir Zapolskiy (2):
      crypto: atmel - fix checks of error code returned by devm_ioremap=
_resource()
      crypto: ux500 - fix checks of error code returned by devm_ioremap=
_resource()

Wang, Rui Y (3):
      crypto: mcryptd - Fix load failure
      crypto: sha-mb - Fix load failure
      crypto: testmgr - Add a test case for import()/export()

Zain Wang (1):
      crypto: rockchip - add hash support for crypto engine in rk3288

=C1lvaro Fern=E1ndez Rojas (5):
      hwrng: bcm63xx - remove unused variables
      hwrng: bcm63xx - add device tree support
      hwrng: bcm63xx - allow building for BMIPS_GENERIC
      hwrng: brcm63xx - document device tree bindings
      hwrng: bcm63xx - fix non device tree compatibility

 Documentation/DocBook/crypto-API.tmpl              |  242 ++++-----
 Documentation/crypto/api-intro.txt                 |   23 +-
 .../devicetree/bindings/rng/brcm,bcm6368.txt       |   17 +
 .../bindings/rng/microchip,pic32-rng.txt           |   17 +
 .../devicetree/bindings/sparc_sun_oracle_rng.txt   |   30 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    2 +
 arch/arm/crypto/aes-ce-glue.c                      |    5 +
 arch/arm/crypto/aesbs-glue.c                       |    6 +
 arch/arm64/crypto/aes-glue.c                       |    5 +
 arch/powerpc/crypto/aes-spe-glue.c                 |    6 +
 arch/s390/crypto/aes_s390.c                        |    6 +
 arch/x86/crypto/aesni-intel_glue.c                 |   11 +-
 arch/x86/crypto/camellia_glue.c                    |   10 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   10 +-
 arch/x86/crypto/serpent_avx_glue.c                 |   11 +-
 arch/x86/crypto/serpent_sse2_glue.c                |   11 +-
 arch/x86/crypto/sha-mb/sha1_mb.c                   |   35 ++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S   |    2 +-
 arch/x86/crypto/twofish_glue_3way.c                |   10 +-
 crypto/Kconfig                                     |   23 +-
 crypto/Makefile                                    |    5 +-
 crypto/ahash.c                                     |   24 +-
 crypto/algapi.c                                    |   15 +
 crypto/{crc32.c =3D> crc32_generic.c}                |    3 +-
 crypto/crypto_engine.c                             |  355 ++++++++++++=
+
 crypto/drbg.c                                      |   64 ---
 crypto/internal.h                                  |    3 +
 crypto/keywrap.c                                   |    4 +-
 crypto/mcryptd.c                                   |    1 +
 crypto/pcompress.c                                 |  115 -----
 crypto/shash.c                                     |  147 ------
 crypto/skcipher.c                                  |    4 +-
 crypto/tcrypt.c                                    |  239 +--------
 crypto/testmgr.c                                   |  401 +++++++-----=
---
 crypto/testmgr.h                                   |  144 ------
 crypto/xts.c                                       |   11 +-
 crypto/zlib.c                                      |  381 ------------=
--
 drivers/block/cryptoloop.c                         |   48 +-
 drivers/block/drbd/drbd_int.h                      |   16 +-
 drivers/block/drbd/drbd_main.c                     |   16 +-
 drivers/block/drbd/drbd_nl.c                       |   59 ++-
 drivers/block/drbd/drbd_receiver.c                 |   56 +-
 drivers/block/drbd/drbd_worker.c                   |   43 +-
 drivers/char/hw_random/Kconfig                     |   15 +-
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm63xx-rng.c               |   11 +-
 drivers/char/hw_random/exynos-rng.c                |   10 +-
 drivers/char/hw_random/n2-drv.c                    |   10 +
 drivers/char/hw_random/pic32-rng.c                 |  155 ++++++
 drivers/crypto/Kconfig                             |    7 +-
 drivers/crypto/atmel-aes.c                         |   10 +-
 drivers/crypto/atmel-sha-regs.h                    |    4 +
 drivers/crypto/atmel-sha.c                         |  200 +++++---
 drivers/crypto/atmel-tdes.c                        |    4 +-
 drivers/crypto/caam/ctrl.c                         |    2 +-
 drivers/crypto/caam/jr.c                           |    2 +-
 drivers/crypto/caam/regs.h                         |    3 +-
 drivers/crypto/ccp/Makefile                        |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |   36 ++
 drivers/crypto/ccp/ccp-crypto-aes.c                |   12 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |   49 +-
 drivers/crypto/ccp/ccp-crypto.h                    |   22 +
 drivers/crypto/ccp/ccp-dev-v3.c                    |  533 ++++++++++++=
++++++++
 drivers/crypto/ccp/ccp-dev.c                       |  471 ++++++------=
-----
 drivers/crypto/ccp/ccp-dev.h                       |  155 +++++-
 drivers/crypto/ccp/ccp-ops.c                       |  381 +-----------=
--
 drivers/crypto/ccp/ccp-pci.c                       |   23 +-
 drivers/crypto/ccp/ccp-platform.c                  |   48 +-
 drivers/crypto/ixp4xx_crypto.c                     |   26 +-
 drivers/crypto/omap-aes.c                          |   97 ++--
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    4 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |    1 -
 drivers/crypto/qat/qat_common/adf_cfg_user.h       |    6 +-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |   19 -
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |   42 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    6 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |   70 +--
 drivers/crypto/qat/qat_common/qat_uclo.c           |    2 +-
 drivers/crypto/rockchip/Makefile                   |    1 +
 drivers/crypto/rockchip/rk3288_crypto.c            |   28 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   56 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   20 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |  404 ++++++++++++=
+++
 drivers/crypto/s5p-sss.c                           |   12 +-
 drivers/crypto/sahara.c                            |   19 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |    5 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    4 +-
 drivers/crypto/ux500/hash/hash_core.c              |    4 +-
 drivers/md/dm-crypt.c                              |   93 ++--
 drivers/net/ppp/ppp_mppe.c                         |   99 ++--
 drivers/net/wireless/intersil/orinoco/mic.c        |   29 +-
 drivers/net/wireless/intersil/orinoco/mic.h        |    4 +-
 drivers/net/wireless/intersil/orinoco/orinoco.h    |    4 +-
 drivers/nfc/s3fwrn5/firmware.c                     |   36 +-
 drivers/scsi/iscsi_tcp.c                           |   54 +-
 drivers/scsi/iscsi_tcp.h                           |    4 +-
 drivers/scsi/libiscsi_tcp.c                        |   29 +-
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |   92 ++--
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |   99 ++--
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |   48 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |   92 ++--
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |   46 +-
 drivers/target/iscsi/iscsi_target.c                |   86 ++--
 drivers/target/iscsi/iscsi_target_auth.c           |   98 ++--
 drivers/target/iscsi/iscsi_target_login.c          |   45 +-
 drivers/usb/wusbcore/crypto.c                      |   30 +-
 fs/cifs/cifsencrypt.c                              |   32 +-
 fs/cifs/smbencrypt.c                               |   26 +-
 fs/ecryptfs/crypto.c                               |  107 ++--
 fs/ecryptfs/ecryptfs_kernel.h                      |   12 +-
 fs/ecryptfs/inode.c                                |    1 -
 fs/ecryptfs/keystore.c                             |  218 ++++----
 fs/ecryptfs/main.c                                 |    1 -
 fs/ecryptfs/mmap.c                                 |    1 -
 fs/ecryptfs/super.c                                |    1 -
 fs/ext4/crypto.c                                   |   24 +-
 fs/ext4/crypto_fname.c                             |   32 +-
 fs/ext4/crypto_key.c                               |   42 +-
 fs/ext4/ext4_crypto.h                              |    2 +-
 fs/f2fs/crypto.c                                   |   24 +-
 fs/f2fs/crypto_fname.c                             |   32 +-
 fs/f2fs/crypto_key.c                               |   40 +-
 fs/f2fs/f2fs_crypto.h                              |    2 +-
 fs/nfsd/nfs4recover.c                              |   28 +-
 include/crypto/aead.h                              |    6 +-
 include/crypto/akcipher.h                          |   28 +-
 include/crypto/algapi.h                            |   92 +++-
 include/crypto/compress.h                          |  145 ------
 include/crypto/drbg.h                              |    4 -
 include/crypto/hash.h                              |   45 ++
 include/crypto/internal/aead.h                     |    6 +
 include/crypto/internal/compress.h                 |   28 -
 include/crypto/internal/hash.h                     |    3 -
 include/crypto/skcipher.h                          |   24 +-
 include/crypto/xts.h                               |   27 +
 include/linux/ccp.h                                |   17 +
 include/linux/crypto.h                             |  252 ---------
 include/linux/sunrpc/gss_krb5.h                    |   32 +-
 include/net/sctp/auth.h                            |    4 +-
 include/net/sctp/structs.h                         |    6 +-
 include/net/tcp.h                                  |    6 +-
 include/scsi/libiscsi_tcp.h                        |   13 +-
 include/target/iscsi/iscsi_target_core.h           |    4 +-
 lib/mpi/longlong.h                                 |    2 +-
 lib/mpi/mpi-inline.h                               |    2 +-
 lib/mpi/mpi-internal.h                             |    8 +-
 lib/mpi/mpicoder.c                                 |   39 +-
 net/bluetooth/smp.c                                |  135 +++--
 net/ceph/crypto.c                                  |  101 ++--
 net/ipv4/tcp.c                                     |   41 +-
 net/ipv4/tcp_fastopen.c                            |    1 +
 net/ipv4/tcp_ipv4.c                                |   23 +-
 net/ipv6/tcp_ipv6.c                                |   23 +-
 net/mac802154/llsec.c                              |   41 +-
 net/mac802154/llsec.h                              |    3 +-
 net/rxrpc/ar-internal.h                            |    2 +-
 net/rxrpc/ar-key.c                                 |   12 +-
 net/rxrpc/rxkad.c                                  |  172 ++++---
 net/sctp/auth.c                                    |   36 +-
 net/sctp/endpointola.c                             |    1 -
 net/sctp/sm_make_chunk.c                           |   51 +-
 net/sctp/socket.c                                  |    8 +-
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |  350 ++++++++----=
-
 net/sunrpc/auth_gss/gss_krb5_keys.c                |   12 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c                |   89 ++--
 net/sunrpc/auth_gss/gss_krb5_seqnum.c              |   22 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |   24 +-
 net/wireless/lib80211_crypt_tkip.c                 |   99 ++--
 net/wireless/lib80211_crypt_wep.c                  |   46 +-
 net/xfrm/xfrm_algo.c                               |    7 +-
 security/keys/encrypted-keys/encrypted.c           |   82 +--
 171 files changed, 4904 insertions(+), 4511 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
