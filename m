From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/7] crypto: ccree: Introduce Arm TrustZone CryptoCell
Date: Mon, 22 Jan 2018 09:26:58 +0000
Message-ID: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Arm TrustZone CryptoCell is a security hardware IP that
includes support for hardware based hash, digest, cipher
and AEAD operations. This driver provides support for
these as part of the Linux Crypto sub-system.

The driver spent some time now in the staging tree being
cleaned up and is now submitted for review for the
purpose of moving into the crypto tree. The first patch
therefore renames its copy in the staging directory
Kconfig define and marks it broken, otherwise there is a
build failure due to global symbols collisions.

Please note that the driver include stubs for yet
unexposed functionality (ivgen and secure HW keys),
which will be added later.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Changes from v1:
- Use KConfig directive to stop staging tree version to not
  collide during link time as opposed to deleting it as indicated
  by Greg KH.
- Switched from legacy ablkcipher to skcipher interface as
  indicated by Corentin Labbe.
- Removed unused zero_buff struct as indicated by Corentin Labbe.
- Moved to kzfree for all IV/key buffers as indicated by
  Corentin Labbe.
- Moved to using __des3_ede_setkey() in lieu of home grown
  version as indicated by Stephan Mueller.
- Fixed multiple small coding style from Dan Carpenter and others.
- Fixed pointer signedness sparse warnings as indicated by Jeremy
  Sowden.
- Rename all registered algs driver name to -ccree prefix

Gilad Ben-Yossef (7):
  staging: ccree: rename staging ver and mark as broken
  crypto: ccree: introduce CryptoCell driver
  crypto: ccree: add skcipher support
  crypto: ccree: add ahash support
  crypto: ccree: add AEAD support
  crypto: ccree: add FIPS support
  MAINTAINERS: update ccree entry

 MAINTAINERS                             |    5 +-
 drivers/crypto/Kconfig                  |   27 +
 drivers/crypto/Makefile                 |    1 +
 drivers/crypto/ccree/Makefile           |    7 +
 drivers/crypto/ccree/cc_aead.c          | 2702 +++++++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_aead.h          |  109 ++
 drivers/crypto/ccree/cc_buffer_mgr.c    | 1651 +++++++++++++++++++
 drivers/crypto/ccree/cc_buffer_mgr.h    |   72 +
 drivers/crypto/ccree/cc_cipher.c        | 1130 +++++++++++++
 drivers/crypto/ccree/cc_cipher.h        |   59 +
 drivers/crypto/ccree/cc_crypto_ctx.h    |  170 ++
 drivers/crypto/ccree/cc_debugfs.c       |  101 ++
 drivers/crypto/ccree/cc_debugfs.h       |   32 +
 drivers/crypto/ccree/cc_driver.c        |  476 ++++++
 drivers/crypto/ccree/cc_driver.h        |  194 +++
 drivers/crypto/ccree/cc_fips.c          |  111 ++
 drivers/crypto/ccree/cc_fips.h          |   37 +
 drivers/crypto/ccree/cc_hash.c          | 2296 ++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_hash.h          |  114 ++
 drivers/crypto/ccree/cc_host_regs.h     |  142 ++
 drivers/crypto/ccree/cc_hw_queue_defs.h |  590 +++++++
 drivers/crypto/ccree/cc_ivgen.c         |  280 ++++
 drivers/crypto/ccree/cc_ivgen.h         |   55 +
 drivers/crypto/ccree/cc_kernel_regs.h   |  167 ++
 drivers/crypto/ccree/cc_lli_defs.h      |   59 +
 drivers/crypto/ccree/cc_pm.c            |  122 ++
 drivers/crypto/ccree/cc_pm.h            |   57 +
 drivers/crypto/ccree/cc_request_mgr.c   |  713 ++++++++
 drivers/crypto/ccree/cc_request_mgr.h   |   51 +
 drivers/crypto/ccree/cc_sram_mgr.c      |  107 ++
 drivers/crypto/ccree/cc_sram_mgr.h      |   65 +
 drivers/staging/ccree/Kconfig           |    4 +-
 drivers/staging/ccree/Makefile          |    2 +-
 33 files changed, 11702 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/ccree/Makefile
 create mode 100644 drivers/crypto/ccree/cc_aead.c
 create mode 100644 drivers/crypto/ccree/cc_aead.h
 create mode 100644 drivers/crypto/ccree/cc_buffer_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_buffer_mgr.h
 create mode 100644 drivers/crypto/ccree/cc_cipher.c
 create mode 100644 drivers/crypto/ccree/cc_cipher.h
 create mode 100644 drivers/crypto/ccree/cc_crypto_ctx.h
 create mode 100644 drivers/crypto/ccree/cc_debugfs.c
 create mode 100644 drivers/crypto/ccree/cc_debugfs.h
 create mode 100644 drivers/crypto/ccree/cc_driver.c
 create mode 100644 drivers/crypto/ccree/cc_driver.h
 create mode 100644 drivers/crypto/ccree/cc_fips.c
 create mode 100644 drivers/crypto/ccree/cc_fips.h
 create mode 100644 drivers/crypto/ccree/cc_hash.c
 create mode 100644 drivers/crypto/ccree/cc_hash.h
 create mode 100644 drivers/crypto/ccree/cc_host_regs.h
 create mode 100644 drivers/crypto/ccree/cc_hw_queue_defs.h
 create mode 100644 drivers/crypto/ccree/cc_ivgen.c
 create mode 100644 drivers/crypto/ccree/cc_ivgen.h
 create mode 100644 drivers/crypto/ccree/cc_kernel_regs.h
 create mode 100644 drivers/crypto/ccree/cc_lli_defs.h
 create mode 100644 drivers/crypto/ccree/cc_pm.c
 create mode 100644 drivers/crypto/ccree/cc_pm.h
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_request_mgr.h
 create mode 100644 drivers/crypto/ccree/cc_sram_mgr.c
 create mode 100644 drivers/crypto/ccree/cc_sram_mgr.h

-- 
2.7.4
