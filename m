Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6C7C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiGUNpe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiGUNod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:44:33 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4113D85F87
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:14 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d17so702870lfa.12
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R2YP8hf62sewspiSTE/eVIUQ9Dbl6R6ObJkLzBoFtJw=;
        b=d2gWzCAwqoczmPdzT3yJczOOKuoBXetcOvh7Jbb0ZKoBMTytwjEl3W320OXRMa36RP
         5LkkNAzlz4NNt+q+7cvRYY/Hiu9kp+6Fl9fykb6/762c6LaVSL2pzzqfWV9yjN0j2dXr
         eQo+ux1r43EV02T3hn+YFucpoxIzM4BkTf/rcyopEYlEms5naVrD8JLwDTm6ZxVsa4m/
         uPwZWyfw0ASEthhvqCQ2LVwW4kDKYCY71p2ubb5LFDiwAG8bpZ9I5xsneE3m572WUZAm
         uK7/ZJu74F7lC+Jq5iYaOqjrTYNTkId0oDJC6yPI6/acsEF5V63TzG3BTyGy8V9P8RHY
         WVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2YP8hf62sewspiSTE/eVIUQ9Dbl6R6ObJkLzBoFtJw=;
        b=Oojx+bnGCY6kXFbHkoRRnn9i0O6pjDisO61E/Yvma/App8b0orlbilSaDgH3FI7+sb
         JLurNqUSmL7E84WknxF/MzjDjKvrhPEJ1KCMWoW4Gf25Pv27ZJIBqnuQV28YbqPbuGLx
         OZ5U6Q+C7LFUnTJyYIXgvhzjyyOUnM/H5M3n60SvHx5RpjZleMb2Uh5C9lUjN/gPbPno
         4Psz8/yusxqcywyLaA1s6qwWVOX9RDK7vdCCaeNaqK02+cAw0PO6V+KDjsmQBcSA/Jnf
         S2w4VRfpiwU8TwQSz+h5oZNrAfiQWWSt+KR45TFsTKE57sUacC5ndsZRfShsgH6Hj/t4
         cOVA==
X-Gm-Message-State: AJIora+msTh+fEy4JTIaWCgRf6qDRuvWKN0Ww0m+fg59CDeAHCo2sac9
        wJzYFyJCAFwQ+gK3iEojChru4j+GNwiG0A==
X-Google-Smtp-Source: AGRyM1vFEVR8Jscvw9xY6XT+usU1QTVOWc+HyjuzSuSrj/9WThkW8h/IBKvgZ+CcK2lZwQjmbyldAA==
X-Received: by 2002:a05:6512:31c9:b0:489:e037:31b9 with SMTP id j9-20020a05651231c900b00489e03731b9mr22178941lfe.178.1658410989440;
        Thu, 21 Jul 2022 06:43:09 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:09 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/15] crypto: ux500/hash: Implement .export and .import
Date:   Thu, 21 Jul 2022 15:40:45 +0200
Message-Id: <20220721134050.1047866-11-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .export and .import callbacks are just implemented as stubs
which makes the tests fail:

 alg: ahash: hmac-sha256-ux500 export() failed with err -38 on
   test vector 0, cfg="import/export"
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 92 at crypto/testmgr.c:5777
   alg_test.part.0+0x160/0x3ec
 alg: self-tests for hmac-sha256-ux500 (hmac(sha256)) failed (rc=-38)

