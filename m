From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 09/14] crypto: qat - comply with crypto_kpp_maxsize()
Date: Thu, 25 May 2017 10:18:11 +0300
Message-ID: <1495696696-22580-10-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38810 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHS7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:59 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_kpp_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 2aab80b..1d882a7 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -521,11 +521,11 @@ static int qat_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	return 0;
 }
 
-static int qat_dh_max_size(struct crypto_kpp *tfm)
+static unsigned int qat_dh_max_size(struct crypto_kpp *tfm)
 {
 	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
 
-	return ctx->p ? ctx->p_size : -EINVAL;
+	return ctx->p_size;
 }
 
 static int qat_dh_init_tfm(struct crypto_kpp *tfm)
-- 
2.7.4
