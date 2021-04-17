Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8737C433ED
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7555161207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhDQNb2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhDQNb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 09:31:28 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED25AC061574
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:31:01 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id b139so26283164qkc.10
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lLmvbjMjGtSVWdhlqL3SvgYtLpaWEFGhNafW6/W3ZVc=;
        b=H7gInR0NHdp5tbim9KFaYP+8HZin0ceZRD/CA+m0WfjBbpAbZTLS/r/SqE0iJXqX/V
         atpAefVsHqBc9FbG8Sk+gO1uSgX+6wuGH+5NH3EejZpZhClT+szYBlQM/Krr2ytV1iha
         ps/jJSerEWGf6+/bWiGjy65y9y9tejvmt8fxK+NnLSAGI+HL2BnQdtsmSAI5KEqM02V3
         PGJBs6t/wODHYu5FNHSGDsHXNrbfddqiL8VmYb4+N2a1uAg4xXholfNzFTy0Jd1z5BAg
         I5zAfvd6T0x1vDVrnbS4bPQ9CX78fDHEJakK5k8CjXEa+ftnR0rkw+N8j3kdM7O6UYEX
         DrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lLmvbjMjGtSVWdhlqL3SvgYtLpaWEFGhNafW6/W3ZVc=;
        b=ogmh2mpX82XLV/GObPu9LAs1+yTRmIREl3Nvp1Fs0DmP/Bj3nw2+uYsN7gJ4Bn2HPe
         jpr9w7vzYLAQtQGjfGB4F3e5Wjn/n7QujnPg6OfrwNIUjYemiVYFlcN+qfmcX7+Slqvi
         KbqN3Jd8wdizEUkQA7SNLttvkHP4cmC47s6FkdkNyF3tTTtoHqybjBT/Y3OtgfyAsxDA
         K0dYp5P1eXiweVyYjoZT/hF+2bEtG4w4rFyvwz+MY95vNRBrAumBp4vefFmXC4/PheBM
         dGR3Xq4Orpu7uYaR3W3ULZq5L6cpaIpEIc/qQ1kJVk+LwLB5kqpw6otjU8QGhb5wOF9g
         Jr8A==
X-Gm-Message-State: AOAM5300cBJZYBssSVnipO0B0yp9qQHWLAsqx4NDCs7HoSocdlmZgMEe
        TXiaZjZIHtjnZtZfFV8JX+FIKQ==
X-Google-Smtp-Source: ABdhPJyMDMOY4H673xU4aLshCe3ybBDll5pw/WeMc/kqTjva4oQUlA3H3J62DlXhQ9CHELCH4lLmiA==
X-Received: by 2002:ae9:e70c:: with SMTP id m12mr4079865qka.390.1618666261160;
        Sat, 17 Apr 2021 06:31:01 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id k26sm6264019qkg.120.2021.04.17.06.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:31:00 -0700 (PDT)
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
 <4c4a9df6-7ad5-85ab-bfcd-2c123bd86ca0@linaro.org>
 <20210413230930.GU1538589@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <beab39e4-560b-b897-fa0e-c95a5f04a018@linaro.org>
Date:   Sat, 17 Apr 2021 09:31:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210413230930.GU1538589@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 4/13/21 7:09 PM, Bjorn Andersson wrote:
> On Tue 13 Apr 17:44 CDT 2021, Thara Gopinath wrote:

[..]

> 
> Yes, given that you just typecast things as you do it should just work
> to move the typecast to the qce_cpu_to_be32p_array().
> 
> But as I said, this would indicate that what is cpu_to_be32() should
> have been be32_to_cpu() (both performs the same swap, it's just a matter
> of what type goes in and what type goes out).
> 
> Looking at the other uses of qce_cpu_to_be32p_array() I suspect that
> it's the same situation there, so perhaps introduce a new function
> qce_be32_to_cpu() in this patchset (that returns number of words
> converted) and then look into the existing users after that?

Hi!

I have sent out the v2 with the new function. To me, it does look 
cleaner. So thanks!

> 
> [..]
>>>>>> +	if (IS_SHA_HMAC(rctx->flags)) {
>>>>>> +		/* Write default authentication iv */
>>>>>> +		if (IS_SHA1_HMAC(rctx->flags)) {
>>>>>> +			auth_ivsize = SHA1_DIGEST_SIZE;
>>>>>> +			memcpy(authiv, std_iv_sha1, auth_ivsize);
>>>>>> +		} else if (IS_SHA256_HMAC(rctx->flags)) {
>>>>>> +			auth_ivsize = SHA256_DIGEST_SIZE;
>>>>>> +			memcpy(authiv, std_iv_sha256, auth_ivsize);
>>>>>> +		}
>>>>>> +		authiv_words = auth_ivsize / sizeof(u32);
>>>>>> +		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
>>>>>
>>>>> AUTH_IV0 is affected by the little endian configuration, does this imply
>>>>> that IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags? If so
>>>>> I think it would be nice if you grouped the conditionals in a way that
>>>>> made that obvious when reading the function.
>>>>
>>>> So yes IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags.
>>>> AUTH_IVn is 0 for ccm and has initial value for HMAC algorithms. I don't
>>>> understand the confusion here.
>>>>
>>>
>>> I'm just saying that writing is as below would have made it obvious to
>>> me that IS_SHA_HMAC() and IS_CCM() are exclusive:
>>
>> So regardless of the mode, it is a good idea  to clear the IV  registers
>> which happens above in
>>
>> 	qce_clear_array(qce, REG_AUTH_IV0, 16);
>>
>>
>> This is important becasue the size of IV varies between HMAC(SHA1) and
>> HMAC(SHA256) and we don't want any previous bits sticking around.
>> For CCM after the above step we don't do anything with AUTH_IV where as for
>> SHA_HMAC we have to go and program the registers. I can split it into
>> if (IS_SHA_HMAC(flags)) {
>> 	...
>> } else {
>> 	...
>> }
>>
>> but both snippets will have the above line code clearing the IV register and
>> the if part will have more stuff actually programming these registers.. Is
>> that what you are looking for ?
> 
> I didn't find an answer quickly to the question if the two where
> mutually exclusive and couldn't determine from the code flow either. But
> my comment seems to stem from my misunderstanding that the little endian
> bit was dependent on IS_CCM().
> 
> That said, if the logic really is "do this for IS_SHA_HMAC(), otherwise
> do that", then if else makes sense.

So, the logic is really. do "clearing of IV" in all cases. Do setting of 
initial IV only for HMAC. I tried the if..else like you said. It did not 
look correct to duplicate the code clearing the IV. So I have added 
comments around this section hopefully making it clearer. Do take a look 
and let me know. I can rework it further if you think so.

> 
> Regards,
> Bjorn
> 

-- 
Warm Regards
Thara
