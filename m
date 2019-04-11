Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124EFC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD9621852
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfDKIvI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:08 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41228 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfDKIvI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQI-0003Lu-TT
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQI-0006mq-Kd; Thu, 11 Apr 2019 16:51:06 +0800
Subject: [PATCH 10/24] crypto: ccree - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQI-0006mq-Kd@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:06 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccree/cc_aead.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index a3527c00b29a..c5cde327cf1f 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -650,6 +650,39 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	return rc;
 }
 
+static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
+			       unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(aead);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err)) {
+		crypto_aead_set_flags(aead, flags);
+		goto out;
+	}
+
+	err = cc_aead_setkey(aead, key, keylen);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+
+badkey:
+	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
 static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 				 unsigned int keylen)
 {
@@ -2372,7 +2405,7 @@ static struct cc_alg_template aead_algs[] = {
 		.driver_name = "authenc-hmac-sha1-cbc-des3-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.template_aead = {
-			.setkey = cc_aead_setkey,
+			.setkey = cc_des3_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
 			.encrypt = cc_aead_encrypt,
 			.decrypt = cc_aead_decrypt,
@@ -2412,7 +2445,7 @@ static struct cc_alg_template aead_algs[] = {
 		.driver_name = "authenc-hmac-sha256-cbc-des3-ccree",
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.template_aead = {
-			.setkey = cc_aead_setkey,
+			.setkey = cc_des3_aead_setkey,
 			.setauthsize = cc_aead_setauthsize,
 			.encrypt = cc_aead_encrypt,
 			.decrypt = cc_aead_decrypt,
