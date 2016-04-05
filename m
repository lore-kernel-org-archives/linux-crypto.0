From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Asymmetric ciphers: counter measures
Date: Tue, 5 Apr 2016 19:43:37 +0800
Message-ID: <20160405114337.GC11852@gondor.apana.org.au>
References: <1710408.OFMoxk9pvo@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41700 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbcDELnr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 07:43:47 -0400
Content-Disposition: inline
In-Reply-To: <1710408.OFMoxk9pvo@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 24, 2016 at 12:27:03PM +0100, Stephan Mueller wrote:
> 
> Currently RSA does not implement anything and is even susceptible to timing 
> attacks if I see that right as the leading zeros are stripped. In addition to 

We should certainly fix this by not stripping the zeroes.

> the leading zeroes problem, blinding comes to mind. If we do blinding, what 
> type of blinding is sufficient for a fallback (base, exponent, modulus)?

It's not just a fallback.  If we ever export this to user-space this
may become a primary implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
