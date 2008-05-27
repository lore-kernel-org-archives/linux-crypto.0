From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Tue, 27 May 2008 04:37:08 -0700 (PDT)
Message-ID: <20080527.043708.50978984.davem@davemloft.net>
References: <20080517095625.GA17878@gondor.apana.org.au>
	<20080520.194723.268247612.davem@davemloft.net>
	<20080526110508.GB14743@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@ml.breakpoint.cc, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57432
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbYE0LhM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 07:37:12 -0400
In-Reply-To: <20080526110508.GB14743@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 26 May 2008 21:05:08 +1000

> On Tue, May 20, 2008 at 07:47:23PM -0700, David Miller wrote:
> 
> > -------------------- before patch --------------------
> > 
> > [452862.338505] testing speed of rmd128
> > [452862.354441] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   6064 cycles/operation,  379 cycles/byte
> 
> > -------------------- after patch --------------------
> > 
> > [453226.216294] testing speed of rmd128
> > [453226.216322] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2784 cycles/operation,  174 cycles/byte
> 
> Looks good Dave! I've done the same thing for the other rmd* files
> and for the store on the result.  Let me know if this looks OK and
> I'll commit.

Looks ok to me, thanks!
