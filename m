Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8688EC10F0B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40B29214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrgDD4+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbfDRIR6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:17:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33516 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388287AbfDRIR5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 04:17:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id k1so636577wrw.0;
        Thu, 18 Apr 2019 01:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXzCrJpqf5sa36CDPY/H5+U5MbOo12IcOmxvO92eWy0=;
        b=rrgDD4+WJIyT8JuL7jpXNbKYuTuo0bd3FeuyJq2GlXSQ5EUs/XWVmDQRUQQRBKqERu
         TV67YsvyK4ZJpzh3VarJa7L12cRYwkrun/wvkFel0yElpqXMJHZufVQLcoEzbm4CaJR1
         yCEgc+CdnS2sff6bY2GEs9PAzprgiQZql0BiBQ6mt1FtGIoKX5CTEWwcLYnbom4MIm0m
         rLH7VlRMtxcjYHhe4JlH4Qts3EkBP178lfstvaiyzybJTUS7s8OSGBjwZ9aMxVZPpt4w
         mSkAQJ9GZSA2N5N38YYGt4GKCah3LBr2b465reI17/bR6/TknJ5jgvTRZxN1DW4RCXdU
         KTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXzCrJpqf5sa36CDPY/H5+U5MbOo12IcOmxvO92eWy0=;
        b=UcS99OWX3hk9CaEiqVgrcCieZY9TI3RoteCMxW4LGAQwfXwJ46oDz6LqJGBOVRsc4H
         CnYP8Bs7mv2a5BBUQcguiz4Aywy9Ghm5Z88Bc2Q8wqSUfa4e8TBn7Mm5ce9zM1HQ1JEv
         WUrfTuWIiJGHfoNdbY1/53+KJ/X78NlT44ix1DEWVYY+s8FJGlfWd23ENHSGPFrK7XXW
         6+RcCqIX9CS3JTzncP4hCNV+jQkY6Amlv8IDh0H9aR5GACZbZ5rgMXgy918A8xQLuW5c
         d/EhXb4xaYm6/A+2zdMbSdql3I8GV8xGNWxN1hb+h6Hy3ozH/N37j7I6YZxfiF1RHm6M
         K0Ng==
X-Gm-Message-State: APjAAAVO3cZGMCJKP2nvKP3Ma8CgTPiEM8nuwmzrNVelHjmB37WRoR0z
        sGhA6NFqt04Iwzf2xGDyn8OejF11
X-Google-Smtp-Source: APXvYqwOnGd4VaevTgxPHDrn61v0zQWOIqo/ZTOaWX/2T42/5ITjK92PwaUY00F3tTHS2xeASI8Wmw==
X-Received: by 2002:a5d:52ce:: with SMTP id r14mr6515750wrv.224.1555575473987;
        Thu, 18 Apr 2019 01:17:53 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w11sm2350619wre.15.2019.04.18.01.17.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 01:17:53 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        maxime.ripard@bootlin.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/4] crypto: sun4i-ss: fallback when length is not multiple of blocksize
Date:   Thu, 18 Apr 2019 10:17:35 +0200
Message-Id: <20190418081735.19002-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
References: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sun4i-ss does not handle requests when length are not a multiple of
blocksize.
This patch adds a fallback for that case.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 57 +++++++++++++++++++++--
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 17 +++++--
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +
 3 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 4b60f8fdd1c8..b060a0810934 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -129,6 +129,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	struct scatterlist *out_sg = areq->dst;
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct sun4i_ss_alg_template *algt;
 	u32 mode = ctx->mode;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
@@ -148,6 +150,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
+	bool need_fallback;
 
 	if (!areq->cryptlen)
 		return 0;
@@ -157,6 +160,10 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		return -EINVAL;
 	}
 
+	algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
+	if (areq->cryptlen % algt->alg.crypto.base.cra_blocksize)
+		need_fallback = true;
+
 	/*
 	 * if we have only SGs with size multiple of 4,
 	 * we can use the SS optimized function
@@ -172,9 +179,24 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		out_sg = sg_next(out_sg);
 	}
 
-	if (no_chunk == 1)
+	if (no_chunk == 1 && !need_fallback)
 		return sun4i_ss_opti_poll(areq);
 
+	if (need_fallback) {
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, op->fallback_tfm);
+		skcipher_request_set_sync_tfm(subreq, op->fallback_tfm);
+		skcipher_request_set_callback(subreq, areq->base.flags, NULL,
+					      NULL);
+		skcipher_request_set_crypt(subreq, areq->src, areq->dst,
+					   areq->cryptlen, areq->iv);
+		if (ctx->mode & SS_DECRYPTION)
+			err = crypto_skcipher_decrypt(subreq);
+		else
+			err = crypto_skcipher_encrypt(subreq);
+		skcipher_request_zero(subreq);
+		return err;
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -448,6 +470,7 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 {
 	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
 	struct sun4i_ss_alg_template *algt;
+	const char *name = crypto_tfm_alg_name(tfm);
 
 	memset(op, 0, sizeof(struct sun4i_tfm_ctx));
 
@@ -458,9 +481,22 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct sun4i_cipher_req_ctx));
 
+	op->fallback_tfm = crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(op->fallback_tfm)) {
+		dev_err(op->ss->dev, "ERROR: Cannot allocate fallback for %s %ld\n",
+			name, PTR_ERR(op->fallback_tfm));
+		return PTR_ERR(op->fallback_tfm);
+	}
+
 	return 0;
 }
 
+void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
+{
+	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	crypto_free_sync_skcipher(op->fallback_tfm);
+}
+
 /* check and set the AES key, prepare the mode to be used */
 int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
@@ -485,7 +521,11 @@ int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
-	return 0;
+
+	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(op->fallback_tfm, key, keylen);
 }
 
 /* check and set the DES key, prepare the mode to be used */
@@ -515,7 +555,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
-	return 0;
+
+	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(op->fallback_tfm, key, keylen);
 }
 
 /* check and set the 3DES key, prepare the mode to be used */
@@ -531,5 +575,10 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
-	return 0;
+
+	crypto_sync_skcipher_clear_flags(op->fallback_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(op->fallback_tfm, key, keylen);
+
 }
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 3d9c5ad6cbb8..a0ecfc8388a0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -92,11 +92,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "cbc-aes-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
@@ -112,11 +113,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "ecb-aes-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
@@ -133,11 +135,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "cbc-des-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
@@ -153,11 +156,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "ecb-des-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
@@ -174,11 +178,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "cbc-des3-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
@@ -194,10 +199,12 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 			.cra_driver_name = "ecb-des3-sun4i-ss",
 			.cra_priority = 300,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun4i_req_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 3,
 			.cra_init = sun4i_ss_cipher_init,
+			.cra_exit = sun4i_ss_cipher_exit,
 		}
 	}
 },
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index f3ac90692ac6..8c4ec9e93565 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -161,6 +161,7 @@ struct sun4i_tfm_ctx {
 	u32 keylen;
 	u32 keymode;
 	struct sun4i_ss_ctx *ss;
+	struct crypto_sync_skcipher *fallback_tfm;
 };
 
 struct sun4i_cipher_req_ctx {
@@ -203,6 +204,7 @@ int sun4i_ss_ecb_des3_encrypt(struct skcipher_request *areq);
 int sun4i_ss_ecb_des3_decrypt(struct skcipher_request *areq);
 
 int sun4i_ss_cipher_init(struct crypto_tfm *tfm);
+void sun4i_ss_cipher_exit(struct crypto_tfm *tfm);
 int sun4i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen);
 int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
-- 
2.21.0

