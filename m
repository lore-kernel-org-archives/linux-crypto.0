From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3 v2] crypto: caam - fix possible deadlock condition
Date: Mon, 20 Aug 2012 16:30:53 +0800
Message-ID: <20120820083053.GA22914@gondor.apana.org.au>
References: <20120713174915.645ffcc5c30160d69a5adc16@freescale.com>
 <20120713180423.25043873b8fc99f7cb2d843b@freescale.com>
 <20120730075603.GD5515@gondor.apana.org.au>
 <20120809190014.336b166aa62b608d23896ae0@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40164 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755823Ab2HTIaz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:30:55 -0400
Content-Disposition: inline
In-Reply-To: <20120809190014.336b166aa62b608d23896ae0@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 09, 2012 at 07:00:14PM -0500, Kim Phillips wrote:
> On Mon, 30 Jul 2012 15:56:04 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Fri, Jul 13, 2012 at 06:04:23PM -0500, Kim Phillips wrote:
> > > commit "crypto: caam - use non-irq versions of spinlocks for job rings"
> > > made two bad assumptions:
> > > 
> > > (a) The caam_jr_enqueue lock isn't used in softirq context.
> > > Not true: jr_enqueue can be interrupted by an incoming net
> > > interrupt and the received packet may be sent for encryption,
> > > via caam_jr_enqueue in softirq context, thereby inducing a
> > > deadlock.
> > > 
> > > This is evidenced when running netperf over an IPSec tunnel
> > > between two P4080's, with spinlock debugging turned on:
> > 
> > All patches applied.  Thanks Kim.
> 
> Herbert, just wanted to make sure that at least the first patch in
> this series were also applied to the crypto tree, i.e., for 3.6
> release because it fixes a potential deadlock condition.  The second
> patch should, too, but it's less important IMO.
> 
> These are the commits to cherry pick from cryptodev into crypto:
> 
> 4a90507 crypto: caam - fix possible deadlock condition
> 95bcaa3 crypto: caam - add backward compatible string sec4.0 (optional)

OK, I'll add these two patches to crypto-2.6.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
