From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 11/11] crypto: dh - fix memleak in setkey
Date: Tue, 23 May 2017 16:19:05 +0300
Message-ID: <1495545545-16872-12-git-send-email-tudor.ambarus@microchip.com>
References: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33438 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935923AbdEWNUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 09:20:00 -0400
In-Reply-To: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

setkey can be called multiple times during the existence
of the transformation object. In case of multiple setkey calls,
the old key was not freed and we leaked memory.
Free the old MPI key if any.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/dh.c b/crypto/dh.c
index 3d35ba9..8eb433d 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -85,6 +85,9 @@ static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 	struct dh params;
 
+	/* Free the old MPI key if any */
+	dh_free_ctx(ctx);
+
 	if (crypto_dh_decode_key(buf, len, &params) < 0)
 		return -EINVAL;
 
-- 
2.7.4
