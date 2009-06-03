From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 14:14:35 +0200
Message-ID: <20090603121435.GN20366@secunet.com>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:53322 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZFCMMK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 08:12:10 -0400
Content-Disposition: inline
In-Reply-To: <20090603115931.GA13361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 09:59:31PM +1000, Herbert Xu wrote:
> 
> When pcrypt instantiates an algorithm, it should set cra_name to
> %s and cra_driver_name to pcrypt(%s).  So as long as the pcrypt
> priority is higher than the underlying algorithm, it should all
> work.
> 
> See for instance how cryptd does it.
> 

Aha, ok I see. So I will see whether I can instantiate pcrypt
with tcrypt as you suggested and drop the wrapper from the next
patchset.

Thanks!
