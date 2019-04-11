Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F990C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25AF2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfDKIvG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:06 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41216 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfDKIvF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQF-0003LC-Hs
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQF-0006mM-AF; Thu, 11 Apr 2019 16:51:03 +0800
Subject: [PATCH 7/24] crypto: cavium - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQF-0006mM-AF@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:03 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/cpt/cptvf_algs.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 600336d169a9..8cffe6094270 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -327,12 +327,30 @@ static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
+	u32 flags = crypto_ablkcipher_get_flags(cipher);
+	int err;
+
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
+
 	return cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
 
 static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
+	u32 flags = crypto_ablkcipher_get_flags(cipher);
+	int err;
+
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
+
 	return cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
 
