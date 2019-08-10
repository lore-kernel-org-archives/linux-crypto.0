Return-Path: <SRS0=QZ1D=WG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F111CC32751
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 09:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76972089E
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Aug 2019 09:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iy+v26NR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfHJJla (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Aug 2019 05:41:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41268 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfHJJla (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Aug 2019 05:41:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so97117533wrm.8
        for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2019 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pDwlcEgRHMP1A+eWN1ls3VEq1WPb0aAZmMnRS26btp0=;
        b=iy+v26NRzdcMasS+ielZ6t2ZRgVZqxgKuZUm+lNSRJkx/fwtoF+yZedxSzo3He7Tys
         gLZs4oAZOtlKp1LAqPi52bBRz4hxaeZfSBZy/4b1hQG4teBSAfwTT7qrlgU61he4I6n2
         gC4dM9F/IcE3V2dyeVFpIPo5kjIX/Gg9LDHiPZ9ZyCMm+PqtqYC87S9IjTUvbqxtaA7U
         vImOsFGwxxX3QoKc5cgxcB7gkbI+8ZRPL1S3b4CoBuAEkHIx8Skfs2c+7ubYPX60/FA+
         EQ5c5wrVHHZ13pNcpBd46PsIa6JvQ6WG/NUZQF7ViyD7vPkDlU3Vuq3RABzmPUyNBl2X
         MVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pDwlcEgRHMP1A+eWN1ls3VEq1WPb0aAZmMnRS26btp0=;
        b=RuUalREn1SgKkTY4vUVRfjwb+L3tPYr5aT4hp+8yv103DbckwT1qZTtrnA3Ud/gT18
         mFzXQST1AWNKrzgAYAmZtbJjP5Lv5k1twu6915yGt11ZmAed9/gkis+BFQplMQnyMkCV
         BUCTsX3vewAYFhnTYdk8AwlTFrBKSWNiIgTOAVhR7bdV+A3DMIu2DA7XTyCM36ELpHPh
         O9HWAl7HF9KIF2XaiugR/g8PkpcERjhP8Cf14EPBTQnaocgiFZ4hj20iLU487jAKo7vx
         a3Pmco2ZMvYecFzCsVEGTAGftRWTyuz8l2fvahjRuEgvbIHsomw9Aip5vdIMEne9pxzE
         UhRA==
X-Gm-Message-State: APjAAAWbU8YNjk1BNSjePlWt+1mmQocrPgIs4Oksx/j+cZEINEwTPsnU
        OfS5k+wCjR/jAbz00cnsCovLJPk8nARLAQ==
X-Google-Smtp-Source: APXvYqz0DtB6rsOsphVfLZ+N0o+A3Ho20CfcSQ33HM4jRLaGjsYL5y0vVCAWYKBmiTeQFUdkiopP6A==
X-Received: by 2002:adf:83c5:: with SMTP id 63mr520977wre.86.1565430088139;
        Sat, 10 Aug 2019 02:41:28 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id n16sm519883wmk.12.2019.08.10.02.41.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Aug 2019 02:41:27 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v9 7/7] md: dm-crypt: omit parsing of the encapsulated cipher
Date:   Sat, 10 Aug 2019 12:40:53 +0300
Message-Id: <20190810094053.7423-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Only the ESSIV IV generation mode used to use cc->cipher so it could
instantiate the bare cipher used to encrypt the IV. However, this is
now taken care of by the ESSIV template, and so no users of cc->cipher
remain. So remove it altogether.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 58 --------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d3f2634f41a8..e5ad3e596639 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -143,7 +143,6 @@ struct crypt_config {
 	struct task_struct *write_thread;
 	struct rb_root write_tree;
 
-	char *cipher;
 	char *cipher_string;
 	char *cipher_auth;
 	char *key_string;
@@ -2140,7 +2139,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 	kzfree(cc->key_string);
 	kzfree(cc->cipher_auth);
@@ -2221,52 +2219,6 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	return 0;
 }
 
-/*
- * Workaround to parse cipher algorithm from crypto API spec.
- * The cc->cipher is currently used only in ESSIV.
- * This should be probably done by crypto-api calls (once available...)
- */
-static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
-{
-	const char *alg_name = NULL;
-	char *start, *end;
-
-	if (crypt_integrity_aead(cc)) {
-		alg_name = crypto_tfm_alg_name(crypto_aead_tfm(any_tfm_aead(cc)));
-		if (!alg_name)
-			return -EINVAL;
-		if (crypt_integrity_hmac(cc)) {
-			alg_name = strchr(alg_name, ',');
-			if (!alg_name)
-				return -EINVAL;
-		}
-		alg_name++;
-	} else {
-		alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
-		if (!alg_name)
-			return -EINVAL;
-	}
-
-	start = strchr(alg_name, '(');
-	end = strchr(alg_name, ')');
-
-	if (!start && !end) {
-		cc->cipher = kstrdup(alg_name, GFP_KERNEL);
-		return cc->cipher ? 0 : -ENOMEM;
-	}
-
-	if (!start || !end || ++start >= end)
-		return -EINVAL;
-
-	cc->cipher = kzalloc(end - start + 1, GFP_KERNEL);
-	if (!cc->cipher)
-		return -ENOMEM;
-
-	strncpy(cc->cipher, start, end - start);
-
-	return 0;
-}
-
 /*
  * Workaround to parse HMAC algorithm from AEAD crypto API spec.
  * The HMAC is needed to calculate tag size (HMAC digest size).
@@ -2373,12 +2325,6 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	} else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
-	ret = crypt_ctr_blkdev_cipher(cc);
-	if (ret < 0) {
-		ti->error = "Cannot allocate cipher string";
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -2413,10 +2359,6 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 	}
 	cc->key_parts = cc->tfms_count;
 
-	cc->cipher = kstrdup(cipher, GFP_KERNEL);
-	if (!cc->cipher)
-		goto bad_mem;
-
 	chainmode = strsep(&tmp, "-");
 	*ivmode = strsep(&tmp, ":");
 	*ivopts = tmp;
-- 
2.17.1

