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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98C6C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAB52067B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DX5TIeWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390907AbfIIMNX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:13:23 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39603 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387508AbfIIMNW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:13:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id u6so12723301edq.6
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 05:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=089VsiYiGEk1TLSTordtGmSyfsQJywk4LVsX2jfTY8o=;
        b=DX5TIeWfnukrqKiM26LZswuQZw4/iM7RUFYcDO4qsAfFr2ezl86rL3wIVnW+AhMSvm
         k61dCvsElI29BU/MrjWGQsGAGQbOXPqDTrA9Wsy9JA7eoalZOm5POyDwyYy8ASLBva7X
         pG1WcCJEh3wBQCTJvTXs82i4w2pviVXWtZC8FQE3ncXVK5ppW/VM/+RsLfU0d7mtWBDJ
         P2pcebxw04T9miBbefZyU3qDucOydORXBF62ynZAz2V5JSiwUad/lYZhbIxgWhxix/Ou
         UHgSWQWS5JGyyquF26RrqGv5NhePOadLO6V7IsX74IvHWEZnKmevch2j0LxYw1WPG4vF
         2aVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=089VsiYiGEk1TLSTordtGmSyfsQJywk4LVsX2jfTY8o=;
        b=Kc6y/c5Bw6fq2j/NO4MnylgBqnYvHeqSpqc4WVu8mXS7tPDz7eqRPxpQCvO8AFDWp3
         OGKcd/rkupZyHl0I54ztCa7vKdT+fDNBbuDSHYf1dThqEYcrXaE29S56ulQb97tCbiJr
         WqPOj6ApcsF4Xy61RLXqbhv/GeowwC7eQSnpnARzD1XrrU0Q/214VHks9QYBy03xAKyA
         Q29trLgIe1F91O2hOiltZd+HS69clhHdRaBHo5aSZEDGeB5qd/ORGBEho/adhexfI+yd
         C5HBYTZFTpLMahvqxH8/BMnz24tooKeLrTt9de6ZWP/ElvKlJCdu8pxvCRcXan/EV5ax
         5F7Q==
X-Gm-Message-State: APjAAAVPnNIoxouJtRov6W8HZm4m1s9dFivSdQzTmLr4SCFdJrNQVIU/
        GMxTQQDtoAeHpWHvHuBcUsbnmENE
X-Google-Smtp-Source: APXvYqznqTS0FYEq6WHNhKDiXMgrNCOXqWPn0yX16Q6+SRgM/h60q6b8sVAlt08PIn2u3lZ20P8cLg==
X-Received: by 2002:a05:6402:8ce:: with SMTP id d14mr24115650edz.244.1568031200062;
        Mon, 09 Sep 2019 05:13:20 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 20sm1747238ejx.50.2019.09.09.05.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 05:13:19 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Added support for CRC32
Date:   Mon,  9 Sep 2019 13:10:29 +0200
Message-Id: <1568027429-26974-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the CRC32 "hash" algorithm

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |   1 +
 drivers/crypto/inside-secure/safexcel.h      |   2 +
 drivers/crypto/inside-secure/safexcel_hash.c | 115 +++++++++++++++++++++++++--
 3 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5d648ee..02851b9 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1009,6 +1009,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_xts_aes,
 	&safexcel_alg_gcm,
 	&safexcel_alg_ccm,
+	&safexcel_alg_crc32,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 1407804..bb98c93 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -324,6 +324,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_DIGEST_XCM		(0x2 << 21)
 #define CONTEXT_CONTROL_DIGEST_HMAC		(0x3 << 21)
 #define CONTEXT_CONTROL_CRYPTO_ALG_MD5		(0x0 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_CRC32	(0x0 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA1		(0x2 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA224	(0x4 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_SHA256	(0x3 << 23)
@@ -805,5 +806,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_xts_aes;
 extern struct safexcel_alg_template safexcel_alg_gcm;
 extern struct safexcel_alg_template safexcel_alg_ccm;
+extern struct safexcel_alg_template safexcel_alg_crc32;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 2effb6d..9d1e8cf 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -82,23 +82,31 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	u64 count = 0;
 
-	cdesc->control_data.control0 |= ctx->alg;
+	cdesc->control_data.control0 = ctx->alg;
 
 	/*
 	 * Copy the input digest if needed, and setup the context
 	 * fields. Do this now as we need it to setup the first command
 	 * descriptor.
 	 */
