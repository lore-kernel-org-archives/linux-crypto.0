Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4CEC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 832EC2089C
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kGbzR475"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGBQsh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 12:48:37 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:46175 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfGBQsf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 12:48:35 -0400
Received: by mail-lf1-f54.google.com with SMTP id z15so11867764lfh.13
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=kGbzR475Fk1fnv5DaMFggiI54T2jNgT0VfoTwrbGvLoGWXuBb84+6vXzgRGOv3lHD3
         pFnmstTbfqpQ3r+5GGapEUM/AFpcxk1qkqCeD/hYJeQv1nXCsioGDiiz3vB+0qwkUf+x
         ymm9GqdyrQz69UDZoUR/o3Lg3cqzx2dd6s5sOcugMOF2FGSh7IWDv75ds/N4sd+iDJEq
         7Fd6DawFuubuNNR5DGCqGtRSre8yWN6EkF8UYPrGv0+ShfCwt2iUIDRn3/5YMvTHaUAf
         BueHb4O6F8TB4SWbLJtd55hq0gO6UOPrvWy3MG9jktf1tU9K5nqa5QkeFwkQWcwbLY9v
         bUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=dK9+dInT/K5KYzP57X6wpIEsHHDGxXCrdvmI/o0f24zLkvKW2xviGMsPP9I5HYU4z1
         Er9nzFs7t3Rul3R+5NQT1np6OvTu1vVKnXS1X1RGLEXaNMaQMrc617sTceM4O0fCmZmI
         944mdRASPAxmVbcpcwDk+Tgh8J9CHk+NxQ2UQ+aTHEFqxuw+LDCRqSvjjh/jc2AjXH8p
         eyoWTva3gmWK4NHIH96MslmNuPS+ihXg5OvucDXmCKUGXwz68a33WoeRtkx/8yOI0Qn0
         tRriQrFv7JoI+At55HV3nyaFAu0K+yD5DFPEGDUCLm3p4GZshbYXkFp6cTojoVakW1y2
         dDWg==
X-Gm-Message-State: APjAAAVxaKm++kK96aaUtzMmhGbkkIJigXbuAnDNKR2eyq16q6ac7IZ2
        uxPwieRjCMLGV46J1tWJieTTKUqgVeFJs2a7
X-Google-Smtp-Source: APXvYqxvEwu5ZUm3B0pwXGdK64Ks8SPUEVibo6YB2I56UF8Y/EAl21aBD/lQ9kQOnyQ9cDW+o6pjuw==
X-Received: by 2002:a19:41cc:: with SMTP id o195mr13813141lfa.166.1562086113634;
        Tue, 02 Jul 2019 09:48:33 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id r17sm3906055ljc.85.2019.07.02.09.48.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 09:48:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v7 3/7] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Tue,  2 Jul 2019 18:48:11 +0200
Message-Id: <20190702164815.6341-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702164815.6341-1-ard.biesheuvel@linaro.org>
References: <20190702164815.6341-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of allocating a crypto skcipher tfm 'foo' and attempting to
infer the encapsulated block cipher from the driver's 'name' field,
directly parse the string that we used to allocated the tfm. These
are always identical (unless the allocation failed, in which case
we bail anyway), but using the string allows us to use it in the
allocation, which is something we will need when switching to the
'essiv' crypto API template.

Reviewed-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 41 +++++++++-----------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..3c17d588f6db 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2321,25 +2321,17 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
  * The cc->cipher is currently used only in ESSIV.
  * This should be probably done by crypto-api calls (once available...)
  */
-static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
+static int crypt_ctr_blkdev_cipher(struct crypt_config *cc, char *alg_name)
 {
-	const char *alg_name = NULL;
 	char *start, *end;
 
 	if (crypt_integrity_aead(cc)) {
-		alg_name = crypto_tfm_alg_name(crypto_aead_tfm(any_tfm_aead(cc)));
-		if (!alg_name)
-			return -EINVAL;
 		if (crypt_integrity_hmac(cc)) {
 			alg_name = strchr(alg_name, ',');
 			if (!alg_name)
 				return -EINVAL;
 		}
 		alg_name++;
-	} else {
-		alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
-		if (!alg_name)
-			return -EINVAL;
 	}
 
 	start = strchr(alg_name, '(');
@@ -2434,32 +2426,35 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
 
-	cc->key_parts = cc->tfms_count;
-
-	/* Allocate cipher */
-	ret = crypt_alloc_tfms(cc, cipher_api);
-	if (ret < 0) {
-		ti->error = "Error allocating crypto tfm";
-		return ret;
-	}
-
 	/* Alloc AEAD, can be used only in new format. */
 	if (crypt_integrity_aead(cc)) {
 		ret = crypt_ctr_auth_cipher(cc, cipher_api);
 		if (ret < 0) {
 			ti->error = "Invalid AEAD cipher spec";
 			return -ENOMEM;
-		}
-		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
-	} else
-		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+	       }
+	}
 
-	ret = crypt_ctr_blkdev_cipher(cc);
+	ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Cannot allocate cipher string";
 		return -ENOMEM;
 	}
 
+	cc->key_parts = cc->tfms_count;
+
+	/* Allocate cipher */
+	ret = crypt_alloc_tfms(cc, cipher_api);
+	if (ret < 0) {
+		ti->error = "Error allocating crypto tfm";
+		return ret;
+	}
+
+	if (crypt_integrity_aead(cc))
+		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
+	else
+		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+
 	return 0;
 }
 
-- 
2.17.1

