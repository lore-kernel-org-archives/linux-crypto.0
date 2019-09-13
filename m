Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1B0C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFB072084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORv8ERz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbfIMQXf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:23:35 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43448 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388221AbfIMQXf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 12:23:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id c19so27508018edy.10
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 09:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ohQE0si9snxRCMigJTreUpd2MR3/iIaRGRu9qae4I8Y=;
        b=ORv8ERz0dqgKdY+sDS3eaMliUhtXpbqtpFK6OaBD2n7hkfcpSSeooIqkucPFb7sH55
         AVeZTRDTDzTKbcb8Bh1CgbFg/oMAV+KE3/lx0m1m2u9SST3o837y74Rx2IAVeByZbl5f
         TYHH/xT2IxRGZUVn5teoF85BlUyvYwchwcyomPc3sX6RJ7rkYR/z8Ju8aPh5elb0Ltsj
         mryw9rim6G+KFkKJ0nwJbFsrIxKjdpI7KmXzHQTOqZn3CiL1Elf7AbG+fgggelUZupZl
         6D+Rn3yAovrJ2X8rADqDkkaULpvldkzPRyWLmRC2/3T8/mvQnzXcCuiTp1QZLHz2CFKV
         Lbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ohQE0si9snxRCMigJTreUpd2MR3/iIaRGRu9qae4I8Y=;
        b=Z8jPrKagXpSR+bHjY7edmp8onM7XXMcVVwjX7c/tpboYx6mpWwshNnNMA9fsfIJcIU
         7xhp3EFjixxNja9D02Yo+zRTI75pKemuaeQtNyqboxFCqxFYpqEvYta9gcgSS/G59bU8
         zTpUR+4RtTVUU5Hq7RMT4T3kMGjY0ikdqUFpgwd1RrVcwOMsHct4eSI+Nm5al1y3FG/f
         wJj/kcygoui3Z147MfHlLPWxebxZ/m+jKsJXld2dbV77Dbi8oNkdwJFdHTYKVmIlX5vr
         SHueD7X64PVXDG/zSZtUNSLtljI2ykoOKRPLc8jG8lAQAEJ6PrUIp7nKgWF/t5wSZ9td
         /pKQ==
X-Gm-Message-State: APjAAAWOd5AuKwnR0aNtQFwdeKBMHXrizP84yZ6OuahYzhCQVatgu7Rc
        3Ckiz6i5SQgRm3tqLo1bEf/nE5Vk
X-Google-Smtp-Source: APXvYqxmN+xrxfDepLNfhBOkX9eKyBj4bgSpQLl/dIr4zoxXcUC2KQuvGWfV66I7Gt+xuGuWoUswDg==
X-Received: by 2002:a50:f045:: with SMTP id u5mr4872709edl.297.1568391812750;
        Fri, 13 Sep 2019 09:23:32 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r18sm5497669edl.6.2019.09.13.09.23.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 09:23:31 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 1/3] crypto: inside-secure - Added support for basic SM3 ahash
Date:   Fri, 13 Sep 2019 17:20:36 +0200
Message-Id: <1568388038-1268-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568388038-1268-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568388038-1268-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the SM3 ahash algorithm

changes since v1:
- moved definition of CONTEXT_CONTROL_CRYPTO_ALG_SM3 (0x7) up above 0xf

changes since v2:
- allow compilation if CONFIG_CRYPTO_SM3 is not set

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  8 ++++
 drivers/crypto/inside-secure/safexcel_hash.c | 64 ++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5886bcd..826d1fb 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1176,6 +1176,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_chacha20,
 	&safexcel_alg_chachapoly,
 	&safexcel_alg_chachapoly_esp,
+	&safexcel_alg_sm3,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 282d59e..e2993b5 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -373,6 +373,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC128	(0x1 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SM3		(0x7 << 23)
 #define CONTEXT_CONTROL_CRYPTO_ALG_POLY1305	(0xf << 23)
 #define CONTEXT_CONTROL_INV_FR			(0x5 << 24)
 #define CONTEXT_CONTROL_INV_TR			(0x6 << 24)
@@ -663,6 +664,12 @@ enum safexcel_eip_version {
 /* Priority we use for advertising our algorithms */
 #define SAFEXCEL_CRA_PRIORITY		300
 
+/* SM3 digest result for zero length message */
+#define EIP197_SM3_ZEROM_HASH	"\x1A\xB2\x1D\x83\x55\xCF\xA1\x7F" \
+				"\x8E\x61\x19\x48\x31\xE8\x1A\x8F" \
+				"\x22\xBE\xC8\xC7\x28\xFE\xFB\x74" \
+				"\x7E\xD0\x35\xEB\x50\x82\xAA\x2B"
+
 /* EIP algorithm presence flags */
 enum safexcel_eip_algorithms {
 	SAFEXCEL_ALG_BC0      = BIT(5),
@@ -869,5 +876,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chacha20;
 extern struct safexcel_alg_template safexcel_alg_chachapoly;
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
+extern struct safexcel_alg_template safexcel_alg_sm3;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 0224779..873b774 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -10,6 +10,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/skcipher.h>
+#include <crypto/sm3.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
@@ -776,6 +777,14 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA512)
 			memcpy(areq->result, sha512_zero_message_hash,
 			       SHA512_DIGEST_SIZE);
+		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SM3) {
+			if (IS_ENABLED(CONFIG_CRYPTO_SM3))
+				memcpy(areq->result, sm3_zero_message_hash,
+				       SM3_DIGEST_SIZE);
+			else
+				memcpy(areq->result,
+				       EIP197_SM3_ZEROM_HASH, SM3_DIGEST_SIZE);
+		}
 
 		return 0;
 	} else if (unlikely(req->digest == CONTEXT_CONTROL_DIGEST_XCM &&
@@ -2221,3 +2230,58 @@ struct safexcel_alg_template safexcel_alg_cmac = {
 		},
 	},
 };
+
+static int safexcel_sm3_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
+	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+	req->state_sz = SM3_DIGEST_SIZE;
+	req->block_sz = SM3_BLOCK_SIZE;
+
+	return 0;
+}
+
+static int safexcel_sm3_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_sm3_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_sm3 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SM3,
+	.alg.ahash = {
+		.init = safexcel_sm3_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_sm3_digest,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = SM3_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "sm3",
+				.cra_driver_name = "safexcel-sm3",
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

