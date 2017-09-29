From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: ecdh_helper - return unsigned value for crypto_ecdh_key_len()
Date: Fri, 29 Sep 2017 12:13:08 +0300
Message-ID: <20170929091308.23734-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:57948 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdI2JNO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 05:13:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ECDH_KPP_SECRET_MIN_SIZE and params->key_size are both returning
unsigned values.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh_helper.c  | 2 +-
 include/crypto/ecdh.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index f05bea5..d3af8e8 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -28,7 +28,7 @@ static inline const u8 *ecdh_unpack_data(void *dst, const void *src, size_t sz)
 	return src + sz;
 }
 
-int crypto_ecdh_key_len(const struct ecdh *params)
+unsigned int crypto_ecdh_key_len(const struct ecdh *params)
 {
 	return ECDH_KPP_SECRET_MIN_SIZE + params->key_size;
 }
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 1aff2a8..d696317 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -54,7 +54,7 @@ struct ecdh {
  *
  * Return: size of the key in bytes
  */
-int crypto_ecdh_key_len(const struct ecdh *params);
+unsigned int crypto_ecdh_key_len(const struct ecdh *params);
 
 /**
  * crypto_ecdh_encode_key() - encode the private key
-- 
2.9.4
