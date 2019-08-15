Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4AFC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CAAD218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VcaU+n5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfHOJB3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37392 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730774AbfHOJB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so1597247wrt.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ODcjsTe5qXMA4WZkrKmlnC58iAmLOZMMRVocLXEZvzE=;
        b=VcaU+n5RpAF30HGVzg5qX7yBeDSBRiw6u9nrkKRw6HWgzWlFzEnHeJSyETvJ5lEkHp
         g1EEIooQdPq9I+jp3Id39fnyH5Lk7yrtCvLX+xA/OryirnlvSHvMW+lDPrnNXhpcNRHk
         Rbygt55ncquhe1aQn0izmdfcgXNZ/6wx6XJM618QD/FNZwlAYVDTm9ulRub1Eg84fUlu
         9WCewfW3ZP2a/5rivLVrY3D3ioy79LOnMDCvfdSlQQ8Ge/OKr8SDyQCBWlB7bOFnHV2n
         GsP26IgsFcoqyirG1cgDoGP/mlNzfkZIH4dzTpF0Mxmub1G8AjkR2aIZdeWgnJBkscu6
         4iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ODcjsTe5qXMA4WZkrKmlnC58iAmLOZMMRVocLXEZvzE=;
        b=KA5QOqfL/Y+293CpKyudcrWRHQMIQRZy2HlyfI70DaQf2h3cBACFint7TxppVkwNdI
         hjnD6EHHSU5DbmVFV4wec50NVSH2ERs+ig5jW+05cN1kyReVmiNdlKux1E42QrjOwUhJ
         8OCbPNHfEoeu3xNaAyZxqnHrmD6W2fXe2B/OjYnXh5Q5YAQmeiToCo+Z0HugqsLgm6Ko
         wGILdZIutfHwzFtK3MTlRpR1Vhl5Rx3foX0IpSXLsYcrPrvnWf0xn9NSAGBoFzMfW+LA
         Fj66h53t3VxqkslWk+D3JznR3yWPJQudlpiK8WphvwEGmbFtxL4/jTdVnq2eQR3CBcKP
         ORAg==
X-Gm-Message-State: APjAAAU4v6dIe06OCDY83C9sUi3CtGpNQG04jtsNHldo6NalXZQfmQ7W
        rSqwwKbnPHybKcI+45LyEZyBamEQ1eDdJR2r
X-Google-Smtp-Source: APXvYqySe4df8HiKgixP8T1219ys+AHQk2WqORhM5me9OyB621FAkzCRQrp2E7OxBFFLk3YE3MBA3g==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr4242015wrr.78.1565859687305;
        Thu, 15 Aug 2019 02:01:27 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 02/30] crypto: s390/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:44 +0300
Message-Id: <20190815090112.9377-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the refactored DES key verification routines. While at it,
rename the DES encrypt/decrypt routines so they will not conflict with
the DES library later on.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/s390/crypto/des_s390.c | 25 +++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 374b42fc7637..439b100c6f2e 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -16,7 +16,7 @@
 #include <linux/fips.h>
 #include <linux/mutex.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <asm/cpacf.h>
 
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
@@ -35,27 +35,24 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 		      unsigned int key_len)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	/* check for weak keys */
-	if (!des_ekey(tmp, key) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, key_len);
 	return 0;
 }
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void s390_des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cpacf_km(CPACF_KM_DEA, ctx->key, out, in, DES_BLOCK_SIZE);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void s390_des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -76,8 +73,8 @@ static struct crypto_alg des_alg = {
 			.cia_min_keysize	=	DES_KEY_SIZE,
 			.cia_max_keysize	=	DES_KEY_SIZE,
 			.cia_setkey		=	des_setkey,
-			.cia_encrypt		=	des_encrypt,
-			.cia_decrypt		=	des_decrypt,
+			.cia_encrypt		=	s390_des_encrypt,
+			.cia_decrypt		=	s390_des_decrypt,
 		}
 	}
 };
@@ -227,8 +224,8 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = __des3_verify_key(&tfm->crt_flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
 		return err;
 
 	memcpy(ctx->key, key, key_len);
-- 
2.17.1

