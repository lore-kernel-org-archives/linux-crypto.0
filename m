From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 05/13] crypto: inside-secure - optimize DSE bufferability control
Date: Thu, 15 Jun 2017 09:56:21 +0200
Message-ID: <20170615075629.30907-6-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Igal Liberman <igall@marvell.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53408 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbdFOIAF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:05 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Igal Liberman <igall@marvell.com>

Configure the data write bufferability to always buffer packets in the
DSE. This change slightly improves performance.

Signed-off-by: Igal Liberman <igall@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel.c | 1 +
 drivers/crypto/inside-secure/safexcel.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 658b307c6a11..73f4ef8d71f3 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -329,6 +329,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	val = EIP197_HIA_DSE_CFG_DIS_DEBUG;
 	val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(7) | EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
 	val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
+	val |= EIP197_HIA_DSE_CFG_ALLWAYS_BUFFERABLE;
 	val |= EIP197_HIA_DSE_CFG_EN_SINGLE_WR;
 	writel(val, priv->base + EIP197_HIA_DSE_CFG);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b8a81c568c99..7e3cbb9ac98e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -139,6 +139,7 @@
 #define EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(n)	((n) << 0)
 #define EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(n)	(((n) & 0x7) << 4)
 #define EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(n)	((n) << 8)
+#define EIP197_HIA_DSE_CFG_ALLWAYS_BUFFERABLE	GENMASK(15, 14)
 #define EIP197_HIA_DxE_CFG_MIN_CTRL_SIZE(n)	((n) << 16)
 #define EIP197_HIA_DxE_CFG_CTRL_CACHE_CTRL(n)	(((n) & 0x7) << 20)
 #define EIP197_HIA_DxE_CFG_MAX_CTRL_SIZE(n)	((n) << 24)
-- 
2.9.4
