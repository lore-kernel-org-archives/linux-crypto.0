Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062FAC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE70364E6C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBYS3K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhBYS2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:28:39 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCFFC0617A7
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:23 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id o34so4790482qtd.11
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPKL92vwEKq+QVHwwPqWKXZtqeTS7tcJq/+AN38Hg8Q=;
        b=VRJhTkxdkQimNwQpMHwAD5JhIKgnDzNtHyD0ZzM44wPyPaS4a7b//4xcwpI56sh+Aw
         FCpCxkCD2yyTnQZ4zGL1fL/8cW8dABeqd9c1G8tobetcZ4U7SADTcq6Dis6fmfsM6G9L
         GaFd1W2bxNkP+btujudqTDPAwVFy7fSh37h2WYc7R95Khn95K2PB0CTNGViKg3bRaLUK
         TGGU/wOseB9lqpD3RZ2iVEamLspqVA6JpTiDjuryeOs97M68YGNELMHp7lgxU6xDZ7Z/
         wMPuwi9DgQrwkZuOPKh4NJ/6WpPqH1fmHdOdAKfTsPZdw7lFj7qLpdZIuim4gQXHM/O8
         L7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPKL92vwEKq+QVHwwPqWKXZtqeTS7tcJq/+AN38Hg8Q=;
        b=dQDOFv0d+IAK8J1FgXCwNdGW8RH33fSImCgy0n1inVsEz6OrVWie9RGB9rpn3W/2YQ
         Rs+Ye/oJhUhr4VDgeku6kGevj2ZEadaD9wUGq0T1mmEgsqtJVmw+y+vmnVI5YmciNVz+
         ogXrAUR9kK6YNosofZJ0aceWxc1lYZR3x0fPIPofOjU7bmlc4Dz/mgBZzJCUSiQJMWLm
         uxb7bGVak9uWXxnzltSZSfC7JgyKpBth6DUQrWcl7GyzeD+ZN2f354L3PJR/Bb5a6wbI
         xx3JcafefjEBBquXl/YAhR9MMmc4GkyDFGHqS+APY+DaZ7tjehr6zB6Rr3shV/3nr5c7
         v5rA==
X-Gm-Message-State: AOAM533VG72knuMdlQcONRrwFEdFJlrpNKqwGmI1OiSKWy4mDnrHkPNS
        0T+mPir+c9wPw3KLjBwY44ds0Q==
X-Google-Smtp-Source: ABdhPJxWTD2n7AVQVFzDn7pMU1keIVsA0aXipMoyL0Pkqig+TqhAKuJ9I1LloqhuQ6pU9xuK66ALpQ==
X-Received: by 2002:ac8:7b9d:: with SMTP id p29mr3595210qtu.351.1614277642740;
        Thu, 25 Feb 2021 10:27:22 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:22 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
Date:   Thu, 25 Feb 2021 13:27:15 -0500
Message-Id: <20210225182716.1402449-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add register programming sequence for enabling AEAD
algorithms on the Qualcomm crypto engine.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 05a71c5ecf61..54d209cb0525 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -15,6 +15,16 @@
 #include "core.h"
 #include "regs-v5.h"
 #include "sha.h"
+#include "aead.h"
+
+static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
+	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
+};
+
+static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
+	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
+};
 
 static inline u32 qce_read(struct qce_device *qce, u32 offset)
 {
@@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
 		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
 }
 
-#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
+#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
 static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
 {
 	u32 cfg = 0;
@@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
 
 	return cfg;
 }
+#endif
 
+#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 {
 	struct ahash_request *req = ahash_request_cast(async_req);
@@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 }
 #endif
 
-#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
+#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
 static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
 {
 	u32 cfg = 0;
@@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
 
 	return cfg;
 }
+#endif
 
+#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
 {
 	u8 swap[QCE_AES_IV_LENGTH];
@@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 }
 #endif
 
