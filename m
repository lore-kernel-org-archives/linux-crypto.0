From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Wed, 2 Nov 2016 16:47:33 -0400
Message-ID: <CACXcFmnEWbGmBc-RmkuOacVVH5sVtdC8ca7Jgbqx2+6TmTPzCg@mail.gmail.com>
References: <20161102175810.18647-1-Jason@zx2c4.com> <20161102200959.GA23297@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:32858 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755198AbcKBUrf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 16:47:35 -0400
In-Reply-To: <20161102200959.GA23297@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 2, 2016 at 4:09 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Nov 02, 2016 at 06:58:10PM +0100, Jason A. Donenfeld wrote:
>> On MIPS chips commonly found in inexpensive routers, this makes a big
>> difference in performance.
>>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Can you give some numbers please? What about other architectures
> that your patch impacts?

In general it is not always clear that using whatever hardware crypto
is available is a good idea. Not all such hardware is fast, some CPUs
are, some CPUs have hardware for AES, and even if the hardware is
faster than the CPU, the context switch overheads may exceed the
advantage.

Ideally the patch development or acceptance process would be
testing this, but I think it might be difficult to reach that ideal.

The exception is a hardware RNG; that should always be used unless
it is clearly awful. It cannot do harm, speed is not much of an issue,
and it solves the hardest problem in the random(4) driver, making
sure of correct initialisation before any use.
