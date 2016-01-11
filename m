From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.5
Date: Mon, 11 Jan 2016 18:14:50 +0800
Message-ID: <20160111101450.GA24044@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45987 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164AbcAKKPF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 05:15:05 -0500
Content-Disposition: inline
In-Reply-To: <20151102080427.GA8465@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.5:

Algorithms:

* Add RSA padding algorithm.

Drivers:

* Add GCM mode support to atmel.
* Add atmel support for SAMA5D2 devices.
* Add cipher modes to talitos.
* Add rockchip driver for rk3288.
* Add qat support for C3XXX and C62X.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Aaro Koskinen (1):
      hwrng: omap3-rom - convert timer to delayed work

Ahsan Atta (1):
      crypto: qat - Rename dh895xcc mmp firmware

Alexander Kuleshov (1):
      crypto: cryptod - use crypto_skcipher_type() for getting skcipher type

Andrzej Zaborowski (5):
      lib/mpi: only require buffers as big as needed for the integer
      crypto: rsa - only require output buffers as big as needed.
      crypto: akcipher - add akcipher declarations needed by templates.
      crypto: rsa - RSA padding algorithm
      crypto: rsa-pkcs1pad - don't allocate buffer on stack

Arnd Bergmann (4):
      crypto: atmel - fix 64-bit warnings
      crypto: atmel: fix bogus select
      crypto: sahara - fix 64-bit dma_addr_t compilation
      crypto: sahara - fix debug output for 64-bit dma_addr_t

Cyrille Pitchen (24):
      crypto: tcrypt - fix keysize argument of test_aead_speed for gcm(aes)
      crypto: atmel-aes - constify value argument of atmel_aes_write_n()
      crypto: atmel-aes - change algorithm priorities
      crypto: atmel-aes - fix unregistration order of crypto algorithms
      crypto: atmel-aes - remove unused header includes
      crypto: atmel-aes - propagate error from atmel_aes_hw_version_init()
      crypto: atmel-aes - change atmel_aes_write_ctrl() signature
      crypto: atmel-aes - make crypto request queue management more generic
      crypto: atmel-aes - remove useless write in the Control Register
      crypto: atmel-aes - simplify the configuration of the AES IP
      crypto: atmel-aes - rework crypto request completion
      crypto: atmel-aes - remove unused 'err' member of struct atmel_aes_dev
      crypto: atmel-aes - reduce latency of DMA completion
      crypto: atmel-aes - remove useless AES_FLAGS_DMA flag
      crypto: atmel-aes - fix atmel_aes_remove()
      crypto: atmel-aes - improve performances of data transfer
      crypto: atmel-aes - use SIZE_IN_WORDS() helper macro
      crypto: atmel-aes - fix typo and indentation
      crypto: atmel-aes - create sections to regroup functions by usage
      crypto: atmel-aes - fix atmel-ctr-aes driver for RFC 3686
      crypto: atmel-aes - fix the counter overflow in CTR mode
      crypto: atmel-aes - change the DMA threshold
      crypto: atmel-aes - add support to GCM mode
      crypto: atmel-aes - add debug facilities to monitor register accesses.

Dan Streetman (1):
      crypto: 842 - remove WARN inside printk

Fabio Estevam (1):
      crypto: caam - pass the correct buffer length

Geliang Tang (6):
      crypto: api - use list_first_entry_or_null and list_next_entry
      crypto: mcryptd - use list_first_entry_or_null()
      crypto: padlock-aes - use offset_in_page macro
      crypto: qat - use list_for_each_entry*
      crypto: ccp - use to_pci_dev and to_platform_device
      crypto: hifn_795x, picoxcell - use ablkcipher_request_cast

Haren Myneni (1):
      crypto: nx-842 - Mask XERS0 bit in return value

Harvijay Saini (1):
      crypto: qat - ring returning retry even though ring has BW

Heiko Stuebner (1):
      crypto: rockchip - fix possible deadlock

Jason A. Donenfeld (1):
      crypto: chacha20poly1305 - Skip encryption/decryption for 0-len

Jim Davis (1):
      crypto: qat - fix typo in clean-files

Jiri Slaby (1):
      hwrng: core - sleep interruptible in read

Julia Lawall (2):
      crypto: qat - constify pci_error_handlers structures
      crypto: drbg - constify drbg_state_ops structures

