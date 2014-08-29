From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH 2/2] crypto: sahara - add support for SHA1/256
Date: Fri, 29 Aug 2014 15:58:55 +0200
Message-ID: <20140829135855.GA13580@pengutronix.de>
References: <1408367619-3436-1-git-send-email-s.trumtrar@pengutronix.de>
 <1408367619-3436-2-git-send-email-s.trumtrar@pengutronix.de>
 <20140829134442.GA9971@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35333 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaH2N7I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2014 09:59:08 -0400
Content-Disposition: inline
In-Reply-To: <20140829134442.GA9971@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Fri, Aug 29, 2014 at 09:44:42PM +0800, Herbert Xu wrote:
> On Mon, Aug 18, 2014 at 03:13:39PM +0200, Steffen Trumtrar wrote:
> >
> > +struct sahara_sha_reqctx {
> > +	unsigned int mode;
> > +	unsigned int digest_size;
> > +	unsigned int context_size;
> > +	u8 buf[SAHARA_MAX_SHA_BLOCK_SIZE];
> > +	unsigned int buf_cnt;
> > +	unsigned int hash_rem;
> > +	struct sg_table data_sg;
> > +	struct scatterlist buf_sg;
> > +	unsigned int sg_in_idx;
> > +	unsigned int result_idx;
> > +};
> 
> So where is the hash state stored?
> 

The hash state is stored in the context_base variable in sahara_dev.
Freescale calls it context in their driver (the only source of information
I have to develop a GPL driver).
To simplify the driver I allocated the context also as dma_alloc_coherent,
same as the key_base for AES.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
