Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F4BC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 14:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45AB0215EA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 14:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WwRmG8HC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfKHOwQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 09:52:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44963 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfKHOwQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 09:52:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id f2so7310039wrs.11
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 06:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O/XoMdhOItgVnyyt8ofQFcj3sIlx0dJO7eZJBuH4Uhw=;
        b=WwRmG8HCyTM+mEiIH3a63WrobNFUO82SWDXoWZbTYioFkLL1kbuFz50ozP6z5KW7Ev
         5p8Kb/eUzUUMKFwo4xk6D+uz5zHeGYrdoN+E4i5ROYcBsBy2zQHo+R0kMOC+VBRc8ID/
         BpFKo/V8oQi4rogs5EEpytjAJ9O/7ttU6KnCqG9+wR1/cqQU/BAMfpJM6muTxn2YTgHZ
         qlrpYRl4nbymlnHjP6SxnBI6XsUNTVZiOI9Sezzfh0l2EiVJ1rNtKDejnV0NXMXlZXjp
         KdEyffgjGMTdHSF03Z7ZuYuewxVRNyXU6gAQjTM5E+jMSWL4/kzgEmbd3UNnEM3fOwRI
         tOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O/XoMdhOItgVnyyt8ofQFcj3sIlx0dJO7eZJBuH4Uhw=;
        b=VEx/lqWzcE58yhdgMdrbXh7WqsO7eaE0Nz3TrSjcBECBPMYLUrJ29ZuMHy24UMRoO1
         ORj35Yru+NtiC9Hq9sNAAOg7UKf/BeJ0YhK1A2mSqCOHQJ98DXOIloNdmorjfYBFyU87
         JgSzrploMZ6ZhO10Y2v+Dc1etcdEeb+pRXPmkZvL7plKd9VK9zMnMeqcMcEf0G13ZSRL
         twp/yspMHZfj6Kq8pRp+1NkcQ4y15tUaWtKiidnAAtzEKfzKesdCS2sDckJpi3vgWvPz
         5uuVt+S8dOdvabpS4gPopqkwwIhte0z8QjlijCRfcundnZ7yuW/1WPtJIQ0TBDDl+h+o
         trpw==
X-Gm-Message-State: APjAAAXMUPJx0CVfoiBt9HAUYq/LtJEMY+K2KC1+s07g3RWZnhNaLUY6
        wDRLpjk/9YpA0Oh4jnzVZea0gg==
X-Google-Smtp-Source: APXvYqxEJJlfAZyIrLv+Gak73UfUDc/IrqE5JANGHlFn1oaBBJ2ARtf2sOtSdlf4jtNQflg1AJ4wGA==
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr8777982wrs.63.1573224734633;
        Fri, 08 Nov 2019 06:52:14 -0800 (PST)
Received: from [192.168.8.102] (212.red-213-99-162.dynamicip.rima-tde.net. [213.99.162.212])
        by smtp.gmail.com with ESMTPSA id a7sm6636928wrr.89.2019.11.08.06.52.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 06:52:14 -0800 (PST)
Subject: Re: [PATCH v4 1/1] arm64: Implement archrandom.h for ARMv8.5-RNG
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
References: <20191106141954.30657-1-rth@twiddle.net>
 <20191106141954.30657-2-rth@twiddle.net>
 <CAKv+Gu8pb5pBFBg0wGoORmaS6yzmoX7L45LLnhuZhqw4JX7d+w@mail.gmail.com>
 <23ce309b-1561-ed95-7ce7-463a991bd19b@linaro.org>
 <CAKv+Gu-03HLED79e+V2D5BtSjRwHH7=rnUWyqZ7dBBD-s7RowQ@mail.gmail.com>
 <CAKv+Gu8y4zwpesytU7vffSCuq8YAjWcHwFHwa_LhTW_cLiSfQw@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <f8c9b7e6-a0f6-211b-0003-a093d2c94e0e@linaro.org>
Date:   Fri, 8 Nov 2019 15:52:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8y4zwpesytU7vffSCuq8YAjWcHwFHwa_LhTW_cLiSfQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/8/19 3:24 PM, Ard Biesheuvel wrote:
>>> To add_interrupt_randomness(), invoked by handle_irq_event_percpu().
>>> Better if I reword the above to include the function name?
>>>
>>
>> This is one of the several places where arch_random_get_seed_long() is
>> called, so if you are going to single it out like that, it does make
>> sense to clarify that.
>>
> 
> Looking more carefully at that code, it seems we call
> arch_get_random_seed_long() NR_CPUS times per second, and assuming
> that our RNDRRS sysreg will be reseeded from a resource that is shared
> between all the cores, I am now wondering if this is such a good fit
> after all, especially in the context of virtualization and
> accessibility of both sysregs all the way down to EL0.
> 
> I propose we go with RNDR instead, at least for the time being, and
> once actual hardware appears, we can try to figure out how these
> pieces best fit together.

This is what I started with, based on the powerpc implementation.
I can certainly revert to that easily.


r~
