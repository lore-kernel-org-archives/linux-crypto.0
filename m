Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2512EC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 19:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7152613C8
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 19:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbhDMTa2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 15:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhDMTa1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:27 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96E5C061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 12:30:07 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id m16so13010651qtx.9
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 12:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PVwoQvaJMxO+yP07DhbysT5h5ccAWpMl0VED6nG2Vg0=;
        b=CluRNLj9fbx1ugBM+N2UuM5PObwNeOIlaq1OfkyrXK+H3bNheYPoAPiT8SCAFj7DM1
         +whx+6Kgc+RlG2Hh/7tmPxBxZuWizsP9YXTt5XJurMtBjnK237cktUo3SoruhUPTle6R
         TDgd0tifyPROWrB7tvDr8RG+/XeNbVKLRzpRGDVAf69N4dfoK71Zg9p1Cqj9WxEXhepd
         9zqff+/PUvN3ekkHJwOGnTHCwdgYJ5M7UngCTRZos0kARvDVr9ZlFurOOzimpsO2zhzW
         D1a41Mmkjf7jTlaMGC8XORvzx+VHv6nZ0dngfU6ISD0q1cPABCfjKPcrMBwkJ69Jf108
         zheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVwoQvaJMxO+yP07DhbysT5h5ccAWpMl0VED6nG2Vg0=;
        b=QXF14s+2m9GBpRCaQAsZwVKqcDaPz5xDenTuA/NaEil/zrE7YHzQuWDpRQADRpCESM
         V+TpSTxX86I8gmo5ffYvDmi/B88mOhlkDWAnIpq1j+mOkwAgGvrPosOquivxJ8H2dWxQ
         dMoCBx/6g+UTJuxGDG99A7pdP/+6Roqp8ekeHk8K4btcL6Wy8xKWmg3Pf2h5BEx2lEUr
         IstJ5r8hX9ZwoTIY6w4SDEdtOgJ8qwdGsor1bIFPfwYlcLBUmKnbz5e1X7o6UPStGPdA
         svOeNLCWcDlDf0eVYNTrPb4JWDf18WWCOGKmuGIn4+QNUnL4ieYgJQtuIZ5UgaAW9/5s
         C9Ig==
X-Gm-Message-State: AOAM531U3SrR4DUVWRX8U2YOesB4u2EEkHX/ELz8ukB8z43wl846QGVU
        twRC2be9l6EW0573kTsqHKU8Dw==
X-Google-Smtp-Source: ABdhPJyii68iBe3CU49SfFfMkpT0rTLbBweiiuqgEh1H92k89lhaew7v3NoiqjSsHdZ3Xn/lvzZc6g==
X-Received: by 2002:ac8:7a77:: with SMTP id w23mr15765350qtt.277.1618342206911;
        Tue, 13 Apr 2021 12:30:06 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id l124sm182499qkf.38.2021.04.13.12.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 12:30:06 -0700 (PDT)
Subject: Re: [PATCH 3/7] crypto: qce: Add mode for rfc4309
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-4-thara.gopinath@linaro.org>
 <20210405223247.GC904837@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <39683997-42ad-bd91-0c31-a9e982e0ba61@linaro.org>
Date:   Tue, 13 Apr 2021 15:30:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210405223247.GC904837@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 4/5/21 6:32 PM, Bjorn Andersson wrote:
> On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> 
>> rf4309 is the specification that uses aes ccm algorithms with IPsec
>> security packets. Add a submode to identify rfc4309 ccm(aes) algorithm
>> in the crypto driver.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> ---
>>   drivers/crypto/qce/common.h | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
>> index 3bc244bcca2d..3ffe719b79e4 100644
>> --- a/drivers/crypto/qce/common.h
>> +++ b/drivers/crypto/qce/common.h
>> @@ -51,9 +51,11 @@
>>   #define QCE_MODE_CCM			BIT(12)
>>   #define QCE_MODE_MASK			GENMASK(12, 8)
>>   
>> +#define QCE_MODE_CCM_RFC4309		BIT(13)
>> +
>>   /* cipher encryption/decryption operations */
>> -#define QCE_ENCRYPT			BIT(13)
>> -#define QCE_DECRYPT			BIT(14)
>> +#define QCE_ENCRYPT			BIT(14)
>> +#define QCE_DECRYPT			BIT(15)
> 
> Can't we move these further up, so that next time we want to add
> something it doesn't require that we also move the ENC/DEC bits?

Yes I will change it to BIT(30) and BIT(31)

> 
>>   
>>   #define IS_DES(flags)			(flags & QCE_ALG_DES)
>>   #define IS_3DES(flags)			(flags & QCE_ALG_3DES)
>> @@ -73,6 +75,7 @@
>>   #define IS_CTR(mode)			(mode & QCE_MODE_CTR)
>>   #define IS_XTS(mode)			(mode & QCE_MODE_XTS)
>>   #define IS_CCM(mode)			(mode & QCE_MODE_CCM)
>> +#define IS_CCM_RFC4309(mode)		((mode) & QCE_MODE_CCM_RFC4309)
> 
> While leaving room for the typical macro issues, none of the other
> macros wrap the argument in parenthesis. Please follow the style of the
> driver, and perhaps follow up with a cleanup patch that just wraps them
> all in parenthesis?

This does throw up a checkpatch warning if I don't wrap "mode" in 
parenthesis. How about I keep this for now and I will follow up with a 
clean up for rest of the macros later ?

> 
> Regards,
> Bjorn
> 
>>   
>>   #define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
>>   #define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
>> -- 
>> 2.25.1
>>

-- 
Warm Regards
Thara
