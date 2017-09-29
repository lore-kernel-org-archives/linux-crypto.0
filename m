From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 1/3] crypto: dh_helper - return unsigned int for dh_data_size()
Date: Fri, 29 Sep 2017 12:21:04 +0300
Message-ID: <20170929092106.24276-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5212 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdI2JVK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 05:21:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

p->key_size, p->p_size, p->g_size are all of unsigned int type.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 8ba8a3f..69869da 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -28,7 +28,7 @@ static inline const u8 *dh_unpack_data(void *dst, const void *src, size_t size)
 	return src + size;
 }
 
-static inline int dh_data_size(const struct dh *p)
+static inline unsigned int dh_data_size(const struct dh *p)
 {
 	return p->key_size + p->p_size + p->g_size;
 }
-- 
2.9.4
