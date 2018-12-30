Return-Path: <SRS0=5fel=PH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923F8C43387
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Dec 2018 14:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55ECE20828
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Dec 2018 14:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NsVRZ0nG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbeL3O7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Dec 2018 09:59:51 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35066 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbeL3O7v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Dec 2018 09:59:51 -0500
Received: by mail-lf1-f65.google.com with SMTP id e26so17181616lfc.2;
        Sun, 30 Dec 2018 06:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HUG0cK/tlltdKSp7QmeOCDbAvvkGtHYIyn9D9aez36w=;
        b=NsVRZ0nGCx3yUEgggilm6H2um+y2sl3RxoRauN67Of8bzjRMZ4iUuAFpKdGlD4ZVox
         GYdj/GFXxvsuYJ7f2eKpmN2JVv04vIMBVs4DMijgfUQIuyqFLEVVEPdzVxFd+uKkEoDV
         peuHcXEZJ/weukeXyVY6vQB/1Dk5IRx3upAwbDMMb4Z0qAOsCiGF/80ZC97SHbypAzrt
         x7R3ore++5kmjRkJ1y24xlNT/UbHOwdbhXv4EivcYun/cs9xbjJQEENPb4y0Fzbr+lhy
         ZOiA/xevik+D0eNWASXHmt2ctfoFhO0yM3m4TT76xZ18nmnCfYOxKpZPTCIh6J9YyPXT
         vgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HUG0cK/tlltdKSp7QmeOCDbAvvkGtHYIyn9D9aez36w=;
        b=RAHZkZMRYeP/5A6G6TPFih6ldS7a3vm8jdVfpHm2B9Dsef1SVvdXG754TR847uXgqC
         DNE7MjrhgWhkqKGj8PXlGBYIwnVL/Odt21/9/mIPYUamEnyzlVrQ7igjjk9BjzTnT8Uo
         +c286Rz99f+T8i/4295rTs25EAFGfwlUFhT0zGRUHRUM/WJZ1ZL8oNnqBA4yNzhg5lKd
         DqGFX6l9hrKJrV24NIkd0MTZax/JkkFpu0UMWIZsuSR0vv/MDWJG+9nwBYoZfcm6huyZ
         tu0IZd5GYnO0/Go/HzVXMIAEnJNPjEvC08F/haYEHAELdCovB+d4rmF5DiIvgTmNGlRK
         R+Mw==
X-Gm-Message-State: AA+aEWa1PhLoZlSwnXAdcfMYU+t7elidf1HKqdvh9t7gjqIE7w+yJ1L/
        QN9mWtUCsLeZxPBan4vzJyA=
X-Google-Smtp-Source: AFSGD/WrX1Ot5yZRRZMipIZi81QAXUPzlhUMosQd3bPe1XvRh4rO8/5m6TsEf4DMTRm03mvyeYwMeg==
X-Received: by 2002:a19:789:: with SMTP id 131mr18247999lfh.11.1546181988622;
        Sun, 30 Dec 2018 06:59:48 -0800 (PST)
Received: from ?IPv6:2001:14ba:8017:3300:3464:5385:65ba:907d? (dtynxhybzpvl4m5q6wb0t-3.rev.dnainternet.fi. [2001:14ba:8017:3300:3464:5385:65ba:907d])
        by smtp.googlemail.com with ESMTPSA id g3-v6sm9820567lje.50.2018.12.30.06.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Dec 2018 06:59:47 -0800 (PST)
Subject: Re: [PATCH v1 2/2] hwrng: add OP-TEE based rng driver
To:     Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-3-git-send-email-sumit.garg@linaro.org>
 <CAKv+Gu9ShfrBhfCuRK_L_ZtZ3KnN7Jb-4hcX9nSO7AYbT8V8LQ@mail.gmail.com>
 <CAFA6WYN5+NWKpPhnGHRnh_ZOF9A8K=MvbbSQ9uvc2Tv1expXcA@mail.gmail.com>
 <CAKv+Gu-Go=GwsO=_WvmTr-OZb4WMGGQrMb2joxX1Kzfhza3JiA@mail.gmail.com>
 <CAFA6WYPm3_SZ59vOxceZkn0uzcJw3ECQZs5R_Ypz0ejpzTgAbQ@mail.gmail.com>
 <20181228144610.GA21561@jax.urgonet>
From:   =?UTF-8?B?VmVzYSBKw6TDpHNrZWzDpGluZW4=?= <dachaac@gmail.com>
Message-ID: <79744651-991d-ff44-2238-96721ff9bc18@gmail.com>
Date:   Sun, 30 Dec 2018 16:59:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181228144610.GA21561@jax.urgonet>
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181230145946.HO9qEXVsMX0JWrnj-fURscU2B95girS6XpmZOwpS18I@z>

Hi All,

On 28/12/2018 16.46, Jens Wiklander wrote:
> Hi Sumit,
> 
> On Fri, Dec 28, 2018 at 06:33:22PM +0530, Sumit Garg wrote:
>> On Fri, 28 Dec 2018 at 16:08, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> Jens,
>>
>> Is there any particular reason to wait indefinitely in
>> "optee_supp_thrd_req" if there is no supplicant running? I think we
>> should probably return as follows from "optee_supp_thrd_req" API in
>> case no supplicant is available:
>>
>> --- a/drivers/tee/optee/supp.c
>> +++ b/drivers/tee/optee/supp.c
>> @@ -88,10 +88,15 @@ u32 optee_supp_thrd_req(struct tee_context *ctx,
>> u32 func, size_t num_params,
>>   {
>>          struct optee *optee = tee_get_drvdata(ctx->teedev);
>>          struct optee_supp *supp = &optee->supp;
>> -       struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
>> +       struct optee_supp_req *req;
>>          bool interruptable;
>>          u32 ret;
>>
>> +       /* Return in case there is no supplicant available */
>> +       if (!supp->ctx)
>> +               return TEEC_ERROR_COMMUNICATION;
>> +
>> +       req = kzalloc(sizeof(*req), GFP_KERNEL);
>>          if (!req)
>>                  return TEEC_ERROR_OUT_OF_MEMORY;
> 
>  From a user space point of view it has been more useful to just wait
> until the supplicant starts to serve requests than polling the interface
> until the call succeeds. For this new use case it makes more sense to be
> able to return an error instead.
> 
> The proposed change is a user space API change, so we will need to do a
> bit more than that.

There are parts of kernel that need randomness before user space is ready.

Can't we move necessary logic for this to in kernel now that there is 
kernel service requiring TEE services?

I suppose there are even more services that would be better to be only 
optee<->kernel interface and not exposed as such to user space. One 
example of such would be mass storage encryption key or hardware rooted 
encryption for Linux keyring. Eg. replacement for TPM chip when TEE 
environment is available.

Thanks,
Vesa Jääskeläinen
