From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3 v2] crypto: caam - fix possible deadlock condition
Date: Mon, 30 Jul 2012 15:56:04 +0800
Message-ID: <20120730075603.GD5515@gondor.apana.org.au>
References: <20120713174915.645ffcc5c30160d69a5adc16@freescale.com>
 <20120713180423.25043873b8fc99f7cb2d843b@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59482 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712Ab2G3H4G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 03:56:06 -0400
Content-Disposition: inline
In-Reply-To: <20120713180423.25043873b8fc99f7cb2d843b@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 13, 2012 at 06:04:23PM -0500, Kim Phillips wrote:
> commit "crypto: caam - use non-irq versions of spinlocks for job rings"
> made two bad assumptions:
> 
> (a) The caam_jr_enqueue lock isn't used in softirq context.
> Not true: jr_enqueue can be interrupted by an incoming net
> interrupt and the received packet may be sent for encryption,
> via caam_jr_enqueue in softirq context, thereby inducing a
> deadlock.
> 
> This is evidenced when running netperf over an IPSec tunnel
> between two P4080's, with spinlock debugging turned on:

All patches applied.  Thanks Kim.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
