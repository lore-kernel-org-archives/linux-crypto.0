Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2AEC2D0B1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E162A20661
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETzIl0pN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBFLl2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:41:28 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33835 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFLl2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 06:41:28 -0500
Received: by mail-qt1-f193.google.com with SMTP id h12so4219515qtu.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 03:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RV6csJ5l/G1lHrVZwqGYg+OyyuMCmV2DbhGWxCleJ+w=;
        b=ETzIl0pNIBjK31lAl6kxebpswrX3o6wx8QoIOhzh2LvMgwkvAmFMp20ZEr/bm9pSEr
         ke8cCmjLvi7/Ug37+p24EP5kUzOXz49V0VeiowxtuwO42NdSUkc1fw5St5vVXc/tRmA+
         43EpWmpDksF8qczPtHsORFferlK7do/lezUDFY1iTwbg3K+e7wnLISgelUBTD4X/+4+v
         TgFXsy/ZQouLGZlvq+8cMeU6ysk5b89hlFAywdxklCGgdRD7VdH/vigO/4WwemfEbpcW
         /hCgOUVFJRU0Dg9E7ptl+en8jqJ4GP7TaQrS5XVHy8rKMC6xm1OO/CmVUjGHdQrBO+aE
         WxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RV6csJ5l/G1lHrVZwqGYg+OyyuMCmV2DbhGWxCleJ+w=;
        b=J84txQBp8XXDdcAq0/5k98qyYMhMgouoXIy3Gt+ksM0x9ykCKc7gYr2D+4LxTRtj5y
         4karSZefr7fR4vf7iAd3dNJe9dUOkoPlRL+cNJYkSEZdu2OMDrO6HVnuUbbS+ICMlmu8
         dq0rkRBv89v0Wp5yvfRSTSFJ+m2t4DkUcNswzRNdv6JNbiSvlLrXL0cuGEJF8ZniIlTZ
         Xhigt9Q8cLFCUcGHsgtiQ8jV1rNz1/qi/4dcU3mC7jD4/H5FEQ8RqXek3Qnp/cg1v4WF
         emayk+5sJCcAU+6LDjMLXczNaJRjXP0m4XIWotEWCA0trjE42v7U3nWCf2+VfCSZ7sST
         Evvg==
X-Gm-Message-State: APjAAAWhs4U1MRtI9x8vXS9fbAJms36uZdzsKiiHJbVvvFX+1m0my0Dp
        NEaYz1R3hZk18a0fTPuOpQDdQdgD
X-Google-Smtp-Source: APXvYqzlLoJ6f4WAz70IXVKhDTXNbdB8Mf31r/TiBeZL5HjWw2nPepAKIkLUH6cjlWpNvmgK+iHL6g==
X-Received: by 2002:ac8:6e83:: with SMTP id c3mr2218816qtv.346.1580989286480;
        Thu, 06 Feb 2020 03:41:26 -0800 (PST)
Received: from gateway.troianet.com.br ([2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id g37sm1507283qte.60.2020.02.06.03.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:41:26 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v3 2/3] crypto: qce - use AES fallback for small requests
Date:   Thu,  6 Feb 2020 08:39:46 -0300
Message-Id: <20200206113947.31396-3-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200206012036.25614-1-cotequeiroz@gmail.com>
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

This adds the 'aes_sw_max_len' parameter, to set the largest request
length processed by the software fallback.  Its default is being set to
512 bytes, a little lower than the break-even point, to balance the cost
in CPU usage.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c2767ed54dfe..052d3ff7fb20 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -685,6 +685,29 @@ choice
 
 endchoice
 
+config CRYPTO_DEV_QCE_SW_MAX_LEN
+	int "Default maximum request size to use software for AES"
+	depends on CRYPTO_DEV_QCE && CRYPTO_DEV_QCE_SKCIPHER
+	default 512
+	help
+	  This sets the default maximum request size to perform AES requests
+	  using software instead of the crypto engine.  It can be changed by
+	  setting the aes_sw_max_len parameter.
+
+	  Small blocks are processed faster in software than hardware.
+	  Considering the 256-bit ciphers, software is 2-3 times faster than
+	  qce at 256-bytes, 30% faster at 512, and about even at 768-bytes.
+	  With 128-bit keys, the break-even point would be around 1024-bytes.
+
+	  The default is set a little lower, to 512 bytes, to balance the
+	  cost in CPU usage.  The minimum recommended setting is 16-bytes
+	  (1 AES block), since AES-GCM will fail if you set it lower.
+	  Setting this to zero will send all requests to the hardware.
+
+	  Note that 192-bit keys are not supported by the hardware and are
+	  always processed by the software fallback, and all DES requests
+	  are done by the hardware.
+
 config CRYPTO_DEV_QCOM_RNG
 	tristate "Qualcomm Random Number Generator Driver"
 	depends on ARCH_QCOM || COMPILE_TEST
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 63ae75809cb7..a3536495b6b0 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -5,6 +5,7 @@
 
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <crypto/aes.h>
 #include <crypto/internal/des.h>
@@ -12,6 +13,13 @@
 
 #include "cipher.h"
 
+unsigned int aes_sw_max_len = CONFIG_CRYPTO_DEV_QCE_SW_MAX_LEN;
+module_param(aes_sw_max_len, uint, 0644);
+MODULE_PARM_DESC(aes_sw_max_len,
+		 "Only use hardware for AES requests larger than this "
+		 "[0=always use hardware; anything <16 breaks AES-GCM; default="
+		 __stringify(CONFIG_CRYPTO_DEV_QCE_SOFT_THRESHOLD) "]");
+
 static LIST_HEAD(skcipher_algs);
 
 static void qce_skcipher_done(void *data)
@@ -166,15 +174,10 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
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
@@ -224,8 +227,9 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
-	if (IS_AES(rctx->flags) && keylen != AES_KEYSIZE_128 &&
-	    keylen != AES_KEYSIZE_256) {
+	if (IS_AES(rctx->flags) &&
+	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
+	     || req->cryptlen <= aes_sw_max_len)) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
