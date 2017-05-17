From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 04/11] crypto: dh - fix dh_max_size
Date: Wed, 17 May 2017 18:00:31 +0300
Message-ID: <1495033238-26016-5-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:28698 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754508AbdEQPBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:03 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function should return minimum size for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 7cec0498..325a5dd 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -148,7 +148,7 @@ static int dh_max_size(struct crypto_kpp *tfm)
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 
-	return mpi_get_size(ctx->p);
+	return ctx->p ? mpi_get_size(ctx->p) : -EINVAL;
 }
 
 static void dh_exit_tfm(struct crypto_kpp *tfm)
-- 
2.7.4
