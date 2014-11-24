From: James Hartley <James.Hartley@imgtec.com>
Subject: RE: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Mon, 24 Nov 2014 17:22:10 +0000
Message-ID: <72BC0C8BD7BB6F45988A99382E5FBAE54434BE34@hhmail02.hh.imgtec.org>
References: <1416343727-2178-1-git-send-email-james.hartley@imgtec.com>
 <1416343727-2178-2-git-send-email-james.hartley@imgtec.com>
 <20141120142210.GA31745@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	"abrestic@chromium.org" <abrestic@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:35890 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXRWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 12:22:14 -0500
In-Reply-To: <20141120142210.GA31745@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,  thanks for the review.

> -----Original Message-----
> From: devicetree-owner@vger.kernel.org [mailto:devicetree-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: 20 November 2014 14:22
> To: James Hartley
> Cc: davem@davemloft.net; grant.likely@linaro.org; robh+dt@kernel.org;
> gregkh@linuxfoundation.org; linux-crypto@vger.kernel.org;
> devicetree@vger.kernel.org; pawel.moll@arm.com;
> mark.rutland@arm.com; ijc+devicetree@hellion.org.uk;
> galak@codeaurora.org; Ezequiel Garcia; abrestic@chromium.org
> Subject: Re: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash
> accelerator
> 
> On Tue, Nov 18, 2014 at 08:48:46PM +0000, James Hartley wrote:
> >
> > +struct img_hash_request_ctx {
> > +	struct img_hash_dev	*hdev;
> > +	u8 digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
> > +	unsigned long		flags;
> > +	size_t			digsize;
> > +
> > +	dma_addr_t		dma_addr;
> > +	size_t			dma_ct;
> > +
> > +	/* sg root */
> > +	struct scatterlist	*sgfirst;
> > +	/* walk state */
> > +	struct scatterlist	*sg;
> > +	size_t			nents;
> > +	size_t			offset;
> > +	unsigned int		total;
> > +	size_t			sent;
> > +
> > +	unsigned long		op;
> > +
> > +	size_t			bufcnt;
> > +	u8 buffer[0] __aligned(sizeof(u32)); };
> 
> Unfortunately this is not consistent with our API since you're not storing the
> non-final hash state in the request context.
> 
> It appears that you're finalising every request.  That means you can only
> implement finup and digest.  With finup you'll also need to be able to import
> a non-final hash state.  If the hardware cannot do that then you can only
> implement digest.
> 
> Everything else would have to be done by a fallback driver.
> 
> So the question is can you obtain the non-final hash state from the hardware
> and then reinsert it for the next operation?

I've looked into this and unfortunately the hardware cannot do that.  I'll spend some
time looking into what this means (I'm not the author of the driver, so will need to 
become a bit more familiar with it). 

> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

Thanks,
James.
