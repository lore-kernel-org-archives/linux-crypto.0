From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
Date: Wed, 11 May 2016 07:41:31 +0000
Message-ID: <VI1PR04MB1311A94658FE756E27429557B8720@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <20160503073957.GA16836@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0055.outbound.protection.outlook.com ([157.55.234.55]:30240
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbcEKKQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 06:16:44 -0400
In-Reply-To: <20160503073957.GA16836@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> On Fri, Apr 29, 2016 at 03:51:46PM +0300, Tudor Ambarus wrote:
> >
> >  struct rsa_key {
> > +	u8 *n;
> > +	u8 *e;
> > +	u8 *d;
> > +	dma_addr_t dma_n;
> > +	dma_addr_t dma_e;
> > +	dma_addr_t dma_d;
> > +	size_t n_sz;
> > +	size_t e_sz;
> > +	bool coherent;
> > +	gfp_t flags;
> 
> Please don't put the DMA primitives in the generic helper.  They
> should stay in the driver for now.

If I move the DMA primitives to the driver context,
I can't assure software coherency enforcement in rsa helper.

If so, after the ANS.1 parsing, if a driver needs to enforce software
coherency, it will have to allocate coherent memory and copy
the ANS.1 parsed data there. Is this acceptable?

Thanks,
ta
