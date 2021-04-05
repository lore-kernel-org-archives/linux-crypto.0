Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B45DC433ED
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24490613DA
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhDEWS7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 18:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbhDEWS6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 18:18:58 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB177C061756
        for <linux-crypto@vger.kernel.org>; Mon,  5 Apr 2021 15:18:51 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n8so13033096oie.10
        for <linux-crypto@vger.kernel.org>; Mon, 05 Apr 2021 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gq3G6MnPPfqTLkiC0H2kPQc5jwJboJ6Jm4w03Zc++/I=;
        b=QdKTwf2nrIjTaWF2UVwFwOyWwa7dCGhEhoV5K9qEhDBTIfxnDvmt1my5oWxh3/Nv41
         CDYid9YcVDBd9uAfGBEWkcVbR7FGEDcH8as0xhuDWKDJ5A0FJdVcgXjmdYi7WKfPXITD
         hoGG4eOrEfaukBNiXWvCq/j80Qv8PB9/DwnQSet2Ag3i8rIOLyqAF4SudChjIuQ76Hq6
         RwQe0F/9UTQHq+w2IPKLf7U4P3X1Fm7I9AzA/2S3FIyHH2AjZD4jVubHBOoKmoqKHBvQ
         Dsd6N+4ox4KP/nkB12Q6otICk3Q41CI8C3/FijUkjc0fvAX1Vfu1iaBEu/aAoi0To709
         BswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gq3G6MnPPfqTLkiC0H2kPQc5jwJboJ6Jm4w03Zc++/I=;
        b=AjMNSaJkY0B0TYB4resgxzMe7iAQlkP+OnfJk/Kk+sLutAVqsStUIP9/Qe+0zhTiG5
         QMHuJIFy1/QP1hVckJfGVxFIJWsA5CqE2iHFbxQUHZyGZ66J/FUZLXx2gAqQKIpTyWWs
         BxcP2qPuxHaq1yc/f2o+t+ygGe2+JBbjYxF7q1EPEghCFGboWE0/1HOQpQRvoMnVpzPR
         U+lPg2FJU53aidFsgsA2N07kG4NyBPAbU46d54cWxfVoy8lnEC0S9WnI6yk31yT8AVdc
         8FOKzfOw5/OgZwlCYwAVdT3Za+nhqKRSvHg1sA7QshyNMC2pKaa2fpj8AwHcXeoO1bsL
         d/cQ==
X-Gm-Message-State: AOAM532ET392v7tC4Vxbjh/eXnFlpMike9X6xZsGKt0foZGSC7B8xQ89
        ZajdNfnSAXzRYEKxSFWN82LTcQ==
X-Google-Smtp-Source: ABdhPJwArqyPv0KBOtN2FIWflyRvFGk1hmtFjg2TR7WiDYGZt0mrYC7yvNlraQr2ObImiG101qdTAQ==
X-Received: by 2002:a05:6808:1444:: with SMTP id x4mr920986oiv.142.1617661131068;
        Mon, 05 Apr 2021 15:18:51 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id o10sm4242246ote.5.2021.04.05.15.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 15:18:50 -0700 (PDT)
Date:   Mon, 5 Apr 2021 17:18:48 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
Message-ID: <20210405221848.GA904837@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225182716.1402449-7-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:

