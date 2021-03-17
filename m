Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EFEC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E94864F92
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 02:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhCQCJq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCQCJn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Mar 2021 22:09:43 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0BFC06174A
        for <linux-crypto@vger.kernel.org>; Tue, 16 Mar 2021 19:09:43 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t4so37486424qkp.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Mar 2021 19:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/MD2a5jJm1VTg2rLp8ZvV5PbVeWqLk6KDwdIiH3D7ok=;
        b=ZTaOzuB+ptoZaIS7ucnPtUjZ9ehUlHs6z1oq1rXOyLKK+S1K6qLgIkqDf9I4N6nCXV
         EA3XCld0w8N7rzIwb0+Ho89U0oNBDnVLTs7vBptEpo4YfDkOyFmVF5WCgTylSamJ7f1L
         ZnML3cfh5KJ6IxkSYSrFrR01mpmoyN7FlyB5Zn7dfcTk5B+ydRJHV6Gtq4+/I5a9/sDT
         WHbgI4qSL5Yq/Z7Fo+RbeyRL9Zbf1sL2qLHGmp5czAccTdDq8G9yqCinsiJLVQfGdp4R
         3kHYr0VULHgD4t7X4pT1TxLh5nMTu/rCM4r/uR3z1Uif3iJ2Ho4GTj9S5T2SFG2Vkxfd
         IOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/MD2a5jJm1VTg2rLp8ZvV5PbVeWqLk6KDwdIiH3D7ok=;
        b=WMrmazLSs2Xqnk9n5t4CL5O6Kg7cvqeAWmbDyizEnex8RrFnkG+fA1x76hqCh/La6o
         m6718/VZm9eblOUhJ6pYGPQ152FTynXZlNh5U4tm9nLJ8izVifvgNK1eoyHSeCYzYLix
         2CWF7LscpJykPMefP1Qli/kLu2gyTANAdQBHqIn8I9Rwc7j7nLHwWCOKfuTxVfryG0ak
         HSWr6ebNofelVtGv9vH5udYZusyez2ffXbybAHbTRS3G+gaA6rfN0dsdrpfsf/NfUt0H
         uY5tFrzwCxJ7J0bbJfGR/omuUttlfLAqDilzJZY7agA9hK/zDPUq1GdA5YuGA1cpKqEt
         nJKg==
X-Gm-Message-State: AOAM531wJ5bYBW3yQXdtdOGa7U/ki+L5Qs/iH2r1POvU/WBufs5dVPqU
        VnOSELqNdFq59mxm5HTQYWdnCg==
X-Google-Smtp-Source: ABdhPJxX1ZLdrxaGMH0MG4DE9v5rUZ/KwcbMeoSoaule+9shT5XPe5Azmr/p44YCEokJ/QbubV7g6g==
X-Received: by 2002:a37:6108:: with SMTP id v8mr2312231qkb.448.1615946982331;
        Tue, 16 Mar 2021 19:09:42 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id l5sm14057275qtj.21.2021.03.16.19.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 19:09:41 -0700 (PDT)
Subject: Re: [PATCH 4/7] crypto: qce: Add support for AEAD algorithms
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-5-thara.gopinath@linaro.org>
 <20210312130150.GA17238@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <69c608d4-5dff-b33b-e112-2b2603ecfd27@linaro.org>
Date:   Tue, 16 Mar 2021 22:09:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210312130150.GA17238@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3/12/21 8:01 AM, Herbert Xu wrote:
> On Thu, Feb 25, 2021 at 01:27:13PM -0500, Thara Gopinath wrote:
>>
>> +static int
>> +qce_aead_async_req_handle(struct crypto_async_request *async_req)
>> +{
>> +	struct aead_request *req = aead_request_cast(async_req);
>> +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
>> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>> +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
>> +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
>> +	struct qce_device *qce = tmpl->qce;
>> +	enum dma_data_direction dir_src, dir_dst;
>> +	unsigned int totallen;
>> +	bool diff_dst;
>> +	int ret;
>> +
>> +	if (IS_CCM_RFC4309(rctx->flags)) {
>> +		memset(rctx->ccm_rfc4309_iv, 0, QCE_MAX_IV_SIZE);
>> +		rctx->ccm_rfc4309_iv[0] = 3;
>> +		memcpy(&rctx->ccm_rfc4309_iv[1], ctx->ccm4309_salt, QCE_CCM4309_SALT_SIZE);
>> +		memcpy(&rctx->ccm_rfc4309_iv[4], req->iv, 8);
>> +		rctx->iv = rctx->ccm_rfc4309_iv;
>> +		rctx->ivsize = AES_BLOCK_SIZE;
>> +	} else {
>> +		rctx->iv = req->iv;
>> +		rctx->ivsize = crypto_aead_ivsize(tfm);
>> +	}
>> +	if (IS_CCM_RFC4309(rctx->flags))
>> +		rctx->assoclen = req->assoclen - 8;
>> +	else
>> +		rctx->assoclen = req->assoclen;
>> +
>> +	totallen = rctx->cryptlen + rctx->assoclen;
> 
> This triggers a warning on totallen not being used.  Please fix.

hmm.. this is strange. I could swear that I checked for warnings before 
sending this out. But I will fix this. I will wait for a couple of more 
days for any other comments and then spin a v2.

> 
> Thanks,
> 

-- 
Warm Regards
Thara
