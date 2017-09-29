From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 2/3] crypto: dh_helper - return unsigned value for crypto_dh_key_len()
Date: Fri, 29 Sep 2017 12:21:05 +0300
Message-ID: <20170929092106.24276-2-tudor.ambarus@microchip.com>
References: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:34296 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdI2JVN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 05:21:13 -0400
In-Reply-To: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DH_KPP_SECRET_MIN_SIZE and dh_data_size() are both returning
unsigned values.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh_helper.c  | 2 +-
 include/crypto/dh.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 69869da..a413b31 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -33,7 +33,7 @@ static inline unsigned int dh_data_size(const struct dh *p)
 	return p->key_size + p->p_size + p->g_size;
 }
 
-int crypto_dh_key_len(const struct dh *p)
+unsigned int crypto_dh_key_len(const struct dh *p)
 {
 	return DH_KPP_SECRET_MIN_SIZE + dh_data_size(p);
 }
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index f638998..71e1bb2 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -53,7 +53,7 @@ struct dh {
  *
  * Return: size of the key in bytes
  */
-int crypto_dh_key_len(const struct dh *params);
+unsigned int crypto_dh_key_len(const struct dh *params);
 
 /**
  * crypto_dh_encode_key() - encode the private key
-- 
2.9.4