-	if (!req->processed) {
+	if (unlikely(req->digest == CONTEXT_CONTROL_DIGEST_XCM)) {
+		ctx->base.ctxr->data[0] = req->state[0];
+
+		cdesc->control_data.control0 |= req->digest |
+			CONTEXT_CONTROL_TYPE_HASH_OUT  |
+			CONTEXT_CONTROL_SIZE(4);
+
+		return;
+	} else if (!req->processed) {
 		/* First - and possibly only - block of basic hash only */
 		if (req->finish) {
-			cdesc->control_data.control0 |=
+			cdesc->control_data.control0 |= req->digest |
 				CONTEXT_CONTROL_TYPE_HASH_OUT |
 				CONTEXT_CONTROL_RESTART_HASH  |
 				/* ensure its not 0! */
 				CONTEXT_CONTROL_SIZE(1);
 		} else {
-			cdesc->control_data.control0 |=
+			cdesc->control_data.control0 |= req->digest |
 				CONTEXT_CONTROL_TYPE_HASH_OUT  |
 				CONTEXT_CONTROL_RESTART_HASH   |
 				CONTEXT_CONTROL_NO_FINISH_HASH |
@@ -238,8 +246,13 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 			return 1;
 		}
 
-		memcpy(areq->result, sreq->state,
-		       crypto_ahash_digestsize(ahash));
+		if (unlikely(sreq->digest == CONTEXT_CONTROL_DIGEST_XCM)) {
+			/* Undo final XOR with 0xffffffff ...*/
+			*(u32 *)areq->result = ~sreq->state[0];
+		} else {
+			memcpy(areq->result, sreq->state,
+			       crypto_ahash_digestsize(ahash));
+		}
 	}
 
 	cache_len = safexcel_queued_len(sreq);
@@ -599,7 +612,7 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 		     /* invalidate for HMAC continuation finish */
 		     (req->finish && (req->processed != req->block_sz)) ||
 		     /* invalidate for HMAC finish with odigest changed */
-		     (req->finish &&
+		     (req->finish && req->hmac &&
 		      memcmp(ctx->base.ctxr->data + (req->state_sz>>2),
 			     ctx->opad, req->state_sz))))
 			/*
@@ -693,6 +706,12 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			       SHA512_DIGEST_SIZE);
 
 		return 0;
+	} else if (unlikely(req->digest == CONTEXT_CONTROL_DIGEST_XCM &&
+			    ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5 &&
+			    req->len == sizeof(u32) && !areq->nbytes)) {
+		/* Zero length CRC32 */
+		memcpy(areq->result, ctx->ipad, sizeof(u32));
+		return 0;
 	} else if (unlikely(req->hmac &&
 			    (req->len == req->block_sz) &&
 			    !areq->nbytes)) {
@@ -1740,3 +1759,85 @@ struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 		},
 	},
 };
+
+static int safexcel_crc32_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret = safexcel_ahash_cra_init(tfm);
+
+	/* Default 'key' is all zeroes */
+	memset(ctx->ipad, 0, sizeof(u32));
+	return ret;
+}
+
+static int safexcel_crc32_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	/* Start from loaded key */
+	req->state[0]	= cpu_to_le32(~ctx->ipad[0]);
+	/* Set processed to non-zero to enable invalidation detection */
+	req->len	= sizeof(u32);
+	req->processed	= sizeof(u32);
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_CRC32;
+	req->digest = CONTEXT_CONTROL_DIGEST_XCM;
+	req->state_sz = sizeof(u32);
+	req->block_sz = sizeof(u32);
+
+	return 0;
+}
+
+static int safexcel_crc32_setkey(struct crypto_ahash *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+
+	if (keylen != sizeof(u32)) {
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->ipad, key, sizeof(u32));
+	return 0;
+}
+
+static int safexcel_crc32_digest(struct ahash_request *areq)
+{
+	return safexcel_crc32_init(areq) ?: safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_crc32 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = 0,
+	.alg.ahash = {
+		.init = safexcel_crc32_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_crc32_digest,
+		.setkey = safexcel_crc32_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = sizeof(u32),
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "crc32",
+				.cra_driver_name = "safexcel-crc32",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
+					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = 1,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_crc32_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
1.8.3.1

