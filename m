From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 07/14] crypto: dh - comply with crypto_kpp_maxsize()
Date: Thu, 25 May 2017 10:18:09 +0300
Message-ID: <1495696696-22580-8-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:46634 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHSv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:51 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_kpp_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index e151f12..b1032a5 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -147,7 +147,7 @@ static int dh_compute_value(struct kpp_request *req)
 	return ret;
 }
 
-static int dh_max_size(struct crypto_kpp *tfm)
+static unsigned int dh_max_size(struct crypto_kpp *tfm)
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 
-- 
2.7.4
