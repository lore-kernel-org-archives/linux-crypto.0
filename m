From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Alignment in the API, once again
Date: Thu, 2 Aug 2007 15:57:24 +0800
Message-ID: <20070802075724.GA12449@gondor.apana.org.au>
References: <20070801230240.GA18744@Chamillionaire.breakpoint.cc> <20070802023006.GA10180@gondor.apana.org.au> <20070802074122.GA22601@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1614 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbXHBH51 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 03:57:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGVYj-0006Qb-4H
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 17:57:25 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGVYi-0003FE-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 15:57:24 +0800
Content-Disposition: inline
In-Reply-To: <20070802074122.GA22601@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 09:41:22AM +0200, Sebastian Siewior wrote:
> 
> Okey this makes sense. What about crypto_ctxsize()? Isn't a bug there?
> I can't specify an alignmask of 16 (what I assumed yesterday after a
> part of brain switched to sleep()) because this brakes the ALIGN()
> macro. Isn't something like

15 & ~7 == 8

is sufficient to guarantee 16-byte alignment.  Remember that
the ctx member is already 8-byte aligned.  So we only need
to add a maximum of 8 extra bytes to get it 16-byte aligned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
