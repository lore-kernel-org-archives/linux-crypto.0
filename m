Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB056C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1C6611F0
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbhDMWqv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 18:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbhDMWqu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 18:46:50 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A3DC061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:46:30 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 7so19620706qka.7
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ka12zSDI6XCwHjAoONYaOjus8+rMfQI6N0FnSz1U3qM=;
        b=F2j0xrWRjkc1gVRnJ6bgBamzhgA3GO9KHnirGkCL+wSGWK7xSYlb6N6RDfxBw+Jwv/
         uyhjxlYfWIQH4n+0wVHzmMs5bw6RGnjGzkZSUYNFm9zDj8VuyTd4tfBYpKJ7XJFmfkoj
         ypTwTFhskqXStAHvrgu2nXf83WwxCvXjTBzeVff+UJbYCoIyCuv+6bAWSjwdG6arrwp0
         I9U//xuPonJHVbt2pZjgXLYBz6NyLEdBBXe7k1d8JkoPNl69G8tPPrEnZeRVMYH71111
         JP+Z00kI2S2MheSTJhL1D1NvXyQ4ZIsN40CGglrUpYWBwi+as0JexGioUqI2QwO5tmDu
         id1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ka12zSDI6XCwHjAoONYaOjus8+rMfQI6N0FnSz1U3qM=;
        b=CZfOqWAkrAeXrTp3nxs1ToiIWClR/RcecMmtEwD3K4YVHTKTJheY5NVWA/4m/jTI5w
         IKezDAcUbY8pf9DFOH3xO8NVOSxTa70geIkSv+6ABMCcmBgseTeniiBCxZ+kOSOAkrPX
         Tya8aQGDO3+mwMXPjQZY3TnYpWqVsR66CqYt7ylNW/qZawi49+Y5PGukXCjYToA+B3RR
         1LjZCA0R97roHK1Q/HFOhlyFoq0mJ6JPyGF0PFLQuNnf+DYA0rPcG+yMeOiIYLyR09sw
         UOJnP7wQ4Wak27ahBiYld0akFxFAtTqJ+R1BVb/IlziqEsfCO7j307vjJQWcx+I3ppD6
         v+1Q==
X-Gm-Message-State: AOAM5312SqZYsKQVDwovP7dWjETIucmk1wJY2H1Aq1QLcaDyfaDl4yeF
        eWxVYX1R0Qa8NpRpXwA9P7DJ5g==
X-Google-Smtp-Source: ABdhPJzDi9zE+rBHhF3cuWO7TksJiS9PthaqQ8DRMYBVBWYctv2ZFFUE3n341QDfLY3yHc3pguewqA==
X-Received: by 2002:a37:6182:: with SMTP id v124mr16851251qkb.289.1618353989470;
        Tue, 13 Apr 2021 15:46:29 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id 188sm7720117qkf.27.2021.04.13.15.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 15:46:28 -0700 (PDT)
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
 <64543792-7237-8622-9619-7020ed0b3fa1@linaro.org>
 <20210413223316.GT1538589@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <784e0379-ee24-51ea-68c5-de7adf907dfb@linaro.org>
Date:   Tue, 13 Apr 2021 18:46:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210413223316.GT1538589@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 4/13/21 6:33 PM, Bjorn Andersson wrote:
> On Tue 13 Apr 17:27 CDT 2021, Thara Gopinath wrote:
> 
>>
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
>>>
>>>> +
>>>> +	/* Write encryption iv */
>>>> +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
>>>> +	enciv_words = enc_ivsize / sizeof(u32);
>>>> +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
>>>
>>> It would be nice if this snippet was extracted to a helper function.
>>
>> I kind of forgot to type this earlier. So yes I agree in principle.
>> It is more elegant to have something like qce_convert_be32_and_write
>> and in the function do the above three steps. This snippet is prevalent in
>> this driver code across other alogs as well (skcipher and hash).
> 
> Perhaps make qce_cpu_to_be32p_array() (or qce_be32_to_cpu() per the
> other reply), could return the number of words written - that way you
> remove the ugly middle line at least - and can still poke at the data
> when needed.

Right. I will note this down for clean up as it touches other stuff as 
well.

> 
>> Take it up as a separate clean up activity  ?
>>
> 
> Yes, that seems like a good idea.
> 
> Regards,
> Bjorn
> 

-- 
Warm Regards
Thara
