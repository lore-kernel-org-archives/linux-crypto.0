From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm/ghash: change internal cra_name to "__ghash"
Date: Mon,  5 Sep 2016 12:58:44 +0100
Message-ID: <1473076724-2725-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38821 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755790AbcIEL7F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2016 07:59:05 -0400
Received: by mail-wm0-f48.google.com with SMTP id 1so135159912wmz.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Sep 2016 04:59:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The fact that the internal synchrous hash implementation is called
"ghash" like the publicly visible one is causing the testmgr code
to misidentify it as an algorithm that requires testing at boottime.
So rename it to "__ghash" to prevent this.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Hi Herbert,

This one should be able to go on top of the 3-pieces series I sent you
last week.

Thanks,
Ard.


 arch/arm/crypto/ghash-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index b88364aa149a..7546b3c02466 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -138,7 +138,7 @@ static struct shash_alg ghash_alg = {
 	.setkey			= ghash_setkey,
 	.descsize		= sizeof(struct ghash_desc_ctx),
 	.base			= {
-		.cra_name	= "ghash",
+		.cra_name	= "__ghash",
 		.cra_driver_name = "__driver-ghash-ce",
 		.cra_priority	= 0,
 		.cra_flags	= CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_INTERNAL,
-- 
2.7.4
