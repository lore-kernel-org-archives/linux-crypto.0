From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 05/10] crypto: qat - avoid memory corruption or undefined behaviour
Date: Fri, 18 Mar 2016 20:32:02 +0200
Message-ID: <1458325927-14737-5-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:46168
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbcCRSrR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:47:17 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
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
