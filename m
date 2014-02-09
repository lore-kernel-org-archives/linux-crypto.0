From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: Fix the pointer voodoo in unaligned ahash
Date: Sun, 9 Feb 2014 09:18:56 +0800
Message-ID: <20140209011856.GB16905@gondor.apana.org.au>
References: <1389720829-5963-1-git-send-email-marex@denx.de>
 <1389720829-5963-2-git-send-email-marex@denx.de>
 <1755989.ess5rJDo4G@tlendack-t1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marex@denx.de>, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34555 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaBIBTQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Feb 2014 20:19:16 -0500
Content-Disposition: inline
In-Reply-To: <1755989.ess5rJDo4G@tlendack-t1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 14, 2014 at 01:35:50PM -0600, Tom Lendacky wrote:
> 
> On Tuesday, January 14, 2014 06:33:47 PM Marek Vasut wrote:
> > Add documentation for the pointer voodoo that is happening in crypto/ahash.c
> > in ahash_op_unaligned(). This code is quite confusing, so add a beefy chunk
> > of documentation.
> > 
> > Moreover, make sure the mangled request is completely restored after finishing
> > this unaligned operation. This means restoring all of .result, .priv, .base.data
> > and .base.complete .
> > 
> > Also, remove the crypto_completion_t complete = ... line present in the
> > ahash_op_unaligned_done() function. This type actually declares a function
> > pointer, which is very confusing.
> > 
> > Finally, yet very important nonetheless, make sure the req->priv is free()'d
> > only after the original request is restored in ahash_op_unaligned_done().
> > The req->priv data must not be free()'d before that in ahash_op_unaligned_finish(),
> > since we would be accessing previously free()'d data in ahash_op_unaligned_done()
> > and cause corruption.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >  crypto/ahash.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 54 insertions(+), 11 deletions(-)
> > 
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index a92dc38..5ca8ede 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -29,6 +29,7 @@
> >  struct ahash_request_priv {
> >  	crypto_completion_t complete;
> >  	void *data;
> > +	void *priv;
> >  	u8 *result;
> >  	void *ubuf[] CRYPTO_MINALIGN_ATTR;
> >  };
> > @@ -200,23 +201,38 @@ static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
> >  	if (!err)
> >  		memcpy(priv->result, req->result,
> >  		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
> > -
> > -	kzfree(priv);
> 
> You can't move/remove this kzfree since a synchronous operation will not take
> the ahash_op_unaligned_done path.  A synchronous operation will never return
> -EINPROGRESS and the effect will be to never free the priv structure.

Marek, did you have a chance to address this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
