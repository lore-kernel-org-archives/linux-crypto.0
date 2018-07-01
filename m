From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 6/6] crypto: ccree: rate limit debug print
Date: Sun,  1 Jul 2018 08:02:39 +0100
Message-ID: <1530428560-4440-7-git-send-email-gilad@benyossef.com>
References: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

A debug print about register status post interrupt can happen
quite often. Rate limit it to avoid cluttering the log.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/crypto/ccree/cc_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index bd974fe..1ff229c 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -131,8 +131,8 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 
 	if (irr) {
-		dev_dbg(dev, "IRR includes unknown cause bits (0x%08X)\n",
-			irr);
+		dev_dbg_ratelimited(dev, "IRR includes unknown cause bits (0x%08X)\n",
+				    irr);
 		/* Just warning */
 	}
 
-- 
2.7.4
