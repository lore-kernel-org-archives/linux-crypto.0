Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A936FC47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8675321721
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 14:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfJGOLz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbfJGOLz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 10:11:55 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD15B12E5
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 14:11:54 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id r21so3380947wme.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 07:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dds3OvwkpQnHLh7gK9rCz/VJSlfyc8rH9MYu6DcxntY=;
        b=BlJPYxsNAr33mawqWApB1jnhwcolfZnKgqUGFzpCvjhL9xVwChMCKstgrP5dsm0h+F
         DwbSt2bhvX0ZrNgquciZ16m/KU8VYpgAs5wAGGQoOOZEBGnJUhnsUSma7b6rrUGPVdIo
         HSbkbZ2UauXECdZ7zWb7y4n8DdLfn7KSi8UzvmUurgFLzU09yGjEn4V0WCVMkxqNVE9p
         +DqVQT0MD6EIYfVrdXLKCRMSLp9m95Ft0A5uft23YOkbN6w9BEVRZRaE3BZGWKEB/j/O
         Of9u2qilqEu66NAzKKPL3f2NITXCKk79i5ySipdwvbfHaaV3ugxGvULEkt7ewmrevwhn
         qzfA==
X-Gm-Message-State: APjAAAUlFy6FhG8yLu0Wrbv2hV5ef5I+WpSXVrLzSU20ii4X8HrdiA4b
        URTaeygZpKEAqFvprlE21qkkij6Tyr6O4VTM/m3YdrE5e6G17oCd6dzabA3y9Dl39IcFaRC9M3w
        DnPttcptQ6nobV6QaDmyMqx7V
X-Received: by 2002:a1c:7fcc:: with SMTP id a195mr21312092wmd.27.1570457513304;
        Mon, 07 Oct 2019 07:11:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYTyoIwPzDW4aRJHwHWLwU6T2w5yp141GiuUdu7dnGllLKuK8ivHmCc/bBrlABqUO0g39JMA==
X-Received: by 2002:a1c:7fcc:: with SMTP id a195mr21312068wmd.27.1570457513112;
        Mon, 07 Oct 2019 07:11:53 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id z125sm28609038wme.37.2019.10.07.07.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:11:52 -0700 (PDT)
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
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
Date:   Mon, 7 Oct 2019 16:11:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191007140022.GA29008@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07-10-2019 16:00, Ingo Molnar wrote:
> 
> * Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> The purgatory code now uses the shared lib/crypto/sha256.c sha256
>> implementation. This needs memzero_explicit, implement this.
>>
>> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
>> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Add barrier_data() call after the memset, making the function really
>>    explicit. Using barrier_data() works fine in the purgatory (build)
>>    environment.
>> ---
>>   arch/x86/boot/compressed/string.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
>> index 81fc1eaa3229..654a7164a702 100644
>> --- a/arch/x86/boot/compressed/string.c
>> +++ b/arch/x86/boot/compressed/string.c
>> @@ -50,6 +50,12 @@ void *memset(void *s, int c, size_t n)
>>   	return s;
>>   }
>>   
>> +void memzero_explicit(void *s, size_t count)
>> +{
>> +	memset(s, 0, count);
>> +	barrier_data(s);
>> +}
> 
> So the barrier_data() is only there to keep LTO from optimizing out the
> seemingly unused function?

I believe that Stephan Mueller (who suggested adding the barrier)
was also worried about people using this as an example for other
"explicit" functions which actually might get inlined.

This is not so much about protecting against LTO as it is against
protecting against inlining, which in this case boils down to the
same thing. Also this change makes the arch/x86/boot/compressed/string.c
and lib/string.c versions identical which seems like a good thing to me
(except for the code duplication part of it).

But I agree a comment would be good, how about:

void memzero_explicit(void *s, size_t count)
{
	memset(s, 0, count);
	/* Avoid the memset getting optimized away if we ever get inlined */
	barrier_data(s);
}

?

Regards,

Hans
