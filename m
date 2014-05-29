From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Date: Thu, 29 May 2014 20:35:41 +0800
Message-ID: <20140529123541.GA2198@gondor.apana.org.au>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140527173050.GA18214@gondor.apana.org.au>
 <1401298880.3645.16.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43641 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbaE2Nou (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 May 2014 09:44:50 -0400
Content-Disposition: inline
In-Reply-To: <1401298880.3645.16.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 28, 2014 at 10:41:20AM -0700, Eric Dumazet wrote:
> On Wed, 2014-05-28 at 01:30 +0800, Herbert Xu wrote:
> 
> > Looks good to me.  This would seem like something that could be
> > generalised to other vmalloc users, no?
> 
> BTW, any objections if I send patches to add NUMA allocations into
> crypto layer, or was it already considered ?

No please go ahead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
