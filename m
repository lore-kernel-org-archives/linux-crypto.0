From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Update for 2.6.23
Date: Sun, 15 Jul 2007 17:35:29 -0700 (PDT)
Message-ID: <20070715.173529.96681471.davem@davemloft.net>
References: <20070711130849.GA10494@gondor.apana.org.au>
	<20070714.234839.34761809.davem@davemloft.net>
	<20070715131557.GA21255@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764634AbXGPAfj@vger.kernel.org>
In-Reply-To: <20070715131557.GA21255@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 15 Jul 2007 21:15:57 +0800

> On Sat, Jul 14, 2007 at 11:48:39PM -0700, David Miller wrote:
> > Herbert can you contact the async_tx author to make sure that
> > his crypto/ bits go through you in the future so that conflicts
> > like this can be avoided?
> 
> No problems.  This was a once-off because it involved multiple
> conflicts all over the place as Andrew can no doubt attest to :)

I kind of figured as much since it had dependencies on other
subsystems.