LABBE Corentin (19):
      crypto: hifn_795x - remove the hifn_test function
      crypto: hifn_795x - use dev_xx/pr_xx instead of printk
      crypto: hifn_795x - fix coding style
      crypto: algif - Change some variable to size_t
      crypto: marvell - check return value of sg_nents_for_len
      crypto: talitos - check return value of sg_nents_for_len
      crypto: sahara - check return value of sg_nents_for_len
      crypto: qce - check return value of sg_nents_for_len
      crypto: picoxcell - check return value of sg_nents_for_len
      crypto: caam - check return value of sg_nents_for_len
      crypto: amcc - check return value of sg_nents_for_len
      crypto: sun4i-ss - add missing statesize
      crypto: sahara - set nb_[in|out]_sg as signed int
      crypto: picoxcell - set [src|dst]_nents and nents as signed int
      crypto: akcipher - fix typos in include/crypto/akcipher.h
      crypto: hash - add zero length message hash for shax and md5
      crypto: n2 - Use precalculated hash from headers
      crypto: ccp - Use precalculated hash from headers
      crypto: ux500 - Use precalculated hash from headers

LEROY Christophe (1):
      crypto: talitos - add new crypto modes

Leilei Zhao (1):
      crypto: atmel-aes - add new version

Leonidas Da Silva Barbosa (1):
      crypto: vmx - IV size failing on skcipher API

Markus Elfring (1):
      crypto: ixp4xx - Delete unnecessary checks before the function call "dma_pool_destroy"

Paul Gortmaker (1):
      crypto: asymmetric_keys - signature.c does not need <module.h>

Pingchao Yang (3):
      crypto: qat - add support for new devices to FW loader
      crypto: qat - fix CTX_ENABLES bits shift direction issue
      crypto: qat - fix some timeout tests

Rahul Pathak (2):
      crypto: atmel-sha - Removed unused variable "err"
      crypto: omap - Removed unused variable "err"

Randy Dunlap (1):
      crypto: aead - fix kernel-doc warnings in crypto/aead.h

Salvatore Benedetto (1):
      crypto: qat - remove superfluous check from adf_probe

Sam Protsenko (1):
      crypto: omap-des - Fix "schedule while atomic" bug

Tadeusz Struk (12):
      crypto: qat - when stopping all devices make fure VF are stopped first
      crypto: qat - fix get instance function
      crypto: qat - add new device definitions
      crypto: qat - move isr files to qat common so that they can be reused
      crypto: qat - add support for c3xxx accel type
      crypto: qat - add support for c62x accel type
      crypto: qat - add support for c3xxxvf accel type
      crypto: qat - add support for c62xvf accel type
      crypto: qat - select PCI_IOV when VF are enabled
      crypto: qat - uint8_t is not large enough for accel_id
      crypto: qat - Fix random config build issue
      crypto: qat - fix SKU definiftion for c3xxx dev

Thierry Reding (1):
      crypto: n2 - Use platform_register/unregister_drivers()

Wang, Rui Y (2):
      crypto: ghash-clmulni - Fix load failure
      crypto: cryptd - Assign statesize properly

Zain Wang (2):
      crypto: rockchip - add DT bindings documentation
      crypto: rockchip - add crypto driver for rk3288

Zeng Xin (1):
      crypto: qat - enable VF irq after guest exits ungracefully

