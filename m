From: Scott Wood <scottwood-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Subject: [RFC PATCH 03/17] crypto: caam: Blacklist CAAM when kexec is enabled
Date: Sat, 18 Jul 2015 15:08:40 -0500
Message-ID: <1437250134-307-4-git-send-email-scottwood@freescale.com>
References: <1437250134-307-1-git-send-email-scottwood@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
 Cristian Stoica <cristian.stoica-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Scott
 Wood <scottwood-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Tiejun Chen <tiejun.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Horia Geanta <horia.geanta-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
To: <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1437250134-307-1-git-send-email-scottwood-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This driver hangs the kernel on boot when loaded via kexec.

To make this driver kexec-safe, add a suspend or freeze hook, and when
probing, don't make any assumptions about the existing hardware state
(e.g. don't request_irq before quiescing the device).

Signed-off-by: Scott Wood <scottwood-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Cc: Cristian Stoica <cristian.stoica-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Cc: Horia Geanta <horia.geanta-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index e286e28..310e9e0 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_FSL_CAAM
 	tristate "Freescale CAAM-Multicore driver backend"
-	depends on FSL_SOC
+	depends on FSL_SOC && !KEXEC
 	help
 	  Enables the driver module for Freescale's Cryptographic Accelerator
 	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).
-- 
2.1.4