+#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
+static int qce_setup_regs_aead(struct crypto_async_request *async_req)
+{
+	struct aead_request *req = aead_request_cast(async_req);
+	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
+	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
+	struct qce_device *qce = tmpl->qce;
+	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
+	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
+	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
+	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
+	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
+	unsigned int enc_keylen = ctx->enc_keylen;
+	unsigned int auth_keylen = ctx->auth_keylen;
+	unsigned int enc_ivsize = rctx->ivsize;
+	unsigned int auth_ivsize;
+	unsigned int enckey_words, enciv_words;
+	unsigned int authkey_words, authiv_words, authnonce_words;
+	unsigned long flags = rctx->flags;
+	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;
+	u32 *iv_last_word;
+
+	qce_setup_config(qce);
+
+	/* Write encryption key */
+	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
+	enckey_words = enc_keylen / sizeof(u32);
+	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
+
+	/* Write encryption iv */
+	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
+	enciv_words = enc_ivsize / sizeof(u32);
+	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
+
+	if (IS_CCM(rctx->flags)) {
+		iv_last_word = (u32 *)&enciv[enciv_words - 1];
+//		qce_write(qce, REG_CNTR3_IV3, enciv[enciv_words - 1] + 1);
+		qce_write(qce, REG_CNTR3_IV3, (*iv_last_word) + 1);
+		qce_write_array(qce, REG_ENCR_CCM_INT_CNTR0, (u32 *)enciv, enciv_words);
+		qce_write(qce, REG_CNTR_MASK, ~0);
+		qce_write(qce, REG_CNTR_MASK0, ~0);
+		qce_write(qce, REG_CNTR_MASK1, ~0);
+		qce_write(qce, REG_CNTR_MASK2, ~0);
+	}
+
+	/* Clear authentication IV and KEY registers of previous values */
+	qce_clear_array(qce, REG_AUTH_IV0, 16);
+	qce_clear_array(qce, REG_AUTH_KEY0, 16);
+
+	/* Clear byte count */
+	qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
+
+	/* Write authentication key */
+	qce_cpu_to_be32p_array(authkey, ctx->auth_key, auth_keylen);
+	authkey_words = DIV_ROUND_UP(auth_keylen, sizeof(u32));
+	qce_write_array(qce, REG_AUTH_KEY0, (u32 *)authkey, authkey_words);
+
+	if (IS_SHA_HMAC(rctx->flags)) {
+		/* Write default authentication iv */
+		if (IS_SHA1_HMAC(rctx->flags)) {
+			auth_ivsize = SHA1_DIGEST_SIZE;
+			memcpy(authiv, std_iv_sha1, auth_ivsize);
+		} else if (IS_SHA256_HMAC(rctx->flags)) {
+			auth_ivsize = SHA256_DIGEST_SIZE;
+			memcpy(authiv, std_iv_sha256, auth_ivsize);
+		}
+		authiv_words = auth_ivsize / sizeof(u32);
+		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
+	}
+
+	if (IS_CCM(rctx->flags)) {
+		qce_cpu_to_be32p_array(authnonce, rctx->ccm_nonce, QCE_MAX_NONCE);
+		authnonce_words = QCE_MAX_NONCE / sizeof(u32);
+		qce_write_array(qce, REG_AUTH_INFO_NONCE0, (u32 *)authnonce, authnonce_words);
+	}
+
+	/* Set up ENCR_SEG_CFG */
+	encr_cfg = qce_encr_cfg(flags, enc_keylen);
+	if (IS_ENCRYPT(flags))
+		encr_cfg |= BIT(ENCODE_SHIFT);
+	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
+
+	/* Set up AUTH_SEG_CFG */
+	auth_cfg = qce_auth_cfg(rctx->flags, auth_keylen, ctx->authsize);
+	auth_cfg |= BIT(AUTH_LAST_SHIFT);
+	auth_cfg |= BIT(AUTH_FIRST_SHIFT);
+	if (IS_ENCRYPT(flags)) {
+		if (IS_CCM(rctx->flags))
+			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
+		else
+			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
+	} else {
+		if (IS_CCM(rctx->flags))
+			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
+		else
+			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
+	}
+	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
+
+	totallen = rctx->cryptlen + rctx->assoclen;
+
+	/* Set the encryption size and start offset */
+	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
+		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen + ctx->authsize);
+	else
+		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
+	qce_write(qce, REG_ENCR_SEG_START, rctx->assoclen & 0xffff);
+
+	/* Set the authentication size and start offset */
+	qce_write(qce, REG_AUTH_SEG_SIZE, totallen);
+	qce_write(qce, REG_AUTH_SEG_START, 0);
+
+	/* Write total length */
+	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
+		qce_write(qce, REG_SEG_SIZE, totallen + ctx->authsize);
+	else
+		qce_write(qce, REG_SEG_SIZE, totallen);
+
+	/* get little endianness */
+	config = qce_config_reg(qce, 1);
+	qce_write(qce, REG_CONFIG, config);
+
+	/* Start the process */
+	if (IS_CCM(flags))
+		qce_crypto_go(qce, 0);
+	else
+		qce_crypto_go(qce, 1);
+
+	return 0;
+}
+#endif
+
 int qce_start(struct crypto_async_request *async_req, u32 type)
 {
 	switch (type) {
@@ -396,6 +543,10 @@ int qce_start(struct crypto_async_request *async_req, u32 type)
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	case CRYPTO_ALG_TYPE_AHASH:
 		return qce_setup_regs_ahash(async_req);
+#endif
+#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
+	case CRYPTO_ALG_TYPE_AEAD:
+		return qce_setup_regs_aead(async_req);
 #endif
 	default:
 		return -EINVAL;
-- 
2.25.1

