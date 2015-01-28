From: James Hartley <james.hartley@imgtec.com>
Subject: Re: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Wed, 28 Jan 2015 00:29:29 +0000
Message-ID: <54C82D69.9070200@imgtec.com>
References: <54C826EC.8050103@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: James Hartley <james.hartley@imgtec.com>,
	<herbert@gondor.apana.org.au>,
	Andrew Bresticker <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:1870 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbbA1A2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2015 19:28:45 -0500
In-Reply-To: <54C826EC.8050103@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/28/15 00:01, James Hartley wrote:
>
> > > +struct img_hash_request_ctx {
> > > +    struct img_hash_dev    *hdev;
> > > +    u8 digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
> > > +    unsigned long        flags;
> > > +    size_t            digsize;
> > > +
> > > +    dma_addr_t        dma_addr;
> > > +    size_t            dma_ct;
> > > +
> > > +    /* sg root */
> > > +    struct scatterlist    *sgfirst;
> > > +    /* walk state */
> > > +    struct scatterlist    *sg;
> > > +    size_t            nents;
> > > +    size_t            offset;
> > > +    unsigned int        total;
> > > +    size_t            sent;
> > > +
> > > +    unsigned long        op;
> > > +
> > > +    size_t            bufcnt;
> > > +    u8 buffer[0] __aligned(sizeof(u32)); };
> >
> > Unfortunately this is not consistent with our API since you're not 
> storing the
> > non-final hash state in the request context.
> >
> > It appears that you're finalising every request.  That means you can 
> only
> > implement finup and digest.  With finup you'll also need to be able 
> to import
> > a non-final hash state.  If the hardware cannot do that then you can 
> only
> > implement digest.
> >
> > Everything else would have to be done by a fallback driver.
> >
> > So the question is can you obtain the non-final hash state from the 
> hardware
> > and then reinsert it for the next operation?
>
> I've looked into this and unfortunately the hardware cannot do that.  
> I'll spend some
> time looking into what this means (I'm not the author of the driver, 
> so will need to
> become a bit more familiar with it).
>
Hi Herbert,

Firstly apologies that there have been quite a few weeks since we last 
discussed this driver!

I understand that because the HW does not support an initial hash state, 
I can only implement digest, and not init, update and final. You 
mentioned that I would have to do everything else using a fallback 
driver - but I'm not clear on:

- If it is mandatory to impement a fallback driver (because the 
potential users of the framework would not know only digest is supported?)
- or can I just remove the support for init update and final?

If I need to implement fallback drivers, would the Niagra2 SPU driver be 
a good reference 
http://lxr.free-electrons.com/source/drivers/crypto/n2_core.c ?

Thanks,
James
