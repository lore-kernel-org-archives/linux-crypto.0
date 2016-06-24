From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 0/5] crypto: Fix IPsec reordering caused by cryptd
Date: Fri, 24 Jun 2016 10:29:34 +0200
Message-ID: <20160624082934.GR7698@gauss.secunet.com>
References: <20160621085321.GA21044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Raj Ammanur <rammanur@arista.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:54502 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbcFXI3i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 04:29:38 -0400
Content-Disposition: inline
In-Reply-To: <20160621085321.GA21044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 21, 2016 at 04:53:21PM +0800, Herbert Xu wrote:
> Hi:
> 
> I finally got around to working on this.  I quickly gave up on the
> notion of hijacking the queued requests as we may end up overwhelming
> our caller.
> 
> So the solution is the obvious one of using cryptd as long as there
> are requests queued there belonging to the same tfm.  This is
> totally untested so please tread carefully.

Thanks for the patches!
I've tested them today and observed no problems with it,
so looks good :)
