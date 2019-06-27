Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CC4C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D57D2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cncw1z/5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF0MDr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38022 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfF0MDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so5396883wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oh1/+FMGZflC6/DL3pe6jxXhkPYRcs3ldpzq2tGNxco=;
        b=Cncw1z/5KJG2n52yi9NLffCPP8LW3dkFAn8f7GZXrSwKtH8qbQrV9FGNuh2TI2MFhd
         UAiiQksV6AnjMUXE7Cg78nceiP2HscxigSb2REn9ObbdYnLpygoo2ESfPrQVCf9FATiy
         ZOnl7CBYJn94IvpFqaEgNOgZ6hvG1eKNdL/3Qri/C5+O5tORKcSiW1jp8Q/F5aMFYtC7
         fMb3MQNGI3y+vciYpM0Ot9PPm2jqo8ygf/jpPOGPBjUYw6dVi2DoAhmxcaBnx5/SM03X
         tPTmn1t4roldIELIqJNXhBACGpjr9AylYgU40lNK3ccOSq5HOxw7dBrPqHoD3VYxrnPL
         Oxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oh1/+FMGZflC6/DL3pe6jxXhkPYRcs3ldpzq2tGNxco=;
        b=hdf80zw45hcV76vuZDoIzZH37zH+TeSbuoIKv6ZkD5C8SXxEMgkxVm8yHOHhkGGsfE
         MCVXRxoqHu6MZNS/6FtvFEDB0anGNs8jeIS/eK7TTUF9J7/czUnBKvPsw7KN/4tHfVGM
         12/TeOT6phWOOkY2N3yq+LkpV80LPvKUhTSQHqa1bs+G2PXk61xwbHbrVveXMZbCYEfZ
         eP3SXJ0dmMeT6vzRu/7Ua22EOS8cSlPNj8UNkdfJQ7W8fapZaq+kFUrnyVwULvwckcn1
         eppRBsp8iMNJAa2hBKTvS1HGsJwgm5HBND6aIQTg4++D7dnxnNwkMTj7LByhAsGdsnL5
         EGpw==
X-Gm-Message-State: APjAAAUqfCHhWabBkbgSwYlG3pUltmFreCAh37upg0K/fMmGXts8oebm
        p88dOsSIPARGX7Qv5vDAPkDknOou80gQvQ==
X-Google-Smtp-Source: APXvYqyyr08Z20ZTEG9HwxXwZgsWqha44S8ZJNC8A4v+j7ed0RjSQeL+sSchvrJWdZ4CsmKCfqK5Uw==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr2951521wmk.55.1561637024969;
        Thu, 27 Jun 2019 05:03:44 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 17/30] crypto: omap/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:01 +0200
Message-Id: <20190627120314.7197-18-ard.biesheuvel@linaro.org>
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
 drivers/crypto/omap-des.c | 25 ++++++--------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3d82d18ff810..103b3293c113 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -37,7 +37,7 @@
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
 
@@ -654,20 +654,13 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	/* Do we need to test against weak key? */
-	if (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (!ret) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -679,17 +672,13 @@ static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1

