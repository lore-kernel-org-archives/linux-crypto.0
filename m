Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B48AC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFC922DD3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 06:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgFVGP0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 02:15:26 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:48805 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731219AbgFVGPR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 02:15:17 -0400
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 21 Jun 2020 23:15:16 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg02-sd.qualcomm.com with ESMTP; 21 Jun 2020 23:15:13 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id CBC0B218A1; Mon, 22 Jun 2020 11:45:11 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        stanimir.varbanov@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, cotequeiroz@gmail.com,
        ebiggers@google.com, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: qce: support zero length test vectors
Date:   Mon, 22 Jun 2020 11:45:04 +0530
Message-Id: <1592806506-23978-2-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
References: <1592806506-23978-1-git-send-email-sivaprak@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto test module passes zero length vectors as test input to sha-1 and
sha-256. To provide correct output for these vectors, hash zero support
has been added as in other crypto drivers.

Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
 drivers/crypto/Kconfig      |  2 ++
 drivers/crypto/qce/common.h |  2 ++
 drivers/crypto/qce/sha.c    | 18 +++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 802b9ada4e9e..7bc58bf99703 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -624,6 +624,8 @@ config CRYPTO_DEV_QCE_SKCIPHER
 config CRYPTO_DEV_QCE_SHA
 	bool
 	depends on CRYPTO_DEV_QCE
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
 
 choice
 	prompt "Algorithms enabled for QCE acceleration"
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 9f989cba0f1b..85ba16418a04 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -87,6 +87,8 @@ struct qce_alg_template {
 		struct ahash_alg ahash;
 	} alg;
 	struct qce_device *qce;
+	const u8 *hash_zero;
+	const u32 digest_size;
 };
 
 void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len);
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 1ab62e7d5f3c..ed82520203f9 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -305,8 +305,12 @@ static int qce_ahash_final(struct ahash_request *req)
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
 	struct qce_device *qce = tmpl->qce;
 
-	if (!rctx->buflen)
+	if (!rctx->buflen) {
+		if (tmpl->hash_zero)
+			memcpy(req->result, tmpl->hash_zero,
+					tmpl->alg.ahash.halg.digestsize);
 		return 0;
+	}
 
 	rctx->last_blk = true;
 
@@ -338,6 +342,13 @@ static int qce_ahash_digest(struct ahash_request *req)
 	rctx->first_blk = true;
 	rctx->last_blk = true;
 
+	if (!rctx->nbytes_orig) {
+		if (tmpl->hash_zero)
+			memcpy(req->result, tmpl->hash_zero,
+					tmpl->alg.ahash.halg.digestsize);
+		return 0;
+	}
+
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
@@ -490,6 +501,11 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	alg->halg.digestsize = def->digestsize;
 	alg->halg.statesize = def->statesize;
 
+	if (IS_SHA1(def->flags))
+		tmpl->hash_zero = sha1_zero_message_hash;
+	else if (IS_SHA256(def->flags))
+		tmpl->hash_zero = sha256_zero_message_hash;
+
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 300;
-- 
2.7.4

