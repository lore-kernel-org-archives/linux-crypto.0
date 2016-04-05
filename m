From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: af_alg - add TLS type encryption
Date: Tue, 5 Apr 2016 19:29:40 +0800
Message-ID: <20160405112940.GB11852@gondor.apana.org.au>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48173 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbcDEL3r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 07:29:47 -0400
Content-Disposition: inline
In-Reply-To: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:20:44PM -0800, Tadeusz Struk wrote:
> Hi,
> The following series adds TLS type authentication. To do this a new
> template, encauth, is introduced. It is derived from the existing authenc
> template and modified to work in "first auth then encrypt" mode.
> The algif interface is also changed to work with the new authentication type.

What is the point of this patch-set? Who is going to be the user?

Also you're including padding into the algorithm.  That goes against
the way we implemented IPsec.  What is the justification for doing
it in the crypto layer instead of the protocol layer?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
