Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4802CECE58D
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2026021721
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfJGNA5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfJGNA4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 09:00:56 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C636A7FDFA
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 13:00:55 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id o92so8943818edb.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 06:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RFA7yYzS4TPNopx3VtKxrY+qRQi7qt3i6uEx9e5IUzo=;
        b=n5BXgloJPQ90C/9LFI5IQx7D9o0xX4ppOmfpsv5pzItLfpN8ZADH+QC9X1W1F0cFxo
         0u/jUkocLGrFW6YSjRmcrpg+uo9j1/AGHDq7kbI8/GNyBKmIX63KhR4381zbWG9jS3qe
         YmcgLgNVE31jANFB9ymF+XDA12NRc7pD+cgE3ySm1kk6Ohsbj8RlSRjvUYWFa9gJoo9L
         cItpV1Fgh29Pth/TLxBu6bhHzFec4isdIRRNVSG6O4lIN+ZMyhbXl3ZqdHc4WlrBqZYc
         JIb6dSQ0CLnByI8fTQi+3UvaC0v+/Sov0jsU/nlK931yvTWxssjEAdYBOHlmjD7pqWbf
         llxA==
X-Gm-Message-State: APjAAAVjpAvkZy3pfqeIRI37sODcN02hf7UN/o7Vf/yjzspnIojI7yXn
        Okjal+ZcTCBqkUpJkTe/04Sl3nUit9Kzg/W9Kuo8GVyGwzgGNdxDd/OzbzIV8uHevaZRwnemiEc
        GCcIDPTwPTjoIRkcLYj59GOvl
X-Received: by 2002:a17:906:3110:: with SMTP id 16mr9524801ejx.306.1570453253882;
        Mon, 07 Oct 2019 06:00:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx6f7du1JuEgCrlIaBKI32GWF8ovChQHd87ogGR9w5BrT/KZ6Jvz6shNx2HfyEuK96FDQHVpA==
X-Received: by 2002:a17:906:3110:: with SMTP id 16mr9524746ejx.306.1570453253395;
        Mon, 07 Oct 2019 06:00:53 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id o31sm3324629edd.17.2019.10.07.06.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 06:00:52 -0700 (PDT)
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
References: <20191007085501.23202-1-hdegoede@redhat.com>
 <65461301.CAtk0GNLiE@tauon.chronox.de>
 <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
 <12200313.ic8YZTgDOU@tauon.chronox.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1da4c70f-c303-5469-6978-77a03f4cf792@redhat.com>
Date:   Mon, 7 Oct 2019 15:00:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <12200313.ic8YZTgDOU@tauon.chronox.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On 07-10-2019 11:34, Stephan Mueller wrote:
> Am Montag, 7. Oktober 2019, 11:06:04 CEST schrieb Hans de Goede:
> 
> Hi Hans,
> 
>> Hi Stephan,
>>
>> On 07-10-2019 10:59, Stephan Mueller wrote:
>>> Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:
>>>
>>> Hi Hans,
>>>
>>>> The purgatory code now uses the shared lib/crypto/sha256.c sha256
>>>> implementation. This needs memzero_explicit, implement this.
>>>>
>>>> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
>>>> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
>>>> input, memzero_explicit") Signed-off-by: Hans de Goede
>>>> <hdegoede@redhat.com>
>>>> ---
>>>>
>>>>    arch/x86/boot/compressed/string.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/arch/x86/boot/compressed/string.c
>>>> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe
>>>> 100644
>>>> --- a/arch/x86/boot/compressed/string.c
>>>> +++ b/arch/x86/boot/compressed/string.c
>>>> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
>>>>
>>>>    	return s;
>>>>    
>>>>    }
>>>>
>>>> +void memzero_explicit(void *s, size_t count)
>>>> +{
>>>> +	memset(s, 0, count);
>>>
>>> May I ask how it is guaranteed that this memset is not optimized out by
>>> the
>>> compiler, e.g. for stack variables?
>>
>> The function and the caller live in different compile units, so unless
>> LTO is used this cannot happen.
> 
> Agreed in this case.
> 
> I would just be worried that this memzero_explicit implementation is assumed
> to be protected against optimization when used elsewhere since other
> implementations of memzero_explicit are provided with the goal to be protected
> against optimizations.
>>
>> Also note that the previous purgatory private (vs shared) sha256
>> implementation had:
>>
>>           /* Zeroize sensitive information. */
>>           memset(sctx, 0, sizeof(*sctx));
>>
>> In the place where the new shared 256 code uses memzero_explicit() and the
>> new shared sha256 code is the only user of the
>> arch/x86/boot/compressed/string.c memzero_explicit() implementation.
>>
>> With that all said I'm open to suggestions for improving this.
> 
> What speaks against the common memzero_explicit implementation?

Nothing, but the purgatory is a standalone binary which runs between
2 kernels when doing kexec so it cannot use the function from lib/string.c
since it is not linked against the lib/string.o object.

> If you cannot
> use it, what about adding a barrier in the memzero_explicit implementation? Or
> what about adding some compiler magic as attached to this email?

Since the purgatory code is running in a somewhat limited environment,
with not all standard headers / macros available I was afraid that the
barrier_data() from the lib/string.c implementation would not work, so
I left it out. In hindsight I should have really given it a try first as
it seems to compile fine and there are no missing symbols in
arch/x86/purgatory/purgatory.ro when using it.

So I will send out a new version with the barrier_data() added making
the arch/x86/boot/compressed/string.c implementation identical to the
lib/string.c one.

Regards,

Hans

