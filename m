From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
	wrapper
Date: Fri, 30 Oct 2009 14:27:34 +0100
Message-ID: <20091030132734.GS15653@secunet.com>
References: <20091008072537.GG15653@secunet.com> <20091008072818.GI15653@secunet.com> <20091008.231833.107456737.davem@davemloft.net> <20091030100609.GR15653@secunet.com> <20091030125818.GA6379@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:59010 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213AbZJ3N1l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2009 09:27:41 -0400
Content-Disposition: inline
In-Reply-To: <20091030125818.GA6379@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2009 at 08:58:18AM -0400, Herbert Xu wrote:
> 
> Since this is all happening through a crypto completion call,
> it needs to be done with BH off since that's a requirement for
> crypto completion functions.  So netif_rx will work correctly
> as when BH is reenabled it'll pick up the packets.

Ok, if it's required that BHs are off then everything is fine.
In fact I solved this problem for pcrypt by switching off the BHs.
I just was not sure whether this is the right way to do.

Thanks for clarification!

I'm going to send a workqueue based version of padata/pcrypt
within the next week.
