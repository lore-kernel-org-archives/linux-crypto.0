From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 02/13] crypto: inside-secure - fix the ring wr_cache offset
Date: Thu, 15 Jun 2017 09:56:18 +0200
Message-ID: <20170615075629.30907-3-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53392 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdFOIAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:04 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The EIP197_HIA_xDR_CFG_WR_CACHE macro was defined to use an offset of
23, which is wrong as it's actually 25. Fix this.

Reported-by: Igal Liberman <igall@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index c17fdd40b99f..0328a9314b90 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -99,7 +99,7 @@
 #define EIP197_HIA_xDR_WR_RES_BUF		BIT(22)
 #define EIP197_HIA_xDR_WR_CTRL_BUG		BIT(23)
 #define EIP197_HIA_xDR_WR_OWN_BUF		BIT(24)
-#define EIP197_HIA_xDR_CFG_WR_CACHE(n)		(((n) & 0x7) << 23)
+#define EIP197_HIA_xDR_CFG_WR_CACHE(n)		(((n) & 0x7) << 25)
 #define EIP197_HIA_xDR_CFG_RD_CACHE(n)		(((n) & 0x7) << 29)
 
 /* EIP197_HIA_CDR_THRESH */
-- 
2.9.4
