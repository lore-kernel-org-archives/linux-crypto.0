Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0329C35247
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 19:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FA22051A
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 19:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ar+Dv/rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBCTFS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 14:05:18 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:33694 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgBCTFR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 14:05:17 -0500
Received: by mail-qv1-f65.google.com with SMTP id z3so7360647qvn.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Feb 2020 11:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hpGMGa/PI1PP+WC+wjiN2o66llJoPNYf7JDCErHl5Ac=;
        b=Ar+Dv/rrki4eBlZPjD23/sYW0Nu1yaQRnhMwqTojpoVsVtg6U+X/ztHlvYQp910EVY
         +xSagOPg2mRibKxjlPeQpsHmstHlbd+ynia84nOW0SdpMeW8pKv5Hiuul62Xqn0h2VnA
         TpZ/vuCHUFc9l0aWlHioX7gy9KWNm2OcGbkpOkaDOEp4g0ajs9OwP1OuS26somg8ssaL
         CKFggHKI/bQFQpZhnvqK+vyLcF6od7hwBVhB2+uLcWZk+7qUCBmOJJJ4WoZk1Xha0zpi
         5UxCedM/tATIk6RG8WLobqgX6TGgqKyh1K+KpOrF0Lty8cgfW2/tHb8XC87Cz+Dr489N
         /rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hpGMGa/PI1PP+WC+wjiN2o66llJoPNYf7JDCErHl5Ac=;
        b=jhF9Ms5dIVHLanFSYIKWyqkO6AiZYWuFQjz9dQSyFTVACEe8/Tlk2efqt4DLm7U3dz
         l3KEsIC1C7z3jrdhxQmxl7w693AMhewv6lS4jTAVm9LApeZZR1FwpMsJ1yeUrnlz4Cjc
         C3arOuJCCUGKWhgB0cNA+5n4aylKBqNRViSJqLxfwnuxHPJVs3DZazDIJZA3fD1br+pO
         A8dhroskDkypCEPvThyUUzZfiucn3q9mY2RSc7SmnSmBsimRZMx1pDGWaIgGBD1w4DtY
         g2NohaCJje2JN4apmAOtjSM0DWY1O/pve4RolgHJhw06KwlKhXUYjAu/ZhBqmK5YEnnY
         Qyjg==
X-Gm-Message-State: APjAAAXNIJZQK1iVGIsWQ4Ww+1uUIa1Kwss43SxiAYmNEQo/3XMp2xqT
        n+gyZmvQ6/HTla4wChVT377E51xD
X-Google-Smtp-Source: APXvYqwTuk5EjZo8FOvkjYUL/SPEIl8j1wuSadOIZtD7RApqVin/pr9ftaR3SDxYkUeUstyk65HPXg==
X-Received: by 2002:a05:6214:a08:: with SMTP id dw8mr24223847qvb.121.1580756716756;
        Mon, 03 Feb 2020 11:05:16 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id b30sm9680001qka.48.2020.02.03.11.05.15
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 11:05:16 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] crypto: qce - use AES fallback when len <= 512
Date:   Mon,  3 Feb 2020 16:04:55 -0300
Message-Id: <20200203165334.6185-3-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203165334.6185-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Process small blocks using the fallback cipher, as a workaround for an
observed failure (DMA-related, apparently) when computing the GCM ghash
key.  This brings a speed gain as well, since it avoids the latency of
using the hardware engine to process small blocks.

Using software for all 16-byte requests would be enough to make GCM
work, but to increase performance, a larger threshold would be better.
Measuring the performance of supported ciphers with openssl speed,
software matches hardware at around 768-1024 bytes.

Considering the 256-bit ciphers, software is 2-3 times faster than qce
at 256-bytes, 30% faster at 512, and about even at 768-bytes.  With
128-bit keys, the break-even point would be around 1024-bytes.

The threshold is being set a little lower, to 512 bytes, to balance the
cost in CPU usage.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 63ae75809cb7..b1b090349a80 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -166,15 +166,10 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	switch (IS_XTS(flags) ? keylen >> 1 : keylen) {
 	case AES_KEYSIZE_128:
 	case AES_KEYSIZE_256:
+		memcpy(ctx->enc_key, key, keylen);
 		break;
-	default:
-		goto fallback;
 	}
 
-	ctx->enc_keylen = keylen;
-	memcpy(ctx->enc_key, key, keylen);
-	return 0;
-fallback:
 	ret = crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
 	if (!ret)
 		ctx->enc_keylen = keylen;
@@ -224,8 +219,9 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
-	if (IS_AES(rctx->flags) && keylen != AES_KEYSIZE_128 &&
-	    keylen != AES_KEYSIZE_256) {
+	if (IS_AES(rctx->flags) &&
+	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
+	     || req->cryptlen <= 512)) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
