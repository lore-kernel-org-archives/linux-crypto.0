Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C23C31E5D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 21:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9972082C
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 21:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DpMBBmk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfFRV2L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 17:28:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35194 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbfFRV2K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 17:28:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so1077590wrv.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 14:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GeHdLEIiKMp7/1v0iGs3g+X9QZKIHHe69xTr11ESOuo=;
        b=DpMBBmk2kGfOoo1UtTp/w94N831+KzjoBk3fn3kDgIehYo2zHzDHet8G50UyVgSnkj
         Ri7viZOAMYnfQlbiBROYFUGsC8zcCtmfXSojqaDC9MzX4vaRpw5QI1V7asBop9WLTO2j
         wsEA2nLW8zhKKaQAAQWnZVPMSfYDBaz3KDsD9NkzSLcwkCl3/rCc5C0YcN0DwoBmkVkU
         TocNSZisIrDSrXt8tigpeHNZ1KIumRySoF5YEILpwiYVKrvvJfFabZyDI3kUKVvF60am
         48ebFFYnCX04XSgYR/7FBhetbNqG9K2Xiw996Fh3tdv1+8ayMXQ/loeD4ES2iuwF1b0F
         FXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GeHdLEIiKMp7/1v0iGs3g+X9QZKIHHe69xTr11ESOuo=;
        b=c5qvrZSiPdrIDpjwQuNP4DNeF++c0+j5qSpMceylaj1cqhouJPmaD9pdQKReyjY454
         HQG5yAmHg3GKHQ2HlpeLPmeNNJh+rlNHUGl/8NZZL28y3nW8UoWHUmRx71w0LNsRrUjF
         PojnB1leCip/74d11DZ5iGtvqjoiIt6t6kp61p0BZrl23xZT7KsVqwBwg/ifJbgKP9S7
         N2qCUFh0A0LxApOmCTuWVLfmYOODj9zHm1kMrwRErFu4grRE/UvOMHc8qtcErfU4Wc+4
         yEH2omSkcjKEGHUWep/MyLpLrJiMMqWTAtB6+vxw/D8RmzNuZvGaQ+xhBW6Ql4HSmNRE
         ks9g==
X-Gm-Message-State: APjAAAV8JGQ8j1sBs4h3vARdcROQiQKnfqniRWsRMWBCKjnQdmK0R2L2
        TIL3XDmKo9J4SqUaFXHlV454YJcNHjvV3viw
X-Google-Smtp-Source: APXvYqxw7UtM436v978g3jeSFj/x7lOOzeXSI5X74pZs1sDQQWNG7T4gqKgGZltyMUJ60Fow0hMRCQ==
X-Received: by 2002:adf:e88e:: with SMTP id d14mr4948391wrm.189.1560893288980;
        Tue, 18 Jun 2019 14:28:08 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id h21sm2273831wmb.47.2019.06.18.14.28.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 14:28:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 3/4] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Tue, 18 Jun 2019 23:27:48 +0200
Message-Id: <20190618212749.8995-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
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
2.17.1

