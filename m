From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 06/10] crypto: qat - fix address leaking of RSA public exponent
Date: Fri, 18 Mar 2016 20:32:03 +0200
Message-ID: <1458325927-14737-6-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0093.outbound.protection.outlook.com ([65.55.169.93]:18042
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbcCRSrI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:47:08 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 8dbbf084..05f49d4 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -711,7 +711,7 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	}
 	qat_crypto_put_instance(ctx->inst);
 	ctx->n = NULL;
-	ctx->d = NULL;
+	ctx->e = NULL;
 	ctx->d = NULL;
 }
 
-- 
1.8.3.1
