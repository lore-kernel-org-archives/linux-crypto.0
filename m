Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6E4C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D195E206A5
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEivIHVO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404803AbfIIMQE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:16:04 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32880 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391095AbfIIMQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:16:02 -0400
Received: by mail-ed1-f65.google.com with SMTP id o9so12779063edq.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 05:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WsMVygqBHKqObiKFhuGWzWU/88m8QMm3pr1+OK1sgaU=;
        b=rEivIHVOsInAtILPxOsu0yv9/dCmvAQZmyzLopbnCDmcj450UGeL1pnRkBentOMjER
         R85PmtTPALWobVJD2t/TYWo5G3WBET/pJ2AQuRh1gzXJt8pTwC/b/PkvUfs3wLP4DV/D
         Mb8jP6ABbM39qWQPyHoyKxEIiBQHp9U1ydQSf0xPjPiay1eJnXuJ/GIU5+L9PS8LwwJ5
         esG7RgFk0qHD+4RqLNQUBtnbiO/zQxmvaUFB2OUuvJcXKDplzFpI/cgLzPLHBDyikMT6
         VOKMG11+vL5u+/IJXHpAoiTBFAM1bcnHhYv681yWXUW837tTAJW0ALNO/Kad574qIsK8
         uDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WsMVygqBHKqObiKFhuGWzWU/88m8QMm3pr1+OK1sgaU=;
        b=G0h4RIRX1O4RU29JVqQ7RXfu5blHoyxiIPY3MJrfD5FCDzw7QKZJvwFiQ8O/qewHJv
         McP+WbTKs/5ZZfedQhhqqt2KeSj8xoLkgdJPI7K8uy8QOjzSfc0iNXPesAZwWXoF0BLa
         mQ5oxOqByjyZBJexgvDWF031lFqkV0IpB9pRhcEHGUr55mL3+QUQWPT7iqFueQ8EciFB
         XqT5LdRdWheIXBcGKlqAj9ZFRgDTRj731FfNCUdpCr2uForLr58h0t37XesMsj3xRZ/E
         dO0CFqxLEBsD8RrQgfV7rw8di0E0ZVHhA2UiB6gPvu9LVO5ir1Iw8WNDQxXccbk24cqw
         uyLw==
X-Gm-Message-State: APjAAAWBcTxM1X5khZvodQ7PLiEJ0zGwFyTv6+SHLMZuVvdXT4RLiCPx
        JjCSibi0L4Qjr9uZfk+yV2/KPhue
X-Google-Smtp-Source: APXvYqz8TxdCFzmPaZUcYSvYz/lAucTahJZJl0PJkvOeFS7MWxABBlinWhTPOwMIIyhno1ZzIWV54w==
X-Received: by 2002:a50:9734:: with SMTP id c49mr24220102edb.93.1568031359542;
        Mon, 09 Sep 2019 05:15:59 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id d24sm3001208edp.88.2019.09.09.05.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 05:15:59 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: inside-secure - Added support for the AES-CMAC ahash
Date:   Mon,  9 Sep 2019 13:13:08 +0200
Message-Id: <1568027588-31997-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568027588-31997-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568027588-31997-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the AES-CMAC authentication algorithm.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 99 ++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index bc8bd69..2e421f6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1012,6 +1012,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_crc32,
 	&safexcel_alg_cbcmac,
 	&safexcel_alg_xcbcmac,
+	&safexcel_alg_cmac,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 809d8d0..d76a4fa 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -809,5 +809,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_crc32;
 extern struct safexcel_alg_template safexcel_alg_cbcmac;
 extern struct safexcel_alg_template safexcel_alg_xcbcmac;
+extern struct safexcel_alg_template safexcel_alg_cmac;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 6576430..0224779 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2122,3 +2122,102 @@ struct safexcel_alg_template safexcel_alg_xcbcmac = {
 		},
 	},
 };
+
+static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+				unsigned int len)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct crypto_aes_ctx aes;
+	__be64 consts[4];
+	u64 _const[2];
+	u8 msb_mask, gfmask;
+	int ret, i;
+
+	ret = aes_expandkey(&aes, key, len);
+	if (ret) {
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
+	for (i = 0; i < len / sizeof(u32); i++)
+		ctx->ipad[i + 8] = cpu_to_be32(aes.key_enc[i]);
+
+	/* precompute the CMAC key material */
+	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
+				CRYPTO_TFM_REQ_MASK);
+	ret = crypto_cipher_setkey(ctx->kaes, key, len);
+	crypto_ahash_set_flags(tfm, crypto_cipher_get_flags(ctx->kaes) &
+			       CRYPTO_TFM_RES_MASK);
+	if (ret)
+		return ret;
+
+	/* code below borrowed from crypto/cmac.c */
+	/* encrypt the zero block */
+	memset(consts, 0, AES_BLOCK_SIZE);
+	crypto_cipher_encrypt_one(ctx->kaes, (u8 *)consts, (u8 *)consts);
+
+	gfmask = 0x87;
+	_const[0] = be64_to_cpu(consts[1]);
+	_const[1] = be64_to_cpu(consts[0]);
+
+	/* gf(2^128) multiply zero-ciphertext with u and u^2 */
+	for (i = 0; i < 4; i += 2) {
+		msb_mask = ((s64)_const[1] >> 63) & gfmask;
+		_const[1] = (_const[1] << 1) | (_const[0] >> 63);
+		_const[0] = (_const[0] << 1) ^ msb_mask;
+
+		consts[i + 0] = cpu_to_be64(_const[1]);
+		consts[i + 1] = cpu_to_be64(_const[0]);
+	}
+	/* end of code borrowed from crypto/cmac.c */
+
+	for (i = 0; i < 2 * AES_BLOCK_SIZE / sizeof(u32); i++)
+		ctx->ipad[i] = cpu_to_be32(((u32 *)consts)[i]);
+
+	if (len == AES_KEYSIZE_192) {
+		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
+		ctx->key_sz = AES_MAX_KEY_SIZE + 2 * AES_BLOCK_SIZE;
+	} else if (len == AES_KEYSIZE_256) {
+		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC256;
+		ctx->key_sz = AES_MAX_KEY_SIZE + 2 * AES_BLOCK_SIZE;
+	} else {
+		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC128;
+		ctx->key_sz = AES_MIN_KEY_SIZE + 2 * AES_BLOCK_SIZE;
+	}
+	ctx->cbcmac = false;
+
+	memzero_explicit(&aes, sizeof(aes));
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_cmac = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = 0,
+	.alg.ahash = {
+		.init = safexcel_cbcmac_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_cbcmac_digest,
+		.setkey = safexcel_cmac_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = AES_BLOCK_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "cmac(aes)",
+				.cra_driver_name = "safexcel-cmac-aes",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_xcbcmac_cra_init,
+				.cra_exit = safexcel_xcbcmac_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
1.8.3.1

