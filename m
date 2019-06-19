Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DDAC31E5E
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 16:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31E222173E
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 16:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EAoaW4AJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFSQ3n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 12:29:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55274 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbfFSQ3n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 12:29:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so135721wme.4
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=EAoaW4AJtwYzR0GSJMkuDcwpafdzAu7jl5A+t5xvZR4112ONvsmNqibJfOI3NGcEk7
         qHhgz0H7aBwoUT3/39rfg08SCNQS+sfGpk7AIjIiGv236vZ2oCklAuqK5MsjiAIscMfE
         i1NaxcEZaZcELhSrDJ0PQRTwJseLlUeYeKvt0p18ZOwyG2ZjZvGCVN8mYr3UL7ycfIck
         2SOhi9PvwCPgINxUPlJv+02xvgyDoL91sYR8CMZjvXiC2O2CA2/co0XVVusc1jsH2AEA
         8ScEi8vVNNDg1fXU8OhEgPYFy+NJyaZMFqtU3uYDq+qeablmclQu+j1ZwJpnGSe+Nl78
         zoqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=fN3Zx0T062DTB6e0hfAf+vATBHQaFNJbdBTDcP3ct3+pB5E0we1+rdaNb8LbJhCbjS
         QI4aM4+q7O2Iveyb8Fn4NhFRoElbuaGyZoz8yPx/oX7FlFZRvhlJWyZcxY29sYSEnwfI
         hmT3uobRQ45OEFaD0OoQgJ8d2cvW2Nbm26Z/ZCcSVb7dscnqgvi3EaoS3JUUDl2d1Q1/
         oO33A7UEpZNNBhAhyVrhScq8PwcDXkI5SWswPNEqvKMv+TFs4j0g+YJkOun2C7x2NQX/
         1kdVFsTUMAiaZpBv/2u022IZFvUtILN2sopQ3fqu/bEX8TrqKGR6kyPUybSW2i30Sjvd
         Kx4Q==
X-Gm-Message-State: APjAAAXCx4X3qJ6+QL2XUfmFGaFtyIOFmYVEv+d5MNWIIqIEDfdxlFrA
        J2GtqhkxdHmp4NFq0oKcGjrHS9ONWRWndw==
X-Google-Smtp-Source: APXvYqw2jjjwulf7xeA4+oJ8X1buLnf1bbXZ7DJKVaJ79MdveT7YXSMVEvSo73r2mrbbQ+lNtYoBMA==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr8691854wmd.54.1560961780633;
        Wed, 19 Jun 2019 09:29:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id 32sm37815960wra.35.2019.06.19.09.29.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 09:29:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v3 3/6] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Wed, 19 Jun 2019 18:29:18 +0200
Message-Id: <20190619162921.12509-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 35 +++++++++-----------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..f001f1104cb5 100644
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
@@ -2434,6 +2426,20 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
 
+	if (crypt_integrity_aead(cc)) {
+		ret = crypt_ctr_auth_cipher(cc, cipher_api);
+		if (ret < 0) {
+			ti->error = "Invalid AEAD cipher spec";
+			return -ENOMEM;
+	       }
+	}
+
+	ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
+	if (ret < 0) {
+		ti->error = "Cannot allocate cipher string";
+		return -ENOMEM;
+	}
+
 	cc->key_parts = cc->tfms_count;
 
 	/* Allocate cipher */
@@ -2445,21 +2451,10 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 
 	/* Alloc AEAD, can be used only in new format. */
 	if (crypt_integrity_aead(cc)) {
-		ret = crypt_ctr_auth_cipher(cc, cipher_api);
-		if (ret < 0) {
-			ti->error = "Invalid AEAD cipher spec";
-			return -ENOMEM;
-		}
 		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
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
 
-- 
2.20.1

