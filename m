Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A664EC433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Nov 2021 14:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8108E610E9
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Nov 2021 14:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhKFO6d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 6 Nov 2021 10:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbhKFO6d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Nov 2021 10:58:33 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ECFC061570
        for <linux-crypto@vger.kernel.org>; Sat,  6 Nov 2021 07:55:52 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id r10-20020a056830448a00b0055ac7767f5eso17722762otv.3
        for <linux-crypto@vger.kernel.org>; Sat, 06 Nov 2021 07:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z6z7bQGP9QoXYF9m0XlJi4+8f09VHtRvRe+KIdlh/HU=;
        b=gx+g8e8rB9CL5wVuNLbUDjn4HUamEkRExjKFvpYx+XRAfjJbDbbTmLwTlGSVE9McrD
         6utg73N6KJEIHcl7PVyOWlFArGM5QBYcLZzjVnev4j7E1M8dUOYJ/ONC6Q/kJGEZDKr9
         OEWpeGyACEK+eFKp/S6Rs3jCJHp29GDO/N11Tp/5dEzbrpWr56fcemI1+hP71THjUnb3
         4pD6EpSxpKk9HyJl6928QG1in0PZLsykFqC/AVjmEcuwVEkLvuhslKKjyKCoOj/wxd0e
         daSKhS1i8638t5VSv/OlOqI1Wx0JdxJzO7ekW+dZrLnn5OJaH5akpz0LK0jfhTBhOGZs
         9udQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z6z7bQGP9QoXYF9m0XlJi4+8f09VHtRvRe+KIdlh/HU=;
        b=ZGgQHHp0lRO70Fh5sd8PtnhEQfUD7zxNxfV4o6zFKpcW5vye0UrZ71rYYcL/cwIzMK
         KbUbq734+SuhvQHDYkLmFbhr2/zXTNXLNqBXsxbYua3vfgE4mrMD44+ZLaF6ptFyHFx3
         ISnu/ZF5L18qllPSxgt1WzpQ1whPh+ARiPOPSMzouwO1H4Pidq/XF/vqgciVBav7qLL9
         mGSZBfo7iidVntgiGAdpNTZCBRUTzFCjfiIUB8+PMG1uf036QDmXwJgm7gU44QW3g7hu
         vjSVKxn79jsJLP7bTDu6SF39sDRgba0IBjTgYHtC/4tZkTZYuEz4EverVZZVbyw5VERz
         gmsw==
X-Gm-Message-State: AOAM530Jly0UnYqQYHtAmCFFUGdwp1spRvINoYpQkrf6L05EiUrodmLy
        EnHYuQbIpFiiw/ekCjHIt1dRgIg/+wY=
X-Google-Smtp-Source: ABdhPJy9v+sxswyaelRAj2IzjV4MtVeS7bha0QJ6tU3CEe9Ayvo+euQfmOj7jUuubsghZxQNfp/G6A==
X-Received: by 2002:a9d:de1:: with SMTP id 88mr38101898ots.286.1636210551094;
        Sat, 06 Nov 2021 07:55:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u8sm1498218ote.17.2021.11.06.07.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 07:55:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
Date:   Sat, 6 Nov 2021 07:55:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211106034725.GA18680@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/5/21 8:47 PM, Herbert Xu wrote:
> On Tue, Oct 26, 2021 at 09:33:19AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On Fri, Sep 17, 2021 at 08:26:19AM +0800, Herbert Xu wrote:
>>> When complex algorithms that depend on other algorithms are built
>>> into the kernel, the order of registration must be done such that
>>> the underlying algorithms are ready before the ones on top are
>>> registered.  As otherwise they would fail during the self-test
>>> which is required during registration.
>>>
>>> In the past we have used subsystem initialisation ordering to
>>> guarantee this.  The number of such precedence levels are limited
>>> and they may cause ripple effects in other subsystems.
>>>
>>> This patch solves this problem by delaying all self-tests during
>>> boot-up for built-in algorithms.  They will be tested either when
>>> something else in the kernel requests for them, or when we have
>>> finished registering all built-in algorithms, whichever comes
>>> earlier.
>>>
>>> Reported-by: Vladis Dronov <vdronov@redhat.com>
>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>>>
>>
>> I can not explain it, but this patch causes a crash with one of my boot
>> tests (riscv32 with riscv32 virt machine and e1000 network adapter):
>>
>> [    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)
> 
> Does this still occur with the latest patch I sent yesterday?
> 

No, I don't see that problem anymore, neither in mainline with your
patch applied nor in the latest -next with your patch applied.

Guenter

