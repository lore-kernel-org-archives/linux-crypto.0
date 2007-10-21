From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/5] [crypto] geode: use consistent IV copy
Date: Sun, 21 Oct 2007 16:13:46 +0800
Message-ID: <20071021081346.GA9397@gondor.apana.org.au>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-2-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1530 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbXJUINt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2007 04:13:49 -0400
Content-Disposition: inline
In-Reply-To: <1192788233-14968-2-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 19, 2007 at 12:03:49PM +0200, Sebastian Siewior wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> It is enough if the IV is copied before and after the while loop.
> With DM-Crypt is seems not be required to save the IV after encrytion
> because a new one is used in the request (dunno about other users).
> It is not save to load the IV within while loop and not save afterwards
> because we mill end up with the wrong IV if the request goes consists
> of more than one page.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Nice cleanup.  Patch applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
