From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Tue, 20 Jan 2015 15:03:56 +1100
Message-ID: <20150120040356.GA11419@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
 <1490816.1NddvTAE2F@tauon>
 <20150120033704.GB10814@gondor.apana.org.au>
 <2151453.hYZ6xmSv8n@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40642 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbATEEH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 23:04:07 -0500
Content-Disposition: inline
In-Reply-To: <2151453.hYZ6xmSv8n@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 20, 2015 at 04:54:44AM +0100, Stephan Mueller wrote:
>
> How would the fail manifest itself? If algif_aead would be present, user 
> space could use the __driver implementation regardless of a setkey or 
> authsize callback by simply calling encrypt/decrypt. Would the error be 
> limited to that caller only?

For user-space it'll never fail.  However, for kernel users such
as IPsec it'll fail if the interrupt occurs while in a thread
that's already using the FPU.

But you're right, we probably shouldn't allow these algorithms to
be directly exported to user-space at all, even when they do possess
a setkey function.  In fact, we should ban them from other places
where they might be used too, such as through IPsec.

I'll try to write something up to do this

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
