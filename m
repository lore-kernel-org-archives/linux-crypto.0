From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/7] Introduce Arm TrustZone CryptoCell
Date: Thu, 11 Jan 2018 09:17:07 +0000
Message-ID: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55068 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754157AbeAKJR1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 04:17:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Arm TrustZone CryptoCell is a security hardware IP that
includes support for hardware based hash, digest, cipher
and AEAD operations. This driver provides support for
these as part of the Linux Crypto sub-system.

The driver spent some time now in the staging tree being
cleaned up and is now submitted for review for the
purpose of moving into the crypto tree. The first patch
therefore delete it's copy in the staging directory
otherwise there is a build failure due to collisions
with it's other copy there.

Please note that the driver include some stubs for yet
unexposed functionality (ivgen and secure HW keys).

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad Ben-Yossef (7):
  staging: ccree: remove ccree from staging tree
  crypto: ccree: introduce CryptoCell driver
  crypto: ccree: add ablkcipher support
  crypto: ccree: add ahash support
  crypto: ccree: add AEAD support
  crypto: ccree: add FIPS support
  MAINTAINERS: update ccree entry

 MAINTAINERS                                        |    5 +-
 drivers/crypto/Kconfig                             |   27 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/ccree/Makefile                      |    7 +
 .../ccree/ssi_aead.c => crypto/ccree/cc_aead.c}    | 1120 ++++++------
 .../ccree/ssi_aead.h => crypto/ccree/cc_aead.h}    |   56 +-
 .../ccree/cc_buffer_mgr.c}                         | 1085 ++++++------
 drivers/crypto/ccree/cc_buffer_mgr.h               |   74 +
 .../ssi_cipher.c => crypto/ccree/cc_cipher.c}      |  716 +++-----
 drivers/crypto/ccree/cc_cipher.h                   |   74 +
 drivers/{staging => crypto}/ccree/cc_crypto_ctx.h  |   38 +-
 drivers/crypto/ccree/cc_debugfs.c                  |  101 ++
 drivers/crypto/ccree/cc_debugfs.h                  |   32 +
 drivers/crypto/ccree/cc_driver.c                   |  477 +++++
 drivers/crypto/ccree/cc_driver.h                   |  194 +++
 .../ccree/ssi_fips.c => crypto/ccree/cc_fips.c}    |   44 +-
 drivers/crypto/ccree/cc_fips.h                     |   37 +
 .../ccree/ssi_hash.c => crypto/ccree/cc_hash.c}    | 1818 +++++++++-----------
 drivers/crypto/ccree/cc_hash.h                     |  114 ++
 drivers/crypto/ccree/cc_host_regs.h                |  142 ++
 .../{staging => crypto}/ccree/cc_hw_queue_defs.h   |   40 +-
 .../ccree/ssi_ivgen.c => crypto/ccree/cc_ivgen.c}  |  141 +-
 drivers/crypto/ccree/cc_ivgen.h                    |   55 +
 drivers/crypto/ccree/cc_kernel_regs.h              |  167 ++
 drivers/{staging => crypto}/ccree/cc_lli_defs.h    |   19 +-
 drivers/crypto/ccree/cc_pm.c                       |  123 ++
 drivers/crypto/ccree/cc_pm.h                       |   57 +
 drivers/crypto/ccree/cc_request_mgr.c              |  714 ++++++++
 drivers/crypto/ccree/cc_request_mgr.h              |   51 +
 .../ssi_sram_mgr.c => crypto/ccree/cc_sram_mgr.c}  |   70 +-
 drivers/crypto/ccree/cc_sram_mgr.h                 |   65 +
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 .../devicetree/bindings/crypto/arm-cryptocell.txt  |   27 -
 drivers/staging/ccree/Kconfig                      |   25 -
 drivers/staging/ccree/Makefile                     |    3 -
 drivers/staging/ccree/TODO                         |   30 -
 drivers/staging/ccree/dx_crys_kernel.h             |  180 --
 drivers/staging/ccree/dx_host.h                    |  155 --
 drivers/staging/ccree/dx_reg_common.h              |   26 -
 drivers/staging/ccree/hash_defs.h                  |   36 -
 drivers/staging/ccree/ssi_buffer_mgr.h             |   91 -
 drivers/staging/ccree/ssi_cipher.h                 |   84 -
 drivers/staging/ccree/ssi_config.h                 |   36 -
 drivers/staging/ccree/ssi_driver.c                 |  538 ------
 drivers/staging/ccree/ssi_driver.h                 |  206 ---
 drivers/staging/ccree/ssi_fips.h                   |   49 -
 drivers/staging/ccree/ssi_hash.h                   |  103 --
 drivers/staging/ccree/ssi_ivgen.h                  |   71 -
 drivers/staging/ccree/ssi_pm.c                     |  145 --
 drivers/staging/ccree/ssi_pm.h                     |   43 -
 drivers/staging/ccree/ssi_request_mgr.c            |  610 -------
 drivers/staging/ccree/ssi_request_mgr.h            |   60 -
 drivers/staging/ccree/ssi_sram_mgr.h               |   79 -
 drivers/staging/ccree/ssi_sysfs.c                  |  172 --
 drivers/staging/ccree/ssi_sysfs.h                  |   55 -
 56 files changed, 4706 insertions(+), 5785 deletions(-)
 create mode 100644 drivers/crypto/ccree/Makefile
 rename drivers/{staging/ccree/ssi_aead.c => crypto/ccree/cc_aead.c} (70%)
 rename drivers/{staging/ccree/ssi_aead.h => crypto/ccree/cc_aead.h} (64%)
 rename drivers/{staging/ccree/ssi_buffer_mgr.c => crypto/ccree/cc_buffer_mgr.c} (56%)
 create mode 100644 drivers/crypto/ccree/cc_buffer_mgr.h
 rename drivers/{staging/ccree/ssi_cipher.c => crypto/ccree/cc_cipher.c} (58%)
 create mode 100644 drivers/crypto/ccree/cc_cipher.h
 rename drivers/{staging => crypto}/ccree/cc_crypto_ctx.h (78%)
 create mode 100644 drivers/crypto/ccree/cc_debugfs.c
 create mode 100644 drivers/crypto/ccree/cc_debugfs.h
 create mode 100644 drivers/crypto/ccree/cc_driver.c
 create mode 100644 drivers/crypto/ccree/cc_driver.h
 rename drivers/{staging/ccree/ssi_fips.c => crypto/ccree/cc_fips.c} (61%)
 create mode 100644 drivers/crypto/ccree/cc_fips.h
 rename drivers/{staging/ccree/ssi_hash.c => crypto/ccree/cc_hash.c} (52%)
 create mode 100644 drivers/crypto/ccree/cc_hash.h
 create mode 100644 drivers/crypto/ccree/cc_host_regs.h
 rename drivers/{staging => crypto}/ccree/cc_hw_queue_defs.h (94%)
 rename drivers/{staging/ccree/ssi_ivgen.c => crypto/ccree/cc_ivgen.c} (62%)
 create mode 100644 drivers/crypto/ccree/cc_ivgen.h
 create mode 100644 drivers/crypto/ccree/cc_kernel_regs.h
 rename drivers/{staging => crypto}/ccree/cc_lli_defs.h (69%)
 create mode 100644 drivers/crypto/ccree/cc_pm.c
 create mode 100644 drivers/crypto/ccree/cc_pm.h
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.h
 rename drivers/{staging/ccree/ssi_sram_mgr.c => crypto/ccree/cc_sram_mgr.c} (50%)
 create mode 100644 drivers/crypto/ccree/cc_sram_mgr.h
 delete mode 100644 drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
 delete mode 100644 drivers/staging/ccree/Kconfig
 delete mode 100644 drivers/staging/ccree/Makefile
 delete mode 100644 drivers/staging/ccree/TODO
 delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 delete mode 100644 drivers/staging/ccree/dx_host.h
 delete mode 100644 drivers/staging/ccree/dx_reg_common.h
 delete mode 100644 drivers/staging/ccree/hash_defs.h
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_cipher.h
 delete mode 100644 drivers/staging/ccree/ssi_config.h
 delete mode 100644 drivers/staging/ccree/ssi_driver.c
 delete mode 100644 drivers/staging/ccree/ssi_driver.h
 delete mode 100644 drivers/staging/ccree/ssi_fips.h
 delete mode 100644 drivers/staging/ccree/ssi_hash.h
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
 delete mode 100644 drivers/staging/ccree/ssi_pm.c
 delete mode 100644 drivers/staging/ccree/ssi_pm.h
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.c
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.h

-- 
2.7.4
