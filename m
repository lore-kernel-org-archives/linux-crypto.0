From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 08/22] staging: ccree: remove m32r as supported platform
Date: Tue, 15 Aug 2017 09:26:36 +0300
Message-ID: <1502778412-16255-9-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
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

M32R requires special handling due due to how it has implemented
ioread32. It is also an orphaned arch on Linux and doesn't seem
to be worth the trouble. So until we have a real user, remove
support for it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/Kconfig b/drivers/staging/ccree/Kconfig
index 0b3092b..89af1c5 100644
--- a/drivers/staging/ccree/Kconfig
+++ b/drivers/staging/ccree/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell C7XX family of Crypto accelerators"
-	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
+	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA && !M32R
 	default n
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
-- 
2.1.4
