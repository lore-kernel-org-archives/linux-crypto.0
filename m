From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH v3] crypto: gf128mul - define gf128mul_x_* in gf128mul.h
Date: Sat, 1 Apr 2017 17:13:51 +0200
Message-ID: <CAAUqJDuaLaAp5JUtekzKTur09SGj1LR0JhWrERg_AbAjAzFxNA@mail.gmail.com>
References: <20170331092703.2520-1-omosnacek@gmail.com> <20170401034407.GA598@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36001 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdDAPON (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 11:14:13 -0400
Received: by mail-lf0-f48.google.com with SMTP id x137so55533071lff.3
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 08:14:12 -0700 (PDT)
In-Reply-To: <20170401034407.GA598@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-04-01 5:44 GMT+02:00 Eric Biggers <ebiggers3@gmail.com>:
> Also, I realized that for gf128mul_x_lle() now that we aren't using the table we
> don't need to shift '_tt' but rather can use the constant 0xe100000000000000:
>
>         /* equivalent to (u64)gf128mul_table_le[(b << 7) & 0xff] << 48
>          * (see crypto/gf128mul.c): */
>         u64 _tt = gf128mul_mask_from_bit(b, 0) & 0xe100000000000000;
>
>         r->b = cpu_to_be64((b >> 1) | (a << 63));
>         r->a = cpu_to_be64((a >> 1) ^ _tt);
>
> I think that would be better and you could send a v4 to do it that way if you
> want.  It's not a huge deal though.

Yes, I was hoping the compiler would be wise enough to fold the shift
into the constant, but I didn't actually check the assembly output...
I took the time to write a quick benchmark and the version without
shift is indeed notably faster.

That said, I'll go the extra mile and send a v4.

Thanks for the review!

O.M.
