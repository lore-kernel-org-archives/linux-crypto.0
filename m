From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 07/11] crypto: dh - fix memleak in setkey
Date: Wed, 17 May 2017 18:00:34 +0300
Message-ID: <1495033238-26016-8-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:36645 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdEQPBM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:12 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

setkey can be called multiple times during the existence
of the transformation object. Free the old MPI key if any.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/dh.c b/crypto/dh.c
index 325a5dd..b55b03d 100644
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
