From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: drbg: use memzero_explicit() for clearing
 sensitive data
Date: Thu, 27 Nov 2014 22:33:02 +0800
Message-ID: <20141127143302.GB25101@gondor.apana.org.au>
References: <20141126184057.GA8235@nick-ThinkPad-T430s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49905 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK0OdH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Nov 2014 09:33:07 -0500
Content-Disposition: inline
In-Reply-To: <20141126184057.GA8235@nick-ThinkPad-T430s>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 26, 2014 at 01:40:57PM -0500, Nickolaus Woodruff wrote:
> Compiler dead store optimization can sometimes remove final calls
> to memset() used to clear sensitive data at the end of a function.
> Replace trailing memset() calls with memzero_explicit() to
> preclude unwanted removal.
> 
> Signed-off-by: Nickolaus Woodruff <nickolauswoodruff@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
