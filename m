From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 14/14] crypto: omap-aes: Kconfig: Add build support for
 AM437x
Date: Sat, 17 Aug 2013 21:42:35 -0500
Message-ID: <1376793755-30478-15-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Joel Fernandes <joelf@ti.com>, Linux OMAP List <linux-omap@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>, "David S. Miller"
 <davem@davemloft.net>, Mark Greer <mgreer@animalcreek.com>, Tony Lindgren
 <tony@atomide.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rajendra
 Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

For AM437x SoC, ARCH_OMAP2 and ARCH_OMAP3 is not enabled in the defconfig. We
follow same thing as SHA driver, and add depends on ARCH_OMAP2PLUS so that the
config is selectable for AES driver on AM437x SoC builds.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index dffb855..e289afa 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -252,7 +252,7 @@ config CRYPTO_DEV_OMAP_SHAM
 
 config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
-	depends on ARCH_OMAP2 || ARCH_OMAP3
+	depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
 	help
-- 
1.7.9.5
