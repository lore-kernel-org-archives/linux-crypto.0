From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - limit mask and type
Date: Fri, 22 Dec 2017 18:58:43 +1100
Message-ID: <20171222075843.GB27971@gondor.apana.org.au>
References: <001a1141c43ad30ccf055efb76ed@google.com>
 <3658547.Hu7AXH7hma@positron.chronox.de>
 <20171222073606.GC27149@gondor.apana.org.au>
 <1779114.sJA4SrkMo1@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ebiggers3@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1779114.sJA4SrkMo1@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 22, 2017 at 08:41:10AM +0100, Stephan Mueller wrote:
>
> Shouldn't we then rather use a white list instead of a black list?
> > 
> > Most other problems however would be bugs in the template code.
> > The first thing a template does when it creates an instance is
> > to check whether the resulting algorithm would fulfil the requested
> > type/mask using crypto_check_attr_type.  So if that's not working
> > then we should fix it there as it may also be triggered via other
> > code paths that can create instances.
> 
> I think I understand that, but does user space need to utilize this logic?

I'm open to a white list as well.  But we should certainly fix
the underlying bugs rather than just papering over them as they
could come back via other channels.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
