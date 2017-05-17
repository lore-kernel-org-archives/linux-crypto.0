From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 11/11] crypto: rsa - do checks before allocating data
Date: Wed, 17 May 2017 18:00:38 +0300
Message-ID: <1495033238-26016-12-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:23804 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754032AbdEQPB1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:27 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/rsa.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4c280b6..a80f76d 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -279,6 +279,9 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (rsa_check_key_length(raw_key.n_sz << 3))
+		return -EINVAL;
+
 	mpi_key->e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
 	if (!mpi_key->e)
 		goto err;
@@ -287,11 +290,6 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	if (!mpi_key->n)
 		goto err;
 
-	if (rsa_check_key_length(mpi_get_size(mpi_key->n) << 3)) {
-		rsa_free_mpi_key(mpi_key);
-		return -EINVAL;
-	}
-
 	return 0;
 
 err:
@@ -313,6 +311,9 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (rsa_check_key_length(raw_key.n_sz << 3))
+		return -EINVAL;
+
 	mpi_key->d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
 	if (!mpi_key->d)
 		goto err;
@@ -325,11 +326,6 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	if (!mpi_key->n)
 		goto err;
 
-	if (rsa_check_key_length(mpi_get_size(mpi_key->n) << 3)) {
-		rsa_free_mpi_key(mpi_key);
-		return -EINVAL;
-	}
-
 	return 0;
 
 err:
-- 
2.7.4
