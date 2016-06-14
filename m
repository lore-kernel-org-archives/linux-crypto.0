From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 4/4] crypto: CTR DRBG - avoid duplicate maintenance of key
Date: Tue, 14 Jun 2016 07:36:06 +0200
Message-ID: <209415319.SS2DWd2TFO@positron.chronox.de>
References: <1842774.dgV8IOeQEu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36440 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbcFNFg3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 01:36:29 -0400
In-Reply-To: <1842774.dgV8IOeQEu@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The TFM object maintains the key for the CTR DRBG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8ceb716..ded8638 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -517,8 +517,7 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 		return ret;
 
 	/* 10.2.1.2 step 5 */
-	memcpy(drbg->C, temp, drbg_keylen(drbg));
-	ret = crypto_skcipher_setkey(drbg->ctr_handle, drbg->C,
+	ret = crypto_skcipher_setkey(drbg->ctr_handle, temp,
 				     drbg_keylen(drbg));
 	if (ret)
 		goto out;
-- 
2.5.5
