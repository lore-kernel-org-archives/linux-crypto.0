From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2 1/2] crypto: qat - avoid memory corruption or undefined behaviour
Date: Wed, 23 Mar 2016 17:06:39 +0200
Message-ID: <1458745600-1448-2-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458745600-1448-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0091.outbound.protection.outlook.com ([157.56.110.91]:22240
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932202AbcCWPGu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 11:06:50 -0400
In-Reply-To: <1458745600-1448-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

memcopying to a (null pointer + offset) will result
in memory corruption or undefined behaviour.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index e5c0727..8dbbf084 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -593,7 +593,7 @@ int qat_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 
 	ret = -ENOMEM;
 	ctx->d = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_d, GFP_KERNEL);
-	if (!ctx->n)
+	if (!ctx->d)
 		goto err;
 
 	memcpy(ctx->d + (ctx->key_sz - vlen), ptr, vlen);
-- 
1.8.3.1
