From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 03/13] crypto: inside-secure - fix incorrect DSE data cache setting
Date: Thu, 15 Jun 2017 09:56:19 +0200
Message-ID: <20170615075629.30907-4-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53398 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbdFOIAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:04 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Set the correct value to the DSE data cache, using WR_CACHE_3BITS
instead of RD_CACHE_3BITS. This fixes an incorrect setting and helps
improving performances.

Reported-by: Igal Liberman <igall@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5485e925e18d..99755fc1a161 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -328,7 +328,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	/* DMA transfer size to use */
 	val = EIP197_HIA_DSE_CFG_DIS_DEBUG;
 	val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(7) | EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
-	val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(RD_CACHE_3BITS);
+	val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
 	writel(val, priv->base + EIP197_HIA_DSE_CFG);
 
 	/* Leave the DSE threads reset state */
-- 
2.9.4
