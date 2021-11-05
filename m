Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39B8C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D387961212
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhKEF61 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 01:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKEF61 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 01:58:27 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3BDC061714;
        Thu,  4 Nov 2021 22:55:47 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bk26so11812777oib.11;
        Thu, 04 Nov 2021 22:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XDpbk0CjUO6wptdfXZsGqs7XWvEwmhygwgg9SfGstx0=;
        b=CMZBHcSY/V+KSkMPQUASl7A/QjSxxoG63LnMCee+X8Vj1wLfEDzPSlMCQklIDCR1k7
         OJQZwv86ATdqFe2bAGopcbscz/eGP87GWvTfl48Xw0+sfLr8bQEX0DN62coBh/oSLpSk
         3sJZVWtUgglIwddK4vwQsOLjA1dxD/F/a3Efy8Q9AwSXJxMf2ItbkLdsfD96SwD3V6ZE
         qwKQhjgrjjyNlXBjyvAcJGYMKpfpM/cqotWBSRL3illtRa+COLz9e0BSlgx6bMNXJuwi
         lwvsLq6V1cVxruIi5O7sLiJUrcRps5Z0/yvc/diUap6SOAwImBuXDUHXGk6LOkmvayra
         waAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XDpbk0CjUO6wptdfXZsGqs7XWvEwmhygwgg9SfGstx0=;
        b=esuEOE5m2GqxXWnPGhULCaG+V2dVV/CuPQTlAS2nyyJTZ0ImJYnYd04JWyhFsBAAXs
         NnpsKKsxxRqAFODesR9cyFSFlJ1sFeljyOXk/Pp4w+G/cm8WuD1Rc9w0xGF2iraVNEex
         HEROwMqmnjbZpkfZwGEpgoMmwGGOkGxZBu9RzePHGk0eI/peFlu+aMY/kxp5fmx+aIAU
         AfA0WtMAeV1I2K4rWutpmCh4hlYdZWqyZUPxJ39nZz3gZBzHY5Zw4tb/ROiS2g1G8diA
         2LsfskPS/SALsYxIgE09g3CO3vqLMhsoup5fdGYX0KFnSQFWRy0AbpLY5HEok9mRl6Sm
         YEwg==
X-Gm-Message-State: AOAM532vZpOhKGqHJTBW10Nv2HPBXZFqAzWNyzq/48+abqgl+i/Lh9vn
        ffa5OdKJFTyNOSzh3tsXvkNacXRkFmw=
X-Google-Smtp-Source: ABdhPJxal+aaRfjiVyH+0JZx081O0ZAQGkNRyjnrzyN/ogqJFf9NX1c5sQuoOscyjFNoOlP3NMokzA==
X-Received: by 2002:a05:6808:243:: with SMTP id m3mr7273522oie.74.1636091746460;
        Thu, 04 Nov 2021 22:55:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm1912963otr.32.2021.11.04.22.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 22:55:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <ac79dba2-c527-783b-6d0f-b879908bb5b6@roeck-us.net>
 <20211105054137.GA12470@gondor.apana.org.au>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: crashes in crypto_shash_update()
Message-ID: <9091d62b-debf-7a9e-e199-94700af954c6@roeck-us.net>
Date:   Thu, 4 Nov 2021 22:55:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211105054137.GA12470@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/4/21 10:41 PM, Herbert Xu wrote:
> On Thu, Nov 04, 2021 at 10:35:41PM -0700, Guenter Roeck wrote:
>> Hi all,
>>
>> I see the following pretty widespread crash in crypto_shash_update().
>>
>> [    1.574992] Unable to handle kernel paging request at virtual address ffffffffffffffc8
>> [    1.575611] Oops [#1]
>> [    1.575698] Modules linked in:
>> [    1.575866] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.15.0-10159-gb8c4a6bfae4e-dirty #1
>> [    1.576120] Hardware name: riscv-virtio,qemu (DT)
>> [    1.576281] epc : crypto_shash_update+0xa/0x2e
>> [    1.576437]  ra : crc32c+0x2c/0x58
>> [    1.576553] epc : ffffffff80358b6c ra : ffffffff80395382 sp : ffffffd00021bc00
>> [    1.576760]  gp : ffffffff81513898 tp : ffffffe001aa8040 t0 : ffffffe001d10568
>> [    1.576966]  t1 : 000000006a138faa t2 : 0000000000000000 s0 : ffffffd00021bc10
>> [    1.577173]  s1 : ffffffff8149e500 a0 : ffffffd00021bc10 a1 : ffffffff81077e70
>> [    1.577378]  a2 : 0000000000000011 a3 : 0000000000000000 a4 : ffffffffffffffb0
>> [    1.577584]  a5 : ffffffffffffffb0 a6 : 0000000000000000 a7 : 0000000028292846
>> [    1.577797]  s2 : ffffffff81077e70 s3 : ffffffff81514008 s4 : ffffffff80c004e0
>> [    1.578005]  s5 : ffffffff81514038 s6 : ffffffff80c10910 s7 : ffffffff80c004a0
>> [    1.578212]  s8 : ffffffff811669a8 s9 : 0000000000000008 s10: ffffffff80a000ac
>> [    1.578421]  s11: 0000000000000000 t3 : 0000000000000009 t4 : 0000000042300000
>> [    1.578628]  t5 : 0000000000000000 t6 : ffffffe003075000
>> [    1.578785] status: 0000000000000120 badaddr: ffffffffffffffc8 cause: 000000000000000d
>> [    1.579010] [<ffffffff80358b6c>] crypto_shash_update+0xa/0x2e
>> [    1.579186] [<ffffffff80395382>] crc32c+0x2c/0x58
>> [    1.579332] [<ffffffff80a1459a>] btrfs_props_init+0x32/0x70
>> [    1.579505] [<ffffffff80a13e26>] init_btrfs_fs+0x12/0x16a
>> [    1.579670] [<ffffffff800020da>] do_one_initcall+0x36/0x15e
>> [    1.579838] [<ffffffff80a00f5c>] kernel_init_freeable+0x1a6/0x20a
>> [    1.580023] [<ffffffff808d6648>] kernel_init+0x1e/0x104
>> [    1.580181] [<ffffffff80002ffa>] ret_from_exception+0x0/0xc
>> [    1.580700] ---[ end trace 4bfa11496ef965ab ]---
>>
>>
>> The problem boils down to crypto_alloc_shash() returning -80 (-ELLIBBAD).
>>
>> Before I spend time analyzing this further, is anyone already looking
>> into the problem ?
> 
> Can you confirm that CRYPTO_MANAGER is unset in your config? If
> so I'm aware of the problem and working on a fix.
> 

Yes. Also, I found out that (blindly - bisect didn't work) reverting commit
cad439fc040e ("crypto: api - Do not create test larvals if manager is disabled")
fixes the problem.

It might also be worthwhile to add some error checking into lib/libcrc32c.c
to avoid dereferencing the ERR_PTR.

Thanks,
Guenter
