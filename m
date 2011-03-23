From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - de-CHIP-ify device tree compatibles
Date: Wed, 23 Mar 2011 21:24:09 +0800
Message-ID: <20110323132409.GD4374@gondor.apana.org.au>
References: <20110315165220.d4fb60bc.kim.phillips@freescale.com> <20110316005951.GA18791@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kim Phillips <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	devicetree-discuss@lists.ozlabs.org,
	Scott Wood <scottwood@freescale.com>,
	Steve Cornelius <sec@pobox.com>,
	Kumar Gala <kumar.gala@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40375 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWNYM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2011 09:24:12 -0400
Content-Disposition: inline
In-Reply-To: <20110316005951.GA18791@angua.secretlab.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2011 at 06:59:51PM -0600, Grant Likely wrote:
> On Tue, Mar 15, 2011 at 04:52:20PM -0500, Kim Phillips wrote:
> > - all the integration parameters have been captured by the binding.
> > - the block name really uniquely identifies this hardware.
> > 
> > Some advocate putting SoC names everywhere in case software needs
> > to work around some chip-specific bug, but more precise SoC
> > information already exists in SVR, and board information already
> > exists in the top-level device tree node.
> > 
> > Note that sometimes the SoC name is a worse identifier than the
> > block version, as the block version can change between revisions
> > of the same SoC.
> > 
> > As a matter of historical reference, neither SEC versions 2.x
> > nor 3.x (driven by talitos) ever needed CHIP references.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> 
> <sigh>  Very well.  As long as some level of versioning is used on the
> compatible values, I guess I can live with it.
> 
> Acked-off-by: Grant Likely <grant.likely@secretlab.ca>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
