Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B447BC48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CBAA20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YO63AJYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfF0MDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44742 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0MDa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16so382533wrl.11
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKKvnKfAoojqb9qpbzog+67ExgqfuGGUR2Pd0cRpEHk=;
        b=YO63AJYr8M/E6foKiZqJWaQhhv0dOKiQrz+/PxMLvOsFBuFGX6x8rKPkTmKRXYq3TD
         Tr7t+JKNzZbXcUK6Lboj1K9SiiNr5DF5sqZx5qANPmnzk389Pg5FDgzgBYA5vhOkcaBs
         4cCuxVWZN+q4+IuNIGp52FFKTYkAV8GbgBxaC8rAhCKtlQDclin2Ku/jR6hJficiPlzM
         ZNnk88Bevawh2liPLq+dJfWB56VdjyY0yD9xCceqXa7k1MmXcPk3NX50IdAqEJ67qc7z
         XLM34Hrg/D+4Mxn+86ingG9Jvmpefl78H7uT+NIh0hys1ab+v5DVRW8qsNukwiXCSEU3
         HNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKKvnKfAoojqb9qpbzog+67ExgqfuGGUR2Pd0cRpEHk=;
        b=OQ9DbP+ycbXlQMSD9fLugi196qT5yDLWpbaRiMt+UX0wVXkOJd4kuDYizH+0vwL9no
         ahhlmBRKj3bFa4oCtWqbGaB18u3bZxTR8qwd4Te51TDypbI3Bngw6fO3/C2Fgh3Hcqjz
         dlyO4+zFTnaDSeKZ3G5RNYah83E9P4e7AWv6giD+X0iiKh9v9d0vJSX328vZgKHUGP0S
         0nbn+9VUCVDx5ApAc8IehlEdcea8fnKE0fLxSlw2+TrlGat16W+k4Bv76adFD06cWAHm
         RvepXcqopUq1apn5086o9Ymt9hLVa/G+PrPftOKhVDcFRUszvlZCMq/V903vnL/N0dbV
         76JA==
X-Gm-Message-State: APjAAAV9ms6hZigPONB0EBX58adYNHPhLf+4EaQzaOtdPpjU51R2pA/M
        Ac8bwG9WmIBhFGM2B+9cESgZ0j6mOPpW+g==
X-Google-Smtp-Source: APXvYqyY/slkL0B2CPlsLa3ciOR62CSwcjfAKS8425kaZ5mVBrAvwcUOVI6PhrDyF7oOE5tesqHU/Q==
X-Received: by 2002:a5d:4909:: with SMTP id x9mr2820836wrq.226.1561637008133;
        Thu, 27 Jun 2019 05:03:28 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:27 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH v2 02/30] crypto: s390/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:46 +0200
Message-Id: <20190627120314.7197-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Acked-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/s390/crypto/des_s390.c | 23 +++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 1f9ab24dc048..99edfb4907b5 100644
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
+	if (unlikely(err))
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
@@ -226,7 +223,7 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = __des3_verify_key(&tfm->crt_flags, key);
+	err = crypto_des3_ede_verify_key(tfm, key);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1

