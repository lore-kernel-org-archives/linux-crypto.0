From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [RFC PATCH 03/12] crypto: crypto4xx: set CRYPTO_ALG_KERN_DRIVER_ONLY flag
Date: Fri, 25 Aug 2017 15:47:16 +0200
Message-ID: <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36244 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbdHYNrd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:33 -0400
Received: by mail-wr0-f194.google.com with SMTP id p8so1525165wrf.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:32 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The security offload function is performed by a cryptographic
engine core attached to the 128-bit PLB (processor local bus)
with builtin DMA and interrupt controllers. This, I think,
satisfies the requirement for the CRYPTO_ALG_KERN_DRIVER_ONLY
flag.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 48215b8525a2..249d35ff3806 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1114,7 +1114,9 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.cra_name 	= "cbc(aes)",
 		.cra_driver_name = "cbc-aes-ppc4xx",
 		.cra_priority 	= CRYPTO4XX_CRYPTO_PRIORITY,
-		.cra_flags 	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize 	= AES_BLOCK_SIZE,
 		.cra_ctxsize 	= sizeof(struct crypto4xx_ctx),
 		.cra_type 	= &crypto_ablkcipher_type,
-- 
2.14.1
