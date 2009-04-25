From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 0/4] Parallel IPsec
Date: Sat, 25 Apr 2009 17:21:42 +0800
Message-ID: <20090425092142.GA5830@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090425083849.GD26070@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58301 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753130AbZDYJWA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2009 05:22:00 -0400
Content-Disposition: inline
In-Reply-To: <20090425083849.GD26070@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 25, 2009 at 12:38:49PM +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Fri, Apr 24, 2009 at 12:24:51PM +0200, Steffen Klassert (steffen.klassert@secunet.com) wrote:
> > This patchset adds the 'pcrypt' parallel crypto template. With this template it
> > is possible to process the crypto requests of a transform in parallel without
> > getting request reorder. This is in particular interesting for IPsec.
> 
> Why can't it be used by default for all crypto operations instead of
> synchronous one?

PCI-based drivers will not benefit from spreading the requests
across CPUs.  If anything they will suffer from the synchronisation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
