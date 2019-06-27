Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2C5C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FED2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tankqLnd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfF0K2O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44978 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfF0K2O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so49818wrl.11
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5YAml7KVGLr/1+CAScarRaj3NSVjbEGTREd9Bd1Ltw=;
        b=tankqLndRYXGNmAVTZk/Pky4kvmRMq1n2DYXeBLsNcqN8AqdSHFpUqyTNDAsj1gmJ3
         wWsscDBDce7G71pfIaDJW2vj6uuiWnJY2MIR+1Bepvhl3DW0DrTSl0bbMYipl6osGYp+
         LTJCsAh2bRq+d8e4ZiXJMVqPAWn5EL1ELFMIEUVwCjfbhwBKXwfuFHbE7V7FUhEJyk0s
         vXzDL4pqqTOPyBpk4+1R/MkGDgHJ+3fPXQhhpeNyUmQ3J4ikBEEEcJNMDjgUGcsexVkM
         /KBbPTyzrel5SZaIo6rGgvSNbNI2hvOvvbRFzH9NoSCfenQFbucSdGO1BFOK7sa2BMAK
         wHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5YAml7KVGLr/1+CAScarRaj3NSVjbEGTREd9Bd1Ltw=;
        b=JeHCI9Q+hslh41z5JQJmwPxqpVf4P1qovPLrRuEQoX6/Nr2xj7LEucagOvgRHcqijB
         fxuV9u5tOcWpGHmcCVse1DNyj1XSsBztfUmunlnqAG2tqy5HN+30fBx1DRi9UwP0cynW
         fP3e24I+gfnF5G2dYiUo3jBIyvirdlpPG7DOQheXYwDUlya9wsAaa0nBRiv+armn2EKJ
         TSBKFA5P+bRSALgCxWYGsChDw9YKT1OeoBCSNUQnq86sugwl445wXytmHY9uHwllFekL
         QY8TCfp7ZqC4i8xDQ1XMRmgXoP2GiFV0QF6sud5WV3wFn/pbV69y9f3WWdTZG3LRhQkl
         Zmjw==
X-Gm-Message-State: APjAAAXJ673Gz9iBOnqS0O5TzcSU1KKY5kZJX5EaBmTQS/HZHrSMWsyn
        sWG2dK667J+8lkenxqxTFUwgRZDkYnc=
X-Google-Smtp-Source: APXvYqx188SwfUakScOuHGSaKgFqTOxv64jBsFy4YwWY8oiqRqv78wsSLxN9QPkFVWpdcq6tQTsfuA==
X-Received: by 2002:adf:a143:: with SMTP id r3mr95191wrr.236.1561631292517;
        Thu, 27 Jun 2019 03:28:12 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:11 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 20/32] crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
Date:   Thu, 27 Jun 2019 12:26:35 +0200
Message-Id: <20190627102647.2992-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AES in CTR mode is used by modes such as GCM and CCM, which are often
used in contexts where only synchronous ciphers are permitted. So
provide a synchronous version of ctr(aes) based on the existing code.
This requires a non-SIMD fallback to deal with invocations occurring
from a context where SIMD instructions may not be used. We have a
helper for this now in the AES library, so wire that up.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index e6da3e30018b..c3a78c5a5c35 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,8 +10,10 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/cpufeature.h>
@@ -289,6 +291,29 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+{
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned long flags;
+
+	/*
+	 * Temporarily disable interrupts to avoid races where
+	 * evicted when the CPU is interrupted to do something
+	 * else.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(ctx, dst, src);
+	local_irq_restore(flags);
+}
+
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	if (!crypto_simd_usable())
+		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
+
+	return ctr_encrypt(req);
+}
+
 static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -378,6 +403,21 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= ce_aes_setkey,
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
+}, {
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-ce-sync",
+	.base.cra_priority	= 300 - 1,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= ctr_encrypt_sync,
+	.decrypt		= ctr_encrypt_sync,
 }, {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-ce",
@@ -421,6 +461,9 @@ static int __init aes_init(void)
 		return err;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
+			continue;
+
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-- 
2.20.1

