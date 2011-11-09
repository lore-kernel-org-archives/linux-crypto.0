From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: talitos - fix descriptor buffer access code
Date: Tue, 8 Nov 2011 19:34:57 -0600
Message-ID: <20111108193457.db068c56fe6db067e4d9057c@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:28415
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab1KIBf5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 20:35:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit 3e721ae (crypto: talitos - handle descriptor not found in
error path) used the wrong offset method to access a channel's
descriptor buffer registers - the TALITOS_DESCBUF macro
doesn't take a channel argument.  Fix it to use the
base chan[x].reg offset instead.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dbe76b5..98ffcc1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -444,7 +444,7 @@ static void report_eu_error(struct device *dev, int ch, u32 desc_hdr)
 	int i;
 
 	if (!desc_hdr)
-		desc_hdr = in_be32(priv->reg + TALITOS_DESCBUF(ch));
+		desc_hdr = in_be32(priv->chan[ch].reg + TALITOS_DESCBUF);
 
 	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
-- 
1.7.7