> Add register programming sequence for enabling AEAD
> algorithms on the Qualcomm crypto engine.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 153 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index 05a71c5ecf61..54d209cb0525 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -15,6 +15,16 @@
>  #include "core.h"
>  #include "regs-v5.h"
>  #include "sha.h"
> +#include "aead.h"
> +
> +static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> +	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
> +};
> +
> +static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> +	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
> +	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
> +};
>  
>  static inline u32 qce_read(struct qce_device *qce, u32 offset)
>  {
> @@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
>  		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
>  }
>  
> -#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> +#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>  static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>  {
>  	u32 cfg = 0;
> @@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>  
>  	return cfg;
>  }
> +#endif
>  
> +#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>  static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>  {
>  	struct ahash_request *req = ahash_request_cast(async_req);
> @@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>  }
>  #endif
>  
> -#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
> +#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>  static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>  {
>  	u32 cfg = 0;
> @@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>  
>  	return cfg;
>  }
> +#endif
>  
> +#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>  static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
>  {
>  	u8 swap[QCE_AES_IV_LENGTH];
> @@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
>  }
>  #endif
>  
> +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
> +static int qce_setup_regs_aead(struct crypto_async_request *async_req)
> +{
> +	struct aead_request *req = aead_request_cast(async_req);
> +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
> +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
> +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
> +	struct qce_device *qce = tmpl->qce;
> +	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
> +	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
> +	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
> +	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
> +	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
> +	unsigned int enc_keylen = ctx->enc_keylen;
> +	unsigned int auth_keylen = ctx->auth_keylen;
> +	unsigned int enc_ivsize = rctx->ivsize;
> +	unsigned int auth_ivsize;
> +	unsigned int enckey_words, enciv_words;
> +	unsigned int authkey_words, authiv_words, authnonce_words;
> +	unsigned long flags = rctx->flags;
> +	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;

I don't see any reason to initialize encr_cfg or auth_cfg.

> +	u32 *iv_last_word;
> +
> +	qce_setup_config(qce);
> +
> +	/* Write encryption key */
> +	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
> +	enckey_words = enc_keylen / sizeof(u32);
> +	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);

Afaict all "array registers" in this function are affected by the
CRYPTO_SETUP little endian bit, but you set this bit before launching
the operation dependent on IS_CCM(). So is this really working for the
!IS_CCM() case?

> +
> +	/* Write encryption iv */
> +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
> +	enciv_words = enc_ivsize / sizeof(u32);
> +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);

It would be nice if this snippet was extracted to a helper function.

> +
> +	if (IS_CCM(rctx->flags)) {
> +		iv_last_word = (u32 *)&enciv[enciv_words - 1];
> +//		qce_write(qce, REG_CNTR3_IV3, enciv[enciv_words - 1] + 1);

I believe this is a remnant of the two surrounding lines.

> +		qce_write(qce, REG_CNTR3_IV3, (*iv_last_word) + 1);

enciv is an array of big endian 32-bit integers, which you tell the
compiler to treat as cpu-native endian, and then you do math on it.
Afaict from the documentation the value of REG_CNTR3_IVn should be set
to rctx->iv + 1, but if the hardware expects these in big endian then I
think you added 16777216.

Perhaps I'm missing something here though?

PS. Based on how the documentation is written, shouldn't you write out
REG_CNTR_IV[012] as well?

> +		qce_write_array(qce, REG_ENCR_CCM_INT_CNTR0, (u32 *)enciv, enciv_words);
> +		qce_write(qce, REG_CNTR_MASK, ~0);
> +		qce_write(qce, REG_CNTR_MASK0, ~0);
> +		qce_write(qce, REG_CNTR_MASK1, ~0);
> +		qce_write(qce, REG_CNTR_MASK2, ~0);
> +	}
> +
> +	/* Clear authentication IV and KEY registers of previous values */
> +	qce_clear_array(qce, REG_AUTH_IV0, 16);
> +	qce_clear_array(qce, REG_AUTH_KEY0, 16);
> +
> +	/* Clear byte count */
> +	qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
> +
> +	/* Write authentication key */
> +	qce_cpu_to_be32p_array(authkey, ctx->auth_key, auth_keylen);
> +	authkey_words = DIV_ROUND_UP(auth_keylen, sizeof(u32));
> +	qce_write_array(qce, REG_AUTH_KEY0, (u32 *)authkey, authkey_words);
> +
> +	if (IS_SHA_HMAC(rctx->flags)) {
> +		/* Write default authentication iv */
> +		if (IS_SHA1_HMAC(rctx->flags)) {
> +			auth_ivsize = SHA1_DIGEST_SIZE;
> +			memcpy(authiv, std_iv_sha1, auth_ivsize);
> +		} else if (IS_SHA256_HMAC(rctx->flags)) {
> +			auth_ivsize = SHA256_DIGEST_SIZE;
> +			memcpy(authiv, std_iv_sha256, auth_ivsize);
> +		}
> +		authiv_words = auth_ivsize / sizeof(u32);
> +		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);

