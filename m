From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 08:11:52 -0400
Message-ID: <CAH8yC8mEt3wac_99+nheKcr8VyoNe9Hvx5K3gm=ucqwLC2yPkA@mail.gmail.com>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Oliver Mangold <o.mangold@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33899 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdGUMLx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 08:11:53 -0400
Received: by mail-oi0-f51.google.com with SMTP id q4so50238045oif.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 05:11:53 -0700 (PDT)
In-Reply-To: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 3:12 AM, Oliver Mangold <o.mangold@gmail.com> wrote:
> Hi,
>
> I was wondering why reading from /dev/urandom is much slower on Ryzen than
> on Intel, and did some analysis. It turns out that the RDRAND instruction is
> at fault, which takes much longer on AMD.
>
> if I read this correctly:
>
> --- drivers/char/random.c ---
>     862         spin_lock_irqsave(&crng->lock, flags);
>     863         if (arch_get_random_long(&v))
>     864                 crng->state[14] ^= v;
>     865         chacha20_block(&crng->state[0], out);
>
> one call to RDRAND (with 64-bit operand) is issued per computation of a
> chacha20 block. According to the measurements I did, it seems on Ryzen this
> dominates the time usage:

AMD's implementation of RDRAND and RDSEED are simply slow. It dates
back to Bulldozer. While Intel can produce random numbers at 10
cycle/sbyte, AMD regularly takes thousands of cycles for one byte.
Bulldozer was measured at 4100 cycles per byte.

It also appears AMD uses the same circuit for random numbers for both
RDRAND and RDSEED. Both are equally fast (or equally slow).

Here are some benchmarks if you are interested:
https://www.cryptopp.com/wiki/RDRAND#Performance .

Jeff
