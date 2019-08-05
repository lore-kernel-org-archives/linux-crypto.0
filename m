Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A21C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D20B216B7
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MpFng02s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfHERCN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34948 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so73683078wmg.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NxKnA7gsQLuCY7H7UCMT6enaWZhoSvhIsSc6hz2ZNrs=;
        b=MpFng02sBM6hGzSgB7Y5yMNXl4UkHWRQzNsRSmyvKzTzvUnC4j+hlkP6nSe5Wan7im
         7kipmhit65iJfi7tOXsDVEJkaoDnvXOy6GdOKWviYXEdG84K0yEx+E3T4gRKXVhTgRzw
         Yr6fOFimUwXXJSDg/KCX3v1HE++SxfbHMmWbzbVXuQlNmoGeK0xnlPDqM9lbBHjHkelW
         xGMCKUEQsjYOuKIX94igrE6QOXqPCb7bpPBsCNYSdyjLlllzmMCSFn5L66LdJfikuy6d
         S1IPuLGVo2D1aKzr40YQa9PU2JipoQecuhSqJ0W2uY3KGSrfC2i7xI5kia/iCsnNp1Zy
         TbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NxKnA7gsQLuCY7H7UCMT6enaWZhoSvhIsSc6hz2ZNrs=;
        b=tgVLSosm5suey/diEz/azs1uN7wnEK5sE8nBBjSKHvHZmwVuQmr1/gONZLviDzQHEI
         OEp1VPLi4f30Qc+HLgSDg5wzzZgdqM1FG0TJ7rxI5hzBDQ8MNxv+YzYfOC8dWM1kJTp2
         b5ae1EWiG2Jp9B0Oa+JjE2pVRm4Wuq+F4JWZafjx0g7YP+hSuTJbGd0jNYy8cNnDQTJL
         Cs/lcXy38PhqFFRzCy/6mFvklELUrl38M93QHI20+7KgqFA5Bnt2sB5HEY5j1oQfqUa3
         SSXju24oX25Ot86SC6Opdyemy6anUSnny5WVOrdWn5hr/c82U8+6CMUmuGprCsWrvB0a
         x01A==
X-Gm-Message-State: APjAAAV4L3VjrJ80K6DmHRMJxBZTki5x4+psmbwhRKM+rapdrPxLEjtr
        XJZ3mLbSlFX08kHhEpLkLn+2SZ9H8QIqUA==
X-Google-Smtp-Source: APXvYqwNHOgUWxdtDseDI4dcCWc9VdSppTmjlHsyVJtpJojQ/ZGZ4/jKpZy4seDyDUnZNv7l9SyGyQ==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr19470917wmi.91.1565024531061;
        Mon, 05 Aug 2019 10:02:11 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 22/30] crypto: sun4i/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:29 +0300
Message-Id: <20190805170037.31330-23-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 26 +++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 6f7cbf6c2b55..1f2557809fa5 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -542,25 +542,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
-	struct sun4i_ss_ctx *ss = op->ss;
-	u32 flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (unlikely(keylen != DES_KEY_SIZE)) {
-		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	flags = crypto_skcipher_get_flags(tfm);
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		dev_dbg(ss->dev, "Weak key %u\n", keylen);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
+	if (err)
+		return err;
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
@@ -578,8 +564,8 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = des3_verify_key(tfm, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key);
+	if (err)
 		return err;
 
 	op->keylen = keylen;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8654d48aedc0..35a27a7145f8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -29,7 +29,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 
-- 
2.17.1

