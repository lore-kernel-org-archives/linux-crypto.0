Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA99AC282DA
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB632184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDKIvD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:03 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41208 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfDKIvD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:03 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQD-0003KL-Eu
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQD-0006m2-4q; Thu, 11 Apr 2019 16:51:01 +0800
Subject: [PATCH 5/24] crypto: bcm - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQD-0006m2-4q@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:01 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/bcm/cipher.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 28f592f7e1b7..8862200d4a0b 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -1840,13 +1840,14 @@ static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
 
 	if (keylen == (DES_KEY_SIZE * 3)) {
-		const u32 *K = (const u32 *)key;
-		u32 flags = CRYPTO_TFM_RES_BAD_KEY_SCHED;
+		u32 flags;
+		int ret;
 
-		if (!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		    !((K[2] ^ K[4]) | (K[3] ^ K[5]))) {
+		flags = crypto_ablkcipher_get_flags(cipher);
+		ret = __des3_verify_key(&flags, key);
+		if (unlikely(ret)) {
 			crypto_ablkcipher_set_flags(cipher, flags);
-			return -EINVAL;
+			return ret;
 		}
 
 		ctx->cipher_type = CIPHER_TYPE_3DES;
@@ -2885,13 +2886,13 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 		break;
 	case CIPHER_ALG_3DES:
 		if (ctx->enckeylen == (DES_KEY_SIZE * 3)) {
-			const u32 *K = (const u32 *)keys.enckey;
-			u32 flags = CRYPTO_TFM_RES_BAD_KEY_SCHED;
+			u32 flags;
 
-			if (!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-			    !((K[2] ^ K[4]) | (K[3] ^ K[5]))) {
+			flags = crypto_aead_get_flags(cipher);
+			ret = __des3_verify_key(&flags, keys.enckey);
+			if (unlikely(ret)) {
 				crypto_aead_set_flags(cipher, flags);
-				return -EINVAL;
+				return ret;
 			}
 
 			ctx->cipher_type = CIPHER_TYPE_3DES;
