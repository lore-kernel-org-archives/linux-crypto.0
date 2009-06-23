From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] tcrypt: Test algorithms by name
Date: Tue, 23 Jun 2009 08:04:36 +0200
Message-ID: <20090623060436.GZ20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071246.GW20366@secunet.com> <20090619105325.GA17647@gondor.apana.org.au> <20090619105627.GA17781@gondor.apana.org.au> <20090619114058.GY20366@secunet.com> <20090619114737.GC17647@gondor.apana.org.au> <20090619123815.GA18826@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37634 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZFWGCC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 02:02:02 -0400
Content-Disposition: inline
In-Reply-To: <20090619123815.GA18826@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:38:15PM +0800, Herbert Xu wrote:
> > 
> > That was quick :)
> > 
> > Patch applied.  Thanks a lot Steffen!
> 
> BTW, I added this on top so that modprobe doesn't complain about
> the return code:
> 

Ugh, I was a bit too quick. Thanks for fixing this up!
