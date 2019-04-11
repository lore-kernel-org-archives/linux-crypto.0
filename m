Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E13C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD9821850
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfDKIvL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:11 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41232 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfDKIvJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQK-0003Md-0T
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQJ-0006n0-Pt; Thu, 11 Apr 2019 16:51:07 +0800
Subject: [PATCH 11/24] crypto: hifn_795x - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQJ-0006n0-Pt@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:07 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/hifn_795x.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dad212cabe63..d656be0a142b 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1976,6 +1976,29 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return 0;
 }
 
+static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			    unsigned int len)
+{
+	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
+	struct hifn_device *dev = ctx->dev;
+	u32 flags;
+	int err;
+
+	flags = crypto_ablkcipher_get_flags(cipher);
+	err = __des3_verify_key(&flags, key);
+	if (unlikely(err)) {
+		crypto_ablkcipher_set_flags(cipher, flags);
+		return err;
+	}
+
+	dev->flags &= ~HIFN_FLAG_OLD_KEY;
+
+	memcpy(ctx->key, key, len);
+	ctx->keysize = len;
+
+	return 0;
+}
+
 static int hifn_handle_req(struct ablkcipher_request *req)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
@@ -2240,7 +2263,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
+			.setkey		=	hifn_des3_setkey,
 			.encrypt	=	hifn_encrypt_3des_cfb,
 			.decrypt	=	hifn_decrypt_3des_cfb,
 		},
@@ -2250,7 +2273,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
+			.setkey		=	hifn_des3_setkey,
 			.encrypt	=	hifn_encrypt_3des_ofb,
 			.decrypt	=	hifn_decrypt_3des_ofb,
 		},
@@ -2261,7 +2284,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 			.ivsize		=	HIFN_IV_LENGTH,
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
+			.setkey		=	hifn_des3_setkey,
 			.encrypt	=	hifn_encrypt_3des_cbc,
 			.decrypt	=	hifn_decrypt_3des_cbc,
 		},
@@ -2271,7 +2294,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 		.ablkcipher = {
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
+			.setkey		=	hifn_des3_setkey,
 			.encrypt	=	hifn_encrypt_3des_ecb,
 			.decrypt	=	hifn_decrypt_3des_ecb,
 		},
