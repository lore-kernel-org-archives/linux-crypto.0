From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 06/11] crypto: rsa - change err code in rsa_max_size
Date: Tue, 23 May 2017 16:19:00 +0300
Message-ID: <1495545545-16872-7-git-send-email-tudor.ambarus@microchip.com>
References: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2549 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937106AbdEWNTx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 09:19:53 -0400
In-Reply-To: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If key was not successfully set, return -ENOKEY instead of
-EINVAL.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/rsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4c280b6..3cf640e 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -341,7 +341,7 @@ static int rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct rsa_mpi_key *pkey = akcipher_tfm_ctx(tfm);
 
-	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+	return pkey->n ? mpi_get_size(pkey->n) : -ENOKEY;
 }
 
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
-- 
2.7.4
