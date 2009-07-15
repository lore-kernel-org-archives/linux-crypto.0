From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 12/35] crypto: padlock - Switch sha to shash
Date: Wed, 15 Jul 2009 12:36:46 +0200
Message-ID: <20090715103646.GN20288@secunet.com>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au> <20090715102818.GM20288@secunet.com> <20090715103025.GA21263@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:44824 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZGOKeH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 06:34:07 -0400
Content-Disposition: inline
In-Reply-To: <20090715103025.GA21263@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 06:30:25PM +0800, Herbert Xu wrote:
> On Wed, Jul 15, 2009 at 12:28:18PM +0200, Steffen Klassert wrote:
> >
> > Just FYI, I'm getting the following compiler error:
> 
> Is this 32-bit or 64-bit?
> 

It's 32-bit.
One of my test systems had padlock enabled by chance.
