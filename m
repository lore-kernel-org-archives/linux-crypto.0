From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: drbg: use memzero_explicit() for clearing
 sensitive data
Date: Mon, 5 Jan 2015 10:45:29 +1100
Message-ID: <20150104234529.GA20989@gondor.apana.org.au>
References: <20141126184057.GA8235@nick-ThinkPad-T430s>
 <20141127143302.GB25101@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55650 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbbADXpe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Jan 2015 18:45:34 -0500
Content-Disposition: inline
In-Reply-To: <20141127143302.GB25101@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 27, 2014 at 10:33:02PM +0800, Herbert Xu wrote:
> On Wed, Nov 26, 2014 at 01:40:57PM -0500, Nickolaus Woodruff wrote:
> > Compiler dead store optimization can sometimes remove final calls
> > to memset() used to clear sensitive data at the end of a function.
> > Replace trailing memset() calls with memzero_explicit() to
> > preclude unwanted removal.
> > 
> > Signed-off-by: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
> 
> Patch applied.  Thanks!

Actually I'm reverting this because the patch was bogus.  None
of the data zeroed are on the stack.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
