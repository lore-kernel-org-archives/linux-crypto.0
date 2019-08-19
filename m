Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8381FC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590A8206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+j7hV4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfHSOSS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:18:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50587 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHSOSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 10:18:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so1792316wml.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 07:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TmnznT0hptKHz4ZiqoCAURLmBmT8IKpbKUZOSS9EXts=;
        b=k+j7hV4F10gOP4bMJkudPvXJal9wc7ostfNWhX69nckFbpPExiJV7p4QjTKfjoFZQq
         pInlW7RUfZyQMvHKjQBFuxcEWIOBMoZjrddkAw5Z49QLLWyIyv4g9jWwqj+GsH8pVfDb
         zJK8mvK7ncMm/PNWGQmVvM4Py1h/LjalRpAsU3UZVXU2SqAACHlHumAFDpBMbrd7/K0K
         iXV99u5zT9fRxJuEl45V7tEB68zI+Ayb6xzlT/CXN6BxQvactcGb3N0AVQse7Lg0DWvG
         wn5U0pfe7/gud+eK//rnDgb/9kg1H9TMCNrVDArXHAOXbGj20DOsFpZ+3ZcpCIYf0UD5
         EN6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TmnznT0hptKHz4ZiqoCAURLmBmT8IKpbKUZOSS9EXts=;
        b=SpyMSlcZdF6cHOaLaonJrOoTlMLssbJ6vP7oBexHoNmxAf3iU0ocHuoksPcCywmVFi
         MCD/tJW7YRS6WH648UvezxNexmomc/DZKizu7DgRKSrhaWP0JxdK28Ze5jUjLBgWPIf2
         +ajZSwCsz0GspDIdI0w2kEDN+JV9KjeRtadfDG+XDkgxyH2ljOnWiF7WPy+ouBJ6qCG+
         FFyO/JMfD87VdLcaEiPgNx9YgDGhoii3wr3SS1q3XzOPRmTqDyvH3kDAgSO8Dm57PWgs
         zeBi+m3khOueRtcnEAaTz/goSSsjazWB8uRTTcf6hqZIk3leOs8cvflteN/KtMd38oav
         uYvA==
X-Gm-Message-State: APjAAAU3IbSb/Up+goJGgCNDZtWs3Hsz/PZeSN99OTX0vhEs84ueShdO
        eAmYQqUXA1cQAWWGk7Dr2qNPhkjQHe9RIQ==
X-Google-Smtp-Source: APXvYqxm4dAYSZtWJ/9uKMswwvikaruxT5nCAUBOTEXRHzwDMj/5FaK+RysVKFbVb1sMmEMW55L3FA==
X-Received: by 2002:a1c:f604:: with SMTP id w4mr4087230wmc.169.1566224296584;
        Mon, 19 Aug 2019 07:18:16 -0700 (PDT)
Received: from localhost.localdomain (11.172.185.81.rev.sfr.net. [81.185.172.11])
        by smtp.gmail.com with ESMTPSA id b26sm12693352wmj.14.2019.08.19.07.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:18:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v13 6/6] md: dm-crypt: omit parsing of the encapsulated cipher
Date:   Mon, 19 Aug 2019 17:17:38 +0300
Message-Id: <20190819141738.1231-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
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
index e3e6e111edfc..0dd1fb027ac0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -147,7 +147,6 @@ struct crypt_config {
 	struct task_struct *write_thread;
 	struct rb_root write_tree;
 
-	char *cipher;
 	char *cipher_string;
 	char *cipher_auth;
 	char *key_string;
@@ -2166,7 +2165,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 	kzfree(cc->key_string);
 	kzfree(cc->cipher_auth);
@@ -2247,52 +2245,6 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
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
@@ -2402,12 +2354,6 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
-	ret = crypt_ctr_blkdev_cipher(cc);
-	if (ret < 0) {
-		ti->error = "Cannot allocate cipher string";
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -2442,10 +2388,6 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
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

