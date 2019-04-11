Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC5EC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8594E2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfDKIvN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:13 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41220 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDKIvG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:06 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQG-0003LL-Lp
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQG-0006mW-Cj; Thu, 11 Apr 2019 16:51:04 +0800
Subject: [PATCH 8/24] crypto: nitrox - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQG-0006mW-Cj@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:04 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/nitrox/nitrox_skcipher.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index d4935d6cefdd..7e4a5e69085e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -257,12 +257,8 @@ static int nitrox_aes_decrypt(struct skcipher_request *skreq)
 static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
 			      const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES3_EDE_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	return nitrox_skcipher_setkey(cipher, 0, key, keylen);
+	return unlikely(des3_verify_key(cipher, key)) ?:
+	       nitrox_skcipher_setkey(cipher, 0, key, keylen);
 }
 
 static int nitrox_3des_encrypt(struct skcipher_request *skreq)
