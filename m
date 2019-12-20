Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC35C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928F2206D8
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYLdb1Sq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfLTTDE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37046 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so4490428plz.4
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8g79+8HxgAmptJNweOiWrmJikepmZeeltOX1+NbRKNU=;
        b=qYLdb1SqIvI20mscu3ddS7O2XmV2HUwMMTkwmie+LgySwl5IBiXyJ9GtAMROyx3uWj
         mPogga3yRYR8TyqsssX6dX2ChHx/Ao6z/WDRUR8yRhqOdzyD4qCNi7k1fDQKUxUQmkfW
         JVhHQ8Shn3sTih7QuQhCMOq9VnaW1JoEGVQRRqVsvXkyg7ZwT5kPGHNo+tYgFvipFrs2
         aGhsgnfTpbNlnW5quKVsA4OpDBglasnPrRWyxDex1nK7jQfMt/EgfyqwtqgqE1btodWB
         K0sAheBFLUNHG/imNeHezW7SFbMcDAyNedubS8LDJ+jtV52iiskdqdopKBWUw56iJnJL
         k/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8g79+8HxgAmptJNweOiWrmJikepmZeeltOX1+NbRKNU=;
        b=F6JbtbNCtucpvrFlMP3ibARAum1Ge3c8WvGDalX38DqK2gge+LBX86J7od38nth28v
         01qShTAlrXXpjQf19ztLMESoStNsdaLMqOdAVVtuZoy6MMkFAmZ2/PaD92K6UtwkdK3U
         tImOqznDI2oHOo76aF32oJWJAbwdAbzNRTNYlEhWGMJPRJ/LgCbuHs3jm9iR0ZKUnYb0
         +80/uYqQcCA+l0RLcTajBh6bWVoS7wf86zYi7F1FnGOb6EH5GbOin9ZI+wJCaG+xklCx
         5J+axWs99AEmsvi2zoJ3zVg2uvuJ6oEl5Q6UG4WNGUHubJ10koYrgB7E7d+Z0+AMg2dS
         r4Iw==
X-Gm-Message-State: APjAAAVP0SvyFm3YL1zjdt7Zd53bc9NObBSV93YekzxITS72SuBaapMC
        wjsGRyHVVd4shSMHseUlEWBa7h3j7yM=
X-Google-Smtp-Source: APXvYqyDoILnucbpEjUmU+9KRQiGvsRoyA+YJ70Yyub5QifgISMAyr32OOm9bUyUZFeVb9XHKkD8Bw==
X-Received: by 2002:a17:90a:ba91:: with SMTP id t17mr18176418pjr.74.1576868583267;
        Fri, 20 Dec 2019 11:03:03 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:02 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 2/6] crypto: qce - fix xts-aes-qce key sizes
Date:   Fri, 20 Dec 2019 16:02:14 -0300
Message-Id: <20191220190218.28884-3-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

XTS-mode uses two keys, so the keysizes should be doubled in
skcipher_def, and halved when checking if it is AES-128/192/256.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/qce/skcipher.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 1f1f40a761fa..e4f6d87ba51d 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -154,12 +154,13 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ablk);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	unsigned long flags = to_cipher_tmpl(ablk)->alg_flags;
 	int ret;
 
 	if (!key || !keylen)
 		return -EINVAL;
 
-	switch (keylen) {
+	switch (IS_XTS(flags) ? keylen >> 1 : keylen) {
 	case AES_KEYSIZE_128:
 	case AES_KEYSIZE_256:
 		break;
@@ -213,13 +214,15 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
+	int keylen;
 	int ret;
 
 	rctx->flags = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
+	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
-	if (IS_AES(rctx->flags) && ctx->enc_keylen != AES_KEYSIZE_128 &&
-	    ctx->enc_keylen != AES_KEYSIZE_256) {
+	if (IS_AES(rctx->flags) && keylen != AES_KEYSIZE_128 &&
+	    keylen != AES_KEYSIZE_256) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
@@ -311,8 +314,8 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.drv_name	= "xts-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
+		.min_keysize	= AES_MIN_KEY_SIZE * 2,
+		.max_keysize	= AES_MAX_KEY_SIZE * 2,
 	},
 	{
 		.flags		= QCE_ALG_DES | QCE_MODE_ECB,
