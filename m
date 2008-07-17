From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] prng: fix a few misc bugs in prng
Date: Thu, 17 Jul 2008 07:02:00 -0400
Message-ID: <20080717110200.GB17892@hmsendeavour.rdu.redhat.com>
References: <20080716202916.GA1648@hmsreliant.think-freely.org> <20080717074615.GA23621@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2483 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYGQLCL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 07:02:11 -0400
Content-Disposition: inline
In-Reply-To: <20080717074615.GA23621@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2008 at 03:46:15PM +0800, Herbert Xu wrote:
> On Wed, Jul 16, 2008 at 04:29:16PM -0400, Neil Horman wrote:
> > 
> >  Fixing a few misc bugs in prng.c:
> >  - Remove prng_key/prng_iv from prng_context (both kept in tfm ptr)
> >  - Making _get_more_prng_bytes return meaningful err codes (not just -1/0)
> >     
> >  Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Applied to cryptodev-2.6.
> 
Thank you!

> > @@ -369,8 +362,7 @@ int reset_prng_context(struct prng_context *ctx,
> >  
> >  	ctx->rand_data_valid = DEFAULT_BLK_SZ;
> >  
> > -	ret = crypto_blkcipher_setkey(ctx->tfm, ctx->prng_key,
> > -					strlen(ctx->prng_key));
> > +	ret = crypto_blkcipher_setkey(ctx->tfm, prng_key, strlen(prng_key));
> 
> Please make the length a parameter instead as it's much more
> convenient to use a blob as a key rather than a string.
> 
Copy that, I'll send a patch shortly.

> > diff --git a/firmware/Makefile b/firmware/Makefile
> > index 809a526..3515814 100644
> > --- a/firmware/Makefile
> > +++ b/firmware/Makefile
> > @@ -34,8 +34,8 @@ fw-shipped-$(CONFIG_SND_SB16_CSP) += sb16/mulaw_main.csp sb16/alaw_main.csp \
> >  				     sb16/ima_adpcm_capture.csp
> >  fw-shipped-$(CONFIG_SND_YMFPCI) += yamaha/ds1_ctrl.fw yamaha/ds1_dsp.fw \
> >  				   yamaha/ds1e_ctrl.fw
> > -fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
> > -			       tigon/tg3_tso5.bin
> > +#fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
> > +#			       tigon/tg3_tso5.bin
> >  fw-shipped-$(CONFIG_USB_DABUSB) += dabusb/firmware.fw dabusb/bitstream.bin
> >  fw-shipped-$(CONFIG_USB_EMI26) += emi26/loader.fw emi26/firmware.fw \
> >  				  emi26/bitstream.fw
> 
> The dreaded firmware makes a comeback :)
> 
Doh!  Ment to remove that!  My bad :)
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