AUTH_IV0 is affected by the little endian configuration, does this imply
that IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags? If so
I think it would be nice if you grouped the conditionals in a way that
made that obvious when reading the function.

> +	}
> +
> +	if (IS_CCM(rctx->flags)) {
> +		qce_cpu_to_be32p_array(authnonce, rctx->ccm_nonce, QCE_MAX_NONCE);
> +		authnonce_words = QCE_MAX_NONCE / sizeof(u32);
> +		qce_write_array(qce, REG_AUTH_INFO_NONCE0, (u32 *)authnonce, authnonce_words);
> +	}
> +
> +	/* Set up ENCR_SEG_CFG */
> +	encr_cfg = qce_encr_cfg(flags, enc_keylen);
> +	if (IS_ENCRYPT(flags))
> +		encr_cfg |= BIT(ENCODE_SHIFT);
> +	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
> +
> +	/* Set up AUTH_SEG_CFG */
> +	auth_cfg = qce_auth_cfg(rctx->flags, auth_keylen, ctx->authsize);
> +	auth_cfg |= BIT(AUTH_LAST_SHIFT);
> +	auth_cfg |= BIT(AUTH_FIRST_SHIFT);
> +	if (IS_ENCRYPT(flags)) {
> +		if (IS_CCM(rctx->flags))
> +			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
> +		else
> +			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
> +	} else {
> +		if (IS_CCM(rctx->flags))
> +			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
> +		else
> +			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
> +	}
> +	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
> +
> +	totallen = rctx->cryptlen + rctx->assoclen;
> +
> +	/* Set the encryption size and start offset */
> +	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
> +		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen + ctx->authsize);
> +	else
> +		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
> +	qce_write(qce, REG_ENCR_SEG_START, rctx->assoclen & 0xffff);
> +
> +	/* Set the authentication size and start offset */
> +	qce_write(qce, REG_AUTH_SEG_SIZE, totallen);
> +	qce_write(qce, REG_AUTH_SEG_START, 0);
> +
> +	/* Write total length */
> +	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
> +		qce_write(qce, REG_SEG_SIZE, totallen + ctx->authsize);
> +	else
> +		qce_write(qce, REG_SEG_SIZE, totallen);
> +
> +	/* get little endianness */
> +	config = qce_config_reg(qce, 1);
> +	qce_write(qce, REG_CONFIG, config);
> +
> +	/* Start the process */
> +	if (IS_CCM(flags))
> +		qce_crypto_go(qce, 0);

Second parameter is defined as "bool", please use "false" here (and true
below). Or

	qce_crypto_go(qce, !IS_CCM(flags));

Regards,
Bjorn

> +	else
> +		qce_crypto_go(qce, 1);
> +
> +	return 0;
> +}
> +#endif
> +
>  int qce_start(struct crypto_async_request *async_req, u32 type)
>  {
>  	switch (type) {
> @@ -396,6 +543,10 @@ int qce_start(struct crypto_async_request *async_req, u32 type)
>  #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>  	case CRYPTO_ALG_TYPE_AHASH:
>  		return qce_setup_regs_ahash(async_req);
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
> +	case CRYPTO_ALG_TYPE_AEAD:
> +		return qce_setup_regs_aead(async_req);
>  #endif
>  	default:
>  		return -EINVAL;
> -- 
> 2.25.1
> 
