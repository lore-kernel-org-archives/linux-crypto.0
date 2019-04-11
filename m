Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D01AC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 786022184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfDKIvU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:20 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41272 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfDKIvU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:20 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQV-0003RY-6O
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQU-0006oc-Sr; Thu, 11 Apr 2019 16:51:18 +0800
Subject: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQU-0006oc-Sr@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:18 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-cryp.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 23b0b7bd64c7..5785f3e235ce 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -762,10 +762,17 @@ static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
-	if (keylen != (3 * DES_KEY_SIZE))
-		return -EINVAL;
-	else
-		return stm32_cryp_setkey(tfm, key, keylen);
+	u32 flags;
+	int err;
+
+	flags = crypto_ablkcipher_get_flags(tfm);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(tfm, flags);
+		return err;
+	}
+
+	return stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
