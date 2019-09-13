Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA3C4CEC7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9031F2084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZpjJImf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfIMKNg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42120 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388088AbfIMKNg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:36 -0400
Received: by mail-ed1-f66.google.com with SMTP id y91so26539585ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CmIc6UlN0PHYLod1pZDVgf5X6GpL1A4Sgep2giuxe+I=;
        b=nZpjJImf9OuF6Fj3n909nJTSTT3mkmoyEtcXhXWlydFe1NEGxQ6jh5SRB4IQ5NPIo0
         Llnlc7m42paC+dEwxnIMCwGOQh3fKkTtpr2nEcOPe4DqcKXVkxmNyFdlF7wgpIu9Qbsa
         o1gL60Rq+IRTgBw6wlIVKsRnvl1nyuUTlS++GPt9wJl/MwrPwva7XxPgw56di0/92MDL
         hTVcB8H7ifbaCmSKLX+bovd22tlJwRQQ4AReK8Mn8EPonVm2bNIO2lHhxld9q0G3Zdip
         kiE6ZXtTnZWwPV6AgoT/NIPzUoThfY0XDm8yZ83DGh3eOvdNbxPAAy/jYPPkInAhVQDI
         9gNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CmIc6UlN0PHYLod1pZDVgf5X6GpL1A4Sgep2giuxe+I=;
        b=VlnWxBhNK+1vOMbxXaNEeWvVMgdJbdwjeV9xCrlfPUdtqKniY0SFS7IcKLuYeUr+Is
         Igbcd8BhjJGn8xPrFt6bYU/fxtFVIXkRwFfCspvoEIlhVTd/itO3uLcq5CbUr6W23Glz
         hjuykTK0jk3mGi0Vpi4Eqz/c6d27AZIM1q3QRp89PoDH0omvGSiBFtwm7/xLwBadLpEI
         P4xPc4RAFKFFJW/H5IXLheYeZKy6S45hOP/gr6ztvbbwleXW0ckbdfAly4EWAkgQlP38
         sY8tyAoTk+EFA8WbL1r1rvbe0lFFGZW1/vknOJxgBTjTCEIXSIvUJuHfP+YBMvBoeHny
         aqhw==
X-Gm-Message-State: APjAAAU6nc6MhJD77U+Zc9VpK+25Sw9/HQDDKYEFzyzchsondLVs7KI4
        Cot8gGxXH24cpNMlCCfaKnMv+Z5n
X-Google-Smtp-Source: APXvYqwfDZ2UxW7VuHiYjKgxxHUXKyBwPIAd/nY0oeGOqW1sye/Yn63L/xehxie2oZkUUUNg26WgPQ==
X-Received: by 2002:a17:906:1903:: with SMTP id a3mr37883535eje.112.1568369614667;
        Fri, 13 Sep 2019 03:13:34 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 6/7] crypto: inside-secure - Add support for the rfc3685(ctr(sm4)) skcipher
Date:   Fri, 13 Sep 2019 11:10:41 +0200
Message-Id: <1568365842-19905-7-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in (32 bit) CTR mode, i.e. skcipher
rfc3686(ctr(sm4)).

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 51 ++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 1679b41..7da4801 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1182,6 +1182,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_cbc_sm4,
 	&safexcel_alg_ofb_sm4,
 	&safexcel_alg_cfb_sm4,
+	&safexcel_alg_ctr_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index db9bc80..0cf4c87 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -877,5 +877,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
+extern struct safexcel_alg_template safexcel_alg_ctr_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 1d8aca2..b14984b3 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2828,3 +2828,54 @@ struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4ctr_setkey(struct crypto_skcipher *ctfm,
+					   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* last 4 bytes of key are the nonce! */
+	ctx->nonce = *(u32 *)(key + len - CTR_RFC3686_NONCE_SIZE);
+	/* exclude the nonce here */
+	len -= CTR_RFC3686_NONCE_SIZE;
+
+	return safexcel_skcipher_sm4_setkey(ctfm, key, len);
+}
+
+static int safexcel_skcipher_sm4_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ctr_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_SM4,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_sm4ctr_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		/* Add nonce size */
+		.min_keysize = SM4_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.max_keysize = SM4_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.ivsize = CTR_RFC3686_IV_SIZE,
+		.base = {
+			.cra_name = "rfc3686(ctr(sm4))",
+			.cra_driver_name = "safexcel-ctr-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_ctr_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

