Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C84C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0432821655
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfJGO3l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfJGO3l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 10:29:41 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E54981F19
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 14:29:40 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v17so7213075wru.12
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 07:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2DH2lGZItnyCxpT638su7JIBUbhf9Wf2K40MEjQfXGs=;
        b=b4mMJlyWODiYKhToELkqytCdL9LOMuz2yVGcODBWA8QvzZ2e09bbk268W0f5JSuYyZ
         B+pRbub8ZhIk0i1z8dv/+VzdPiWj52ReydzkmPt8k6/p2oOie67jFQzXphs1S6qfbhkn
         XOAIxsjiPAlxOa4856R11VzIRkVs/AtQOgHx1ZIVrNtEQfkbZLruo+YV85b0Yt2a1xVZ
         SKwpJAt4lacL5CZ8HctTlyqwhOVS6f7o67z251PmNIC13Xd454pQhiRx/i2R+QC6acPw
         HxEe+Jkk5akFbSOrfYI+kNmGFBq5BZc8ZFIN/Zq6A/onmKIDL+MMhlVHuUhrn0BPdOwI
         EkUA==
X-Gm-Message-State: APjAAAWZhdWpE8HH8pPJuR+bOT56YZ1hth3H240T05b3wdM4cM807CCJ
        NgSsTsKTCulF5ieZ6g9pu1++/KMbLMPBGUL/sulMf7asTX2ad5AD/E403SQb5KD2B8HqIwrkfMw
        z9kX36bLNab39qnPxAzUvtCOS
X-Received: by 2002:a1c:9dc1:: with SMTP id g184mr20208474wme.77.1570458578898;
        Mon, 07 Oct 2019 07:29:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz0iUna5xpCm/klRwotM0QLEzqWJ6+o/3qIKqAoj8z/BjCYdHBrV6duKeSKdnnUjVlquYJsWA==
X-Received: by 2002:a1c:9dc1:: with SMTP id g184mr20208466wme.77.1570458578691;
        Mon, 07 Oct 2019 07:29:38 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id m18sm31573558wrg.97.2019.10.07.07.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:29:38 -0700 (PDT)
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Stephan Mueller <smueller@chronox.de>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
Date:   Mon, 7 Oct 2019 16:29:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191007142230.GA117630@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07-10-2019 16:22, Ingo Molnar wrote:
> 
> * Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> Hi,
>>
>> On 07-10-2019 16:00, Ingo Molnar wrote:
>>>
>>> * Hans de Goede <hdegoede@redhat.com> wrote:
>>>
>>>> The purgatory code now uses the shared lib/crypto/sha256.c sha256
>>>> implementation. This needs memzero_explicit, implement this.
>>>>
>>>> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
>>>> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>> Changes in v2:
>>>> - Add barrier_data() call after the memset, making the function really
>>>>     explicit. Using barrier_data() works fine in the purgatory (build)
>>>>     environment.
>>>> ---
>>>>    arch/x86/boot/compressed/string.c | 6 ++++++
>>>>    1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
>>>> index 81fc1eaa3229..654a7164a702 100644
>>>> --- a/arch/x86/boot/compressed/string.c
>>>> +++ b/arch/x86/boot/compressed/string.c
>>>> @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
>>>>    	return s;
>>>>    }
>>>> +void memzero_explicit(void *s, size_t count)
>>>> +{
>>>> +	memset(s, 0, count);
>>>> +	barrier_data(s);
>>>> +}
>>>
>>> So the barrier_data() is only there to keep LTO from optimizing out the
>>> seemingly unused function?
>>
>> I believe that Stephan Mueller (who suggested adding the barrier)
>> was also worried about people using this as an example for other
>> "explicit" functions which actually might get inlined.
>>
>> This is not so much about protecting against LTO as it is against
>> protecting against inlining, which in this case boils down to the
>> same thing. Also this change makes the arch/x86/boot/compressed/string.c
>> and lib/string.c versions identical which seems like a good thing to me
>> (except for the code duplication part of it).
>>
>> But I agree a comment would be good, how about:
>>
>> void memzero_explicit(void *s, size_t count)
>> {
>> 	memset(s, 0, count);
>> 	/* Avoid the memset getting optimized away if we ever get inlined */
>> 	barrier_data(s);
>> }
> 
> Well, the standard construct for preventing inlining would be 'noinline',
> right? Any reason that wouldn't work?

Good question. I guess the worry is that modern compilers are getting
more aggressive with optimizing and then even if not inlined if the
function gets compiled in the same scope, then the compiler might
still notice it is only every writing to the memory passed in; and
then optimize it away of the write happens to memory which lifetime
ends immediately afterwards. I mean removing the call is not inlining,
so compiler developers might decide that that is still fine to do.

IMHO with trickycode like this is is best to just use the proven
version from lib/string.c

I guess I made the comment to specific though, so how about:

void memzero_explicit(void *s, size_t count)
{
	memset(s, 0, count);
	/* Tell the compiler to never remove / optimize away the memset */
	barrier_data(s);
}

Regards,

Hans
