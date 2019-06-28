Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573F4C5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 302F220665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QPAyy8U2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfF1Jfn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42094 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so5527168wrl.9
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eV01uQdPZTJ7/ilJN4hJbZST5nCOhRZhfQyfAGOz1ts=;
        b=QPAyy8U2Tg8zuxxtRQeYT2uu9rNCq2ozTlCwPWAqbsY3OgnQsRyRZMq+4hxgLb95y6
         xfQf6XRGgwT966h7LgX9J6WhRRggkECnCyWGr3Gpm3Vz3JR+6EK0fdG1E0mQCM1AFtNw
         OsF8xYxvWTNIzZGCyovR7IJbBsABwYTYUS2zgi823j2u9Gwbzd9jZv4iZ89ormk+2kZP
         2e3Hu96xDlWo0+YSPHUzk9ZnRdA4uLCvr0AdZ8SKzdv5nxfthn2/jTDwHchtzJNZKF51
         1pH1Xtes9M/1rqiFnS6Pi5elruX7/52psnde7tVwYhedAfui+Rpd1fGdFX8GK9HDdrXr
         h3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eV01uQdPZTJ7/ilJN4hJbZST5nCOhRZhfQyfAGOz1ts=;
        b=igcu+4ieCcwnGDrbfko5qaxZNM6WjYtOu9T9jPbLSz7Y9D+KI9dCpBvpIpOtlRBAcO
         7PF7bN0r6RVjz/U397rTlVoNtZfaGhPX9VDybWr1AIGeewUH5S9G/D8r+dy3HUWoUpNd
         fUuPRmEtE3HuUsFpi7dXu3Gzzu4/0Ya1xcxq260hvNYXyken15yvjqCyPGQYKD+M+9a9
         0sk2wPF65IolfW1138eSpOiq6sxn6tzCOlNYRg/JexbmETmNzIzGcCq0Qr5Lyx67V9/n
         8lX9fvIXgiV3w7A6unC1ybIj0QK16xKnriUyJoDwvJxhEzmwG8DT1hkTuA7CaY0l79Bp
         bn9Q==
X-Gm-Message-State: APjAAAXw2vrFg4cdGuuW+PfEPzGllqC1+v5/Ic2uMPy2JxOmIOkndQgW
        XYMhfrKz38Gfm9eQi/J4QNeE2/pjqYia2A==
X-Google-Smtp-Source: APXvYqx3w/Jrg25+X6n5kv7CJJE8HCj4sVFTW75Klx+tU3t6D8koOz5r9n5EKHHNaapM1i7Pb+nbmQ==
X-Received: by 2002:adf:ea8b:: with SMTP id s11mr597242wrm.100.1561714540531;
        Fri, 28 Jun 2019 02:35:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH v3 02/30] crypto: s390/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:01 +0200
Message-Id: <20190628093529.12281-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Acked-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/s390/crypto/des_s390.c | 25 +++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 1f9ab24dc048..5be891170a89 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -15,7 +15,7 @@
 #include <linux/crypto.h>
 #include <linux/fips.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <asm/cpacf.h>
 
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
@@ -34,27 +34,24 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
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
+static void crypto_des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cpacf_km(CPACF_KM_DEA, ctx->key, out, in, DES_BLOCK_SIZE);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -75,8 +72,8 @@ static struct crypto_alg des_alg = {
 			.cia_min_keysize	=	DES_KEY_SIZE,
 			.cia_max_keysize	=	DES_KEY_SIZE,
 			.cia_setkey		=	des_setkey,
-			.cia_encrypt		=	des_encrypt,
-			.cia_decrypt		=	des_decrypt,
+			.cia_encrypt		=	crypto_des_encrypt,
+			.cia_decrypt		=	crypto_des_decrypt,
 		}
 	}
 };
@@ -226,8 +223,8 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = __des3_verify_key(&tfm->crt_flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
 		return err;
 
 	memcpy(ctx->key, key, key_len);
-- 
2.20.1

