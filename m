From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 3 Nov 2016 05:26:57 +0800
Message-ID: <20161102212657.GA26887@gondor.apana.org.au>
References: <20161102175810.18647-1-Jason@zx2c4.com>
 <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
 <20161102210802.GA26741@gondor.apana.org.au>
 <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 02, 2016 at 10:25:00PM +0100, Jason A. Donenfeld wrote:
> These architectures select HAVE_EFFICIENT_UNALIGNED_ACCESS:
> 
> s390 arm arm64 powerpc x86 x86_64
> 
> So, these will use the original old code.

What I'm interested in is whether the new code is sufficiently
close in performance to the old code, particularonly on x86.

I'd much rather only have a single set of code for all architectures.
After all, this is meant to be a generic implementation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
