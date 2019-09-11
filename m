Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC16EECDE28
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9376821928
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 08:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctMrYKUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfIKIoC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:44:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40487 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfIKIoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 04:44:01 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so19870830edm.7
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 01:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mMzoaFGeLettwkBbzKasgizTArXf2AsW9ZqWUb0iq3g=;
        b=ctMrYKUxakM4uztgilwfIqowXAFTmSTXWYUTtz5f9mt3DO75lw+hN08TlD6vytHEEQ
         /HTlfjPWnt0mNq71rgIooQWsiM3FwuZwBvOr2WXSyHK8Mtl87R/dXSgkXjLwS1TBfDwP
         /88H/LM0CJh2Lpp1TUxWUqBjXM2Jmf5NEXMz7bFJmgg5cDJax7+xB8yw4P5PsYFRyss/
         /UB12eusDeEtrm20U5mX0pubnPZ6jgit/a1TlzCU0KAdta1qYTpMaTuH5fXzmDOYyEAQ
         FMC89sh10RhBYpUmFbpZBLKlEx+ShkFxlBa/cJEevy8T6gtFsj6p3aPK8cH0qem/AQ6j
         Vsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mMzoaFGeLettwkBbzKasgizTArXf2AsW9ZqWUb0iq3g=;
        b=c+ao9sZ2iPalxyRihY1itssu4FyxFqtJSmlA7Xv5fuh6X/g/8BS7h/d0oO2xB4IkVd
         gLS9HEVZh3lo7BaQwLU0yZvrb6sWS6jrOvHvBpioruORqUsKYkG9+nFLHuk0Gdu5GMZY
         fbeNiaGo7OBH10Urjvs+MEZOwRSRwDl1syDPhelnE4CXbLlHTkoyULhevDA2UFpJOEl7
         W4yNDyjACJUJLfVMpXYoaxJWEdPdrxWSSt8jvtczFrtyRqa3TB6OF6MHUS4wVMkleYFY
         SKdIvO9NIC+KxxKnHh+hZHmBjT007VxuGWRDZ/G5V+D8UndjEZVcTeqhC3SA6DSIsATr
         pzOw==
X-Gm-Message-State: APjAAAXpkbLNgci/XheTB0oj5rRnDFIW+i4h1gklAzqsuL15ga5illFP
        DUG942cBmZIPxsevpQfAeWBSC5Q6
X-Google-Smtp-Source: APXvYqwGurUWViVOdcwMdbY8trA0DGhjDMmThXYZ7wEJ6MYedOmIRI1Ad7SIroKWEyI3fZpTFLrOgA==
X-Received: by 2002:a17:906:694:: with SMTP id u20mr25374149ejb.83.1568191440014;
        Wed, 11 Sep 2019 01:44:00 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h38sm207138edh.13.2019.09.11.01.43.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 01:43:59 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/3] crypto: inside-secure - Added support for HMAC-SM3 ahash
Date:   Wed, 11 Sep 2019 09:41:10 +0200
Message-Id: <1568187671-8540-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the hmac(sm3) ahash authentication algorithm

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 70 ++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 826d1fb..7d907d5 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1177,6 +1177,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_chachapoly,
 	&safexcel_alg_chachapoly_esp,
 	&safexcel_alg_sm3,
+	&safexcel_alg_hmac_sm3,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index fc2aba2..7ee09fe 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -871,5 +871,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chachapoly;
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
 extern struct safexcel_alg_template safexcel_alg_sm3;
+extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a4107bb..fdf4bcc 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2280,3 +2280,73 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
 		},
 	},
 };
+
+static int safexcel_hmac_sm3_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sm3",
+					SM3_DIGEST_SIZE);
+}
+
+static int safexcel_hmac_sm3_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	/* Start from ipad precompute */
+	memcpy(req->state, ctx->ipad, SM3_DIGEST_SIZE);
+	/* Already processed the key^ipad part now! */
+	req->len	= SM3_BLOCK_SIZE;
+	req->processed	= SM3_BLOCK_SIZE;
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
+	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+	req->state_sz = SM3_DIGEST_SIZE;
+	req->block_sz = SM3_BLOCK_SIZE;
+	req->hmac = true;
+
+	return 0;
+}
+
+static int safexcel_hmac_sm3_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_hmac_sm3_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SM3,
+	.alg.ahash = {
+		.init = safexcel_hmac_sm3_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_hmac_sm3_digest,
+		.setkey = safexcel_hmac_sm3_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = SM3_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "hmac(sm3)",
+				.cra_driver_name = "safexcel-hmac-sm3",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = SM3_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_ahash_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
1.8.3.1