saurabh (1):
      crypto: nx - use of_property_read_u32()

 .../devicetree/bindings/crypto/rockchip-crypto.txt |   29 +
 arch/powerpc/include/asm/icswx.h                   |    1 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   26 +
 crypto/Makefile                                    |    1 +
 crypto/akcipher.c                                  |   34 +-
 crypto/algapi.c                                    |    9 +-
 crypto/algif_aead.c                                |    6 +-
 crypto/algif_skcipher.c                            |   10 +-
 crypto/asymmetric_keys/signature.c                 |    2 +-
 crypto/chacha20poly1305.c                          |    8 +
 crypto/cryptd.c                                    |    4 +-
 crypto/drbg.c                                      |    6 +-
 crypto/mcryptd.c                                   |    8 +-
 crypto/md5.c                                       |    6 +
 crypto/rsa-pkcs1pad.c                              |  628 +++++++
 crypto/rsa.c                                       |   40 +-
 crypto/sha1_generic.c                              |    7 +
 crypto/sha256_generic.c                            |   16 +
 crypto/tcrypt.c                                    |    2 +-
 drivers/char/hw_random/core.c                      |    6 +-
 drivers/char/hw_random/omap3-rom-rng.c             |   13 +-
 drivers/crypto/Kconfig                             |   18 +-
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/amcc/crypto4xx_core.c               |    4 +
 drivers/crypto/atmel-aes-regs.h                    |   10 +
 drivers/crypto/atmel-aes.c                         | 1843 ++++++++++++++------
 drivers/crypto/atmel-sha.c                         |    3 +-
 drivers/crypto/caam/caamhash.c                     |   26 +-
 drivers/crypto/ccp/Kconfig                         |    2 +
 drivers/crypto/ccp/ccp-ops.c                       |   39 +-
 drivers/crypto/ccp/ccp-pci.c                       |    8 +-
 drivers/crypto/ccp/ccp-platform.c                  |    6 +-
 drivers/crypto/hifn_795x.c                         |  512 +++---
 drivers/crypto/ixp4xx_crypto.c                     |    6 +-
 drivers/crypto/marvell/cipher.c                    |    8 +
 drivers/crypto/marvell/hash.c                      |    4 +
 drivers/crypto/n2_core.c                           |   50 +-
 drivers/crypto/nx/nx-842-powernv.c                 |   23 +-
 drivers/crypto/omap-aes.c                          |    4 +-
 drivers/crypto/omap-des.c                          |    5 +-
 drivers/crypto/padlock-aes.c                       |    4 +-
 drivers/crypto/picoxcell_crypto.c                  |   56 +-
 drivers/crypto/qat/Kconfig                         |   46 +
 drivers/crypto/qat/Makefile                        |    4 +
 drivers/crypto/qat/qat_c3xxx/Makefile              |    3 +
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  238 +++
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   83 +
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |  335 ++++
 drivers/crypto/qat/qat_c3xxxvf/Makefile            |    3 +
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |  173 ++
 .../adf_c3xxxvf_hw_data.h}                         |   31 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |  305 ++++
 drivers/crypto/qat/qat_c62x/Makefile               |    3 +
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |  248 +++
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |   84 +
 drivers/crypto/qat/qat_c62x/adf_drv.c              |  335 ++++
 drivers/crypto/qat/qat_c62xvf/Makefile             |    3 +
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |  173 ++
 .../adf_drv.h => qat_c62xvf/adf_c62xvf_hw_data.h}  |   32 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |  305 ++++
 drivers/crypto/qat/qat_common/Makefile             |    4 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   16 +-
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |    9 +-
 drivers/crypto/qat/qat_common/adf_admin.c          |    4 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |    4 +-
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    8 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   31 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |   21 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |   36 +-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |    8 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   21 +-
 .../qat/{qat_dh895xcc => qat_common}/adf_isr.c     |   44 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   23 -
 drivers/crypto/qat/qat_common/adf_transport.c      |   28 +-
 .../qat/qat_common/adf_transport_access_macros.h   |    5 +
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 +-
 .../adf_isr.c => qat_common/adf_vf_isr.c}          |   64 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   10 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h        |   37 +-
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |  165 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |  136 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |  124 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |  555 +++++-
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    4 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    5 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    9 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |  103 +-
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    4 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    5 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   10 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   96 +-
 drivers/crypto/qce/ablkcipher.c                    |    8 +
 drivers/crypto/qce/sha.c                           |    5 +
 drivers/crypto/rockchip/Makefile                   |    3 +
 drivers/crypto/rockchip/rk3288_crypto.c            |  394 +++++
 drivers/crypto/rockchip/rk3288_crypto.h            |  216 +++
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  505 ++++++
 drivers/crypto/sahara.c                            |   42 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |    2 +
 drivers/crypto/talitos.c                           |  124 +-
 drivers/crypto/talitos.h                           |    1 +
 drivers/crypto/ux500/Kconfig                       |    2 +
 drivers/crypto/ux500/hash/hash_core.c              |   20 +-
 drivers/crypto/vmx/aes_cbc.c                       |    2 +-
 drivers/crypto/vmx/aes_ctr.c                       |    2 +-
 include/crypto/aead.h                              |    1 +
 include/crypto/akcipher.h                          |   10 +-
 include/crypto/internal/akcipher.h                 |   78 +
 include/crypto/internal/rsa.h                      |    2 +
 include/crypto/md5.h                               |    2 +
 include/crypto/sha.h                               |    6 +
 lib/842/842_decompress.c                           |   14 +-
 lib/mpi/mpicoder.c                                 |   21 +-
 113 files changed, 7344 insertions(+), 1605 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
