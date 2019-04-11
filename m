Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B9BC282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3A62184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDKIvM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:12 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41240 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfDKIvL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQM-0003Nt-7X
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:10 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQM-0006nK-0d; Thu, 11 Apr 2019 16:51:10 +0800
Subject: [PATCH 13/24] crypto: inside-secure - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQM-0006nK-0d@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:10 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/inside-secure/safexcel_cipher.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 7ef30a98cb24..de4be10b172f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1039,13 +1039,12 @@ static int safexcel_cbc_des3_ede_decrypt(struct skcipher_request *req)
 static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 				   const u8 *key, unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
+	int err;
 
-	if (len != DES3_EDE_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	err = des3_verify_key(ctfm, key);
+	if (unlikely(err))
+		return err;
 
 	/* if context exits and key changed, need to invalidate it */
 	if (ctx->base.ctxr_dma) {
