Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CB1C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C8264F21
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhBYS3G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhBYS2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:28:39 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03905C061794
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:22 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id x124so6614024qkc.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ETgBQLYg+/VWvm61ckCcRJ/qjnexOrujXO/Zc4gAByk=;
        b=QOtK3Py0wsHpsrn2/gcZiheoI2WxeORK7ySqUv+CVosazkeEuZGTt1atjv0gHFYOY1
         1phUdWb5oh06h6JQ/gjqu1fgpWo58evmWknnMtUDUGhc2xx6jcpBCRvbeAafGkLPqnEW
         TYpcGzd0IGQ20EYy0zeZdSoB2Nogy5ZD8bjnGf5bzU2lXiX2PT4oNBgaPdUBaFX3P9HC
         kaB5PfTPMG3qJKsg64FZDfMbwLA3T61ThSOexIkAOVE+K9kDoj7nT0M3XqRQ2zQXCcsz
         Am+uxXgcNR0+JIgYWKj7Vv3BIX4AbH9jNCcgfjs49qC63HLPeuvH8RLxuVxIi+Fh3vvN
         m7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ETgBQLYg+/VWvm61ckCcRJ/qjnexOrujXO/Zc4gAByk=;
        b=Os1yBj2Bqg/WglDUXCtihu5+T1jKYpezeK3f3LaqMK0dZHQ/MS1iD7VOBvW/4gQeg0
         RSMCF2cRBQr4RxS/ACUMDaeG3gWRD/wjCzoePUXuwde6mo6N5FlWaVNCeZkK4M/MlEqy
         B1CJn1tf29DF0Ggt/DSBIZNVaZq/Q7nSZJMTyuXEj919j/EcpF0B/TUBBMUi3FwZw21g
         o7BiB0wBP7rWcnh7SYJXxmB5IlM+UQ4P4wkIFt3GFkF3P+9MmwA6ruzLmyb8nLoN9YH7
         XvLbK/wFTEuMvlfz9PVxjd1QIM13fzsCWUDbUqZLCCDPii44h5sFXT2lBqle4fs/3T52
         23dQ==
X-Gm-Message-State: AOAM5332gD6CtrwwWpMTuWB8lst2ONHXsZIQUd5ccOSGTMwVC/RIdKBB
        UT8/fZZDooCPodxNqSKZLSBEbA==
X-Google-Smtp-Source: ABdhPJyBtLKwgKLkF7YDMwgY4LIUZeTV1v0kz99YxTg05GUmcnrl/QM2F3zMOiluFL2IBijJbMYsnw==
X-Received: by 2002:a05:620a:1315:: with SMTP id o21mr3964110qkj.3.1614277641049;
        Thu, 25 Feb 2021 10:27:21 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:20 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] crypto: qce: Add support for AEAD algorithms
Date:   Thu, 25 Feb 2021 13:27:13 -0500
Message-Id: <20210225182716.1402449-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce support to enable following algorithms in Qualcomm Crypto Engine.

- authenc(hmac(sha1),cbc(des))
- authenc(hmac(sha1),cbc(des3_ede))
- authenc(hmac(sha256),cbc(des))
- authenc(hmac(sha256),cbc(des3_ede))
- authenc(hmac(sha256),cbc(aes))
- ccm(aes)
- rfc4309(ccm(aes))

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/Kconfig      |  15 +
 drivers/crypto/qce/Makefile |   1 +
 drivers/crypto/qce/aead.c   | 779 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/aead.h   |  53 +++
 drivers/crypto/qce/common.h |   2 +
 drivers/crypto/qce/core.c   |   4 +
 6 files changed, 854 insertions(+)
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e535f28a8028..8caf296acda4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -645,6 +645,12 @@ config CRYPTO_DEV_QCE_SHA
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 
+config CRYPTO_DEV_QCE_AEAD
+	bool
+	depends on CRYPTO_DEV_QCE
+	select CRYPTO_AUTHENC
+	select CRYPTO_LIB_DES
+
 choice
 	prompt "Algorithms enabled for QCE acceleration"
 	default CRYPTO_DEV_QCE_ENABLE_ALL
@@ -665,6 +671,7 @@ choice
 		bool "All supported algorithms"
 		select CRYPTO_DEV_QCE_SKCIPHER
 		select CRYPTO_DEV_QCE_SHA
