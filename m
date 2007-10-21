From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 2/5] [crypto] geode: relax in busy loop and care about return value
Date: Sun, 21 Oct 2007 16:14:52 +0800
Message-ID: <20071021081452.GB9397@gondor.apana.org.au>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-3-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1541 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888AbXJUIOz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2007 04:14:55 -0400
Content-Disposition: inline
In-Reply-To: <1192788233-14968-3-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 19, 2007 at 12:03:50PM +0200, Sebastian Siewior wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> The code waits in a busy loop until the hardware finishes the encryption
> or decryption process. This wants a cpu_relax() :)
> The busy loop finishes either if the encryption is done or if the counter
> is zero. If the latter is true than the hardware failed. Since this
> should not happen, leave sith a BUG().
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Applied.

I'd like to see the error propagated up though.  We'd need
to change the simple cipher interface to allow errors to be
returned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
