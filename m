Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FC0C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F7C61103
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345450AbhDMW2D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 18:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhDMW2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 18:28:02 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850F2C061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:27:39 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o5so19634452qkb.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rgFY8x0zq0Pabg4Abiq7MJVjIpGtxc8sg3kp5cufSKs=;
        b=gFcTpDF814f+UVigQLUqhxPVE8WJgLIVn3BcNJ9rq1U4wY45vKtl5AX0c9l4TSK7YK
         RuNuM1WQ0sqmhr56Q5kzG1GNjb0SCofFp7D/ZBDG1it7tkK4W0O3SpvBWaMTLpASz5Rr
         T9g3rhT6bMTwS5BmhYYMnkuqMbGKrq6iYNoh3APD1EQBSyD+N1Rimg6036gkIZ3Ua25H
         P/7su8QtUhcUbKJNFCBu5D0qtq2+xDWzAugoI9fqUI+fCgrB4u0/M9bBd7uxkkaF6Kzc
         cSW0gDpZJr1WAbShmT3QOQY7iK7+L4Ay+kWJULmZWzWx+X4+bb4lGAnqYIhUWwbXzbig
         cpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rgFY8x0zq0Pabg4Abiq7MJVjIpGtxc8sg3kp5cufSKs=;
        b=gEiCjtKr7qk2GKGdqOo2vl11nfb+coka9pIH9G2xh1tVYy3EF66XkDomX/v+38FnKu
         Pkd37M9VOGHBh6PSrZxvQH1BffgSAF2mwsHRMZXGBnWXjfzJBuMx0i+oymACpoRq20cU
         FvTPojfCUFLJ/qqCTMcAcYiFGIc+5VrFbnILQyZWUw/synA8IpraNIYKkR1QpDCjW/cp
         hlaRygW6WR5DvEjW3Cv2Fm50J1yHqP6jPybQXzNX7WtwspwDpsg3XriIEj8rNXXAsleK
         YYPTTwVcnxc6TAU2VLYiUW4BOj2/kF7dVHPLmJoTcVLrQqMFXYqo2ozpNOZqScTINu2g
         3qNQ==
X-Gm-Message-State: AOAM530IG4hvpOMXYQOGqcDH1uU9ihS2qNj0KmPVrMN/MP6w7WaqZCSq
        zJnSwIg/LR7hNSJFmK3vtzOa8Q==
X-Google-Smtp-Source: ABdhPJx8OlHyTfidUFnV2le3ndgc2t+MTF0+oYam74PHMao1CxljRATxTNmyHpYGiS2WPKlQJMxYlA==
X-Received: by 2002:a05:620a:2013:: with SMTP id c19mr34517163qka.403.1618352858549;
        Tue, 13 Apr 2021 15:27:38 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id c145sm1276772qkg.48.2021.04.13.15.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 15:27:37 -0700 (PDT)
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <64543792-7237-8622-9619-7020ed0b3fa1@linaro.org>
Date:   Tue, 13 Apr 2021 18:27:37 -0400
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
> 
>> +
>> +	/* Write encryption iv */
>> +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
>> +	enciv_words = enc_ivsize / sizeof(u32);
>> +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
> 
> It would be nice if this snippet was extracted to a helper function.

I kind of forgot to type this earlier. So yes I agree in principle.
It is more elegant to have something like qce_convert_be32_and_write
and in the function do the above three steps. This snippet is prevalent 
in this driver code across other alogs as well (skcipher and hash).
Take it up as a separate clean up activity  ?

-- 
Warm Regards
Thara
