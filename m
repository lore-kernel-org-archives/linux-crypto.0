From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 01/13] crypto: caam/qi - fix typo in authenc alg driver name
Date: Fri, 7 Jul 2017 16:05:11 +0300
Message-ID: <20170707130523.32427-2-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:31743
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752148AbdGGNGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:06:05 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

s/desi/des for echainiv(authenc(hmac(sha256),cbc(des))) alg.

Cc: <stable@vger.kernel.org>
Fixes: b189817cf7894 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ea0e5b8b9171..b63bc3019f42 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1970,7 +1970,7 @@ static struct caam_aead_alg driver_aeads[] = {
 				.cra_name = "echainiv(authenc(hmac(sha256),"
 					    "cbc(des)))",
 				.cra_driver_name = "echainiv-authenc-"
-						   "hmac-sha256-cbc-desi-"
+						   "hmac-sha256-cbc-des-"
 						   "caam-qi",
 				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-- 
2.12.0.264.gd6db3f216544
