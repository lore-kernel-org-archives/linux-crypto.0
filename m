From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 16/20] crypto: caam - disable IRQ coalescing by default
Date: Fri, 22 Jun 2012 19:48:53 -0500
Message-ID: <1340412537-2325-11-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
 <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:14346
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756839Ab2FWAu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:50:57 -0400
In-Reply-To: <1340412537-2325-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It has been observed that in zero-loss benchmarks, when a
slow traffic rate is being tested, the IRQ timer coalescing
parameter was set too high, and the ethernet controller
would start dropping packets because the job ring back half
wouldn't be executed in time before the ethernet controller
would fill its buffers, thereby significantly reducing the
zero-loss performance figures.

Empirical testing has shown that the best zero-loss performance
is achieved when IRQ coalescing is set to minimum values and/or
turned off, since apparently the job ring driver already implements
an adequately-performing general-purpose IRQ mitigation strategy
in software.

Whilst we could go with minimal count (2-8) and timing settings
(192-256), we prefer just turning h/w coalescing altogether off
to minimize setkey latency (due to split key generation), and
for consistent cross-SoC performance (the SEC vs. core clock
ratio changes).

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 502a7f3..65c7668 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -32,10 +32,13 @@ config CRYPTO_DEV_FSL_CAAM_RINGSIZE
 config CRYPTO_DEV_FSL_CAAM_INTC
 	bool "Job Ring interrupt coalescing"
 	depends on CRYPTO_DEV_FSL_CAAM
-	default y
+	default n
 	help
 	  Enable the Job Ring's interrupt coalescing feature.
 
+	  Note: the driver already provides adequate
+	  interrupt coalescing in software.
+
 config CRYPTO_DEV_FSL_CAAM_INTC_COUNT_THLD
 	int "Job Ring interrupt coalescing count threshold"
 	depends on CRYPTO_DEV_FSL_CAAM_INTC
-- 
1.7.11.1
