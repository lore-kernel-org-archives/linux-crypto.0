From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: caam - Clamp AEAD SG list by input length
Date: Mon, 8 Jun 2015 21:53:25 +0800
Message-ID: <20150608135325.GA31073@gondor.apana.org.au>
References: <20150608083824.GA26193@gondor.apana.org.au>
 <55759CA6.8070108@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36859 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbbFHNxa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 09:53:30 -0400
Content-Disposition: inline
In-Reply-To: <55759CA6.8070108@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2015 at 06:46:14AM -0700, Tadeusz Struk wrote:
> On 06/08/2015 01:38 AM, Herbert Xu wrote:
> > +static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
> > +	struct scatterlist *sg, unsigned int total,
> > +	struct sec4_sg_entry *sec4_sg_ptr)
> > +{
> > +	do {
> > +		unsigned int len = min(sg_dma_len(sg), total);
> > +
> > +		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg), len, 0);
> > +		sec4_sg_ptr++;
> > +		sg = sg_next(sg);
> > +		total -= len;
> > +	} while (total);
> > +	return sec4_sg_ptr - 1;
> > +}
> 
> Is req->assoclen guaranteed to be assoc->length aligned?

No req->assoclen can be any length.  What is the problem?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
