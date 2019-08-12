Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA30C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 14:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A9A20679
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 14:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HPd1I4Ug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfHLOx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:53:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54545 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfHLOx4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 10:53:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so12459356wme.4
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RPAXMF1cZCQBFyoO5A8Rg5Pyb4a0kwaVK9Utdlrc6bw=;
        b=HPd1I4UgBWiDtrDqP8Ibwq0bukCpSgD2COS1aF+OJautrHGb22YSz6iSzyREDD7/iU
         +8RHZSigttoAcV4j0A4x0NPM2Gc1eVLwnNdLZGqNXz7k55tir9Vfeebrn6byVb8fssmB
         aJt8sE3BGLbxRpw8XzNRSg9dwjt/faluQIM2oRa2YTLYpQS6yUF7c6TWGeMvQIOG6WV5
         EhxcX7W8sbfoE5+fOdz9xTut4arwIvhboa21yo1QN94hYf2Js7Mp8avqzVpvvz6GdP+H
         HmLGftm+HF6lDkAyS2bLhdetY9nz6kMccX0ZGOmYvwj1JHnX8dRCGCrcYIqn3rfqdROg
         RbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RPAXMF1cZCQBFyoO5A8Rg5Pyb4a0kwaVK9Utdlrc6bw=;
        b=TznfrOX0M7eHcyefRrJ1uEDm8Pgh7zPP9ObxZQ6AyhSP3eXft3/QIaDPzAnfrr8ETd
         XiLBrdg5DmBt5jF7qZ02dxH4x3/jOUEnwHm+ANMa30TnwcuBKbIQ6XJgAPBbemm4Mt3Q
         Eldi1rv1K+k+I9zf2BiloEQIRj4gOk7JC9ZDE/C0ZJpyxgyHyxthXiNn2i9vyPQU6M+o
         kB34oU8XCwfnwe9/CryTDw5E6cr8GNvnv1x7RQw20EyDZ5byYjYPDoqWMduojwUyqgZ5
         ge1fXEuq55vCKQNrKE1xeTDRbID0mmAtarg7p6DK5iZQUi982XoKEQzhEe3EkKi2TjGF
         3lXA==
X-Gm-Message-State: APjAAAWfun9/B/F6UFYg3qxXESGD7VTqWV8g0qHxHRWy5MekpiBvtqtI
        8RQeYeXuyz32Ru5Fuu4TMqoTgx33k7bVmA==
X-Google-Smtp-Source: APXvYqzsX9jGCzgbY3nph2SZ/NkCZDR8QVdOrP8Q0upsnGNRaqynD6WofTQaCwEM5IwdsBMfLcLCcQ==
X-Received: by 2002:a1c:760b:: with SMTP id r11mr28955527wmc.41.1565621634015;
        Mon, 12 Aug 2019 07:53:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:1c0e:f938:89a1:8e17])
        by smtp.gmail.com with ESMTPSA id k13sm23369190wro.97.2019.08.12.07.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 07:53:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v10 7/7] md: dm-crypt: omit parsing of the encapsulated cipher
Date:   Mon, 12 Aug 2019 17:53:24 +0300
Message-Id: <20190812145324.27090-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
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
index d44d24853aee..f87f6495652f 100644
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
@@ -2376,12 +2328,6 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
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
 
@@ -2416,10 +2362,6 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
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

