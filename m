Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586DBC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C0020656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wLh/8hue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfF0MEB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:04:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55106 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfF0MEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:04:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so5464548wme.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HMxEFfI7tJ6A3Lxij+jWi/muPaKRgiRph4XGCcI4O/0=;
        b=wLh/8hue28aVYJN153iWSXFQC6z6dcOhvOsueBxpfXF5HOwY3BY0gnAYHzKt3geR9l
         O+hoIGDVIwjeriTvdayL+YvO2oB1Ln6XnL25zjGAhv0E6WgMKaAdlp6SJ0PHetV7gweu
         tVhhxrmD5N1X62E4LMhotmz3YtlEjHo7fA6DtOJJI5c/SWq3EPKc+cZwlPRhuRvTGtqw
         BVJ0TeH7m7Hn/2yDcDW0wnFC9rvK93Rz6LD04UW+SIg35/cZaGc9adkRGC2bgYzKSZyw
         NxjyrE73ll2psaWlgrvJE/1OsUw0TQYJ6Pz/p/WbnhgD38O4YTJDdxjfH7QWEUhTLf1a
         mL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HMxEFfI7tJ6A3Lxij+jWi/muPaKRgiRph4XGCcI4O/0=;
        b=r78IHChlUyWif2e2Y+9z8ZSGgVBk8nVo0RAdlHazviLnkhyG054CPIh06mx6NJye7D
         qRlb4IxAxj9ynw3r/ACrSUs0yiZTM33rM34RBt8oG4Sg2zkwJglr65gvE2OKfPIzOXRV
         zV1Pzs03wP+PovkcCNKepBTw/Dp0Rv4yndnc/to87SsWqSbBcR2ctKT6knnNcOGmN4Bk
         fYJ6mvTeGeOdfWKyRZtAzYZJ7SxL4s2Uou6fqfuj+8XrJD2lM4icNCpdBTtFKTfTfQPD
         0bpkZ0iKI/wSj+k3mmRInl7wNEr/ilshJXTZZVFNUYVb+0GdDhX3WPQRzC39Dfo9fmZJ
         JFKw==
X-Gm-Message-State: APjAAAXGgNB0oc1xSnGUJnAaskozHUhJ94EXk77PVQ8Y+kL3XFmzGgMC
        CGMkUotsQagfNLeuUTw7sXWRl3M5Y8sDMA==
X-Google-Smtp-Source: APXvYqxCLtKCjeTDfxk84yIW4LXv8oBtB5qrhUAUF9YSWNPghrQOBSPxBVtO1IjgUUwgdSHDNNCHIg==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr2949860wmf.162.1561637037905;
        Thu, 27 Jun 2019 05:03:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 29/30] crypto: des - remove now unused __des3_ede_setkey()
Date:   Thu, 27 Jun 2019 14:03:13 +0200
Message-Id: <20190627120314.7197-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/des_generic.c | 13 -------------
 include/crypto/des.h |  3 ---
 2 files changed, 16 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 8669423886aa..201caf22b881 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -56,19 +56,6 @@ static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_decrypt(dctx, dst, src);
 }
 
-int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-		      unsigned int keylen)
-{
-	int err;
-
-	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	des_ekey(expkey, key);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__des3_ede_setkey);
-
 static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2c864a4e6707..7812b4331ae4 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -54,7 +54,4 @@ int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
 int des3_ede_expand_key(struct des3_ede_ctx *ctx, const u8 *key,
 			unsigned int keylen);
 
-extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-			     unsigned int keylen);
-
 #endif /* __CRYPTO_DES_H */
-- 
2.20.1

