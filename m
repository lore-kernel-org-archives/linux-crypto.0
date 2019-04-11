Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A7C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0B72184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfDKIvD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:03 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41196 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDKIu7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:50:59 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQA-0003Jm-1j
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:50:58 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQ9-0006lY-RV; Thu, 11 Apr 2019 16:50:57 +0800
Subject: [PATCH 2/24] crypto: s390 - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQ9-0006lY-RV@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:50:57 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/s390/crypto/des_s390.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 0d15383d0ff1..1f9ab24dc048 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -224,24 +224,11 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int key_len)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
 
-	if (!(crypto_memneq(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
-	    crypto_memneq(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
-			  DES_KEY_SIZE)) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
-
-	/* in fips mode, ensure k1 != k2 and k2 != k3 and k1 != k3 */
-	if (fips_enabled &&
-	    !(crypto_memneq(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
-	      crypto_memneq(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
-			    DES_KEY_SIZE) &&
-	      crypto_memneq(key, &key[DES_KEY_SIZE * 2], DES_KEY_SIZE))) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = __des3_verify_key(&tfm->crt_flags, key);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, key_len);
 	return 0;
