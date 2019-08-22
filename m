Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6732C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 11:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77F52339F
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 11:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqLb7HHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbfHVLti (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 07:49:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36636 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730980AbfHVLti (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 07:49:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so5125771wrt.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Aug 2019 04:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=AjwmZtrXILAuJl0MisviurMWlOnHSseE5n8f1/W3bps=;
        b=oqLb7HHp9p1SPqcVO11xuW5LGdUDJoCdGfUstKYoKubl3gnb0MDpg475SfBUuKHBtQ
         64zhSUuRqjrXtf5lLdnZ7xgATsLkcwW1w9fXm48PdfCChH2XGcbGv2ndGM+ZEPC92CPn
         PiLOuI6blVxtJE/AEA2vSmcK5JwwVWHph3aK96Nx7qNU6WjAYfP9XdWNckHktOFU5czh
         yix2j1A/raVb3CtOS019DGv7g15Brf/OOhx6DtCKpDuh7dS5eJy/2o6/pPzKMxNHdwWj
         26A2WNVCLkbqW4/RoaRmwStK72P+44tSFYmxFuPiiQIisQx/kq+SW7pzwaSHTmUMU6l1
         2y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AjwmZtrXILAuJl0MisviurMWlOnHSseE5n8f1/W3bps=;
        b=ouC5eoYf78ixdnakDNbWGFaw6A/b6MDJKHU+2oEEQ+Shij6+cgqxNtF8DttQCezgmc
         d4h1/fBakk112x5twKQwD3RygrJt2B1bIHXSgp6yMbgjxTXWlR42T+e2hl0sXlhlys93
         h6P99k8JLNdEFeopDZIstgj14GtkxAwHzRoAldztW5bCDsXGVLD5glEqBlvrrZSE9Xir
         4XgUAMAAlFvdsTAwalFx0traWdJbhd8Cg0Byq3SPaUMlO1E+GcVJZw3gLVUDiCBG6K34
         ke7DdCI7elKTRL0ApKnxNiRzhEL7jFHPQQ2TlPqCdmSMlBBjjqojvWywserbmSHQQkNp
         D7Nw==
X-Gm-Message-State: APjAAAXL+KmdXmSsPHui4kJSwZzM4o6oElpk6pIblHwlIrU3EpyaATYj
        eP+m45rVe25492HzNoNIf5DTNsnNehBUsQ==
X-Google-Smtp-Source: APXvYqz1M+j33mnkDqzO43W45DBHUU/8pCIzEXqM1ppFkBahtidpoRgbrtuTffBASCENPO/Ib2aFRA==
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr46203373wrx.100.1566474576613;
        Thu, 22 Aug 2019 04:49:36 -0700 (PDT)
Received: from mba13.lan (adsl-91.109.242.50.tellas.gr. [109.242.50.91])
        by smtp.gmail.com with ESMTPSA id 2sm5357051wmz.16.2019.08.22.04.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 04:49:35 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH cryptodev buildfix] crypto: n2/des - fix build breakage after DES updates
Date:   Thu, 22 Aug 2019 14:49:15 +0300
Message-Id: <20190822114915.5363-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix build breakage caused by the DES library refactor.

Fixes: d4b90dbc8578 ("crypto: n2/des - switch to new verification routines")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/n2_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 4765163df6be..63923cc33727 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -757,7 +757,8 @@ static int n2_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			 unsigned int keylen)
 {
-	struct n2_cipher_context *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
 	int err;
 
@@ -775,7 +776,8 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			  unsigned int keylen)
 {
-	struct n2_cipher_context *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
 	int err;
 
-- 
2.17.1