The driver already has code for saving and restoring the hardware
state, which is now unused. Pass the tests by simply implementing the
callbacks properly, extending the state with the length, index
and buffer from the ongoing request context.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  |   5 +
 drivers/crypto/ux500/hash/hash_core.c | 227 +++++++++++++-------------
 2 files changed, 114 insertions(+), 118 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 5aa86c4855f5..05f0b0221a13 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -226,6 +226,11 @@ struct hash_state {
 	u32		csr[52];
 	u32		csfull;
 	u32		csdatain;
+	u32		buffer[HASH_BLOCK_SIZE / sizeof(u32)];
+	struct uint64	length;
+	u8		index;
+	bool		dma_mode;
+	bool		hw_initialized;
 };
 
 /**
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 46dad128b6fe..1edb11812c7d 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -964,108 +964,6 @@ int hash_hw_update(struct ahash_request *req)
 	return 0;
 }
 
-/**
- * hash_resume_state - Function that resumes the state of an calculation.
- * @device_data:	Pointer to the device structure.
- * @device_state:	The state to be restored in the hash hardware
- */
-int hash_resume_state(struct hash_device_data *device_data,
-		      const struct hash_state *device_state)
-{
-	u32 temp_cr;
-	s32 count;
-	int hash_mode = HASH_OPER_MODE_HASH;
-
-	if (NULL == device_state) {
-		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
-			__func__);
-		return -EPERM;
-	}
-
-	/*
-	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
-	 * prepare the initialize the HASH accelerator to compute the message
-	 * digest of a new message.
-	 */
-	HASH_INITIALIZE;
-
-	temp_cr = device_state->temp_cr;
-	writel_relaxed(temp_cr & HASH_CR_RESUME_MASK, &device_data->base->cr);
-
-	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
-		hash_mode = HASH_OPER_MODE_HMAC;
-	else
-		hash_mode = HASH_OPER_MODE_HASH;
-
-	for (count = 0; count < HASH_CSR_COUNT; count++) {
-		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
-			break;
-
-		writel_relaxed(device_state->csr[count],
-			       &device_data->base->csrx[count]);
-	}
-
-	writel_relaxed(device_state->csfull, &device_data->base->csfull);
-	writel_relaxed(device_state->csdatain, &device_data->base->csdatain);
-
-	writel_relaxed(device_state->str_reg, &device_data->base->str);
-	writel_relaxed(temp_cr, &device_data->base->cr);
-
-	return 0;
-}
-
-/**
- * hash_save_state - Function that saves the state of hardware.
- * @device_data:	Pointer to the device structure.
- * @device_state:	The strucure where the hardware state should be saved.
- */
-int hash_save_state(struct hash_device_data *device_data,
-		    struct hash_state *device_state)
-{
-	u32 temp_cr;
-	u32 count;
-	int hash_mode = HASH_OPER_MODE_HASH;
-
-	if (NULL == device_state) {
-		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
-			__func__);
-		return -ENOTSUPP;
-	}
-
-	/* Write dummy value to force digest intermediate calculation. This
-	 * actually makes sure that there isn't any ongoing calculation in the
-	 * hardware.
-	 */
-	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
-		cpu_relax();
-
-	temp_cr = readl_relaxed(&device_data->base->cr);
-
-	device_state->str_reg = readl_relaxed(&device_data->base->str);
-
-	device_state->din_reg = readl_relaxed(&device_data->base->din);
-
-	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
-		hash_mode = HASH_OPER_MODE_HMAC;
-	else
-		hash_mode = HASH_OPER_MODE_HASH;
-
-	for (count = 0; count < HASH_CSR_COUNT; count++) {
-		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
-			break;
-
-		device_state->csr[count] =
-			readl_relaxed(&device_data->base->csrx[count]);
-	}
-
-	device_state->csfull = readl_relaxed(&device_data->base->csfull);
-	device_state->csdatain = readl_relaxed(&device_data->base->csdatain);
-
-	device_state->temp_cr = temp_cr;
-
-	return 0;
-}
-
 /**
  * hash_check_hw - This routine checks for peripheral Ids and PCell Ids.
  * @device_data:
@@ -1244,14 +1142,107 @@ static int ahash_sha256_digest(struct ahash_request *req)
 	return ret1 ? ret1 : ret2;
 }
 
-static int ahash_noimport(struct ahash_request *req, const void *in)
+static int ahash_import(struct ahash_request *req, const void *in)
 {
-	return -ENOSYS;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct hash_device_data *device_data = ctx->device;
+	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	const struct hash_state *hstate = in;
+	int hash_mode = HASH_OPER_MODE_HASH;
+	u32 cr;
+	s32 count;
+
+	/* Restore software state */
+	req_ctx->length = hstate->length;
+	req_ctx->index = hstate->index;
+	req_ctx->dma_mode = hstate->dma_mode;
+	req_ctx->hw_initialized = hstate->hw_initialized;
+	memcpy(req_ctx->buffer, hstate->buffer, HASH_BLOCK_SIZE);
+
+	/*
+	 * Restore hardware state
+	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
+	 * prepare the initialize the HASH accelerator to compute the message
+	 * digest of a new message.
+	 */
+	HASH_INITIALIZE;
+
+	cr = hstate->temp_cr;
+	writel_relaxed(cr & HASH_CR_RESUME_MASK, &device_data->base->cr);
+
+	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
+		hash_mode = HASH_OPER_MODE_HMAC;
+	else
+		hash_mode = HASH_OPER_MODE_HASH;
+
+	for (count = 0; count < HASH_CSR_COUNT; count++) {
+		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
+			break;
+		writel_relaxed(hstate->csr[count],
+			       &device_data->base->csrx[count]);
+	}
+
+	writel_relaxed(hstate->csfull, &device_data->base->csfull);
+	writel_relaxed(hstate->csdatain, &device_data->base->csdatain);
+	writel_relaxed(hstate->str_reg, &device_data->base->str);
+	writel_relaxed(cr, &device_data->base->cr);
+
+	return 0;
 }
 
