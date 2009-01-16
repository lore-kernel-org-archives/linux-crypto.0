From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 12:53:57 +1100
Message-ID: <20090116015356.GA9822@gondor.apana.org.au>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com> <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com> <1232068858.5937.222.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: roel kluin <roel.kluin@gmail.com>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56328 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755432AbZAPByF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 20:54:05 -0500
Content-Disposition: inline
In-Reply-To: <1232068858.5937.222.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 16, 2009 at 09:20:58AM +0800, Huang Ying wrote:
> On Thu, 2009-01-15 at 17:47 +0800, roel kluin wrote:
>
> > > +       kernel_fpu_begin();
> > > +       while ((nbytes = walk.nbytes)) {
> > > +               aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
> > > +                             nbytes & AES_BLOCK_MASK);
> > > +               nbytes &= AES_BLOCK_SIZE - 1;
> > > +               err = blkcipher_walk_done(desc, &walk, nbytes);
> > > +       }
> > > +       kernel_fpu_end();
> > > +
> > > +       return err;
> > > +}
> > 
> > if blkcipher_walk_{virt,done} returns an error, don't we have to break
> > out of the loop?
> > i.e.
> > 
> > while (!err && (nbytes = walk.nbytes))
> > 
> > (if that's erroneous, it occurs in other places as well)

That's not necessary because blkcipher_walk_done will ensure
that walk.nbytes == 0 if there is an error.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
