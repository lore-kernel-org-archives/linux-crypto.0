From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 3 Nov 2016 08:49:34 +0800
Message-ID: <20161103004934.GA30775@gondor.apana.org.au>
References: <20161102175810.18647-1-Jason@zx2c4.com>
 <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
 <20161102210802.GA26741@gondor.apana.org.au>
 <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
 <20161102212657.GA26887@gondor.apana.org.au>
 <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37843 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbcKCAtp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 20:49:45 -0400
Content-Disposition: inline
In-Reply-To: <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 02, 2016 at 11:00:00PM +0100, Jason A. Donenfeld wrote:
>
> Just tested. I get a 6% slowdown on my Skylake. No good. I think it's
> probably best to have the two paths in there, and not reduce it to
> one.

FWIW I'd rather live with a 6% slowdown than having two different
code paths in the generic code.  Anyone who cares about 6% would
be much better off writing an assembly version of the code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
