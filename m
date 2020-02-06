Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8750DC35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5286120720
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKxRnbiq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBFVCr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 16:02:47 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42357 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFVCq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 16:02:46 -0500
Received: by mail-qt1-f194.google.com with SMTP id j5so198610qtq.9
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 13:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AoHCldDCQ5hCkP9X9bLOVxXvyjIh5qhSG0PvyC3sC/0=;
        b=kKxRnbiq9Y3dHC78ZGvl5uEmlSOeGZebUJyNtWo0GME7yZJ+18GGAjIRcl0SRE9ej4
         IN8QPGLfeuqGuHU0QGtrfZlgU6+F+/b/sgNppK2wd8fv827nH5PJi2+Xw9BS0c6kS3r4
         oiTR3gPhXtNCaqt8TpuqiUZNhQMvjuSsELIwxKlVLRyoBd0km1zbOtgYNBcdVAVvcEYE
         V/XrHb0hv7F+xSzhJ8hOey1p10dEnWPUn/d2mehhol8BkSU12m/sOnuj9vgxctwW/5Xf
         oAEjYFCVBaWuxWKu8HNkKZ3BNoPBeimJH+HqJTx9bnu/KuoyDxi/5wl/ZBr9RFozITCT
         9cJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AoHCldDCQ5hCkP9X9bLOVxXvyjIh5qhSG0PvyC3sC/0=;
        b=K82H/oKrBtDDK9ygD1JcjFM5wSR7JFqyQQsKoOcnlKrwYUyEwNeKaerQMZ21zNH/F9
         SYsJ8Nd5MCQn/bkORUqFZuO73/6UUp2lM50D1uwuSAlG2utHoMTcoIWnCpFkUtXF6cEn
         8CBF4q5PJYC1QQNj0JBNZ4mCOfKLl1Lv11LE691e86Nbplmmm5q6Qfs/vVZbTyO8+aQe
         760vIDEH2FR1tIZzc/KsOtK2scfDRPdRF43QQaO/fzR6UDYNLiq4NqYf2inKBddmzkk5
         PKVAJNDKhXofDiAZCJivS8muzi/B1wskrK7X7s3NEYezxnv++5zg+jK4inRjwrSXg8eM
         4UXg==
X-Gm-Message-State: APjAAAVzpWrygsYCFpgWxwyYGieNmYhVPudCuogo++8iefzCbKABstVT
        WaMNa5fXXBaTOGIKTG2yzaQNSPDp
X-Google-Smtp-Source: APXvYqw9HSNybSbCCsVCP1roB2+HVqZKG2UNueb4iD1EHAovQrd7bQOjUkn6wnvHZia1PVz+lRKM1g==
X-Received: by 2002:aed:218f:: with SMTP id l15mr4353654qtc.247.1581022965056;
        Thu, 06 Feb 2020 13:02:45 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id o12sm252869qke.79.2020.02.06.13.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 13:02:44 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v4 2/3] crypto: qce - use AES fallback for small requests
Date:   Thu,  6 Feb 2020 18:02:06 -0300
Message-Id: <20200206210207.21849-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206210207.21849-1-cotequeiroz@gmail.com>
References: <20200206210207.21849-1-cotequeiroz@gmail.com>
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
--

v3 -> v4:
Corrected a missing 'static' declaration of aes_sw_max_len

v2 -> v3:
Corrected style issues pointed out by checkpatch.pl

v1 -> v2:
Changed the threshold from a fixed number to a module parameter

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
index 63ae75809cb7..e55348bba36f 100644
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
 
+static unsigned int aes_sw_max_len = CONFIG_CRYPTO_DEV_QCE_SW_MAX_LEN;
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
