From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto: gf128mul - define gf128mul_x_ble in gf128mul.h
Date: Fri, 31 Mar 2017 11:17:12 +0200
Message-ID: <CAAUqJDtE0AE7gf6m4=Q=6ZXvZa4bqByCYYMoKbwV+2RCaJYFZg@mail.gmail.com>
References: <20170330192535.23123-1-omosnacek@gmail.com> <20170330195546.GA60896@gmail.com>
 <CAAUqJDs37N7NETK2DWU5mpV3ZwnYbi399bEpL9HHg8fRawch+A@mail.gmail.com> <CAH8yC8nNJZ9yhvffkz7Fqg=zXFJTA+VQohAWa=8RFkpMBsY_qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34082 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbdCaJRf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2017 05:17:35 -0400
Received: by mail-lf0-f41.google.com with SMTP id z15so40438551lfd.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2017 02:17:34 -0700 (PDT)
In-Reply-To: <CAH8yC8nNJZ9yhvffkz7Fqg=zXFJTA+VQohAWa=8RFkpMBsY_qQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jeff,

2017-03-31 8:05 GMT+02:00 Jeffrey Walton <noloader@gmail.com>:
>>> Also note that '(b & ((u64)1 << 63)) ? 0x87 : 0x00;' is actually getting
>>> compiled as '((s64)b >> 63) & 0x87', which is branchless and therefore makes the
>>> new version more efficient than one might expect:
>>>
>>>         sar    $0x3f,%rax
>>>         and    $0x87,%eax
>>>
>>> It could even be written the branchless way explicitly, but it shouldn't matter.
>>
>> I think the definition using unsigned operations is more intuitive...
>> Let's just leave the clever tricks up to the compiler :)
>
> It may be a good idea to use the one that provides constant time-ness
> to help avoid leaking information.

That's a good point... I played around with various ways to write the
expression in Compiler Explorer [1] and indeed GCC fails to produce
constant-time code from my version on some architectures (e.g. the
32-bit ARM). The version with an explicit arithmetic right shift seems
to produce the most efficient code across platforms, so I'll rewrite
it like that for v3.

Thanks,
O.M.

[1] https://gcc.godbolt.org/