+		select CRYPTO_DEV_QCE_AEAD
 		help
 		  Enable all supported algorithms:
 			- AES (CBC, CTR, ECB, XTS)
@@ -690,6 +697,14 @@ choice
 			- SHA1, HMAC-SHA1
 			- SHA256, HMAC-SHA256
 
+	config CRYPTO_DEV_QCE_ENABLE_AEAD
+		bool "AEAD algorithms only"
+		select CRYPTO_DEV_QCE_AEAD
+		help
+		  Enable AEAD algorithms only:
+			- authenc()
+			- ccm(aes)
+			- rfc4309(ccm(aes))
 endchoice
 
 config CRYPTO_DEV_QCE_SW_MAX_LEN
diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
index 14ade8a7d664..2cf8984e1b85 100644
--- a/drivers/crypto/qce/Makefile
+++ b/drivers/crypto/qce/Makefile
@@ -6,3 +6,4 @@ qcrypto-objs := core.o \
 
 qcrypto-$(CONFIG_CRYPTO_DEV_QCE_SHA) += sha.o
 qcrypto-$(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) += skcipher.o
+qcrypto-$(CONFIG_CRYPTO_DEV_QCE_AEAD) += aead.o
diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
new file mode 100644
index 000000000000..b594c4bb2640
--- /dev/null
+++ b/drivers/crypto/qce/aead.c
@@ -0,0 +1,779 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (C) 2021, Linaro Limited. All rights reserved.
+ */
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <crypto/gcm.h>
+#include <crypto/authenc.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/des.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <crypto/scatterwalk.h>
+#include "aead.h"
+
+#define CCM_NONCE_ADATA_SHIFT		6
+#define CCM_NONCE_AUTHSIZE_SHIFT	3
+#define MAX_CCM_ADATA_HEADER_LEN        6
+
+static LIST_HEAD(aead_algs);
+
+static void qce_aead_done(void *data)
+{
+	struct crypto_async_request *async_req = data;
+	struct aead_request *req = aead_request_cast(async_req);
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+	struct qce_result_dump *result_buf = qce->dma.result_buf;
+	enum dma_data_direction dir_src, dir_dst;
+	bool diff_dst;
+	int error;
+	u32 status;
+	unsigned int totallen;
+	unsigned char tag[SHA256_DIGEST_SIZE] = {0};
+	int ret = 0;
+
+	diff_dst = (req->src != req->dst) ? true : false;
+	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
+
+	error = qce_dma_terminate_all(&qce->dma);
+	if (error)
+		dev_dbg(qce->dev, "aead dma termination error (%d)\n",
+			error);
+	if (diff_dst)
+		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
+
+	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+
+	if (IS_CCM(rctx->flags)) {
+		if (req->assoclen) {
+			sg_free_table(&rctx->src_tbl);
+			if (diff_dst)
+				sg_free_table(&rctx->dst_tbl);
+		} else {
+			if (!(IS_DECRYPT(rctx->flags) && !diff_dst))
+				sg_free_table(&rctx->dst_tbl);
+		}
+	} else {
+		sg_free_table(&rctx->dst_tbl);
+	}
+
+	error = qce_check_status(qce, &status);
+	if (error < 0 && (error != -EBADMSG))
+		dev_err(qce->dev, "aead operation error (%x)\n", status);
+
+	if (IS_ENCRYPT(rctx->flags)) {
+		totallen = req->cryptlen + req->assoclen;
+		if (IS_CCM(rctx->flags))
+			scatterwalk_map_and_copy(rctx->ccmresult_buf, req->dst,
+						 totallen, ctx->authsize, 1);
+		else
+			scatterwalk_map_and_copy(result_buf->auth_iv, req->dst,
+						 totallen, ctx->authsize, 1);
+
+	} else if (!IS_CCM(rctx->flags)) {
+		totallen = req->cryptlen + req->assoclen - ctx->authsize;
+		scatterwalk_map_and_copy(tag, req->src, totallen, ctx->authsize, 0);
+		ret = memcmp(result_buf->auth_iv, tag, ctx->authsize);
+		if (ret) {
+			pr_err("Bad message error\n");
+			 error = -EBADMSG;
+		}
+	}
+
+	qce->async_req_done(qce, error);
+}
+
+static struct scatterlist *
+qce_aead_prepare_result_buf(struct sg_table *tbl, struct aead_request *req)
+{
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+
+	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
+	return qce_sgtable_add(tbl, &rctx->result_sg, QCE_RESULT_BUF_SZ);
+}
+
+static struct scatterlist *
+qce_aead_prepare_ccm_result_buf(struct sg_table *tbl, struct aead_request *req)
+{
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+
+	sg_init_one(&rctx->result_sg, rctx->ccmresult_buf, QCE_BAM_BURST_SIZE);
+	return qce_sgtable_add(tbl, &rctx->result_sg, QCE_BAM_BURST_SIZE);
+}
+
+static struct scatterlist *
+qce_aead_prepare_dst_buf(struct aead_request *req)
+{
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+	struct scatterlist *sg, *msg_sg, __sg[2];
+	gfp_t gfp;
+	unsigned int assoclen = req->assoclen;
+	unsigned int totallen;
+	int ret;
+
+	totallen = rctx->cryptlen + assoclen;
+	rctx->dst_nents = sg_nents_for_len(req->dst, totallen);
+	if (rctx->dst_nents < 0) {
+		dev_err(qce->dev, "Invalid numbers of dst SG.\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (IS_CCM(rctx->flags))
+		rctx->dst_nents += 2;
+	else
+		rctx->dst_nents += 1;
+
+	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+						GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->dst_tbl, rctx->dst_nents, gfp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (IS_CCM(rctx->flags) && assoclen) {
+		/* Get the dst buffer */
+		msg_sg = scatterwalk_ffwd(__sg, req->dst, assoclen);
+
+		sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->adata_sg,
+				     rctx->assoclen);
+		if (IS_ERR(sg)) {
+			ret = PTR_ERR(sg);
+			goto dst_tbl_free;
+		}
+		/* dst buffer */
+		sg = qce_sgtable_add(&rctx->dst_tbl, msg_sg, rctx->cryptlen);
+		if (IS_ERR(sg)) {
+			ret = PTR_ERR(sg);
+			goto dst_tbl_free;
+		}
+		totallen = rctx->cryptlen + rctx->assoclen;
+	} else {
+		if (totallen) {
+			sg = qce_sgtable_add(&rctx->dst_tbl, req->dst, totallen);
+			if (IS_ERR(sg))
+				goto dst_tbl_free;
+		}
+	}
+	if (IS_CCM(rctx->flags))
+		sg = qce_aead_prepare_ccm_result_buf(&rctx->dst_tbl, req);
+	else
+		sg = qce_aead_prepare_result_buf(&rctx->dst_tbl, req);
+
+	if (IS_ERR(sg))
+		goto dst_tbl_free;
+
+	sg_mark_end(sg);
+	rctx->dst_sg = rctx->dst_tbl.sgl;
+	rctx->dst_nents = sg_nents_for_len(rctx->dst_sg, totallen) + 1;
+
+	return sg;
+
+dst_tbl_free:
+	sg_free_table(&rctx->dst_tbl);
+	return sg;
+}
+
+static int
+qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
+{
+	struct scatterlist *sg, *msg_sg, __sg[2];
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int assoclen = rctx->assoclen;
+	unsigned int adata_header_len, cryptlen, totallen;
+	gfp_t gfp;
+	bool diff_dst;
+	int ret;
+
+	if (IS_DECRYPT(rctx->flags))
+		cryptlen = rctx->cryptlen + ctx->authsize;
+	else
+		cryptlen = rctx->cryptlen;
+	totallen = cryptlen + req->assoclen;
+
+	/* Get the msg */
+	msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
+
+	rctx->adata = kzalloc((ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN) *
+			       sizeof(unsigned char), GFP_ATOMIC);
+	if (!rctx->adata)
+		return -ENOMEM;
+
+	/*
+	 * Format associated data (RFC3610 and NIST 800-38C)
+	 * Even though specification allows for AAD to be up to 2^64 - 1 bytes,
+	 * the assoclen field in aead_request is unsigned int and thus limits
+	 * the AAD to be up to 2^32 - 1 bytes. So we handle only two scenarios
+	 * while forming the header for AAD.
+	 */
+	if (assoclen < 0xff00) {
+		adata_header_len = 2;
+		*(__be16 *)rctx->adata = cpu_to_be16(assoclen);
+	} else {
+		adata_header_len = 6;
+		*(__be16 *)rctx->adata = cpu_to_be16(0xfffe);
+		*(__be32 *)(rctx->adata + 2) = cpu_to_be32(assoclen);
+	}
+
+	/* Copy the associated data */
+	if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, assoclen),
+			      rctx->adata + adata_header_len,
+			      assoclen) != assoclen)
+		return -EINVAL;
+
+	/* Pad associated data to block size */
+	rctx->assoclen = ALIGN(assoclen + adata_header_len, 16);
+
+	diff_dst = (req->src != req->dst) ? true : false;
+
+	if (diff_dst)
+		rctx->src_nents = sg_nents_for_len(req->src, totallen) + 1;
+	else
+		rctx->src_nents = sg_nents_for_len(req->src, totallen) + 2;
+
+	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->src_tbl, rctx->src_nents, gfp);
+	if (ret)
+		return ret;
+
+	/* Associated Data */
+	sg_init_one(&rctx->adata_sg, rctx->adata, rctx->assoclen);
+	sg = qce_sgtable_add(&rctx->src_tbl, &rctx->adata_sg,
+			     rctx->assoclen);
+	if (IS_ERR(sg)) {
+		ret = PTR_ERR(sg);
+		goto err_free;
+	}
+	/* src msg */
+	sg = qce_sgtable_add(&rctx->src_tbl, msg_sg, cryptlen);
+	if (IS_ERR(sg)) {
+		ret = PTR_ERR(sg);
+		goto err_free;
+	}
+	if (!diff_dst) {
+		/*
+		 * When src and dst buffers are same, there is already space
+		 * in the buffer for padded 0's which is output in lieu of
+		 * the MAC that is input
+		 */
+		if (!IS_DECRYPT(rctx->flags)) {
+			sg = qce_aead_prepare_ccm_result_buf(&rctx->src_tbl, req);
+			if (IS_ERR(sg)) {
+				ret = PTR_ERR(sg);
+				goto err_free;
+			}
+		}
+	}
+	sg_mark_end(sg);
+	rctx->src_sg = rctx->src_tbl.sgl;
+	totallen = cryptlen + rctx->assoclen;
+	rctx->src_nents = sg_nents_for_len(rctx->src_sg, totallen);
+
+	if (diff_dst) {
+		sg = qce_aead_prepare_dst_buf(req);
+		if (IS_ERR(sg))
+			goto err_free;
+	} else {
+		if (IS_ENCRYPT(rctx->flags))
+			rctx->dst_nents = rctx->src_nents + 1;
+		else
+			rctx->dst_nents = rctx->src_nents;
+		rctx->dst_sg = rctx->src_sg;
+	}
+
+	return 0;
+err_free:
+	sg_free_table(&rctx->src_tbl);
+	return ret;
+}
+
+static int qce_aead_prepare_buf(struct aead_request *req)
+{
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+	struct scatterlist *sg;
+	bool diff_dst = (req->src != req->dst) ? true : false;
+	unsigned int totallen;
+
+	totallen = rctx->cryptlen + rctx->assoclen;
+
+	sg = qce_aead_prepare_dst_buf(req);
+	if (IS_ERR(sg))
+		return PTR_ERR(sg);
+	if (diff_dst) {
+		rctx->src_nents = sg_nents_for_len(req->src, totallen);
+		if (rctx->src_nents < 0) {
+			dev_err(qce->dev, "Invalid numbers of src SG.\n");
+			return -EINVAL;
+		}
+		rctx->src_sg = req->src;
+	} else {
+		rctx->src_nents = rctx->dst_nents - 1;
+		rctx->src_sg = rctx->dst_sg;
+	}
+	return 0;
+}
+
+static int qce_aead_ccm_prepare_buf(struct aead_request *req)
+{
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct scatterlist *sg;
+	bool diff_dst = (req->src != req->dst) ? true : false;
+	unsigned int cryptlen;
+
+	if (rctx->assoclen)
+		return qce_aead_ccm_prepare_buf_assoclen(req);
+
+	if (IS_ENCRYPT(rctx->flags))
+		return qce_aead_prepare_buf(req);
+
+	cryptlen = rctx->cryptlen + ctx->authsize;
+	if (diff_dst) {
+		rctx->src_nents = sg_nents_for_len(req->src, cryptlen);
+		rctx->src_sg = req->src;
+		sg = qce_aead_prepare_dst_buf(req);
+		if (IS_ERR(sg))
+			return PTR_ERR(sg);
+	} else {
+		rctx->src_nents = sg_nents_for_len(req->src, cryptlen);
+		rctx->src_sg = req->src;
+		rctx->dst_nents = rctx->src_nents;
+		rctx->dst_sg = rctx->src_sg;
+	}
+
+	return 0;
+}
+
+static int qce_aead_create_ccm_nonce(struct qce_aead_reqctx *rctx, struct qce_aead_ctx *ctx)
+{
+	unsigned int msglen_size;
+	u8 msg_len[4];
+	int i;
+
+	if (!rctx || !rctx->iv)
+		return -EINVAL;
+
+	msglen_size = rctx->iv[0] + 1;
+
+	if (msglen_size > 4)
+		msglen_size = 4;
+
+	memcpy(&msg_len[0], &rctx->cryptlen, 4);
+
+	memcpy(&rctx->ccm_nonce[0], rctx->iv, rctx->ivsize);
+	if (rctx->assoclen)
+		rctx->ccm_nonce[0] |= 1 << CCM_NONCE_ADATA_SHIFT;
+	rctx->ccm_nonce[0] |= ((ctx->authsize - 2) / 2) <<
+				CCM_NONCE_AUTHSIZE_SHIFT;
+	for (i = 0; i < msglen_size; i++)
+		rctx->ccm_nonce[QCE_MAX_NONCE - i - 1] = msg_len[i];
+
+	return 0;
+}
+
+static int
+qce_aead_async_req_handle(struct crypto_async_request *async_req)
+{
+	struct aead_request *req = aead_request_cast(async_req);
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+	enum dma_data_direction dir_src, dir_dst;
+	unsigned int totallen;
+	bool diff_dst;
+	int ret;
+
+	if (IS_CCM_RFC4309(rctx->flags)) {
+		memset(rctx->ccm_rfc4309_iv, 0, QCE_MAX_IV_SIZE);
+		rctx->ccm_rfc4309_iv[0] = 3;
+		memcpy(&rctx->ccm_rfc4309_iv[1], ctx->ccm4309_salt, QCE_CCM4309_SALT_SIZE);
+		memcpy(&rctx->ccm_rfc4309_iv[4], req->iv, 8);
+		rctx->iv = rctx->ccm_rfc4309_iv;
+		rctx->ivsize = AES_BLOCK_SIZE;
+	} else {
+		rctx->iv = req->iv;
+		rctx->ivsize = crypto_aead_ivsize(tfm);
+	}
+	if (IS_CCM_RFC4309(rctx->flags))
+		rctx->assoclen = req->assoclen - 8;
+	else
+		rctx->assoclen = req->assoclen;
+
+	totallen = rctx->cryptlen + rctx->assoclen;
+
+	diff_dst = (req->src != req->dst) ? true : false;
+	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
+
+	if (IS_CCM(rctx->flags)) {
+		ret = qce_aead_create_ccm_nonce(rctx, ctx);
+		if (ret)
+			return ret;
+	}
+	if (IS_CCM(rctx->flags))
+		ret = qce_aead_ccm_prepare_buf(req);
+	else
+		ret = qce_aead_prepare_buf(req);
+
+	if (ret)
+		return ret;
+	ret = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	if (ret < 0)
+		goto error_free;
+
+	if (diff_dst) {
+		ret = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
+		if (ret < 0)
+			goto error_unmap_dst;
+	}
+
+	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
+			       rctx->dst_sg, rctx->dst_nents,
+			       qce_aead_done, async_req);
+	if (ret)
+		goto error_unmap_src;
+
+	qce_dma_issue_pending(&qce->dma);
+
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
+	if (ret)
+		goto error_terminate;
+
+	return 0;
+
+error_terminate:
+	qce_dma_terminate_all(&qce->dma);
+error_unmap_src:
+	if (diff_dst)
+		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+error_unmap_dst:
+	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+error_free:
+	if (IS_CCM(rctx->flags) && rctx->assoclen) {
+		sg_free_table(&rctx->src_tbl);
+		if (diff_dst)
+			sg_free_table(&rctx->dst_tbl);
+	} else {
+		sg_free_table(&rctx->dst_tbl);
+	}
+	return ret;
+}
+
+static int qce_aead_crypt(struct aead_request *req, int encrypt)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(tfm);
+	unsigned int blocksize = crypto_aead_blocksize(tfm);
+
+	rctx->flags  = tmpl->alg_flags;
+	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
+
+	if (encrypt)
+		rctx->cryptlen = req->cryptlen;
+	else
+		rctx->cryptlen = req->cryptlen - ctx->authsize;
+
+	/* CE does not handle 0 length messages */
+	if (!rctx->cryptlen) {
+		if (!(IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags)))
+			return -EINVAL;
+	}
+
+	/*
+	 * CBC algorithms require message lengths to be
+	 * multiples of block size.
+	 */
+	if (IS_CBC(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, blocksize))
+		return -EINVAL;
+
+	/* RFC4309 supported AAD size 16 bytes/20 bytes */
+	if (IS_CCM_RFC4309(rctx->flags))
+		if (crypto_ipsec_check_assoclen(req->assoclen))
+			return -EINVAL;
+
+	return tmpl->qce->async_req_enqueue(tmpl->qce, &req->base);
+}
+
+static int qce_aead_encrypt(struct aead_request *req)
+{
+	return qce_aead_crypt(req, 1);
+}
+
+static int qce_aead_decrypt(struct aead_request *req)
+{
+	return qce_aead_crypt(req, 0);
+}
+
+static int qce_aead_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned long flags = to_aead_tmpl(tfm)->alg_flags;
+
+	if (IS_CCM_RFC4309(flags)) {
+		if (keylen < QCE_CCM4309_SALT_SIZE)
+			return -EINVAL;
+		keylen -= QCE_CCM4309_SALT_SIZE;
+		memcpy(ctx->ccm4309_salt, key + keylen, QCE_CCM4309_SALT_SIZE);
+	}
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->enc_keylen = keylen;
+	ctx->auth_keylen = keylen;
+
+	memcpy(ctx->enc_key, key, keylen);
+	memcpy(ctx->auth_key, key, keylen);
+
+	return 0;
+}
+
+static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_authenc_keys authenc_keys;
+	unsigned long flags = to_aead_tmpl(tfm)->alg_flags;
+	u32 _key[6];
+	int err;
+
+	err = crypto_authenc_extractkeys(&authenc_keys, key, keylen);
+	if (err)
+		return err;
+
+	if (authenc_keys.enckeylen > QCE_MAX_KEY_SIZE ||
+	    authenc_keys.authkeylen > QCE_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	if (IS_DES(flags)) {
+		err = verify_aead_des_key(tfm, authenc_keys.enckey, authenc_keys.enckeylen);
+		if (err)
+			return err;
+	} else if (IS_3DES(flags)) {
+		err = verify_aead_des3_key(tfm, authenc_keys.enckey, authenc_keys.enckeylen);
+		if (err)
+			return err;
+		/*
+		 * The crypto engine does not support any two keys
+		 * being the same for triple des algorithms. The
+		 * verify_skcipher_des3_key does not check for all the
+		 * below conditions. Return -EINVAL in case any two keys
+		 * are the same. Revisit to see if a fallback cipher
+		 * is needed to handle this condition.
+		 */
+		memcpy(_key, authenc_keys.enckey, DES3_EDE_KEY_SIZE);
+		if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) ||
+		    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) ||
+		    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
+			return -EINVAL;
+	} else if (IS_AES(flags)) {
+		/* No random key sizes */
+		if (authenc_keys.enckeylen != AES_KEYSIZE_128 &&
+		    authenc_keys.enckeylen != AES_KEYSIZE_256)
+			return -EINVAL;
+	}
+
+	ctx->enc_keylen = authenc_keys.enckeylen;
+	ctx->auth_keylen = authenc_keys.authkeylen;
+
+	memcpy(ctx->enc_key, authenc_keys.enckey, authenc_keys.enckeylen);
+
+	memset(ctx->auth_key, 0, sizeof(ctx->auth_key));
+	memcpy(ctx->auth_key, authenc_keys.authkey, authenc_keys.authkeylen);
+
+	return 0;
+}
+
+static int qce_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned long flags = to_aead_tmpl(tfm)->alg_flags;
+
+	if (IS_CCM(flags)) {
+		if (authsize < 4 || authsize > 16 || authsize % 2)
+			return -EINVAL;
+		if (IS_CCM_RFC4309(flags) && (authsize < 8 || authsize % 4))
+			return -EINVAL;
+	}
+	ctx->authsize = authsize;
+	return 0;
+}
+
+static int qce_aead_init(struct crypto_aead *tfm)
+{
+	crypto_aead_set_reqsize(tfm, sizeof(struct qce_aead_reqctx));
+	return 0;
+}
+
+struct qce_aead_def {
+	unsigned long flags;
+	const char *name;
+	const char *drv_name;
+	unsigned int blocksize;
+	unsigned int chunksize;
+	unsigned int ivsize;
+	unsigned int maxauthsize;
+};
+
+static const struct qce_aead_def aead_def[] = {
+	{
+		.flags          = QCE_ALG_DES | QCE_MODE_CBC | QCE_HASH_SHA1_HMAC,
+		.name           = "authenc(hmac(sha1),cbc(des))",
+		.drv_name       = "authenc-hmac-sha1-cbc-des-qce",
+		.blocksize      = DES_BLOCK_SIZE,
+		.ivsize         = DES_BLOCK_SIZE,
+		.maxauthsize	= SHA1_DIGEST_SIZE,
+	},
+	{
+		.flags          = QCE_ALG_3DES | QCE_MODE_CBC | QCE_HASH_SHA1_HMAC,
+		.name           = "authenc(hmac(sha1),cbc(des3_ede))",
+		.drv_name       = "authenc-hmac-sha1-cbc-3des-qce",
+		.blocksize      = DES3_EDE_BLOCK_SIZE,
+		.ivsize         = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize	= SHA1_DIGEST_SIZE,
+	},
+	{
+		.flags          = QCE_ALG_DES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
+		.name           = "authenc(hmac(sha256),cbc(des))",
+		.drv_name       = "authenc-hmac-sha256-cbc-des-qce",
+		.blocksize      = DES_BLOCK_SIZE,
+		.ivsize         = DES_BLOCK_SIZE,
+		.maxauthsize	= SHA256_DIGEST_SIZE,
+	},
+	{
+		.flags          = QCE_ALG_3DES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
+		.name           = "authenc(hmac(sha256),cbc(des3_ede))",
+		.drv_name       = "authenc-hmac-sha256-cbc-3des-qce",
+		.blocksize      = DES3_EDE_BLOCK_SIZE,
+		.ivsize         = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize	= SHA256_DIGEST_SIZE,
+	},
+	{
+		.flags          =  QCE_ALG_AES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
+		.name           = "authenc(hmac(sha256),cbc(aes))",
+		.drv_name       = "authenc-hmac-sha256-cbc-aes-qce",
+		.blocksize      = AES_BLOCK_SIZE,
+		.ivsize         = AES_BLOCK_SIZE,
+		.maxauthsize	= SHA256_DIGEST_SIZE,
+	},
+	{
+		.flags          =  QCE_ALG_AES | QCE_MODE_CCM,
+		.name           = "ccm(aes)",
+		.drv_name       = "ccm-aes-qce",
+		.blocksize	= 1,
+		.ivsize         = AES_BLOCK_SIZE,
+		.maxauthsize	= AES_BLOCK_SIZE,
+	},
+	{
+		.flags          =  QCE_ALG_AES | QCE_MODE_CCM | QCE_MODE_CCM_RFC4309,
+		.name           = "rfc4309(ccm(aes))",
+		.drv_name       = "rfc4309-ccm-aes-qce",
+		.blocksize	= 1,
+		.ivsize         = 8,
+		.maxauthsize	= AES_BLOCK_SIZE,
+	},
+};
+
+static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl;
+	struct aead_alg *alg;
+	int ret;
+
+	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
+	if (!tmpl)
+		return -ENOMEM;
+
+	alg = &tmpl->alg.aead;
+
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 def->drv_name);
+
+	alg->base.cra_blocksize		= def->blocksize;
+	alg->chunksize			= def->chunksize;
+	alg->ivsize			= def->ivsize;
+	alg->maxauthsize		= def->maxauthsize;
+	if (IS_CCM(def->flags))
+		alg->setkey		= qce_aead_ccm_setkey;
+	else
+		alg->setkey		= qce_aead_setkey;
+	alg->setauthsize		= qce_aead_setauthsize;
+	alg->encrypt			= qce_aead_encrypt;
+	alg->decrypt			= qce_aead_decrypt;
+	alg->init			= qce_aead_init;
+
+	alg->base.cra_priority		= 300;
+	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_ctxsize		= sizeof(struct qce_aead_ctx);
+	alg->base.cra_alignmask		= 0;
+	alg->base.cra_module		= THIS_MODULE;
+
+	INIT_LIST_HEAD(&tmpl->entry);
+	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_AEAD;
+	tmpl->alg_flags = def->flags;
+	tmpl->qce = qce;
+
+	ret = crypto_register_aead(alg);
+	if (ret) {
+		kfree(tmpl);
+		dev_err(qce->dev, "%s registration failed\n", alg->base.cra_name);
+		return ret;
+	}
+
+	list_add_tail(&tmpl->entry, &aead_algs);
+	dev_dbg(qce->dev, "%s is registered\n", alg->base.cra_name);
+	return 0;
+}
+
+static void qce_aead_unregister(struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl, *n;
+
+	list_for_each_entry_safe(tmpl, n, &aead_algs, entry) {
+		crypto_unregister_aead(&tmpl->alg.aead);
+		list_del(&tmpl->entry);
+		kfree(tmpl);
+	}
+}
+
+static int qce_aead_register(struct qce_device *qce)
+{
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(aead_def); i++) {
+		ret = qce_aead_register_one(&aead_def[i], qce);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	qce_aead_unregister(qce);
+	return ret;
+}
+
+const struct qce_algo_ops aead_ops = {
+	.type = CRYPTO_ALG_TYPE_AEAD,
+	.register_algs = qce_aead_register,
+	.unregister_algs = qce_aead_unregister,
+	.async_req_handle = qce_aead_async_req_handle,
+};
diff --git a/drivers/crypto/qce/aead.h b/drivers/crypto/qce/aead.h
new file mode 100644
index 000000000000..3d1f2039930b
--- /dev/null
+++ b/drivers/crypto/qce/aead.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, Linaro Limited. All rights reserved.
+ */
+
+#ifndef _AEAD_H_
+#define _AEAD_H_
+
+#include "common.h"
+#include "core.h"
+
+#define QCE_MAX_KEY_SIZE		64
+#define QCE_CCM4309_SALT_SIZE		3
+
+struct qce_aead_ctx {
+	u8 enc_key[QCE_MAX_KEY_SIZE];
+	u8 auth_key[QCE_MAX_KEY_SIZE];
+	u8 ccm4309_salt[QCE_CCM4309_SALT_SIZE];
+	unsigned int enc_keylen;
+	unsigned int auth_keylen;
+	unsigned int authsize;
+};
+
+struct qce_aead_reqctx {
+	unsigned long flags;
+	u8 *iv;
+	unsigned int ivsize;
+	int src_nents;
+	int dst_nents;
+	struct scatterlist result_sg;
+	struct scatterlist adata_sg;
+	struct sg_table dst_tbl;
+	struct sg_table src_tbl;
+	struct scatterlist *dst_sg;
+	struct scatterlist *src_sg;
+	unsigned int cryptlen;
+	unsigned int assoclen;
+	unsigned char *adata;
+	u8 ccm_nonce[QCE_MAX_NONCE];
+	u8 ccmresult_buf[QCE_BAM_BURST_SIZE];
+	u8 ccm_rfc4309_iv[QCE_MAX_IV_SIZE];
+};
+
+static inline struct qce_alg_template *to_aead_tmpl(struct crypto_aead *tfm)
+{
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+
+	return container_of(alg, struct qce_alg_template, alg.aead);
+}
+
+extern const struct qce_algo_ops aead_ops;
+
+#endif /* _AEAD_H_ */
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 3ffe719b79e4..ba7ff6b68825 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -11,6 +11,7 @@
 #include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/aead.h>
 
 /* xts du size */
 #define QCE_SECTOR_SIZE			512
@@ -88,6 +89,7 @@ struct qce_alg_template {
 	union {
 		struct skcipher_alg skcipher;
 		struct ahash_alg ahash;
+		struct aead_alg aead;
 	} alg;
 	struct qce_device *qce;
 	const u8 *hash_zero;
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 80b75085c265..d3780be44a76 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -17,6 +17,7 @@
 #include "core.h"
 #include "cipher.h"
 #include "sha.h"
+#include "aead.h"
 
 #define QCE_MAJOR_VERSION5	0x05
 #define QCE_QUEUE_LENGTH	1
@@ -28,6 +29,9 @@ static const struct qce_algo_ops *qce_ops[] = {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	&ahash_ops,
 #endif
+#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
+	&aead_ops,
+#endif
 };
 
 static void qce_unregister_algs(struct qce_device *qce)
-- 
2.25.1

