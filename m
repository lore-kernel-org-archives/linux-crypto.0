Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C778CC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A109020828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rjbJKmZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfF0K2Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41688 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF0K2P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so1903284wrm.8
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vL6L5hDUn9mhzlJsgchovHgAG3ROBqwVQK1Apo8D4Bw=;
        b=rjbJKmZaLfFvG68L2HeJd6+nxvTiSFwE2g5H7gZ6eXamIPreK2PdaFtkeBtxL+JLpD
         lp0oa3N8G966wEQvOo2DduyWYINH+Nnwzis5OH9LnLV2DzfWv6xOVFajOJqTbbTbztKS
         3YOYwdwqCR0S0RsurTF9cMKsgxCQVS6N8RiknP8V6MnVjEmanMMcpLoF6dkgBY7iz7On
         dLMhA9fdgF+Y66G8/7/zt5/MLbzQ7l8IHr3L2NzWbU5Vy9k0nsROBosGBXm1iFq0JbF1
         ouzVBDX+LvCKXGiYEfHgNG4Zc3RGUzYA8ZW0LQLLsTfnn7ZwpJZ/BSFndKstWkiWxx7J
         C1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vL6L5hDUn9mhzlJsgchovHgAG3ROBqwVQK1Apo8D4Bw=;
        b=tuUD7jAEiYeCM8L/quJH8IlUxHzopr9+zEboG1ywzPqT8kKlF/NQC5LyOv54uxQbjF
         ay+BVPR//2VqXvefEb8vC1nOXYwE3ciIMHviVFGvl4WCsm/6xsYSSDv+d1zIL1VdWLlC
         iH47HxvIqULMZSJCXkS50Gd2WvdGpkvdc56cZUpNoO29i8NlMUXNJswzCFUyjiUWmcTt
         Qkj7k3DN6SpXkFuH3lFp7gUfopR7W63VtjqVV38oHCm9UMdIxw9+kzLdtA8YkFw474wS
         HbIBE0Lj/QSgRBrrGhsUl7dJ2QH7P9D2n6IqJdeH9sBESYfcoWBKO3uu9SAiI5Qi1RwM
         oQpA==
X-Gm-Message-State: APjAAAVVGGSL/I7P8FUjc8LGKx+hnGn9toP1IWCyNx84/vVZRIAMYT4C
        H+DDiS2Yq+vlN1H9HC10jLvRRYGaXOU=
X-Google-Smtp-Source: APXvYqyalmXkQtuJ39ykrPKRX/aoncBEtoOiRjBhjnSgsdRkeeKd5m9lAA6XbXvMH4U7DinxACyxSQ==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr2737951wrp.312.1561631293493;
        Thu, 27 Jun 2019 03:28:13 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 21/32] crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
Date:   Thu, 27 Jun 2019 12:26:36 +0200
Message-Id: <20190627102647.2992-22-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/aes-neonbs-glue.c | 65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f43c9365b6a9..2f1aa199926c 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -9,8 +9,10 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/cbc.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
@@ -57,6 +59,11 @@ struct aesbs_xts_ctx {
 	struct crypto_cipher	*tweak_tfm;
 };
 
+struct aesbs_ctr_ctx {
+	struct aesbs_ctx	key;		/* must be first member */
+	struct crypto_aes_ctx	fallback;
+};
+
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
@@ -192,6 +199,25 @@ static void cbc_exit(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->enc_tfm);
 }
 
+static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
+				 unsigned int key_len)
+{
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
+	if (err)
+		return err;
+
+	ctx->key.rounds = 6 + key_len / 4;
+
+	kernel_neon_begin();
+	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
+	kernel_neon_end();
+
+	return 0;
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -234,6 +260,29 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+{
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned long flags;
+
+	/*
+	 * Temporarily disable interrupts to avoid races where
+	 * evicted when the CPU is interrupted to do something
+	 * else.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(&ctx->fallback, dst, src);
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
 static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
@@ -361,6 +410,22 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= aesbs_setkey,
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
+}, {
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-neonbs-sync",
+	.base.cra_priority	= 250 - 1,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aesbs_ctr_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.walksize		= 8 * AES_BLOCK_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= aesbs_ctr_setkey_sync,
+	.encrypt		= ctr_encrypt_sync,
+	.decrypt		= ctr_encrypt_sync,
 }, {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-neonbs",
-- 
2.20.1

