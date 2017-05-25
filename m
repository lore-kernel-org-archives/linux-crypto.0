From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 11/14] crypto: rsa - comply with crypto_akcipher_maxsize()
Date: Thu, 25 May 2017 10:18:13 +0300
Message-ID: <1495696696-22580-12-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35063 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHTH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:19:07 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/rsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4c280b6..b067f3a 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -337,11 +337,11 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	return -ENOMEM;
 }
 
-static int rsa_max_size(struct crypto_akcipher *tfm)
+static unsigned int rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct rsa_mpi_key *pkey = akcipher_tfm_ctx(tfm);
 
-	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+	return mpi_get_size(pkey->n);
 }
 
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
-- 
2.7.4
