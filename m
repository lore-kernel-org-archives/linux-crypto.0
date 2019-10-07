Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0301DC47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 19:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8479206C0
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 19:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfJGTg3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 15:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbfJGTg3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 15:36:29 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFA2385363
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 19:36:28 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id s15so9696742edj.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 12:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ljeQp8GB5NCWoYLQPc6omSfgvu4MNul47KparjzcLdc=;
        b=KU+IkMdbhi51qK5J9j0qRnN24Sh3ObKvZZYE3dHRXEw0WincFFHupBhtnJMu2MHqUY
         yodABmp5M1YHKnLBBYbGNuTCJtbF9QCP3bdImyyNBhivSEhXDFL9hquaEwq7tryHLo/3
         zNoEw6Yd3zNuuH1yMNjGtwS6SeGE6frmXy09xZW+R1dI86IjJi2BTwkcm6GfhdSn4wlv
         vMpbM2Xyu12bU9RM5OdhcrW+HXRlJAngnLj6MKXEu0v2bKH2nh1avTe/AhUpgKQwQRuC
         JwFs+XjOYE+XmUOXm8pjDZE1crB6K0IGn+Dd4G0Xia0cayL0kWyKTs2UTAjj5K8C8bkZ
         RGEA==
X-Gm-Message-State: APjAAAVIUWVvpG4pD4nLmdSr+uT229OJXt5yM09CSt/YpGDmYYf8ared
        q5cXm9Gvxa/MrVPNvWIjgE279NTYGxbYGL1OPHweCZRG0dr4lcvIDDPIgOJWJkbE5+PSvYNEA+R
        7fi3Chv4y5O2kJi3aqZNXW5DF
X-Received: by 2002:a17:906:cec3:: with SMTP id si3mr25362438ejb.145.1570476987604;
        Mon, 07 Oct 2019 12:36:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz6Da4NEDWiQMcaC9fAtmpy1da8A1+7AzwgtoUpoptiUpd1fibFowoiKw31dJ8eZhCyne3fDw==
X-Received: by 2002:a17:906:cec3:: with SMTP id si3mr25362409ejb.145.1570476987315;
        Mon, 07 Oct 2019 12:36:27 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c14-2800-ec23-a060-24d5-2453.cable.dynamic.v6.ziggo.nl. [2001:1c00:c14:2800:ec23:a060:24d5:2453])
        by smtp.gmail.com with ESMTPSA id x5sm1967822ejc.53.2019.10.07.12.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 12:36:26 -0700 (PDT)
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        linux-s390@vger.kernel.org
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
 <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
 <20191007144600.GB59713@gmail.com>
 <20191007152049.GA384920@rani.riverdale.lan>
 <20191007154007.GA96929@gmail.com>
 <20191007184237.GB13589@rani.riverdale.lan>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1d17349e-98ab-b582-6981-b484b0e970b6@redhat.com>
Date:   Mon, 7 Oct 2019 21:36:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191007184237.GB13589@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07-10-2019 20:42, Arvind Sankar wrote:
> On Mon, Oct 07, 2019 at 05:40:07PM +0200, Ingo Molnar wrote:
>>
>> * Arvind Sankar <nivedita@alum.mit.edu> wrote:
>>
>>> With the barrier in there, is there any reason to *not* inline the
>>> function? barrier_data() is an asm statement that tells the compiler
>>> that the asm uses the memory that was set to zero, thus preventing it
>>> from removing the memset even if nothing else uses that memory later. A
>>> more detailed comment is there in compiler-gcc.h. I can't see why it
>>> wouldn't work even if it were inlined.
>>>
>>> If the function can indeed be inlined, we could just make the common
>>> implementation a macro and avoid duplicating it? As mentioned in another
>>> mail, we otherwise will likely need another duplicate implementation for
>>> arch/s390/purgatory as well.
>>
>> I suspect macro would be justified in this case. Mind sending a v3 patch
>> to demonstrate how it would all look like?
>>
>> I'll zap v2 if the macro solution looks better.
>>
>> Thanks,
>>
>> 	Ingo
> 
> Patch attached to turn memzero_explicit into inline function.

Hehe, I had prepared and have just tested the exact same patch
(only the commit msg was different).

I've just booted a kernel build with that patch and that works
fine (as expected).

So your patch is:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>

Since this is a bit of a core change though, I think it is
best if you send it to the linux-kernel list (with my tags from above
added) as is normally done for kernel patches. Then others, who may
not be following this thread, will get a chance to give feedback on it.

Regards,

Hans
