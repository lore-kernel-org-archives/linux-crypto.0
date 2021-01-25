Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470EAC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA92221E5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbhAYQ0h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730763AbhAYQZx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 11:25:53 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106BFC061788
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:25:13 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d1so13237632otl.13
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KLhKRtgeJ+2sRx58ZlTjQzSVRy9woj1CcpkOodtGDmc=;
        b=yPd8UfDeWLMehfS5LV06ocnlP6qW/7ep5g0yzZUQwCqfJVjWXRiCGK8dv4G4epvJ3E
         wPKwbPXb/rzSCyyv/Lc4eqCUZAUZYCP67krU4E6A1ZsA33/u58wLwe94QG+WIywQRaGk
         vzAXErfcl7KzVzOYR8OrCsfZuCM1sf8oAlEurXFe8wM0KIE1F3BGyk2EbgF+y8vFa42F
         6ng05cte0YjlINhwmMbQc+xn2YC/bXhjjH59SREPscQE8HmTDf9qeTzgHip4eBj2mtXC
         rvPWN3cABIy7BrnRvuzHG2bHclx7fQDP1wgZQ5oP6xsJvI8ay1am6aA/7Z1WnoDeT+Tq
         jtAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KLhKRtgeJ+2sRx58ZlTjQzSVRy9woj1CcpkOodtGDmc=;
        b=q8hmIOfwUsjslsQeid31xNjlmv5TbCZrvo8cGz0sBxir/sfNgcstxc0X7xud9CuDnj
         ES/z6ygOZRnpPoKAPyryVnC8b5P7aD+MCix3E5crqOC8PX+FXHq2LP3WAjYNESiEERyy
         2SkCrCCYukvhIo99Zh9nNzJwl8DYXvkrTYaMy6nxa1dY7KEfC2PPevuH56zTT1rV2r5g
         1WbGBBbB4ES/X7U94ehmrybgf/euUFquTPT23KzjAnqmozwLiVOyqvMLBycgaKfd5niQ
         roI2U6n+KBAr0ItKHyBscivZuZMyl+Ndmb4vr0IT3hrgyaWkfaO5RZLDF3j/Q+3q667r
         vv0w==
X-Gm-Message-State: AOAM532Ux6sBVLApl4RQ4QridPDQ8G1j5PxSUsxdh4wPdSSkMmkkqtHV
        EPaOBTAYPK7PL41p9mgZ9bK97A==
X-Google-Smtp-Source: ABdhPJx+2x08xXpPFpyeCPmzZYM6V5JbIV/1q2hyn+nq63lcg3m5cjTfpxmxB56iFVW0sB78f0czSQ==
X-Received: by 2002:a05:6830:157:: with SMTP id j23mr1042468otp.240.1611591912296;
        Mon, 25 Jan 2021 08:25:12 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id r10sm3631796oib.31.2021.01.25.08.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:25:11 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:25:09 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] drivers: crypto: qce: skcipher: Fix regressions
 found during fuzz testing
Message-ID: <YA7w5W0Rhyiy5hs4@builder.lan>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
 <20210120184843.3217775-4-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184843.3217775-4-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 20 Jan 12:48 CST 2021, Thara Gopinath wrote:

> This patch contains the following fixes for the supported encryption
> algorithms in the Qualcomm crypto engine(CE)
> 1. Return unsupported if key1 = key2 for AES XTS algorithm since CE
> does not support this and the operation causes the engine to hang.
> 2. Return unsupported if any three keys are same for DES3 algorithms
> since CE does not support this and the operation causes the engine to
> hang.
> 3. Return unsupported for 0 length plain texts since crypto engine BAM
> dma does not support 0 length data.
> 4. ECB messages do not have an IV and hence set the ivsize to 0.
> 5. Ensure that the data passed for ECB/CBC encryption/decryption is
> blocksize aligned. Otherwise the CE hangs on the operation.
> 6. Allow messages of length less that 512 bytes for all other encryption
> algorithms other than AES XTS. The recommendation is only for AES XTS
> to have data size greater than 512 bytes.
> 

This seems like 6 trivial changes, that if send individually will be
easy to reason about and if there's ever any regressions it will be easy
to bisect.

So please split this patch.

Regards,
Bjorn

> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
> 
> v2->v3:
> 	- Made the comparison between keys to check if any two keys are
> 	  same for triple des algorithms constant-time as per
> 	  Nym Seddon's suggestion.
> 
>  drivers/crypto/qce/skcipher.c | 68 ++++++++++++++++++++++++++++++-----
>  1 file changed, 60 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
> index a2d3da0ad95f..d78b932441ab 100644
> --- a/drivers/crypto/qce/skcipher.c
> +++ b/drivers/crypto/qce/skcipher.c
> @@ -167,16 +167,32 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
>  	struct crypto_tfm *tfm = crypto_skcipher_tfm(ablk);
>  	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	unsigned long flags = to_cipher_tmpl(ablk)->alg_flags;
> +	unsigned int __keylen;
>  	int ret;
>  
>  	if (!key || !keylen)
>  		return -EINVAL;
>  
> -	switch (IS_XTS(flags) ? keylen >> 1 : keylen) {
> +	/*
> +	 * AES XTS key1 = key2 not supported by crypto engine.
> +	 * Revisit to request a fallback cipher in this case.
> +	 */
> +	if (IS_XTS(flags)) {
> +		__keylen = keylen >> 1;
> +		if (!memcmp(key, key + __keylen, __keylen))
> +			return -EINVAL;
> +	} else {
> +		__keylen = keylen;
> +	}
> +	switch (__keylen) {
>  	case AES_KEYSIZE_128:
>  	case AES_KEYSIZE_256:
>  		memcpy(ctx->enc_key, key, keylen);
>  		break;
> +	case AES_KEYSIZE_192:
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
> @@ -204,12 +220,27 @@ static int qce_des3_setkey(struct crypto_skcipher *ablk, const u8 *key,
>  			   unsigned int keylen)
>  {
>  	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
> +	u32 _key[6];
>  	int err;
>  
>  	err = verify_skcipher_des3_key(ablk, key);
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * The crypto engine does not support any two keys
> +	 * being the same for triple des algorithms. The
> +	 * verify_skcipher_des3_key does not check for all the
> +	 * below conditions. Return -ENOKEY in case any two keys
> +	 * are the same. Revisit to see if a fallback cipher
> +	 * is needed to handle this condition.
> +	 */
> +	memcpy(_key, key, DES3_EDE_KEY_SIZE);
> +	if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) |
> +	    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) |
> +	    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
> +		return -ENOKEY;
> +
>  	ctx->enc_keylen = keylen;
>  	memcpy(ctx->enc_key, key, keylen);
>  	return 0;
> @@ -221,6 +252,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
>  	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
>  	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
> +	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
>  	int keylen;
>  	int ret;
>  
> @@ -228,14 +260,34 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
>  	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
>  	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
>  
> -	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
> -	 * is not a multiple of it; pass such requests to the fallback
> +	/* CE does not handle 0 length messages */
> +	if (!req->cryptlen)
> +		return -EINVAL;
> +
> +	/*
> +	 * ECB and CBC algorithms require message lengths to be
> +	 * multiples of block size.
> +	 * TODO: The spec says AES CBC mode for certain versions
> +	 * of crypto engine can handle partial blocks as well.
> +	 * Test and enable such messages.
> +	 */
> +	if (IS_ECB(rctx->flags) || IS_CBC(rctx->flags))
> +		if (!IS_ALIGNED(req->cryptlen, blocksize))
> +			return -EINVAL;
> +
> +	/*
> +	 * Conditions for requesting a fallback cipher
> +	 * AES-192 (not supported by crypto engine (CE))
> +	 * AES-XTS request with len <= 512 byte (not recommended to use CE)
> +	 * AES-XTS request with len > QCE_SECTOR_SIZE and
> +	 * is not a multiple of it.(Revisit this condition to check if it is
> +	 * needed in all versions of CE)
>  	 */
>  	if (IS_AES(rctx->flags) &&
> -	    (((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
> -	      req->cryptlen <= aes_sw_max_len) ||
> -	     (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
> -	      req->cryptlen % QCE_SECTOR_SIZE))) {
> +	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
> +	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
> +	    (req->cryptlen > QCE_SECTOR_SIZE &&
> +	    req->cryptlen % QCE_SECTOR_SIZE))))) {
>  		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>  		skcipher_request_set_callback(&rctx->fallback_req,
>  					      req->base.flags,
> @@ -307,7 +359,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
>  		.name		= "ecb(aes)",
>  		.drv_name	= "ecb-aes-qce",
>  		.blocksize	= AES_BLOCK_SIZE,
> -		.ivsize		= AES_BLOCK_SIZE,
> +		.ivsize		= 0,
>  		.min_keysize	= AES_MIN_KEY_SIZE,
>  		.max_keysize	= AES_MAX_KEY_SIZE,
>  	},
> -- 
> 2.25.1
> 
