From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3 v2] crypto: caam - fix possible deadlock condition
Date: Thu, 9 Aug 2012 19:00:14 -0500
Message-ID: <20120809190014.336b166aa62b608d23896ae0@freescale.com>
References: <20120713174915.645ffcc5c30160d69a5adc16@freescale.com>
	<20120713180423.25043873b8fc99f7cb2d843b@freescale.com>
	<20120730075603.GD5515@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:16127
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041Ab2HJACZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Aug 2012 20:02:25 -0400
In-Reply-To: <20120730075603.GD5515@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 30 Jul 2012 15:56:04 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jul 13, 2012 at 06:04:23PM -0500, Kim Phillips wrote:
> > commit "crypto: caam - use non-irq versions of spinlocks for job rings"
> > made two bad assumptions:
> > 
> > (a) The caam_jr_enqueue lock isn't used in softirq context.
> > Not true: jr_enqueue can be interrupted by an incoming net
> > interrupt and the received packet may be sent for encryption,
> > via caam_jr_enqueue in softirq context, thereby inducing a
> > deadlock.
> > 
> > This is evidenced when running netperf over an IPSec tunnel
> > between two P4080's, with spinlock debugging turned on:
> 
> All patches applied.  Thanks Kim.

Herbert, just wanted to make sure that at least the first patch in
this series were also applied to the crypto tree, i.e., for 3.6
release because it fixes a potential deadlock condition.  The second
patch should, too, but it's less important IMO.

These are the commits to cherry pick from cryptodev into crypto:

4a90507 crypto: caam - fix possible deadlock condition
95bcaa3 crypto: caam - add backward compatible string sec4.0 (optional)

The third is this one:

61bb86b crypto: caam - set descriptor sharing type to SERIAL

which technically is a performance improvement, and I'm ok with
leaving it out of v3.6.

Sorry for not making that clear from the start; sometimes it's tough
to tell what will make it into cryptodev prior to the merge window
opening (or rather as that time approaches).

Thanks,

Kim
