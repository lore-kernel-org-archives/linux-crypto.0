From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 01/13] crypto: omap-aes: drop unused flags attribute from omap_aes_ctx
Date: Wed, 24 May 2017 10:35:22 +0300
Message-ID: <1495611334-15039-2-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:52352 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758135AbdEXHf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:35:59 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is not used for anything, so drop it.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index fe32dd9..ad6e2b3 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -105,7 +105,6 @@ struct omap_aes_ctx {
 
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
-	unsigned long	flags;
 	struct crypto_skcipher	*fallback;
 };
 
-- 
1.9.1
