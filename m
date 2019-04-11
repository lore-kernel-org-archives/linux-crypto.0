Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77651C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 490DF2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfDKIvS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:18 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41264 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfDKIvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:18 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQS-0003QG-SW
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQS-0006oI-Lk; Thu, 11 Apr 2019 16:51:16 +0800
Subject: [PATCH 19/24] crypto: qce - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQS-0006oI-Lk@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:16 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qce/ablkcipher.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 154b6baa124e..8d3493855a70 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -198,6 +198,25 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	return -EINVAL;
 }
 
+static int qce_des3_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+			   unsigned int keylen)
+{
+	struct qce_cipher_ctx *ctx = crypto_ablkcipher_ctx(ablk);
+	u32 flags;
+	int err;
+
+	flags = crypto_ablkcipher_get_flags(ablk);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(ablk, flags);
+		return err;
+	}
+
+	ctx->enc_keylen = keylen;
+	memcpy(ctx->enc_key, key, keylen);
+	return 0;
+}
+
 static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 {
 	struct crypto_tfm *tfm =
@@ -363,7 +382,8 @@ static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
 	alg->cra_ablkcipher.ivsize = def->ivsize;
 	alg->cra_ablkcipher.min_keysize = def->min_keysize;
 	alg->cra_ablkcipher.max_keysize = def->max_keysize;
-	alg->cra_ablkcipher.setkey = qce_ablkcipher_setkey;
+	alg->cra_ablkcipher.setkey = IS_3DES(def->flags) ?
+				     qce_des3_setkey : qce_ablkcipher_setkey;
 	alg->cra_ablkcipher.encrypt = qce_ablkcipher_encrypt;
 	alg->cra_ablkcipher.decrypt = qce_ablkcipher_decrypt;
 
