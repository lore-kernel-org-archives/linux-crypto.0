From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix error IDs for SEC v5.x RNG4
Date: Sat, 15 Sep 2012 03:33:54 +0300
Message-ID: <1347669234-31464-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:8713
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759078Ab2INVi0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Sep 2012 17:38:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

According to SEC v5.0-v5.3 reference manuals.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Acked-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/error.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 9955ed9..30b8f74 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -77,10 +77,8 @@ static void report_ccb_status(u32 status, char *outstr)
 		"Not instantiated",
 		"Test instantiate",
 		"Prediction resistance",
-		"",
 		"Prediction resistance and test request",
 		"Uninstantiate",
-		"",
 		"Secure key generation",
 	};
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
-- 
1.7.7.6
