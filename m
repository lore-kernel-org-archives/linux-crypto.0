Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520FDC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 21:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 289EB6120E
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 21:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhDMVcU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhDMVcU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 17:32:20 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F49C061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 14:32:00 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 30so8885250qva.9
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 14:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nxMWXDBC0LJ7v4Qp9G3rcuNoE2Q8i3XYQtAcfovO3WM=;
        b=Ob/iq8RG9ZSjzdcGJTQzrRCTZn1tZMkoVDkoP8US2yQlBAcp6RiRnPs9xV25DTVrIj
         iWFQPN8RySzVmX6ikPjiKu1kyBOPdKluqb+PA/ryfKz+IapxCmxq5bZ7VYQ6Q8m9VzsE
         4IqmLRTaRhZ/JXr/O+gLYodwG8ofd82yI14pNIDk/aYX9wCK4cBLSL1qptHDLX+ALZYW
         t/NQ+bZjB6ZdZE0ER9lkhsw6AGRBzr+ap00BJyklIS0aAS015b7RQzrL2HQuoPUtVgcV
         9DJ2xvo01xeDuXol2FNtcGTQU4/0OhM9KyV7bn+hp/XqPlO0+T6eFDHJAH1Cofa+/KtL
         aJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxMWXDBC0LJ7v4Qp9G3rcuNoE2Q8i3XYQtAcfovO3WM=;
        b=YrB8VAb3YRxO4+iKso3sw0bvB8PvNnl0eS/sRwwPpPKP69Jhvh0mduMoftN3CB0bfY
         x9+kiwsdm/TeVQecgbjKTt/opBoHyib/Ql7oz/8W1CY7SpoJTdDx3aVJWlCjykzwSxyV
         S/STkyj17XgNxC6KBuVA/ciGBYZWAumOwse6hxTdSPrG2rGaaYljzM3xGHlCKtQ4mlmK
         3unDpX1tR5a0uZWj592kCzYv9T4QJoF7ieovHqIhVfkW4B2V7PHvXsclU7oR6bk927oz
         cONju39LdOHxkypbHE/1SlAyJ/FuJvuo9OVmns46r1SyUelvt6i1kyCbgyxcRqh/iFOA
         fyGQ==
X-Gm-Message-State: AOAM533JZN9vXtaGJAmVDIVJ2wCHdvCOIYn8pCD+0QEGp031YZhAkzOw
        iQoeLxdlXZiwtJ3ROlJ96A+CgQ==
X-Google-Smtp-Source: ABdhPJx6VAP68B7NzJ/anJobEMtL6nxwdN1p5o95ufsaXaACglPjr3QadKu8Mr3nB3ixLqzoueBkYQ==
X-Received: by 2002:ad4:4625:: with SMTP id x5mr35498156qvv.55.1618349519319;
        Tue, 13 Apr 2021 14:31:59 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id j30sm10742849qka.57.2021.04.13.14.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 14:31:58 -0700 (PDT)
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <cab25283-1ad6-2107-8a5e-230a3a7358b5@linaro.org>
Date:   Tue, 13 Apr 2021 17:31:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210405221848.GA904837@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hi Bjorn,

