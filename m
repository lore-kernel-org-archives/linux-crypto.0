Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AA5C5ACAE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7526D206CD
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzgg3Qmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbfILKNF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:13:05 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:38907 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730936AbfILKNE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 06:13:04 -0400
Received: by mail-ed1-f47.google.com with SMTP id a23so21201045edv.5
        for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2019 03:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4CMpHJaZuSF7AQ7YslQwUV2u9lqwDF6dkvSOWcYKXh4=;
        b=bzgg3QmoJIwYh/4AE75jhgBgJaH85CUk1biXqRMsIkjbPsa5aYn5DNjB9Q9Z82Sjzr
         aZSIgEuID2o47tgIPGwNzlGjwSt4FjO5wkWaAoSRvXXH0jTRjeuH5hm31SNt5bB9l7BY
         PkPBjequRRtbjxrRNcecPeg+OTb1NynC39HSX9o8VEuID8yojseGMGFHjiGNLUkgLb1y
         MEVWd0EC7dcMBI0HJGCovfIBA7nNppbkORgu/AWnbqre8WmQO7zpw6AByo0iN9FNEKoZ
         JmDn18yGYs/zwhvEnm2P07qdGkmEhvQ6QiplYTPC1fOvIg1e2Cm+tRIRas6nEQzf1TF6
         KlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4CMpHJaZuSF7AQ7YslQwUV2u9lqwDF6dkvSOWcYKXh4=;
        b=lVo88GkuVomSgzesFcQQTqN6DKX0UGIg66mpWMPthjdNpe+MUNsBvBM1+scPJnanHa
         7M8FMQVlGV/3cBCKZ5sS4d8fVlYdPKvC+N5VuxJlkfxWV6wP2MrafZMNTHYO+ewCGZPW
         6Y3frmkD9E3iVA3MxWdTfu3Kz4SXKeK9CUpjzWM4KsQmpBukb5QuEoGKUitFicTESM6i
         6GDpSdT9Q3Az62C3aKNVjDqpR+3mZ79tZ3TDxiP7EgkztMfasN+7QYs0MyQTk2mERg+c
         dlPiqf5YDF7qapMLrWH7HtoovPQxzPiZBhKe9fy5aCaNFQ5AMTQHl1elfuis+uq/dAJ/
         v0nQ==
X-Gm-Message-State: APjAAAW6ui8sZS7MahUSlmcNyi3iKhAU++6+I6tjek9Ra4uKesGJDlkw
        Tky0YBvjIIwF8UP6nWU7gLp9v5Vi
X-Google-Smtp-Source: APXvYqyFgw66p/sH764+lqKTLL/1isjH1xNZkBrQ/BbejIarBwcte6Wv96wcL3sEZayUCU3GQf5YJg==
X-Received: by 2002:aa7:d2cd:: with SMTP id k13mr9286922edr.28.1568283182242;
        Thu, 12 Sep 2019 03:13:02 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id k11sm2561499ejr.3.2019.09.12.03.13.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:13:01 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 1/3] crypto: inside-secure - Added support for basic SM3 ahash
Date:   Thu, 12 Sep 2019 11:10:12 +0200
Message-Id: <1568279414-16773-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the SM3 ahash algorithm

changes since v1:
- moved definition of CONTEXT_CONTROL_CRYPTO_ALG_SM3 (0x7) up above 0xf

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  2 +
 drivers/crypto/inside-secure/safexcel_hash.c | 59 ++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

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
index 282d59e..4c22df8 100644
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
@@ -869,5 +870,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chacha20;
 extern struct safexcel_alg_template safexcel_alg_chachapoly;
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
+extern struct safexcel_alg_template safexcel_alg_sm3;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 0224779..a4107bb 100644
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
@@ -776,6 +777,9 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SHA512)
 			memcpy(areq->result, sha512_zero_message_hash,
 			       SHA512_DIGEST_SIZE);
+		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SM3)
+			memcpy(areq->result, sm3_zero_message_hash,
+			       SM3_DIGEST_SIZE);
 
 		return 0;
 	} else if (unlikely(req->digest == CONTEXT_CONTROL_DIGEST_XCM &&
@@ -2221,3 +2225,58 @@ struct safexcel_alg_template safexcel_alg_cmac = {
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

