From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/7] staging: ccree: rename staging ver and mark as broken
Date: Mon, 22 Jan 2018 09:26:59 +0000
Message-ID: <1516613230-4524-2-git-send-email-gilad@benyossef.com>
References: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
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

Rename the Kconfig var of the staging tree version of the driver
in preparation of introducing the final version of the driver
into the cryptodev tree to avoid link time symbol collisions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig  | 4 ++--
 drivers/staging/ccree/Makefile | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 0b3092b..a84b6ab 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -1,6 +1,6 @@
-config CRYPTO_DEV_CCREE
+config CRYPTO_DEV_CCREE_OLD
 	tristate "Support for ARM TrustZone CryptoCell C7XX family of Crypto accelerators"
-	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
+	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA && BROKEN
 	default n
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index ae702f3..1e7d105 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,3 +1,3 @@
-obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
+obj-$(CONFIG_CRYPTO_DEV_CCREE_OLD) := ccree.o
 ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
 ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
-- 
2.7.4
