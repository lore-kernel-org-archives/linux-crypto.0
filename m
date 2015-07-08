From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: akcipher: continuous memory for input/output
Date: Wed, 8 Jul 2015 23:29:32 +0800
Message-ID: <20150708152932.GA23750@gondor.apana.org.au>
References: <4018710.nx8zEmrfD4@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58837 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724AbbGHP3j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 11:29:39 -0400
Content-Disposition: inline
In-Reply-To: <4018710.nx8zEmrfD4@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 08, 2015 at 05:27:15PM +0200, Stephan Mueller wrote:
> 
> But according to Tadeusz it may be viable to register hybrid asym ciphers with 
> the akcipher API. If there is a full blown hybrid asym cipher we have to 
> handle potentially large chunks of data. I am now wondering whether a flat 
> buffer still makes sense or whether the akcipher should be converted to 
> scatter lists as all the other cipher types.
> 
> If it shall stay as is, how would we be handling larger buffers?

What is a hybrid cipher and why would we want to have it in the
kernel?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
