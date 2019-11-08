Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA576C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A94B920869
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nttfrdji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfKHLKE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:10:04 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41469 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfKHLKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 06:10:04 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so6550735wrm.8
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 03:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rUxh3vvwbZXzco325awc1KArm39f6mGwBPXY04coXF0=;
        b=NttfrdjiyBRmEK/c68Q9ORoq0LjyS9dQetAJmr/e2bJfmCuMwPZITZsARjWWKqyglD
         ziONDNHl8/n9KGlRZYBhVfPR7BLx1QsrZFCQE7W/PmvBJefa77vFU7IIdaMcZ5nbdyNC
         EzAnBTveWi3yoYUMSWQobzuzjgDWmn3gO750sFglp84qYhnPZ+3HOhKCtllW4yYcSAQ5
         imiilQZEXJAOPM3S7O32sWhulSvNtG+MfzejMwEbert2soo9CkI30z+Aer1PTB8X+cjf
         v8eEpXN5F8eh/8z6Vf1W5KhsMQmXahUMsYi2dsKg1+v8CjF312DXuidSOlvveLU6W6K7
         KpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUxh3vvwbZXzco325awc1KArm39f6mGwBPXY04coXF0=;
        b=PzCNtZByRo+eJ99psh7BBc/wNX+ZE8gjnkO2k65Sk98bfKBJ6nNsQxTfOtvxj/nBWW
         pM0i2XvS4Z7DG8407SjCYyG7EUKywo7lOFVA21iUMDTDegYzzKJ7a1o0xEWIbnHTtH8a
         Ib2ETjCPCCkgMvauBEWzhoy4T/vUAqQLt+Sg/tJcXg+/UZ+j2u0bGdNpJU2pX/M5o/ma
         VCvc68nzidtQrgevvJ5QV1/QTyog3T1ZtuS/x3pZdOkgrLhv/9WndRcKKNYkGqwsX5/R
         xwbnG+JI2LoWROBN4XzNR3/yBwLUz4iPWz1Effy+l1h3G+nUl1CiWPd3UwC6Uq58hb9s
         UKLQ==
X-Gm-Message-State: APjAAAUzdf7CTboNejgi/Te/V4oZfY/r00uYx19fVnuh+oO9aqL9Fy6R
        jFovyD27OcGNEvLpA1fNTN6MkQ==
X-Google-Smtp-Source: APXvYqy/FKh+QZ1oUxzXbC2agwYXqjQCXnZiNSUvhj29pnp99dCgr+ywRtnGy75nJWz3iPnTaOG58w==
X-Received: by 2002:adf:f192:: with SMTP id h18mr8283597wro.148.1573211400989;
        Fri, 08 Nov 2019 03:10:00 -0800 (PST)
Received: from [192.168.8.102] (212.red-213-99-162.dynamicip.rima-tde.net. [213.99.162.212])
        by smtp.gmail.com with ESMTPSA id j10sm51846wrx.30.2019.11.08.03.09.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 03:10:00 -0800 (PST)
Subject: Re: [PATCH v4 1/1] arm64: Implement archrandom.h for ARMv8.5-RNG
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
References: <20191106141954.30657-1-rth@twiddle.net>
 <20191106141954.30657-2-rth@twiddle.net>
 <CAKv+Gu8pb5pBFBg0wGoORmaS6yzmoX7L45LLnhuZhqw4JX7d+w@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <23ce309b-1561-ed95-7ce7-463a991bd19b@linaro.org>
Date:   Fri, 8 Nov 2019 12:09:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8pb5pBFBg0wGoORmaS6yzmoX7L45LLnhuZhqw4JX7d+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/6/19 10:30 PM, Ard Biesheuvel wrote:
> On Wed, 6 Nov 2019 at 15:20, Richard Henderson
> <richard.henderson@linaro.org> wrote:
>> +static inline bool has_random(void)
>> +{
>> +       /*
>> +        * We "have" RNG if either
>> +        * (1) every cpu in the system has RNG, or
>> +        * (2) in a non-preemptable context, current cpu has RNG.
>> +        * Case 1 is the expected case when RNG is deployed, but
>> +        * case 2 is present as a backup in case some big/little
>> +        * system only has RNG on big cpus, we can still add entropy
>> +        * from the interrupt handler of the big cpus.
> 
> I don't understand the reference to the interrupt handler here.

To add_interrupt_randomness(), invoked by handle_irq_event_percpu().
Better if I reword the above to include the function name?

> It is
> worth mentioning though that this arrangement permits
> rand_initialize() to use the instructions regardless of whether they
> are implemented only by the boot CPU or by all of them.

Yes, I'll include that.


r~
