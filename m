From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: akcipher: continuous memory for input/output
Date: Fri, 10 Jul 2015 21:36:34 +0800
Message-ID: <20150710133634.GA17850@gondor.apana.org.au>
References: <4018710.nx8zEmrfD4@tauon.atsec.com>
 <20150708152932.GA23750@gondor.apana.org.au>
 <3241575.xDOc5hzFrC@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51199 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbbGJNgp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 09:36:45 -0400
Content-Disposition: inline
In-Reply-To: <3241575.xDOc5hzFrC@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 08, 2015 at 05:54:35PM +0200, Stephan Mueller wrote:
>
> But IIRC, there are systems out there which perform a full hybrid asym 
> operation. Without having checked in detail, I believe this is true for IBM 
> cryptoexpress or Cavium cards.

Such systems won't be using the akcipher interface even if we
decided to support them.  As akcipher is only meant to support
the underlying cipher, not the whole system.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
