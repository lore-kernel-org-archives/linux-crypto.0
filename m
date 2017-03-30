From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto: gf128mul - define gf128mul_x_ble in gf128mul.h
Date: Thu, 30 Mar 2017 23:32:07 +0200
Message-ID: <CAAUqJDs37N7NETK2DWU5mpV3ZwnYbi399bEpL9HHg8fRawch+A@mail.gmail.com>
References: <20170330192535.23123-1-omosnacek@gmail.com> <20170330195546.GA60896@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:32957 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933271AbdC3Vca (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 17:32:30 -0400
Received: by mail-lf0-f43.google.com with SMTP id h125so34701138lfe.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 14:32:29 -0700 (PDT)
In-Reply-To: <20170330195546.GA60896@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

2017-03-30 21:55 GMT+02:00 Eric Biggers <ebiggers3@gmail.com>:
> This is an improvement; I'm just thinking that maybe this should be done for all
> the gf128mul_x_*() functions, if only so that they use a consistent style and
> are all defined next to each other.

Right, that doesn't seem to be a bad idea... I was confused for a
while by the '& 0xff' in the _lle one, but now I see it also uses just
two values of the table, so it can be re-written in a similar way. In
fact, the OCB mode from RFC 7253 (that I'm currently trying to port to
kernel crypto API) uses gf128mul_x_bbe, so it would be useful to have
that one accessible, too.

I will move them all in v2, then.

> Also note that '(b & ((u64)1 << 63)) ? 0x87 : 0x00;' is actually getting
> compiled as '((s64)b >> 63) & 0x87', which is branchless and therefore makes the
> new version more efficient than one might expect:
>
>         sar    $0x3f,%rax
>         and    $0x87,%eax
>
> It could even be written the branchless way explicitly, but it shouldn't matter.

I think the definition using unsigned operations is more intuitive...
Let's just leave the clever tricks up to the compiler :)

Thanks,
O.M.

>
> - Eric
