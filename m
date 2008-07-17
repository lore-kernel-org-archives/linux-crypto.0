From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] prng; bring prng into better alignment with specification
Date: Thu, 17 Jul 2008 07:04:05 -0400
Message-ID: <20080717110405.GC17892@hmsendeavour.rdu.redhat.com>
References: <20080716203200.GB1648@hmsreliant.think-freely.org> <20080717074856.GB23621@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758265AbYGQLE0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080717074856.GB23621@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 17, 2008 at 03:48:56PM +0800, Herbert Xu wrote:
> On Wed, Jul 16, 2008 at 04:32:00PM -0400, Neil Horman wrote:
> >  Bring prng into better alignment with specificaion:
> >     
> >  - Convert to using Generic AES 128 bit cipher
> >  - Convert DT to be a non-shifted counter, increasing counter period
> >     
> >  Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Applied to cryptodev-2.6.
> >
> > @@ -325,17 +306,13 @@ int reset_prng_context(struct prng_context *ctx,
> >  		       unsigned char *V, unsigned char *DT)
> >  	int ret;
> > -	int iv_len;
> >  	int rc = -EFAULT;
> >  	unsigned char *prng_key;
> > -	unsigned char *prng_iv;
> >  	spin_lock(&ctx->prng_lock);
> >  	ctx->flags |= PRNG_NEED_RESET;
> >  
> >  	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
> >  
> > -	prng_iv = iv ? iv : (unsigned char *)DEFAULT_PRNG_IV;
> 
> We can now kill the iv parameter too.
> 
Yeah, I was trying to decide if I should remove that or not, in the event we
wanted to support alternate [blk]ciphers in the future for the cprng.  As I
think about it, I don't think its a big deal to nix.  I'll get rid of it
shortly.

Thanks
Neil

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
