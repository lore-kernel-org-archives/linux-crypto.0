Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3559FC282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C9A206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwIlOCwx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfDVL0I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:26:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33989 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfDVL0H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 07:26:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id r186so13918318wmf.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Apr 2019 04:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=45OIqyxPhSR1GPiehZv11C5FocNohr7VYhj0ZCDPs8s=;
        b=QwIlOCwxa8hMFIGDnq1zPSJ1Ym2JkB67kE+/xzj0LyDU/QKlxtqfxlV2lU2TRZOtAS
         KZRHvfpzWH6x7Tihe+cYGdaQT4WEsPttOHJwSrzkiKshd7W380DvFIAt16nwz6y2+P2C
         nQCarDjHPTMrBkCO7Dv5YGi9P9Ru1lvhmMcmamp54Jqzx1BHYrQ2cynRRB71BeKIt15B
         6k/NDPRe5X9vemcOoyJ8Qcj2YMZYr9kBeORCdKfai1vFKXe6FxZNqFwMZrTlDbNN2Jcv
         K49Kh5obiWVk56UAzyD8DQXpA8H7u2d6LVLQadzvsBsr9deWFDiypbFpUYobGKtQC+Ej
         iksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=45OIqyxPhSR1GPiehZv11C5FocNohr7VYhj0ZCDPs8s=;
        b=W6SMNQmVz8DgDfQsdUSMj5YFv9xkGybwfhBB8ne1YM5ZwGI0/NhJ1ZjNTqlWH/WKZf
         z16BJjJ6X7gFhDd5dQwShzpouY9CXH0fD9Gek+wFp7uuuTKx/Sd0Uv+14DC9Cp+R4KD/
         9CfQwiLdHaV9QC1nrdMiugELvSd/+5dMAu6Fk6m4MlPVpappjNO2YfG7/O4ZR88xXYZL
         q3JR8/vJ0vCJGEMneCrnIjw2YaTRvS5uL8QsL+z6f9CszkNhtNUIIp6RRIqh9KNy88kg
         bWPucY24lxpMeRT7jhkE+hXP2tl1DcQka5sTds3N0S3964QypbD7RF1PuVFoW+ZZZBis
         TbLg==
X-Gm-Message-State: APjAAAVWuFJ5zx4r0XrLUuD5TdjpgrxSTyi4Ge1AfHYi6/aq3zWFObrk
        zq9Kj+yuH6DF4wzdnoA1uy8l9bFQ
X-Google-Smtp-Source: APXvYqxBMjhqBoyXNbvKJK9JKa+KpHJF+vEjIDFlMxqWvLEXeWaHXL2aG3JOaBpgPSf1xoCFcj4BTw==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr12511551wmc.1.1555932364765;
        Mon, 22 Apr 2019 04:26:04 -0700 (PDT)
Received: from debian64.daheim (p5B0D75EE.dip0.t-ipconnect.de. [91.13.117.238])
        by smtp.gmail.com with ESMTPSA id z63sm17909571wme.30.2019.04.22.04.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Apr 2019 04:26:03 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hIX5F-0001VV-IV; Mon, 22 Apr 2019 13:26:01 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto4xx: use sync skcipher for fallback
Date:   Mon, 22 Apr 2019 13:26:00 +0200
Message-Id: <f2832f561a239db6dff6da5550e6c97913a70b02.1555932334.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <4d8f4f483feb713126bbdb789b095936819d9804.1555932334.git.chunkeey@gmail.com>
References: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com> <4d8f4f483feb713126bbdb789b095936819d9804.1555932334.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This replaces struct crypto_skcipher and the extra request size
with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
which uses a fixed stack size.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 12 ++++++------
 drivers/crypto/amcc/crypto4xx_core.c | 11 +++--------
 drivers/crypto/amcc/crypto4xx_core.h |  2 +-
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 3458c5a085d9..307f5cfa9ba4 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -264,10 +264,10 @@ crypto4xx_ctr_crypt(struct skcipher_request *req, bool encrypt)
 	 * overlow.
 	 */
 	if (counter + nblks < counter) {
-		struct skcipher_request *subreq = skcipher_request_ctx(req);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher.cipher);
 		int ret;
 
-		skcipher_request_set_tfm(subreq, ctx->sw_cipher.cipher);
+		skcipher_request_set_sync_tfm(subreq, ctx->sw_cipher.cipher);
 		skcipher_request_set_callback(subreq, req->base.flags,
 			NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -289,14 +289,14 @@ static int crypto4xx_sk_setup_fallback(struct crypto4xx_ctx *ctx,
 {
 	int rc;
 
-	crypto_skcipher_clear_flags(ctx->sw_cipher.cipher,
+	crypto_sync_skcipher_clear_flags(ctx->sw_cipher.cipher,
 				    CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(ctx->sw_cipher.cipher,
+	crypto_sync_skcipher_set_flags(ctx->sw_cipher.cipher,
 		crypto_skcipher_get_flags(cipher) & CRYPTO_TFM_REQ_MASK);
-	rc = crypto_skcipher_setkey(ctx->sw_cipher.cipher, key, keylen);
+	rc = crypto_sync_skcipher_setkey(ctx->sw_cipher.cipher, key, keylen);
 	crypto_skcipher_clear_flags(cipher, CRYPTO_TFM_RES_MASK);
 	crypto_skcipher_set_flags(cipher,
-		crypto_skcipher_get_flags(ctx->sw_cipher.cipher) &
+		crypto_sync_skcipher_get_flags(ctx->sw_cipher.cipher) &
 			CRYPTO_TFM_RES_MASK);
 
 	return rc;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 920bd5e720b2..3e7d24ff3fa6 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -965,15 +965,10 @@ static int crypto4xx_sk_init(struct crypto_skcipher *sk)
 
 	if (alg->base.cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
 		ctx->sw_cipher.cipher =
-			crypto_alloc_skcipher(alg->base.cra_name, 0,
-					      CRYPTO_ALG_NEED_FALLBACK |
-					      CRYPTO_ALG_ASYNC);
+			crypto_alloc_sync_skcipher(alg->base.cra_name, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(ctx->sw_cipher.cipher))
 			return PTR_ERR(ctx->sw_cipher.cipher);
-
-		crypto_skcipher_set_reqsize(sk,
-			sizeof(struct skcipher_request) + 32 +
-			crypto_skcipher_reqsize(ctx->sw_cipher.cipher));
 	}
 
 	amcc_alg = container_of(alg, struct crypto4xx_alg, alg.u.cipher);
@@ -992,7 +987,7 @@ static void crypto4xx_sk_exit(struct crypto_skcipher *sk)
 
 	crypto4xx_common_exit(ctx);
 	if (ctx->sw_cipher.cipher)
-		crypto_free_skcipher(ctx->sw_cipher.cipher);
+		crypto_free_sync_skcipher(ctx->sw_cipher.cipher);
 }
 
 static int crypto4xx_aead_init(struct crypto_aead *tfm)
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 18df695ca6b1..4ecc34fa8ebd 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -131,7 +131,7 @@ struct crypto4xx_ctx {
 	__le32 iv_nonce;
 	u32 sa_len;
 	union {
-		struct crypto_skcipher *cipher;
+		struct crypto_sync_skcipher *cipher;
 		struct crypto_aead *aead;
 	} sw_cipher;
 };
-- 
2.20.1

