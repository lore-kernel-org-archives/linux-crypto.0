From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Mon, 30 Mar 2009 16:49:56 +0200
Message-ID: <20090330144956.GA32550@secunet.com>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com> <20090327083615.GB27903@gondor.apana.org.au> <20090330115415.GC6791@secunet.com> <20090330131955.GA22604@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:40182 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbZC3OsM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2009 10:48:12 -0400
Content-Disposition: inline
In-Reply-To: <20090330131955.GA22604@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 30, 2009 at 09:19:55PM +0800, Herbert Xu wrote:
> 
> How about using eseqiv? It's designed for exactly this situation
> where you want parallel async processing.  Its overhead is just
> one extra encryption block.
> 

Yes, that's an option too. I'll give it a try.

Thanks!
