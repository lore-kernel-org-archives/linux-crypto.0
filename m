Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CBBC4332D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CB422D6E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbhALDHQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387674AbhALDHQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 22:07:16 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE56C0617AB
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:53 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id j26so734910qtq.8
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xgi65kSxCtkSEFXSk+Ziqt8xvxh6x9q3ozPOFxdoDG4=;
        b=Qu7gN/zvRvs+jPzDp9Zw3b3JjdN0UK7EtPq+8hW/7hXtJQwlbzYxegrnBvZnd1iMkU
         6lLN1pL8DZbDSiG0wgHurOFto9UKIcMjNlxDpgmOasSO25RQNeFKtx1fQwDfy5lZrA/e
         gIKVt7OrMs3uJ3IiXrnASqhYxXmv0uoBe6lyyR6O76mqakSTEiRjgCBmP7JVFdd1PjqZ
         fN5mmbYUp5ZDzpzxypMK4bv9yDvoB34xD3loNIQSlaAsUrNdSspZjxbehIxs+UV8drcJ
         wjnxa9cof6PgvoyQrIUyOafTxuHwcBlWcTvo0MXAz/0tmKfa7/XUXAkICKQLAFAW/ZF7
         k+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgi65kSxCtkSEFXSk+Ziqt8xvxh6x9q3ozPOFxdoDG4=;
        b=twKu53AIZEt4xoPJeBvvEdgkYIZyrgv6lDZ/KcTyRYSjimHJ4zsf+A8MtzPEbrQvJe
         d7QNB83Si89CQ5oVD4d0zSV8WxnAEoQ40nElo/feJWscKVGK2uyvYoTejT+ccQBiJubO
         f2Wph/MUTQL8SEsY+S6tnvEdjtCqIsjK74hf6Y6PoibbMh6YugZmvHXx04lvjG/Ot9AC
         3OZM7o7lIzQsU+LEFpD9i3eCR8VisDR5OeaU4Rwx+0H3h87vdeDWGbrur90zmfrlNWhm
         KPrIUi8nMcbg90jwE0ec8U3yvefQnM8oQY545YGQl6zwC4rdHcWmgtyPH7YtaMNLhRZJ
         E8Ww==
X-Gm-Message-State: AOAM5332CKDyY2JTjYROv31c/tRGQJtZMlK6ilL6Qi9jo6Mb/516b60Q
        I7C7gpuWvSXtrSbyz9RAX24tOw==
X-Google-Smtp-Source: ABdhPJzgOcaF5VNSau79AGi9gL8+T879GmC0EC2VrTmKeg2RXqBgx7kndj0Rs9/rpyI9CEJsSG8cXg==
X-Received: by 2002:ac8:110e:: with SMTP id c14mr2586459qtj.293.1610420753230;
        Mon, 11 Jan 2021 19:05:53 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c7sm814235qkm.99.2021.01.11.19.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:05:52 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] drivers: crypto: qce: Remove totallen and offset in qce_start
Date:   Mon, 11 Jan 2021 22:05:45 -0500
Message-Id: <20210112030545.669480-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112030545.669480-1-thara.gopinath@linaro.org>
References: <20210112030545.669480-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

totallen is used to get the size of the data to be transformed.
This is also available via nbytes or cryptlen in the qce_sha_reqctx
and qce_cipher_ctx. Similarly offset convey nothing for the supported
encryption and authentication transformations and is always 0.
Remove these two redundant parameters in qce_start.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c   | 17 +++++++----------
 drivers/crypto/qce/common.h   |  3 +--
 drivers/crypto/qce/sha.c      |  2 +-
 drivers/crypto/qce/skcipher.c |  2 +-
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index f7bc701a4aa2..dceb9579d87a 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -140,8 +140,7 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 	return cfg;
 }
 
-static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
-				u32 totallen, u32 offset)
+static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 {
 	struct ahash_request *req = ahash_request_cast(async_req);
 	struct crypto_ahash *ahash = __crypto_ahash_cast(async_req->tfm);
@@ -306,8 +305,7 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
 	qce_write(qce, REG_ENCR_XTS_DU_SIZE, cryptlen);
 }
 
-static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
-				     u32 totallen, u32 offset)
+static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 {
 	struct skcipher_request *req = skcipher_request_cast(async_req);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
@@ -367,7 +365,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 
 	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
 	qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
-	qce_write(qce, REG_ENCR_SEG_START, offset & 0xffff);
+	qce_write(qce, REG_ENCR_SEG_START, 0);
 
 	if (IS_CTR(flags)) {
 		qce_write(qce, REG_CNTR_MASK, ~0);
@@ -376,7 +374,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 		qce_write(qce, REG_CNTR_MASK2, ~0);
 	}
 
-	qce_write(qce, REG_SEG_SIZE, totallen);
+	qce_write(qce, REG_SEG_SIZE, rctx->cryptlen);
 
 	/* get little endianness */
 	config = qce_config_reg(qce, 1);
@@ -388,17 +386,16 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 }
 #endif
 
-int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
-	      u32 offset)
+int qce_start(struct crypto_async_request *async_req, u32 type)
 {
 	switch (type) {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	case CRYPTO_ALG_TYPE_SKCIPHER:
-		return qce_setup_regs_skcipher(async_req, totallen, offset);
+		return qce_setup_regs_skcipher(async_req);
 #endif
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	case CRYPTO_ALG_TYPE_AHASH:
-		return qce_setup_regs_ahash(async_req, totallen, offset);
+		return qce_setup_regs_ahash(async_req);
 #endif
 	default:
 		return -EINVAL;
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 85ba16418a04..3bc244bcca2d 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -94,7 +94,6 @@ struct qce_alg_template {
 void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len);
 int qce_check_status(struct qce_device *qce, u32 *status);
 void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step);
-int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
-	      u32 offset);
+int qce_start(struct crypto_async_request *async_req, u32 type);
 
 #endif /* _COMMON_H_ */
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index dd263c5e4dd8..a079e92b4e75 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -113,7 +113,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type, 0, 0);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_terminate;
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 936bfb7c769b..2f327640b4de 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -143,7 +143,7 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type, req->cryptlen, 0);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_terminate;
 
-- 
2.25.1

