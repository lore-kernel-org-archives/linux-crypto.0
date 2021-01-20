Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28D2C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 18:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB667233CE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 18:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbhATSvz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389703AbhATSuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 13:50:50 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D349C061793
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:49 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 143so26283729qke.10
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1e7KxCkB9ALHgGjl5vPgq64Nql5G6JqmYVRXhWLnCVk=;
        b=o5f0+xX5rIcHFnJXAXckT0q0cemgXpY4fo/gCTWdzPAqp5MAUjYxbNdXXXZe9u3mw7
         Rk6nk/oKTZEwA2pv8lx1bIDxoGFF2TjIG89jbW/TDYg3OW4rM01HK/hN7f6jM8XaSytt
         E1+/eRXTgT158KLOstokIiYkA/rkBUXHuJQQiBGyX5t7ZqZaDm9PrQRQMSFjJQLEl+UC
         Kt1IShnOm5+6i+pBx2gK8wBcdLgDT5AFODUX27MvLOCLmKzyZBQCjSIbM7azNFnOCcmh
         UYlgG9Sxwci3nN6T2GO++rhK/glK3KIjil37NqbkOXprhgp67KravxDM/dlW2pvE7x+1
         PMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1e7KxCkB9ALHgGjl5vPgq64Nql5G6JqmYVRXhWLnCVk=;
        b=pS2HkDjXMFhiuXKbexBqEbvVqL7FEIbnQY8nfAERhpePxEfM0qp0kNwqSI3po8kSgN
         v8gneFmYZ+B/tno93Zgnd8FofL1Ped2RO0rOC7fBNln7NysQXET91p07X0MgbtBQamIP
         jUTMtinM2lkdcriRt6uYoBa0gjhErEvOq4vB3BlYjsFUbM90/uN1taDULUtTod7pLAqT
         drk6VRKxxGBgOiIVwcVvQ3CCdyBwJATWUQzVqEgjR0XIE7h5UdZJ1repAtBUsJBzss8l
         QX9yimbNt9bNxSCCr03MbB3PsW9LMdOud61kcyEtq/AAahvAXQWRj4VYKetLgyVgVXrF
         MghQ==
X-Gm-Message-State: AOAM5312c9izs4I1R4PqfYXFYEDrd2QkUTXfZ1FSI/RYY4CKtmqOQEJ8
        KaOx8lTMe2HzzsoIbPGEMKiRBQ==
X-Google-Smtp-Source: ABdhPJynesls9+r0vHdAVJoRkK/3YzmxwztH1E26jYOb35RbtTQR/xJdTAayra8NQ2jztD1iTB5IvA==
X-Received: by 2002:a37:78c4:: with SMTP id t187mr10762600qkc.139.1611168528355;
        Wed, 20 Jan 2021 10:48:48 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id w8sm1769903qts.50.2021.01.20.10.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:48:47 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] drivers: crypto: qce: skcipher: Fix regressions found during fuzz testing
Date:   Wed, 20 Jan 2021 13:48:40 -0500
Message-Id: <20210120184843.3217775-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120184843.3217775-1-thara.gopinath@linaro.org>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch contains the following fixes for the supported encryption
algorithms in the Qualcomm crypto engine(CE)
1. Return unsupported if key1 = key2 for AES XTS algorithm since CE
does not support this and the operation causes the engine to hang.
2. Return unsupported if any three keys are same for DES3 algorithms
since CE does not support this and the operation causes the engine to
hang.
3. Return unsupported for 0 length plain texts since crypto engine BAM
dma does not support 0 length data.
4. ECB messages do not have an IV and hence set the ivsize to 0.
5. Ensure that the data passed for ECB/CBC encryption/decryption is
blocksize aligned. Otherwise the CE hangs on the operation.
6. Allow messages of length less that 512 bytes for all other encryption
algorithms other than AES XTS. The recommendation is only for AES XTS
to have data size greater than 512 bytes.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v2->v3:
	- Made the comparison between keys to check if any two keys are
	  same for triple des algorithms constant-time as per
	  Nym Seddon's suggestion.

 drivers/crypto/qce/skcipher.c | 68 ++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index a2d3da0ad95f..d78b932441ab 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -167,16 +167,32 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ablk);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	unsigned long flags = to_cipher_tmpl(ablk)->alg_flags;
+	unsigned int __keylen;
 	int ret;
 
 	if (!key || !keylen)
 		return -EINVAL;
 
-	switch (IS_XTS(flags) ? keylen >> 1 : keylen) {
+	/*
+	 * AES XTS key1 = key2 not supported by crypto engine.
+	 * Revisit to request a fallback cipher in this case.
+	 */
+	if (IS_XTS(flags)) {
+		__keylen = keylen >> 1;
+		if (!memcmp(key, key + __keylen, __keylen))
+			return -EINVAL;
+	} else {
+		__keylen = keylen;
+	}
+	switch (__keylen) {
 	case AES_KEYSIZE_128:
 	case AES_KEYSIZE_256:
 		memcpy(ctx->enc_key, key, keylen);
 		break;
+	case AES_KEYSIZE_192:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
@@ -204,12 +220,27 @@ static int qce_des3_setkey(struct crypto_skcipher *ablk, const u8 *key,
 			   unsigned int keylen)
 {
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
+	u32 _key[6];
 	int err;
 
 	err = verify_skcipher_des3_key(ablk, key);
 	if (err)
 		return err;
 
+	/*
+	 * The crypto engine does not support any two keys
+	 * being the same for triple des algorithms. The
+	 * verify_skcipher_des3_key does not check for all the
+	 * below conditions. Return -ENOKEY in case any two keys
+	 * are the same. Revisit to see if a fallback cipher
+	 * is needed to handle this condition.
+	 */
+	memcpy(_key, key, DES3_EDE_KEY_SIZE);
+	if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) |
+	    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) |
+	    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
+		return -ENOKEY;
+
 	ctx->enc_keylen = keylen;
 	memcpy(ctx->enc_key, key, keylen);
 	return 0;
@@ -221,6 +252,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	int keylen;
 	int ret;
 
@@ -228,14 +260,34 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
-	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
-	 * is not a multiple of it; pass such requests to the fallback
+	/* CE does not handle 0 length messages */
+	if (!req->cryptlen)
+		return -EINVAL;
+
+	/*
+	 * ECB and CBC algorithms require message lengths to be
+	 * multiples of block size.
+	 * TODO: The spec says AES CBC mode for certain versions
+	 * of crypto engine can handle partial blocks as well.
+	 * Test and enable such messages.
+	 */
+	if (IS_ECB(rctx->flags) || IS_CBC(rctx->flags))
+		if (!IS_ALIGNED(req->cryptlen, blocksize))
+			return -EINVAL;
+
+	/*
+	 * Conditions for requesting a fallback cipher
+	 * AES-192 (not supported by crypto engine (CE))
+	 * AES-XTS request with len <= 512 byte (not recommended to use CE)
+	 * AES-XTS request with len > QCE_SECTOR_SIZE and
+	 * is not a multiple of it.(Revisit this condition to check if it is
+	 * needed in all versions of CE)
 	 */
 	if (IS_AES(rctx->flags) &&
-	    (((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
-	      req->cryptlen <= aes_sw_max_len) ||
-	     (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
-	      req->cryptlen % QCE_SECTOR_SIZE))) {
+	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
+	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
+	    (req->cryptlen > QCE_SECTOR_SIZE &&
+	    req->cryptlen % QCE_SECTOR_SIZE))))) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,
@@ -307,7 +359,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 	},
-- 
2.25.1