On 4/5/21 6:18 PM, Bjorn Andersson wrote:
> On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> 
>> Add register programming sequence for enabling AEAD
>> algorithms on the Qualcomm crypto engine.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> ---
>>   drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 153 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
>> index 05a71c5ecf61..54d209cb0525 100644
>> --- a/drivers/crypto/qce/common.c
>> +++ b/drivers/crypto/qce/common.c
>> @@ -15,6 +15,16 @@
>>   #include "core.h"
>>   #include "regs-v5.h"
>>   #include "sha.h"
>> +#include "aead.h"
>> +
>> +static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
>> +	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
>> +};
>> +
>> +static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
>> +	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
>> +	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
>> +};
>>   
>>   static inline u32 qce_read(struct qce_device *qce, u32 offset)
>>   {
>> @@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
>>   		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
>>   }
>>   
>> -#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>> +#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>>   static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>>   {
>>   	u32 cfg = 0;
>> @@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>>   
>>   	return cfg;
>>   }
>> +#endif
>>   
>> +#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>>   static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>>   {
>>   	struct ahash_request *req = ahash_request_cast(async_req);
>> @@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>>   }
>>   #endif
>>   
>> -#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>> +#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>>   static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>>   {
>>   	u32 cfg = 0;
>> @@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>>   
>>   	return cfg;
>>   }
>> +#endif
>>   
>> +#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>>   static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
>>   {
>>   	u8 swap[QCE_AES_IV_LENGTH];
>> @@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
>>   }
>>   #endif
>>   
>> +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
>> +static int qce_setup_regs_aead(struct crypto_async_request *async_req)
>> +{
>> +	struct aead_request *req = aead_request_cast(async_req);
>> +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
>> +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
>> +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
>> +	struct qce_device *qce = tmpl->qce;
>> +	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
>> +	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
>> +	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
>> +	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
>> +	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
>> +	unsigned int enc_keylen = ctx->enc_keylen;
>> +	unsigned int auth_keylen = ctx->auth_keylen;
>> +	unsigned int enc_ivsize = rctx->ivsize;
>> +	unsigned int auth_ivsize;
>> +	unsigned int enckey_words, enciv_words;
>> +	unsigned int authkey_words, authiv_words, authnonce_words;
>> +	unsigned long flags = rctx->flags;
>> +	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;
> 
> I don't see any reason to initialize encr_cfg or auth_cfg.

right.. I will remove it

> 
>> +	u32 *iv_last_word;
>> +
>> +	qce_setup_config(qce);
>> +
>> +	/* Write encryption key */
>> +	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
>> +	enckey_words = enc_keylen / sizeof(u32);
>> +	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
> 
> Afaict all "array registers" in this function are affected by the
> CRYPTO_SETUP little endian bit, but you set this bit before launching
> the operation dependent on IS_CCM(). So is this really working for the
> !IS_CCM() case?

I am not sure I understand you. Below ,
	/* get little endianness */
	config = qce_config_reg(qce, 1);
	qce_write(qce, REG_CONFIG, config);

is outside of any checks..

> 
>> +
>> +	/* Write encryption iv */
>> +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
>> +	enciv_words = enc_ivsize / sizeof(u32);
>> +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
> 
> It would be nice if this snippet was extracted to a helper function.
> 
>> +
>> +	if (IS_CCM(rctx->flags)) {
>> +		iv_last_word = (u32 *)&enciv[enciv_words - 1];
>> +//		qce_write(qce, REG_CNTR3_IV3, enciv[enciv_words - 1] + 1);
> 
> I believe this is a remnant of the two surrounding lines.

It indeed is.. I will remove it.

> 
>> +		qce_write(qce, REG_CNTR3_IV3, (*iv_last_word) + 1);
> 
> enciv is an array of big endian 32-bit integers, which you tell the
> compiler to treat as cpu-native endian, and then you do math on it.
> Afaict from the documentation the value of REG_CNTR3_IVn should be set
> to rctx->iv + 1, but if the hardware expects these in big endian then I
> think you added 16777216.

So, the crypto engine documentation talks of writing to these registers 
in little endian mode. The byte stream that you get for iv from the user
is in big endian mode as in the MSB is byte 0. So we kind of invert this 
and write  to these registers. This is what happens with declaring the 
__be32 array and copying words to it from the byte stream. So now byte 0 
is the LSB and a +1 will just add a 1 to it.

I suspect from what I read in the documentation we could get away by 
removing this and writing the big endian byte stream directly and never 
setting the little endian in config register. Though I am not sure if 
this has ever been tested out. If we change it, it will be across 
algorithms and as a separate effort.

> 
> Perhaps I'm missing something here though?
> 
> PS. Based on how the documentation is written, shouldn't you write out
> REG_CNTR_IV[012] as well?

It is done on top, right ?
qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);

> 
>> +		qce_write_array(qce, REG_ENCR_CCM_INT_CNTR0, (u32 *)enciv, enciv_words);
>> +		qce_write(qce, REG_CNTR_MASK, ~0);
>> +		qce_write(qce, REG_CNTR_MASK0, ~0);
>> +		qce_write(qce, REG_CNTR_MASK1, ~0);
>> +		qce_write(qce, REG_CNTR_MASK2, ~0);
>> +	}
>> +
>> +	/* Clear authentication IV and KEY registers of previous values */
>> +	qce_clear_array(qce, REG_AUTH_IV0, 16);
>> +	qce_clear_array(qce, REG_AUTH_KEY0, 16);
>> +
>> +	/* Clear byte count */
>> +	qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
>> +
>> +	/* Write authentication key */
>> +	qce_cpu_to_be32p_array(authkey, ctx->auth_key, auth_keylen);
>> +	authkey_words = DIV_ROUND_UP(auth_keylen, sizeof(u32));
>> +	qce_write_array(qce, REG_AUTH_KEY0, (u32 *)authkey, authkey_words);
>> +
>> +	if (IS_SHA_HMAC(rctx->flags)) {
>> +		/* Write default authentication iv */
>> +		if (IS_SHA1_HMAC(rctx->flags)) {
>> +			auth_ivsize = SHA1_DIGEST_SIZE;
>> +			memcpy(authiv, std_iv_sha1, auth_ivsize);
>> +		} else if (IS_SHA256_HMAC(rctx->flags)) {
>> +			auth_ivsize = SHA256_DIGEST_SIZE;
>> +			memcpy(authiv, std_iv_sha256, auth_ivsize);
>> +		}
>> +		authiv_words = auth_ivsize / sizeof(u32);
>> +		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
> 
> AUTH_IV0 is affected by the little endian configuration, does this imply
> that IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags? If so
> I think it would be nice if you grouped the conditionals in a way that
> made that obvious when reading the function.

So yes IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags. 
AUTH_IVn is 0 for ccm and has initial value for HMAC algorithms. I don't 
understand the confusion here.

> 
>> +	}
>> +
>> +	if (IS_CCM(rctx->flags)) {
>> +		qce_cpu_to_be32p_array(authnonce, rctx->ccm_nonce, QCE_MAX_NONCE);
>> +		authnonce_words = QCE_MAX_NONCE / sizeof(u32);
>> +		qce_write_array(qce, REG_AUTH_INFO_NONCE0, (u32 *)authnonce, authnonce_words);
>> +	}
>> +
>> +	/* Set up ENCR_SEG_CFG */
>> +	encr_cfg = qce_encr_cfg(flags, enc_keylen);
>> +	if (IS_ENCRYPT(flags))
>> +		encr_cfg |= BIT(ENCODE_SHIFT);
>> +	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
>> +
>> +	/* Set up AUTH_SEG_CFG */
>> +	auth_cfg = qce_auth_cfg(rctx->flags, auth_keylen, ctx->authsize);
>> +	auth_cfg |= BIT(AUTH_LAST_SHIFT);
>> +	auth_cfg |= BIT(AUTH_FIRST_SHIFT);
>> +	if (IS_ENCRYPT(flags)) {
>> +		if (IS_CCM(rctx->flags))
>> +			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
>> +		else
>> +			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
>> +	} else {
>> +		if (IS_CCM(rctx->flags))
>> +			auth_cfg |= AUTH_POS_AFTER << AUTH_POS_SHIFT;
>> +		else
>> +			auth_cfg |= AUTH_POS_BEFORE << AUTH_POS_SHIFT;
>> +	}
>> +	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
>> +
>> +	totallen = rctx->cryptlen + rctx->assoclen;
>> +
>> +	/* Set the encryption size and start offset */
>> +	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
>> +		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen + ctx->authsize);
>> +	else
>> +		qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
>> +	qce_write(qce, REG_ENCR_SEG_START, rctx->assoclen & 0xffff);
>> +
>> +	/* Set the authentication size and start offset */
>> +	qce_write(qce, REG_AUTH_SEG_SIZE, totallen);
>> +	qce_write(qce, REG_AUTH_SEG_START, 0);
>> +
>> +	/* Write total length */
>> +	if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
>> +		qce_write(qce, REG_SEG_SIZE, totallen + ctx->authsize);
>> +	else
>> +		qce_write(qce, REG_SEG_SIZE, totallen);
>> +
>> +	/* get little endianness */
>> +	config = qce_config_reg(qce, 1);
>> +	qce_write(qce, REG_CONFIG, config);
>> +
>> +	/* Start the process */
>> +	if (IS_CCM(flags))
>> +		qce_crypto_go(qce, 0);
> 
> Second parameter is defined as "bool", please use "false" here (and true
> below). Or
> 
> 	qce_crypto_go(qce, !IS_CCM(flags));

will do... I like the one liner better.


-- 
Warm Regards
Thara
