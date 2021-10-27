Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB75C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 03:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348CF6109D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 03:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237894AbhJ0Duk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbhJ0Duj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 23:50:39 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36D2C061745
        for <linux-crypto@vger.kernel.org>; Tue, 26 Oct 2021 20:48:13 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id g125so1639093oif.9
        for <linux-crypto@vger.kernel.org>; Tue, 26 Oct 2021 20:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O61utyFCh45BGCY/6xEqjSGoDqQCeSTBEDoOCoOpz0k=;
        b=ZHulCIeA1s5ATY5hoRB/l6wND2YDHI22/l7zkoN4IuL+BmIu7eWRj4ZIxsnqo5vCc3
         bi/c+UsIgfZ7Tewd+XhUp+1/Dj4Zbso0qc/QlnKHis3vfadDPY7+LEYWj/XL8edOjj8K
         8JEJN2ECkJ7QqTEH1NQ2deM0TwcurGP0RbrYfAcX35fEM214ovAP9GG0/xHBWgU4mGJg
         2MXxoYwT5u3QTXF3gHcMZzDsYf7HzVQha1pmE2DktXH/O+xdouqw2KOhjN2jVpidO8Ax
         iGODa7/vd+zPGXDCyQ8X+eLy2tN6oXM6b1udESw/5ulMuTxssIXvf1hiwnnpW46UKQbr
         gjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O61utyFCh45BGCY/6xEqjSGoDqQCeSTBEDoOCoOpz0k=;
        b=XzwapJA2KL4U2PEFvyd9qT7XC87y1KYOJNyDB8pBC+jNvFg6Q4TqHvonYDz1tQ2O4t
         eE5COodE3VymEMkwpk+oCZBB4DGVTQsDIIXsBOGpYKGKKpX7++DEuwbzVCGDzDKsYT5Z
         OzFvMbM9NyKLjWSw8rTaZPWsBvwSgwXNe7HJjvaUhWskphpIplBzAZ3YkJ0Yd7bdyEAn
         /s6fDTrQY60jFb5mXR6R+wutMt7dgwkVJ8307vFVGfawlet94wCM6WtJFYBJ5m2rApqp
         9OdJTqo/8U7dmAvYmiANGqX6VC4gf76zLbKSctPx5U71OgelsKjPHVc6U9ODi8Vvm8lK
         LwEg==
X-Gm-Message-State: AOAM533E6YyGpZELAh+PJMG0WU0oz2dSuqJINmJDVWik+8tIeeXDISFg
        WNq4LzNoNxosEkbuuiM6OTp9wfXRJqg=
X-Google-Smtp-Source: ABdhPJzo68Qu3V8qFo+ZjDq5KdXf5Po2swwbZ+nC1BE+Z4MMamk0cVm5h6qf03MUvj2MieqaIYldHA==
X-Received: by 2002:a54:448e:: with SMTP id v14mr1999495oiv.174.1635306493181;
        Tue, 26 Oct 2021 20:48:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a71sm469991ooc.10.2021.10.26.20.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 20:48:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211027025913.GB24480@gondor.apana.org.au>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <7ac86f69-95c8-1059-3955-2b7fba6e7eb0@roeck-us.net>
Date:   Tue, 26 Oct 2021 20:48:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211027025913.GB24480@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/26/21 7:59 PM, Herbert Xu wrote:
> On Tue, Oct 26, 2021 at 09:33:19AM -0700, Guenter Roeck wrote:
>>
>> I can not explain it, but this patch causes a crash with one of my boot
>> tests (riscv32 with riscv32 virt machine and e1000 network adapter):
>>
>> [    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)
>> [    9.968578] Unable to handle kernel paging request at virtual address 9e000000
>> [    9.969207] Oops [#1]
>> [    9.969325] Modules linked in:
>> [    9.969619] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc6-next-20211025 #1
>> [    9.969983] Hardware name: riscv-virtio,qemu (DT)
>> [    9.970262] epc : e1000_io_write+0x10/0x1c
>> [    9.970487]  ra : e1000_reset_hw+0xfa/0x312
>> [    9.970639] epc : c07b3a44 ra : c07b5e4a sp : c258dcf0
>> [    9.970792]  gp : c1d6cfa0 tp : c25b0040 t0 : c1f05b3c
>> [    9.970941]  t1 : 04d6d7d4 t2 : 00001fff s0 : c258dd00
>> [    9.971091]  s1 : c36a9990 a0 : c36a9990 a1 : 9e000000
>> [    9.971240]  a2 : 00000000 a3 : 04000000 a4 : 00000002
>> [    9.971389]  a5 : 9e000000 a6 : 00000000 a7 : 00006000
>> [    9.971539]  s2 : c101b3ec s3 : c23aceb0 s4 : 04140240
>> [    9.971692]  s5 : 00000000 s6 : c14a3550 s7 : c1d72000
>> [    9.971872]  s8 : 00000000 s9 : c36a9000 s10: 00000000
>> [    9.972037]  s11: 00000000 t3 : cb75ee6c t4 : 0000000c
>> [    9.972200]  t5 : 000021cb t6 : c1f017a0
>> [    9.972336] status: 00000120 badaddr: 9e000000 cause: 0000000f
>> [    9.972570] [<c07b3a44>] e1000_io_write+0x10/0x1c
>> [    9.973382] ---[ end trace 49388ec34793549e ]---
>> [    9.973873] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
>>
>> Bisect log is attached. Reverting this patch fixes the problem. The problem
>> is always seen with this patch applied, and is never seen with this patch
>> reverted.
>>
>> Any idea what might be going on, and how to debug the problem ?
> 
> Could you please send me the complete boot log, as well as the
> kernel config file please?
> 

You should find everything you should need to reproduce the problem,
including a full crash log, at http://server.roeck-us.net/qemu/riscv32/.

Hope this helps,

Guenter