-static int ahash_noexport(struct ahash_request *req, void *out)
+static int ahash_export(struct ahash_request *req, void *out)
 {
-	return -ENOSYS;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct hash_device_data *device_data = ctx->device;
+	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct hash_state *hstate = out;
+	int hash_mode = HASH_OPER_MODE_HASH;
+	u32 cr;
+	u32 count;
+
+	/*
+	 * Save hardware state:
+	 * Write dummy value to force digest intermediate calculation. This
+	 * actually makes sure that there isn't any ongoing calculation in the
+	 * hardware.
+	 */
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
+		cpu_relax();
+
+	cr = readl_relaxed(&device_data->base->cr);
+
+	hstate->str_reg = readl_relaxed(&device_data->base->str);
+
+	hstate->din_reg = readl_relaxed(&device_data->base->din);
+
+	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
+		hash_mode = HASH_OPER_MODE_HMAC;
+	else
+		hash_mode = HASH_OPER_MODE_HASH;
+
+	for (count = 0; count < HASH_CSR_COUNT; count++) {
+		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
+			break;
+
+		hstate->csr[count] =
+			readl_relaxed(&device_data->base->csrx[count]);
+	}
+
+	hstate->csfull = readl_relaxed(&device_data->base->csfull);
+	hstate->csdatain = readl_relaxed(&device_data->base->csdatain);
+
+	hstate->temp_cr = cr;
+
+	/* Save software state */
+	hstate->length = req_ctx->length;
+	hstate->index = req_ctx->index;
+	hstate->dma_mode = req_ctx->dma_mode;
+	hstate->hw_initialized = req_ctx->hw_initialized;
+	memcpy(hstate->buffer, req_ctx->buffer, HASH_BLOCK_SIZE);
+
+	return 0;
 }
 
 static int hmac_sha1_init(struct ahash_request *req)
@@ -1361,10 +1352,10 @@ static struct hash_algo_template hash_algs[] = {
 			.update = ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha1_digest,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.statesize = sizeof(struct hash_state),
 			.halg.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-ux500",
@@ -1384,10 +1375,10 @@ static struct hash_algo_template hash_algs[] = {
 			.update	= ahash_update,
 			.final = ahash_final,
 			.digest = ahash_sha256_digest,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.statesize = sizeof(struct hash_state),
 			.halg.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-ux500",
@@ -1408,10 +1399,10 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha1_digest,
 			.setkey = hmac_sha1_setkey,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.statesize = sizeof(struct hash_state),
 			.halg.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-ux500",
@@ -1432,10 +1423,10 @@ static struct hash_algo_template hash_algs[] = {
 			.final = ahash_final,
 			.digest = hmac_sha256_digest,
 			.setkey = hmac_sha256_setkey,
-			.export = ahash_noexport,
-			.import = ahash_noimport,
+			.export = ahash_export,
+			.import = ahash_import,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
-			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.statesize = sizeof(struct hash_state),
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-ux500",
-- 
2.36.1

