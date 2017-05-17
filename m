From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [RFC PATCH v2 2/4] crypto: ecdh - allow user to provide NULL privkey
Date: Wed, 17 May 2017 18:26:51 +0300
Message-ID: <1495034813-27143-3-git-send-email-tudor.ambarus@microchip.com>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58579 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdEQP1d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:27:33 -0400
In-Reply-To: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the user provides a NULL ecc private key, the kernel will
generate it and further use it for ecdh.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 63ca337..f28f5b5 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -55,6 +55,10 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	ctx->curve_id = params.curve_id;
 	ctx->ndigits = ndigits;
 
+	if (!params.key || !params.key_size)
+		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
+				       ctx->private_key);
+
 	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
 			     (const u8 *)params.key, params.key_size) < 0)
 		return -EINVAL;
-- 
2.7.4
