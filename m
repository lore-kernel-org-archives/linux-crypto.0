Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A8CC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D736120E
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbhDMWou (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 18:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243101AbhDMWoq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 18:44:46 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D830C061756
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:44:25 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id h3so8219545qve.13
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fRv1VLSmNT5c1ESBt9iq7OX+vEe0OiwZ74hunxukn24=;
        b=cIW1F8yAX/DJdnbvmy7FYBM6joZgTHbxealIFNS5keGvWV0ZXXjx2QAyhBkcFhjOx/
         /H/CsWClsPRnd6cU//zQ8EypwmIWhyqYct/KTKfa4EtVQytC1Akekp9FQyEzUx6C95je
         lCK5++r6GG1ZLMq+MvvYOiUX3sxB195v5BoShlL+8uDr8ZtPj/63YTJdWpytqkjh2SFa
         ecY2KsqkD82kQplQXEGw3019RcgNcbJajy5u7L6HIpywtJVl1bg2vfoICdDpo9hHgGQ0
         huWwH5AhvmYqzhPFC1vr7S9sQWKxsRcFUcU66qNUhTop731JlesnTRB/BEKR2xhBPLYK
         B7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRv1VLSmNT5c1ESBt9iq7OX+vEe0OiwZ74hunxukn24=;
        b=j4fSFUmxF3uc7qybEdktN2XAUcApXtvCebGttjoMH5Ne1CqG06maUmt4VgBHiK6n7m
         yFfH0WpJ7Iz7P4+mVNCg/KKNeSjxNhEW7fJvUsq/dh4UoiqgGA9gAgZzt+/U/QhfNsqd
         31rPF8V93WoStLWqdz1a0J6GlpEiubjo3RftBM8NAQ6jM82DBB0zqqnGsEKwb2b4sLnL
         +Hhm02Fw5/VOwFIyvDCsl6pUCbzFtXxxXI/XvcEV7bPH19oipuXddDH0OFGHILDR97nC
         IgQZ1LfeaTvGKkcQTSRIZuvX2Dm2LBZNQYUFMotJnSKde4ex/rK7+05ySbuwMaAcMTBg
         vsDg==
X-Gm-Message-State: AOAM532Lm1yyam1kYW/ukre+ix8+9227z6simiicjukrzRg5pZjN7x91
        nKj7GHzM6JS4/NaptYQ+I4dnNQ==
X-Google-Smtp-Source: ABdhPJzbp8mb/fUdcl29XGm7Kr96tZ5fAUfspG7oB+Blo4Ncn9B7VeFuuQE1CIx0XkrVf3xQHsDI5g==
X-Received: by 2002:a05:6214:1381:: with SMTP id g1mr13193821qvz.21.1618353864371;
        Tue, 13 Apr 2021 15:44:24 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id q67sm9065716qkb.89.2021.04.13.15.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 15:44:23 -0700 (PDT)
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
 <cab25283-1ad6-2107-8a5e-230a3a7358b5@linaro.org>
 <20210413222014.GS1538589@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <4c4a9df6-7ad5-85ab-bfcd-2c123bd86ca0@linaro.org>
Date:   Tue, 13 Apr 2021 18:44:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210413222014.GS1538589@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 4/13/21 6:20 PM, Bjorn Andersson wrote:
> On Tue 13 Apr 16:31 CDT 2021, Thara Gopinath wrote:
> 
>>
>> Hi Bjorn,
>>
>> On 4/5/21 6:18 PM, Bjorn Andersson wrote:
>>> On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
>>>
>>>> Add register programming sequence for enabling AEAD
>>>> algorithms on the Qualcomm crypto engine.
>>>>
>>>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>>>> ---
>>>>    drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
>>>>    1 file changed, 153 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
>>>> index 05a71c5ecf61..54d209cb0525 100644
>>>> --- a/drivers/crypto/qce/common.c
>>>> +++ b/drivers/crypto/qce/common.c
>>>> @@ -15,6 +15,16 @@
>>>>    #include "core.h"
>>>>    #include "regs-v5.h"
>>>>    #include "sha.h"
>>>> +#include "aead.h"
>>>> +
>>>> +static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
>>>> +	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
>>>> +};
>>>> +
>>>> +static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
>>>> +	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
>>>> +	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
>>>> +};
>>>>    static inline u32 qce_read(struct qce_device *qce, u32 offset)
>>>>    {
>>>> @@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
>>>>    		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
>>>>    }
>>>> -#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>>>> +#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>>>>    static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>>>>    {
>>>>    	u32 cfg = 0;
>>>> @@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
>>>>    	return cfg;
>>>>    }
>>>> +#endif
>>>> +#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
>>>>    static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>>>>    {
>>>>    	struct ahash_request *req = ahash_request_cast(async_req);
>>>> @@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>>>>    }
>>>>    #endif
>>>> -#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>>>> +#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
>>>>    static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>>>>    {
>>>>    	u32 cfg = 0;
>>>> @@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
>>>>    	return cfg;
>>>>    }
>>>> +#endif
>>>> +#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>>>>    static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
>>>>    {
>>>>    	u8 swap[QCE_AES_IV_LENGTH];
>>>> @@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
>>>>    }
>>>>    #endif
>>>> +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
>>>> +static int qce_setup_regs_aead(struct crypto_async_request *async_req)
>>>> +{
>>>> +	struct aead_request *req = aead_request_cast(async_req);
>>>> +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
>>>> +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
>>>> +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
>>>> +	struct qce_device *qce = tmpl->qce;
>>>> +	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
>>>> +	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
>>>> +	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
>>>> +	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
>>>> +	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
>>>> +	unsigned int enc_keylen = ctx->enc_keylen;
>>>> +	unsigned int auth_keylen = ctx->auth_keylen;
>>>> +	unsigned int enc_ivsize = rctx->ivsize;
>>>> +	unsigned int auth_ivsize;
>>>> +	unsigned int enckey_words, enciv_words;
>>>> +	unsigned int authkey_words, authiv_words, authnonce_words;
>>>> +	unsigned long flags = rctx->flags;
>>>> +	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;
>>>
>>> I don't see any reason to initialize encr_cfg or auth_cfg.
>>
>> right.. I will remove it
>>
>>>
>>>> +	u32 *iv_last_word;
>>>> +
>>>> +	qce_setup_config(qce);
>>>> +
>>>> +	/* Write encryption key */
>>>> +	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
>>>> +	enckey_words = enc_keylen / sizeof(u32);
>>>> +	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
>>>
>>> Afaict all "array registers" in this function are affected by the
>>> CRYPTO_SETUP little endian bit, but you set this bit before launching
>>> the operation dependent on IS_CCM(). So is this really working for the
>>> !IS_CCM() case?
>>
>> I am not sure I understand you. Below ,
>> 	/* get little endianness */
>> 	config = qce_config_reg(qce, 1);
>> 	qce_write(qce, REG_CONFIG, config);
>>
>> is outside of any checks..
>>
> 
> You're right, I misread that snippet as I was jumping through the
> function. So we're unconditionally running the hardware in little endian
> mode.
> 
>>>
>>>> +
>>>> +	/* Write encryption iv */
>>>> +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
>>>> +	enciv_words = enc_ivsize / sizeof(u32);
>>>> +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
>>>
>>> It would be nice if this snippet was extracted to a helper function.
>>>
>>>> +
>>>> +	if (IS_CCM(rctx->flags)) {
>>>> +		iv_last_word = (u32 *)&enciv[enciv_words - 1];
>>>> +//		qce_write(qce, REG_CNTR3_IV3, enciv[enciv_words - 1] + 1);
>>>
>>> I believe this is a remnant of the two surrounding lines.
>>
>> It indeed is.. I will remove it.
>>
>>>
>>>> +		qce_write(qce, REG_CNTR3_IV3, (*iv_last_word) + 1);
>>>
>>> enciv is an array of big endian 32-bit integers, which you tell the
>>> compiler to treat as cpu-native endian, and then you do math on it.
>>> Afaict from the documentation the value of REG_CNTR3_IVn should be set
>>> to rctx->iv + 1, but if the hardware expects these in big endian then I
>>> think you added 16777216.
>>
>> So, the crypto engine documentation talks of writing to these registers in
>> little endian mode. The byte stream that you get for iv from the user
>> is in big endian mode as in the MSB is byte 0. So we kind of invert this and
>> write  to these registers. This is what happens with declaring the __be32
>> array and copying words to it from the byte stream. So now byte 0 is the LSB
>> and a +1 will just add a 1 to it.
>>
> 
> But if the data come in big endian and after qce_cpu_to_be32p_array()
> you're able to do math on them with expected result and you're finally
> passing the data to writel() then I think that qce_cpu_to_be32p_array()
> is actually be32_to_cpu() and after the conversion you should carry the
> results in CPU-native u32 arrays - and thereby skip the typecasting.

you mean I can replace __be32 arrays with u32 arrays ?? yes I probably 
can. I will try this out and if it works do the change.

> 
>> I suspect from what I read in the documentation we could get away by
>> removing this and writing the big endian byte stream directly and never
>> setting the little endian in config register. Though I am not sure if this
>> has ever been tested out. If we change it, it will be across algorithms and
>> as a separate effort.
> 
> writel() will, at least on arm64, convert the CPU native value to little
> endian before writing it out, so I think the current setting make sense.

hmm.. ok.

> 
>>
>>>
>>> Perhaps I'm missing something here though?
>>>
>>> PS. Based on how the documentation is written, shouldn't you write out
>>> REG_CNTR_IV[012] as well?
>>
>> It is done on top, right ?
>> qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
>>
> 
> You're right, depending on enciv_words you write the 4 registers, then
> increment the last word and write that out again.
> 
>>>
>>>> +		qce_write_array(qce, REG_ENCR_CCM_INT_CNTR0, (u32 *)enciv, enciv_words);
>>>> +		qce_write(qce, REG_CNTR_MASK, ~0);
>>>> +		qce_write(qce, REG_CNTR_MASK0, ~0);
>>>> +		qce_write(qce, REG_CNTR_MASK1, ~0);
>>>> +		qce_write(qce, REG_CNTR_MASK2, ~0);
>>>> +	}
>>>> +
>>>> +	/* Clear authentication IV and KEY registers of previous values */
>>>> +	qce_clear_array(qce, REG_AUTH_IV0, 16);
>>>> +	qce_clear_array(qce, REG_AUTH_KEY0, 16);
>>>> +
>>>> +	/* Clear byte count */
>>>> +	qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
>>>> +
>>>> +	/* Write authentication key */
>>>> +	qce_cpu_to_be32p_array(authkey, ctx->auth_key, auth_keylen);
>>>> +	authkey_words = DIV_ROUND_UP(auth_keylen, sizeof(u32));
>>>> +	qce_write_array(qce, REG_AUTH_KEY0, (u32 *)authkey, authkey_words);
>>>> +
>>>> +	if (IS_SHA_HMAC(rctx->flags)) {
>>>> +		/* Write default authentication iv */
>>>> +		if (IS_SHA1_HMAC(rctx->flags)) {
>>>> +			auth_ivsize = SHA1_DIGEST_SIZE;
>>>> +			memcpy(authiv, std_iv_sha1, auth_ivsize);
>>>> +		} else if (IS_SHA256_HMAC(rctx->flags)) {
>>>> +			auth_ivsize = SHA256_DIGEST_SIZE;
>>>> +			memcpy(authiv, std_iv_sha256, auth_ivsize);
>>>> +		}
>>>> +		authiv_words = auth_ivsize / sizeof(u32);
>>>> +		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
>>>
>>> AUTH_IV0 is affected by the little endian configuration, does this imply
>>> that IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags? If so
>>> I think it would be nice if you grouped the conditionals in a way that
>>> made that obvious when reading the function.
>>
>> So yes IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags.
>> AUTH_IVn is 0 for ccm and has initial value for HMAC algorithms. I don't
>> understand the confusion here.
>>
> 
> I'm just saying that writing is as below would have made it obvious to
> me that IS_SHA_HMAC() and IS_CCM() are exclusive:

So regardless of the mode, it is a good idea  to clear the IV  registers 
which happens above in

	qce_clear_array(qce, REG_AUTH_IV0, 16);


This is important becasue the size of IV varies between HMAC(SHA1) and 
HMAC(SHA256) and we don't want any previous bits sticking around.
For CCM after the above step we don't do anything with AUTH_IV where as 
for SHA_HMAC we have to go and program the registers. I can split it into
if (IS_SHA_HMAC(flags)) {
	...
} else {
	...
}

but both snippets will have the above line code clearing the IV register 
and the if part will have more stuff actually programming these 
registers.. Is that what you are looking for ?


-- 
Warm Regards
Thara
