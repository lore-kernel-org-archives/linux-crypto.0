From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Wed, 2 Nov 2016 23:00:00 +0100
Message-ID: <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
References: <20161102175810.18647-1-Jason@zx2c4.com> <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
 <20161102210802.GA26741@gondor.apana.org.au> <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
 <20161102212657.GA26887@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:34403 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755930AbcKBWAN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 18:00:13 -0400
In-Reply-To: <20161102212657.GA26887@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 2, 2016 at 10:26 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> What I'm interested in is whether the new code is sufficiently
> close in performance to the old code, particularonly on x86.
>
> I'd much rather only have a single set of code for all architectures.
> After all, this is meant to be a generic implementation.

Just tested. I get a 6% slowdown on my Skylake. No good. I think it's
probably best to have the two paths in there, and not reduce it to
one.
