Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EEAC433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 15:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF0C23884
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 15:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhAHPuy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 10:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbhAHPuy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 10:50:54 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB26C061381
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 07:50:13 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c14so6804081qtn.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 07:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jfyQVb5F4Fnofjwp4gp3HmfbIgP2C1LdLC9T1MaxhqE=;
        b=Fd/iGCYcmREuauhENVWhXDuS650ocy4lTiDWN3CcIkwQ0pdr9wK4Nkdzy7n/iedqZD
         lDRI7oO9bPLZBUSlBwBxZM6Ugs+c9VD8/sdlkYv2vP0T+Hc85ZKUr1OeQds9eU6lh3ev
         /ymA5b1dQ63StLRN19OMeoIQKjTQqm78f6MGkH7Fn6vSrw198bmGmbxZhrZ+a9EztdC5
         3J1yP+Byw3coh8YQv13vogIuH+zuKkVCCKA3rTfkRbtpDHqZW8lPWU/MwRAb5WcyXLrH
         N/puP93uGUv3TwdsGUNn329/7tuFFe1QxJB9z4gqwxYBUAzzxm9T3U7T0A1BGwmA3tJp
         x6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jfyQVb5F4Fnofjwp4gp3HmfbIgP2C1LdLC9T1MaxhqE=;
        b=fgj5Vn+e7sKGSNdnVCrfnLpomJ+nhgGxWCnvo/p7+0jfgmrqcQH0ch84U0P9ZhfNK2
         js56xDJUqbr5dXXl9wXUlEXa50P0QJhrURjumQp+UmUttoYTjHKz9jffs1ICaaYuEMvs
         79VGGDbHVo8xb2kKD6Leg4IgkJodBwOMMvxKFyl36G0mDlCeC5towMRCxSHo1pjMJiiS
         TTMpbxquDkXzbY+5rRwl/A+CQ2NKu+DkXIs99jFlRKrDozmEd2eFLytb6OPni2uWZ60b
         W3PlMzZ0ElCB5CykcsFMAnTO/ZsXRbN6m/kWq1Pc8/RcLg18EMHPZk6jLIN4ZugkY0g3
         2OMg==
X-Gm-Message-State: AOAM531h0sp2z4npSX7hl4ueiqhXPp96ZUPVFdIDqVhpFyQvpN/7S6vM
        ga1YnV1YlTpBQUT/7aqxftLRmg==
X-Google-Smtp-Source: ABdhPJyVgCVxH6DPzttzqVseTpzz084eIMiRf60Z3+k3TBhHzynQ2X+U/znUzzT8fPdW/OVwHeS2nw==
X-Received: by 2002:ac8:5359:: with SMTP id d25mr4161265qto.132.1610121013125;
        Fri, 08 Jan 2021 07:50:13 -0800 (PST)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id d140sm5071811qkc.111.2021.01.08.07.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 07:50:12 -0800 (PST)
Subject: Re: [PATCH 1/6] drivers: crypto: qce: sha: Restore/save
 sha1_state/sha256_state with qce_sha_reqctx in export/import
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
 <20201219033027.3066042-2-thara.gopinath@linaro.org>
 <20210102212501.GA1931@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <a72257ba-14c2-8e61-435c-4daa3a7d6b6e@linaro.org>
Date:   Fri, 8 Jan 2021 10:50:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210102212501.GA1931@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 1/2/21 4:25 PM, Herbert Xu wrote:
> On Fri, Dec 18, 2020 at 10:30:22PM -0500, Thara Gopinath wrote:
>> Export and import interfaces save and restore partial transformation
>> states. The partial states were being stored and restored in struct
>> sha1_state for sha1/hmac(sha1) transformations and sha256_state for
>> sha256/hmac(sha256) transformations.This led to a bunch of corner cases
>> where improper state was being stored and restored. A few of the corner
>> cases that turned up during testing are:
>>
>> - wrong byte_count restored if export/import is called twice without h/w
>> transaction in between
>> - wrong buflen restored back if the pending buffer
>> length is exactly the block size.
>> - wrong state restored if buffer length is 0.
>>
>> To fix these issues, save and restore the entire qce_sha_rctx structure
>> instead of parts of it in sha1_state and sha256_state structures.
>> This in turn simplifies the export and import apis.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> ---
>>   drivers/crypto/qce/sha.c | 93 ++++------------------------------------
>>   1 file changed, 8 insertions(+), 85 deletions(-)
> 
> How is this safe when the reqctx structure contains pointers?

Hi Herbert,

You are right. Also more I think about this, it is better to have 
another struct to export and import the relevant pieces.
I will fix this and send across a v2.

> 
> Cheers,
> 

-- 
Warm Regards
Thara
