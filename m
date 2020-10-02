Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA10C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 07:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335CD20719
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 07:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJBHz1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:55:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48594 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgJBHz1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 03:55:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kOFuU-0001qj-1x; Fri, 02 Oct 2020 17:55:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2020 17:55:22 +1000
Date:   Fri, 2 Oct 2020 17:55:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        =?utf-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?aHVudGNoZW4o6ZmI6ZizKQ==?= <huntchen@tencent.com>,
        =?utf-8?B?ZGFubnl3YW5nKOeOi+Wuhyk=?= <dannywang@tencent.com>
Cc:     Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
Subject: [PATCH] crypto: bcm - Verify GCM/CCM key length in setkey
Message-ID: <20201002075522.GA6186@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The setkey function for GCM/CCM algorithms didn't verify the key
length before copying the key and subtracting the salt length.

This patch delays the copying of the key til after the verification
has been done.  It also adds checks on the key length to ensure
that it's at least as long as the salt.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Cc: <stable@vger.kernel.org>
Reported-by: kiyin(尹亮) <kiyin@tencent.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 5d38b87b9d77..50d169e61b41 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2867,7 +2867,6 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *cipher,
 
 	ctx->enckeylen = keylen;
 	ctx->authkeylen = 0;
-	memcpy(ctx->enckey, key, ctx->enckeylen);
 
 	switch (ctx->enckeylen) {
 	case AES_KEYSIZE_128:
@@ -2883,6 +2882,8 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *cipher,
 		goto badkey;
 	}
 
+	memcpy(ctx->enckey, key, ctx->enckeylen);
+
 	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
 		 ctx->authkeylen);
 	flow_dump("  enc: ", ctx->enckey, ctx->enckeylen);
@@ -2937,6 +2938,10 @@ static int aead_gcm_esp_setkey(struct crypto_aead *cipher,
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = GCM_ESP_SALT_SIZE;
 	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -2965,6 +2970,10 @@ static int rfc4543_gcm_esp_setkey(struct crypto_aead *cipher,
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = GCM_ESP_SALT_SIZE;
 	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -2994,6 +3003,10 @@ static int aead_ccm_esp_setkey(struct crypto_aead *cipher,
 	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
 
 	flow_log("%s\n", __func__);
+
+	if (keylen < CCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len = CCM_ESP_SALT_SIZE;
 	ctx->salt_offset = CCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - CCM_ESP_SALT_SIZE, CCM_ESP_SALT_SIZE);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
