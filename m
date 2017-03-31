From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] crypto: gf128mul - define gf128mul_x_ble in gf128mul.h
Date: Fri, 31 Mar 2017 02:05:02 -0400
Message-ID: <CAH8yC8nNJZ9yhvffkz7Fqg=zXFJTA+VQohAWa=8RFkpMBsY_qQ@mail.gmail.com>
References: <20170330192535.23123-1-omosnacek@gmail.com> <20170330195546.GA60896@gmail.com>
 <CAAUqJDs37N7NETK2DWU5mpV3ZwnYbi399bEpL9HHg8fRawch+A@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35365 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdCaGFE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2017 02:05:04 -0400
Received: by mail-oi0-f53.google.com with SMTP id f193so51429778oib.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 23:05:03 -0700 (PDT)
In-Reply-To: <CAAUqJDs37N7NETK2DWU5mpV3ZwnYbi399bEpL9HHg8fRawch+A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> Also note that '(b & ((u64)1 << 63)) ? 0x87 : 0x00;' is actually getting
>> compiled as '((s64)b >> 63) & 0x87', which is branchless and therefore makes the
>> new version more efficient than one might expect:
>>
>>         sar    $0x3f,%rax
>>         and    $0x87,%eax
>>
>> It could even be written the branchless way explicitly, but it shouldn't matter.
>
> I think the definition using unsigned operations is more intuitive...
> Let's just leave the clever tricks up to the compiler :)

It may be a good idea to use the one that provides constant time-ness
to help avoid leaking information.

Jeff
