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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6C7C35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B992082E
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PH+MhRUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBFBVR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 20:21:17 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43904 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBFBVQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 20:21:16 -0500
Received: by mail-qt1-f194.google.com with SMTP id d18so3223219qtj.10
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2020 17:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9EEloNQL6eZ3dm91bJ9GK6LSsi6Ei6R6xgKjvhZ/fg=;
        b=PH+MhRUg4SpXTAVHjTDnJGaiGNnOivSq0kOv2J4x46mYknS+BNueX8vC4YmmsHcpXe
         uRAgAoVILZ/HOy6fvup5LjMWTzcmUMqZFnxBArc55xX0QcURDTXGM+bGYz4SF6wSvajU
         IY/9ui3wV8lkamZg2yxz9j2uilLnPZn01tykcacppipNXzXTDFl99u372FLt53iZmLFp
         67EYNwoXoebOzaZIEQv/dWoP+C/ofVcw1vdrdLQ+lg+IJNmLEma9myeCo15eFW7LxWL1
         JeIHMJ3nyQ/W2kC5CFSzZbbi3kEFgO5qQG82xZLN2OSo1bQyksWtpmZFQjnx5a99tGA/
         6eIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9EEloNQL6eZ3dm91bJ9GK6LSsi6Ei6R6xgKjvhZ/fg=;
        b=H2KhXvEewyjo18b8uKL3DEzN7BKMhFc3/HGEPpr7TbuR/+ZAyl1qrhLpp6b2pFCDw3
         Z/L7/Yf2jwUOXQ/Ol4h0VgeWsR4sjvHyGmyemBHmviU/X2LHreMxlt2dl7hRYXjiSeDU
         3T33KJZbQmZblYefBN8sGZZKwATSo2xIeBJ82/KFV/Gu4KPJHWxn6ax6PewWxMrY3jm4
         mv8ziWYBmoXXf1QoRQ3krFlVDfbKPJEyp+1kF27kpWFNmFSZMT+pzchTGOheCrkEA+6k
         pWLhv+WQC9nTNt/svOGoYHlDYyjwmc2YrhmwUROHBf7NUpe9U25kwim0pItoT7WWh9gs
         dMPw==
X-Gm-Message-State: APjAAAXKFSYLvcgcsg8lWnEhMgQalrdHAeAsLQXz0P0OCk33SpZwn7J0
        ORiiHK0R+bINr4DtJAmqwFrmc2eY
X-Google-Smtp-Source: APXvYqyBxbj7mn7KmTYGUKaMuMMGMBq7Paz599jWEL25SGeXSEp6mxiB/6PDX6j64PDbG1itlWjp9g==
X-Received: by 2002:ac8:6b98:: with SMTP id z24mr547718qts.392.1580952074932;
        Wed, 05 Feb 2020 17:21:14 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c18sm719729qkk.5.2020.02.05.17.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 17:21:14 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v2 2/3] crypto: qce - use AES fallback for small requests
Date:   Wed,  5 Feb 2020 22:20:35 -0300
Message-Id: <20200206012036.25614-3-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
 <20200206012036.25614-1-cotequeiroz@gmail.com>
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

crypto: qce - add aes_sw_max_len parameter

This adds the AES fallback threshold as a parameter, so it can be
changed by the user.

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
+		 __stringify(CONFIG_CRYPTO_DEV_QCE_SOFT_THRESHOLD)"]");
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
