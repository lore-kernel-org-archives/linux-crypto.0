From: Stafford Horne <shorne@gmail.com>
Subject: Re: [RFC PATCH 1/2] crypto: Fix -Wstringop-truncation warnings
Date: Sat, 23 Jun 2018 15:46:48 +0900
Message-ID: <20180623064648.GH24595@lianli.shorne-pla.net>
References: <20180623020753.27266-1-shorne@gmail.com>
 <20180623020753.27266-2-shorne@gmail.com>
 <20180623024149.GB880@sol.localdomain>
 <20180623025256.GG24595@lianli.shorne-pla.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <nick.desaulniers@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180623025256.GG24595@lianli.shorne-pla.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 23, 2018 at 11:52:56AM +0900, Stafford Horne wrote:
> On Fri, Jun 22, 2018 at 07:41:49PM -0700, Eric Biggers wrote:
> > On Sat, Jun 23, 2018 at 11:07:52AM +0900, Stafford Horne wrote:
> > > As of GCC 9.0.0 the build is reporting warnings like:
> > > 
[...]
> > >  	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
> > >  	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
> > > -		sizeof(rblkcipher.geniv));
> > > +		sizeof(rblkcipher.geniv) - 1);
> > >  
> > >  	rblkcipher.blocksize = alg->cra_blocksize;
> > >  	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
> > 
> > Your "fix" introduces an information disclosure bug, as it results in
> > uninitialized memory being copied to userspace.  This same broken patch was sent
> > by someone else too.
> > 
> > Maybe it would be best to just memset() the crypto_report_* structs to 0 after
> > declaration and then replace the strncpy()'s with strscpy()'s, even if just to
> > stop people from sending broken "fixes".  Do you want to do that?
> 
> Right, I didnt realize that we were using strncpy to also init the whole buffer.
> 
> I will do as suggest, and respin.

Hi Eric,

I thought about this a bit, doing memset() and strscpy() seemed fine, but the
below also would work, be a bit faster and stop gcc form complaining.  What do
you think?

@@ -512,6 +512,7 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
        strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
        strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
                sizeof(rblkcipher.geniv));
+       rblkcipher.geniv[sizeof(rblkcipher.geniv) - 1] = '\0';

        rblkcipher.blocksize = alg->cra_blocksize;
        rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;

Let me know what you think.

-Stafford
