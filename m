From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 3 Nov 2016 05:08:02 +0800
Message-ID: <20161102210802.GA26741@gondor.apana.org.au>
References: <20161102175810.18647-1-Jason@zx2c4.com>
 <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 02, 2016 at 10:06:39PM +0100, Jason A. Donenfeld wrote:
> On Wed, Nov 2, 2016 at 9:09 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Can you give some numbers please? What about other architectures
> > that your patch impacts?
> 
> Per [1], the patch gives a 181% speed up on MIPS32r2.
> 
> [1] https://lists.zx2c4.com/pipermail/wireguard/2016-September/000398.html

What about architectures? In particular, what if we just use your
new code for all architectures.  How much would we lose?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
